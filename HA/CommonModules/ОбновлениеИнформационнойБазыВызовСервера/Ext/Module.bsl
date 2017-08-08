﻿////////////////////////////////////////////////////////////////////////////////
// Обноление базы при переходе на новый релтз
//
////////////////////////////////////////////////////////////////////////////////

Процедура ЗапуститьОбновление() Экспорт
	
	ПервоначальноеЗаполнениеБазы();
	Константы.ПервоначальноеЗаполнениеПройдено.Установить(Истина);
	
	Версия = Метаданные.Версия;
	// Однократные обработчики
	Если СравнитьВерсии("0.8", Версия) = 0 Тогда
		ПереходНаВерсию_0_8();
	КонецЕсли;
	
КонецПроцедуры

Функция ЭтоПервыйЗапуск() Экспорт
	Возврат Не Константы.ПервоначальноеЗаполнениеПройдено.Получить();
КонецФункции

#Область ПервоначальноеЗаполнение

Процедура ПервоначальноеЗаполнениеБазы() Экспорт
	
	УстановкаЕдиницИзмХарактеристик();
	
	УстановкаПредпределенныхФормул();
	
	УстановкаПредопределенныхДеталей();
	
	Константы.КаталогФото.Установить("\storage\sdcard0\DCIM\Camera");
	Константы.КаталогКартинок.Установить("sdcard/Pictures/");
	
КонецПроцедуры

