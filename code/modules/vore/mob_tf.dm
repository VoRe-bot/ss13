// Procs for living mobs based around mob transformation. Initially made for the mouseray, they are now used in various other places and the main procs are now called from here.


/mob/living/proc/mob_tf(var/mob/living/M)
	if(!istype(M))
		return
	if(src && isliving(src))
		//CHOMPEdit Start
		faction = M.faction
		if(istype(src, /mob/living/simple_mob))
			var/mob/living/simple_mob/S = src
			if(!S.voremob_loaded)
				S.voremob_loaded = TRUE
				S.init_vore()
		new /obj/effect/effect/teleport_greyscale(M.loc)
		//CHOMPEdit End
		for(var/obj/belly/B as anything in src.vore_organs)
			src.vore_organs -= B
			qdel(B)
		src.vore_organs = list()
		src.name = M.name
		src.real_name = M.real_name
		for(var/lang in M.languages)
			src.languages |= lang
		M.copy_vore_prefs_to_mob(src)
		src.vore_selected = M.vore_selected
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(ishuman(src))
				var/mob/living/carbon/human/N = src
				N.gender = H.gender
				N.identifying_gender = H.identifying_gender
			else
				src.gender = H.gender
		else
			src.gender = M.gender
			if(ishuman(src))
				var/mob/living/carbon/human/N = src
				N.identifying_gender = M.gender

		mob_belly_transfer(M)
		nutrition = M.nutrition //CHOMPAdd
		M.soulgem.transfer_self(src) //CHOMPAdd Soulcatcher

		src.ckey = M.ckey
		if(M.ai_holder && src.ai_holder)
			var/datum/ai_holder/old_AI = M.ai_holder
			old_AI.set_stance(STANCE_SLEEP)
			var/datum/ai_holder/new_AI = src.ai_holder
			new_AI.hostile = old_AI.hostile
			new_AI.retaliate = old_AI.retaliate
		M.loc = src
		M.forceMove(src)
		src.tf_mob_holder = M

/mob/living/proc/mob_belly_transfer(var/mob/living/M)
	for(var/obj/belly/B as anything in M.vore_organs)
		B.loc = src
		B.forceMove(src)
		B.owner = src
		M.vore_organs -= B
		src.vore_organs += B

/mob/living
	var/mob/living/tf_mob_holder = null

/mob/living/proc/revert_mob_tf()
	if(!tf_mob_holder)
		return
	var/mob/living/ourmob = tf_mob_holder
	//CHOMPAdd Start - OOC Escape functionality for Mind Binder and Body Snatcher
	if(ourmob.loc != src)
		if(isnull(ourmob.loc))
			to_chat(src,span_notice("You have no body."))
			tf_mob_holder = null
			return
		if(istype(ourmob.loc, /mob/living)) //Check for if body was transformed
			ourmob = ourmob.loc
		if(ourmob.ckey)
			if(ourmob.tf_mob_holder && ourmob.tf_mob_holder == src)
				//Body Swap
				var/datum/mind/ourmind = src.mind
				var/datum/mind/theirmind = ourmob.mind
				ourmob.ghostize()
				src.ghostize()
				ourmob.mind = null
				src.mind = null
				ourmind.current = null
				theirmind.current = null
				ourmind.active = TRUE
				ourmind.transfer_to(ourmob)
				theirmind.active = TRUE
				theirmind.transfer_to(src)
				ourmob.tf_mob_holder = null
				src.tf_mob_holder = null
			else
				to_chat(src,span_notice("Your body appears to be in someone else's control."))
			return
		src.mind.transfer_to(ourmob)
		tf_mob_holder = null
		return
	new /obj/effect/effect/teleport_greyscale(src.loc)
	//CHOMPAdd End - OOC Escape functionality for Mind Binder and Body Snatcher
	if(ourmob.ai_holder)
		var/datum/ai_holder/our_AI = ourmob.ai_holder
		our_AI.set_stance(STANCE_IDLE)
	tf_mob_holder = null
	ourmob.ckey = ckey
	var/turf/get_dat_turf = get_turf(src)
	ourmob.loc = get_dat_turf
	ourmob.forceMove(get_dat_turf)
	// CHOMPEdit Start
	if(!tf_form_ckey)
		ourmob.vore_selected = vore_selected
		vore_selected = null
		for(var/obj/belly/B as anything in vore_organs)
			B.loc = ourmob
			B.forceMove(ourmob)
			B.owner = ourmob
			vore_organs -= B
			ourmob.vore_organs += B
	// CHOMPEdit End

	ourmob.Life(1)

	if(ishuman(src))
		for(var/obj/item/W in src)
			if(istype(W, /obj/item/implant/backup) || istype(W, /obj/item/nif))
				continue
			src.drop_from_inventory(W)

	// CHOMPEdit Start
	if(tf_form == ourmob)
		if(tf_form_ckey)
			src.ckey = tf_form_ckey
		else
			src.mind = null
		ourmob.tf_form = src
		src.forceMove(ourmob)
	else
		qdel(src)
	//CHOMPEdit End

