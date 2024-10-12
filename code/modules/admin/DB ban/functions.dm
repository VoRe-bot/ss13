
//Either pass the mob you wish to ban in the 'banned_mob' attribute, or the banckey, banip and bancid variables. If both are passed, the mob takes priority! If a mob is not passed, banckey is the minimum that needs to be passed! banip and bancid are optional.
/datum/admins/proc/DB_ban_record(var/bantype, var/mob/banned_mob, var/duration = -1, var/reason, var/job = "", var/rounds = 0, var/banckey = null, var/banip = null, var/bancid = null)

	if(!check_rights(R_MOD,0) && !check_rights(R_BAN))	return

	establish_db_connection()
	if(!SSdbcore.IsConnected()) //CHOMPEdit TGSQL
		return

	var/serverip = "[world.internet_address]:[world.port]"
	var/bantype_pass = 0
	var/bantype_str
	switch(bantype)
		if(BANTYPE_PERMA)
			bantype_str = "PERMABAN"
			duration = -1
			bantype_pass = 1
		if(BANTYPE_TEMP)
			bantype_str = "TEMPBAN"
			bantype_pass = 1
		if(BANTYPE_JOB_PERMA)
			bantype_str = "JOB_PERMABAN"
			duration = -1
			bantype_pass = 1
		if(BANTYPE_JOB_TEMP)
			bantype_str = "JOB_TEMPBAN"
			bantype_pass = 1
	if( !bantype_pass ) return
	if( !istext(reason) ) return
	if( !isnum(duration) ) return

	var/ckey
	var/computerid
	var/ip

	if(ismob(banned_mob))
		ckey = banned_mob.ckey
		if(banned_mob.client)
			computerid = banned_mob.client.computer_id
			ip = banned_mob.client.address
	else if(banckey)
		ckey = ckey(banckey)
		computerid = bancid
		ip = banip

	var/datum/db_query/query = SSdbcore.NewQuery("SELECT id FROM erro_player WHERE ckey = :t_ckey", list("t_ckey",ckey)) //CHOMPEdit TGSQL
	query.Execute()
	var/validckey = 0
	if(query.NextRow())
		validckey = 1
	qdel(query) //CHOMPEdit TGSQL
	if(!validckey)
		if(!banned_mob || (banned_mob && !IsGuestKey(banned_mob.key))) //VOREStation Edit Start.
			var/confirm = tgui_alert(usr, "This ckey hasn't been seen, are you sure?", "Confirm Badmin", list("Yes", "No"))
			if(confirm != "Yes")
				return //VOREStation Edit End

	var/a_ckey
	var/a_computerid
	var/a_ip

	if(src.owner && istype(src.owner, /client))
		a_ckey = src.owner:ckey
		a_computerid = src.owner:computer_id
		a_ip = src.owner:address

	var/who
	for(var/client/C in GLOB.clients)
		if(!who)
			who = "[C]"
		else
			who += ", [C]"

	var/adminwho
	for(var/client/C in GLOB.admins)
		if(!adminwho)
			adminwho = "[C]"
		else
			adminwho += ", [C]"

	reason = sql_sanitize_text(reason)
	var/list/sqlargs = list("t_bantype" = bantype_str, "t_reason" = reason, "t_job" = job, "t_ckey" = ckey, "t_a_ckey" = a_ckey, "t_who" = who, "t_adminwho" = adminwho) //CHOMPEdit TGSQL
	var/sql = "INSERT INTO erro_ban (`id`,`bantime`,`serverip`,`bantype`,`reason`,`job`,`duration`,`rounds`,`expiration_time`,`ckey`,`computerid`,`ip`,`a_ckey`,`a_computerid`,`a_ip`,`who`,`adminwho`,`edits`,`unbanned`,`unbanned_datetime`,`unbanned_ckey`,`unbanned_computerid`,`unbanned_ip`) VALUES (null, Now(), '[serverip]', :t_bantype, :t_reason, :t_job, [(duration)?"[duration]":"0"], [(rounds)?"[rounds]":"0"], Now() + INTERVAL [(duration>0) ? duration : 0] MINUTE, :t_ckey, '[computerid]', '[ip]', :t_a_ckey, '[a_computerid]', '[a_ip]', :t_who, :t_adminwho, '', null, null, null, null, null)" //CHOMPEdit TGSQL

	var/datum/db_query/query_insert = SSdbcore.NewQuery(sql,sqlargs) //CHOMPEdit TGSQL
	query_insert.Execute()
	to_chat(usr, span_filter_adminlog("[span_blue("Ban saved to database.")]"))
	message_admins("[key_name_admin(usr)] has added a [bantype_str] for [ckey] [(job)?"([job])":""] [(duration > 0)?"([duration] minutes)":""] with the reason: \"[reason]\" to the ban database.",1)
	qdel(query_insert) //CHOMPEdit TGSQL