Процедура УстановкаЕдиницИзмХарактеристик()

	// Дозаполнение предопределенных единиц измерения. 
	
	Штука = Справочники.КлассификаторЕдиницИзмерения.ЕдиницаИзмеренияПоКоду("796",,, Истина);
	
	ДюймКв = Справочники.КлассификаторЕдиницИзмерения.ЕдиницаИзмеренияПоКоду("071",,, Истина);
	ФутКв = Справочники.КлассификаторЕдиницИзмерения.ЕдиницаИзмеренияПоКоду("073",,, Истина);
	ЯрдКв = Справочники.КлассификаторЕдиницИзмерения.ЕдиницаИзмеренияПоКоду("075",,, Истина);
	
	Миллиметр = Справочники.КлассификаторЕдиницИзмерения.ЕдиницаИзмеренияПоКоду("003",,, Истина);
	Сантиметр = Справочники.КлассификаторЕдиницИзмерения.ЕдиницаИзмеренияПоКоду("004",,, Истина);
	Дюйм = Справочники.КлассификаторЕдиницИзмерения.ЕдиницаИзмеренияПоКоду("039",,, Истина);
	Метр = Справочники.КлассификаторЕдиницИзмерения.ЕдиницаИзмеренияПоКоду("006",,, Истина);
	Километр = Справочники.КлассификаторЕдиницИзмерения.ЕдиницаИзмеренияПоКоду("008",,, Истина);
	Фут = Справочники.КлассификаторЕдиницИзмерения.ЕдиницаИзмеренияПоКоду("041",,, Истина);
	Ярд = Справочники.КлассификаторЕдиницИзмерения.ЕдиницаИзмеренияПоКоду("043",,, Истина);
	
	МиллиметрКуб = Справочники.КлассификаторЕдиницИзмерения.ЕдиницаИзмеренияПоКоду("110",,, Истина);
	СантиметрКуб = Справочники.КлассификаторЕдиницИзмерения.ЕдиницаИзмеренияПоКоду("111",,, Истина);
	МетрКуб = Справочники.КлассификаторЕдиницИзмерения.ЕдиницаИзмеренияПоКоду("113",,, Истина);
	Литр = Справочники.КлассификаторЕдиницИзмерения.ЕдиницаИзмеренияПоКоду("112",,, Истина);
	
	МиллиметрКв = Справочники.КлассификаторЕдиницИзмерения.ЕдиницаИзмеренияПоКоду("050",,, Истина);
	СантиметрКв = Справочники.КлассификаторЕдиницИзмерения.ЕдиницаИзмеренияПоКоду("051",,, Истина);
	КилометрКв = Справочники.КлассификаторЕдиницИзмерения.ЕдиницаИзмеренияПоКоду("061",,, Истина);
	МетрКв = Справочники.КлассификаторЕдиницИзмерения.ЕдиницаИзмеренияПоКоду("055",,, Истина);
	
	Килограмм = Справочники.КлассификаторЕдиницИзмерения.ЕдиницаИзмеренияПоКоду("166",,, Истина);
	Миллиграмм = Справочники.КлассификаторЕдиницИзмерения.ЕдиницаИзмеренияПоКоду("161",,, Истина);
	Грамм = Справочники.КлассификаторЕдиницИзмерения.ЕдиницаИзмеренияПоКоду("163",,, Истина);
	Тонна = Справочники.КлассификаторЕдиницИзмерения.ЕдиницаИзмеренияПоКоду("168",,, Истина);
	
	Треб = ОбщегоНазначения.НайтиСоздатьПредопределенныйЭлемент("Справочник.КлассификаторЕдиницИзмерения.Треб");
	
	//Порядок имеет значение, т.к. ед. физ характеристики ищется по концу имени
	СписокЕдИзм = Новый Массив;
	СписокЕдИзм.Добавить(Миллиметр);
	СписокЕдИзм.Добавить(Сантиметр);
	СписокЕдИзм.Добавить(Километр);
	СписокЕдИзм.Добавить(Метр);
	СписокЕдИзм.Добавить(Фут);
	СписокЕдИзм.Добавить(Ярд);
	СписокЕдИзм.Добавить(ЯрдКв);
	СписокЕдИзм.Добавить(Дюйм);
	СписокЕдИзм.Добавить(ДюймКв);
	СписокЕдИзм.Добавить(МиллиметрКв);
	СписокЕдИзм.Добавить(СантиметрКв);
	СписокЕдИзм.Добавить(КилометрКв);
	СписокЕдИзм.Добавить(МетрКв);
	СписокЕдИзм.Добавить(ФутКв);
	СписокЕдИзм.Добавить(МиллиметрКуб);
	СписокЕдИзм.Добавить(СантиметрКуб);
	СписокЕдИзм.Добавить(МетрКуб);
	СписокЕдИзм.Добавить(Литр);
	СписокЕдИзм.Добавить(Килограмм);
	СписокЕдИзм.Добавить(Миллиграмм);
	СписокЕдИзм.Добавить(Грамм);
	СписокЕдИзм.Добавить(Штука);
	СписокЕдИзм.Добавить(Тонна);
	СписокЕдИзм.Добавить(треб);
	
	СписокРодителей = Новый Массив;
	СписокРодителей.Добавить(Справочники.ФизическиеХарактеристики.Длина);
	СписокРодителей.Добавить(Справочники.ФизическиеХарактеристики.Ширина);
	СписокРодителей.Добавить(Справочники.ФизическиеХарактеристики.Высота);
	СписокРодителей.Добавить(Справочники.ФизическиеХарактеристики.Прочие);
	СписокРодителей.Добавить(Справочники.ФизическиеХарактеристики.Угол);
	
	Для каждого ЕдИзм Из СписокЕдИзм Цикл
		ЕдИзмОб = ЕдИзм.ПолучитьОбъект();
		ЕдИзмОб.ТипХарактеристики = Перечисления.ТипыХарактеристик.ДробноеЧисло;
		ЕдИзмОб.Записать();
	КонецЦикла;
	
	ТребОб = Треб.ПолучитьОбъект();
	ТребОб.ТипХарактеристики = Перечисления.ТипыХарактеристик.Булево;
	ТребОб.НаименованиеПолное = НСтр("ru = 'Требуется'; en = 'Requires'");
	ТребОб.Записать();
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ФизическиеХарактеристики.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ФизическиеХарактеристики КАК ФизическиеХарактеристики
	|ГДЕ
	|	ФизическиеХарактеристики.Предопределенный = ИСТИНА
	|	И ФизическиеХарактеристики.ЭтоГруппа = ЛОЖЬ");
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ХарактеристикаОбъект = Выборка.Ссылка.ПолучитьОбъект();
		// Устанавливаем ед. измерения
		Для каждого ЕдиницаИзм Из СписокЕдИзм Цикл
			Если СтрЗаканчиваетсяНа(ХарактеристикаОбъект.ИмяПредопределенныхДанных, ЕдиницаИзм.Наименование) Тогда
				ХарактеристикаОбъект.ЕдиницаИзмерения = ЕдиницаИзм.Ссылка;
				ХарактеристикаОбъект.Записать();
				Прервать;
			ИначеЕсли Выборка.Ссылка = Справочники.ФизическиеХарактеристики.Угол_α Тогда
				ХарактеристикаОбъект.Наименование = "α";
				
				ХарактеристикаОбъект.ЕдиницаИзмерения = ОбщегоНазначения.НайтиСоздатьПредопределенныйЭлемент(
					"Справочник.КлассификаторЕдиницИзмерения.ГрадусУгла");
					
				ХарактеристикаОбъект.Записать();
				Прервать;
			КонецЕсли;
		КонецЦикла;
		// Устанавливаем родителя
		Для каждого Родитель Из СписокРодителей Цикл
			Если СтрНачинаетсяС(ХарактеристикаОбъект.ИмяПредопределенныхДанных, Родитель.Наименование) Тогда
				ХарактеристикаОбъект.Родитель = Родитель;
				ХарактеристикаОбъект.Записать();
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;