/mob/living/proc/handle_tf_holder()
	if(!tf_mob_holder)
		return
	if(tf_mob_holder.loc != src) return //CHOMPAdd - Prevent bodyswapped creatures having their life linked
	if(stat != tf_mob_holder.stat)
		if(stat == DEAD)
			tf_mob_holder.death(FALSE, null)
		if(tf_mob_holder.stat == DEAD)
			death()

/mob/living/proc/copy_vore_prefs_to_mob(var/mob/living/new_mob)
	//For primarily copying vore preference settings from a carbon mob to a simplemob
	//It can be used for other things, but be advised, if you're using it to put a simplemob into a carbon mob, you're gonna be overriding a bunch of prefs
	new_mob.ooc_notes = ooc_notes
	new_mob.ooc_notes_likes = ooc_notes_likes
	new_mob.ooc_notes_dislikes = ooc_notes_dislikes
	new_mob.digestable = digestable
	new_mob.devourable = devourable
	new_mob.absorbable = absorbable
	new_mob.feeding = feeding
	new_mob.can_be_drop_prey = can_be_drop_prey
	new_mob.can_be_drop_pred = can_be_drop_pred
	// new_mob.allow_inbelly_spawning = allow_inbelly_spawning //CHOMP Removal: we have vore spawning at home. Actually if this were to be enabled, it would break anyway. Just leaving this here as a reference to it.
	new_mob.digest_leave_remains = digest_leave_remains
	new_mob.allowmobvore = allowmobvore
	new_mob.permit_healbelly = permit_healbelly
	new_mob.noisy = noisy
	new_mob.selective_preference = selective_preference
	new_mob.appendage_color = appendage_color
	new_mob.appendage_alt_setting = appendage_alt_setting
	new_mob.drop_vore = drop_vore
	new_mob.stumble_vore = stumble_vore
	new_mob.slip_vore = slip_vore
	new_mob.throw_vore = throw_vore
	new_mob.food_vore = food_vore
	new_mob.resizable = resizable
	new_mob.show_vore_fx = show_vore_fx
	new_mob.step_mechanics_pref = step_mechanics_pref
	new_mob.pickup_pref = pickup_pref
	new_mob.vore_taste = vore_taste
	new_mob.vore_smell = vore_smell
	new_mob.nutrition_message_visible = nutrition_message_visible
	new_mob.allow_spontaneous_tf = allow_spontaneous_tf
	new_mob.eating_privacy_global = eating_privacy_global
	new_mob.allow_mimicry = allow_mimicry
	new_mob.text_warnings = text_warnings
	new_mob.allow_mind_transfer = allow_mind_transfer

	//CHOMP stuff Start
	new_mob.phase_vore = phase_vore
	new_mob.latejoin_vore = latejoin_vore
	new_mob.latejoin_prey = latejoin_prey
	new_mob.receive_reagents = receive_reagents
	new_mob.give_reagents = give_reagents
	new_mob.apply_reagents = apply_reagents
	new_mob.autotransferable = autotransferable
	new_mob.strip_pref = strip_pref
	new_mob.vore_sprite_color = vore_sprite_color
	new_mob.vore_sprite_multiply = vore_sprite_multiply
	new_mob.noisy_full = noisy_full
	new_mob.no_latejoin_vore_warning = no_latejoin_vore_warning
	new_mob.no_latejoin_prey_warning = no_latejoin_prey_warning
	new_mob.no_latejoin_vore_warning_time = no_latejoin_vore_warning_time
	new_mob.no_latejoin_prey_warning_time = no_latejoin_prey_warning_time
	new_mob.no_latejoin_vore_warning_persists = no_latejoin_vore_warning_persists
	new_mob.no_latejoin_prey_warning_persists = no_latejoin_prey_warning_persists
	new_mob.belly_rub_target = belly_rub_target
	new_mob.soulcatcher_pref_flags = soulcatcher_pref_flags
	//CHOMP stuff End
