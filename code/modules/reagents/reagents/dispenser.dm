/datum/reagent/aluminum
	name = "Aluminum"
	id = "aluminum"
	description = "A silvery white and ductile member of the boron group of chemical elements."
	taste_description = "metal"
	taste_mult = 1.1
	reagent_state = SOLID
	color = "#A8A8A8"

/datum/reagent/calcium
	name = "Calcium"
	id = "calcium"
	description = "A chemical element, the building block of bones."
	taste_description = "metallic chalk" // Apparently, calcium tastes like calcium.
	taste_mult = 1.3
	reagent_state = SOLID
	color = "#e9e6e4"

//VOREStation Edit
/datum/reagent/calcium/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(ishuman(M) && rand(1,10000) == 1)
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/external/O in H.bad_external_organs)
			if(O.status & ORGAN_BROKEN)
				O.mend_fracture()
				H.custom_pain("You feel the agonizing power of calcium mending your bones!",60)
				H.AdjustWeakened(1)
				break // Only mend one bone, whichever comes first in the list
//VOREStation Edit End

/datum/reagent/carbon
	name = "Carbon"
	id = "carbon"
	description = "A chemical element, the building block of life."
	taste_description = "sour chalk"
	taste_mult = 1.5
	reagent_state = SOLID
	color = "#1C1300"
	ingest_met = REM * 5

/datum/reagent/carbon/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(M.ingested && M.ingested.reagent_list.len > 1) // Need to have at least 2 reagents - cabon and something to remove
		var/effect = 1 / (M.ingested.reagent_list.len - 1)
		for(var/datum/reagent/R in M.ingested.reagent_list)
			if(R == src)
				continue
			M.ingested.remove_reagent(R.id, removed * effect)

/datum/reagent/carbon/touch_turf(var/turf/T)
	..()
	if(!istype(T, /turf/space))
		var/obj/effect/decal/cleanable/dirt/dirtoverlay = locate(/obj/effect/decal/cleanable/dirt, T)
		if (!dirtoverlay)
			dirtoverlay = new/obj/effect/decal/cleanable/dirt(T)
			dirtoverlay.alpha = volume * 30
		else
			dirtoverlay.alpha = min(dirtoverlay.alpha + volume * 30, 255)

/datum/reagent/chlorine
	name = "Chlorine"
	id = "chlorine"
	description = "A chemical element with a characteristic odour."
	taste_description = "pool water"
	reagent_state = GAS
	color = "#808080"

/datum/reagent/chlorine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.take_organ_damage(1*REM, 0)

/datum/reagent/chlorine/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	M.take_organ_damage(1*REM, 0)

/datum/reagent/copper
	name = "Copper"
	id = "copper"
	description = "A highly ductile metal."
	taste_description = "pennies"
	color = "#6E3B08"

/datum/reagent/ethanol
	name = "Ethanol" //Parent class for all alcoholic reagents.
	id = "ethanol"
	description = "A well-known alcohol with a variety of applications."
	taste_description = "pure alcohol"
	reagent_state = LIQUID
	color = "#404030"

	ingest_met = REM * 2

	var/nutriment_factor = 0
	var/strength = 10 // This is, essentially, units between stages - the lower, the stronger. Less fine tuning, more clarity.
	var/toxicity = 1

	var/druggy = 0
	var/adj_temp = 0
	var/targ_temp = 310
	var/halluci = 0

	glass_name = "ethanol"
	glass_desc = "A well-known alcohol with a variety of applications."
	allergen_factor = 1	//simulates mixed drinks containing less of the allergen, as they have only a single actual reagent unlike food

	affects_robots = 1 //kiss my shiny metal ass

/datum/reagent/ethanol/touch_mob(var/mob/living/L, var/amount)
	..()
	if(istype(L))
		L.adjust_fire_stacks(amount / 15)

/datum/reagent/ethanol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed) //This used to do just toxin. That's boring. Let's make this FUN.
	if(issmall(M))
		removed *= 2

	var/strength_mod = 3 * M.species.chem_strength_alcohol //Alcohol is 3x stronger when injected into the veins.
	if(!strength_mod)
		return

	if(!(M.isSynthetic()))
		M.add_chemical_effect(CE_ALCOHOL, 1)
		var/effective_dose = dose * strength_mod * (1 + volume/60) //drinking a LOT will make you go down faster

		if(effective_dose >= strength) // Early warning
			M.make_dizzy(18) // It is decreased at the speed of 3 per tick
		if(effective_dose >= strength * 2) // Slurring
			M.slurring = max(M.slurring, 90)
		if(effective_dose >= strength * 3) // Confusion - walking in random directions
			M.Confuse(60)
		if(effective_dose >= strength * 4) // Blurry vision
			M.eye_blurry = max(M.eye_blurry, 30)
		if(effective_dose >= strength * 5) // Drowsyness - periodically falling asleep
			M.drowsyness = max(M.drowsyness, 60)
		if(effective_dose >= strength * 6) // Toxic dose
			M.add_chemical_effect(CE_ALCOHOL_TOXIC, toxicity*3)
		if(effective_dose >= strength * 7) // Pass out
			M.Paralyse(60)
			M.Sleeping(90)

		if(druggy != 0)
			M.druggy = max(M.druggy, druggy*3)

		if(adj_temp > 0 && M.bodytemperature < targ_temp) // 310 is the normal bodytemp. 310.055
			M.bodytemperature = min(targ_temp, M.bodytemperature + (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))
		if(adj_temp < 0 && M.bodytemperature > targ_temp)
			M.bodytemperature = min(targ_temp, M.bodytemperature - (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))

		if(halluci)
			M.hallucination = max(M.hallucination, halluci*3)

/datum/reagent/ethanol/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	var/ep_base_power = 60	//base nutrition gain for ethanol-processing synthetics, reduced by alcohol strength
	var/ep_final_mod = 30	//final divisor on nutrition gain
	if(issmall(M))
		removed *= 2

	if(!(M.species.allergens & allergen_type) && !(M.isSynthetic()))	//assuming it doesn't cause a horrible reaction, we get the nutrition effects - VOREStation Edit (added synth check)
		M.adjust_nutrition(nutriment_factor * removed)

	if(M.isSynthetic() && M.nutrition < 500 && M.species.robo_ethanol_proc)
		M.adjust_nutrition(round(max(0,ep_base_power - strength) * removed)/ep_final_mod)	//the stronger it is, the more juice you gain

	var/effective_dose = dose * M.species.chem_strength_alcohol
	if(!effective_dose)
		return

	if(M.species.robo_ethanol_drunk || !(M.isSynthetic()))
		M.add_chemical_effect(CE_ALCOHOL, 1)

		if(effective_dose >= strength) // Early warning
			M.make_dizzy(6) // It is decreased at the speed of 3 per tick
		if(effective_dose >= strength * 2) // Slurring
			M.slurring = max(M.slurring, 30)
		if(effective_dose >= strength * 3) // Confusion - walking in random directions
			M.Confuse(20)
		if(effective_dose >= strength * 4) // Blurry vision
			M.eye_blurry = max(M.eye_blurry, 10)
		if(effective_dose >= strength * 5) // Drowsyness - periodically falling asleep
			M.drowsyness = max(M.drowsyness, 20)
		if(effective_dose >= strength * 6) // Toxic dose
			M.add_chemical_effect(CE_ALCOHOL_TOXIC, toxicity)
		if(effective_dose >= strength * 7) // Pass out
			M.Paralyse(20)
			M.Sleeping(30)

		if(druggy != 0)
			M.druggy = max(M.druggy, druggy)

		if(halluci)
			M.hallucination = max(M.hallucination, halluci)

		if(adj_temp > 0 && M.bodytemperature < targ_temp) // 310 is the normal bodytemp. 310.055
			M.bodytemperature = min(targ_temp, M.bodytemperature + (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))
		if(adj_temp < 0 && M.bodytemperature > targ_temp)
			M.bodytemperature = min(targ_temp, M.bodytemperature - (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))

/datum/reagent/ethanol/touch_obj(var/obj/O)
	..()
	if(istype(O, /obj/item/weapon/paper))
		var/obj/item/weapon/paper/paperaffected = O
		paperaffected.clearpaper()
		to_chat(usr, "The solution dissolves the ink on the paper.")
		return
	if(istype(O, /obj/item/weapon/book))
		if(volume < 5)
			return
		if(istype(O, /obj/item/weapon/book/tome))
			to_chat(usr, "<span class='notice'>The solution does nothing. Whatever this is, it isn't normal ink.</span>")
			return
		var/obj/item/weapon/book/affectedbook = O
		affectedbook.dat = null
		to_chat(usr, "<span class='notice'>The solution dissolves the ink on the book.</span>")
	return

/datum/reagent/fluorine
	name = "Fluorine"
	id = "fluorine"
	description = "A highly-reactive chemical element."
	taste_description = "acid"
	reagent_state = GAS
	color = "#808080"

/datum/reagent/fluorine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustToxLoss(removed)

/datum/reagent/fluorine/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustToxLoss(removed)

/datum/reagent/hydrogen
	name = "Hydrogen"
	id = "hydrogen"
	description = "A colorless, odorless, nonmetallic, tasteless, highly combustible diatomic gas."
	taste_mult = 0 //no taste
	reagent_state = GAS
	color = "#808080"

/datum/reagent/iron
	name = "Iron"
	id = "iron"
	description = "Pure iron is a metal."
	taste_description = "metal"
	reagent_state = SOLID
	color = "#353535"

/datum/reagent/lithium
	name = "Lithium"
	id = "lithium"
	description = "A chemical element, used as antidepressant."
	taste_description = "metal"
	reagent_state = SOLID
	color = "#808080"

/datum/reagent/lithium/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		if(M.canmove && !M.restrained() && istype(M.loc, /turf/space))
			step(M, pick(cardinal))
		if(prob(5))
			M.emote(pick("twitch", "drool", "moan"))

/datum/reagent/mercury
	name = "Mercury"
	id = "mercury"
	description = "A chemical element."
	taste_mult = 0 //mercury apparently is tasteless. IDK
	reagent_state = LIQUID
	color = "#484848"

/datum/reagent/mercury/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		if(M.canmove && !M.restrained() && istype(M.loc, /turf/space))
			step(M, pick(cardinal))
		if(prob(5))
			M.emote(pick("twitch", "drool", "moan"))
		M.adjustBrainLoss(0.5 * removed)

/datum/reagent/nitrogen
	name = "Nitrogen"
	id = "nitrogen"
	description = "A colorless, odorless, tasteless gas."
	taste_mult = 0 //no taste
	reagent_state = GAS
	color = "#808080"

/datum/reagent/oxygen
	name = "Oxygen"
	id = "oxygen"
	description = "A colorless, odorless gas."
	taste_mult = 0
	reagent_state = GAS
	color = "#808080"

/datum/reagent/oxygen/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_VOX)
		M.adjustToxLoss(removed * 3)

/datum/reagent/phosphorus
	name = "Phosphorus"
	id = "phosphorus"
	description = "A chemical element, the backbone of biological energy carriers."
	taste_description = "vinegar"
	reagent_state = SOLID
	color = "#832828"

/datum/reagent/potassium
	name = "Potassium"
	id = "potassium"
	description = "A soft, low-melting solid that can easily be cut with a knife. Reacts violently with water."
	taste_description = "sweetness" //potassium is bitter in higher doses but sweet in lower ones.
	reagent_state = SOLID
	color = "#A0A0A0"

/datum/reagent/radium
	name = "Radium"
	id = "radium"
	description = "Radium is an alkaline earth metal. It is extremely radioactive."
	taste_mult = 0	//Apparently radium is tasteless
	reagent_state = SOLID
	color = "#C7C7C7"

/datum/reagent/radium/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(issmall(M)) removed *= 2
	M.apply_effect(10 * removed, IRRADIATE, 0) // Radium may increase your chances to cure a disease
	if(M.virus2.len)
		for(var/ID in M.virus2)
			var/datum/disease2/disease/V = M.virus2[ID]
			if(prob(5))
				M.antibodies |= V.antigen
				if(prob(50))
					M.apply_effect(50, IRRADIATE, check_protection = 0) // curing it that way may kill you instead
					var/absorbed = 0
					var/obj/item/organ/internal/diona/nutrients/rad_organ = locate() in M.internal_organs
					if(rad_organ && !rad_organ.is_broken())
						absorbed = 1
					if(!absorbed)
						M.adjustToxLoss(100)

/datum/reagent/radium/touch_turf(var/turf/T)
	..()
	if(volume >= 3)
		if(!istype(T, /turf/space))
			var/obj/effect/decal/cleanable/greenglow/glow = locate(/obj/effect/decal/cleanable/greenglow, T)
			if(!glow)
				new /obj/effect/decal/cleanable/greenglow(T)
			return