КонецПроцедуры

Процедура УстановкаПредпределенныхФормул()
	
	Sпрям = Справочники.Формулы.Sпрям.ПолучитьОбъект();
	Sпрям.Сокращение = Sпрям.ИмяПредопределенныхДанных;
	Sпрям.Формула = Справочники.ФизическиеХарактеристики.Длина.ИмяПредопределенныхДанных 
		+ " * "
		+ Справочники.ФизическиеХарактеристики.Ширина.ИмяПредопределенныхДанных; 
	Sпрям.Записать();
	
	Sтреуг = Справочники.Формулы.Sтреуг.ПолучитьОбъект();
	Sтреуг.Сокращение = Sтреуг.ИмяПредопределенныхДанных;
	Sтреуг.Формула = "1 / 2 * " 
		+ Справочники.Формулы.ОСНОВАНИЕтреуг.ИмяПредопределенныхДанных
		+ " * "
		+ Справочники.Формулы.ВЫСОТАтреуг.ИмяПредопределенныхДанных;
	Sтреуг.Подсказка = НСтр("ru = 'Площадь треугольника равна половине площади прямоугольника'; en = 'Area of a triangle is half of a rectangle.'");
	Sтреуг.Записать();
	
	Pтреуг = Справочники.Формулы.Pтреуг.ПолучитьОбъект();
	Pтреуг.Сокращение = Pтреуг.ИмяПредопределенныхДанных;
	Pтреуг.Формула = Справочники.ФизическиеХарактеристики.Длина.ИмяПредопределенныхДанных
		+ " + "
		+ Справочники.ФизическиеХарактеристики.Ширина.ИмяПредопределенныхДанных
		+ " + "
		+ Справочники.ФизическиеХарактеристики.Высота.ИмяПредопределенныхДанных;
	Pтреуг.Записать();
	
	ФормулаГерона = Справочники.Формулы.ФормулаГерона.ПолучитьОбъект();
	ФормулаГерона.Сокращение = ФормулаГерона.ИмяПредопределенныхДанных;
	ФормулаГерона.Формула = "Pow ( "
		+ Pтреуг.ИмяПредопределенныхДанных
		+ " / 2 * ( "
		+ Pтреуг.ИмяПредопределенныхДанных
		+ " / 2 - "
		+ Справочники.ФизическиеХарактеристики.Длина
		+ " ) * ( "
		+ Pтреуг.ИмяПредопределенныхДанных
		+ " / 2 - "
		+ Справочники.ФизическиеХарактеристики.Ширина
		+ " ) * ( "
		+ Pтреуг.ИмяПредопределенныхДанных
		+ " / 2 - "
		+ Справочники.ФизическиеХарактеристики.Высота
		+ " ), 1 / 2 )"; // Pow(число, 1 / 2)
	ФормулаГерона.Подсказка = НСтр("ru = 'Позволяет вычислить площадь любого треугольника, не зная его высоту'; en = 'Allows you to calculate an area of any triangle without knowing a altitude (height)'");
	ФормулаГерона.Записать();
	
	ГИПОТЕНУЗАтреуг = Справочники.Формулы.ГИПОТЕНУЗАтреуг.ПолучитьОбъект();
	ГИПОТЕНУЗАтреуг.Сокращение = ГИПОТЕНУЗАтреуг.ИмяПредопределенныхДанных;
	ГИПОТЕНУЗАтреуг.Формула = "Pow ( Pow ( "
		+ Справочники.ФизическиеХарактеристики.СторонаA.ИмяПредопределенныхДанных
		+ ", 2 ) + Pow ( "
		+ Справочники.ФизическиеХарактеристики.СторонаB.ИмяПредопределенныхДанных
		+ ", 2 ), 1 / 2 )";
	ГИПОТЕНУЗАтреуг.Подсказка = "ru = 'Гипотенуза прямоугольного треугольника по формуле Пифагора'; en = 'Hipotinuse a right trinagle evaluating with Pythagorean theorem'";
	ГИПОТЕНУЗАтреуг.Записать();
	
	ВЫСОТАтреуг = Справочники.Формулы.ВЫСОТАтреуг.ПолучитьОбъект();
	ВЫСОТАтреуг.Сокращение = ВЫСОТАтреуг.ИмяПредопределенныхДанных;
	ВЫСОТАтреуг.Формула = "Pow ( Pow ( "
		+ Справочники.ФизическиеХарактеристики.СторонаC.ИмяПредопределенныхДанных
		+ ", 2 ) - Pow ( "
		+ Справочники.ФизическиеХарактеристики.СторонаB.ИмяПредопределенныхДанных
		+ ", 2 ), 1 / 2 )";
	ВЫСОТАтреуг.Подсказка = "ru = 'Высота прямоугольного треугольника по формуле Пифагора'; en = 'Height a right trinagle evaluating with Pythagorean theorem'";
	ВЫСОТАтреуг.Записать();
	
	ОСНОВАНИЕтреуг = Справочники.Формулы.ОСНОВАНИЕтреуг.ПолучитьОбъект();
	ОСНОВАНИЕтреуг.Сокращение = ОСНОВАНИЕтреуг.ИмяПредопределенныхДанных;
	ОСНОВАНИЕтреуг.Формула = "Pow ( Pow ( "
		+ Справочники.ФизическиеХарактеристики.СторонаC.ИмяПредопределенныхДанных
		+ ", 2 ) - Pow ( "
		+ Справочники.ФизическиеХарактеристики.СторонаA.ИмяПредопределенныхДанных
		+ ", 2 ), 1 / 2 )";
	ОСНОВАНИЕтреуг.Подсказка = "ru = 'Высота прямоугольного треугольника по формуле Пифагора'; en = 'Height a right trinagle evaluating with Pythagorean theorem'";
	ОСНОВАНИЕтреуг.Записать();
	
	Pпрям = Справочники.Формулы.Pпрям.ПолучитьОбъект();
	Pпрям.Сокращение = Pпрям.ИмяПредопределенныхДанных;
	Pпрям.Формула = Справочники.ФизическиеХарактеристики.Длина.ИмяПредопределенныхДанных
		+ " * 2"
		+ " + "
		+ Справочники.ФизическиеХарактеристики.Ширина.ИмяПредопределенныхДанных
		+ " * 2";
	Pпрям.Записать();
	
	M3_M2Ссылка = ОбщегоНазначения.НайтиСоздатьПредопределенныйЭлемент("Справочник.Формулы.М3_М2");
	M3_M2 = M3_M2Ссылка.ПолучитьОбъект();
	M3_M2.Сокращение = "м3 => м2";
	M3_M2.Формула = Справочники.ФизическиеХарактеристики.Объем.ИмяПредопределенныхДанных
		+ " / "
		+ Справочники.ФизическиеХарактеристики.Высота.ИмяПредопределенныхДанных;
	M3_M2.Записать();
	
	M2_M3Ссылка = ОбщегоНазначения.НайтиСоздатьПредопределенныйЭлемент("Справочник.Формулы.М2_М3");
	M2_M3 = M2_M3Ссылка.ПолучитьОбъект();
	M2_M3.Сокращение = "м2 => м3";
	M2_M3.Формула = Справочники.ФизическиеХарактеристики.Площадь.ИмяПредопределенныхДанных
		+ " * "
		+ Справочники.ФизическиеХарактеристики.Высота.ИмяПредопределенныхДанных;
	M2_M3.Записать();
	
