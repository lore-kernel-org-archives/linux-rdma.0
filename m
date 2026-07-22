Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11023100.outbound.protection.outlook.com [40.107.159.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DFE46D08E;
	Wed, 22 Jul 2026 09:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.100
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784711900; cv=fail; b=EhYT0+KQslNMDNpY1A9qN/gXHDaaQfvPQhJGNBSlsSivTolC1cRHzfbD2jz2cO2B98rANSCqho9EoBOQ5qi5ysNIpjZdDf7Rd3OyWC9WCEpbgy5/IV9r4GOOeLQwQGry4IXGYKZHmoX0KrRiidyUYAbzzPfqIo+lNQ3rccrRHPA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784711900; c=relaxed/simple;
	bh=lB0w2pWB57LvAS3sG8fU9cxsy7n9GzJBAj5ikWtsbDQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XZsUlW+6vR2dJLaV53+ptMcWYxOT8opVc3ngH5FuKQF1TrR7tuB42V2/TLR1wUNgVdph9w7g0RWrZDF+M0Yd4vfHdqCGeRVjbxqClmHrsJOCsd2XUgrmjlb1QUecRCJTbT1pyZweFAwLoVSuiNZmh5TVVgVcgjSBm9j+elhQ/3o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=UYGOqTm9; arc=fail smtp.client-ip=40.107.159.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="UYGOqTm9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hZbQKa6g1DT3RsySc/2vCM8dFSO8IozIjbCztKPmmL3dW8cK8VvEDAn+pxV9pBTXoAPp6dori3nWTpchIcZuB7urHcn6k2jEXzzruNgbq87QUe5xRvojcVWob75aKa2Oc6IghsKpEYQV0iuMqDUf9mk31b4OvajXuGkO+WiaUOlf+ZKEbFdh26RwW59kx3P8M2GO3JyFQyPu4TarDrv+ri+oPc2TQT9X/j8Y44LnkfmojPDEOgBvHb16xwk7xgLxGUaVl9eFAjDDiiuvImlhK7ybtdkaq59lzwULOBori6h/Erk4PINA1hqvhZeB5T21HmoxzHYb/1r6r/A8pQAW0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lB0w2pWB57LvAS3sG8fU9cxsy7n9GzJBAj5ikWtsbDQ=;
 b=qnfdbR1u8xmu7SMMRo77feIb6t9sa6Wr0i4j3Z8fqJ501EjC11/zYWBrY+lKZCBSIf21kdRXBsZkj0lDDY7s5k2ihwP5vgqJCjNsFjHaclEdw5EwVh7M6yhKb9BV6STpD00AV5hyG6i7Uad3dk7nfXhrG2X6RPJiZtWZfEvXtpzHZrm1novyb7zX8ITPWHBTJU8tl54n9CwNdm2OtbVxZSSOLohMYM4rqP3Opr3j1oUUzpY8yfEmpkBqadQvqlPwso+7HZXc2zeJCPztwXbqZGKcOFWeKuGCOAEPNNNdq3+5Gi4D2xXRNiknx/o4UrPGvsgzwXloR1VkWTPYvMDN/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lB0w2pWB57LvAS3sG8fU9cxsy7n9GzJBAj5ikWtsbDQ=;
 b=UYGOqTm96R91+0vTwqmjPP0yzTB6TVHjmFzvejwCOWmMlhQMAz6cq94IDmfoLGSvcqU5myUb5j+cnLV2bW2rIixeQGByRUf08sCK2ahNqxAQUeMqBBnGqeU1IyA7Ql+0WXdJuL1rizxuijFf1eBD+22v+aogfd8vzwiXFHJQyhw=
Received: from DU8PR83MB0975.EURPRD83.prod.outlook.com (2603:10a6:10:5cb::5)
 by VI2PR83MB0815.EURPRD83.prod.outlook.com (2603:10a6:800:271::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.4; Wed, 22 Jul
 2026 09:18:12 +0000
Received: from DU8PR83MB0975.EURPRD83.prod.outlook.com
 ([fe80::b11f:dc15:ff12:53e]) by DU8PR83MB0975.EURPRD83.prod.outlook.com
 ([fe80::b11f:dc15:ff12:53e%6]) with mapi id 15.21.0270.004; Wed, 22 Jul 2026
 09:18:12 +0000
From: Konstantin Taranov <kotaranov@microsoft.com>
To: Leon Romanovsky <leon@kernel.org>, Long Li <longli@microsoft.com>, Jason
 Gunthorpe <jgg@ziepe.ca>, Shiraz Saleem <shirazsaleem@microsoft.com>
CC: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rdma-next] RDMA/mana_ib: drain QP references after partial
 table insertion
Thread-Topic: [PATCH rdma-next] RDMA/mana_ib: drain QP references after
 partial table insertion
Thread-Index: AQHdGbsFpQpIy7oHwUC/Tu1RSVb6VQ==
Date: Wed, 22 Jul 2026 09:18:12 +0000
Message-ID:
 <DU8PR83MB0975C74A6A47AB8EAE06AB29B4C12@DU8PR83MB0975.EURPRD83.prod.outlook.com>
References:
 <20260721-if-mana-table-store-qp-qids-partiall-v1-1-8fb3d2d2b559@nvidia.com>
In-Reply-To:
 <20260721-if-mana-table-store-qp-qids-partiall-v1-1-8fb3d2d2b559@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=021b9190-8a1b-47ee-8e81-1046ecd49fdf;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-07-22T09:07:30Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU8PR83MB0975:EE_|VI2PR83MB0815:EE_
x-ms-office365-filtering-correlation-id: 8074fadd-73e4-483a-6238-08dee7d22798
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|22082099003|18002099003|38070700021|3023799007|56012099006|11063799006|10067099003;
x-microsoft-antispam-message-info:
 ZeoxsQy509UyB2mhYzwvE/FEj2VJMVV7YNT2C7HSN9G1TLfZHx8j1ETVxFaoHAxRHSWwjv71q9J38D8lSgUSHS0CNfth3QPjMHYX2HkL+7MIiegOj4HZA/1S/hbAe9jJaMtLyYPr0SScOhteki0JElXY/7CnIEMQ5yTwW4TJMT6/IKHUqbCWAGeYW03QFlSuczdCoJc+Q9nzr2ZCQLcsWp+Tzj3UEIZv8jwu4aGZj9M/t4AOKCgIcafWlIS0Hp/oQjfoaA4+FaMDMcSR7LTRU2nvQ0ZFhF5EgAjVVeJ7hY3QGb/tfm/9aAUjeLkA/1o5V/94JNYs0h3NWtmy4lpcT5XQJGYnQseZ4FR7PcSLIOG69dY94Hpoh0Mae53uL0s/ZIxLgUN8kO2fCSoN4WX5PE1rko7rwHIlUSjFTbSacOBrlJ2ZpDWflKlv3dYmeOsTTg0H4/QSxu5KRMowRHx8zMb6YAa7hecPpcayUydBFrInqmYTOJ1Cc0KpY61yBEo7XnRX4CusUvf/BlANhlOvjKmQS5eY9Q4sjxhx/y47xKhPSm4No8FyOaQoEqfRgszC4ou+oe/K+zKNVA3nGLRQKOOuzzRBiPwdZZjYrnQcp96eiNPFQpNbHjjzD++jwCYc2CqPG1rwltjhOHbp3KltW7/T48IWz3D7Tl7k10r/7FCbJuqKpevg/jRevnUUjHCp0BI2WizQNuu0WYrMQtLJPgTCGz7CqVF+Xp49jLuPchA=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU8PR83MB0975.EURPRD83.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(22082099003)(18002099003)(38070700021)(3023799007)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NnF2VUowR3dLa2RQb0cyMC83aEhRS0JxZU1udlE4RHRiWG9CL1JiTno5QTZ6?=
 =?utf-8?B?UDRjQ2hwNGNJUVdjbVAxVFhRNm9XTHhuT3p4SitERmtJcWRRbkErMm9MVjB4?=
 =?utf-8?B?Nmh6MzdWZ2xqZTFKUm1jZE5FOTlvNzhZMnU3NU14ck1HNjNMWmFOVFB3NnBX?=
 =?utf-8?B?VVF3aGNMdlMzNE1GWTEwTFBBMDBUUC8wMGorQzFTU2dlOEdKRFptcVZYSFN0?=
 =?utf-8?B?YVcwUVZRZUNxQi9BVzhyZlZsQk5vS1pFOG9PbzFSam5KclVzSkNDcFRiV0ps?=
 =?utf-8?B?RWhWUm5zYnBacU15eDIxSVJQTjlseGlXTWM4YTY0dXBGcTd6Vmp3R2pEM1JR?=
 =?utf-8?B?YzZPSjZjZ1M1cHdueTk4eGlpTVo3UVNkQzJnb1NGT0REUC82bmR2bE5RT3Q5?=
 =?utf-8?B?YW5RTjl5Tm9XMmhQanl4WWR2anVpbkloTVAxbVpoY08vU21HUTlSeDNISDZu?=
 =?utf-8?B?UENmekVlV3hHUmtIazJlS2FzWUNIa1pteWgwaUVKZXUzREdodTFSUElWTFEx?=
 =?utf-8?B?M2JvTVZLYjRXMjFWVHFUMFFvMDRRY1hZVW9FQytxd05sTFJTMWlyOG1PUjNL?=
 =?utf-8?B?eCtCcEFaSERtZjVNY3VjelZ4RlNETlBBT1VJRXJ5cGVibkltbVR1MkdWUUZK?=
 =?utf-8?B?UGhzUGpYcUw1bTdDYUxadldpT3dwd3RYRElTSVcrV2piUDNHYWpka0lJcU9i?=
 =?utf-8?B?N1piWDRMbGZFcEpCSFpZTkw3OEVIU2Y3ZGVpQ0pDMjIyTWxSNUJyTkZIQ081?=
 =?utf-8?B?dW01MVlSQldUSzhNSFJsRDJuK1lnYTNuOWlTS2tTclFMWFkzMHQrVXRzODRK?=
 =?utf-8?B?MVMzWDRJYkwzL0tSZC9NL0g5b2ZtMVU1ekoxMkt1UXJhWStFanZQVTBFbUtS?=
 =?utf-8?B?RndhWldlenR4OXM5OXI3WW9mQ2xMUzVaT2hYNGt1SGJDWGNpTEhZMUZhaTYx?=
 =?utf-8?B?VTJYOWNmT3hySzZvVThsN1R3LzdkOStYVHlwVWFjTHVGTGJTbTE5dldlQ0Fz?=
 =?utf-8?B?dk5qeVBFcDE1NW1saFJLS1pERGNRZGh0enNOY3BIblAxRWp3T1c5anJINW5R?=
 =?utf-8?B?bGFHTytzQ01DNUJzM0doLzZta2QrNkp3N3g3QjBsQzhOQVIwS1hsM2gveXNG?=
 =?utf-8?B?dDAzS1NzdS9yMVI2Qlg4aVFqU0RvbHVNYlp1Y2NyMWVlNW9CRng3djhUWnpj?=
 =?utf-8?B?QkFMOHJycWhpaitVNk9VNFoyd0orZTJPQkdBaWl3WkU5WGpGQ1VRY2JldDMy?=
 =?utf-8?B?cHJnamF5U01abWZuVlQzOFRUUzJ5UlA5NEp3UWZCNWxrbWt1V2dTbkJva0NT?=
 =?utf-8?B?Y1ExWFhCMG5RbG5nZzNLUjNlRkFibDU1S0ZvMS82TkFIM3pibFNFVVBvWTF4?=
 =?utf-8?B?a2RaVERQQzZJcHUxNFBIMkFlYW5HM2NScWFEeE1CcjM4VlhWQ0hjTVN2ZW5t?=
 =?utf-8?B?Z2VGSTl2YlBrNUl6UnJJZU81SkFxWDk1K0c2SzVzc3NwNm5YVWdWQ2lYMGRi?=
 =?utf-8?B?MnQ2VzZxUnBja1R0bysxODNnZVZBSVlaV003Nk4wL2NHT3d2VUpCd2IwQlF3?=
 =?utf-8?B?UTFOWEtsSFlPSXhWdkpNS1dHZWE4Umw1eVcvUGpaUm5weTFEazM5bEpSaVlJ?=
 =?utf-8?B?NDlpSS9USVAzbWJ3cUVYSWhtVWx1MytmR2szcFpBcngwT1VtUWVzMENiemhh?=
 =?utf-8?B?bUlmanliNnY0Q013ZlNlV3laL3NjTFczTGNNMWNKNk9yS1B0ZkYyOTBnQ2JN?=
 =?utf-8?B?bTNHd3lFKzJmTWVUSXREUmpvditFSVpmZU9kSEo0VWdZaFFUbjl6bVNWd29a?=
 =?utf-8?B?SzZJNS84c2M5WWtxV1FTa082SnB0bVlCYXJjZE1uYU9DbHByZ2pSQXd4bzBk?=
 =?utf-8?B?WThEZU9vVlYwczdEajl2OGhaeC9SMmo3NGhXWk9Gb3J2aWF6YWRiWVBzVG1I?=
 =?utf-8?B?Ui9PZzB5cDlhZlExa1hIM1IvdzNNTFZsVERnZEZYbUpTd2FucHFYRTRjSGl1?=
 =?utf-8?B?R3g4MWtZS0JaVCt5WXQ2Sy83a21ucFRHTWNqc0YwUFFHU0lHdGN5UWZpWGJz?=
 =?utf-8?B?Y2o2S0VhWENiRkRJdFdBYk9zdkxyT1lCWUpvd2t4SGZFVEdFUUNZdDlGRHdE?=
 =?utf-8?B?dzlqSzFnUG11bG9KRCthZzR2ZVpqbmxLcHd2ZHF4Qk1laEhyc0hoQWJrMW9p?=
 =?utf-8?B?dUtOT3kxSi80NXNKY2duSFNURWIvTW5QOS9tdUhaekpSVHQ4S3FnNnA0ekpB?=
 =?utf-8?B?Yjh2bSsxSlJKREJKS2JkWnljZDNRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU8PR83MB0975.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8074fadd-73e4-483a-6238-08dee7d22798
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2026 09:18:12.6191
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n/xdbKlwsJtEOv9MZNWAksGhBRplfToZaHub0OXUR0oshfy3Y8Plzq4DSKDra3ShDfymRrMnxOQ7ScrE7GBypQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI2PR83MB0815

PiBGcm9tOiBMZW9uIFJvbWFub3Zza3kgPGxlb25yb0BudmlkaWEuY29tPg0KPiANCj4gbWFuYV90
YWJsZV9zdG9yZV91ZF9xcCgpIHB1Ymxpc2hlcyBhIFFQIGF0IGl0cyBzZW5kLXF1ZXVlIGlkIGJl
Zm9yZQ0KPiBpbnNlcnRpbmcgdGhlIHJlY2VpdmUtcXVldWUgaWQsIGRyb3BwaW5nIHRoZSBYQXJy
YXkgbG9jayBiZXR3ZWVuIHRoZSB0d28NCj4geGFfaW5zZXJ0X2lycSgpIGNhbGxzLiBBIGNvbmN1
cnJlbnQgY29tcGxldGlvbiBoYW5kbGVyIGNhbiBsb29rIHVwIHRoZSBRUCBhbmQNCj4gdGFrZSBh
IHRyYW5zaWVudCByZWZlcmVuY2UuIFdoZW4gdGhlIHNlY29uZCBpbnNlcnRpb24gZmFpbHMsIHRo
ZSByb2xsYmFjaw0KPiBlcmFzZWQgb25seSB0aGUgc2VuZC1xdWV1ZSBlbnRyeSBhbmQgcmV0dXJu
ZWQsIGxlYXZpbmcgYm90aCB0aGUgaW5pdGlhbCB0YWJsZQ0KPiByZWZlcmVuY2UgYW5kIHRoZSB0
cmFuc2llbnQgcmVmZXJlbmNlIG91dHN0YW5kaW5nIHdoaWxlIFJETUEgY29yZSBmcmVlcyB0aGUN
Cj4gUVAsIGNhdXNpbmcgYSB1c2UtYWZ0ZXItZnJlZS4NCj4gDQo+IERyYWluIHRoZSByZWZlcmVu
Y2UgYXMgbm9ybWFsIGRlc3RydWN0aW9uIGRvZXM6IGRyb3AgdGhlIGluaXRpYWwgcmVmZXJlbmNl
IGFuZA0KPiB3YWl0IGZvciBxcC0+ZnJlZSwgcmVsZWFzaW5nIHRoZSBRUCBvbmx5IGFmdGVyIGV2
ZXJ5IGNvbmN1cnJlbnQgbG9va3VwIHJldHVybnMNCj4gaXRzIHJlZmVyZW5jZS4NCj4gDQo+IEZp
eGVzOiA4MDAxZTkyNTdlY2EgKCJSRE1BL21hbmFfaWI6IGV4dGVuZCBtYW5hIFFQIHRhYmxlIikN
Cj4gU2lnbmVkLW9mZi1ieTogTGVvbiBSb21hbm92c2t5IDxsZW9ucm9AbnZpZGlhLmNvbT4NCg0K
UmV2aWV3ZWQtYnk6IEtvbnN0YW50aW4gVGFyYW5vdiA8a290YXJhbm92QG1pY3Jvc29mdC5jb20+
IA0KDQo+IC0tLQ0KPiBLb25zdGFudGluLA0KPiANCj4gSSBzYXcgdGhpcyBpbiBvbmUgb2YgdGhl
IFNhc2hpa28gcnVucywgYW5kIEkgYmVsaWV2ZSB0aGUgQUkgaXMgY29ycmVjdC4gVGhlDQo+IHJl
ZmVyZW5jZSBjYW4gYmUgYWNxdWlyZWQgdGhyb3VnaCB0aGUgR0RNQV9FUUVfUk5JQ19RUF9GQVRB
TCBldmVudC4NCj4gDQoNCkkgZG91YnQgdGhhdCBpdCBpcyBwb3NzaWJsZSBmb3IgRVFFcy4gVGhl
IGVxZSBvbmx5IGNhbiBtZW50aW9uIGFuIFJRIGFuZCB3ZSBmaXJzdCB0cnkgdG8gaW5zZXJ0IGFu
IFNRLg0KQXMgd2VsbCBhcyB3aGVuIHdlIGRyYWluIEdTSSBRUCwgd2UgYWxzbyBsb29rIHVwIHdp
dGggYW4gUlEuDQpJIGFtIGFsc28gdHJ5aW5nIHRvIHRoaW5rIHdoZXRoZXIgQ1FFIHdpdGggU1Eg
UUlEIGNhbiBjYXVzZSBpdCwgd2hpY2ggd291bGQgcmV2ZWFsIGEgSFcgYnVnL3JhY2UuDQpCdXQg
SSBkbyBhZ3JlZSB0aGF0IHRoZSBwYXRjaCBtYWtlcyBzZW5zZSBhbmQgd2Ugc2hvdWxkIGhhdmUg
aXQsIHJlZ2FyZGxlc3Mgb2Ygd2hldGhlciBpdCBpcyBwb3NzaWJsZS4NClRoYW5rcyBhIGxvdCBm
b3IgdGhlIHBhdGNoLiBJIGhhdmUgc2VudCByZWNlbnRseSBhIFVDLXJlbGF0ZWQgcGF0Y2ggdGhh
dCBjaGFuZ2VzIHRoZSBzYW1lIGxpbmVzLg0KSSB3aWxsIHJlYmFzZSBpdCBvbiB0b3Agb2YgeW91
ciBjaGFuZ2UuDQoNCj4gVGhhbmtzDQo+IC0tLQ0KPiAgZHJpdmVycy9pbmZpbmliYW5kL2h3L21h
bmEvcXAuYyB8IDEwICsrKysrKysrLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCA4IGluc2VydGlvbnMo
KyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pbmZpbmliYW5k
L2h3L21hbmEvcXAuYw0KPiBiL2RyaXZlcnMvaW5maW5pYmFuZC9ody9tYW5hL3FwLmMgaW5kZXgg
YjVmZjA3ZTM0ZWI3Li5jNTJmM2VjMTQwMzINCj4gMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvaW5m
aW5pYmFuZC9ody9tYW5hL3FwLmMNCj4gKysrIGIvZHJpdmVycy9pbmZpbmliYW5kL2h3L21hbmEv
cXAuYw0KPiBAQCAtNDcyLDYgKzQ3MiwxMiBAQCBzdGF0aWMgdm9pZCBtYW5hX3RhYmxlX3JlbW92
ZV9yY19xcChzdHJ1Y3QNCj4gbWFuYV9pYl9kZXYgKm1kZXYsIHN0cnVjdCBtYW5hX2liX3FwDQo+
ICAJeGFfZXJhc2VfaXJxKCZtZGV2LT5xcF90YWJsZV93cSwgcXAtPmlicXAucXBfbnVtKTsgIH0N
Cj4gDQo+ICtzdGF0aWMgdm9pZCBtYW5hX3RhYmxlX2RyYWluX3FwX3JlZihzdHJ1Y3QgbWFuYV9p
Yl9xcCAqcXApIHsNCj4gKwltYW5hX3B1dF9xcF9yZWYocXApOw0KPiArCXdhaXRfZm9yX2NvbXBs
ZXRpb24oJnFwLT5mcmVlKTsNCj4gK30NCj4gKw0KPiAgc3RhdGljIGludCBtYW5hX3RhYmxlX3N0
b3JlX3VkX3FwKHN0cnVjdCBtYW5hX2liX2RldiAqbWRldiwgc3RydWN0DQo+IG1hbmFfaWJfcXAg
KnFwKSAgew0KPiAgCXUzMiBxaWRzID0gcXAtPnVkX3FwLnF1ZXVlc1tNQU5BX1VEX1NFTkRfUVVF
VUVdLmlkIHwNCj4gTUFOQV9TRU5EUV9NQVNLOyBAQCAtNDkwLDYgKzQ5Niw3IEBAIHN0YXRpYyBp
bnQNCj4gbWFuYV90YWJsZV9zdG9yZV91ZF9xcChzdHJ1Y3QgbWFuYV9pYl9kZXYgKm1kZXYsIHN0
cnVjdCBtYW5hX2liX3FwICpxDQo+IA0KPiAgcmVtb3ZlX3NxOg0KPiAgCXhhX2VyYXNlX2lycSgm
bWRldi0+cXBfdGFibGVfd3EsIHFpZHMpOw0KPiArCW1hbmFfdGFibGVfZHJhaW5fcXBfcmVmKHFw
KTsNCj4gIAlyZXR1cm4gZXJyOw0KPiAgfQ0KPiANCj4gQEAgLTUzNyw4ICs1NDQsNyBAQCBzdGF0
aWMgdm9pZCBtYW5hX3RhYmxlX3JlbW92ZV9xcChzdHJ1Y3QNCj4gbWFuYV9pYl9kZXYgKm1kZXYs
DQo+ICAJCQkgIHFwLT5pYnFwLnFwX3R5cGUpOw0KPiAgCQlyZXR1cm47DQo+ICAJfQ0KPiAtCW1h
bmFfcHV0X3FwX3JlZihxcCk7DQo+IC0Jd2FpdF9mb3JfY29tcGxldGlvbigmcXAtPmZyZWUpOw0K
PiArCW1hbmFfdGFibGVfZHJhaW5fcXBfcmVmKHFwKTsNCj4gIH0NCj4gDQo+ICBzdGF0aWMgaW50
IG1hbmFfaWJfY3JlYXRlX3JjX3FwKHN0cnVjdCBpYl9xcCAqaWJxcCwgc3RydWN0IGliX3BkICpp
YnBkLA0KPiANCj4gLS0tDQo+IGJhc2UtY29tbWl0OiA3NGY0OTI1NTQ5MmE2MjY1OGYzNmJmMjU3
OGQ3OTE2ZjFjNmZmYWQxDQo+IGNoYW5nZS1pZDogMjAyNjA3MjEtaWYtbWFuYS10YWJsZS1zdG9y
ZS1xcC1xaWRzLXBhcnRpYWxsLWFmYTE0ZjAyMzI2MQ0KPiANCj4gQmVzdCByZWdhcmRzLA0KPiAt
LQ0KPiBMZW9uIFJvbWFub3Zza3kgPGxlb25yb0BudmlkaWEuY29tPg0KDQo=
