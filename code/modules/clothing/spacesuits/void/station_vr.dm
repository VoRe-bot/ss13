/obj/item/clothing/head/helmet/space/void/medical/alt
	sprite_sheets = list(
		SPECIES_HUMAN			= 'icons/inventory/head/mob.dmi',
		SPECIES_TAJARAN 			= 'icons/inventory/head/mob_tajaran.dmi',
		SPECIES_SKRELL 			= 'icons/inventory/head/mob_skrell.dmi',
		SPECIES_UNATHI 			= 'icons/inventory/head/mob_unathi.dmi',
		SPECIES_XENOHYBRID 		= 'icons/inventory/head/mob_unathi.dmi',
		SPECIES_AKULA			= 'icons/inventory/head/mob_unathi.dmi',
		SPECIES_SERGAL			= 'icons/inventory/head/mob_unathi.dmi',
		SPECIES_VULPKANIN		= 'icons/inventory/head/mob_vr_vulpkanin.dmi',
		SPECIES_ZORREN_HIGH		= 'icons/inventory/head/mob_vr_vulpkanin.dmi',
		SPECIES_FENNEC			= 'icons/inventory/head/mob_vr_vulpkanin.dmi'
		)
	sprite_sheets_obj = list(
		SPECIES_TAJARAN 			= 'icons/inventory/head/item.dmi',
		SPECIES_SKRELL			= 'icons/inventory/head/item.dmi',
		SPECIES_UNATHI			= 'icons/inventory/head/item.dmi',
		SPECIES_XENOHYBRID		= 'icons/inventory/head/item.dmi',
		SPECIES_AKULA			= 'icons/inventory/head/item.dmi',
		SPECIES_SERGAL			= 'icons/inventory/head/item.dmi',
		SPECIES_VULPKANIN		= 'icons/inventory/head/item.dmi',
		SPECIES_ZORREN_HIGH		= 'icons/inventory/head/item.dmi',
		SPECIES_FENNEC			= 'icons/inventory/head/item.dmi'
		)

/obj/item/clothing/suit/space/void/medical/alt
	sprite_sheets = list(
		SPECIES_HUMAN			= 'icons/inventory/suit/mob.dmi',
		SPECIES_TAJARAN 			= 'icons/inventory/suit/mob_tajaran.dmi',
		SPECIES_SKRELL 			= 'icons/inventory/suit/mob_skrell.dmi',
		SPECIES_UNATHI 			= 'icons/inventory/suit/mob_unathi.dmi',
		SPECIES_XENOHYBRID 		= 'icons/inventory/suit/mob_unathi.dmi',
		SPECIES_AKULA			= 'icons/inventory/suit/mob_vr_akula.dmi',
		SPECIES_SERGAL			= 'icons/inventory/suit/mob_vr_sergal.dmi',
		SPECIES_VULPKANIN		= 'icons/inventory/suit/mob_vr_vulpkanin.dmi',
		SPECIES_ZORREN_HIGH		= 'icons/inventory/suit/mob_vr_vulpkanin.dmi',
		SPECIES_FENNEC			= 'icons/inventory/suit/mob_vr_vulpkanin.dmi'
		)
	sprite_sheets_obj = list(
		SPECIES_TAJARAN			= 'icons/inventory/suit/item.dmi',
		SPECIES_SKRELL			= 'icons/inventory/suit/item.dmi',
		SPECIES_UNATHI			= 'icons/inventory/suit/item.dmi',
		SPECIES_XENOHYBRID		= 'icons/inventory/suit/item.dmi',
		SPECIES_AKULA			= 'icons/inventory/suit/item.dmi',
		SPECIES_SERGAL			= 'icons/inventory/suit/item.dmi',
		SPECIES_VULPKANIN		= 'icons/inventory/suit/item.dmi',
		SPECIES_ZORREN_HIGH		= 'icons/inventory/suit/item.dmi',
		SPECIES_FENNEC			= 'icons/inventory/suit/item.dmi'
		)

// Alt mining voidsuit
// CHOMPStation Edit Start: Commonwealth -> Solgov.
/obj/item/clothing/suit/space/void/mining/alt2
	desc = "A surplus Solgov mining voidsuit! Slightly more comfortable and easier to move in than your average voidsuit."

	icon = 'icons/inventory/suit/item_vr.dmi'
	default_worn_icon = 'icons/inventory/suit/mob_vr.dmi'
	icon_state = "void_mining_bay"
	item_state = null
	sprite_sheets = ALL_VR_SPRITE_SHEETS_SUIT_MOB
	sprite_sheets_obj = ALL_VR_SPRITE_SHEETS_SUIT_ITEM
	slowdown = 0

/obj/item/clothing/head/helmet/space/void/mining/alt2
	desc = "A surplus Solgov voidsuit helmet. Seems more fancy than what's usually found on the frontier."

	icon = 'icons/inventory/head/item_vr.dmi'
	default_worn_icon = 'icons/inventory/head/mob_vr.dmi'
	icon_state = "void_mining_bay"
	item_state = null
	sprite_sheets = ALL_VR_SPRITE_SHEETS_HEAD_MOB
	sprite_sheets_obj = ALL_VR_SPRITE_SHEETS_HEAD_ITEM

