Config = Config or {}

Config.IsSelling = false

Config.TrapHouse = {
    ['Code'] = 1111,
    ['Owner'] = '',
    ['Coords'] = {
        ['Enter'] = {
            ['X'] = 'Ga maar lekker zoeken..',
            ['Y'] = 'Ga maar lekker zoeken..',
            ['Z'] = 'Ga maar lekker zoeken..',
            ['H'] = 'Ga maar lekker zoeken..',
            ['Z-OffSet'] = 35.0,
        },
        ['Interact'] = {
            ['X'] = 'Ga maar lekker zoeken..',
            ['Y'] = 'Ga maar lekker zoeken..',
            ['Z'] = 'Ga maar lekker zoeken..',
        },
    },
}

Config.SellItems = {
 ['diamond-blue'] = {
   ['Type'] = 'money',
   ['Amount'] = math.random(4500, 7000),
 },
 ['diamond-red'] = {
   ['Type'] = 'money',
   ['Amount'] = math.random(4500, 7500),
 },
 ['markedbills'] = {
   ['Type'] = 'info',
   ['Amount'] = 0,
 },
}