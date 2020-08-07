/obj/item/gun/projectile/automatic/rifle/adhomian
	name = "adhomian automatic rifle"
	desc = "The Tsarrayut'yan rifle is a select-fire, crew-served automatic rifle producted by the People's Republic of Adhomai."
	icon = 'icons/obj/badmoon.dmi'
	icon_state = "tsarrayut"
	item_state = "tsarrayut"
	contained_sprite = TRUE

	load_method = SINGLE_CASING|SPEEDLOADER

	ammo_type = /obj/item/ammo_casing/a762
	allowed_magazines = null
	magazine_type = null
	max_shells = 25

	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/gunshot/gunshot_rifle.ogg'

	is_wieldable = TRUE

/obj/item/gun/projectile/automatic/rifle/adhomian/update_icon()
	if(wielded)
		item_state = "tsarrayut-wielded"
	else
		item_state = "tsarrayut"
	update_held_icon()

/obj/item/gun/projectile/revolver/detective/knife
	name = "knife-revolver"
	desc = "An adhomian revolver with a blade attached to its barrel."
	icon = 'icons/obj/badmoon.dmi'
	icon_state = "knifegun"
	item_state = "knifegun"
	force = 20
	sharp = TRUE
	edge = TRUE

/obj/item/gun/projectile/musket
	name = "adhomian musket"
	desc = "A rustic firearm, used by Tajaran soldiers during the adhomian gunpowder age"
	icon = 'icons/obj/badmoon.dmi'
	icon_state = "musket"
	item_state = "musket"
	contained_sprite = TRUE

	load_method = SINGLE_CASING
	handle_casings = DELETE_CASINGS

	max_shells = 1

	caliber = "musket"

	slot_flags = SLOT_BACK

	is_wieldable = TRUE

	needspin = FALSE

	w_class = ITEMSIZE_LARGE

	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/gunshot/gunshot_rifle.ogg'

	fire_delay = 35
	fire_sound = 'sound/weapons/gunshot/musket.ogg'
	recoil = 4

	var/has_powder = FALSE

/obj/item/gun/projectile/musket/update_icon()
	if(wielded)
		item_state = "musket-wielded"
	else
		item_state = "musket"
	update_held_icon()

/obj/item/gun/projectile/musket/special_check(mob/user)
	if(!has_powder)
		to_chat(user, "<span class='warning'>\The [src] has no gunpowder!</span>")
		return 0

	if(!wielded)
		to_chat(user, "<span class='warning'>You can't fire without stabilizing \the [src]!</span>")
		return 0

	var/datum/effect/effect/system/smoke_spread/smoke = new /datum/effect/effect/system/smoke_spread()
	smoke.set_up(3, 0, user.loc)
	smoke.start()
	has_powder = FALSE
	return ..()

/obj/item/gun/projectile/musket/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if (istype(W, /obj/item/reagent_containers))
		if(has_powder)
			to_chat(user, "<span class='notice'>\The [src] is already full of gunpowder.</span>")
			return
		var/obj/item/reagent_containers/C = W
		if(C.reagents.has_reagent(/datum/reagent/gunpowder, 5))
			if(do_after(user, 15))
				if(has_powder)
					return
				C.reagents.remove_reagent(/datum/reagent/gunpowder, 5)
				has_powder = TRUE
				to_chat(user, "<span class='notice'>You fill \the [src] with gunpowder.</span>")

/obj/item/ammo_casing/musket
	name = "lead ball"
	desc = "A lead ball."
	icon = 'icons/obj/badmoon.dmi'
	icon_state = "musketball"
	caliber = "musket"
	projectile_type = /obj/item/projectile/bullet/musket

/obj/item/projectile/bullet/musket
	name = "lead ball"
	damage = 60

/obj/item/projectile/bullet/musket/on_impact(var/atom/A)
	if(istype(A, /mob/living/simple_animal/hostile/geist))
		var/mob/living/simple_animal/hostile/geist/W = A
		W.has_regen = FALSE
		W.visible_message("<span class='danger'>\The [W]'s flesh burns and sizzles at the impact of \the [src].</span>")
	..()

/obj/item/reagent_containers/powder_horn
	name = "powder horn"
	desc = "An ivory container for gunpowder."
	icon = 'icons/obj/badmoon.dmi'
	icon_state = "powderhorn"
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5)
	volume = 30
	reagents_to_add = list(/datum/reagent/gunpowder = 30)

/datum/reagent/gunpowder
	name = "Gunpowder"
	description = "A primitive explosive chemical."
	reagent_state = SOLID
	color = "#1C1300"
	ingest_met = REM * 5
	taste_description = "sour chalk"
	taste_mult = 1.5
	fallback_specific_heat = 0.018