Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11020106.outbound.protection.outlook.com [52.101.84.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B693F928B;
	Fri, 31 Jul 2026 12:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.106
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785502478; cv=fail; b=Anq6OJxn3pmP4GmLvtID6Y3k/g6CpTkclNkuQXddAoIh2tr+0rit+DLhiv3f9mzqdNyRdg/RtG3mIA+av8LGK7mYZTsx+HXdUPX3fLAEn3zDKiP1v6cSOiPypyHnb20+//NvZ2buDOCajO38J2MH3Q6FNyvhFqHF0ozpppkXyT0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785502478; c=relaxed/simple;
	bh=I2yJcphQCXIrJfrRtWAib8o5xa8+dANt3j+aKpzojwU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AwxppfXBST6rBjdK4m7BBD2V3RQKbLsTDdD6bccvlgBjJ8jUMHmUAh8Fkh9SkwLC3dv+KccxSpG2qQiUSHTuzkb4i0iqJX1qumXH5I6fy1Frq8TQnKd3K1Odzprh5TzstndRzJ4RFf1ilT4R9DM6ps2TRc3299ytLocAxJzHTtM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=g6l3WmvJ; arc=fail smtp.client-ip=52.101.84.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="g6l3WmvJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e+BbsNzn47FSrhN2Gl+p7bC1KUBp3DtP/sGbphZQQWoahzuED7EA2OAQhs1LovMRPgvDJEY/Bw01VUvwp3sW/mxKTFJ+xqlhhOO1m69kzlWHLQCPGHthRHN8M8kTrQj4LTjy18L3FI/cszbtlWHeReFMmcTWF+wXFjYBMbuVaLzm6/tA0AIs+aXMc1yUNc++MqZZCLYFSqWXfiRoh+VmR+Z9o7wQJqlVJXSW021epcGRCRDYHdCIREf4YkBm/8bvj60bALzP8vnogqEmmsCd4fMGlf1THxZSeEznrluWXo+8hzObsgU6oy5J3cA/ZGiWUPSQpJ62I6D0TS0CrUnzRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I2yJcphQCXIrJfrRtWAib8o5xa8+dANt3j+aKpzojwU=;
 b=C/Ig8KKyHifjG3bzozx4Mv3vpk7HsDfFRsmOmgwKk5aqdYepY7zIpgDJbnhPHUMrZ4icsc8F6FIC5RP+u+IWN+diWh5DipfTcAqF3bH017aHuJkTCZccYOx0Bi/8CZAYEdFL7cNRWizNPTk2QNxUzjhqPootROo5rNiHOLQNkPmcAvNl+l5KXq8qsVyM6fv05/2iuLAPbivDfwSeEldy+FPFzD1n7eTrHtI3XIpOxKrirbp7FzP8hf4s2kluTbmrslqAACdHFvc0h+fdKkaolT/7sKrVXw9RVlwDygeNw120+fLYFUEFqYupXGGoaESYmcpJhpd94VctoM8qh9hBoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I2yJcphQCXIrJfrRtWAib8o5xa8+dANt3j+aKpzojwU=;
 b=g6l3WmvJ6+j1EdhQiNEYSriw5VQTZFi2TfX44azuFQNwl/5vuV8Zt6lY416fzqjoM3TZtw7zAbE6mTAzKTMOL7UGftiLwVsIfF0yUDziQUUJuzYEhW0UCYCDufnpR/9sa3l+7VhRhXhz4IjJQK0XlFoSfECKFpZPH8awMDT0ZFc=
Received: from DU8PR83MB0975.EURPRD83.prod.outlook.com (2603:10a6:10:5cb::5)
 by DU4PR83MB0746.EURPRD83.prod.outlook.com (2603:10a6:10:586::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.11; Fri, 31 Jul
 2026 12:54:32 +0000
Received: from DU8PR83MB0975.EURPRD83.prod.outlook.com
 ([fe80::b11f:dc15:ff12:53e]) by DU8PR83MB0975.EURPRD83.prod.outlook.com
 ([fe80::b11f:dc15:ff12:53e%6]) with mapi id 15.21.0292.010; Fri, 31 Jul 2026
 12:54:32 +0000
From: Konstantin Taranov <kotaranov@microsoft.com>
To: Jiri Pirko <jiri@resnulli.us>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>
CC: "jgg@ziepe.ca" <jgg@ziepe.ca>, "leon@kernel.org" <leon@kernel.org>, Long
 Li <longli@microsoft.com>, "linux-hyperv@vger.kernel.org"
	<linux-hyperv@vger.kernel.org>
Subject: RE: [PATCH rdma-next] RDMA/mana_ib: Retain create CQ flags field name
Thread-Topic: [PATCH rdma-next] RDMA/mana_ib: Retain create CQ flags field
 name
Thread-Index: AQHdIOu6qCzoHyzcnkuwjOo3cwMLgg==
Date: Fri, 31 Jul 2026 12:54:31 +0000
Message-ID:
 <DU8PR83MB0975547820CBB956D4EFFE57B4C82@DU8PR83MB0975.EURPRD83.prod.outlook.com>
References: <20260731091041.2250897-1-jiri@resnulli.us>
In-Reply-To: <20260731091041.2250897-1-jiri@resnulli.us>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ace87dc9-0292-4898-899f-a46f3324b91f;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-07-31T12:45:31Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU8PR83MB0975:EE_|DU4PR83MB0746:EE_
x-ms-office365-filtering-correlation-id: b6545ed6-037e-42df-bf97-08deef02dd78
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|38070700021|56012099006|11063799006|7146999003|10067099003|22082099003|18002099003;
x-microsoft-antispam-message-info:
 2DkXJLtBYQI0L6VceI4Hc/mUVIkqi2KvWfIh8m3uzX15e8ovhsF8IxjSkVZVU2MOYoMBvz31+fENcZ1ux3cIUKRnQskUiI76bm/yjpUsjBgj0AjpkLfWLb36gNySJILYQzv54A7d37B28/qI17Vvx//KUF4ZZQa11+Abrs88llznJGLxHb1DIuJ27djqSap6HsMJfzwTs9AA/ExwperM9eOFsGkcwcw7G5B2fKsPRdCSCQeL5dd4YRGbequ1I4dm+M9ilR+F4vjo3O1kf24MsPDRl+BCQk9yTSUt3zdFZSo09nscRLYHkHFtk9tEYiS84j2Lg91z8cn8XiOtGbQIyGeM6/O5EUAKyxKMnbcio7EzAB2KCEscajZDTTeOaIQhJvx92xrGOtyP9aurydcdEcYu9f2W4td2kDIcKyxL7+/hlDpZNCMMyGpIRdybA3DWKWiEVXQ8taENiQclJS+kqPPSA/7VkHA+juVrx/5KVZfbS3Nh/LBsE3EKvwz9/YY5T7NYcqym0NYnk9LCxVPiQ5gvOmznYsAsoyFMhXX2D/3TY3sS7K6R8V1IxDxYBki7n2DofUCr3EISyD9qwpGk/0i80Y2gto/T4OGoRpPGeN6kwavV8fVksq/YmjUqol3RzsBX+qai6IvScf7gEnmK5PpTfyV0nu4nfg646mQH9iq9Cqwqg2mApw6lx46nezaxNS+zzZsjY8jNWVudRk8PBaP4Bj+Cx3viaU0liWqx5Aw=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU8PR83MB0975.EURPRD83.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(38070700021)(56012099006)(11063799006)(7146999003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MzVUN1hOaVpGeGw0S1BpazROZGNGdjFYbE5XUjZRN3dOSkVRdU9sNnpvTmZ0?=
 =?utf-8?B?MG9oZlhOUi9aOGNNbm1Ca21Sb0VtRXVKOVYrTEkrc2J2RjNETTJOOGp5WXls?=
 =?utf-8?B?eVZEOEFFNlFSM2RoWU15VXNOc1FkRGdncjlTdjZ2U0dGV2xnQm1aQVBpZUw0?=
 =?utf-8?B?TmhocUM3Z0VFS3JRd1pIdzJ6RFc2WFFNVGl4bENuNHNmMUs5TEVkZ01KSlYw?=
 =?utf-8?B?cU1SbW9GVm5MdnFZQVJoRzMweVhFaGl2UkxnSUNWOWJkR1RSeDBRUnFOTXpU?=
 =?utf-8?B?M3dVa2ZRRGhXMWxrZ3doa3FKOFN5Q1NKK2hxOENtckxvdEhCdHBhRkc1WmRh?=
 =?utf-8?B?eVNkMnpKSDE3d3JaU1BTRFJNVmY0ZHozcU53SlVKNVhDbDVKMzJWcGxVYytM?=
 =?utf-8?B?N01wU1h3bUNMNFBmQS9RSGdOZGg0TmRhL1ZHRlBHcERqdjBNN1EwOUY0bi9y?=
 =?utf-8?B?VDBCMFhQeHpJS3Q1QkhxMmUyUkhucjlNdzIwTDJWa3hndVZ2ck1yZGhZT01Q?=
 =?utf-8?B?d28wYy83V2lhS1VmT00vRUsycXBLS3Fpc0NqWGh1cXdmREFvNE0rYVBBTHBt?=
 =?utf-8?B?d0FrN3NaYUJxQ3FPSU1BN1FRYnpNUnBIUS9ZLzNqU3o1aklVM25yZFhxWDNW?=
 =?utf-8?B?SGVkNldINFM3L0hTNzZVeW55bXlFZ0loNGdkdittekNJVm5NTk43d0hRbjcx?=
 =?utf-8?B?ZWE5TXg3bGQwQk84QzVzcHZseUlKTWZRajBWN0diRlVYQ0ZRWjdjc25FQm9B?=
 =?utf-8?B?bFk1VXVFNlJ5SnFtODdPcUo1cmptOWpLdVJZeXczTVhINkx5a09VMmRvSHZx?=
 =?utf-8?B?WHF3M2tRYXBpVnhRWmd5bVlOQksxZWVwQUpBbzdweDJ5c3FGNUxqckc4VkJG?=
 =?utf-8?B?dGRZcnozeHFqbXhEYkJlZW1nNTlqbmw0Q2Y3cnV1cXFHRHVYOTZ1QTdKUndW?=
 =?utf-8?B?Y04rMlVEWDJuTWZFbnhZalo1L1FtVCt1K2RjOUQzTDRNSVowd1pKOUxtS0pJ?=
 =?utf-8?B?eUtHamlKRVlwREsyYkFtUU4zc1YrQnlSM09GdEpJRndmRDU5ZG9WT2NPa2lT?=
 =?utf-8?B?Z1lZUDZYaHl6T0tGOThBdjJEd2R5N1AzVVI4bHNmVEVlMmNSZkQ0bi96WnBM?=
 =?utf-8?B?Z3A0NG1DNkNpRzdyYisvekhWcllqZDh0N0F5Y0d4SHJaRzNpMkdYempJSlUz?=
 =?utf-8?B?UTB1cXJpcnk5ajNaU3FPOFF4L2lwS2VvRFNYK2kyeklGbnNseXdnVDRyTFhG?=
 =?utf-8?B?dkl1emY2ZDgwSkJkcVpBZm9mc3ZPb3BGOTl4V21RQkZRQ3Z4K0pYN0oyUVFq?=
 =?utf-8?B?ZmpSaEFmYzltQXQ1Q0Z3RVdMSjdnVDdRVXVkUCt6Rk5FaGx3dHVBenRHbWQ0?=
 =?utf-8?B?UHoyeXRGdXFUdTk5SGxnQ0tIR0VYa05KOVovb2p6OTF6bWlTQWNlcjlFWXMy?=
 =?utf-8?B?VmhTNGU0UjlJVUFselQxQWtQc0JWMWlzVzRGSktCREdtUmpQUjhpbW1VTk5T?=
 =?utf-8?B?dlpxSTdaWnQzMjBWUkFnaXVJUVJpTFhkQWNQOUVHQWI1Ym9Ka1FpQU5MUnhq?=
 =?utf-8?B?MHk1WkRqV3J1VUx6RlhoN3VxaEk3L25qc3BQSUN6MDVyZ2dlM0pkRS9GMzF6?=
 =?utf-8?B?VTJLQ1ZuZ1JIS1UyTjdLSkdMNHMrQ2ZCeHV3bWtQdjA2MmFRbDRoTERxZHl3?=
 =?utf-8?B?MXQzU1lIZnY4M3pWM1ZvSHQ1a3o3d1JuU2l4anVCanJhUWZJRU9NS0tYU3Yx?=
 =?utf-8?B?UmczamhZZW9SeVUyN2NHTDZNTnFtRWJLWVlvSHdzM3R5bnBTQ3JEYnZvVjFQ?=
 =?utf-8?B?M1EwdmZEcjhGUEJzUUpJenp4MVVvcXY0bGZUTkxSTzVnZWNMS0pLQnI0bDVt?=
 =?utf-8?B?bzlXWHAzQkovclB1YkJYQXdXVFZBZFJGcHA4c2RjL0cvTWQyYVNoV2tEaWdU?=
 =?utf-8?B?RlhHUkR3TFBrRW1tVmY0bnVJWlVndFhIY2hrSmc0NHRxeFAxRHRvNzJ4TTZ6?=
 =?utf-8?B?UmtjRSsrZlh5eSt0dHdlWGpNRmRBcUhFeWJXdzltVncrcjJsVXpqS2g3V3pZ?=
 =?utf-8?B?Y3Z3M0NxZFVncFJrK0ttandTQjdQbEEwUy81QzFCMWFsZWt0amRNeU5sVW1G?=
 =?utf-8?B?U3N4QWEzdDBDY0QzY0RnSEczc3VpTkF5SjdkK1J3WWVrK2FMRktlNnIwdWtP?=
 =?utf-8?B?QU04V2VKVkJlZWNMVThmbFA5ekVzWVYzWlkySm5jbzRIWFlNTElJcTdmdkdo?=
 =?utf-8?B?c1dWOEdqSmdwY3J1UnNYRXRwMEhRPT0=?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b6545ed6-037e-42df-bf97-08deef02dd78
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2026 12:54:31.7513
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L7M75ucL4hVDZtyYtDZT0DMK0MFjlko6388PFuCsTH/v/LMy2CeM3v42FM/OoQcyt2wc76KgRqic4TyXUomqjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR83MB0746

PiBGcm9tOiBKaXJpIFBpcmtvIDxqaXJpQG52aWRpYS5jb20+DQo+IA0KPiBDb21taXQgZWI3MGQ4
M2E4NjQ1ICgiUkRNQS9tYW5hX2liOiBBZG9wdCByb2J1c3QgdWRhdGEiKSByZW5hbWVkIHRoZQ0K
PiAiZmxhZ3MiIGZpZWxkIG9mIHN0cnVjdCBtYW5hX2liX2NyZWF0ZV9jcSB0byAiY29tcF9tYXNr
IiwgYXMNCj4gaWJfY29weV92YWxpZGF0ZV91ZGF0YV9pbl9jbSgpIG9ubHkgdmFsaWRhdGVzIGEg
bWVtYmVyIHdpdGggdGhhdCBuYW1lLg0KPiANCj4gVGhlIGxheW91dCBkaWQgbm90IGNoYW5nZSwg
YnV0IHRoZSBmaWVsZCBoYXMgYmVlbiBhIHBhcnQgb2YgdGhlIFVBUEkgc2luY2UNCj4gY29tbWl0
IDQ0YjYwN2FkNGNkZiAoIlJETUEvbWFuYV9pYjogaW1wbGVtZW50IHVhcGkgZm9yIGNyZWF0aW9u
IG9mIHJuaWMNCj4gY3EiKSwgc28gdGhlIHJlbmFtZSBicmVha3MgdXNlcnNwYWNlIHJlZmVycmlu
ZyB0byBpdCwgZm9yIGV4YW1wbGUgdGhlIG1hbmENCj4gcHJvdmlkZXIgb2YgcmRtYS1jb3JlIGFz
c2lnbmluZyBjbWRfZHJ2LT5mbGFncy4NCj4gDQo+IENvbnZlcnQgdGhlIGZpZWxkIHRvIGEgdW5p
b24gcHJvdmlkaW5nIGJvdGggbmFtZXMsIHNvIHRoYXQNCj4gaWJfY29weV92YWxpZGF0ZV91ZGF0
YV9pbl9jbSgpIHN0aWxsIGZpbmRzICJjb21wX21hc2siIGFuZCB1c2Vyc3BhY2Uga2VlcHMNCj4g
ImZsYWdzIiwgd2l0aG91dCBoYXZpbmcgdG8gYWRkIGEgaGVscGVyIGZvciB0aGlzIHNpbmdsZSBj
YXNlLg0KPiANCg0KVGhhbmtzIGZvciB0aGUgcGF0Y2gsIGJ1dCBteSB1bmRlcnN0YW5kaW5nIHRo
YXQgaXQgaXMgYSBjb21tb24gcHJhY3RpY2UgdG8gcmVuYW1lIHRoZSBmaWVsZHMsDQphbmQga2Vy
bmVscyBoZWFkZXJzIHNob3VsZCBub3QgYWNjdW11bGF0ZSBoaXN0b3JpY2FsIG5hbWVzLiANCkkg
YWxzbyBmYWNlZCBhIHNpbWlsYXIgcHJvYmxlbSBmcm9tIHJlbmFtZXMgaW4gb3RoZXIgcHJvdmlk
ZXJzLCB3aGVuIEkgbmVlZGVkIGEgbmV3IGtlcm5lbCBoZWFkZXIgaW4gcmRtYS1jb3JlLg0KSWYg
dGhpcyBicmVha3MgeW91ciByZG1hLWNvcmUgaW4gYSBQUiwganVzdCByZW1vdmUgdGhlIGZpZWxk
IHJlbmFtZSBpbiBrZXJuZWwgdXBkYXRlIGNvbW1pdCBhcyB0aGF0IGhlYWRlciB1cGRhdGUgY29t
bWl0IGlzIG5vdCBnZXR0aW5nIG1lcmdlZCBhbnl3YXkgZnJvbSB5b3VyIFBSLg0KTXkgdW5kZXJz
dGFuZGluZyB0aGF0IG1haW50YWluZXJzIG9mIFJETUEtY29yZSB3aWxsIG1lcmdlIHRoZSBrZXJu
ZWwgaGVhZGVyIHVwZGF0ZSwgYW5kIHdpbGwgYnJpbmcgdGhpcyBjaGFuZ2UgZnJvbSBteSBQUjoN
Cmh0dHBzOi8vZ2l0aHViLmNvbS9saW51eC1yZG1hL3JkbWEtY29yZS9wdWxsLzE3NjUvY29tbWl0
cy8wZGNhZGQ5MzE2ZjFiOThlMjE5NzNlM2E2ZTBmOTYxODZkNDliZDVhDQoNCi0gS29uc3RhbnRp
bg0KDQo+IEZpeGVzOiBlYjcwZDgzYTg2NDUgKCJSRE1BL21hbmFfaWI6IEFkb3B0IHJvYnVzdCB1
ZGF0YSIpDQo+IFNpZ25lZC1vZmYtYnk6IEppcmkgUGlya28gPGppcmlAbnZpZGlhLmNvbT4NCj4g
LS0tDQo+ICBpbmNsdWRlL3VhcGkvcmRtYS9tYW5hLWFiaS5oIHwgNSArKysrLQ0KPiAgMSBmaWxl
IGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdp
dCBhL2luY2x1ZGUvdWFwaS9yZG1hL21hbmEtYWJpLmggYi9pbmNsdWRlL3VhcGkvcmRtYS9tYW5h
LWFiaS5oDQo+IGluZGV4IDQxMGYwZGRjOGM4OS4uNDMxYzcwNzZmMjBhIDEwMDY0NA0KPiAtLS0g
YS9pbmNsdWRlL3VhcGkvcmRtYS9tYW5hLWFiaS5oDQo+ICsrKyBiL2luY2x1ZGUvdWFwaS9yZG1h
L21hbmEtYWJpLmgNCj4gQEAgLTI1LDcgKzI1LDEwIEBAIGVudW0gbWFuYV9pYl9jcmVhdGVfY3Ff
ZmxhZ3Mgew0KPiANCj4gIHN0cnVjdCBtYW5hX2liX2NyZWF0ZV9jcSB7DQo+ICAJX19hbGlnbmVk
X3U2NCBidWZfYWRkcjsNCj4gLQlfX3UxNgljb21wX21hc2s7DQo+ICsJdW5pb24gew0KPiArCQlf
X3UxNgljb21wX21hc2s7DQo+ICsJCV9fdTE2CWZsYWdzOyAvKiB0aGUgb3JpZ2luYWwgbmFtZSBv
ZiB0aGUgZmllbGQgKi8NCj4gKwl9Ow0KPiAgCV9fdTE2CXJlc2VydmVkMDsNCj4gIAlfX3UzMgly
ZXNlcnZlZDE7DQo+ICB9Ow0KPiAtLQ0KPiAyLjU0LjANCg0K
