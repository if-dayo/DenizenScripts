advancements_share:
    type: world
    debug: false
    events:
        after player completes advancement:
        - define advancement <context.advancement>
        - foreach <server.online_players.exclude[<player>]> as:target:
            - if <[target].has_advancement[<[advancement]>]>:
                - foreach next
            - execute as_server "advancement grant <[target].name> only <[advancement]>" silent
        after player joins:
        - wait 2s
        - run advancements_share_sync

        after server start:
        - run advancements_share_sync
        after reload scripts:
        - run advancements_share_sync

advancements_share_sync:
    type: task
    debug: false
    script:
    - define players <server.online_players>
    - if <[players].size> < 2:
        - stop
    - foreach <[players]> as:source:
        - define others <[players].exclude[<[source]>]>
        - foreach <[source].advancements> as:advancement:
            - foreach <[others]> as:target:
                - if <[target].has_advancement[<[advancement]>]>:
                    - foreach next
                - execute as_server "advancement grant <[target].name> only <[advancement]>" silent
        - wait 1t
