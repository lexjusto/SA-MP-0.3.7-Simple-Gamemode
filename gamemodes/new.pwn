//Especially for those who are just beginning to study the pawn! • by lexjusto ;)
//
@___If_u_can_read_this_u_r_nerd();
@___If_u_can_read_this_u_r_nerd()
{
    #emit    stack    0x7FFFFFFF
    #emit    inc.s    cellmax
    static const ___[][] = {"made with love by | lexjusto |"};
    #emit    retn
    #emit    load.s.pri    ___
    #emit    proc
    #emit    proc
    #emit    fill    cellmax
    #emit    proc
    #emit    stor.alt    ___
    #emit    strb.i    2
    #emit    switch    4
    #emit    retn
L1:
    #emit    jump    L1
    #emit    zero    cellmin
}

#include <a_samp>
#include <streamer>
#include <a_mysql>
#include <zcmd>
#include <sscanf2>
#include <colors>

#define MYSQL_HOST     			"127.0.0.1" // MYSQL HOSTNAME (DOMAIN\IP)
#define MYSQL_USER     			"root" //MYSQL USER
#define MYSQL_DB 				"astawnew" // MYSQL DATABASE
#define MYSQL_PASS 				"root" //MYSQL PASSWORD FOR USER
#define MYSQL_LOG_TYPE          LOG_ALL // LOG_NONE && LOG_ERROR && LOG_WARNING && LOG_DEBUG && LOG_ALL

#define TABLE_ACCOUNTS          "accounts" // ACCOUNTS TABLE
//
#define GAMEMODE_HOSTNAME       "Simple Gamemode (by lexjusto)" //HOSTNAME
#define GAMEMODE_NAME          	"Simple-GM" //GAMEMODE NAME
#define SUPPORT_EMAIL           "test@sa-mp.com"//SUPPORT EMAIL
//
#undef MAX_PLAYERS
#define MAX_PLAYERS 50 //Number of players specified in the server.cfg
//
#define INVALID_PLAYER_DATA 	-1
#define MAX_EMAIL_LEN    		64
#define MAX_PASSWORD_LEN     	36
#define MAX_IPADRESS_LEN      	40
#define MAX_CHATMESS_LEN        144
#define PlayerName(%1) 			PlayerInfo[%1][pName]
#define BYTES_PER_CELL 			(cellbits / 8)
#define publics:%0(%1)          forward %0(%1); public %0(%1)
#define HidePlayerDialog(%1) 	ShowPlayerDialog(%1,-1,0,"","","","")
//
#define COLOR_FADE1 			0xE6E6E6E6
#define COLOR_FADE2 			0xC8C8C8C8
#define COLOR_FADE3 			0xAAAAAAAA
#define COLOR_FADE4 			0x8C8C8C8C
#define COLOR_FADE5 			0x6E6E6E6E
//

main(){}

new MySQL_C1;
new query[1024];
new RolePlayChat = 1;

enum dZone
{
	zSpawnFAQ,
};
new DynamicZone[dZone];

enum pInfo
{
	//register info
	pID,
    pName[MAX_PLAYER_NAME],
    pEmail[MAX_EMAIL_LEN],
    pRegDate,
    pRegIP[MAX_IPADRESS_LEN],
	pLastDate,
    pLastIP[MAX_IPADRESS_LEN],
    pRegistered,
    pInvited[MAX_PLAYER_NAME],
    pGender,
    //
    bool:pLogged,
	pLevel,
	pMoney,
	pSkin,
};
new PlayerInfo[MAX_PLAYERS][pInfo];

enum tInfo
{
    pRegPassword[MAX_PASSWORD_LEN],
    pRegEmail[MAX_EMAIL_LEN],
    pRegInvited[MAX_PLAYER_NAME],
    pRegGender,
    pRegSkin,
};
new TempInfo[MAX_PLAYERS][tInfo];

//DIALOG`S
enum
{
	dNull,
	//
	dRegister,
	dRegisterEmail,
	dRegisterGender,
	dRegisterGender1,
	dRegisterSkin,
	dRegisterInvited,
	dRegisterEnd,
	dLogin,
	//
}

