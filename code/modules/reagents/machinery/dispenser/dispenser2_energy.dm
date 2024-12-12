
/obj/machinery/chemical_dispenser
	var/_recharge_reagents = 1
	var/list/dispense_reagents = list()
	var/process_tick = 0

/obj/machinery/chemical_dispenser/process()
	if(!_recharge_reagents)
		return
	if(stat & (BROKEN|NOPOWER))
		return
	if(--process_tick <= 0)
		process_tick = 15
		. = 0
		for(var/id in dispense_reagents)
			var/datum/reagent/R = SSchemistry.chemical_reagents[id]
			if(!R)
				stack_trace("[src] at [x],[y],[z] failed to find reagent '[id]'!")
				dispense_reagents -= id
				continue
			var/obj/item/reagent_containers/chem_disp_cartridge/C = cartridges[R.name]
			if(C && C.reagents.total_volume < C.reagents.maximum_volume)
				var/to_restore = min(C.reagents.maximum_volume - C.reagents.total_volume, 5)
				use_power(to_restore * 500)
				C.reagents.add_reagent(id, to_restore)
				. = 1
		if(.)
			SStgui.update_uis(src)

/obj/machinery/chemical_dispenser
	dispense_reagents = list(
		REAGENT_ID_HYDROGEN, REAGENT_ID_LITHIUM, REAGENT_ID_CARBON, REAGENT_ID_NITROGEN, REAGENT_ID_OXYGEN, REAGENT_ID_FLUORINE, REAGENT_ID_SODIUM,
		REAGENT_ID_ALUMINIUM, REAGENT_ID_SILICON, REAGENT_ID_PHOSPHORUS, REAGENT_ID_SULFUR, REAGENT_ID_CHLORINE, REAGENT_ID_POTASSIUM, REAGENT_ID_IRON,
		REAGENT_ID_COPPER, REAGENT_ID_MERCURY, REAGENT_ID_RADIUM, REAGENT_ID_WATER, REAGENT_ID_ETHANOL, REAGENT_ID_SUGAR, REAGENT_ID_SACID, REAGENT_ID_TUNGSTEN,
		REAGENT_ID_CALCIUM
		)

/obj/machinery/chemical_dispenser/ert
	dispense_reagents = list(
		REAGENT_ID_INAPROVALINE, REAGENT_ID_RYETALYN, REAGENT_ID_PARACETAMOL, REAGENT_ID_TRAMADOL, REAGENT_ID_OXYCODONE, REAGENT_ID_STERILIZINE, REAGENT_ID_LEPORAZINE,
		REAGENT_ID_KELOTANE, REAGENT_ID_DERMALINE, REAGENT_ID_DEXALIN, REAGENT_ID_DEXALINP, REAGENT_ID_TRICORDRAZINE, REAGENT_ID_ANTITOXIN, REAGENT_ID_SYNAPTIZINE,
		REAGENT_ID_HYRONALIN, REAGENT_ID_ARITHRAZINE, REAGENT_ID_ALKYSINE, REAGENT_ID_IMIDAZOLINE, REAGENT_ID_PERIDAXON, REAGENT_ID_BICARIDINE, REAGENT_ID_HYPERZINE,
		REAGENT_ID_REZADONE, REAGENT_ID_SPACEACILLIN, REAGENT_ID_ETHYLREDOXRAZINE, REAGENT_ID_STOXIN, REAGENT_ID_CHLORALHYDRATE, REAGENT_ID_CRYOXADONE,
		REAGENT_ID_CLONEXADONE
		)