// Alt anomaly/excavation suit
/obj/item/clothing/suit/space/anomaly/alt
	desc = "A surplus Solgov anomaly suit! Slightly more comfortable and easier to move in than your average anomaly suit."

	icon = 'icons/inventory/suit/item_vr.dmi'
	default_worn_icon = 'icons/inventory/suit/mob_vr.dmi'
	icon_state = "void_excavation_bay"
	item_state = null
	sprite_sheets = ALL_VR_SPRITE_SHEETS_SUIT_MOB
	sprite_sheets_obj = ALL_VR_SPRITE_SHEETS_SUIT_ITEM
	slowdown = 0.5

/obj/item/clothing/head/helmet/space/anomaly/alt
	desc = "A surplus Solgov helmet. Seems more fancy than what's usually found on the frontier."

	icon = 'icons/inventory/head/item_vr.dmi'
	default_worn_icon = 'icons/inventory/head/mob_vr.dmi'
	icon_state = "void_excavation_bay"
	item_state = null
	sprite_sheets = ALL_VR_SPRITE_SHEETS_HEAD_MOB
	sprite_sheets_obj = ALL_VR_SPRITE_SHEETS_HEAD_ITEM
	camera_networks = list(NETWORK_RESEARCH)

// Alt riot suit
/obj/item/clothing/suit/space/void/security/riot/alt
	desc = "A surplus Solgov riot control voidsuit! Slightly more comfortable and easier to move in than your average voidsuit."

	icon = 'icons/inventory/suit/item_vr.dmi'
	default_worn_icon = 'icons/inventory/suit/mob_vr.dmi'
	icon_state = "void_secalt_bay"
	item_state = null
	sprite_sheets = ALL_VR_SPRITE_SHEETS_SUIT_MOB
	sprite_sheets_obj = ALL_VR_SPRITE_SHEETS_SUIT_ITEM
	slowdown = 0.5

/obj/item/clothing/head/helmet/space/void/security/riot/alt
	desc = "A surplus Solgov voidsuit helmet. Seems more fancy than what's usually found on the frontier."

	icon = 'icons/inventory/head/item_vr.dmi'
	default_worn_icon = 'icons/inventory/head/mob_vr.dmi'
	icon_state = "void_secalt_bay"
	item_state = null
	sprite_sheets = ALL_VR_SPRITE_SHEETS_HEAD_MOB
	sprite_sheets_obj = ALL_VR_SPRITE_SHEETS_HEAD_ITEM

// Alt pilot suit
/obj/item/clothing/suit/space/void/pilot/alt2
	desc = "A surplus Solgov pilot voidsuit! Slightly more comfortable and easier to move in than your average voidsuit."

	icon = 'icons/inventory/suit/item_vr.dmi'
	default_worn_icon = 'icons/inventory/suit/mob_vr.dmi'
	icon_state = "void_pilot_bay"
	item_state = null
	sprite_sheets = ALL_VR_SPRITE_SHEETS_SUIT_MOB
	sprite_sheets_obj = ALL_VR_SPRITE_SHEETS_SUIT_ITEM
	slowdown = 0

/obj/item/clothing/head/helmet/space/void/pilot/alt2
	desc = "A surplus Solgov voidsuit helmet. Seems more fancy than what's usually found on the frontier."

	icon = 'icons/inventory/head/item_vr.dmi'
	default_worn_icon = 'icons/inventory/head/mob_vr.dmi'
	icon_state = "void_pilot_bay"
	item_state = null
	sprite_sheets = ALL_VR_SPRITE_SHEETS_HEAD_MOB
	sprite_sheets_obj = ALL_VR_SPRITE_SHEETS_HEAD_ITEM

// Alt medical/emt suit
/obj/item/clothing/suit/space/void/medical/alt2
	desc = "A surplus Solgov medical voidsuit! Slightly more comfortable and easier to move in than your average voidsuit."

	icon = 'icons/inventory/suit/item_vr.dmi'
	default_worn_icon = 'icons/inventory/suit/mob_vr.dmi'
	icon_state = "void_medicalalt_bay"
	item_state = null
	sprite_sheets = ALL_VR_SPRITE_SHEETS_SUIT_MOB
	sprite_sheets_obj = ALL_VR_SPRITE_SHEETS_SUIT_ITEM
	slowdown = 0

/obj/item/clothing/head/helmet/space/void/medical/alt2
	desc = "A surplus Solgov voidsuit helmet. Seems more fancy than what's usually found on the frontier."

	icon = 'icons/inventory/head/item_vr.dmi'
	default_worn_icon = 'icons/inventory/head/mob_vr.dmi'
	icon_state = "void_medicalalt_bay"
	item_state = null
	sprite_sheets = ALL_VR_SPRITE_SHEETS_HEAD_MOB
	sprite_sheets_obj = ALL_VR_SPRITE_SHEETS_HEAD_ITEM