new Float:NewPlayerSpawns[][] =
{
    //{x, y, z, angle},
    {2804.1511, -2437.3279, 13.6297, 89.2193},
    {2759.0200, -2561.1782, 13.6383, 1.1954}
};

stock MySQLConnect()
{
    new connecttime = GetTickCount();

    MySQL_C1 = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_DB, MYSQL_PASS);
    if(mysql_errno()) return print("-> Connect to database '"MYSQL_DB"' has not been established!");
    else printf("-> Connect to database '"MYSQL_DB"' was successfully installed. (%d ms)", GetTickCount() - connecttime);

	return true;
}
public OnGameModeInit()
{
    new launchtime = GetTickCount();

    MySQLConnect(); //try connect

    if(mysql_errno())
	{
	    SendRconCommand("hostname "GAMEMODE_HOSTNAME" | *error*");
	    SetGameModeText(""GAMEMODE_NAME" | *error*");

		return MysqlErrorMessage(INVALID_PLAYER_ID);
	}
    else
    {
	    SendRconCommand("hostname "GAMEMODE_HOSTNAME"");
	    SetGameModeText(""GAMEMODE_NAME"");

        mysql_log(MYSQL_LOG_TYPE);

	   	EnableStuntBonusForAll(0);
	   	ShowPlayerMarkers(2);
		DisableInteriorEnterExits();

		CreatePickup(1239, 23, 1757.0731,-1943.8488,13.5688, -1); //Spawn FAQ Pickup
		DynamicZone[zSpawnFAQ] = CreateDynamicSphere(1757.0731,-1943.8488,13.5688,0.8,0,0,-1); //Spawn FAQ Pickup
		Create3DTextLabel("Начальная информация", 0xFF9900FF, 1757.0731,-1943.8488,14.2, 25.0, 0);
		Create3DTextLabel("_____________________", 0xFF9900FF, 1757.0731,-1943.8488,14.17, 25.0, 0);
		
		printf("-> Gamemode ("GAMEMODE_NAME") successfully launched! (%d ms)", GetTickCount() - launchtime);
	}
	return true;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return true;
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{
	if(areaid == DynamicZone[zSpawnFAQ]) return ShowPlayerDialog(playerid,dNull,DIALOG_STYLE_MSGBOX,"Начальная информация","Начальная информация об возможностях игры..\n...\n...\n...","Закрыть","");
	return true;
}

public OnGameModeExit()
{
	return true;
}

public OnPlayerRequestClass(playerid, classid)
{
	return 1;
}

stock PlayerClearChat(playerid, size) for(new s; s < size; s++) SendClientFormattedMessage(playerid, -1, " ");

public OnPlayerCommandReceived(playerid, cmdtext[])
{
    if(!PlayerInfo[playerid][pLogged]) { SendClientFormattedMessage(playerid, -1,"* Необходимо авторизоватся!"); return false; }

	return true;
}

public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
	if(success == -1)
	{
		return SendClientFormattedMessage(playerid, -1, "Ошибка! Команда не найдена!");
	}
	printf("Игрок %s только что использовал команду \"%s\"", PlayerName(playerid), cmdtext);
	return true;
}

