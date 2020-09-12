﻿	
// СтандартныеПодсистемы.В23ерсионированиеОбъектов
// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
// Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	Настройки.ПриПолученииСлужебныхРеквизитов = Истина;
КонецПроцедуры

// Ограничивает видимость реквизитов объекта в отчете по версии.
//
// Параметры:
// Реквизиты - Массив - список имен реквизитов объекта.
Процедура ПриПолученииСлужебныхРеквизитов(Реквизиты) Экспорт
    //Реквизиты.Добавить("ИмяРеквизита"); // реквизит объекта
    //Реквизиты.Добавить("ИмяТабличнойЧасти.*"); // табличная часть объекта
КонецПроцедуры
// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

//+ #201 Иванов А.Б. 2020-05-23 Изменения от Дениса Урянского @d-hurricane
// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Ссылка)";
	
КонецПроцедуры //- #201 Иванов А.Б. 2020-05-23 Изменения от Дениса Урянского @d-hurricane

Функция ПолучитьНомерЗадачи(ЗадачаСсылка) Экспорт 
	Возврат Формат(ЗадачаСсылка.Код,"ЧГ=0");
КонецФункции 

Функция ПолучитьКомментарииВКоде(ДопПараметры) Экспорт
	Перем КомментарииВКоде;
	
	пКод = ДопПараметры.Код;
	пИсполнитель = ДопПараметры.Исполнитель;
	пНомерВнешнейЗаявки = ДопПараметры.НомерВнешнейЗаявки;
	
	ФИОИсполнителя = Неопределено;
	Если ЗначениеЗаполнено(пИсполнитель) Тогда
		МассивПодстрок = СтрРазделить(пИсполнитель," ");
		КоличествоСлов = МассивПодстрок.Количество();
		Если КоличествоСлов > 0 Тогда
			ФИОИсполнителя = " "+ МассивПодстрок[0];
		Конецесли;
		Если КоличествоСлов > 1 Тогда
			ФИОИсполнителя = ФИОИсполнителя + " " + Лев(МассивПодстрок[1],1)+".";
		Конецесли;
		Если КоличествоСлов > 2 Тогда
			ФИОИсполнителя = ФИОИсполнителя + "" + Лев(МассивПодстрок[2],1)+".";
		Конецесли;	
	Конецесли;
	пКомментарииВКоде = "//+ #"+Формат(пКод,"ЧГ=0") 
		+ ?(ЗначениеЗаполнено(пНомерВнешнейЗаявки)," "+пНомерВнешнейЗаявки,"")
		+ ФИОИсполнителя
		+ " " + Формат(ТекущаяДатаСеанса(),"ДФ=yyyy-MM-dd"); 	
		
	Возврат пКомментарииВКоде;	
КонецФункции 

