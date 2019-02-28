﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Инициализировать();
	ЗагрузитьТаблицуСПланомТО();
	УстановитьУсловноеОформление();
	
	ФормыОбщиеДействияКлиентСервер.ФорматДатыДокумента(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ЗагрузитьТаблицуСПланомТО();
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	РаботаСФотоФормыСервер.ПриЗаписиНаСервере(ЭтотОбъект, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандРеквизитовФормы

&НаКлиенте
Процедура Подключаемый_ИзменитьСтатусТО(Элемент) Экспорт
	
	ИзменитьСтатусТО(ЭтотОбъект[Элемент.Имя], Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСтатусТО(ТОПройдено, ИмяЭлемента)
	
	НомерСтроки = ФормыСервисныеРаботыКлиентСервер.НомерСтрокиИзИмениЭлемента(ФормыСервисныеРаботыКлиентСервер.ИмяЭлементаБезНомераКолонки(ИмяЭлемента));
	СтрокаТЧ = Объект.ВыполненныеРаботы[НомерСтроки - 1];
	
	Если ТОПройдено Тогда
		СтрокаТЧ[УзнатьВидТОПоИмениЭлемента(ИмяЭлемента) + "Статус"] =
			ПредопределенноеЗначение("Перечисление.СтатусыВыполненияТО.Пройдено"); 
			
		СтрокаТЧ[УзнатьВидТОПоИмениЭлемента(ИмяЭлемента) + "ПоФакту"] = Объект.Дата;
	Иначе
		СтрокаТЧ[УзнатьВидТОПоИмениЭлемента(ИмяЭлемента) + "Статус"] = 
			ПредопределенноеЗначение("Перечисление.СтатусыВыполненияТО.НеПройдено");
			
		СтрокаТЧ[УзнатьВидТОПоИмениЭлемента(ИмяЭлемента) + "ПоФакту"] = Неопределено;
	КонецЕсли;
	
	ОбновитьЭлементыПланаТО();
	ОтфильтроватьРегламентныеРаботы(ДиапазонТО);
	
КонецПроцедуры

&НаКлиенте
Процедура АвтомобильПриИзменении(Элемент)
	Объект.ТекущийНомерТО = ТекущийНомерТО(Объект.Автомобиль, Объект.Дата);
	ЗагрузитьТаблицуСПланомТО();
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьДату(Команда)
	ФормыОбщиеДействияКлиент.НачатьВводДаты(ЭтотОбъект, 
		Элементы.Дата, 
		Объект.Дата,
		Новый ОписаниеОповещения("ЗавершитьИзменениеДаты", ЭтотОбъект, Новый Структура("ИмяЭлемента", Элементы.Дата.Имя)));
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьИзменениеДаты(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Объект.ТекущийНомерТО = ТекущийНомерТО(Объект.Автомобиль, Объект.Дата);
	ЗагрузитьТаблицуСПланомТО();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиТЧРаботы

//Вызывается при первоначальном заполнении
&НаСервере
Процедура Инициализировать()
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если Не ЗначениеЗаполнено(Объект.Автомобиль) Тогда
			Объект.Автомобиль = Справочники.Автомобили.АвтомобильПоУмолчанию();
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Объект.Дата) Тогда
			Объект.Дата = ТекущаяДата();
		КонецЕсли;
	КонецЕсли;
	
	ДиапазонТО = ИмяТекущееТО();
	Объект.ТекущийНомерТО = ТекущийНомерТО(Объект.Автомобиль, Объект.Дата);
	Элементы.Пробег.Формат = "ЧРГ=' '";
	Элементы.Пробег.ФорматРедактирования = "ЧРГ=' '";
	
	ФормыСервисныеРаботыСервер.ЗаполнитьПробегЕслиНовыйДокумент(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыПланаТО()
	
	Элементы.ГруппаРаботы.Видимость = (Объект.ВыполненныеРаботы.Количество() > 0);
	
	Счетчик = 1;
	Для каждого СтрокаПлана Из Объект.ВыполненныеРаботы Цикл
		ДобавитьСтрокуПланаТОНаФорму(СтрокаПлана, Счетчик);
		Счетчик = Счетчик + 1;
	КонецЦикла;
	
	ФормыСервисныеРаботыСервер.ОбновитьЭлементыСуммы(ЭтотОбъект, ПолучитьВидыТО());
	ФормыСервисныеРаботыКлиентСервер.ПересчитатьСумму(ЭтотОбъект, ПолучитьВидыТО());
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РаботаОбработкаВыбора(Элемент, ВыбранноеЗначение) 
	
	//НомерХарактеристики = Элемент.Родитель.Родитель.ПодчиненныеЭлементы.Индекс(Элемент.Родитель) + 1;
	//
	//ИмяРеквизита = ФормыПроектыКлиентСервер.ИмяКолонкиЗначенияХарактеристики()+ НомерХарактеристики;
	//
	//КонвертированноеЧило = ПересчитатьЕдиницуИзмеренияНаСервере(
	//	ЭтотОбъект[Элемент.Имя], 
	//	ВыбранноеЗначение, 
	//	ЭтотОбъект[ИмяРеквизита]
	//);
	//
	//ЭтотОбъект[ИмяРеквизита] = КонвертированноеЧило;
	//
	//УстановитьТипХарактеристикиПоСсылке(ИмяРеквизита, ВыбранноеЗначение);
	//
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтрокуПланаТОНаФорму(СтрокаТаблицы, Счетчик)
	
	// Номера ТО по регламентной работе
	ВидыТО = ПолучитьВидыТО();
	
	СчетчикВидаТО = 1;
	Для каждого ВидТО ИЗ ВидыТО Цикл
	
		РодительСтроки = ФормыОбщиеДействияСервер.НайтиДобавитьГруппуФормы(
			ЭтотОбъект, ВидТО + ИмяГруппыСтрокиТаблицы() + Строка(Счетчик) + Строка(СчетчикВидаТО), Элементы.ГруппаРаботы);
		РодительСтроки.Видимость  = Ложь;
		РодительСтроки.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
		РодительСтроки.ТолькоПросмотр = ВидТО <> ИмяТекущееТО();
		
		РодительРаботы = ФормыОбщиеДействияСервер.НайтиДобавитьГруппуФормы(
			ЭтотОбъект, ВидТО + ИмяГруппыРодительРаботы() + Строка(Счетчик) + Строка(СчетчикВидаТО), РодительСтроки);
		
		// Добавляем Реквизиты для Ссылки на Регламентную работу
		ЭлементРеквизита = ФормыОбщиеДействияСервер.ДобавитьРеквизитСоСвязаннымЭлементомНаФорму(
			ЭтотОбъект, ВидТО + ИмяРаботы() + Строка(Счетчик) + Строка(СчетчикВидаТО), СтрокаТаблицы.РегламентнаяРабота,
			РодительРаботы
		);
		ЭлементРеквизита.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
		ЭлементРеквизита.Вид = ВидПоляФормы.ПолеВвода;
		ЭлементРеквизита.РедактированиеТекста = Ложь;
		ЭлементРеквизита.ТолькоПросмотр = Истина;
		
		// Флажок выполненного этапа
		ЭлементРеквизита = ФормыОбщиеДействияСервер.ДобавитьРеквизитСоСвязаннымЭлементомНаФорму(
			ЭтотОбъект, ВидТО + ИмяВыполненннойРаботы() + Строка(Счетчик) + Строка(СчетчикВидаТО), 
			СтрокаТаблицы[ВидТО + "Статус"] = Перечисления.СтатусыВыполненияТО.Пройдено,
			РодительРаботы
		);
		ЭлементРеквизита.Вид = ВидПоляФормы.ПолеФлажка;
		ЭлементРеквизита.ШиринаЭлемента = 10;
		ЭлементРеквизита.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
		ЭлементРеквизита.ГоризонтальноеПоложение = ГоризонтальноеПоложениеЭлемента.Право;
		
		РодительРаботы = ФормыОбщиеДействияСервер.НайтиДобавитьГруппуФормы(
			ЭтотОбъект, ВидТО + ИмяГруппыРодительРаботы() + Строка(Счетчик) + Строка(СчетчикВидаТО), РодительСтроки);
			
		ЭлементРеквизита.УстановитьДействие("ПриИзменении", "Подключаемый_ИзменитьСтатусТО");
	
		// Группа номера ТО
		РодительВидТО = ФормыОбщиеДействияСервер.НайтиДобавитьГруппуФормы(
			ЭтотОбъект, ВидТО + ИмяГруппыВидаТО() + Строка(Счетчик) + Строка(СчетчикВидаТО), РодительСтроки);
		РодительВидТО.Видимость   = Истина;
		РодительВидТО.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;
		
		// План ТО
		ЭлементРеквизита = ФормыОбщиеДействияСервер.ДобавитьРеквизитСоСвязаннымЭлементомНаФорму(
			ЭтотОбъект, 
			ВидТО + "ПоПлану" + Строка(Счетчик) + СчетчикВидаТО, 
			СтрокаТаблицы[ВидТО + "ПоПлану"],
			РодительВидТО,
			Тип("Дата")
		);
		ЭлементРеквизита.Вид = ВидПоляФормы.ПолеНадписи;
		ЭлементРеквизита.Формат = "ДФ=dd/MM/yy; ДЛФ=D; ДП=-";
		ЭлементРеквизита.ТолькоПросмотр = Истина;
		ЭлементРеквизита.Заголовок = НСтр("ru = 'План'; en = 'Plan'");
		ЭлементРеквизита.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
		ЭлементРеквизита.Ширина = 8;
		// TODO: не работает на Android API 27
		//ЭлементРеквизита.ЦветТекста = ЦветаСтиля.ЦветГиперссылки;
		
		// Passed / Not Passed
		ЭлементРеквизита = ФормыОбщиеДействияСервер.ДобавитьРеквизитСоСвязаннымЭлементомНаФорму(
			ЭтотОбъект, 
			ВидТО + "ДекорацияPassed" + Строка(Счетчик) + СчетчикВидаТО, 
			ЗначениеЗаполнено(СтрокаТаблицы[ВидТО + "ПоФакту"]),
			РодительВидТО,
			Тип("Булево")
		);
		ЭлементРеквизита.Вид = ВидПоляФормы.ПолеНадписи;
		ЭлементРеквизита.ТолькоПросмотр = Истина;
		ЭлементРеквизита.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
		ЭлементРеквизита.РастягиватьПоГоризонтали = Ложь;
		ЭлементРеквизита.Ширина = 6;
		ЭлементРеквизита.ЦветТекста = Новый Цвет(34, 139, 34);
		ЭлементРеквизита.ГоризонтальноеПоложениеВГруппе = ГоризонтальноеПоложениеЭлемента.Лево;
		Если СтрокаТаблицы[ВидТО + "Внеплановое"] Тогда
			ЭлементРеквизита.Формат = "БЛ='NOPASS'; БИ=OVPLAN";
		Иначе
			ЭлементРеквизита.Формат = "БЛ='NOPASS'; БИ=PASSED";
		КонецЕсли;
		ЭлементРеквизита.Гиперссылка = Истина;
		Если ВидТО = ИмяТекущееТО() Тогда
			ЭлементРеквизита.УстановитьДействие("Нажатие", "Подключаемый_ДекорацияPassedНажатие");
		КонецЕсли;
		
		// Факт ТО
		ЭлементРеквизита = ФормыОбщиеДействияСервер.ДобавитьРеквизитСоСвязаннымЭлементомНаФорму(
			ЭтотОбъект, 
			ВидТО + "ПоФакту" + Строка(Счетчик) + СчетчикВидаТО, 
			СтрокаТаблицы[ВидТО + "ПоФакту"],
			РодительВидТО,
			Тип("Дата")
		);
		ЭлементРеквизита.Вид = ВидПоляФормы.ПолеНадписи;
		ЭлементРеквизита.Гиперссылка = Истина;
		ЭлементРеквизита.ТолькоПросмотр = Истина;
		ЭлементРеквизита.ЦветТекста = Новый Цвет(28, 115, 205);
		ЭлементРеквизита.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
		ЭлементРеквизита.Видимость = Истина;
		ЭлементРеквизита.Ширина = 8;
		Если ВидТО = ИмяТекущееТО() Тогда
			ЭлементРеквизита.Формат = "ДФ=dd/MM/yy; ДЛФ=D; ДП='enter date'";
			ЭлементРеквизита.УстановитьДействие("Нажатие", "Подключаемый_СсылкаНаДатуТОНажатие");
		Иначе
			ЭлементРеквизита.Формат = "ДФ=dd/MM/yy; ДЛФ=D; ДП='empty date'";
		КонецЕсли;
		
		// Сумма ТО
		ЭлементРеквизита = ФормыОбщиеДействияСервер.ДобавитьРеквизитСоСвязаннымЭлементомНаФорму(
			ЭтотОбъект, 
			ВидТО + "Сумма" + Строка(Счетчик) + СчетчикВидаТО, 
			СтрокаТаблицы[ВидТО + "Сумма"],
			РодительВидТО,
			ОбщегоНазначения.ОписаниеТипаЧисло(6,, ДопустимыйЗнак.Неотрицательный)
		);
		ЭлементРеквизита.Вид = ВидПоляФормы.ПолеВвода;
		ЭлементРеквизита.Заголовок = НСтр("ru = 'руб'; en = 'rub'");
		ЭлементРеквизита.Ширина = 7;
		ЭлементРеквизита.Формат = "ЧЦ=6; ЧРГ=' '; ЧГ=3,0; ЧФ='Ч rub'";
		ЭлементРеквизита.ФорматРедактирования = "ЧЦ=6; ЧРГ=' '; ЧГ=3,0; ЧФ='Ч rub'";
		ЭлементРеквизита.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
		ЭлементРеквизита.УстановитьДействие("ПриИзменении", "Подключаемый_СуммаТОПриИзменении");
		ЭлементРеквизита.ТолькоПросмотр = ВидТО <> ИмяТекущееТО();
		
		СчетчикВидаТО = СчетчикВидаТО + 1;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеСтрокиПланФакта(ПланДата, ФактДата)
	
	СтрокаПлана = Новый ФорматированнаяСтрока(
		СтрШаблон(НСтр("ru = 'П:%1'; en = 'P:%1'"), Формат(ПланДата, "Л=ru_RU; ДФ=dd.MM.yy; ДП=--------------")),
		, Новый Цвет(0, 0, 150));
		
	Разделитель = Новый ФорматированнаяСтрока(" / ");
		
	СтрокаФакта = Новый ФорматированнаяСтрока(
		СтрШаблон(НСтр("ru = 'Ф:%1'; en = 'F:%1'"), Формат(ФактДата, "Л=ru_RU; ДФ=dd.MM.yy; ДП=--------------")),
		, Новый Цвет(0, 150, 0));
	
	Возврат Новый ФорматированнаяСтрока(СтрокаПлана, Разделитель, СтрокаФакта);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИмяГруппыСтрокиТаблицы()
	
	Возврат "ГруппаСтрокаТаб";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИмяГруппыРодительРаботы()
	
	Возврат "ГруппаРаботаСтрока";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИмяРаботы()
	
	Возврат "Работа";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИмяВыполненннойРаботы()
	
	Возврат "РаботаВыполнена";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИмяГруппыВидаТО()
	
	Возврат "ГруппаВидТО";
	
КонецФункции

&НаСервереБезКонтекста
Функция ИмяПрошлогоТО()
	
	Возврат Документы.РегистрацииТО.ИмяПрошлогоТО();
	
КонецФункции

&НаСервереБезКонтекста
Функция ИмяТекущееТО()
	
	Возврат Документы.РегистрацииТО.ИмяТекущееТО();
	
КонецФункции

&НаСервереБезКонтекста
Функция ИмяСледующееТО()
	
	Возврат Документы.РегистрацииТО.ИмяСледующееТО();
	
КонецФункции

&НаСервере
Процедура ЗагрузитьТаблицуСПланомТО()
	
	Если Не ЗначениеЗаполнено(Объект.Автомобиль) Или Не ЗначениеЗаполнено(Объект.Дата) Тогда
		Объект.ВыполненныеРаботы.Очистить();
	Иначе
		Объект.ВыполненныеРаботы.Загрузить(ТаблицаПланТО(Объект.Автомобиль, Объект.Дата));
	КонецЕсли;
	
	// Требуется соблюдение порядка вызовов
	ОбновитьТумблерДиапазонаТО();
	ОбновитьЭлементыПланаТО();
	ОтфильтроватьРегламентныеРаботы(ДиапазонТО);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СсылкаНаДатуТОНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("ЗавершитьВводДатыТО", ЭтотОбъект, 
		Новый Структура("ИмяЭлемента", Элемент.Имя));
		
	РеквизитДаты = ФормыСервисныеРаботыКлиентСервер.РеквизитТЧПоИмениЭлемента(ЭтотОбъект, Элемент.Имя);
	РеквизитДатыПлан = ФормыСервисныеРаботыКлиентСервер.РеквизитТЧПоИмениЭлемента(ЭтотОбъект, СтрЗаменить(Элемент.Имя, "ПоФакту", "ПоПлану"));
	
	ФормыОбщиеДействияКлиент.НачатьВводДаты(ЭтотОбъект, 
		Элемент, 
		?(ЗначениеЗаполнено(РеквизитДаты), РеквизитДаты, Макс(Объект.Дата, РеквизитДатыПлан)),
		Новый ОписаниеОповещения("ЗавершитьВводДатыТО", ЭтотОбъект, Новый Структура("ИмяЭлемента", Элемент.Имя)));
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СуммаТОПриИзменении(Элемент, СтандартнаяОбработка)
	
	СтрокаТЧ = ФормыСервисныеРаботыКлиентСервер.СтрокаТЧВыполненныеРаботыПоИмениЭлемента(ЭтотОбъект, ФормыСервисныеРаботыКлиентСервер.ИмяЭлементаБезНомераКолонки(Элемент.Имя));
	СтрокаТЧ[ФормыСервисныеРаботыКлиентСервер.ИмяЭлементаБезНомераСтроки(Элемент.Имя)] = ЭтотОбъект[Элемент.Имя];
	
	ФормыСервисныеРаботыКлиентСервер.ПересчитатьСумму(ЭтотОбъект, ПолучитьВидыТО());
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ДекорацияPassedНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИмяЭлемента = Элемент.Имя;
	
	НомерСтроки = ФормыСервисныеРаботыКлиентСервер.НомерСтрокиИзИмениЭлемента(ФормыСервисныеРаботыКлиентСервер.ИмяЭлементаБезНомераКолонки(ИмяЭлемента));
	СтрокаТЧ = Объект.ВыполненныеРаботы[НомерСтроки - 1];
	
	СтатусТО = СтрокаТЧ[УзнатьВидТОПоИмениЭлемента(ИмяЭлемента) + "Статус"];
	
	ИзменитьСтатусТО(СтатусТО <> ПредопределенноеЗначение("Перечисление.СтатусыВыполненияТО.Пройдено"), ИмяЭлемента);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьВводДатыТО(Дата, ДополнительныеПараметры) Экспорт
	
	Если Дата = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаТЧ = ФормыСервисныеРаботыКлиентСервер.СтрокаТЧВыполненныеРаботыПоИмениЭлемента(ЭтотОбъект, ФормыСервисныеРаботыКлиентСервер.ИмяЭлементаБезНомераКолонки(ДополнительныеПараметры.ИмяЭлемента));
	СтрокаТЧ[ФормыСервисныеРаботыКлиентСервер.ИмяЭлементаБезНомераСтроки(ДополнительныеПараметры.ИмяЭлемента)] = Дата;
	
	СтрокаТЧ[УзнатьВидТОПоИмениЭлемента(ДополнительныеПараметры.ИмяЭлемента) + "Статус"] =
		ПредопределенноеЗначение("Перечисление.СтатусыВыполненияТО.Пройдено");
	
	ОбновитьЭлементыПланаТО();
	ОтфильтроватьРегламентныеРаботы(ДиапазонТО);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьРаботу(Команда)
	Оповещение = Новый ОписаниеОповещения("ЗавершитьДобавлениеРаботы", ЭтотОбъект);
	ОткрытьФорму("Справочник.РегламентныеРаботы.ФормаВыбора",, ЭтотОбъект.Элементы.ДобавитьРаботу,,,, Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьДобавлениеРаботы(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого СтрокаРаботы Из Объект.ВыполненныеРаботы Цикл
		Если СтрокаРаботы.РегламентнаяРабота = РезультатЗакрытия 
			И ЗначениеЗаполнено(СтрокаРаботы.ТекущееТОПоПлану) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Выбранная работа уже есть в таблице'; en = 'This service already exists in the table'"));
			Возврат;
		КонецЕсли;
	КонецЦикла;
	
	СтрокаРабот = Объект.ВыполненныеРаботы.Добавить();
	СтрокаРабот.РегламентнаяРабота = РезультатЗакрытия;
	СтрокаРабот[ДиапазонТО + "Статус"] = ПредопределенноеЗначение("Перечисление.СтатусыВыполненияТО.Пройдено");
	ДатаТО = НачалоИнтервалаТО(ИмяТекущееТО(), Объект.Дата);
	СтрокаРабот[ДиапазонТО + "ПоПлану"] = ДатаТО;
	СтрокаРабот[ДиапазонТО + "ПоФакту"] = ДатаТО;
	СтрокаРабот[ДиапазонТО + "Номер"] = Объект.ТекущийНомерТО;
	СтрокаРабот[ДиапазонТО + "Внеплановое"] = Истина;
	
	ОбновитьЭлементыПланаТО();
	ОтфильтроватьРегламентныеРаботы(ДиапазонТО);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиТумблераТО

&НаСервере
Процедура ОбновитьТумблерДиапазонаТО()
	
	НомераТО = Новый Массив;
	ВидыТО = ПолучитьВидыТО();
	
	Элементы.ДиапазонТО.СписокВыбора.Очистить();

	Для каждого ВидТО Из ВидыТО Цикл
		ЭлСписка = Элементы.ДиапазонТО.СписокВыбора.Добавить(ВидТО, Строка(ВидТО));
		
		ДатаПоИнтервалу =  Документы.РегистрацииТО.ДатаТОПоИнтервалу(
			ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Автомобиль, "ДатаПриобретения"), ВидТО, Объект.Дата);
			
		Если ВидТО = ИмяПрошлогоТО() Тогда
			ЭлСписка.Представление = СтрШаблон("№%1 %2", Объект.ТекущийНомерТО - 1, Формат(ДатаПоИнтервалу, "ДФ=yyyy"));
		ИначеЕсли ВидТО = ИмяТекущееТО() Тогда
			ЭлСписка.Представление = СтрШаблон("№%1 %2", Объект.ТекущийНомерТО, Формат(ДатаПоИнтервалу, "ДФ=yyyy"));
		ИначеЕсли ВидТО = ИмяСледующееТО() Тогда
			ЭлСписка.Представление = СтрШаблон("№%1 %2", Объект.ТекущийНомерТО + 1, Формат(ДатаПоИнтервалу, "ДФ=yyyy"));
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДиапазонТОПриИзменении(Элемент)
	
	ОтфильтроватьРегламентныеРаботы(ДиапазонТО);
	
КонецПроцедуры

&НаСервере
Процедура ОтфильтроватьРегламентныеРаботы(знач ВидТОТекущий)
	
	ВидыТО = ПолучитьВидыТО();
	
	Для Счетчик1 = 1 По Объект.ВыполненныеРаботы.Количество() Цикл
		Для Счетчик2 = 1 По ВидыТО.Количество() Цикл
			ЭтотОбъект.Элементы[ВидыТО[Счетчик2 - 1] + ИмяГруппыСтрокиТаблицы() + Строка(Счетчик1) + Строка(Счетчик2)].Видимость = Ложь;
		КонецЦикла;
	КонецЦикла;
	
	Счетчик1 = 1;
	Для каждого СтрокаРеглРаботы Из Объект.ВыполненныеРаботы Цикл
		Счетчик2 = 1;
		Для каждого ВидТО Из ВидыТО Цикл
			ГруппаСтрокиТаблицы = ЭтотОбъект.Элементы[ВидТО + ИмяГруппыСтрокиТаблицы() + Строка(Счетчик1) + Строка(Счетчик2)];
			Если СтрокаРеглРаботы[ВидТО + "Номер"] > 0 
				И СтрНачинаетсяС(ГруппаСтрокиТаблицы.Имя, ВидТОТекущий)
				И ТОВходитВИнтервал(ВидТО, СтрокаРеглРаботы[ВидТО + "ПоПлану"]) Тогда
				
				ГруппаСтрокиТаблицы.Видимость = Истина;
			КонецЕсли;
			Счетчик2 = Счетчик2 + 1;
		КонецЦикла;
		Счетчик1 = Счетчик1 + 1;
	КонецЦикла;
	
	Элементы.ДобавитьРаботу.Видимость = (ВидТОТекущий = ИмяТекущееТО());
	
	ФормыСервисныеРаботыКлиентСервер.ОтфильтроватьСуммуИтого(ЭтотОбъект, ВидыТО, ВидТОТекущий);
	
КонецПроцедуры

#КонецОбласти

#Область РаботаСФото

&НаКлиенте
Процедура Декорация1Нажатие(Элемент)
	РаботаСФотоФормыКлиент.НачатьСозданиеНовогоФото(ЭтотОбъект, Неопределено, Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НачатьЗагрузкуФото() Экспорт
	
	ЗагрузитьФотоПроекта();
	
	Элементы.ДекорацияЗагрузкаКартинки.Видимость = Не ФотоЗагружены;
	Элементы.ДекорацияЗагрузкаТекст.Видимость = Не ФотоЗагружены;
	Элементы.ДекорацияПустоеФото.Видимость = ФотоЗагружены;
	
	ОбновитьИнтерфейс();
	ЭтотОбъект.Активизировать();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СсылкаНаПредставлениеДанныхНажатие(Элемент, СтандартнаяОбработка) Экспорт
	РаботаСФотоФормыКлиент.Подключаемый_СсылкаНаПредставлениеДанныхНажатие(
		ЭтотОбъект, Элемент, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Функция РеквизитФормыДляФотоКлиент() Экспорт
	Возврат РеквизитФормыДляФотоСервер();
КонецФункции

&НаСервере
Функция РеквизитФормыДляФотоСервер()
	Возврат РаботаСФотоФормыСервер.РеквизитФормыДляФото(ЭтотОбъект);
КонецФункции

&НаКлиенте
Процедура СтраницыОперацийПриСменеСтраницы(Элемент, ТекущаяСтраница)
	РаботаСФотоФормыКлиент.ПриСменеСтраницыСФото(ЭтотОбъект, ТекущаяСтраница);
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьФотоПроекта()
	РаботаСФотоФормыСервер.ЗагрузитьФотоПроекта(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ТОВходитВИнтервал(ВидТО, ПоПлану)
	
	ДатаПриобретения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Автомобиль, "ДатаПриобретения");
	ТОНачалоИнтервала = НачалоИнтервалаТО(ВидТО, ПоПлану);
	
	Если ВидТО = ИмяТекущееТО() Тогда
		ТОКонецИнтервала = ДобавитьМесяц(ДатаПриобретения, 12 * (Объект.ТекущийНомерТО + 1));
	ИначеЕсли ВидТО = ИмяСледующееТО() Тогда
		ТОКонецИнтервала = ДобавитьМесяц(ДатаПриобретения, 12 * (Объект.ТекущийНомерТО + 2));
	ИначеЕсли ВидТО = ИмяПрошлогоТО() Тогда
		ТОКонецИнтервала = ДобавитьМесяц(ДатаПриобретения, 12 * Объект.ТекущийНомерТО);
	Иначе
		ВызватьИсключение "Not implemented";
	КонецЕсли;
	
	ПроверяемыеДаты = Новый Массив;
	ПроверяемыеДаты.Добавить(ПоПлану);
	
	Для каждого ДатаДляПроверки Из ПроверяемыеДаты Цикл
		Если ДатаДляПроверки >= ТОНачалоИнтервала И ДатаДляПроверки < ТОКонецИнтервала Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

&НаСервере
Функция НачалоИнтервалаТО(ВидТО, ДатаАнализа)
	
	ДатаПриобретения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Автомобиль, "ДатаПриобретения");
	
	Если ВидТО = ИмяТекущееТО() Тогда
		Возврат ДобавитьМесяц(ДатаПриобретения, 12 * Объект.ТекущийНомерТО);
	ИначеЕсли ВидТО = ИмяСледующееТО() Тогда
		Возврат ДобавитьМесяц(ДатаПриобретения, 12 * (Объект.ТекущийНомерТО + 1));
	ИначеЕсли ВидТО = ИмяПрошлогоТО() Тогда
		Возврат ДобавитьМесяц(ДатаПриобретения, 12 * (Объект.ТекущийНомерТО - 1));
	Иначе
		ВызватьИсключение "Not implemented";
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	//TODO: УСЛОВНОЕ ОФОРМДЕНИЕ НЕ РАБОТАЕТ ПО НЕПОНЯТНЫМ ПРИЧИНАМ
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	Счетчик1 = 1;
	Для каждого СтрокаРегРаботы Из Объект.ВыполненныеРаботы Цикл
		Счетчик2 = 1;
		Для каждого ВидТО Из ПолучитьВидыТО() Цикл
	
			ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
			ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы[ВидТО + ИмяВыполненннойРаботы() + Строка(Счетчик1) + Строка(Счетчик2)].Имя);

			ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ВыполненныеРаботы." + ВидТО  + "Статус");
			ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
			ОтборЭлемента.ПравоеЗначение = Перечисления.СтатусыВыполненияТО.Пройдено;
			
			Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветОтрицательногоЧисла);
			
			Счетчик2 = Счетчик2 + 1;

		КонецЦикла;
		Счетчик1 = Счетчик1 + 1;
	КонецЦикла;
	//
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ТекущийНомерТО(знач Автомобиль, знач ДатаАнализа)
	
	Если Не ЗначениеЗаполнено(Автомобиль) Или Не ЗначениеЗаполнено(ДатаАнализа) Тогда
		Возврат 0;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА (ВЫРАЗИТЬ(ВлЗапрос.ТекущийНомерТО КАК ЧИСЛО(13, 0))) = ВлЗапрос.ТекущийНомерТО
	|			ТОГДА ВлЗапрос.ТекущийНомерТО
	|		ИНАЧЕ ВЫРАЗИТЬ(ВлЗапрос.ТекущийНомерТО - 0.5 КАК ЧИСЛО(13, 0))
	|	КОНЕЦ КАК ТекущийНомерТО
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВЫРАЗИТЬ(РАЗНОСТЬДАТ(&ДатаПриобретения, &ДатаАнализа, МЕСЯЦ) / 12 КАК ЧИСЛО(10, 3)) КАК ТекущийНомерТО) КАК ВлЗапрос");
	Запрос.УстановитьПараметр("ДатаПриобретения", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Автомобиль, "ДатаПриобретения"));
	Запрос.УстановитьПараметр("ДатаАнализа", ДатаАнализа);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.ТекущийНомерТО;
	
КонецФункции

&НаСервереБезКонтекста
Функция ТаблицаПланТО(знач Автомобиль, знач ДатаАнализа)
	Возврат Документы.РегистрацииТО.ТаблицаПланТО(ДатаАнализа, Автомобиль);
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция УзнатьВидТОПоИмениЭлемента(ИмяЭлемента)
	
	ВидыТО = ПолучитьВидыТО();
	
	Для каждого ВидТО Из ВидыТО Цикл
		Если СтрНачинаетсяС(ИмяЭлемента, ВидТО) Тогда
			Возврат ВидТО;
		КонецЕсли;
	КонецЦикла;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьВидыТО()
	
	Возврат Документы.РегистрацииТО.ПолучитьВидыТО();
	
КонецФункции

#КонецОбласти