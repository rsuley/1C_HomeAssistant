﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("ФизХарактеристики") Тогда
		Возврат;
	КонецЕсли;
	
	ФизХарактеристики = Параметры.ФизХарактеристики;
	
	ОбновитьЭлементыДеталиПроекта(ФизХарактеристики);
	ОбновитьЭлементыХарактеристик(ФизХарактеристики);
	
	УправлениеФормой();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандРеквизитовФормы

&НаКлиенте
Процедура Подключаемый_ХарактеристикаОбработкаВыбора(Элемент, ВыбранноеЗначение) 
	
	НомерХарактеристики = Элемент.Родитель.Родитель.ПодчиненныеЭлементы.Индекс(Элемент.Родитель) + 1;
	
	ИмяРеквизита = ФормыПроектыКлиентСервер.ИмяКолонкиЗначенияХарактеристики()+ НомерХарактеристики;
	
	КонвертированноеЧило = ПересчитатьЕдиницуИзмеренияНаСервере(
		ЭтотОбъект[Элемент.Имя], 
		ВыбранноеЗначение, 
		ЭтотОбъект[ИмяРеквизита]
	);
	
	ЭтотОбъект[ИмяРеквизита] = КонвертированноеЧило;
	
	УстановитьТипХарактеристикиПоСсылке(ИмяРеквизита, ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НажатиеЭлемента(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОткрытьВыборХарактеристики(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_УдалитьХарактеристику(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИндексЭлемента = ИндексЭлементаПоИмени(Элемент.Имя);
	ИмяГруппы = ФормыПроектыКлиентСервер.ИмяГруппыДеталиХарактеристики() + Строка(ИндексЭлемента);
	Элементы[ИмяГруппы].Видимость = Ложь;
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОткрытьВыборХарактеристики(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДеталиПроекта(Элемент)
	
	ДетальПроектаПриИзменииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура Принять(Команда)
	
	ОбработатьЗакрытиеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьХарактеристику(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ЗавершитьДобавлениеХарактеристики", ЭтотОбъект);
	ОткрытьФорму("Справочник.ФизическиеХарактеристики.ФормаВыбора",,,,,, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьДобавлениеХарактеристики(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТипХарактеристики = ТипХарактеристикиПоСсылке(ВыбранноеЗначение);
	
	СтрокаХарактеристики = Новый Структура("Характеристика,ТипХарактеристики,Значение", 
		ВыбранноеЗначение, 
		ТипХарактеристики, 
		0
	);
	
	ИндексСвободнойХарактеристики = СвободныйИндексХарактеристики();
	
	ДобавитьХарактеристикуНаФорму(СтрокаХарактеристики, ИндексСвободнойХарактеристики);
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьХарактеристику(Команда)
	
	ИмяГруппы = ФормыПроектыКлиентСервер.ИмяГруппыДеталиХарактеристики() + АктивныеХарактеристикиФормы(ЭтотОбъект).Количество();
	Элементы[ИмяГруппы].Видимость = Ложь;
	
	УправлениеФормой();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьЭлементыДеталиПроекта(ФизХарактеристики)
	
	// Добавляем реквизиты для детали проекта
	ЭлементРеквизита = ФормыОбщиеДействияСервер.ДобавитьРеквизитСоСвязаннымЭлементомНаФорму(
		ЭтотОбъект, ИмяРеквизитаДетальПроекта(), ФизХарактеристики.ДетальПроекта,
		Элементы.ГруппаДеталь
	);
	ЭлементРеквизита.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
	ЭлементРеквизита.Вид = ВидПоляФормы.ПолеВвода;
	ЭлементРеквизита.РедактированиеТекста = Ложь;
	ЭлементРеквизита.Шрифт = ШрифтыСтиля.КрупныйШрифтТекста;
	ЭлементРеквизита.УстановитьДействие("ПриИзменении", "Подключаемый_ПриИзмененииДеталиПроекта");
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыХарактеристик(ДетальСФизХарактеристиками)
	
	ФизХарактеристики = ДетальСФизХарактеристиками.Характеристики;
	Счетчик = 1;
	Для каждого СтрокаХарактеристики Из ФизХарактеристики Цикл
		
		ДобавитьХарактеристикуНаФорму(СтрокаХарактеристики, Счетчик);
		Счетчик = Счетчик + 1;
		
	КонецЦикла;
	
	// Скрыть лишние элементы характеристик
	Для Счетчик = ФизХарактеристики.Количество() + 1 По ФормыПроектыКлиентСервер.ЛимитХарактеристик() Цикл
		
		ЭлементСтроки = Элементы.Найти(ФормыПроектыКлиентСервер.ИмяГруппыДеталиХарактеристики() + Счетчик);
		Если ЭлементСтроки <> Неопределено Тогда
			ЭлементСтроки.Видимость = Ложь;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИмяРеквизитаДетальПроекта()
	Возврат "ДетальПроекта";
КонецФункции

&НаКлиенте
Функция ОбработатьЗакрытиеФормы()
	
	АдресТЗ = РезультатЗакрытияФормы();
	ОповеститьОВыборе(АдресТЗ);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПересчитатьЕдиницуИзмеренияНаСервере(ИсхФизХар, КонФизХар, Количество)
	
	Возврат Справочники.КлассификаторЕдиницИзмерения.ПересчитатьЕдиницуИзмерения(
		ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ИсхФизХар, "ЕдиницаИзмерения"), 
		ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КонФизХар, "ЕдиницаИзмерения"), 
		Количество);
		
КонецФункции

&НаСервереБезКонтекста
Функция РодительХаракт(знач ХарактеристикаСсылка)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ХарактеристикаСсылка, "Родитель");

	
КонецФункции

&НаКлиенте
Процедура КолВоХарактеристикНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВыборХарактеристики(Элемент)
	
	НомерХарактеристики = Элемент.Родитель.Родитель.ПодчиненныеЭлементы.Индекс(Элемент.Родитель) + 1;
	ЭлементХарактеристики = Элементы[ФормыПроектыКлиентСервер.ИмяКолонкиХарактеристики() + НомерХарактеристики];
	
	РодительХаракт = РодительХаракт(ЭтотОбъект[ФормыПроектыКлиентСервер.ИмяКолонкиХарактеристики() + НомерХарактеристики]);
	
	ПараметрыФормы = Новый Структура("ТекущийРодитель, Отбор", РодительХаракт);
	
	СтруктураОтбора = Новый Структура();
	СтруктураОтбора.Вставить("Родитель", РодительХаракт);
	ПараметрыФормы.Отбор = СтруктураОтбора;
	
	ОткрытьФорму("Справочник.ФизическиеХарактеристики.ФормаВыбора", ПараметрыФормы, ЭлементХарактеристики);
	
КонецПроцедуры

&НаСервере
Процедура ДетальПроектаПриИзменииСервер()
	
	ДетальПроекта = ЭтотОбъект[ИмяРеквизитаДетальПроекта()];
	
	ДетальСХарактеристиками = Новый Структура;
	ДетальСХарактеристиками.Вставить("ДетальПроекта", ДетальПроекта);
	
	ХарактеристикиДетали = Справочники.ДеталиПроекта.ЗапроситьПараметрыДетали(
		ОбщегоНазначения.ЗначениеВМассив(ДетальПроекта));
		
	ДетальСХарактеристиками.Вставить("Характеристики", ХарактеристикиДетали);
	
	ОбновитьЭлементыХарактеристик(ДетальСХарактеристиками);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьХарактеристикуНаФорму(СтрокаХарактеристики, Счетчик)

	РодительСтроки = ФормыОбщиеДействияСервер.НайтиДобавитьГруппуФормы(
		ЭтотОбъект, ФормыПроектыКлиентСервер.ИмяГруппыДеталиХарактеристики() + Счетчик, Элементы.ГруппаРеквизиты);
	РодительСтроки.Видимость = Истина;
	
	// Добавляем Картинку для Стрелки
	ЭлементРеквизита = ФормыОбщиеДействияСервер.НайтиДобавитьЭлементФормы(
		ЭтотОбъект, 
		ИмяДекорацииУдаления() + Счетчик, 
		Тип("ДекорацияФормы"), 
		РодительСтроки
	);
	ЭлементРеквизита.Вид = ВидДекорацииФормы.Картинка;
	ЭлементРеквизита.Картинка = БиблиотекаКартинок.Закрыть;
	ЭлементРеквизита.Гиперссылка = Истина;
	ЭлементРеквизита.УстановитьДействие("Нажатие", "Подключаемый_УдалитьХарактеристику");
	
	// Добавляем Реквизиты для Ссылки на новую ФизическуюХарактеристику
	ЭлементРеквизита = ФормыОбщиеДействияСервер.ДобавитьРеквизитСоСвязаннымЭлементомНаФорму(
		ЭтотОбъект, ФормыПроектыКлиентСервер.ИмяКолонкиХарактеристики() + Счетчик, СтрокаХарактеристики.Характеристика,
		РодительСтроки
	);
	ЭлементРеквизита.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
	ЭлементРеквизита.Вид = ВидПоляФормы.ПолеВвода;
	ЭлементРеквизита.РедактированиеТекста = Ложь;
	ЭлементРеквизита.УстановитьДействие("ОбработкаВыбора", "Подключаемый_ХарактеристикаОбработкаВыбора");
	
	// Добавление элемента для физической единицы
	ЭлементРеквизита = ФормыОбщиеДействияСервер.ДобавитьРеквизитСоСвязаннымЭлементомНаФорму(
		ЭтотОбъект, ФормыПроектыКлиентСервер.ИмяКолонкиЗначенияХарактеристики() + Счетчик, 
		СтрокаХарактеристики.Значение,
		РодительСтроки, 
		ФормыОбщиеДействияСервер.ВсеТипыФизическихХарактеристик()
	);
	ЭлементРеквизита.Вид = ВидПоляФормы.ПолеВвода;
	ЭлементРеквизита.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
	ЭлементРеквизита.ГоризонтальноеПоложение = ГоризонтальноеПоложениеЭлемента.Право;
	
	ФормыОбщиеДействияСервер.ПривестиРеквизитКТипуХарактеристики(
		ЭтотОбъект[ФормыПроектыКлиентСервер.ИмяКолонкиЗначенияХарактеристики() + Счетчик], 
		СтрокаХарактеристики.ТипХарактеристики);
		
	ЭлементРеквизита.ОграничениеТипа =
		 ФормыОбщиеДействияСервер.ОписаниеТипаХарактеристикиПоЗначению(
		 ЭтотОбъект[ФормыПроектыКлиентСервер.ИмяКолонкиЗначенияХарактеристики() + Счетчик]);

КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	КолВоХарактеристик = АктивныеХарактеристикиФормы(ЭтотОбъект).Количество();
	
	Элементы.ДобавитьХарактеристику.Доступность = (КолВоХарактеристик < ФормыПроектыКлиентСервер.ЛимитХарактеристик());
	Элементы.УдалитьХарактеристику.Доступность = (КолВоХарактеристик > 1);
	
	Для каждого ЭлементФормы Из Элементы Цикл
		Если СтрНачинаетсяС(ЭлементФормы.Имя, ИмяДекорацииУдаления()) Тогда
			Если СтрЗаканчиваетсяНа(ЭлементФормы.Имя, "РасширеннаяПодсказка") Тогда
				// У расширенной подсказки нет свойства Видимость и своего типа
				Продолжить;
			КонецЕсли;
			ЭлементФормы.Доступность = (КолВоХарактеристик > 1);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция УстановитьТипХарактеристикиПоСсылке(ИмяРеквизита, ХарактеристикаСсылка)
	
	ТипХарактеристики = Справочники.ФизическиеХарактеристики.ТипХарактеристикиПоСсылке(ХарактеристикаСсылка);
	Элементы[ИмяРеквизита].ОграничениеТипа = ФормыОбщиеДействияСервер.ОписаниеТипаХарактеристики(ТипХарактеристики);
	
КонецФункции

&НаСервере
Функция РезультатЗакрытияФормы();
	
	ДеталиСХарактеристиками = Новый Структура;
	ДеталиСХарактеристиками.Вставить("ДетальПроекта", ЭтотОбъект[ИмяРеквизитаДетальПроекта()]);
	
	ТЗХарактеристики = Новый ТаблицаЗначений;
	ТЗХарактеристики.Колонки.Добавить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ФизическиеХарактеристики"));
	ТЗХарактеристики.Колонки.Добавить("ДетальПроекта", Новый ОписаниеТипов("СправочникСсылка.ДеталиПроекта"));
	ТЗХарактеристики.Колонки.Добавить("Значение", ФормыОбщиеДействияСервер.ВсеТипыФизическихХарактеристик());
	Для каждого ХаркаФормы Из АктивныеХарактеристикиФормы(ЭтотОбъект) Цикл
		СтрокаХарактеристик = ТЗХарактеристики.Добавить();
		СтрокаХарактеристик.Характеристика = ЭтотОбъект[ФормыПроектыКлиентСервер.ИмяКолонкиХарактеристики() + ИндексЭлементаПоИмени(ХаркаФормы.Имя)];
		СтрокаХарактеристик.Значение = ЭтотОбъект[ФормыПроектыКлиентСервер.ИмяКолонкиЗначенияХарактеристики() + ИндексЭлементаПоИмени(ХаркаФормы.Имя)];
	КонецЦикла;
	ДеталиСХарактеристиками.Вставить("Характеристики", ТЗХарактеристики);
	
	Возврат ПоместитьВоВременноеХранилище(ДеталиСХарактеристиками);
	
КонецФункции

&НаСервереБезКонтекста
Функция ТипХарактеристикиПоСсылке(Характеристика) Экспорт

	Возврат Справочники.ФизическиеХарактеристики.ТипХарактеристикиПоСсылке(Характеристика)

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИндексЭлементаПоИмени(ИмяЭлемента)
	
	Возврат Прав(ИмяЭлемента, 1);
	
КонецФункции

&НаКлиенте
Функция СвободныйИндексХарактеристики()
	
	ИндексХарактеристики = 0;
	Для каждого ЭлементФормы Из Элементы Цикл
		Если СтрНачинаетсяС(ЭлементФормы.Имя, ФормыПроектыКлиентСервер.ИмяГруппыДеталиХарактеристики()) Тогда
			Если СтрЗаканчиваетсяНа(ЭлементФормы.Имя, "РасширеннаяПодсказка") Тогда
				// У расширенной подсказки нет свойства Видимость и своего типа
				Продолжить;
			КонецЕсли;
			Если ЭлементФормы.Видимость Тогда
				ИндексХарактеристики = Макс(ИндексХарактеристики, Число(ИндексЭлементаПоИмени(ЭлементФормы.Имя)));
			Иначе
				Возврат Число(ИндексЭлементаПоИмени(ЭлементФормы.Имя));
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ИндексХарактеристики + 1;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция АктивныеХарактеристикиФормы(Форма)
	
	Элементы = Форма.Элементы;
	
	АктивныеХарактеристики = Новый Массив;
	Для каждого ЭлементФормы Из Элементы Цикл
		Если СтрНачинаетсяС(ЭлементФормы.Имя, ФормыПроектыКлиентСервер.ИмяГруппыДеталиХарактеристики()) Тогда
			Если СтрЗаканчиваетсяНа(ЭлементФормы.Имя, "РасширеннаяПодсказка") Тогда
				// У расширенной подсказки нет свойства Видимость и своего типа
				Продолжить;
			КонецЕсли;
			Если ЭлементФормы.Видимость Тогда
				АктивныеХарактеристики.Добавить(ЭлементФормы);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат АктивныеХарактеристики;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИмяДекорацииУдаления()
	
	Возврат "ДекорацияСтрелка";
	
КонецФункции

#КонецОбласти
