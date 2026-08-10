Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013042.outbound.protection.outlook.com [40.93.201.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A4B3F8893;
	Mon, 10 Aug 2026 14:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786372226; cv=fail; b=JRphyJ4HQBTPTWelLCciX/M2I8TKHi0VWH4eGxS9WL+jb9IbBpxF2M5IjZJT2ZaKxnC0CepExG3L6Uf3u23m3hMDgRDGdlZPG2ZqbnA+oGOrLPnixi/51d1/1MOWwLw4cX1yu5MTzQxrCrseXb5Np+VM1CChHefY5+jfxT6rscs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786372226; c=relaxed/simple;
	bh=Q5TAvqD+fqrAzD1FvXQa6ikgAfpX49W9tQJeMXN+rhg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=F0ZObGfM8JquNjxhVb5xxZ4Ml5mS1UsunN+U1VbJMlIiR5hpxWiNSQhbHlrYo6BKF3RTTJB4JbvquMWz5hkZPdVPoh5N1OdfLJiqxNutv/4N7TTxILiciPFc2zyqrtX/AHm1N8CG/0mKXSxPOov6YHvq//28G8AI3v1SDr1Zb6w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SlwgdAO7; arc=fail smtp.client-ip=40.93.201.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SlwgdAO7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WKw0CQuxZLWGpz/2vA+TNxQodFWY3MO3m/9zX+h3BQ8LwFimhp4Tdk4xAOgBGwc26ITQ1rSFBv4jBn1IT+/uopJx7QZ7ehPnPNzxKi7eUBWSuN9V+w60Ub1/Bq6JNHp0l4bRCvkvRgArzrwFKLqNEzlIgScBL+t38w1h2XmdsOiwDRPcvai7+A+ajA6dOFPD97SDaqVwf1RVXHfIzjbWPNiXz94x7p/ViHYk79HHaos7Rw3drw0bOn2o5XGDO/foU87WWWdQ0F58TsRs/xtJ/bnSLdqKnsRyxp1DQf/s0tTsyuyl8W1uKomrsumDtlVnreCe8j0EOccFdlhSARoRGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q5TAvqD+fqrAzD1FvXQa6ikgAfpX49W9tQJeMXN+rhg=;
 b=po9lDQ/D+KkEOMeJJZS/u0FXxH5CjSm4kaTuJWJG3NXbV/yEtQYvcw45qgAlbhNangfO8Fo9tR/T8ilWI1IQidwSuxgQCFKMDk8WV0NF8QWDppWnJSpMwwzAHAkhCn4d8EqNj18/k37Y0kyU2KibFftLY+YNCSDJKWvxxRtF6rkpckuoIeuxXgO2LoxJ/NdQ5eFYZciqexL+6129VOsPRtsOL3IVpT4PNSAzC9JlS+pO1z+zWLdTGohu+cc1ic/W6qqlmD5ZuWg2NU8pyZTpqKMK5j3k/pDecKZJZVBaetpuHUc7vI75nB5lvjmlSijsDGHyFsRzyUiqojENDDQ2cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q5TAvqD+fqrAzD1FvXQa6ikgAfpX49W9tQJeMXN+rhg=;
 b=SlwgdAO73G2v3njEDl60C8YbcnvOLl4WJXE7jEeKJ0t+aBNSFkYIutYzqhCRq63scvFYOjzZYA1hmWsNxIYIuczUBWaiS23wkyjdpc1MDJl4lhXF35ZEbtDsvCdsxrkmsGtts8kfS78nsVzvlj4/TcAT5tdCCIx1WzdnE/P1xQ6d/yQUcl+fFnSzY4QILicFqawIbPxD4qK0aaHH8JYWbeQEMTfTZoHUc4ycyEetMaxC+awcOh+xcKSC3WZIBiq1hNIt3485mHUH4ihFF0H3RBnhiAFpvtFIAQ/7krOr+33kIeCdUt8KKixd+ampEqAgPYQwMXI6gJaynOhKa8z5YQ==
Received: from DS5PPF266051432.namprd12.prod.outlook.com
 (2603:10b6:f:fc00::648) by IA0PPFAF883AE17.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::be1) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 14:30:19 +0000
Received: from DS5PPF266051432.namprd12.prod.outlook.com
 ([fe80::25c9:b561:2aea:8e3c]) by DS5PPF266051432.namprd12.prod.outlook.com
 ([fe80::25c9:b561:2aea:8e3c%3]) with mapi id 15.21.0292.022; Mon, 10 Aug 2026
 14:30:19 +0000
From: Cosmin Ratiu <cratiu@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>, "kuba@kernel.org" <kuba@kernel.org>
CC: Patrisious Haddad <phaddad@nvidia.com>, "davem@davemloft.net"
	<davem@davemloft.net>, "daniel.zahka@gmail.com" <daniel.zahka@gmail.com>,
	Chris Mi <cmi@nvidia.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "horms@kernel.org"
	<horms@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kees@kernel.org" <kees@kernel.org>, Dragos
 Tatulea <dtatulea@nvidia.com>, Boris Pismenny <borisp@nvidia.com>, Rahul
 Rameshbabu <rrameshbabu@nvidia.com>, Jianbo Liu <jianbol@nvidia.com>,
	"leon@kernel.org" <leon@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
	"shuah@kernel.org" <shuah@kernel.org>, "andrew+netdev@lunn.ch"
	<andrew+netdev@lunn.ch>, Mark Bloch <mbloch@nvidia.com>, Alex Lazar
	<alazar@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>, Gal Pressman
	<gal@nvidia.com>, "sd@queasysnail.net" <sd@queasysnail.net>, Raed Salem
	<raeds@nvidia.com>, "Jacob.e.keller@intel.com" <Jacob.e.keller@intel.com>,
	"skhan@linuxfoundation.org" <skhan@linuxfoundation.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"edumazet@google.com" <edumazet@google.com>, Lama Kayal <lkayal@nvidia.com>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"sdf.kernel@gmail.com" <sdf.kernel@gmail.com>, "doruk@0sec.ai"
	<doruk@0sec.ai>, "sdf@fomichev.me" <sdf@fomichev.me>,
	"aleksandr.loktionov@intel.com" <aleksandr.loktionov@intel.com>
Subject: Re: [PATCH net-next V2 13/13] selftests: drv-net: psp: Add a test for
 PSP with HW-GRO
Thread-Topic: [PATCH net-next V2 13/13] selftests: drv-net: psp: Add a test
 for PSP with HW-GRO
Thread-Index: AQHdI+yv39DUnRTc3kqHa/IbPCZqaraTWuAAgAQGzYA=
Date: Mon, 10 Aug 2026 14:30:19 +0000
Message-ID: <35b40fcde5439a9ff50054fa9d264b77307ee103.camel@nvidia.com>
References: <20260804083535.2946459-1-tariqt@nvidia.com>
	 <20260804083535.2946459-14-tariqt@nvidia.com>
	 <20260807180054.380be9d0@kernel.org>
In-Reply-To: <20260807180054.380be9d0@kernel.org>
Reply-To: Cosmin Ratiu <cratiu@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS5PPF266051432:EE_|IA0PPFAF883AE17:EE_
x-ms-office365-filtering-correlation-id: 2fd8d0e7-2886-4453-88ba-08def6ebe79b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|11063799006|56012099006|10067099003|4143699003|6133799003|38070700021|22082099003|18002099003;
x-microsoft-antispam-message-info:
 3Yua4b00yLfbTtB8U0dRHo+9uBdTAs3lA/GN/ekYsfpHu3E9WMorffS96laZw3ihg1H93MgyY64hCNNz39xZVv1/VJvTa9gGBI5PxmaoOyHqMzCRsXoc2kuj2EVEg7u4n16py0m9zRgzbKa8cT6pGCwY+07d1mieyHlQtZxmw27K1pFg4tDjUWwxOChfWg5DcNwEQeN3f/4hJsQHnttO0RkzGUTFwpsIJCHot4361K1cmqaqQg+r3VsjnJKvNqHvkCq/iI+bW248qQnrKqMeT5G4nL5TtClpE3VpiA32yJd5O4X4FB3vV5kon/JACW7NyTTac0Ac89GGDt+roeceu7g9Wq4jKxOhjofdCuBE3EA2Mjx7YfZMAwFtRJ/+ZsoTAMf1KUb3+AodIYE58LAkVhDNYIZ7Gr7si4Vju605DZi0CaOvaXrJqeCtB9GGUg6z9/zoQLT0rvTiLw8arNYIffNARJWhIasymczOZ0+zTgvZpG34BssqSVeS3mUR3Cn4FhIBnJhrLUS3/p0QPHNgEQXpE0xruEGlQJr9R6bOGMKOD/Wt4iAxjkP6Vr6mGNFJAn1zMzILoljZ+kJzacXYkMcsdXAL6q4HmfigVWT8l+JOpiYtDG6YsT0rVXKW02/BxXOBVx9H4JgNHm4/EUI5DREhH7nYx0IPViLD/IgrU8yE1r4hqlBA9ItZ03zB6Q79MoiFncULxMuxMvaWS0/ONOujdzJrstT241rhhrFj7L0=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS5PPF266051432.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(11063799006)(56012099006)(10067099003)(4143699003)(6133799003)(38070700021)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SVdjK3BRSHlieHpMWFg1NjhDYWtsSTlyMExHUG1CSE13TTNlT2x3L1ZpTW9M?=
 =?utf-8?B?TmxnR2dhNzdBc2NEL1phRVBQVnltblNYRi9xMHBiMUFqdnZ1a2VpVStQVkZn?=
 =?utf-8?B?dFpTdG1mQnQwdHRPME9wLzRUci9GQ0FEUTZSbitQSjd4OTVDQnJpcEQ3cCtu?=
 =?utf-8?B?L1dzY2RscE0wVkpoV1FDcnJ0WVJtSlFuczQ2NEs2RTVBRHJ5QVdoNGNnY01s?=
 =?utf-8?B?eEhCQ3Vmd2M4d0N5Vml6dTBLMFV5T0VjYnB2WFhDVzdSRWN2aTRKUFVFbGNO?=
 =?utf-8?B?NXp0eVFyaHNhU2FmZ0JScER0cTJoNmppd0lzemFOc3J1ZjR2ZU9KcFpoNkRM?=
 =?utf-8?B?TkN5OE00MlhQV1RYOVg3NmdabjhkT3dhRE1ObWkrQ3kwNll1K3FQVGY1cm5v?=
 =?utf-8?B?N3ArWG5rYkFFcTA2dUlqcCtzTkFVeTJ1c0tPNjdzaVIrWXN2cXNTbVFteUN1?=
 =?utf-8?B?NUIrSnNyN0FmWlhWbnVBTWV6aTIyMXUySElJUjlBR3dnWkx1YWlmNlg0bWZ4?=
 =?utf-8?B?VXJoWExoeDFqWHVqUHpUSmp2QjdYZW1DTUZrRjhOZm5MY1NsSEc5b0lDcVUv?=
 =?utf-8?B?QWhlQXh2MEw3Yis4T0tKeDdNVFhTcE1WRXE3TEVQTnJwY0k0T2JDaUhUa05Q?=
 =?utf-8?B?TmIyNGZuVVNidE5oVHpjelVTa3Z6R3dwZ0xBcnhQVjFjK3NSYnVtWXY4MGwr?=
 =?utf-8?B?MFJDT1E5RzRlR1ZOTVlQWnVNNjZOZ0RnWTBQM0U5OFhLRXJsQnJSalZEM2dQ?=
 =?utf-8?B?YUhXY0FQM0tlTEtRUE1IZlAzM2ZKdWlQS3dLeS9Oc21pREdPbDhQUUZmMXJ3?=
 =?utf-8?B?WWVuenFJOVV5VVY2NjJqQWh0STVWalVqVzJQcjVvbU5RSXJ4RXBad2I5Q3F3?=
 =?utf-8?B?TGY1K1JNYlJnQ2V0YUUxMC9TekpZeWV4VEdIeFo3SytLdy9pbzNMUnNmSjcw?=
 =?utf-8?B?Z0Njc2ZyeUViZVRsYWlIdlhDWGJnL0lsV3ZDMCtOdFV6YUhSaGxVcDFrZm9U?=
 =?utf-8?B?UnZpcTd6ZUZod0FzOWkwNXdYZmh1dElPQVJ6am1KYWxhdFlSMzNVVHlETkQr?=
 =?utf-8?B?TVA0UXljdm8weVFlU0NkUjFvTW1mS00rQmtzOElhQk9XaXJtSHlJOG5uTS93?=
 =?utf-8?B?bmJFSUJEekRwUDVMdk54SFV5WW53Rjhua1RkMko1ekFkZGsxcTdtUkdaT3ow?=
 =?utf-8?B?V3FVOG9sczJpdDBHUUtDVXVzQ2dQZUI2Q3RxV1ZHUmcvWHgrN2xUNkRpLzJy?=
 =?utf-8?B?ZjcwRHFOelh3YUM4TVdWRFh2bzJZbThqZjdDYTRkdTNvdnczRWIvVldKa0Yx?=
 =?utf-8?B?Zld3WEE2TU1pL1V2Wmlaa0t6WnZFRys5R0tudWNKVFRWeGZKMmJvNHlxcEIw?=
 =?utf-8?B?ZHp1NnluL0RZcmYyNWVRQUZpMTNyVVI3QUJKOUZZMzdTSkF2S2dyK0czeDVi?=
 =?utf-8?B?SHNUZFdTamJyUmVRUkx1YlA4R0psRUxVUlFZSEh1QmIvWmcyWDhoV1FRVkVC?=
 =?utf-8?B?Ny9Zdkh4T1N3dGZiUFovUVFTaTU2ZFNzNGxOd21DVkFQSmNxWnhyVldsekZZ?=
 =?utf-8?B?amc1OWFqK0N6UDRDMmRCUE1FaUpxYXR0VkZQcEU1b1hsdHhKWnBuQWh4NEVh?=
 =?utf-8?B?cmZWaEVSeDZXUlUrZ0tDTVZwME1TQWVaVFUrT3BaSktuUGV6ZDhTYXlPMXgw?=
 =?utf-8?B?cDEyYlNQek03WGcvNlZQZzNoRnBFbXZwakszMUFXd0lNUHJJbVRwZHR4SWp3?=
 =?utf-8?B?Zi9YQVQ3Rk10cmdNYzRwVHdwdTFDSmFPaWZvR2I5SVN5SUtKa2t3UEdsckts?=
 =?utf-8?B?MUtoaVpJYTVROVdhcWdPREJZdElWZjVIZUEyV1ZwNGdRQVIxbFhnVDIrNnJu?=
 =?utf-8?B?WkYrTm01Zk9MSGRIQjRNeU44NjlEbGFTVWZjYytSUk1YaDhxcnF0OUF3ZnJZ?=
 =?utf-8?B?ZVJTNm1renVONURtY05zL0tIaDdCZlNKVm9MR1ArYno4Qm45TS9xaGcrUDhU?=
 =?utf-8?B?UUlHMk5yT1Y4V1hLeDZzdmozSlJNQ05zSjNvWEM0WkNMRXNzaFJ1Y1VhQWF6?=
 =?utf-8?B?Q1lPbmlHZ1k1Q25ZUTlsRnROVGErckFJcGV4bjVZbThTMC9oMHZtR0kvVnBi?=
 =?utf-8?B?L2FWSkx3Y0JLSDRzVWMyeHBJNHZNZDhaWFJHYWJuUmhyeXF5VEZkWGtNc2FV?=
 =?utf-8?B?TmJQSUFLZWxaR0tLbGJKVDR4S1BCN3pOZmNIcW5lLy9tUFpVd2xVSkoweUV1?=
 =?utf-8?B?SWRRSHc1QitJNDR2bDBUSldxTjQySmJNSUhIbGJrVDJzWDk5NXZvNkxtSTkz?=
 =?utf-8?B?RnQ2ZkR2cTMrYTJGR0RTalZxMDdDWnBMZkF0Sm9kUDF3OE9HU1d1dz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <997AE80D5C6F8445B70A8B70414181AA@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS5PPF266051432.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fd8d0e7-2886-4453-88ba-08def6ebe79b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2026 14:30:19.6069
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ik+V6iSQzRyjqWRJftQzpS+iljcGPr8YX5+2BKsMrDLCQo6Pa0OLuqadibmpiigeT+z3so21KK2F1T9xKXH1Qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPFAF883AE17

T24gRnJpLCAyMDI2LTA4LTA3IGF0IDE4OjAwIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVHVlLCA0IEF1ZyAyMDI2IDExOjM1OjM1ICswMzAwIFRhcmlxIFRvdWthbiB3cm90ZToN
Cj4gPiDCoHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2RyaXZlcnMvbmV0L3BzcC5wecKgwqDCoCB8
IDEzMQ0KPiA+ICsrKysrKysrKysrKysrKystLQ0KPiANCj4gVGhpcyBpcyBub3QgdGhlIHJpZ2h0
IHBsYWNlLCBhbmQgdGhlIHRlc3QgY292ZXJhZ2UgaXMgcmVhbGx5IHdlYWsuDQo+IFBsZWFzZSBz
ZWUgdGhlIGxldmVsIG9mIGRldGFpbCB3ZSBoYXZlIGluIHRoZSBvdGhlciBncm8gdGVzdCBjYXNl
cy4NCj4gVGhpcyBzaG91bGQgcHJvYmFibHkgYmUgYSBzZXBhcmF0ZSB0ZXN0IGR1ZSB0byBhIGNy
eXB0byBjb21wbGV4aXR5LA0KPiBhbmQgd2Ugc2hvdWxkIGV4ZXJjaXNlIHRoZSB2YXJpb3VzIGhl
YWRlciBmaWVsZHMgUFNQIGhhcywgYXMgd2VsbA0KPiBhcyBjcnlwdG8gZmFpbHVyZXM/DQoNCkkn
bGwgbW92ZSB0aGUgaHcgZ3JvIHRlc3RzIGludG8gYSBkZWRpY2F0ZWQgcHNwX2dyby5weSB0ZXN0
IGZvciB0aGUNCm5leHQgdmVyc2lvbiBhbmQgaW5jcmVhc2UgdGhlIGFzc2VydGlvbiBzdHJlbmd0
aCBzaW1pbGFyIHRvIG90aGVyIEhXDQpHUk8gdGVzdHMuDQoNCkkgZm91bmQgYSB3YXkgdG8gc3Bh
d24gbXVsdGlwbGUgcHNwX3Jlc3BvbmRlcnMgdG8gdmVyaWZ5IGNyb3NzLXN0cmVhbQ0KYXNzZW1i
bHkgZXJyb3JzIGFuZCBvdGhlciB3ZWlyZCBlZGdlIGNhc2VzLg0KDQpJbiBvcmRlciB0byBhdm9p
ZCBkdXBsaWNhdGluZyBhIGxvdCBvZiBwc3AgY29ubmVjdGlvbiBtYW5hZ2VtZW50IGNvZGUsDQpJ
IGhvcGUgaXQncyBmaW5lIHRvIG1vdmUgc2hhcmVkIHN0dWZmIGluIGEgcHNwX2xpYi5weSBmaWxl
IChzaW1pbGFyIHRvDQpody9kZXZtZW1fbGliLnB5KS4gSSBrbm93IHlvdSdyZSBhZ2FpbnN0IGZy
YW1ld29ya2lmeWluZyBzdHVmZiwgYnV0IGluDQp0aGlzIGNhc2UgSSB0aGluayBpdCdzIGEgZ29v
ZCBjaG9pY2UuDQoNCkFsbCBvZiB0aGlzIHdpbGwgcHVzaCB0aGUgc2VyaWVzIHRvIDE1IHBhdGNo
ZXMuDQoNCkNvc21pbi4NCg==
