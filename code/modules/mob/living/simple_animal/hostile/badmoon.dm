/mob/living/simple_animal/hostile/geist
	name = "creature"
	desc = "A monstrous being, its titanic form casts a large shadow. A mix of malice and intelligent can be seen on its eyes."
	speak_emote = list("roars")
	icon = 'icons/obj/geist.dmi'
	icon_state = "geist"
	icon_living = "geist"
	icon_dead = "geist_dead"
	icon_rest = "geist_rest"
	stop_automated_movement = TRUE
	universal_speak = TRUE
	universal_understand = TRUE

	mob_swap_flags = HUMAN|SIMPLE_ANIMAL|SLIME|MONKEY
	mob_push_flags = ALLMOBS


	tameable = FALSE

	speed = -2

	response_help  = "pets"
	response_disarm = "shoves"
	response_harm   = "harmlessly punches"
	maxHealth = 800
	health = 800
	harm_intent_damage = 0
	melee_damage_lower = 45
	melee_damage_upper = 45
	mob_size = 50
	environment_smash = 2
	attacktext = "mauled"

	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	sight = SEE_MOBS

	butchering_products = list(/obj/item/stack/material/animalhide = 4)
	meat_type = /obj/item/reagent_containers/food/snacks/meat/adhomai
	meat_amount = 15

	attack_sound = 'sound/effects/creatures/demon_attack.ogg'

	pixel_x = -16
	pixel_y = 0

	layer = 5

	var/is_devouring = FALSE
	var/has_regen = TRUE

/mob/living/simple_animal/hostile/geist/examine(mob/user)
	. = ..()
	if(istajara(user))
		to_chat(user, ("Its description matches the tales about cavern geists."))
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.religion == RELIGION_RASKARA)
				to_chat(user, SPAN_CULT("Death walks among the living. Its champion is here."))


/mob/living/simple_animal/hostile/geist/Life()
	..()
	if(has_regen)
		if (getBruteLoss() > 0)
			if(prob(25))
				adjustBruteLoss(-50)
				visible_message("<span class='danger'>\The [src]'s wounds regenerates quickly!</span>")

	sight |= SEE_MOBS

/mob/living/simple_animal/hostile/geist/verb/geist_devour(mob/living/target as mob in oview())
	set category = "Geist"
	set name = "Devour"
	set desc = "Devours a creature, destroying its body and regenerating health."

	if(!Adjacent(target))
		return

	if(target.isSynthetic())
		return

	if(src.is_devouring)
		to_chat(src, "<span class='warning'>We are already feasting on something!</span>")
		return 0

	if(!health)
		to_chat(src, "<span class='notice'>We are dead, we cannot use any abilities!</span>")
		return

	if(last_special > world.time)
		to_chat(src, "<span class='warning'>We must wait a little while before we can use this ability again!</span>")
		return

	src.visible_message("<span class='warning'>[src] begins ripping apart and feasting on [target]!</span>")
	src.is_devouring = TRUE

	target.adjustBruteLoss(50)

	if(!do_after(src,150))
		to_chat(src, "<span class='warning'>You need to wait longer to devour \the [target]!</span>")
		src.is_devouring = FALSE
		return 0

	src.visible_message("<span class='warning'>[src] tears a chunk from \the [target]'s flesh!</span>")

	target.adjustBruteLoss(50)

	if(!do_after(src,150))
		to_chat(src, "<span class='warning'>You need to wait longer to devour \the [target]!</span>")
		src.is_devouring = FALSE
		return 0

	src.visible_message("<span class='warning'>[target] is completely devoured by [src]!</span>", \
						"<span class='danger'>You completely devour \the [target]!</span>")
	target.gib()
	rejuvenate()
	updatehealth()
	last_special = world.time + 100
	src.is_devouring = FALSE
	return


/mob/living/simple_animal/hostile/wind_devil
	name = "sham'tyr"
	desc = "A flying adhomian creature, known for their loud wails that can be heard far below the clouds they soar above."
	icon = 'icons/obj/badmoon.dmi'
	icon_state = "devil"
	icon_living = "devil"
	icon_dead = "devil_dead"
	icon_rest = "devil_rest"
	turns_per_move = 3
	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"
	speed = -2
	maxHealth = 80
	health = 80
	mob_size = 10

	pass_flags = PASSTABLE

	harm_intent_damage = 5
	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = "bitten"
	attack_sound = 'sound/weapons/bite.ogg'

	environment_smash = 1

	faction = "geist"
	flying = TRUE
	butchering_products = list(/obj/item/stack/material/animalhide = 1)
	meat_type = /obj/item/reagent_containers/food/snacks/meat/adhomai
	meat_amount = 5