public OnPlayerCommandText(playerid, cmdtext[]) return true;

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case dRegister:
		{
		    if(!response) return SendClientFormattedMessage(playerid, -1, "Вы отменили регистрацию."),PlayerKick(playerid);
		    if(!strlen(inputtext) || strlen(inputtext) < 3 || strlen(inputtext) > MAX_PASSWORD_LEN)
			{
			    SendClientFormattedMessage(playerid, -1, "Длина пароля должна быть от 3 до 36 символов! Попробуйте еще раз.");
			    return ShowPlayerDialog(playerid, dRegister, DIALOG_STYLE_INPUT, "{FFFFFF}Регистрация","{FFFFFF}Аккаунт {8B0000}не зарегистрирован{FFFFFF}, введите ваш пароль:","Далее","Отмена");
	        }
	        strmid(TempInfo[playerid][pRegPassword], inputtext, 0, strlen(inputtext), MAX_PASSWORD_LEN);
	        ShowPlayerDialog(playerid, dRegisterEmail, DIALOG_STYLE_INPUT, "{FFFFFF}Регистрация","Введите вашу электронную почту:","Далее","Отмена");
			return true;
		}
		case dRegisterEmail:
		{
  			if(!response) return SendClientFormattedMessage(playerid, -1, "Вы отменили регистрацию."),PlayerKick(playerid);
  			if(strfind(inputtext, "lexjusto", true) != -1) return ShowPlayerDialog(playerid, dRegisterEmail, DIALOG_STYLE_INPUT, "{FFFFFF}Регистрация","{FFFFFF}Шутки шутишь?..Смешно..ха-ха..\n\nВведите вашу электронную почту:","Далее","Отмена");
		    if(!strlen(inputtext) || strlen(inputtext) > MAX_EMAIL_LEN || strfind(inputtext, "@", true) == -1 || strfind(inputtext, ".", true) == -1)
			{
			    SendClientFormattedMessage(playerid, -1, "Вы ввели неккоректный электронный адрес, пример - 'lexjusto@yandex.com' (максимальная длина - 64 символа)");
			    return ShowPlayerDialog(playerid, dRegisterEmail, DIALOG_STYLE_INPUT, "{FFFFFF}Регистрация","{FFFFFF}Введите вашу электронную почту:","Далее","Отмена");
	        }
	        strmid(TempInfo[playerid][pRegEmail], inputtext, 0, strlen(inputtext), MAX_EMAIL_LEN);
	        ShowPlayerDialog(playerid, dRegisterGender, DIALOG_STYLE_LIST, "{FFFFFF}Регистрация","{FFFFFF}Пол вашего персонажа:\nМужской\nЖенский","Выбрать","Отмена");
			return true;
		}
		case dRegisterGender:
		{
		    if(!response) return SendClientFormattedMessage(playerid, -1, "Вы отменили регистрацию."),PlayerKick(playerid);
		    switch(listitem)
		    {
		        case 0: return ShowPlayerDialog(playerid, dRegisterGender, DIALOG_STYLE_LIST, "{FFFFFF}Регистрация","{FFFFFF}Пол вашего персонажа:\nМужской\nЖенский","Выбрать","Отмена");
		        case 1: TempInfo[playerid][pRegGender] = 1;
		        case 2: TempInfo[playerid][pRegEmail] = 2;
		        default: TempInfo[playerid][pRegGender] = 1;
		    }
		    ShowPlayerDialog(playerid, dRegisterSkin, DIALOG_STYLE_LIST, "{FFFFFF}Регистрация","Skin №1\nSkin №2\nSkin №3\nSkin №4\nSkin №5","Выбрать","Отмена");
		    return true;
		}
		case dRegisterSkin:
		{
		    if(!response) return SendClientFormattedMessage(playerid, -1, "Вы отменили регистрацию."),PlayerKick(playerid);

		    switch(listitem)
		    {
		        case 0..4: TempInfo[playerid][pRegSkin] = listitem+1;
		        default: TempInfo[playerid][pRegSkin] = 1;
		    }
		    ShowPlayerDialog(playerid, dRegisterInvited, DIALOG_STYLE_INPUT, "{FFFFFF}Регистрация","{FFFFFF}Введите ник человека пригласившего вас на сервер (если такового нет - пропустите данный шаг):","Далее","Пропустить");

			return true;
	  	}
		case dRegisterInvited:
		{
		    if(response)
		    {
			    if(strfind(inputtext, "lexjusto", true) != -1) return ShowPlayerDialog(playerid, dRegisterInvited, DIALOG_STYLE_INPUT, "{FFFFFF}Регистрация","{FFFFFF}Шутки шутишь?..Смешно..ха-ха..завязывай..\n\nВведите ник человека пригласившего вас на сервер (если такового нет - пропустите данный шаг):","Далее","Пропустить");
			    if(!strlen(inputtext) || strlen(inputtext) > MAX_PLAYER_NAME)
			    {
			    	SendClientFormattedMessage(playerid, -1, "Вы ввели неккоректный ник пригласившего вас игрока, пример - 'lexjusto'");
				    return ShowPlayerDialog(playerid, dRegisterInvited, DIALOG_STYLE_INPUT, "{FFFFFF}Регистрация","{FFFFFF}Введите ник человека пригласившего вас на сервер (если такового нет - пропустите данный шаг):","Далее","Пропустить");
			    }
			    strmid(TempInfo[playerid][pRegInvited], inputtext, 0, strlen(inputtext), MAX_PLAYER_NAME);
		    }
		    if(!response) TempInfo[playerid][pRegInvited] = 0;
			new regstr[512];
			new reginv[MAX_PLAYER_NAME];
			if(TempInfo[playerid][pRegInvited] == 0) reginv = "* Шаг пропущен *";
			else strmid(reginv, TempInfo[playerid][pRegInvited], 0, strlen(TempInfo[playerid][pRegInvited]), MAX_PLAYER_NAME);
			format(regstr,sizeof(regstr),"\
			{FFFFFF}Проверьте правильность введенных вами данных и сделайте скриншот, если нужно.\n\n\
			Имя:\t\t%s\nПароль:\t%s\nE-Mail:\t\t%s\nПол:\t\t%s\nСкин:\t\t№%d\nРеферал:\t%s",PlayerName(playerid),TempInfo[playerid][pRegPassword],TempInfo[playerid][pRegEmail],(TempInfo[playerid][pRegGender] == 1) ? ("Мужчина") : ("Женщина"), TempInfo[playerid][pRegSkin], reginv);
		    ShowPlayerDialog(playerid, dRegisterEnd, DIALOG_STYLE_MSGBOX, "{FFFFFF}Регистрация",regstr,"Верно","Повтор");
		    return true;
		}
		case dRegisterEnd:
		{
			if(response) PlayerCreateAccount(playerid, TempInfo[playerid][pRegEmail], TempInfo[playerid][pRegPassword], TempInfo[playerid][pRegInvited], TempInfo[playerid][pRegGender], TempInfo[playerid][pRegSkin]);
			if(!response)
			{
				PlayerClearChat(playerid,50);
				SendClientFormattedMessage(playerid, -1, "Вы решили пройти регистрацию с самого начала.");
				return ShowPlayerDialog(playerid, dRegister, DIALOG_STYLE_INPUT, "{FFFFFF}Регистрация","{FFFFFF}Аккаунт {8B0000}не зарегистрирован{FFFFFF}, введите ваш пароль:","Далее","Отмена");
			}

			TempInfo[playerid][pRegPassword] = INVALID_PLAYER_DATA;
			TempInfo[playerid][pRegEmail] = INVALID_PLAYER_DATA;
			TempInfo[playerid][pRegGender] = INVALID_PLAYER_DATA;
			TempInfo[playerid][pRegSkin] = INVALID_PLAYER_DATA;
			TempInfo[playerid][pRegInvited] = INVALID_PLAYER_DATA;

		    return true;
  		}
		case dLogin:
		{
		    if(!response) return SendClientFormattedMessage(playerid, -1, "Вы отменили авторизацию."),PlayerKick(playerid);
		    if(!strlen(inputtext) || strlen(inputtext) < 3 || strlen(inputtext) > MAX_PASSWORD_LEN)
			{
			    SendClientFormattedMessage(playerid, -1, "Длина пароля должна быть от 3 до 36 символов! Попробуйте еще раз.");
			    return ShowPlayerDialog(playerid, dLogin, DIALOG_STYLE_INPUT, "{FFFFFF}Авторизация","{FFFFFF}Аккаунт {006400}зарегистрирован{FFFFFF}, введите ваш пароль:","Далее","Отмена");
		    }
			mysql_format(MySQL_C1, query,sizeof(query), "SELECT * FROM `"TABLE_ACCOUNTS"` WHERE `name` = '%e' AND `password` = MD5(MD5(CONCAT(`regdate` + '%e'))) LIMIT 0,1", PlayerName(playerid), inputtext);
	  		mysql_function_query(MySQL_C1, query, true, "PlayerLogin","d", playerid);

	  		if(mysql_errno()) return MysqlErrorMessage(playerid);

	  		return true;
		}
	}
	return 1;
}
public OnPlayerSpawn(playerid)
{
	if(!PlayerInfo[playerid][pLogged]) return SendClientFormattedMessage(playerid,-1,"Необходимо авторизоваться!"),PlayerKick(playerid);

	PlayerSpawn(playerid);

 	SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
    SetPlayerScore(playerid, PlayerInfo[playerid][pLevel]);

	return true;
}

