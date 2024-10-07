extends Node

@onready var jump_sfx = $jumpSFX
@onready var slide_sfx = $slideSFX
@onready var die_sfx = $dieSFX
@onready var shoot_sfx = $shooterSFX
@onready var spring_sfx = $springSFX
@onready var spike_sfx = $spikeSFX
@onready var key_sfx = $KeyPickedUpSFX
@onready var unlock_sfx = $UnlockedSFX
@onready var level_complete_sfx = $LevelCompleteSFX


# Plays the sound effect only if it is not currently playing
func play_sfx(sfx: AudioStreamPlayer):
	if not sfx.is_playing():
		sfx.play()

# Example usage:
func play_jump_sfx():
	play_sfx(jump_sfx)

func play_slide_sfx():
	play_sfx(slide_sfx)

func play_die_sfx():
	play_sfx(die_sfx)

func play_shoot_sfx():
	play_sfx(shoot_sfx)

func play_spring_sfx():
	play_sfx(spring_sfx)

func play_spike_sfx():
	play_sfx(spike_sfx) 

func play_lvl_complete_sfx():
	play_sfx(level_complete_sfx)

func play_key_sfx():
	play_sfx(key_sfx)
	
func play_unlock_sfx():
	play_sfx(unlock_sfx)
