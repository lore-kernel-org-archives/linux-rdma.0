Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11020097.outbound.protection.outlook.com [52.101.61.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52123B14D6;
	Tue, 28 Jul 2026 23:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.97
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785283124; cv=fail; b=O5zrlrXoAtMGUj3TEc7JZWJwuNOg4sR82UJzLlZUVxlfYgBPzrRBwE4W8+IAnbTTBYmlq37783naLpDgIEcdYBwAcTellGqiwG1XAGwG2yeeFHZrMw/APYR9D6cJxlGDNQbB3Jt0QOO7IctHjgjN9R88t+vgUYM2lcJo7wjGQgM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785283124; c=relaxed/simple;
	bh=NZ9jwZQUcRogapMFPUu3Y8R5d7cxlaA4w1JiFOwxqcA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PKkTZzneDlb3kw4gILXfk5OZB2V0ZrxTY+QHo9MTCPx61Uwl08h+5KAHjOKS1TxgRCKes9KQ/38Z1h5p3wJdpySEq9r5ifMzN+91m78S0/uj9P3/tTwLVAcUtd00LzJN7pbRnk/8o5hUKrPPtfYyRxF6Wn83NaexrBF3131tZHs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=Rz6IR2mM; arc=fail smtp.client-ip=52.101.61.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="Rz6IR2mM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LumjCAS1GavZ8bijnFK4A/YZPIxIVt4iLRqoUFrap5j4OhQTn02q5x6G/6+OwM0ZPBXs04obrYOInlehH/WJ1TIpLtzRI5wH9OaYpTBi83N27fwVJwTy57/uQTkhyRdZst/II1i2vhq0dYFpOeWH6/arSVqIncg3e4zh9PNXJbssS3d2tTrYhauCMvFHXH861/aHDaoajOuQ9ZpPYc6Ze4sW5T92lNN4wSQdAtOyrcDU5VUYdeZlPejR1OGjdtz8UZ36Bw26anDvUvgkDcl35CNmMJafrkGCTUqMylNM3AupKQuZJLEGubkqGGpf09k2NRJst1gXkRN4mVzuL3u/MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NZ9jwZQUcRogapMFPUu3Y8R5d7cxlaA4w1JiFOwxqcA=;
 b=TPxKslck6bLgWQ7MpXcQdW2MMjr0ZEwHeaSfJWFYNhxvOfaFJMf6SmPYqfm4Szr7xWNNmtyN5vmrIV3ziqAgtckbGALONdv2scflnCh47fW615b8NtkRfxU7xYr4gIBOre+0X5OTEFkht9Psrqm+rpyrxXmuvaVojnZ+orA9IlVQUGnVlAeCYln9JGTkJpILWS2qvvLk5tUXGhuKdsG1/ZzLuK0xdYUK5+7rTh6G8tLgAxzkCrPMDW55mFxMVL8J+i6jF1O9mH+wb509spAuur0G4iEnUOwVn4Q02+q5BJJNVKFgoy+TX36phVoM9XshqDxU80boGnA3MU4LMUVVvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NZ9jwZQUcRogapMFPUu3Y8R5d7cxlaA4w1JiFOwxqcA=;
 b=Rz6IR2mMdcNYIAvUcjdBZovr1GfHgz5pQ1ep/7ynFvwgAmos/uIr6+sOQY3SsI2T+a7UP66s8pr+kQl2rCGceHe5jBM9LcNNsSdmIxuHjRJri3vOSmICfSYk09EJ036ejUXwLp/vq8EnJ3uopjhNRi6G/iOP9gBpNrLLjLOpV50=
Received: from LV0PR21MB6670.namprd21.prod.outlook.com (2603:10b6:408:337::12)
 by LV2PR21MB3349.namprd21.prod.outlook.com (2603:10b6:408:14f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.7; Tue, 28 Jul
 2026 23:58:39 +0000
Received: from LV0PR21MB6670.namprd21.prod.outlook.com
 ([fe80::c354:baab:cb7e:3c96]) by LV0PR21MB6670.namprd21.prod.outlook.com
 ([fe80::c354:baab:cb7e:3c96%4]) with mapi id 15.21.0292.000; Tue, 28 Jul 2026
 23:58:39 +0000
From: Long Li <longli@microsoft.com>
To: Paolo Abeni <pabeni@redhat.com>, Konstantin Taranov
	<kotaranov@microsoft.com>, Jakub Kicinski <kuba@kernel.org>, "David S .
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Andrew
 Lunn <andrew+netdev@lunn.ch>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky
	<leon@kernel.org>, Haiyang Zhang <haiyangz@microsoft.com>, KY Srinivasan
	<kys@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui
	<DECUI@microsoft.com>, "shradhagupta@linux.microsoft.com"
	<shradhagupta@linux.microsoft.com>, Simon Horman <horms@kernel.org>,
	"ernis@linux.microsoft.com" <ernis@linux.microsoft.com>,
	"stephen@networkplumber.org" <stephen@networkplumber.org>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH net-next v2 0/7] net: mana: harden the HWC
 and add dynamic queue depth
Thread-Topic: [EXTERNAL] Re: [PATCH net-next v2 0/7] net: mana: harden the HWC
 and add dynamic queue depth
Thread-Index: AQHdGWrPQIVLv249e0+uVOo34Ns9lLaCy8wAgADVhpA=
Date: Tue, 28 Jul 2026 23:58:39 +0000
Message-ID:
 <LV0PR21MB6670BDF8E9C8CEF4A22C0FF3CECB2@LV0PR21MB6670.namprd21.prod.outlook.com>
References: <20260721234339.1476932-1-longli@microsoft.com>
 <7108c005-6b8d-4dda-82cc-e665cbe3b6a4@redhat.com>
In-Reply-To: <7108c005-6b8d-4dda-82cc-e665cbe3b6a4@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=113d342f-b65b-49ad-8238-8e085ac5073b;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-07-28T23:37:39Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0PR21MB6670:EE_|LV2PR21MB3349:EE_
x-ms-office365-filtering-correlation-id: ed9b668c-eb71-4446-a2bf-08deed042512
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|3023799007|38070700021|10067099003|7146999003|11063799006|4143699003|56012099006|921020|22082099003|18002099003;
x-microsoft-antispam-message-info:
 8f7qudk2EQGeLXCksEQePX545Xn/EmnSBsekvzX2aCfUahtRQeFyOPOX1ATP1Hk/bAvy1/x84C6uwCL5UB5iubvdtZd8lMt0oToHO7XVHL+VD2oPpzil6hPTP2Ai6mZIx5SiTgpSQ4KCfxyEv2+N7saCP5ZtYxCZOIcCkci24TEekIubjJFKduy8l3vGh+qMSozYYSjagmGP5Z9ODRbcD7IkYQBnRzKx1ixqh38P2rJEm2qGujIk1TV4M4ODuLjJVgSflMzCesUto0KYr2SE8qcOlPghSXIyOf5I/ozTkn1PTTAjyEXUQGFZDx66ismU+VYE1O9hP4hYhh1ylo4l86OComvvutL7N3unSPLKwWnOw/W713S69jH4AEKEAL0sJ6x4pluhgpvGoMdn5pcsyHSuzEXdONbNPMd95A2bkII5sPjsNRuvkU+6u2nNoOXV9QTv9vSHodpluBWe/X6XfNJg2p6FXtoghKEU3NBjIYCuCXdeS769GQN5XERQI0YUZYpz759f9c5+21THRpMq0Z0MIzsrc0l3edlHQ22Rmcf95xt5Zrg2WmCAN8hN8RXfeEjuZFq0hVpMoTx6p4g5bRmHKaMyK+69jpowKXqoDVy337JMyn/DO0DxoK5hk+sD9tHSCmOJtr3Gp1MSrijVRAgRbt5Og2yDvj8XfhCT4223R+2zFVX2q1oR/5mTQyv0X28ODH4ipErL+Mp+gfahHxdC+bYUSdFt8cs3xeOnCZD31zcBTF9lvepqRetBjfN6
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR21MB6670.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(3023799007)(38070700021)(10067099003)(7146999003)(11063799006)(4143699003)(56012099006)(921020)(22082099003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eldKWU9NclpML1RhRmhTUEJ0Vnp6MUNNMTh3anJPQ2dIZVAwcEJiZTAyNW1i?=
 =?utf-8?B?MzdxR1FXckZ2UVlSVUpjN3ZGL1Z5blFEaXNvcjVvNytZRVJkWEU4T2R3SWVP?=
 =?utf-8?B?djYwVElVR0xLSzZmekJMSldPVHVUcENWZ3FKR0w4U2Jlb2ZFNWl0cVZ1Qk12?=
 =?utf-8?B?Q0t3MUhmdnN4S0ordHZ3VVpybXFPa2hpMmxEV1UvSVEzUVE2aVN5aFZUL2NQ?=
 =?utf-8?B?K1J1WUppb1hlaDF0NmdpTmR5OXRiNzBFdEV6REoyR0RMUlZYeXloYlR3V3Nz?=
 =?utf-8?B?RzZSeUtLcHlVMFE4cjJYTkMzS1V1a2Z1bnIvVURIRVRvVC81YkdCd3ZuLzdY?=
 =?utf-8?B?NFdzNFVCdWZ6NVZaOFVXMk5BS2xQRWdwMGhxbk1VR0JudDlvb01uYzF0NWhr?=
 =?utf-8?B?M2lHVmdkODB5bFRoRjZUcnZyWU1iaVJnbC9BOGNFa2FaeDVVNVBpOGRkd1BT?=
 =?utf-8?B?QnVEK2UzcHpjN0JWZ2piQmJ0ZUcxZTZob0VYOUZkeklIeFlwaXVFVXRmajY1?=
 =?utf-8?B?RWthVnZtQmNPWldmYXpzVkMva1JpbFhXNERkcitCekFtWmlGRjg2WmRJSEoz?=
 =?utf-8?B?N053NkFLTVNkNVQ1aGc4ZDdFaHkvUWJTWE5NaXdXcnc4MFEyTFJKRW5Veng1?=
 =?utf-8?B?b3N3czBNKzVIS0s0bS9GdE5UbVpPMkFXTVlTN1NlYk01RG9EMEFmTW82cG96?=
 =?utf-8?B?dFZWV2V6NWdQK0pMN010SWxjbnZXOUpveVo4TXdqcGhTdmllczluTDlTQzIr?=
 =?utf-8?B?YWJzZHE2WUZiR3ptWDgxY2c5YVZvQzl3dUtDWEVIckYzcGtkaG80Wm80M0x2?=
 =?utf-8?B?SjZJcEZLUnNPd0toK083MS9vL0dLUkE0RXhyNXl2WklxQmtGMmZGUEhxRUlZ?=
 =?utf-8?B?YWxoZU5NWHJLSUlTWnhqTGNXZnBReStzRFZXdkZhWEM5NGRRRUNsL3dRWkUw?=
 =?utf-8?B?amNHOGg1MTE0ZlAva2VXdVU2bE1mZTQ4aHVyTTd2VXAwc0RralVwMmNXTDhj?=
 =?utf-8?B?UUt2UFMzemxBU09BeFVZMzFnbjdDaUhNZmNscTNHR3VFM2pHclJ5bEJkeWhK?=
 =?utf-8?B?Nm9JSUVpcFVuVGxCeTI4ZXNsZ2NZa2Fkc2tvbnhjSzBPVFZoQTYvVnB2VVlS?=
 =?utf-8?B?UE01ZVJCaTNMSXFNVHJOazlBYkwrUmU3NWhiVTlGSEJQL01EREk4RmREdGJk?=
 =?utf-8?B?cHVCSHk1NUprSXpuVkoyN3lzVXRWTkswZHpDd2lkZUJpMW40VXZsSWMzT3Ro?=
 =?utf-8?B?dXVmcGI4MGhadTRNT2JuOWZVaFZnNXNxR3pFb25IMUphN0dyWlVmNlBqbU12?=
 =?utf-8?B?Z3VTMHZ3VUxLU2hVUnJOUzR5dGtIdmg3ZExhTXdDT21hYUIyUHhkc2pHOFVI?=
 =?utf-8?B?ZDREaTd3Z0R3b3oxZVNKdGI0c043cml2M2ZFZUZpMUI0MnBaSzFYY2hZSUIv?=
 =?utf-8?B?eFF4QlpqQXVCM25nczgwYW1ib2lHN3YvMmRCdmFxc08xUXFOU0hnN3kyQ01w?=
 =?utf-8?B?MGlKNFVBYkdXeEY0dmVMN3A5bWF5Z0JHNVBTajhHeTVDUEtrNHplcWtRRTJ3?=
 =?utf-8?B?cloyR3hzVzIzMG1MUHFyTGF6R1VwSzNnYjJ5TW15MXZVSUhJcCt5NngzVExZ?=
 =?utf-8?B?Sy95MERCRWxIdi9NZ05obnlIeS92dkJLSkdaQ0EvT0xOb1N6SUFrRktNSVNR?=
 =?utf-8?B?THBxMG5BRHNiU3o4MUZEa3ZaakR2bXZMem1GZ2V3RllLOGhhbjQrNk5aVXZL?=
 =?utf-8?B?eFludXB3a0h2WjRQMy9vMGFtSDVFZ0ZaQTZlVVU0VnZYS29VQnFqR0t5RWNV?=
 =?utf-8?B?cEcxZFZJMXVQYitWUVlteVNkODlrNVE0RmhpamlQcGxLOUdZdCt1QVlrQytS?=
 =?utf-8?B?MFJlQXdxSnNqN1FycGNKVHk4bG5mVVNkNlRMWEhDSmNQRkRQWk94WWoxVENq?=
 =?utf-8?B?Nnd5UGduekw0cWU5dFkyZk5iQ1U5b0Q2Z0NoWWU1L3R3b29XajE1SWRDUEVR?=
 =?utf-8?B?WFZZb2diQUtmUXdxY0l6RlcxdkFxQ3M3VmFwaUNtalVEczZCY2ZYTWZjTUZ3?=
 =?utf-8?B?WFBiM3ovN3kyVUg0czgyVGgxNzBEVzNvdWQrTy9RUDdtSzZTNndzMGxHbXBm?=
 =?utf-8?B?Y2w0OHFCa2ZXdW9rNlZsaFVUcUxLWVMwV2Y5aG40a3dSTkRTOEJMa09rZ1FO?=
 =?utf-8?B?WmN2N1FmNkt5M2xTcWdCVWk4SUR5SE96aXk0ZnJ3U1BtaW9Calh4S1YwN0Z1?=
 =?utf-8?B?bEs4cSs5ZXNOcFJyajlPV1NZQ2E2MzM5WUQrL3U0NWNWTS9HNnNjUlhLcmI4?=
 =?utf-8?Q?6IatPfHUDeTSBVMjBW?=
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
X-MS-Exchange-CrossTenant-AuthSource: LV0PR21MB6670.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed9b668c-eb71-4446-a2bf-08deed042512
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2026 23:58:39.0703
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: USOREBk1SVc7DyBP0F7wzkZDgNLKqdcnGrjST9jnmqjCqqJDimeeFGpLWqc71SgRoZA0Asq49Ms2LhvPNkdR5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR21MB3349

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGFvbG8gQWJlbmkgPHBh
YmVuaUByZWRoYXQuY29tPg0KPiBTZW50OiBUdWVzZGF5LCBKdWx5IDI4LCAyMDI2IDM6NTMgQU0N
Cj4gVG86IExvbmcgTGkgPGxvbmdsaUBtaWNyb3NvZnQuY29tPjsgS29uc3RhbnRpbiBUYXJhbm92
DQo+IDxrb3RhcmFub3ZAbWljcm9zb2Z0LmNvbT47IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5l
bC5vcmc+OyBEYXZpZCBTIC4NCj4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgRXJpYyBE
dW1hemV0IDxlZHVtYXpldEBnb29nbGUuY29tPjsNCj4gQW5kcmV3IEx1bm4gPGFuZHJldytuZXRk
ZXZAbHVubi5jaD47IEphc29uIEd1bnRob3JwZSA8amdnQHppZXBlLmNhPjsNCj4gTGVvbiBSb21h
bm92c2t5IDxsZW9uQGtlcm5lbC5vcmc+OyBIYWl5YW5nIFpoYW5nDQo+IDxoYWl5YW5nekBtaWNy
b3NvZnQuY29tPjsgS1kgU3Jpbml2YXNhbiA8a3lzQG1pY3Jvc29mdC5jb20+OyBXZWkgTGl1DQo+
IDx3ZWkubGl1QGtlcm5lbC5vcmc+OyBEZXh1YW4gQ3VpIDxERUNVSUBtaWNyb3NvZnQuY29tPjsN
Cj4gc2hyYWRoYWd1cHRhQGxpbnV4Lm1pY3Jvc29mdC5jb207IFNpbW9uIEhvcm1hbiA8aG9ybXNA
a2VybmVsLm9yZz47DQo+IGVybmlzQGxpbnV4Lm1pY3Jvc29mdC5jb207IHN0ZXBoZW5AbmV0d29y
a3BsdW1iZXIub3JnDQo+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1yZG1hQHZn
ZXIua2VybmVsLm9yZzsgbGludXgtDQo+IGh5cGVydkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtl
cm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogW0VYVEVSTkFMXSBSZTogW1BBVENIIG5l
dC1uZXh0IHYyIDAvN10gbmV0OiBtYW5hOiBoYXJkZW4gdGhlIEhXQw0KPiBhbmQgYWRkIGR5bmFt
aWMgcXVldWUgZGVwdGgNCj4gDQo+IE9uIDcvMjIvMjYgMTo0MyBBTSwgTG9uZyBMaSB3cm90ZToN
Cj4gPiBUaGlzIHNlcmllcyBoYXJkZW5zIHRoZSBNQU5BIEhhcmR3YXJlIENoYW5uZWwgKEhXQykg
Y29udHJvbC1wbGFuZSBwYXRoDQo+ID4gYW5kIHRoZW4gYnVpbGRzIG9uIHRoYXQgdG8gc3VwcG9y
dCBhIGR5bmFtaWMgSFdDIHF1ZXVlIGRlcHRoLg0KPiA+DQo+ID4gVGhlIEhXQyBpcyB0aGUgY29t
bWFuZCBjaGFubmVsIHRoZSBkcml2ZXIgdXNlcyB0byB0YWxrIHRvIHRoZSBkZXZpY2UuDQo+ID4g
VG9kYXkgaXQgaXMgY3JlYXRlZCBhdCBhIGZpeGVkIGRlcHRoIG9mIG9uZSBvdXRzdGFuZGluZyBy
ZXF1ZXN0LCBhbmQNCj4gPiBzZXZlcmFsIG9mIGl0cyBsb29rdXAgYW5kIHRlYXJkb3duIHBhdGhz
IHByZWRhdGUgdGhlIFJDVSBhbmQNCj4gPiBETUEtbGlmZXRpbWUgcnVsZXMgdGhleSBub3cgbmVl
ZCB0byBmb2xsb3cuICBSYWlzaW5nIHRoZSBxdWV1ZSBkZXB0aA0KPiA+IGFuZCBhbGxvd2luZyBj
b25jdXJyZW50IGNvbW1hbmRzIG1ha2VzIHRob3NlIGxhdGVudCByYWNlcyByZWFjaGFibGUsDQo+
ID4gc28gdGhlIGZpeGVzIGNvbWUgZmlyc3QgYW5kIHRoZSBmZWF0dXJlIGJ1aWxkcyBvbiB0aGVt
Lg0KPiA+DQo+ID4gUGF0Y2hlcyAxLTUgYXJlIGZpeGVzIGZvciBwcmUtZXhpc3RpbmcgSFdDIGJ1
Z3MsIGVhY2ggd2l0aCBhIEZpeGVzOiB0YWc6DQo+ID4NCj4gPiAgIDE6IGNxX3RhYmxlIHdhcyBh
IHBsYWluIHBvaW50ZXIgYXJyYXkgZnJlZWQgd2l0aCBubyBncmFjZSBwZXJpb2Qgd2hpbGUNCj4g
PiAgICAgIHRoZSBFUSBpbnRlcnJ1cHQgaGFuZGxlciBkZXJlZmVyZW5jZWQgaXQ7IHB1dCBpdCB1
bmRlciBSQ1UuDQo+ID4gICAyOiB0aGUgSFdDIFJRIGFuZCBTUSB3ZXJlIHNpemVkIHdpdGggZWFj
aCBvdGhlcidzIG1lc3NhZ2Ugc2l6ZSwgc28gYQ0KPiA+ICAgICAgcmVzcG9uc2UgY291bGQgb3Zl
cmZsb3cgdGhlIFJRIGJ1ZmZlciBhbmQgdGhlIFJYIHNsb3Qgc3RyaWRlIHdhcw0KPiA+ICAgICAg
Y29tcHV0ZWQgd2l0aCB0aGUgd3Jvbmcgc2l6ZS4NCj4gPiAgIDM6IGNvbXBfYnVmIHdhcyBmcmVl
ZCBiZWZvcmUgdGhlIEVRIHdhcyBkZXN0cm95ZWQsIHNvIGEgbGF0ZSBjb21wbGV0aW9uDQo+ID4g
ICAgICBoYW5kbGVyIGNvdWxkIHRvdWNoIGZyZWVkIG1lbW9yeS4NCj4gPiAgIDQ6IHRoZSBSWCBw
YXRoIGNvbnN1bWVkIGRldmljZS1zdXBwbGllZCBsZW5ndGhzIGFuZCBpbmRpY2VzIHdpdGhvdXQN
Cj4gPiAgICAgIHZhbGlkYXRpb247IHZhbGlkYXRlIHRoZW0gYmVmb3JlIHVzZSAodGhpcyBtYXR0
ZXJzIGZvciBjb25maWRlbnRpYWwNCj4gPiAgICAgIFZNcywgd2hlcmUgdGhlIERNQSBidWZmZXIg
aXMgc2hhcmVkIHdpdGggdGhlIGhvc3QpLg0KPiA+ICAgNTogYSBmYWlsZWQgbWFuYV9od2NfZXN0
YWJsaXNoX2NoYW5uZWwoKSBjb3VsZCBsZWF2ZSBsaXZlIE1TVCBlbnRyaWVzDQo+ID4gICAgICB3
aGlsZSB0aGUgZHJpdmVyIGZyZWVkIHRoZSBxdWV1ZSBidWZmZXJzLCBhbmQgZGVzdHJveV9jaGFu
bmVsKCkgZnJlZWQNCj4gPiAgICAgIHRoZSBUWFEvUlhRIGJlZm9yZSB0aGUgRVEgd2FzIHF1aWVz
Y2VkOyBhZGQgYSBzZXR1cF9hY3RpdmUgdGVhcmRvd24NCj4gPiAgICAgIGdhdGUgYW5kIGRlc3Ry
b3kgdGhlIENRIGZpcnN0Lg0KPiANCj4gRml4ZXMgc2hvdWxkIGdvIHZpYSB0aGUgbmV0IHRyZWUu
IFRhcmdldGluZyBuZXQtbmV4dCB0byBhdm9pZCB3YWl0aW5nIHRoZQ0KPiBtZXJnZSB0byBwb3N0
IHRoZSBkZXBlbmRhbnQgZmVhdHVyZXMgaXMgbm90IGEgdmFsaWQgcmVhc29uLg0KPiANCj4gQWxz
byBib3RoIHNhc2hpa29zIGFncmVlcyBwY2llX2ZwcigpIGluIHBhdGNoIDUgaXMgbm90IHRoZSBj
b3JyZWN0IGZ1bmN0aW9uIHRvDQo+IGJlIHVzZWQgdGhlcmUuDQo+IA0KPiBBbHNvIHBsZWFzZSBu
b3RlIHRoZSBleHBlY3RhdGlvbnMgV1JUIExMTXMgZmVlZGJhY2ssIGNvbW1pdCBjODJmZjk0NTky
ZmIuDQo+IA0KPiAvUA0KDQpJJ2xsIHBvc3QgUGF0Y2ggMS01IHRvIG5ldC4NCg0KVGhhbmsgeW91
LA0KTG9uZw0KDQo=