stock PlayerSpawn(playerid)
{
    if(!PlayerInfo[playerid][pLogged]) return SendClientFormattedMessage(playerid,-1,"Необходимо авторизоваться!"),PlayerKick(playerid);


   	new randomspawn = random(sizeof(NewPlayerSpawns));
	SetPlayerPos(playerid, NewPlayerSpawns[randomspawn][0], NewPlayerSpawns[randomspawn][1], NewPlayerSpawns[randomspawn][2]);
    SetPlayerFacingAngle(playerid, NewPlayerSpawns[randomspawn][3]);

	SetCameraBehindPlayer(playerid);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	return true;
}

public OnPlayerUpdate(playerid)
{
    PlayerUpdateMoney(playerid);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return true;
}

stock PlayerUpdateMoney(playerid)
{
	new money = GetPlayerMoney(playerid);
	if(PlayerInfo[playerid][pMoney] > money)
	{
		ResetPlayerMoney(playerid);
		GivePlayerMoney(playerid, PlayerInfo[playerid][pMoney]);
	}
	else if(PlayerInfo[playerid][pMoney] < money)
	{
		ResetPlayerMoney(playerid);
		GivePlayerMoney(playerid, PlayerInfo[playerid][pMoney]);
	}
	return true;
}

stock MysqlErrorMessage(playerid)
{
    if(playerid == INVALID_PLAYER_ID) return printf("-> Error sending the query to the database! (Error Code: #%d)",mysql_errno());
	else
	{
 		PlayerClearChat(playerid, 50);
		new mysqlerror[MAX_CHATMESS_LEN];
		format(mysqlerror,sizeof(mysqlerror),"В данный момент сервер испытывает проблемы с базой данных. (Код ошибки: #%d)",mysql_errno());
	    SendClientFormattedMessage(playerid, -1, mysqlerror);
	    SendClientFormattedMessage(playerid, -1, "Попробуйте совершить действие пойже, по возможности сообщите о проблеме по адресу - "SUPPORT_EMAIL"");
		PlayerKick(playerid);

		printf("-> Error sending the query to the database! (Error Code: #%d) | (Player: %s[%d])",mysql_errno(),PlayerName(playerid),playerid);
	}
	return true;
}
public OnPlayerConnect(playerid)
{
	ResetPlayerInfo(playerid);

	GetPlayerName(playerid, PlayerInfo[playerid][pName], MAX_PLAYER_NAME);

	SetTimerEx("OnPlayerJoin", 150, false, "d", playerid);

	return true;
}