/obj/machinery/chemical_dispenser/bar_soft
	dispense_reagents = list(
<<<<<<< HEAD
		"water", "ice", "coffee", "cream", "tea", "icetea", "cola", "spacemountainwind", "dr_gibb", "space_up", "tonic",
		"sodawater", "lemonjuice", "lemon_lime", "sugar", "orangejuice", "limejuice", "watermelonjuice", "thirteenloko", "grapesoda"
=======
		REAGENT_ID_WATER, REAGENT_ID_ICE, REAGENT_ID_COFFEE, REAGENT_ID_CREAM, REAGENT_ID_TEA, REAGENT_ID_ICETEA, REAGENT_ID_COLA, REAGENT_ID_SPACEMOUNTAINWIND, REAGENT_ID_DRGIBB, REAGENT_ID_SPACEUP, REAGENT_ID_TONIC,
		REAGENT_ID_SODAWATER, REAGENT_ID_LEMONJUICE, REAGENT_ID_LEMONLIME, REAGENT_ID_SUGAR, REAGENT_ID_ORANGEJUICE, REAGENT_ID_LIMEJUICE, REAGENT_ID_WATERMELONJUICE,REAGENT_ID_THIRTEENLOKO, REAGENT_ID_GRAPESODA, REAGENT_ID_PINEAPPLEJUICE
>>>>>>> fd5d9267ff ([MIRROR] Converts gas, ore, plants and reagent strings to defines (#9611))
		)

/obj/machinery/chemical_dispenser/bar_alc
	dispense_reagents = list(
		REAGENT_ID_LEMONLIME, REAGENT_ID_SUGAR, REAGENT_ID_ORANGEJUICE, REAGENT_ID_LIMEJUICE, REAGENT_ID_SODAWATER, REAGENT_ID_TONIC, REAGENT_ID_BEER, REAGENT_ID_KAHLUA,
		REAGENT_ID_WHISKEY, REAGENT_ID_REDWINE, REAGENT_ID_WHITEWINE, REAGENT_ID_VODKA, REAGENT_ID_CIDER, REAGENT_ID_GIN, REAGENT_ID_RUM, REAGENT_ID_TEQUILLA, REAGENT_ID_VERMOUTH, REAGENT_ID_COGNAC, REAGENT_ID_ALE, REAGENT_ID_MEAD, REAGENT_ID_BITTERS
		)

/obj/machinery/chemical_dispenser/bar_coffee
	dispense_reagents = list(
<<<<<<< HEAD
		"coffee", "cafe_latte", "soy_latte", "hot_coco", "milk", "cream", "tea", "ice",
		"orangejuice", "lemonjuice", "limejuice", "berryjuice", "mint", "decaf", "greentea"
=======
		REAGENT_ID_COFFEE, REAGENT_ID_CAFELATTE, REAGENT_ID_SOYLATTE, REAGENT_ID_HOTCOCO, REAGENT_ID_MILK, REAGENT_ID_CREAM, REAGENT_ID_TEA, REAGENT_ID_ICE, REAGENT_ID_WATER,
		REAGENT_ID_ORANGEJUICE, REAGENT_ID_LEMONJUICE, REAGENT_ID_LIMEJUICE, REAGENT_ID_BERRYJUICE, REAGENT_ID_MINT, REAGENT_ID_DECAF, REAGENT_ID_GREENTEA, REAGENT_ID_MILKFOAM, REAGENT_ID_DRIPCOFFEE
		)

/obj/machinery/chemical_dispenser/bar_syrup
	dispense_reagents = list(
		REAGENT_ID_SYRUPPUMPKIN, REAGENT_ID_SYRUPCARAMEL, REAGENT_ID_SYRUPSALTEDCARAMEL, REAGENT_ID_SYRUPIRISH, REAGENT_ID_SYRUPALMOND, REAGENT_ID_SYRUPCINNAMON, REAGENT_ID_SYRUPPISTACHIO,
		REAGENT_ID_SYRUPVANILLA, REAGENT_ID_SYRUPTOFFEE, REAGENT_ID_GRENADINE, REAGENT_ID_SYRUPCHERRY, REAGENT_ID_SYRUPBUTTERSCOTCH, REAGENT_ID_SYRUPCHOCOLATE, REAGENT_ID_SYRUPWHITECHOCOLATE, REAGENT_ID_SYRUPSTRAWBERRY,
		REAGENT_ID_SYRUPCOCONUT, REAGENT_ID_SYRUPGINGER, REAGENT_ID_SYRUPGINGERBREAD, REAGENT_ID_SYRUPPEPPERMINT, REAGENT_ID_SYRUPBIRTHDAY
>>>>>>> fd5d9267ff ([MIRROR] Converts gas, ore, plants and reagent strings to defines (#9611))
		)