//+ #208 milanse 31.05.2020
Функция КонтактыПоЗадаче() Экспорт
	
	ТекстЗапросаДляПоиска = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	узЗадачи.Исполнитель КАК Исполнитель
	|ИЗ
	|	Справочник.узЗадачи КАК узЗадачи
	|ГДЕ
	|	узЗадачи.Ссылка = &Предмет
	|	И НЕ узЗадачи.Исполнитель = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	узЗадачи.Автор
	|ИЗ
	|	Справочник.узЗадачи КАК узЗадачи
	|ГДЕ
	|	узЗадачи.Ссылка = &Предмет
	|	И НЕ узЗадачи.Автор = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	узЗадачи.Контрагент
	|ИЗ
	|	Справочник.узЗадачи КАК узЗадачи
	|ГДЕ
	|	узЗадачи.Ссылка = &Предмет
	|	И НЕ узЗадачи.Исполнитель = ЗНАЧЕНИЕ(Справочник.узКонтрагенты.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	узНаблюдателиЗаЗадачами.Пользователь
	|ИЗ
	|	РегистрСведений.узНаблюдателиЗаЗадачами КАК узНаблюдателиЗаЗадачами
	|ГДЕ
	|	узНаблюдателиЗаЗадачами.Задача = &Предмет";
	
	ТекстЗапросаДляПоиска = "
	| ОБЪЕДИНИТЬ ВСЕ
	|" + ТекстЗапросаДляПоиска;
	
	Возврат ТекстЗапросаДляПоиска;	
		
КонецФункции

// СтандартныеПодсистемы.Взаимодействие
////////////////////////////////////////////////////////////////////////////////
// Интерфейс для работы с подсистемой Взаимодействия.

// Возвращает партнера и контактных лиц сделки.
// 
Функция ПолучитьКонтакты(Ссылка) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапросаПоКонтактам();
	Запрос.УстановитьПараметр("Предмет",Ссылка);
	
	НачатьТранзакцию();
	Попытка
		РезультатЗапроса = Запрос.Выполнить();
		
		Если РезультатЗапроса.Пустой() Тогда
			Результат = Неопределено;
		Иначе
			Результат = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Контакт");
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Возвращает текст запроса по контактам взаимодействий, содержащимся в документе.
//
// Параметры:
//  ТекстВременнаяТаблица - Строка - Имя временной таблицы, в которую помещаются полученные данные.
//  Объединить  - Булево  - признак, указывающий на необходимость добавления конструкции ОБЪЕДИНИТЬ в запрос.
//
// Возвращаемое значение:
//   Строка   - сформированный текст запроса для получения контактов взаимодействий объекта.
//
Функция ТекстЗапросаПоКонтактам(ТекстВременнаяТаблица = "", Объединить = Ложь) Экспорт
	
	ШаблонВыбрать = ?(Объединить,"ВЫБРАТЬ РАЗЛИЧНЫЕ","ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ");
	
	ТекстЗапроса = "
	|%ШаблонВыбрать%
	|	узЗадачи.Контрагент КАК Контакт " + ТекстВременнаяТаблица + "
	|ИЗ
	|	Справочник.узЗадачи КАК узЗадачи
	|ГДЕ
	|	узЗадачи.Ссылка = &Предмет
	|	И (НЕ узЗадачи.Контрагент = ЗНАЧЕНИЕ(Справочник.узКонтрагенты.ПустаяСсылка))
	|
	|";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"%ШаблонВыбрать%",ШаблонВыбрать);
	
	Если Объединить Тогда
		
		ТекстЗапроса = "
		| ОБЪЕДИНИТЬ ВСЕ
		|" + ТекстЗапроса;
		
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Конец СтандартныеПодсистемы.Взаимодействие

Функция ПолучитьНастройкиСобытий() Экспорт 
	РезультатФункции = Новый Структура();
	
	ВидыСобытий_ДобавленаЗадача = ПредопределенноеЗначение("Перечисление.узВидыСобытий.ДобавленаЗадача");
	ВидыСобытий_НовыйИсполнитель = ПредопределенноеЗначение("Перечисление.узВидыСобытий.НовыйИсполнитель");
	ВидыСобытий_ДобавленКомментарий = ПредопределенноеЗначение("Перечисление.узВидыСобытий.ДобавленКомментарий");
	ВидыСобытий_ИзмененКомментарий = ПредопределенноеЗначение("Перечисление.узВидыСобытий.ИзмененКомментарий");
	ВидыСобытий_ИзмененоОписаниеЗадачи = ПредопределенноеЗначение("Перечисление.узВидыСобытий.ИзмененоОписаниеЗадачи");
	ВидыСобытий_ИзменениеСтатуса = ПредопределенноеЗначение("Перечисление.узВидыСобытий.ИзменениеСтатуса");
	ВидыСобытий_ВходящееПисьмо = ПредопределенноеЗначение("Перечисление.узВидыСобытий.ВходящееПисьмо");
	ВидыСобытий_ВыполненаЗадача = ПредопределенноеЗначение("Перечисление.узВидыСобытий.ВыполненаЗадача");
	
	РезультатФункции.Вставить("ВидыСобытий_ДобавленаЗадача",ВидыСобытий_ДобавленаЗадача);
	РезультатФункции.Вставить("ВидыСобытий_НовыйИсполнитель",ВидыСобытий_НовыйИсполнитель);
	РезультатФункции.Вставить("ВидыСобытий_ДобавленКомментарий",ВидыСобытий_ДобавленКомментарий);
	РезультатФункции.Вставить("ВидыСобытий_ИзмененКомментарий",ВидыСобытий_ИзмененКомментарий);
	РезультатФункции.Вставить("ВидыСобытий_ИзмененоОписаниеЗадачи",ВидыСобытий_ИзмененоОписаниеЗадачи);
	РезультатФункции.Вставить("ВидыСобытий_ИзменениеСтатуса",ВидыСобытий_ИзменениеСтатуса);
	РезультатФункции.Вставить("ВидыСобытий_ВходящееПисьмо",ВидыСобытий_ВходящееПисьмо);
	РезультатФункции.Вставить("ВидыСобытий_ВыполненаЗадача",ВидыСобытий_ВыполненаЗадача);
	
	МассивСобытийДляНаблюдателяКоторыеПодлежатОтправки = Новый Массив();
	МассивСобытийДляНаблюдателяКоторыеПодлежатОтправки.Добавить(ВидыСобытий_ИзменениеСтатуса);
	МассивСобытийДляНаблюдателяКоторыеПодлежатОтправки.Добавить(ВидыСобытий_НовыйИсполнитель);
	МассивСобытийДляНаблюдателяКоторыеПодлежатОтправки.Добавить(ВидыСобытий_ДобавленКомментарий);
	МассивСобытийДляНаблюдателяКоторыеПодлежатОтправки.Добавить(ВидыСобытий_ИзмененКомментарий);
	МассивСобытийДляНаблюдателяКоторыеПодлежатОтправки.Добавить(ВидыСобытий_ВходящееПисьмо);
	
	РезультатФункции.Вставить("МассивСобытийДляНаблюдателяКоторыеПодлежатОтправки",МассивСобытийДляНаблюдателяКоторыеПодлежатОтправки);
	
	МассивСобытийКоторыеПодлежатОтправки = Новый Массив();
	МассивСобытийКоторыеПодлежатОтправки.Добавить(ВидыСобытий_ДобавленаЗадача);
	МассивСобытийКоторыеПодлежатОтправки.Добавить(ВидыСобытий_НовыйИсполнитель);
	МассивСобытийКоторыеПодлежатОтправки.Добавить(ВидыСобытий_ДобавленКомментарий);
	МассивСобытийКоторыеПодлежатОтправки.Добавить(ВидыСобытий_ИзмененКомментарий);
	МассивСобытийКоторыеПодлежатОтправки.Добавить(ВидыСобытий_ВходящееПисьмо);
	
	РезультатФункции.Вставить("МассивСобытийКоторыеПодлежатОтправки",МассивСобытийКоторыеПодлежатОтправки);
	
	МассивСобытийДляСтарогоИсполнителяКоторыеПодлежатОтправки = Новый Массив();
	МассивСобытийДляСтарогоИсполнителяКоторыеПодлежатОтправки.Добавить(ВидыСобытий_НовыйИсполнитель);
	РезультатФункции.Вставить("МассивСобытийДляСтарогоИсполнителяКоторыеПодлежатОтправки",МассивСобытийДляСтарогоИсполнителяКоторыеПодлежатОтправки);
	
	МассивСобытийДляКонтрагентовКоторыеПодлежатОтправки = Новый Массив();
	МассивСобытийДляКонтрагентовКоторыеПодлежатОтправки.Добавить(ВидыСобытий_ДобавленаЗадача);	
	МассивСобытийДляКонтрагентовКоторыеПодлежатОтправки.Добавить(ВидыСобытий_ВыполненаЗадача);	
	
	РезультатФункции.Вставить("МассивСобытийДляКонтрагентовКоторыеПодлежатОтправки",МассивСобытийДляКонтрагентовКоторыеПодлежатОтправки);
	
	
	Возврат РезультатФункции;	
КонецФункции 

Функция ЕстьЗаписиВРССвязанныеЗадачи(пЗадача, ОтбиратьЗаписиИПоСвязаннойЗадачи = Ложь) Экспорт
 
	пЕстьЗаписиВРССвязанныеЗадачи = Ложь;
	
	Если НЕ ЗначениеЗаполнено(пЗадача) Тогда
		Возврат пЕстьЗаписиВРССвязанныеЗадачи;
	Конецесли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	узСвязанныеЗадачи.Задача,
	               |	узСвязанныеЗадачи.СвязаннаяЗадача
	               |ИЗ
	               |	РегистрСведений.узСвязанныеЗадачи КАК узСвязанныеЗадачи
	               |ГДЕ
	               |	ВЫБОР
	               |			КОГДА &ОтбиратьЗаписиИПоСвязаннойЗадачи
	               |				ТОГДА узСвязанныеЗадачи.Задача = &Задача
	               |						ИЛИ узСвязанныеЗадачи.СвязаннаяЗадача = &Задача
	               |			ИНАЧЕ узСвязанныеЗадачи.Задача = &Задача
	               |		КОНЕЦ";
	
	Запрос.УстановитьПараметр("Задача",пЗадача);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		пЕстьЗаписиВРССвязанныеЗадачи = Истина;
	Конецесли;
	
	Возврат пЕстьЗаписиВРССвязанныеЗадачи;
КонецФункции 

Функция ПолучитьМассивНомеровСвязанныхЗадач(пЗадача) Экспорт	
	
	МассивНомеровСвязанныхЗадач = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	узСвязанныеЗадачи.СвязаннаяЗадача
	|ПОМЕСТИТЬ ВТРезультат
	|ИЗ
	|	РегистрСведений.узСвязанныеЗадачи КАК узСвязанныеЗадачи
	|ГДЕ
	|	узСвязанныеЗадачи.Задача = &Задача
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	узСвязанныеЗадачи.Задача
	|ИЗ
	|	РегистрСведений.узСвязанныеЗадачи КАК узСвязанныеЗадачи
	|ГДЕ
	|	узСвязанныеЗадачи.СвязаннаяЗадача = &Задача
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТРезультат.СвязаннаяЗадача.Код КАК НомерЗадачи
	|ИЗ
	|	ВТРезультат КАК ВТРезультат
	|ГДЕ
	|	ВТРезультат.СвязаннаяЗадача <> &Задача";
	
	Запрос.УстановитьПараметр("Задача",пЗадача);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат МассивНомеровСвязанныхЗадач;
	Конецесли;
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		МассивНомеровСвязанныхЗадач.Добавить(Формат(Выборка.НомерЗадачи,"ЧГ=0"));
	КонецЦикла;
	
	Возврат МассивНомеровСвязанныхЗадач;
КонецФункции

//+ #104 Дзеса Ігор (capitoshko) 08.10.2018
Функция ЗадачаБезПодчененнойИерархии(Ссылка) Экспорт 

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ узЗадачи.Ссылка) КАК КоличествоДокументов
	|ИЗ
	|	Справочник.узЗадачи КАК узЗадачи
	|ГДЕ
	|	узЗадачи.ОсновнаяЗадача В ИЕРАРХИИ(&Ссылка)";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	ВыборкаДокументов = Запрос.Выполнить().Выбрать();
	
	ВыборкаДокументов.Следующий();
	
	Если ВыборкаДокументов.КоличествоДокументов = 0 Тогда 
		Возврат Ложь;
	Иначе 
		Возврат Истина;
	КонецЕсли;
	