publics: OnPlayerJoin(playerid)
{
	PlayerClearChat(playerid, 50);

	SendClientFormattedMessage(playerid, -1, "Добро пожаловать на сервер - LexJusto RolePlay");

    mysql_format(MySQL_C1, query, sizeof(query), "SELECT `name` FROM `"TABLE_ACCOUNTS"` WHERE `name` = '%e'", PlayerName(playerid));
	mysql_function_query(MySQL_C1, query, true, "PlayerCheckRegister", "d", playerid);

	if(mysql_errno()) return MysqlErrorMessage(playerid);

	return true;
}

stock PlayerKick(i) return SetTimerEx("KickFix", 250, false, "d", i);
publics: KickFix(i)
{
	SendClientFormattedMessage(i, -1, "Для выхода из игры используйте команду /q(uit)");
	Kick(i);
	return true;
}

stock ResetPlayerInfo(playerid)
{
	//PlayerInfo
	//register info
	PlayerInfo[playerid][pLogged] = false;
	PlayerInfo[playerid][pID] = INVALID_PLAYER_DATA;
	PlayerInfo[playerid][pName] = INVALID_PLAYER_DATA;
	PlayerInfo[playerid][pEmail] = INVALID_PLAYER_DATA;
	PlayerInfo[playerid][pRegDate] = INVALID_PLAYER_DATA;
	PlayerInfo[playerid][pRegIP] = INVALID_PLAYER_DATA;
	PlayerInfo[playerid][pLastDate] = INVALID_PLAYER_DATA;
	PlayerInfo[playerid][pLastIP] = INVALID_PLAYER_DATA;
	PlayerInfo[playerid][pRegistered] = INVALID_PLAYER_DATA;
	PlayerInfo[playerid][pInvited] = INVALID_PLAYER_DATA;
	PlayerInfo[playerid][pGender] = INVALID_PLAYER_DATA;
	//
	PlayerInfo[playerid][pLevel] = INVALID_PLAYER_DATA;
	PlayerInfo[playerid][pMoney] = INVALID_PLAYER_DATA;
	PlayerInfo[playerid][pSkin] = INVALID_PLAYER_DATA;
	//
	//TempInfo
	TempInfo[playerid][pRegPassword] = INVALID_PLAYER_DATA;
	TempInfo[playerid][pRegEmail] = INVALID_PLAYER_DATA;
	TempInfo[playerid][pRegGender] = INVALID_PLAYER_DATA;
	TempInfo[playerid][pRegSkin] = INVALID_PLAYER_DATA;
	TempInfo[playerid][pRegInvited] = INVALID_PLAYER_DATA;

	return true;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(PlayerInfo[playerid][pLogged] == true) PlayerSaveData(playerid);

	return true;
}

