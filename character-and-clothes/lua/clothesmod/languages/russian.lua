----- DO NOT TOUCH THAT -----
----- DO NOT TOUCH THAT -----
----- DO NOT TOUCH THAT -----
local function GetCurrentLuaFile()
    local source = debug.getinfo(2, "S").source

    if source:sub(1, 1) == "@" then
        return source:sub(2)
    else
        error("Caller was not defined in a file", 2)
    end
end

local function GetCurrentLuaFileName()
    local luafile = GetCurrentLuaFile()
    local split = string.Split(luafile, "/")

    return split[#split]
end

local filename_wl = GetCurrentLuaFileName()
local filename = string.Replace(filename_wl, ".lua")
-------------------------------
CLOTHESMOD.Config.Sentences[1][filename] = "Добавить"
CLOTHESMOD.Config.Sentences[2][filename] = "Издание изображений"
CLOTHESMOD.Config.Sentences[3][filename] = "Образ"
CLOTHESMOD.Config.Sentences[4][filename] = "Удалить"
CLOTHESMOD.Config.Sentences[5][filename] = "Издание текстов"
CLOTHESMOD.Config.Sentences[6][filename] = "Текст"
CLOTHESMOD.Config.Sentences[7][filename] = "Выбери свою футболку"
CLOTHESMOD.Config.Sentences[8][filename] = "Создай свою футболку"
CLOTHESMOD.Config.Sentences[9][filename] = "Хотите создать эту футболку на заказ?"
CLOTHESMOD.Config.Sentences[10][filename] = "Ошибка"
CLOTHESMOD.Config.Sentences[11][filename] = "Вы должны настроить футболку"
CLOTHESMOD.Config.Sentences[12][filename] = "Это имя уже занято"
CLOTHESMOD.Config.Sentences[13][filename] = "Создать"
CLOTHESMOD.Config.Sentences[14][filename] = "Выбери свои брюки"
CLOTHESMOD.Config.Sentences[15][filename] = "ИЗМЕНИТЬ"
CLOTHESMOD.Config.Sentences[16][filename] = "СПИСОК ОДЕЖДЫ"
CLOTHESMOD.Config.Sentences[17][filename] = "Корзина"
CLOTHESMOD.Config.Sentences[18][filename] = "Всего"
CLOTHESMOD.Config.Sentences[19][filename] = "ЗАКРЫТЬ"
CLOTHESMOD.Config.Sentences[20][filename] = "Магазин"
CLOTHESMOD.Config.Sentences[21][filename] = "Добавить в корзину"
CLOTHESMOD.Config.Sentences[22][filename] = "Вы уже владеете этим"
CLOTHESMOD.Config.Sentences[23][filename] = "КУПИТЬ"
CLOTHESMOD.Config.Sentences[24][filename] = "Индивидуальные"
CLOTHESMOD.Config.Sentences[25][filename] = "Снять свою одежду"
CLOTHESMOD.Config.Sentences[26][filename] = "Бросить рубашку"
CLOTHESMOD.Config.Sentences[27][filename] = "Бросить нижние штаны"
CLOTHESMOD.Config.Sentences[28][filename] = "Добро пожаловать"
CLOTHESMOD.Config.Sentences[29][filename] = "+"
CLOTHESMOD.Config.Sentences[30][filename] = "ОБРАТНО"
CLOTHESMOD.Config.Sentences[31][filename] = "Выберите свое имя"
CLOTHESMOD.Config.Sentences[32][filename] = "Выберите свой пол"
CLOTHESMOD.Config.Sentences[33][filename] = "Выберите цвет ваших глаз"
CLOTHESMOD.Config.Sentences[34][filename] = "Выбери свою голову"
CLOTHESMOD.Config.Sentences[35][filename] = "+"
CLOTHESMOD.Config.Sentences[36][filename] = "Вы не можете сделать это в этой работе."
CLOTHESMOD.Config.Sentences[37][filename] = "У вас нет верхней рубашки"
CLOTHESMOD.Config.Sentences[38][filename] = "У вас нет нижних штанов"
CLOTHESMOD.Config.Sentences[39][filename] = "Вы сняли свою верхнюю рубашку"
CLOTHESMOD.Config.Sentences[40][filename] = "Вы сбросили нижние штаны"
CLOTHESMOD.Config.Sentences[41][filename] = "Вам не хватает денег!"
CLOTHESMOD.Config.Sentences[42][filename] = "Вы прошли операцию"
CLOTHESMOD.Config.Sentences[43][filename] = "Ваша одежда куплена и теперь находится в вашем гардеробе"
CLOTHESMOD.Config.Sentences[44][filename] = "Ваша футболка куплена и теперь находится в вашем гардеробе"
CLOTHESMOD.Config.Sentences[45][filename] = "Вы переоделись"
CLOTHESMOD.Config.Sentences[46][filename] = "Это уже ваше имя!"
CLOTHESMOD.Config.Sentences[47][filename] = "Ваше имя было изменено!"
CLOTHESMOD.Config.Sentences[48][filename] = "Ваш персонаж создан!"
CLOTHESMOD.Config.Sentences[49][filename] = "Гардероб"
CLOTHESMOD.Config.Sentences[50][filename] = "Эта одежда для другого пола"
CLOTHESMOD.Config.Sentences[51][filename] = "Продавец одежды"
CLOTHESMOD.Config.Sentences[52][filename] = "Хирург"
CLOTHESMOD.Config.Sentences[53][filename] = "Примечание: если вы смените пол, вся ваша одежда в вашем гардеробе будет удалена!"
CLOTHESMOD.Config.Sentences[54][filename] = "Оплатить операцию"
CLOTHESMOD.Config.Sentences[55][filename] = "Хотите получить этот вид?"
CLOTHESMOD.Config.Sentences[56][filename] = "Это будет стоить"
CLOTHESMOD.Config.Sentences[57][filename] = "Вы ничего не изменили"
CLOTHESMOD.Config.Sentences[58][filename] = "Оплатить"
CLOTHESMOD.Config.Sentences[59][filename] = "Здравствуйте, вы хотите изменить свой"
CLOTHESMOD.Config.Sentences[60][filename] = "появление у пластических хирургов?"
CLOTHESMOD.Config.Sentences[61][filename] = "ДА!"
CLOTHESMOD.Config.Sentences[62][filename] = "НЕТ, СПАСИБО!"
CLOTHESMOD.Config.Sentences[63][filename] = "Изменить свое имя"
CLOTHESMOD.Config.Sentences[64][filename] = "Хотите изменить свое имя?"
CLOTHESMOD.Config.Sentences[65][filename] = "+"
CLOTHESMOD.Config.Sentences[66][filename] = "Купить индивидуальную футболку"
CLOTHESMOD.Config.Sentences[67][filename] = "Купить футболку"
CLOTHESMOD.Config.Sentences[68][filename] = "Ваше имя и ваше фамилие должны содержать не менее 3 символов"
CLOTHESMOD.Config.Sentences[69][filename] = "Там нет свободных кроватей. Повторите попытку позже."
CLOTHESMOD.Config.Sentences[70][filename] = "РУБАШКИ" -- Cats
CLOTHESMOD.Config.Sentences[71][filename] = "БРЮКИ" -- Cats
CLOTHESMOD.Config.Sentences[72][filename] = "НАРЯДЫ" -- Cats
CLOTHESMOD.Config.Sentences[73][filename] = "СОХРАНИТЬ ОБОРУДОВАНИЕ" -- Cats