КонецФункции 
//- #104 Дзеса Ігор (capitoshko) 08.10.2018 

//+ГЕНА
Функция СловарьДляСообщений()
	
	СообщенияСловаря = Новый ТаблицаЗначений;
	СообщенияСловаря.Колонки.Добавить("Код"); // Фиксированный код в словаре
	СообщенияСловаря.Колонки.Добавить("Имя"); // Копируется в текст письма как параметр
	СообщенияСловаря.Колонки.Добавить("Текст"); // Получается из словаря
	
	СтрокаТЗ = СообщенияСловаря.Добавить();
	СтрокаТЗ.Код = 22;
	СтрокаТЗ.Имя = "узСловарь_Добрый_день";
	
	СтрокаТЗ = СообщенияСловаря.Добавить();
	СтрокаТЗ.Код = 23;
	СтрокаТЗ.Имя = "узСловарь_Номер_задачи";
	
	СтрокаТЗ = СообщенияСловаря.Добавить();
	СтрокаТЗ.Код = 24;
	СтрокаТЗ.Имя = "узСловарь_Описание_задачи";
	
	СтрокаТЗ = СообщенияСловаря.Добавить();
	СтрокаТЗ.Код = 25;
	СтрокаТЗ.Имя = "узСловарь_Комментарии";
	
	СтрокаТЗ = СообщенияСловаря.Добавить();
	СтрокаТЗ.Код = 26;
	СтрокаТЗ.Имя = "узСловарь_Реквизиты_задачи";
	
	СтрокаТЗ = СообщенияСловаря.Добавить();
	СтрокаТЗ.Код = 27;
	СтрокаТЗ.Имя = "узСловарь_Исполнитель";
	
	СтрокаТЗ = СообщенияСловаря.Добавить();
	СтрокаТЗ.Код = 28;
	СтрокаТЗ.Имя = "узСловарь_Статус";
	
	СтрокаТЗ = СообщенияСловаря.Добавить();
	СтрокаТЗ.Код = 29;
	СтрокаТЗ.Имя = "узСловарь_Важность";
	
	СтрокаТЗ = СообщенияСловаря.Добавить();
	СтрокаТЗ.Код = 30;
	СтрокаТЗ.Имя = "узСловарь_Основная_задача";
	
	МассивКодовСообщений = СообщенияСловаря.ВыгрузитьКолонку("Код");
	СтруктураСообщений = узОбщийМодульСервер.ПолучитьСтруктуруСообщений(МассивКодовСообщений);
	Для Каждого СтрокаТЗ Из СообщенияСловаря Цикл
		СтрокаТЗ.Текст = СтруктураСообщений["Текст" + СтрокаТЗ.Код];
	КонецЦикла;
	
	Возврат СообщенияСловаря;
	
