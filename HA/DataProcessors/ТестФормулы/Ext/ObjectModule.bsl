﻿Перем КонтекстЯдра;
Перем Ожидаем;

Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	КонтекстЯдра = КонтекстЯдраПараметр;
	Ожидаем = КонтекстЯдра.Плагин("УтвержденияBDD");
	
КонецПроцедуры

Функция ПолучитьСписокТестов() Экспорт
	ВсеТесты = Новый Массив;
	ВсеТесты.Добавить("ТестРасссчитатьЗначенияФормул");
	
	Возврат ВсеТесты;
КонецФункции

Процедура ТестРасссчитатьЗначенияФормул() Экспорт
	
	Аргументы = Новый Соответствие;
	Аргументы.Вставить(Справочники.ФизическиеХарактеристики.Длинам.Наименование, 10);
	Аргументы.Вставить(Справочники.ФизическиеХарактеристики.Ширинам.Наименование, 5);
	Аргументы.Вставить(Справочники.ФизическиеХарактеристики.Высотам.Наименование, 10);
	
	// Простая формула
	Результат = Справочники.Формулы.РасссчитатьЗначенияФормул(
		ОбщегоНазначения.ЗначениеВМассив(Справочники.Формулы.Sпрям), Аргументы);
	
	Ожидаем
	.Что(Результат.Получить(Справочники.Формулы.Sпрям))
	.Равно(50);
	
	// Рекурсивная формула
	Результат = Справочники.Формулы.РасссчитатьЗначенияФормул(
		ОбщегоНазначения.ЗначениеВМассив(Справочники.Формулы.ФормулаГерона), Аргументы);
	
	Ожидаем
	.Что(Окр(Результат.Получить(Справочники.Формулы.ФормулаГерона), 0))
	.Равно(24);
	
	// Формула не задана
	ПараметрыМетода = Новый Массив;
	ПараметрыМетода.Добавить(Неопределено);
	ПараметрыМетода.Добавить(Аргументы);
	
	Ожидаем
	.Метод("Справочники.Формулы.РасссчитатьЗначенияФормул", ПараметрыМетода)
	.ВыбрасываетИсключение(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	
КонецПроцедуры