publics: PlayerCheckRegister(playerid)
{
	new rows, fields;
	cache_get_data(rows, fields);

	if(rows) ShowPlayerDialog(playerid, dLogin, DIALOG_STYLE_PASSWORD, "{FFFFFF}Авторизация","{FFFFFF}Аккаунт {006400}зарегистрирован{FFFFFF}, введите ваш пароль:","Далее","Отмена");
	else ShowPlayerDialog(playerid, dRegister, DIALOG_STYLE_INPUT, "{FFFFFF}Регистрация","{FFFFFF}Аккаунт {8B0000}не зарегистрирован{FFFFFF}, введите ваш пароль:","Далее","Отмена");
 	return true;
}

publics: PlayerCreateAccount(playerid, regemail[], regpassword[], reginvited[], reggender, regskin)
{
	new regip[MAX_IPADRESS_LEN];
	GetPlayerIp(playerid, regip, sizeof(regip));
	mysql_format(MySQL_C1, query, sizeof(query), "INSERT INTO `"TABLE_ACCOUNTS"` (`name`, `email`, `password`, `regdate`, `regip`, `registered`, `invited`, `gender`, `skin`) VALUES ('%e', '%e', MD5(MD5(CONCAT('%i' + '%e'))), '%i', '%e', '%i', '%e', '%i', '%i')",
  	PlayerName(playerid), regemail, gettime(), regpassword, gettime(), regip, 0, reginvited, reggender, regskin);
	mysql_function_query(MySQL_C1, query, false, "","");

	if(mysql_errno()) return MysqlErrorMessage(playerid);

	mysql_format(MySQL_C1, query,sizeof(query), "SELECT * FROM `"TABLE_ACCOUNTS"` WHERE `name` = '%e' LIMIT 0,1", PlayerName(playerid));
	mysql_function_query(MySQL_C1, query, true, "PlayerLogin","d", playerid);

	if(mysql_errno()) return MysqlErrorMessage(playerid);

    return true;
}

publics: PlayerLogin(playerid)
{
    new rows, fields;
	cache_get_data(rows, fields);
	if(!rows)
	{
	    SendClientFormattedMessage(playerid, -1, "Вы ввели не верный пароль! Попробуйте ещё раз.");
		return ShowPlayerDialog(playerid, dLogin, DIALOG_STYLE_PASSWORD, "Авторизация","Аккаунт зарегистрирован, введите ваш пароль:","Далее","Отмена");
	}
	else PlayerLoadData(playerid);
    return true;
}