/datum/admins/proc/DB_ban_unban(var/ckey, var/bantype, var/job = "")

	if(!check_rights(R_BAN))	return

	var/bantype_str
	if(bantype)
		var/bantype_pass = 0
		switch(bantype)
			if(BANTYPE_PERMA)
				bantype_str = "PERMABAN"
				bantype_pass = 1
			if(BANTYPE_TEMP)
				bantype_str = "TEMPBAN"
				bantype_pass = 1
			if(BANTYPE_JOB_PERMA)
				bantype_str = "JOB_PERMABAN"
				bantype_pass = 1
			if(BANTYPE_JOB_TEMP)
				bantype_str = "JOB_TEMPBAN"
				bantype_pass = 1
			if(BANTYPE_ANY_FULLBAN)
				bantype_str = "ANY"
				bantype_pass = 1
		if( !bantype_pass ) return

	var/bantype_sql
	if(bantype_str == "ANY")
		bantype_sql = "(bantype = 'PERMABAN' OR (bantype = 'TEMPBAN' AND expiration_time > Now() ) )"
	else
		bantype_sql = "bantype = '[bantype_str]'"

	var/sql = "SELECT id FROM erro_ban WHERE ckey = :t_ckey AND [bantype_sql] AND (unbanned is null OR unbanned = false)" //CHOMPEdit TGSQL
	if(job)
		sql += " AND job = '[job]'"

	establish_db_connection()
	if(!SSdbcore.IsConnected()) //CHOMPEdit TGSQL
		return

	var/ban_id
	var/ban_number = 0 //failsafe

	var/datum/db_query/query = SSdbcore.NewQuery(sql, list("t_ckey" = ckey)) //CHOMPEdit TGSQL
	query.Execute()
	while(query.NextRow())
		ban_id = query.item[1]
		ban_number++;
	qdel(query) //CHOMPEdit TGSQL
	if(ban_number == 0)
		to_chat(usr, span_filter_adminlog("[span_red("Database update failed due to no bans fitting the search criteria. If this is not a legacy ban you should contact the database admin.")]"))
		return

	if(ban_number > 1)
		to_chat(usr, span_filter_adminlog("[span_red("Database update failed due to multiple bans fitting the search criteria. Note down the ckey, job and current time and contact the database admin.")]"))
		return

	if(istext(ban_id))
		ban_id = text2num(ban_id)
	if(!isnum(ban_id))
		to_chat(usr, span_filter_adminlog("[span_red("Database update failed due to a ban ID mismatch. Contact the database admin.")]"))
		return

	DB_ban_unban_by_id(ban_id)