КонецПроцедуры

Процедура УстановкаПредопределенныхДеталей()
	
	ГабаритыСсылка = ОбщегоНазначения.НайтиСоздатьПредопределенныйЭлемент("Справочник.ДеталиПроекта.Габариты");
	Габариты = ГабаритыСсылка.ПолучитьОбъект();
	
	Габариты.Характеристики.Очистить();
	НоваяСтрока = Габариты.Характеристики.Добавить();
	НоваяСтрока.Характеристика = ОбщегоНазначения.НайтиСоздатьПредопределенныйЭлемент("Справочник.ФизическиеХарактеристики.Длинасм");
	
	НоваяСтрока = Габариты.Характеристики.Добавить();
	НоваяСтрока.Характеристика = ОбщегоНазначения.НайтиСоздатьПредопределенныйЭлемент("Справочник.ФизическиеХарактеристики.Ширинасм");
	
	НоваяСтрока = Габариты.Характеристики.Добавить();
	НоваяСтрока.Характеристика = ОбщегоНазначения.НайтиСоздатьПредопределенныйЭлемент("Справочник.ФизическиеХарактеристики.ВысотаСм");
	
	Габариты.Записать();
	
КонецПроцедуры


#КонецОбласти

#Область ОднократныеОбработчики

Процедура ПереходНаВерсию_0_8()
	
	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Compares two stroke numeric versions each number must be separated by dot symbol.
// Returns positive numbet if the version1 is greater, negative - if one is less, 
// and zero ig versions are equal
//
// Parameters:
//  Версия1 - String - first vesrion
//  Версия2 - String - second version
// 
// Return:
//  Numveber - result of comparison
//
Функция СравнитьВерсии(Версия1, Версия2)
	
	Версия1Число = Число(СтрЗаменить(Версия1, ".", ""));
	Версия2Число = Число(СтрЗаменить(Версия2, ".", ""));
	
	Возврат Версия2Число - Версия1Число;
	
КонецФункции

#КонецОбласти