КонецФункции
//-ГЕНА

//+ГЕНА
Функция ДополнительныеПараметрыДляСообщений()
	
	ДопПараметры = Новый ТаблицаЗначений;
	ДопПараметры.Колонки.Добавить("Код"); // Фиксированное имя переменной
	ДопПараметры.Колонки.Добавить("Имя"); // Копируется в текст письма как параметр
	ДопПараметры.Колонки.Добавить("Текст"); // Представление
	
	СтрокаТЗ = ДопПараметры.Добавить();
	СтрокаТЗ.Код = "узНомерЗадачи";
	СтрокаТЗ.Имя = "узНомер_задачи";
	СтрокаТЗ.Текст = НСтр("ru = 'Номер задачи'; en = 'Task number'");
	
	СтрокаТЗ = ДопПараметры.Добавить();
	СтрокаТЗ.Код = "узТемаПисьмаСобытие";
	СтрокаТЗ.Имя = "узТема_письма_событие";
	СтрокаТЗ.Текст = НСтр("ru = 'Тема письма (событие)'; en = 'Email subject (event)'");
	
	СтрокаТЗ = ДопПараметры.Добавить();
	СтрокаТЗ.Код = "узИзмененияПоКомментариям";
	СтрокаТЗ.Имя = "узИзменения_по_комментариям";
	СтрокаТЗ.Текст = НСтр("ru = 'Список изменений по комментариям'; en = 'List of changes by comments'");
	
	Возврат ДопПараметры;
	
