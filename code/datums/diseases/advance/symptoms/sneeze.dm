/*
//////////////////////////////////////

Sneezing

	Very Noticable.
	Increases resistance.
	Doesn't increase stage speed.
	Very transmittable.
	Low Level.

Bonus
	Forces a spread type of AIRBORNE
	with extra range!

//////////////////////////////////////
*/

/datum/symptom/sneeze
	name = "Sneezing"
	stealth = -2
	resistance = 3
	stage_speed = 0
	transmittable = 4
	level = 1
	severity = 1

/datum/symptom/sneeze/Activate(datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB))
		var/mob/living/M = A.affected_mob
		switch(A.stage)
			if(1, 2, 3)
				M.emote("sniff")
			else
				M.emote("sneeze")
				if(!M.wear_mask) // Spread only if they're not covering their face
					A.spread(5)

				if(prob(30) && !M.wear_mask) // Same for mucus
					var/obj/effect/decal/cleanable/mucus/icky = new(get_turf(M))
					icky.viruses |= A.Copy()

	return
