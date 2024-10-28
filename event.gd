extends Node

@warning_ignore("unused_signal")
signal enemy_tower_destroyed
@warning_ignore("unused_signal")
signal enemy_tower_health_changed(value: int)
@warning_ignore("unused_signal")
signal player_tower_destroyed
@warning_ignore("unused_signal")
signal player_tower_health_changed(value: int)
@warning_ignore("unused_signal")
signal resource_amount_changed(value: int)

@warning_ignore("unused_signal")
signal game_ended(win: bool)
@warning_ignore("unused_signal")
signal enemy_creature_died(value: int)