КонецФункции
//-ГЕНА

//+ГЕНА
// СтандартныеПодсистемы.ШаблоныСообщений
// Вызывается при подготовке шаблонов сообщений и позволяет переопределить список реквизитов и вложений.
//
// Параметры:
//  Реквизиты               - ДеревоЗначений - список реквизитов шаблона.
//         ** Имя            - Строка - Уникальное имя общего реквизита.
//         ** Представление  - Строка - Представление общего реквизита.
//         ** Тип            - Тип    - Тип реквизита. По умолчанию строка.
//         ** Формат         - Строка - Формат вывода значения для чисел, дат, строк и булевых значений.
//  Вложения                - ТаблицаЗначений - печатные формы и вложения
//         ** Имя            - Строка - Уникальное имя вложения.
//         ** Представление  - Строка - Представление варианта.
//         ** ТипФайла       - Строка - Тип вложения, который соответствует расширению файла: "pdf", "png", "jpg", mxl" и др.
//  ДополнительныеПараметры - Структура - дополнительные сведения о шаблоне сообщений.
//
Процедура ПриПодготовкеШаблонаСообщения(Реквизиты, Вложения, ДополнительныеПараметры) Экспорт
	
	ПараметрыСообщения = ДополнительныеПараметры.ПараметрыСообщения;
	
	// Группа ".Словарь транслируемых слов"
	
	СообщенияСловаря = СловарьДляСообщений();
	
	// Кэширование таблицы для передачи в ПриФормированииСообщения при отправке сообщения
	ПараметрыСообщения.Вставить("узСообщенияСловаря", СообщенияСловаря);
	
	СтрокаСловарь = Реквизиты.Добавить();
	СтрокаСловарь.Имя = "узСловарь";
	СтрокаСловарь.Представление = НСтр("ru = '# Словарь транслируемых слов'; en = '# Dictionary of translated words'");
	
	Для Каждого СтрокаСообщения Из СообщенияСловаря Цикл
		СтрокаКод = СтрокаСловарь.Строки.Добавить();
		СтрокаКод.Имя = "узЗадачи." + СтрокаСообщения.Имя;
		СтрокаКод.Представление = СтрокаСообщения.Текст;
	КонецЦикла;
	
	// Группа ".Доп. параметры"
	
	СообщенияДопПараметров = ДополнительныеПараметрыДляСообщений();
	
	// Кэширование таблицы для передачи в ПриФормированииСообщения при отправке сообщения
	ПараметрыСообщения.Вставить("узСообщенияДопПараметров", СообщенияДопПараметров);
	
	СтрокаДопПараметры = Реквизиты.Добавить();
	СтрокаДопПараметры.Имя = "узДопПараметры";
	СтрокаДопПараметры.Представление = НСтр("ru = '# Динамические параметры'; en = '# Dynamic parameters'");
	
	Для Каждого СтрокаСообщения Из СообщенияДопПараметров Цикл
		СтрокаКод = СтрокаДопПараметры.Строки.Добавить();
		СтрокаКод.Имя = "узЗадачи." + СтрокаСообщения.Имя;
		СтрокаКод.Представление = СтрокаСообщения.Текст;
	КонецЦикла;
	
