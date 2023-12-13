-- Function to initialize all global variables
function initialize_globals()
    -- All global accessable variables will be stored in this table
    global.DTO = {}

    -- A list with all different cards
    global.DTO.cards = {}

    -- A list with all the equiped cards
    global.DTO.equiped_cards = {}

    -- A list with all the cards that are in the players inventory
    global.DTO.inventory_cards = {}

    -- A list of GUI's
    global.DTO.gui = {}
end

initialize_globals()