// Alt explorer suit
/obj/item/clothing/suit/space/void/exploration/alt2
	desc = "A surplus Solgov exploration voidsuit! Slightly more comfortable and easier to move in than your average voidsuit."

	icon = 'icons/inventory/suit/item_vr.dmi'
	default_worn_icon = 'icons/inventory/suit/mob_vr.dmi'
	icon_state = "void_explorer_bay"
	item_state = null
	sprite_sheets = ALL_VR_SPRITE_SHEETS_SUIT_MOB
	sprite_sheets_obj = ALL_VR_SPRITE_SHEETS_SUIT_ITEM
	slowdown = 0

/obj/item/clothing/head/helmet/space/void/exploration/alt2
	desc = "A surplus Solgov voidsuit helmet. Seems more fancy than what's usually found on the frontier."

	icon = 'icons/inventory/head/item_vr.dmi'
	default_worn_icon = 'icons/inventory/head/mob_vr.dmi'
	icon_state = "void_explorer_bay"
	item_state = null
	sprite_sheets = ALL_VR_SPRITE_SHEETS_HEAD_MOB
	sprite_sheets_obj = ALL_VR_SPRITE_SHEETS_HEAD_ITEM

// Alt engineering voidsuit
/obj/item/clothing/suit/space/void/engineering/alt2
	desc = "A surplus Solgov engineering voidsuit! Slightly more comfortable and easier to move in than your average voidsuit."

	icon = 'icons/inventory/suit/item_vr.dmi'
	default_worn_icon = 'icons/inventory/suit/mob_vr.dmi'
	icon_state = "void_engineeringalt_bay"
	item_state = null
	sprite_sheets = ALL_VR_SPRITE_SHEETS_SUIT_MOB
	sprite_sheets_obj = ALL_VR_SPRITE_SHEETS_SUIT_ITEM
	slowdown = 0.5

/obj/item/clothing/head/helmet/space/void/engineering/alt2
	desc = "A surplus Solgov voidsuit helmet. Seems more fancy than what's usually found on the frontier."

	icon = 'icons/inventory/head/item_vr.dmi'
	default_worn_icon = 'icons/inventory/head/mob_vr.dmi'
	icon_state = "void_engineeringalt_bay"
	item_state = null
	sprite_sheets = ALL_VR_SPRITE_SHEETS_HEAD_MOB
	sprite_sheets_obj = ALL_VR_SPRITE_SHEETS_HEAD_ITEM

// Alt atmos voidsuit
/obj/item/clothing/suit/space/void/atmos/alt2
	desc = "A surplus Solgov atmospherics voidsuit! Slightly more comfortable and easier to move in than your average voidsuit."

	icon = 'icons/inventory/suit/item_vr.dmi'
	default_worn_icon = 'icons/inventory/suit/mob_vr.dmi'
	icon_state = "void_atmosalt_bay"
	item_state = null
	sprite_sheets = ALL_VR_SPRITE_SHEETS_SUIT_MOB
	sprite_sheets_obj = ALL_VR_SPRITE_SHEETS_SUIT_ITEM
	slowdown = 0.5

/obj/item/clothing/head/helmet/space/void/atmos/alt2
	desc = "A surplus Solgov voidsuit helmet. Seems more fancy than what's usually found on the frontier."

	icon = 'icons/inventory/head/item_vr.dmi'
	default_worn_icon = 'icons/inventory/head/mob_vr.dmi'
	icon_state = "void_atmosalt_bay"
	item_state = null
	sprite_sheets = ALL_VR_SPRITE_SHEETS_HEAD_MOB
	sprite_sheets_obj = ALL_VR_SPRITE_SHEETS_HEAD_ITEM

// Alt command voidsuit
/obj/item/clothing/suit/space/void/captain/alt
	desc = "A surplus Solgov Navy captain voidsuit! Slightly more comfortable and easier to move in than your average voidsuit."

	icon = 'icons/inventory/suit/item_vr.dmi'
	default_worn_icon = 'icons/inventory/suit/mob_vr.dmi'
	icon_state = "void_command_bay"
	item_state = null
	sprite_sheets = ALL_VR_SPRITE_SHEETS_SUIT_MOB
	sprite_sheets_obj = ALL_VR_SPRITE_SHEETS_SUIT_ITEM
	slowdown = 1.0

/obj/item/clothing/head/helmet/space/void/captain/alt
	desc = "A surplus Solgov voidsuit helmet. Seems more fancy than what's usually found on the frontier."

	icon = 'icons/inventory/head/item_vr.dmi'
	default_worn_icon = 'icons/inventory/head/mob_vr.dmi'
	icon_state = "void_command_bay"
	item_state = null
	sprite_sheets = ALL_VR_SPRITE_SHEETS_HEAD_MOB
	sprite_sheets_obj = ALL_VR_SPRITE_SHEETS_HEAD_ITEM
	camera_networks = list(NETWORK_COMMAND)
// CHOMPStation Edit End