КонецПроцедуры
//_ГЕНА

//+ГЕНА
// Вызывается в момент создания сообщений по шаблону для заполнения значений реквизитов и вложений.
//
// Параметры:
//  Сообщение - Структура - структура с ключами:
//    * ЗначенияРеквизитов - Соответствие - список используемых в шаблоне реквизитов.
//      ** Ключ     - Строка - имя реквизита в шаблоне;
//      ** Значение - Строка - значение заполнения в шаблоне.
//    * ЗначенияОбщихРеквизитов - Соответствие - список используемых в шаблоне общих реквизитов.
//      ** Ключ     - Строка - имя реквизита в шаблоне;
//      ** Значение - Строка - значение заполнения в шаблоне.
//    * Вложения - Соответствие - значения реквизитов 
//      ** Ключ     - Строка - имя вложения в шаблоне;
//      ** Значение - ДвоичныеДанные, Строка - двоичные данные или адрес во временном хранилище вложения.
//  ПредметСообщения - ЛюбаяСсылка - ссылка на объект являющийся источником данных.
//  ДополнительныеПараметры - Структура -  Дополнительная информация о шаблоне сообщения.
//
Процедура ПриФормированииСообщения(Сообщение, ПредметСообщения, ДополнительныеПараметры) Экспорт
	
	ПараметрыСообщения = ДополнительныеПараметры.ПараметрыСообщения;
	
	Реквизиты = Сообщение.ЗначенияРеквизитов;
	
	Если ПараметрыСообщения.Свойство("узСообщенияСловаря") Тогда
		СообщенияСловаря = ПараметрыСообщения.узСообщенияСловаря;
	Иначе
		СообщенияСловаря = СловарьДляСообщений();
	КонецЕсли;
	Для Каждого СтрокаСообщения Из СообщенияСловаря Цикл
		Если Реквизиты[СтрокаСообщения.Имя] = "" Тогда
			Реквизиты[СтрокаСообщения.Имя] = СтрокаСообщения.Текст;
		КонецЕсли;
	КонецЦикла;
	
	Если ПараметрыСообщения.Свойство("узСообщенияДопПараметров") Тогда
		СообщенияДопПараметров = ПараметрыСообщения.узСообщенияДопПараметров;
	Иначе
		СообщенияДопПараметров = ДополнительныеПараметрыДляСообщений();
	КонецЕсли;
	
	Для Каждого СтрокаСообщения Из СообщенияДопПараметров Цикл
		Если Реквизиты[СтрокаСообщения.Имя] = "" Тогда
			Если ПараметрыСообщения.Свойство(СтрокаСообщения.Код) Тогда
				Реквизиты[СтрокаСообщения.Имя] = ПараметрыСообщения[СтрокаСообщения.Код];
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры
//-ГЕНА

