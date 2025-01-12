var/global/list/uplink_locations = list("PDA", "Headset", "None")

/datum/category_item/player_setup_item/antagonism/basic
	name = "Basic"
	sort_order = 1

	var/datum/paiCandidate/candidate

/datum/category_item/player_setup_item/antagonism/basic/load_character(list/save_data)
	pref.uplinklocation = save_data["uplinklocation"]
	pref.exploit_record = save_data["exploit_record"]
	pref.antag_faction  = save_data["antag_faction"]
	pref.antag_vis      = save_data["antag_vis"]

/datum/category_item/player_setup_item/antagonism/basic/save_character(list/save_data)
	save_data["uplinklocation"] = pref.uplinklocation
	save_data["exploit_record"] = pref.exploit_record
	save_data["antag_faction"]  = pref.antag_faction
	save_data["antag_vis"]      = pref.antag_vis

/datum/category_item/player_setup_item/antagonism/basic/load_preferences(datum/json_savefile/savefile)
	if(!candidate)
		candidate = new()
	var/preference_mob = preference_mob()
	if(!preference_mob)// No preference mob - this happens when we're called from client/New() before it calls ..()  (via datum/preferences/New())
		spawn()
			preference_mob = preference_mob()
			if(!preference_mob)
				return
			candidate.savefile_load(preference_mob)
		return

	candidate.savefile_load(preference_mob)

/datum/category_item/player_setup_item/antagonism/basic/save_preferences(datum/json_savefile/savefile)
	if(!candidate)
		return

	if(!preference_mob())
		return

	candidate.savefile_save(preference_mob())

/datum/category_item/player_setup_item/antagonism/basic/sanitize_character()
	pref.uplinklocation	= sanitize_inlist(pref.uplinklocation, uplink_locations, initial(pref.uplinklocation))
	if(!pref.antag_faction) pref.antag_faction = "None"
	if(!pref.antag_vis) pref.antag_vis = "Hidden"

// Moved from /datum/preferences/proc/copy_to()
/datum/category_item/player_setup_item/antagonism/basic/copy_to_mob(var/mob/living/carbon/human/character)
	character.exploit_record = pref.exploit_record
	character.antag_faction = pref.antag_faction
	character.antag_vis = pref.antag_vis

/datum/category_item/player_setup_item/antagonism/basic/content(var/mob/user)
	. += "Faction: <a href='byond://?src=\ref[src];antagfaction=1'>[pref.antag_faction]</a><br/>"
	. += "Visibility: <a href='byond://?src=\ref[src];antagvis=1'>[pref.antag_vis]</a><br/>"
	. +=span_bold("Uplink Type : <a href='byond://?src=\ref[src];antagtask=1'>[pref.uplinklocation]</a>")
	. +="<br>"
	. +=span_bold("Exploitable information:") + "<br>"
	if(jobban_isbanned(user, "Records"))
		. += span_bold("You are banned from using character records.") + "<br>"
	else
		. +="<a href='byond://?src=\ref[src];exploitable_record=1'>[TextPreview(pref.exploit_record,40)]</a><br>"
	. += "<br>"
	. += span_bold("pAI:") + "<br>"
	if(!candidate)
		log_debug("[user] pAI prefs have a null candidate var.")
		return .
	. += "Name: <a href='byond://?src=\ref[src];option=name'>[candidate.name ? candidate.name : "None Set"]</a><br>"
	. += "Description: <a href='byond://?src=\ref[src];option=desc'>[candidate.description ? TextPreview(candidate.description, 40) : "None Set"]</a><br>"
	. += "Role: <a href='byond://?src=\ref[src];option=role'>[candidate.role ? TextPreview(candidate.role, 40) : "None Set"]</a><br>"
	. += "OOC Comments: <a href='byond://?src=\ref[src];option=ooc'>[candidate.comments ? TextPreview(candidate.comments, 40) : "None Set"]</a><br>"

/datum/category_item/player_setup_item/antagonism/basic/OnTopic(var/href,var/list/href_list, var/mob/user)
	if (href_list["antagtask"])
		pref.uplinklocation = next_in_list(pref.uplinklocation, uplink_locations)
		return TOPIC_REFRESH

	if(href_list["exploitable_record"])
		var/exploitmsg = sanitize(tgui_input_text(user,"Set exploitable information about you here.","Exploitable Information", html_decode(pref.exploit_record), MAX_RECORD_LENGTH, TRUE, prevent_enter = TRUE), MAX_RECORD_LENGTH, extra = 0)
		if(!isnull(exploitmsg) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.exploit_record = exploitmsg
			return TOPIC_REFRESH

	if(href_list["antagfaction"])
		var/choice = tgui_input_list(user, "Please choose an antagonistic faction to work for.", "Character Preference", antag_faction_choices + list("None","Other"), pref.antag_faction)
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		if(choice == "Other")
			var/raw_choice = sanitize(tgui_input_text(user, "Please enter a faction.", "Character Preference", null, MAX_NAME_LEN), MAX_NAME_LEN)
			if(raw_choice)
				pref.antag_faction = raw_choice
		else
			pref.antag_faction = choice
		return TOPIC_REFRESH

	if(href_list["antagvis"])
		var/choice = tgui_input_list(user, "Please choose an antagonistic visibility level.", "Character Preference", antag_visiblity_choices, pref.antag_vis)
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		else
			pref.antag_vis = choice
		return TOPIC_REFRESH

	if(href_list["option"])
		var/t
		switch(href_list["option"])
			if("name")
				t = sanitizeName(tgui_input_text(user, "Enter a name for your pAI", "Global Preference", candidate.name, MAX_NAME_LEN), MAX_NAME_LEN, 1)
				if(t && CanUseTopic(user))
					candidate.name = t
			if("desc")
				t = tgui_input_text(user, "Enter a description for your pAI", "Global Preference", html_decode(candidate.description), multiline = TRUE, prevent_enter = TRUE)
				if(!isnull(t) && CanUseTopic(user))
					candidate.description = sanitize(t)
			if("role")
				t = tgui_input_text(user, "Enter a role for your pAI", "Global Preference", html_decode(candidate.role))
				if(!isnull(t) && CanUseTopic(user))
					candidate.role = sanitize(t)
			if("ooc")
				t = tgui_input_text(user, "Enter any OOC comments", "Global Preference", html_decode(candidate.comments), multiline = TRUE, prevent_enter = TRUE)
				if(!isnull(t) && CanUseTopic(user))
					candidate.comments = sanitize(t)
		return TOPIC_REFRESH

	return ..()