stock PlayerLoadData(playerid)
{
	new rowid = 0;

    //register info
    PlayerInfo[playerid][pID] = cache_get_field_content_int(rowid, "id", MySQL_C1);
    cache_get_field_content(rowid, "email", PlayerInfo[playerid][pEmail], MySQL_C1, MAX_EMAIL_LEN);
    PlayerInfo[playerid][pRegDate] = cache_get_field_content_int(rowid, "regdate", MySQL_C1);
    cache_get_field_content(rowid, "regip", PlayerInfo[playerid][pRegIP], MySQL_C1, MAX_IPADRESS_LEN);
    PlayerInfo[playerid][pLastDate] = cache_get_field_content_int(rowid, "lastdate", MySQL_C1);
    cache_get_field_content(rowid, "lastip", PlayerInfo[playerid][pLastIP], MySQL_C1, MAX_IPADRESS_LEN);
    PlayerInfo[playerid][pRegistered] = cache_get_field_content_int(rowid, "registered", MySQL_C1);
    cache_get_field_content(rowid, "invited", PlayerInfo[playerid][pInvited], MySQL_C1, MAX_PLAYER_NAME);
    PlayerInfo[playerid][pGender] = cache_get_field_content_int(rowid, "gender", MySQL_C1);
    //
    PlayerInfo[playerid][pLevel] = cache_get_field_content_int(rowid, "level", MySQL_C1);
    PlayerInfo[playerid][pMoney] = cache_get_field_content_int(rowid, "money", MySQL_C1);
    PlayerInfo[playerid][pSkin] = cache_get_field_content_int(rowid, "skin", MySQL_C1);
	//

    if(PlayerInfo[playerid][pRegistered] == 0)
    {
        PlayerInfo[playerid][pLevel] = 1;
        PlayerInfo[playerid][pMoney] = 250;
        PlayerInfo[playerid][pRegistered] = 1;

   		mysql_format(MySQL_C1,query,sizeof(query),"UPDATE "TABLE_ACCOUNTS" SET `registered` = '%i', `level` = '%i', `money` = '%i' WHERE `name` = '%e'", PlayerInfo[playerid][pRegistered], PlayerInfo[playerid][pLevel], PlayerInfo[playerid][pMoney], PlayerName(playerid));
		mysql_function_query(MySQL_C1, query, false, "", "");

		if(mysql_errno()) return MysqlErrorMessage(playerid);

  		SetPlayerHealth(playerid, 100);
    	SendClientFormattedMessage(playerid, -1, "Регистрация игрового аккаунта успешно завершена!");
    }
    else
    {
        SetPlayerHealth(playerid, 100);
        SendClientFormattedMessage(playerid, -1, "Вы успешно авторизовались!");
    }

    PlayerInfo[playerid][pLogged] = true;

    SpawnPlayer(playerid);

    new lastip[MAX_IPADRESS_LEN];
    GetPlayerIp(playerid, lastip, sizeof(lastip));
	mysql_format(MySQL_C1,query,sizeof(query),"UPDATE "TABLE_ACCOUNTS" SET `lastdate` = '%i', `lastip` = '%e', `logged` = '%i' WHERE `name` = '%e'",gettime(), lastip, PlayerInfo[playerid][pLogged], PlayerName(playerid));
	mysql_function_query(MySQL_C1, query, false, "", "");

	if(mysql_errno()) return MysqlErrorMessage(playerid);

    return true;
}