/datum/reagent/acid
	name = "Sulphuric acid"
	id = "sacid"
	description = "A very corrosive mineral acid with the molecular formula H2SO4."
	taste_description = "acid"
	reagent_state = LIQUID
	color = "#DB5008"
	metabolism = REM * 2
	touch_met = 50 // It's acid!
	var/power = 5
	var/meltdose = 10 // How much is needed to melt
	affects_robots = TRUE //CHOMPedit, it's acid! Still eats metal!

/datum/reagent/acid/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_GREY) //ywedit
		return
	if(issmall(M)) removed *= 2
	M.take_organ_damage(0, removed * power * 2)

/datum/reagent/acid/affect_touch(var/mob/living/carbon/M, var/alien, var/removed) // This is the most interesting
	if(alien == IS_GREY) //ywedit
		return
	if(ishuman(M) && !isbelly(M.loc)) //CHOMPEdit Start
		var/mob/living/carbon/human/H = M
		if(H.head)
			if(H.head.unacidable || is_type_in_list(H.head,item_digestion_blacklist))
				to_chat(H, "<span class='danger'>Your [H.head] protects you from the acid.</span>")
				remove_self(volume)
				return
			else if(removed > meltdose)
				to_chat(H, "<span class='danger'>Your [H.head] melts away!</span>")
				qdel(H.head)
				H.update_inv_head(1)
				H.update_hair(1)
				removed -= meltdose
		if(removed <= 0)
			return

		if(H.wear_mask)
			if(H.wear_mask.unacidable || is_type_in_list(H.wear_mask,item_digestion_blacklist))
				to_chat(H, "<span class='danger'>Your [H.wear_mask] protects you from the acid.</span>")
				remove_self(volume)
				return
			else if(removed > meltdose)
				to_chat(H, "<span class='danger'>Your [H.wear_mask] melts away!</span>")
				qdel(H.wear_mask)
				H.update_inv_wear_mask(1)
				H.update_hair(1)
				removed -= meltdose
		if(removed <= 0)
			return

		if(H.glasses)
			if(H.glasses.unacidable || is_type_in_list(H.glasses,item_digestion_blacklist))
				to_chat(H, "<span class='danger'>Your [H.glasses] partially protect you from the acid!</span>")
				removed /= 2
			else if(removed > meltdose)
				to_chat(H, "<span class='danger'>Your [H.glasses] melt away!</span>")
				qdel(H.glasses)
				H.update_inv_glasses(1)
				removed -= meltdose / 2
		if(removed <= 0)
			return
	if(isbelly(M.loc))
		var/obj/belly/B = M.loc
		if(!M.digestable || B.digest_mode != DM_DIGEST)
			remove_self(volume)
			return
		if(B.owner)
			if(B.show_liquids && B.reagent_mode_flags & DM_FLAG_REAGENTSDIGEST && B.reagents.total_volume < B.custom_max_volume)
				B.owner_adjust_nutrition(removed * (B.nutrition_percent / 100) * power)
				B.digest_nutri_gain += removed * (B.nutrition_percent / 100) + 0.5
				B.GenerateBellyReagents_digesting()
			else
				B.owner_adjust_nutrition(removed * (B.nutrition_percent / 100) * power) //CHOMPEdit End

	if(volume < meltdose) // Not enough to melt anything
		M.take_organ_damage(0, removed * power * 0.2) //burn damage, since it causes chemical burns. Acid doesn't make bones shatter, like brute trauma would.
		return
	if(!M.unacidable && removed > 0)
		if(istype(M, /mob/living/carbon/human) && volume >= meltdose)
			var/mob/living/carbon/human/H = M
			var/obj/item/organ/external/affecting = H.get_organ(BP_HEAD)
			if(affecting)
				if(affecting.take_damage(0, removed * power * 0.1))
					H.UpdateDamageIcon()
				if(prob(100 * removed / meltdose)) // Applies disfigurement
					if (affecting.organ_can_feel_pain() && !isbelly(H.loc)) //VOREStation Add
						H.emote("scream")
					H.status_flags |= DISFIGURED
		else
			M.take_organ_damage(0, removed * power * 0.1) // Balance. The damage is instant, so it's weaker. 10 units -> 5 damage, double for pacid. 120 units beaker could deal 60, but a) it's burn, which is not as dangerous, b) it's a one-use weapon, c) missing with it will splash it over the ground and d) clothes give some protection, so not everything will hit