/datum/admins/proc/DB_ban_edit(var/banid = null, var/param = null)

	if(!check_rights(R_BAN))	return

	if(!isnum(banid) || !istext(param))
		to_chat(usr, "Cancelled")
		return

	var/datum/db_query/query = SSdbcore.NewQuery("SELECT ckey, duration, reason FROM erro_ban WHERE id = [banid]") //CHOMPEdit TGSQL
	query.Execute()

	var/eckey = usr.ckey	//Editing admin ckey
	var/pckey				//(banned) Player ckey
	var/duration			//Old duration
	var/reason				//Old reason

	if(query.NextRow())
		pckey = query.item[1]
		duration = query.item[2]
		reason = query.item[3]
	else
		to_chat(usr, span_filter_adminlog("Invalid ban id. Contact the database admin"))
		return
	qdel(query) //CHOMPEdit TGSQL
	reason = sql_sanitize_text(reason)
	var/value

	switch(param)
		if("reason")
			if(!value)
				value = sanitize(tgui_input_text(usr, "Insert the new reason for [pckey]'s ban", "New Reason", "[reason]", null))
				value = sql_sanitize_text(value)
				if(!value)
					to_chat(usr, "Cancelled")
					return
			var/list/sqlargs = list("t_reason" = value, "t_edits" = "- [eckey] changed ban reason from <cite><b>\\\"[reason]\\\"</b></cite> to <cite><b>\\\"[value]\\\"</b></cite><BR>") //CHOMPEdit TGSQL
			var/datum/db_query/update_query = SSdbcore.NewQuery("UPDATE erro_ban SET reason = '[value]', edits = CONCAT(edits,:t_edits) WHERE id = [banid]", sqlargs) //CHOMPEdit TGSQL
			update_query.Execute()
			message_admins("[key_name_admin(usr)] has edited a ban for [pckey]'s reason from [reason] to [value]",1)
			qdel(update_query) //CHOMPEdit TGSQL
		if("duration")
			if(!value)
				value = tgui_input_number(usr, "Insert the new duration (in minutes) for [pckey]'s ban", "New Duration", "[duration]", null)
				if(!isnum(value) || !value)
					to_chat(usr, "Cancelled")
					return
			var/list/sqlargs = list("t_edits" = "- [eckey] changed ban duration from [duration] to [value]<br>") //CHOMPEdit TGSQL
			var/datum/db_query/update_query = SSdbcore.NewQuery("UPDATE erro_ban SET duration = [value], edits = CONCAT(edits,:t_edits), expiration_time = DATE_ADD(bantime, INTERVAL [value] MINUTE) WHERE id = [banid]",sqlargs) //CHOMPEdit TGSQL
			message_admins("[key_name_admin(usr)] has edited a ban for [pckey]'s duration from [duration] to [value]",1)
			update_query.Execute()
			qdel(update_query) //CHOMPEdit TGSQL
		if("unban")
			if(tgui_alert(usr, "Unban [pckey]?", "Unban?", list("Yes", "No")) == "Yes")
				DB_ban_unban_by_id(banid)
				return
	to_chat(usr, span_filter_adminlog("Cancelled"))
	return

/datum/admins/proc/DB_ban_unban_by_id(var/id)

	if(!check_rights(R_BAN))	return

	var/sql = "SELECT ckey FROM erro_ban WHERE id = [id]"

	establish_db_connection()
	if(!SSdbcore.IsConnected()) //CHOMPEdit TGSQL
		return

	var/ban_number = 0 //failsafe

	var/pckey
	var/datum/db_query/query = SSdbcore.NewQuery(sql) //CHOMPEdit TGSQL
	query.Execute()
	while(query.NextRow())
		pckey = query.item[1]
		ban_number++;
	qdel(query) //CHOMPEdit TGSQL
	if(ban_number == 0)
		to_chat(usr, span_filter_adminlog("[span_red("Database update failed due to a ban id not being present in the database.")]"))
		return

	if(ban_number > 1)
		to_chat(usr, span_filter_adminlog("[span_red("Database update failed due to multiple bans having the same ID. Contact the database admin.")]"))
		return

	if(!src.owner || !istype(src.owner, /client))
		return

	var/unban_ckey = src.owner:ckey
	var/unban_computerid = src.owner:computer_id
	var/unban_ip = src.owner:address
	var/list/sqlargs = list("t_ckey" = unban_ckey) //CHOMPEdit TGSQL
	var/sql_update = "UPDATE erro_ban SET unbanned = 1, unbanned_datetime = Now(), unbanned_ckey = :t_ckey, unbanned_computerid = '[unban_computerid]', unbanned_ip = '[unban_ip]' WHERE id = [id]" //CHOMPEdit TGSQL
	message_admins("[key_name_admin(usr)] has lifted [pckey]'s ban.",1)

	var/datum/db_query/query_update = SSdbcore.NewQuery(sql_update,sqlargs) //CHOMPEdit TGSQL
	query_update.Execute()
	qdel(query_update) //CHOMPEdit TGSQL

/client/proc/DB_ban_panel()
	set category = "Admin.Moderation" //CHOMPEdit
	set name = "Banning Panel"
	set desc = "Edit admin permissions"

	if(!holder)
		return

	holder.DB_ban_panel()


