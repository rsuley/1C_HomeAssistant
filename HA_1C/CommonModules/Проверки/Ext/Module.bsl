﻿////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для реализации asserts
// 
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

Процедура СвойствоЗаполнено(Свойство) Экспорт
	
	Если Не ЗначениеЗаполнено(Свойство) Тогда
		ВызватьИсключение "Ошибка. Свойство должно быть заполнено";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти