Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11022078.outbound.protection.outlook.com [40.107.209.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969DC46EC9E;
	Tue, 21 Jul 2026 19:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662148; cv=fail; b=e4/K3fkX2ilVE/mRCMvlCGH8lECW8H8kREb66SSQ1l9PiTLdt4fs3tZv4xIxCSRemj3N9/O2pDGkUmFU4RWm08AecsSdrFSp0jmhs9XNJBh62BBKt+uENk+5K64P/Lo/cEZjr8SzYVd8JsEtccTE6T9xnsDu5nxWB99fI9vdbbc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662148; c=relaxed/simple;
	bh=dDPdPHLS9ljDJJjLNO28iq2Czbyt1lJkvowWolwSnk4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NORAJw1C7aAmpep2Kqs7TYcXMvqeBPu2QZeXJmEhkTs+anFEqHtxlx/MGZtda24+YhaHIbmPrt3le8JDDCH0BgZ6lUwl930wh4+FfigZL84fyb/mEYUmurt6lPElNdu8uxrUcFg0/GOEfypOBuxwz+Z8eD4I9fWOR4BO6gqcbY4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=cHNkH67N; arc=fail smtp.client-ip=40.107.209.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="cHNkH67N"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uFuRa6i0hQ6EY1eL02PUVkzJIBfPZFbRVfdt2/mAM7zn18DFGBZ6C3KZJYykiooAl2nBGj9/tkeLpeSG2mWZZauac7WMC4f0yvcaE6EnHMmyEuRhfgAPQYoIsDUzQbshBAMst+PYYJivF2gUwI8wgb5ds1l03PzfEYYF6RhNHX+WiJufsxExflL+1Ufradj+pA6Lae7nmDImpJ9gOOPBEG6VWggZqxa+XggJBys+p9+/tXoUVcUFD9gGyVb5eazOt9RwrEcYfv+AafWA2yj91novVmngodaG6wf9nM9bOFEVrcw9PC2lxXPH7jSxm0p2H8QUb3EuEhARWnoHeT6GoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dDPdPHLS9ljDJJjLNO28iq2Czbyt1lJkvowWolwSnk4=;
 b=DVPDd7c8N5JXfyaUKMu+tOJCme+ypRjhh7Z2ifazlUXY6GpIzHU8GwXpmJ1VwMCjrJfL/tpwwWOQM7mT/JYRmBinAePRD/oJILLaJLKSIqzf7J71mBgRrCYbA19W0TmiYvPUcdXzvvJzeSovDAQGDOFWT/AeJzCVa5mRYRK2J2SA1fUM/lVxdwEssp7DBm9e4zF/BceZast6LofmZUJ5fVijU19g6YXV/UDjSHJlhiyQdJHNLwntS2N8SqWCtuMGb1+rxxa1DctErVKYaZR/OdgxHQIrPSA9Tv7adp3QTv5aPHRg2zqesWm8sxnQjHbclkiQQ/04ml5Z4NJ/v3XjTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dDPdPHLS9ljDJJjLNO28iq2Czbyt1lJkvowWolwSnk4=;
 b=cHNkH67NtgO4s5e6YcV777Fot25CjBxkgShxNDzZ6Ut60ttrzYbN6WIs9XUWZvX1UGT0o2EhwwJ8G6lGKZFrguvK8DyuvKBkJJSIFJCgniweU7o+J+qydAuQ7Dn+IWKthf8Jzkux6jfvkzX12x3yE6yWhpHS9sFD1+Ut+Meqxmo=
Received: from SA1PR21MB6683.namprd21.prod.outlook.com (2603:10b6:806:4a4::6)
 by PH0PR21MB6516.namprd21.prod.outlook.com (2603:10b6:510:388::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Tue, 21 Jul
 2026 19:29:05 +0000
Received: from SA1PR21MB6683.namprd21.prod.outlook.com
 ([fe80::8bad:6294:8a07:fe18]) by SA1PR21MB6683.namprd21.prod.outlook.com
 ([fe80::8bad:6294:8a07:fe18%3]) with mapi id 15.21.0159.007; Tue, 21 Jul 2026
 19:29:04 +0000
From: Long Li <longli@microsoft.com>
To: Leon Romanovsky <leon@kernel.org>, Konstantin Taranov
	<kotaranov@microsoft.com>, Jason Gunthorpe <jgg@ziepe.ca>, Shiraz Saleem
	<shirazsaleem@microsoft.com>
CC: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXTERNAL] [PATCH rdma-next] RDMA/mana_ib: drain QP references
 after partial table insertion
Thread-Topic: [EXTERNAL] [PATCH rdma-next] RDMA/mana_ib: drain QP references
 after partial table insertion
Thread-Index: AQHdGSGkccI8xInxX0mxLGM0IPwwSLZ4W/rg
Date: Tue, 21 Jul 2026 19:29:04 +0000
Message-ID:
 <SA1PR21MB6683E68DE3D488BD28D5BEACCEC22@SA1PR21MB6683.namprd21.prod.outlook.com>
References:
 <20260721-if-mana-table-store-qp-qids-partiall-v1-1-8fb3d2d2b559@nvidia.com>
In-Reply-To:
 <20260721-if-mana-table-store-qp-qids-partiall-v1-1-8fb3d2d2b559@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=5f60fe8a-0489-45d4-81f9-b420c9a3bddf;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-07-21T19:28:34Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB6683:EE_|PH0PR21MB6516:EE_
x-ms-office365-filtering-correlation-id: ccbafc4a-2989-440c-f7b4-08dee75e5359
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|56012099006|11063799006|18002099003|38070700021|10067099003|22082099003;
x-microsoft-antispam-message-info:
 NgQrbcb8pPnWnng+LQwtuxXiwNiq3xd1vWhmta4+awO9ig0U9dD/SXXmaGEpfTog93qN+EOKoCtSpRrxIcpmz0AKPaHVmzeiun0BxIDillOXPlRvzcRsCyPMxXUPF2UR/BG9W+89DJMJ3lzc6bD25JWxtP4btKEjSdej1GHD0JWjca2fdmiuuL3/WetpqgSb2Ic4lMpjI02oBVbTi5UbmV264HdxEADSQXwwVlQ5sDqDXUyZiiPjz7cfzsv3scDawyK8YbmKm/uA/gm4WXel4jtTOa0q4YjIllWd7DbZz58+i2+00rIpUKlfTiqgnhLhQ2GqonLsPk7LEyWQaHbW82cV9C8CvF4Pw/0spQkgQBtk7IWgCY19Va+s9KNjNxQzuuB7N3fF1qgpAtyYAHpOoU3gUVint1zeH+KQEeQCIw8D0IOCfQSEQeMDSjYI4itNdCCJRWwsAqJVpAFKlR3KVM/khC+KaDZXxM8EJkIzhfEQQcc8wFlzs44sDiFV2roeMQq6VOa/rWrqQA9ijtI6knje3kBBqHF/hVEGwg7zCDthEdTVrc+WHPzBf5c5l9b9REe/OVQNWR6Olj5/NxrAdjQxPl/72kllhjwMo5GKDSgPWByjSkQbZjQCYsprNVTdJuXIQt6hyGYPMOmCez65kjT1UC0kJ+WE66SfeYB8G3jPANf/+PhlDHgBtv7jBOtlck7jd0PCWUfLqzwtE9qmlrhXgQS36xMrC8vTuZqxgD0=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB6683.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(56012099006)(11063799006)(18002099003)(38070700021)(10067099003)(22082099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YXZVQ0JBYXRKUWpWUVlKZkZjcjh1R0tzUmF4NWdhQzRWbC9VRnFSYzdDZ3B1?=
 =?utf-8?B?L1NRNFZna09SZ09PY1h6ZldDUnZTM1k2ZG9Lbm03QUZMeDV6NldCdEw0VzBp?=
 =?utf-8?B?UUhlL3pNV3lBMFBmMlFPU2N2NlZSK0kxRjhnWlpFQnNMdXFBdmVINUZnVzFQ?=
 =?utf-8?B?Y3lTbFBZVG5TSlNyRlF2MkN4UzhQcWZQWG9pRURYR2UyWmxjeUZjcEZCVWxs?=
 =?utf-8?B?MVREWGlKbkFhRzZEYkpKamNPbnRzNUs4YTBvUHh1QVRJNFVRZzJqbE0rc3gx?=
 =?utf-8?B?T25TZ3RWbnB2dmxBZVhvbUdiNlVDOHVLKzBDZ0pyQ1RwQ21QNkVGQTlyZkRE?=
 =?utf-8?B?NERDWFJwaGNyc3F1UlIrMUtqdlhlSUd6TkRUOEtTSEt2OCt1Q3kxNU1Cby93?=
 =?utf-8?B?THBVVVJSNTZIMi8xTTlBWUxsby9ZU3FDWFMwS2dyanZZb0tjUmExU2hWSDEy?=
 =?utf-8?B?ZEZjMys1bUIyR0VwbHB0QVhMdTYyL0E3QnRnMU9xWTR2eTdkOUJLY3M5VHlZ?=
 =?utf-8?B?ekUzZUpHYVMrbUxFdlhrNWQvVlVkYUE4MHd5SDRJbmFrT0NPWGtZNkxmY3dn?=
 =?utf-8?B?YU1Xb1NpV3Rka1dRaXlaeUI1eTdlandJSEVhN0RGbHMyUlUzeGdiV1VQbGtV?=
 =?utf-8?B?TU5mS21nZkp5ZWt1QzhrNCtyWCtJYUM1aHNBQ3ltYzRuSzZGMEk4T0F5dTEr?=
 =?utf-8?B?QkI4eWlxVk9wbjFTWW1tVkJSU1JkQWVBZTUzRUgzSEpoUTBzNHBuUjBwUDYv?=
 =?utf-8?B?RURLL3VxUkR0YVBCNHRZYjBycGZiQmViUlRRd0REZWZhcnRTSjk2a21wSWZH?=
 =?utf-8?B?bU45WHBQL1M5TFM4Q0dPN3FEakVWTm42SDB1cUtrcER0NStIVTNma2czR0p4?=
 =?utf-8?B?cUVkbXdiWnJzcUNRbjR1cXBCMzdlK1RyYnowa3NhRElMODdTZCtURzlodE1E?=
 =?utf-8?B?Y0c2NGUzUXdoKzdZMGd1VmRXTkJMOWNncWtvKzhIY1QyS0hoeGgyREhMWUQ3?=
 =?utf-8?B?cTRnZjZSd0V4REhWZS9nUklhMjBFRzNuZlJVNk5zUjRPK3VaSUNuSnY0bTNM?=
 =?utf-8?B?aG50T1NNQVJnd1AyM1lCSXBUdVpJNFdyaGlpS3FJOGhRZHRMaldLcWNrOXB0?=
 =?utf-8?B?WWwyWll5ZkNXRmkrbFExLzB6c3NHYzJhUHUraFZQSjN0TmtJRFhLVTVXQWxk?=
 =?utf-8?B?MFNCOHIrSzVSS3NOdlFVUGpIc0NsZ1doRG5odC9CTW1IUXh5YjFVeWlHbUNK?=
 =?utf-8?B?NzhYZndJamw1S2ZMa0xTcUlEYi9lQTZRNjk0ZWVWam1tL3ZpU2lYbmdaay84?=
 =?utf-8?B?elVSV2ZkSmxseDI1eUt2SFlZSFptQmhVY0JnVEtiVjRkcDFXVldPd1ZnN1I2?=
 =?utf-8?B?dEZuREhlL0IzMnhMTEdWdTltVnBxVzNNdUF1S0p2YnFlemdqaEc1dGNGRTZT?=
 =?utf-8?B?bWNnY3Z2d2FnVWg1QnhieXNyeEQvZHV5Q0J3c1dtaXUvMnZtLy9IRUFsZ25O?=
 =?utf-8?B?NHZ1aWdyWi9oTnlXUnM2SVlMOTU4dW5LMWVTQ2xRcHl2ME16REdrdjNQWW05?=
 =?utf-8?B?VGlZUHBPNXFMZWppQVNXQ3kwZ2tlWDNBckc1QW5rVWxHV3hHa3VEZmJWL3JZ?=
 =?utf-8?B?ZVJRSUFZbGxESDV3VllhZmltcjRvVnFmMUtGcTdBOFpjNDh5MjZ4Wi9mK21m?=
 =?utf-8?B?cEQrK0JkbWFvd0JrUmNVRmxQUGdqY0w0bEl1eTFZTWlkMzgvUDQrdVRDTnRT?=
 =?utf-8?B?ZVF6SUNCTnRJakZXNUczTnRIczl3SDFiY0l5R0NvTWQ0alljWGFwMEYveldm?=
 =?utf-8?B?SmNUSmRwcmIwMzI5UkE0VldWelVyS1JJRFgyVDNHNUVqdURlTW4xNVVBd3pt?=
 =?utf-8?B?cXRYenBpaVFnUXNFUFBoWHhka1JyZlFxYlhaYUFIMnZkL3l5WnFPYk9iYnBL?=
 =?utf-8?B?b0Q1MzVMRGJJbG5BbVRPa2hCaVZmcU1rL2h3bHBzR2V5bXhuL2pFdm1Ya3k5?=
 =?utf-8?B?R0trREJZL2hkMzJDV0NyTFIyQ21rTnpVWFREYXJ6aGpqUXZMTm9QMGdaK3Er?=
 =?utf-8?B?enM4YWYwMTdZMHZXbWRPRittZlFWdkVSbkhDMXgxb1BRWlgyb1V0Q0k1aGlx?=
 =?utf-8?B?L2ZzSElMdU0rU2N6bVkyWHFZbmo3SXpmOFVhd3FPNjJlOHBPVWpmOC82MTVK?=
 =?utf-8?B?SVVncWdCWXh1bm5FclE4RXhTZ1U0ejZxdTNtUktPQnk2ZDZLM2JMTUxsenZG?=
 =?utf-8?B?Nm5ibnZjVEd0cUh0RVM0K3NUbzhQUjE2Y254bmFLQ0IzZmNCS1h2dlFsREM5?=
 =?utf-8?Q?OhYWQVhfe8EigiZ7AY?=
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
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB6683.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccbafc4a-2989-440c-f7b4-08dee75e5359
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2026 19:29:04.4097
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: voTplR74z5i2WBZavxL1fFYaLWsQkCW2QBZ9RZtx7AepuWgKKpR7si4SmbNnmi24f8cBy8ycGDD4AgaFizPufQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR21MB6516

PiANCj4gRnJvbTogTGVvbiBSb21hbm92c2t5IDxsZW9ucm9AbnZpZGlhLmNvbT4NCj4gDQo+IG1h
bmFfdGFibGVfc3RvcmVfdWRfcXAoKSBwdWJsaXNoZXMgYSBRUCBhdCBpdHMgc2VuZC1xdWV1ZSBp
ZCBiZWZvcmUNCj4gaW5zZXJ0aW5nIHRoZSByZWNlaXZlLXF1ZXVlIGlkLCBkcm9wcGluZyB0aGUg
WEFycmF5IGxvY2sgYmV0d2VlbiB0aGUgdHdvDQo+IHhhX2luc2VydF9pcnEoKSBjYWxscy4gQSBj
b25jdXJyZW50IGNvbXBsZXRpb24gaGFuZGxlciBjYW4gbG9vayB1cCB0aGUgUVANCj4gYW5kIHRh
a2UgYSB0cmFuc2llbnQgcmVmZXJlbmNlLiBXaGVuIHRoZSBzZWNvbmQgaW5zZXJ0aW9uIGZhaWxz
LCB0aGUgcm9sbGJhY2sNCj4gZXJhc2VkIG9ubHkgdGhlIHNlbmQtcXVldWUgZW50cnkgYW5kIHJl
dHVybmVkLCBsZWF2aW5nIGJvdGggdGhlIGluaXRpYWwgdGFibGUNCj4gcmVmZXJlbmNlIGFuZCB0
aGUgdHJhbnNpZW50IHJlZmVyZW5jZSBvdXRzdGFuZGluZyB3aGlsZSBSRE1BIGNvcmUgZnJlZXMg
dGhlDQo+IFFQLCBjYXVzaW5nIGEgdXNlLWFmdGVyLWZyZWUuDQo+IA0KPiBEcmFpbiB0aGUgcmVm
ZXJlbmNlIGFzIG5vcm1hbCBkZXN0cnVjdGlvbiBkb2VzOiBkcm9wIHRoZSBpbml0aWFsIHJlZmVy
ZW5jZQ0KPiBhbmQgd2FpdCBmb3IgcXAtPmZyZWUsIHJlbGVhc2luZyB0aGUgUVAgb25seSBhZnRl
ciBldmVyeSBjb25jdXJyZW50IGxvb2t1cA0KPiByZXR1cm5zIGl0cyByZWZlcmVuY2UuDQo+IA0K
PiBGaXhlczogODAwMWU5MjU3ZWNhICgiUkRNQS9tYW5hX2liOiBleHRlbmQgbWFuYSBRUCB0YWJs
ZSIpDQo+IFNpZ25lZC1vZmYtYnk6IExlb24gUm9tYW5vdnNreSA8bGVvbnJvQG52aWRpYS5jb20+
DQoNClJldmlld2VkLWJ5OiBMb25nIExpIDxsb25nbGlAbWljcm9zb2Z0LmNvbT4NCg0KDQo+IC0t
LQ0KPiBLb25zdGFudGluLA0KPiANCj4gSSBzYXcgdGhpcyBpbiBvbmUgb2YgdGhlIFNhc2hpa28g
cnVucywgYW5kIEkgYmVsaWV2ZSB0aGUgQUkgaXMgY29ycmVjdC4gVGhlDQo+IHJlZmVyZW5jZSBj
YW4gYmUgYWNxdWlyZWQgdGhyb3VnaCB0aGUgR0RNQV9FUUVfUk5JQ19RUF9GQVRBTCBldmVudC4N
Cj4gDQo+IFRoYW5rcw0KPiAtLS0NCj4gIGRyaXZlcnMvaW5maW5pYmFuZC9ody9tYW5hL3FwLmMg
fCAxMCArKysrKysrKy0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspLCAyIGRl
bGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5maW5pYmFuZC9ody9tYW5h
L3FwLmMNCj4gYi9kcml2ZXJzL2luZmluaWJhbmQvaHcvbWFuYS9xcC5jIGluZGV4IGI1ZmYwN2Uz
NGViNy4uYzUyZjNlYzE0MDMyDQo+IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2luZmluaWJhbmQv
aHcvbWFuYS9xcC5jDQo+ICsrKyBiL2RyaXZlcnMvaW5maW5pYmFuZC9ody9tYW5hL3FwLmMNCj4g
QEAgLTQ3Miw2ICs0NzIsMTIgQEAgc3RhdGljIHZvaWQgbWFuYV90YWJsZV9yZW1vdmVfcmNfcXAo
c3RydWN0DQo+IG1hbmFfaWJfZGV2ICptZGV2LCBzdHJ1Y3QgbWFuYV9pYl9xcA0KPiAgCXhhX2Vy
YXNlX2lycSgmbWRldi0+cXBfdGFibGVfd3EsIHFwLT5pYnFwLnFwX251bSk7ICB9DQo+IA0KPiAr
c3RhdGljIHZvaWQgbWFuYV90YWJsZV9kcmFpbl9xcF9yZWYoc3RydWN0IG1hbmFfaWJfcXAgKnFw
KSB7DQo+ICsJbWFuYV9wdXRfcXBfcmVmKHFwKTsNCj4gKwl3YWl0X2Zvcl9jb21wbGV0aW9uKCZx
cC0+ZnJlZSk7DQo+ICt9DQo+ICsNCj4gIHN0YXRpYyBpbnQgbWFuYV90YWJsZV9zdG9yZV91ZF9x
cChzdHJ1Y3QgbWFuYV9pYl9kZXYgKm1kZXYsIHN0cnVjdA0KPiBtYW5hX2liX3FwICpxcCkgIHsN
Cj4gIAl1MzIgcWlkcyA9IHFwLT51ZF9xcC5xdWV1ZXNbTUFOQV9VRF9TRU5EX1FVRVVFXS5pZCB8
DQo+IE1BTkFfU0VORFFfTUFTSzsgQEAgLTQ5MCw2ICs0OTYsNyBAQCBzdGF0aWMgaW50DQo+IG1h
bmFfdGFibGVfc3RvcmVfdWRfcXAoc3RydWN0IG1hbmFfaWJfZGV2ICptZGV2LCBzdHJ1Y3QgbWFu
YV9pYl9xcCAqcQ0KPiANCj4gIHJlbW92ZV9zcToNCj4gIAl4YV9lcmFzZV9pcnEoJm1kZXYtPnFw
X3RhYmxlX3dxLCBxaWRzKTsNCj4gKwltYW5hX3RhYmxlX2RyYWluX3FwX3JlZihxcCk7DQo+ICAJ
cmV0dXJuIGVycjsNCj4gIH0NCj4gDQo+IEBAIC01MzcsOCArNTQ0LDcgQEAgc3RhdGljIHZvaWQg
bWFuYV90YWJsZV9yZW1vdmVfcXAoc3RydWN0DQo+IG1hbmFfaWJfZGV2ICptZGV2LA0KPiAgCQkJ
ICBxcC0+aWJxcC5xcF90eXBlKTsNCj4gIAkJcmV0dXJuOw0KPiAgCX0NCj4gLQltYW5hX3B1dF9x
cF9yZWYocXApOw0KPiAtCXdhaXRfZm9yX2NvbXBsZXRpb24oJnFwLT5mcmVlKTsNCj4gKwltYW5h
X3RhYmxlX2RyYWluX3FwX3JlZihxcCk7DQo+ICB9DQo+IA0KPiAgc3RhdGljIGludCBtYW5hX2li
X2NyZWF0ZV9yY19xcChzdHJ1Y3QgaWJfcXAgKmlicXAsIHN0cnVjdCBpYl9wZCAqaWJwZCwNCj4g
DQo+IC0tLQ0KPiBiYXNlLWNvbW1pdDogNzRmNDkyNTU0OTJhNjI2NThmMzZiZjI1NzhkNzkxNmYx
YzZmZmFkMQ0KPiBjaGFuZ2UtaWQ6IDIwMjYwNzIxLWlmLW1hbmEtdGFibGUtc3RvcmUtcXAtcWlk
cy1wYXJ0aWFsbC1hZmExNGYwMjMyNjENCj4gDQo+IEJlc3QgcmVnYXJkcywNCj4gLS0NCj4gTGVv
biBSb21hbm92c2t5IDxsZW9ucm9AbnZpZGlhLmNvbT4NCg0K