/datum/reagent/acid/touch_obj(var/obj/O, var/amount) //CHOMPEdit Start
	if(istype(O, /obj/item) && O.loc)
		if(isbelly(O.loc) || isbelly(O.loc.loc))
			var/obj/belly/B = O.loc
			if(B.item_digest_mode == IM_HOLD)
				return
			var/obj/item/I = O
			var/spent_amt = I.digest_act(I.loc, 1, amount / (meltdose / 3))
			remove_self(spent_amt) //10u stomacid per w_class, less if stronger acid.
			if(B.owner)
				B.owner_adjust_nutrition((B.nutrition_percent / 100) * 5 * spent_amt)
			return
	..()
	if(O.unacidable || is_type_in_list(O,item_digestion_blacklist)) //CHOMPEdit End
		return
	if((istype(O, /obj/item) || istype(O, /obj/effect/plant)) && (volume > meltdose))
		var/obj/effect/decal/cleanable/molten_item/I = new/obj/effect/decal/cleanable/molten_item(O.loc)
		I.desc = "Looks like this was \an [O] some time ago."
		for(var/mob/M in viewers(5, O))
			to_chat(M, "<span class='warning'>\The [O] melts.</span>")
		qdel(O)
		remove_self(meltdose) // 10 units of acid will not melt EVERYTHING on the tile

/datum/reagent/acid/touch_mob(var/mob/living/L) //CHOMPAdd Start
	if(isbelly(L.loc))
		var/obj/belly/B = L.loc
		if(B.digest_mode != DM_DIGEST || !L.digestable)
			remove_self(volume)
			return
		if(B.owner)
			if(B.show_liquids && B.reagent_mode_flags & DM_FLAG_REAGENTSDIGEST && B.reagents.total_volume < B.custom_max_volume)
				B.owner_adjust_nutrition(volume * (B.nutrition_percent / 100) * power)
				B.digest_nutri_gain += volume * (B.nutrition_percent / 100) + 0.5
				B.GenerateBellyReagents_digesting()
			else
				B.owner_adjust_nutrition(volume * (B.nutrition_percent / 100) * power)
	L.adjustFireLoss(volume * power * 0.2)
	remove_self(volume) //CHOMPAdd End

/datum/reagent/silicon
	name = "Silicon"
	id = "silicon"
	description = "A tetravalent metalloid, silicon is less reactive than its chemical analog carbon."
	taste_mult = 0
	reagent_state = SOLID
	color = "#A8A8A8"

/datum/reagent/sodium
	name = "Sodium"
	id = "sodium"
	description = "A chemical element, readily reacts with water."
	taste_description = "salty metal"
	reagent_state = SOLID
	color = "#808080"

/datum/reagent/sugar
	name = "Sugar"
	id = "sugar"
	description = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste."
	taste_description = "sugar"
	taste_mult = 1.8
	reagent_state = SOLID
	color = "#FFFFFF"

	glass_name = "sugar"
	glass_desc = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste."
	glass_icon = DRINK_ICON_NOISY

/datum/reagent/sugar/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjust_nutrition(removed * 3)

	var/effective_dose = dose
	if(issmall(M))
		effective_dose *= 2

	if(alien == IS_UNATHI)
		if(effective_dose < 2)
			if(effective_dose == metabolism * 2 || prob(5))
				M.emote("yawn")
		else if(effective_dose < 5)
			M.eye_blurry = max(M.eye_blurry, 10)
		else if(effective_dose < 20)
			if(prob(50))
				M.Weaken(2)
			M.drowsyness = max(M.drowsyness, 20)
		else
			M.Sleeping(20)
			M.drowsyness = max(M.drowsyness, 60)

/datum/reagent/sulfur
	name = "Sulfur"
	id = "sulfur"
	description = "A chemical element with a pungent smell."
	taste_description = "old eggs"
	reagent_state = SOLID
	color = "#BF8C00"

/datum/reagent/tungsten
	name = "Tungsten"
	id = "tungsten"
	description = "A chemical element, and a strong oxidising agent."
	taste_description = "metal"
	taste_mult = 0 //no taste
	reagent_state = SOLID
	color = "#DCDCDC"