public OnPlayerText(playerid, text[])
{
    new chattext[MAX_CHATMESS_LEN];
    if(PlayerInfo[playerid][pLogged] == false) return SendClientFormattedMessage(playerid, -1, "Прежде чем писать что либо в чат, вам необходимо авторизоваться!");

	if(RolePlayChat)
	{
	 	if(strlen(text) < 1 || strlen(text) > MAX_CHATMESS_LEN) return SendClientFormattedMessage(playerid, -1,"Сообщение не соответствует разрешенному размеру!");

		format(chattext,sizeof(chattext),"- %s(%i): %s",PlayerName(playerid),playerid,text);
		ProxDetector(20.0, playerid, chattext,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
		SetPlayerChatBubble(playerid, text, COLOR_WHITE, 20.0, 7000);
		ApplyAnim(playerid, "PED", "IDLE_CHAT",4.1,0,1,1,1,1,1);
		SetTimerEx("ClearAnim", 100*strlen(text), false, "d", playerid);
		return false;
	}
	return true;
}

stock ApplyAnim(playerid,name[],anim[],Float:speed,p,p2,p3,p4,p5,p6 = 0)
{
	if(!IsPlayerInAnyVehicle(playerid)) ApplyAnimation(playerid,name,anim,speed,p,p2,p3,p4,p5,p6);
	return true;
}
publics: ClearAnim(playerid) return ApplyAnimation(playerid, "CARRY", "crry_prtial",4.0,0,0,0,0,0,1);

stock ProxDetector(Float:radi, playerid, string[],col1,col2,col3,col4,col5)
{
    new Float:posx, Float:posy, Float:posz;
    new Float:oldposx, Float:oldposy, Float:oldposz;
    new Float:tempposx, Float:tempposy, Float:tempposz;
    GetPlayerPos(playerid, oldposx, oldposy, oldposz);
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            GetPlayerPos(i, posx, posy, posz);
            tempposx = (oldposx -posx);
            tempposy = (oldposy -posy);
            tempposz = (oldposz -posz);
            if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i))
            {
                if (((tempposx < radi/16) && (tempposx > -radi/16)) && ((tempposy < radi/16) && (tempposy > -radi/16)) && ((tempposz < radi/16) && (tempposz > -radi/16))) SendClientMessage(i, col1, string);
                else if (((tempposx < radi/8) && (tempposx > -radi/8)) && ((tempposy < radi/8) && (tempposy > -radi/8)) && ((tempposz < radi/8) && (tempposz > -radi/8)))SendClientMessage(i, col2, string);
                else if (((tempposx < radi/4) && (tempposx > -radi/4)) && ((tempposy < radi/4) && (tempposy > -radi/4)) && ((tempposz < radi/4) && (tempposz > -radi/4)))SendClientMessage(i, col3, string);
                else if (((tempposx < radi/2) && (tempposx > -radi/2)) && ((tempposy < radi/2) && (tempposy > -radi/2)) && ((tempposz < radi/2) && (tempposz > -radi/2)))SendClientMessage(i, col4, string);
                else if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))SendClientMessage(i, col5, string);
            }
        }
    }
    return 1;
}

stock PlayerSaveData(playerid)
{
    PlayerInfo[playerid][pLogged] = false;

  	mysql_format(MySQL_C1, query, sizeof(query),"UPDATE `"TABLE_ACCOUNTS"` SET \
  	`logged` = '%d', \
	`level` = '%d', \
	`money` = '%d', \
	`skin` = '%d' \
	WHERE `name` = '%e'",
	PlayerInfo[playerid][pLogged],
	PlayerInfo[playerid][pLevel],
	PlayerInfo[playerid][pMoney],
	PlayerInfo[playerid][pSkin],
	PlayerInfo[playerid][pName]
	);
	mysql_tquery(MySQL_C1, query, "", "");

	if(mysql_errno()) return MysqlErrorMessage(playerid);

	return true;
}

SendClientFormattedMessage(playerid, color, fstring[], {Float, _}:...)
{
    static const
        STATIC_ARGS = 3;
    new
        n = (numargs() - STATIC_ARGS) * BYTES_PER_CELL;
    if (n)
    {
        new
            message[144],
            arg_start,
            arg_end;
        #emit CONST.alt        fstring
        #emit LCTRL          5
        #emit ADD
        #emit STOR.S.pri        arg_start

        #emit LOAD.S.alt        n
        #emit ADD
        #emit STOR.S.pri        arg_end
        do
        {
            #emit LOAD.I
            #emit PUSH.pri
            arg_end -= BYTES_PER_CELL;
            #emit LOAD.S.pri      arg_end
        }
        while (arg_end > arg_start);

        #emit PUSH.S          fstring
        #emit PUSH.C          128
        #emit PUSH.ADR         message

        n += BYTES_PER_CELL * 3;
        #emit PUSH.S          n
        #emit SYSREQ.C         format

        n += BYTES_PER_CELL;
        #emit LCTRL          4
        #emit LOAD.S.alt        n
        #emit ADD
        #emit SCTRL          4

        return SendClientMessage(playerid, color, message);
    }
    else
    {
        return SendClientMessage(playerid, color, fstring);
    }
}

//COMMAND`S
COMMAND:mymenu(playerid, params[])
{
    SendClientFormattedMessage(playerid, -1,"Тестовая команда.");
    return true;
}