/datum/admins/proc/DB_ban_panel(var/playerckey = null, var/adminckey = null, var/playerip = null, var/playercid = null, var/dbbantype = null, var/match = null)
	if(!usr.client)
		return

	if(!check_rights(R_BAN))	return

	establish_db_connection()
	if(!SSdbcore.IsConnected()) //CHOMPEdit TGSQL
		to_chat(usr, span_filter_adminlog("[span_red("Failed to establish database connection")]"))
		return

	var/output = "<div align='center'><table width='90%'><tr>"

	output += "<td width='35%' align='center'>"
	output += "<h1>Banning panel</h1>"
	output += "</td>"

	output += "<td width='65%' align='center' bgcolor='#f9f9f9'>"

	output += "<form method='GET' action='?src=\ref[src]'>[HrefTokenFormField()]"
	output += "<b>Add custom ban:</b> (ONLY use this if you can't ban through any other method)"
	output += "<input type='hidden' name='src' value='\ref[src]'>"
	output += "<table width='100%'><tr>"
	output += "<td width='50%' align='right'><b>Ban type:</b><select name='dbbanaddtype'>"
	output += "<option value=''>--</option>"
	output += "<option value='[BANTYPE_PERMA]'>PERMABAN</option>"
	output += "<option value='[BANTYPE_TEMP]'>TEMPBAN</option>"
	output += "<option value='[BANTYPE_JOB_PERMA]'>JOB PERMABAN</option>"
	output += "<option value='[BANTYPE_JOB_TEMP]'>JOB TEMPBAN</option>"
	output += "</select></td>"
	output += "<td width='50%' align='right'><b>Ckey:</b> <input type='text' name='dbbanaddckey'></td></tr>"
	output += "<tr><td width='50%' align='right'><b>IP:</b> <input type='text' name='dbbanaddip'></td>"
	output += "<td width='50%' align='right'><b>CID:</b> <input type='text' name='dbbanaddcid'></td></tr>"
	output += "<tr><td width='50%' align='right'><b>Duration:</b> <input type='text' name='dbbaddduration'></td>"
	output += "<td width='50%' align='right'><b>Job:</b><select name='dbbanaddjob'>"
	output += "<option value=''>--</option>"
	for(var/j in get_all_jobs())
		output += "<option value='[j]'>[j]</option>"
	for(var/j in SSjob.get_job_titles_in_department(DEPARTMENT_SYNTHETIC))
		output += "<option value='[j]'>[j]</option>"
	var/list/bantypes = list("traitor","changeling","operative","revolutionary","cultist","wizard") //For legacy bans.
	for(var/antag_type in all_antag_types) // Grab other bans.
		var/datum/antagonist/antag = all_antag_types[antag_type]
		bantypes |= antag.bantype
	for(var/j in bantypes)
		output += "<option value='[j]'>[j]</option>"
	output += "</select></td></tr></table>"
	output += "<b>Reason:<br></b><textarea name='dbbanreason' cols='50'></textarea><br>"
	output += "<input type='submit' value='Add ban'>"
	output += "</form>"

	output += "</td>"
	output += "</tr>"
	output += "</table>"

	output += "<form method='GET' action='?src=\ref[src]'>[HrefTokenFormField()]"
	output += "<table width='60%'><tr><td colspan='2' align='left'><b>Search:</b>"
	output += "<input type='hidden' name='src' value='\ref[src]'></td></tr>"
	output += "<tr><td width='50%' align='right'><b>Ckey:</b> <input type='text' name='dbsearchckey' value='[playerckey]'></td>"
	output += "<td width='50%' align='right'><b>Admin ckey:</b> <input type='text' name='dbsearchadmin' value='[adminckey]'></td></tr>"
	output += "<tr><td width='50%' align='right'><b>IP:</b> <input type='text' name='dbsearchip' value='[playerip]'></td>"
	output += "<td width='50%' align='right'><b>CID:</b> <input type='text' name='dbsearchcid' value='[playercid]'></td></tr>"
	output += "<tr><td width='50%' align='right' colspan='2'><b>Ban type:</b><select name='dbsearchbantype'>"
	output += "<option value=''>--</option>"
	output += "<option value='[BANTYPE_PERMA]'>PERMABAN</option>"
	output += "<option value='[BANTYPE_TEMP]'>TEMPBAN</option>"
	output += "<option value='[BANTYPE_JOB_PERMA]'>JOB PERMABAN</option>"
	output += "<option value='[BANTYPE_JOB_TEMP]'>JOB TEMPBAN</option>"
	output += "</select></td></tr></table>"
	output += "<br><input type='submit' value='search'><br>"
	output += "<input type='checkbox' value='[match]' name='dbmatch' [match? "checked=\"1\"" : null]> Match(min. 3 characters to search by key or ip, and 7 to search by cid)<br>"
	output += "</form>"
	output += "Please note that all jobban bans or unbans are in-effect the following round.<br>"
	output += "This search shows only last 100 bans."

	if(adminckey || playerckey || playerip || playercid || dbbantype)

		adminckey = ckey(adminckey)
		playerckey = ckey(playerckey)
		playerip = sql_sanitize_text(playerip)
		playercid = sql_sanitize_text(playercid)

		if(adminckey || playerckey || playerip || playercid || dbbantype)

			var/blcolor = "#ffeeee" //banned light
			var/bdcolor = "#ffdddd" //banned dark
			var/ulcolor = "#eeffee" //unbanned light
			var/udcolor = "#ddffdd" //unbanned dark
			var/alcolor = "#eeeeff" // auto-unbanned light
			var/adcolor = "#ddddff" // auto-unbanned dark

			output += "<table width='90%' bgcolor='#e3e3e3' cellpadding='5' cellspacing='0' align='center'>"
			output += "<tr>"
			output += "<th width='25%'><b>TYPE</b></th>"
			output += "<th width='20%'><b>CKEY</b></th>"
			output += "<th width='20%'><b>TIME APPLIED</b></th>"
			output += "<th width='20%'><b>ADMIN</b></th>"
			output += "<th width='15%'><b>OPTIONS</b></th>"
			output += "</tr>"

			var/adminsearch = ""
			var/playersearch = ""
			var/ipsearch = ""
			var/cidsearch = ""
			var/bantypesearch = ""
			//CHOMPEdit Begin
			var/list/sqlargs = list()
			if(!match)
				if(adminckey)
					adminsearch = "AND a_ckey = :t_adminckey "
					sqlargs["t_adminckey"] = adminckey
				if(playerckey)
					playersearch = "AND ckey = :t_playerckey "
					sqlargs["t_playerckey"] = playerckey //CHOMPEdit End
				if(playerip)
					ipsearch  = "AND ip = '[playerip]' "
				if(playercid)
					cidsearch  = "AND computerid = '[playercid]' "
			else
				if(adminckey && length(adminckey) >= 3) //CHOMPEdit Begin
					adminsearch = "AND a_ckey LIKE CONCAT(:t_adminckey,'%') "
					sqlargs["t_adminckey"] = adminckey
				if(playerckey && length(playerckey) >= 3)
					playersearch = "AND ckey LIKE CONCAT(:t_playerckey,'%') "
					sqlargs["t_playerckey"] = playerckey //CHOMPEdit End
				if(playerip && length(playerip) >= 3)
					ipsearch  = "AND ip LIKE '[playerip]%' "
				if(playercid && length(playercid) >= 7)
					cidsearch  = "AND computerid LIKE '[playercid]%' "

			if(dbbantype)
				bantypesearch = "AND bantype = "

				switch(dbbantype)
					if(BANTYPE_TEMP)
						bantypesearch += "'TEMPBAN' "
					if(BANTYPE_JOB_PERMA)
						bantypesearch += "'JOB_PERMABAN' "
					if(BANTYPE_JOB_TEMP)
						bantypesearch += "'JOB_TEMPBAN' "
					else
						bantypesearch += "'PERMABAN' "

			var/datum/db_query/select_query = SSdbcore.NewQuery("SELECT id, bantime, bantype, reason, job, duration, expiration_time, ckey, a_ckey, unbanned, unbanned_ckey, unbanned_datetime, edits, ip, computerid FROM erro_ban WHERE 1 [playersearch] [adminsearch] [ipsearch] [cidsearch] [bantypesearch] ORDER BY bantime DESC LIMIT 100", sqlargs) //CHOMPEdit TGSQL
			select_query.Execute()

			var/now = time2text(world.realtime, "YYYY-MM-DD hh:mm:ss") // MUST BE the same format as SQL gives us the dates in, and MUST be least to most specific (i.e. year, month, day not day, month, year)

			while(select_query.NextRow())
				var/banid = select_query.item[1]
				var/bantime = select_query.item[2]
				var/bantype  = select_query.item[3]
				var/reason = select_query.item[4]
				var/job = select_query.item[5]
				var/duration = select_query.item[6]
				var/expiration = select_query.item[7]
				var/ckey = select_query.item[8]
				var/ackey = select_query.item[9]
				var/unbanned = select_query.item[10]
				var/unbanckey = select_query.item[11]
				var/unbantime = select_query.item[12]
				var/edits = select_query.item[13]
				var/ip = select_query.item[14]
				var/cid = select_query.item[15]

				// true if this ban has expired
				var/auto = (bantype in list("TEMPBAN", "JOB_TEMPBAN")) && now > expiration // oh how I love ISO 8601 (ish) date strings

				var/lcolor = blcolor
				var/dcolor = bdcolor
				if(unbanned)
					lcolor = ulcolor
					dcolor = udcolor
				else if(auto)
					lcolor = alcolor
					dcolor = adcolor

				var/typedesc =""
				switch(bantype)
					if("PERMABAN")
						typedesc = "<font color='red'><b>PERMABAN</b></font>"
					if("TEMPBAN")
						typedesc = "<b>TEMPBAN</b><br><font size='2'>([duration] minutes) [(unbanned || auto) ? "" : "(<a href=\"byond://?src=\ref[src];[HrefToken()];dbbanedit=duration;dbbanid=[banid]\">Edit</a>)"]<br>Expires [expiration]</font>"
					if("JOB_PERMABAN")
						typedesc = "<b>JOBBAN</b><br><font size='2'>([job])</font>"
					if("JOB_TEMPBAN")
						typedesc = "<b>TEMP JOBBAN</b><br><font size='2'>([job])<br>([duration] minutes<br>Expires [expiration]</font>"

				output += "<tr bgcolor='[dcolor]'>"
				output += "<td align='center'>[typedesc]</td>"
				output += "<td align='center'><b>[ckey]</b></td>"
				output += "<td align='center'>[bantime]</td>"
				output += "<td align='center'><b>[ackey]</b></td>"
				output += "<td align='center'>[(unbanned || auto) ? "" : "<b><a href=\"byond://?src=\ref[src];[HrefToken()];dbbanedit=unban;dbbanid=[banid]\">Unban</a></b>"]</td>"
				output += "</tr>"
				output += "<tr bgcolor='[dcolor]'>"
				output += "<td align='center' colspan='2' bgcolor=''><b>IP:</b> [ip]</td>"
				output += "<td align='center' colspan='3' bgcolor=''><b>CIP:</b> [cid]</td>"
				output += "</tr>"
				output += "<tr bgcolor='[lcolor]'>"
				output += "<td align='center' colspan='5'><b>Reason: [(unbanned || auto) ? "" : "(<a href=\"byond://?src=\ref[src];[HrefToken()];dbbanedit=reason;dbbanid=[banid]\">Edit</a>)"]</b> <cite>\"[reason]\"</cite></td>"
				output += "</tr>"
				if(edits)
					output += "<tr bgcolor='[dcolor]'>"
					output += "<td align='center' colspan='5'><b>EDITS</b></td>"
					output += "</tr>"
					output += "<tr bgcolor='[lcolor]'>"
					output += "<td align='center' colspan='5'><font size='2'>[edits]</font></td>"
					output += "</tr>"
				if(unbanned)
					output += "<tr bgcolor='[dcolor]'>"
					output += "<td align='center' colspan='5' bgcolor=''><b>UNBANNED by admin [unbanckey] on [unbantime]</b></td>"
					output += "</tr>"
				else if(auto)
					output += "<tr bgcolor='[dcolor]'>"
					output += "<td align='center' colspan='5' bgcolor=''><b>EXPIRED at [expiration]</b></td>"
					output += "</tr>"
				output += "<tr>"
				output += "<td colspan='5' bgcolor='white'>&nbsp</td>"
				output += "</tr>"

			output += "</table></div>"
			qdel(select_query) //CHOMPEdit TGSQL

	usr << browse(output,"window=lookupbans;size=900x700")
