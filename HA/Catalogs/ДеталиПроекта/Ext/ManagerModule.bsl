﻿
#Область ПрограммныйИнтерфейс

Функция ЗапроситьПараметрыДетали(МассивСсылок) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ДеталиПроектаХарактеристики.Характеристика КАК Характеристика,
	|	ДеталиПроектаХарактеристики.Характеристика.ЕдиницаИзмерения.ТипХарактеристики КАК ТипХарактеристики,
	|	0 КАК Значение
	|ИЗ
	|	Справочник.ДеталиПроекта.Характеристики КАК ДеталиПроектаХарактеристики
	|ГДЕ
	|	ДеталиПроектаХарактеристики.Ссылка В (&Ссылка)");
	Запрос.УстановитьПараметр("Ссылка", МассивСсылок);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецОбласти

