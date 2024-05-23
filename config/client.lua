return {
    --- Enables the drunk sound mode, something extra i guess
    useDrunkSoundMode = true,
    --- delay in ms before the effect is first applied
    delayEffect = 15000,
    effect = {
        severitySteps = {
            [0.5] = {
                --- timecycle modifier to apply
                timecycle = 'Drunk',
                --- shake severity
                shake = 0.25,
                --- walk style to apply
                walk = 'move_m@drunk@slightlydrunk'
            },
            [2.0] = {
                timecycle = 'Drunk',
                shake = 0.75,
                walk = 'move_m@drunk@moderatedrunk'
            },
            [3.0] = {
                timecycle = 'spectator5',
                shake = 1.25,
                walk = 'move_m@drunk@a'
            },
            [4.0] = {
                timecycle = 'spectator5',
                shake = 2.0,
                walk = 'MOVE_M@DRUNK@VERYDRUNK'
            },
        },
    },
    --- whether to enable the ethyl coma feature
    ethylComa = true,
    --- alcohol level at which the player will die from ethyl coma
    ethylComaValue = 5.0
}