//+ГЕНА
// Заполняет список получателей SMS при отправке сообщения сформированного по шаблону.
//
// Параметры:
//   ПолучателиSMS - ТаблицаЗначений - список получается SMS.
//     * НомерТелефона - Строка - номер телефона, куда будет отправлено сообщение SMS.
//     * Представление - Строка - представление получателя сообщения SMS.
//     * Контакт       - Произвольный - контакт, которому принадлежит номер телефона.
//  ПредметСообщения - ЛюбаяСсылка, Структура - ссылка на объект являющийся источником данных, либо структура,
//    * Предмет               - ЛюбаяСсылка - ссылка на объект являющийся источником данных
//    * ПроизвольныеПараметры - Соответствие - заполненный список произвольных параметров.//
//
Процедура ПриЗаполненииТелефоновПолучателейВСообщении(ПолучателиSMS, ПредметСообщения) Экспорт
КонецПроцедуры
//-ГЕНА

//+ГЕНА
// Заполняет список получателей письма при отправки сообщения сформированного по шаблону.
//
// Параметры:
//   ПолучателиПисьма - ТаблицаЗначений - список получается письма.
//     * Адрес           - Строка - адрес электронной почты получателя.
//     * Представление   - Строка - представление получается письма.
//     * Контакт         - Произвольный - контакт, которому принадлежит адрес электрнной почты.
//  ПредметСообщения - ЛюбаяСсылка, Структура - ссылка на объект являющийся источником данных, либо структура,
//                                              если шаблон содержит произвольные параметры:
//    * Предмет               - ЛюбаяСсылка - ссылка на объект являющийся источником данных
//    * ПроизвольныеПараметры - Соответствие - заполненный список произвольных параметров.
//
Процедура ПриЗаполненииПочтыПолучателейВСообщении(ПолучателиПисьма, ПредметСообщения) Экспорт
КонецПроцедуры
// Конец СтандартныеПодсистемы.ШаблоныСообщений
//-ГЕНА
