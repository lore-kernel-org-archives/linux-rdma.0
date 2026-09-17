Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010026.outbound.protection.outlook.com [52.101.46.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C77C4DC557;
	Thu, 17 Sep 2026 14:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789657166; cv=fail; b=QwVjl8IpBsl7oPEIunJS5o0CUFMHlQjgfAbXc+Gu1tqFcuqO+/Mz3WDuZ7N9gY0z9/uTJuH3KK2Sha/+aNdVsv5d4GrcqzCO451d1M3rvAHfE8fT1KhFdAyslLGTLmcseIPEqzl84qNCVlsyXeH0e8ZvTTPCx2oo7F3kAc0AvKw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789657166; c=relaxed/simple;
	bh=ujLfub7e/mwxZKsu5/U1y8zRVDvau8FRF6HyAnPfrs8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=igozqoSkIHabATsAeobAGaAPmk7LtkXK05wCpfXJptM8rnEHxo9KN89BZ/0flb4kY66sTbcW495/+ZPVFrM5Hq+4j/Ph4Lt1Yk5qHhdXb4zzHTkKQlHoqtKv0bwVp+HWBoTDtmLI6HYin7gQkVJuOYkwtShwwG8zf6obTPQ9yPA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XE+vTxPx; arc=fail smtp.client-ip=52.101.46.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XE+vTxPx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l7yXociPeq28CvQ8rjp64jA4oNa9WjIDVJf/7QuNMLdMtgTSeATRoFyRkMxDA0KDqXmOgwZWww/i0CbC63r2L+9Yj0Vo5kMnmaM1nvayZEW4VrZLR0EPEA4IHSjoubGhwwa+gUYkWrN6L14uwvLglRu5ROdzZRDS9PCjbqVmJ6K459iN1G8hPLxup8oyyihtLpqkCVPlHRe+9l3+n1fgFibT0TLXyF+PCoVFfG58LOsc0k4pNSSxqU2d29tZVhaidT6yIcOjdO1meZgpHL0zikGCioBkvNRdT7HWYv7mWV18s0EfaQXGwSEtQkZ5Uu1OXrXaaMQpMfbsdibXAkXEGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ujLfub7e/mwxZKsu5/U1y8zRVDvau8FRF6HyAnPfrs8=;
 b=v++Ca+ohhz82J7jB1D3aKtsR8IUHXu+TyYLht/+JQwHbEMwoJCPbl+euZkAbOBCMe3pFYP0aloEkSxvsL3g6t9ZqxjHnrL+VBXgmkCH6km+d0zsNEaOnYyRDVTx/xjM8TPhiqPI+ToKA6MkKWeQfNV5DHPwuDAJsEzfAvsuWHB108+z7peRNDYJNIU58WplEZlCyzk+57OFUrrqbohK/WiVtdyTKQ9PXWrVdbgeQgrNT3nFIqHWy7sA9ACZAyIFyURc9CTlfsVq+yfE0aBpLZ+rCp0waG3uhZWA5gy2ZezVTMaaCuurHA/UNFp5z8ehemp2t67EYeEPBgc9rwr/bzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ujLfub7e/mwxZKsu5/U1y8zRVDvau8FRF6HyAnPfrs8=;
 b=XE+vTxPxDfvXNdd180CCiZiLzjg0MYUegy3e5+w0BnWtpoH3x0WBABZjGqALeMoB4IWpXyMaF9frNEZoTXquxhoWWn7t/WhxZgy3RI9tq/v0qsvm2kpxmIiv8UHcSNbpjXOq+Jaz1uvtnVietRkdi1yvInyR/JZSrOl7xEGBJFFCui2JgFtD9x4d47KApbbgWlzg4CnaHxkyzraISBySpGzwl+k0ylNKpZ/0QfQys5QW3+H4wo7teaVAVRFsHmcoWrRrNzXaHhgVCv7LEueVrRiVJC4yRxermqdjlDmVSVDVMGnrxNcQ/VYzpGmfyJFUQ0V58NeLM1FEnusIYEr5Yg==
Received: from DS5PPF266051432.namprd12.prod.outlook.com
 (2603:10b6:f:fc00::648) by IA1PR12MB9030.namprd12.prod.outlook.com
 (2603:10b6:208:3f2::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Thu, 17 Sep
 2026 14:58:54 +0000
Received: from DS5PPF266051432.namprd12.prod.outlook.com
 ([fe80::25c9:b561:2aea:8e3c]) by DS5PPF266051432.namprd12.prod.outlook.com
 ([fe80::25c9:b561:2aea:8e3c%3]) with mapi id 15.21.0428.009; Thu, 17 Sep 2026
 14:58:52 +0000
From: Cosmin Ratiu <cratiu@nvidia.com>
To: "andrew+netdev@lunn.ch" <andrew+netdev@lunn.ch>, "davem@davemloft.net"
	<davem@davemloft.net>, Tariq Toukan <tariqt@nvidia.com>, "sd@queasysnail.net"
	<sd@queasysnail.net>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "edumazet@google.com"
	<edumazet@google.com>, "daniel.zahka@gmail.com" <daniel.zahka@gmail.com>,
	"kuba@kernel.org" <kuba@kernel.org>
CC: Petr Machata <petrm@nvidia.com>, "doruk@0sec.ai" <doruk@0sec.ai>, Boris
 Pismenny <borisp@nvidia.com>, "shuah@kernel.org" <shuah@kernel.org>,
	"willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
	"leon@kernel.org" <leon@kernel.org>, Jianbo Liu <jianbol@nvidia.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Rahul
 Rameshbabu <rrameshbabu@nvidia.com>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, "bobbyeshleman@meta.com"
	<bobbyeshleman@meta.com>, Raed Salem <raeds@nvidia.com>,
	"skhan@linuxfoundation.org" <skhan@linuxfoundation.org>, Carolina Jubran
	<cjubran@nvidia.com>, "kees@kernel.org" <kees@kernel.org>, "horms@kernel.org"
	<horms@kernel.org>, Dragos Tatulea <dtatulea@nvidia.com>, Mark Bloch
	<mbloch@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, "willemb@google.com"
	<willemb@google.com>, Gal Pressman <gal@nvidia.com>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH net-next V4 14/14] selftests: drv-net: Add PSP HW GRO
 conformance tests
Thread-Topic: [PATCH net-next V4 14/14] selftests: drv-net: Add PSP HW GRO
 conformance tests
Thread-Index: AQHdP18K2aMxiqVMS0SVl9iLPnxsmbbFUy0AgA2YLQA=
Date: Thu, 17 Sep 2026 14:58:52 +0000
Message-ID: <ec10b8dfb77efae7bb299940294b329b06656edf.camel@nvidia.com>
References: <20260908065244.3799142-1-tariqt@nvidia.com>
	 <20260908065244.3799142-15-tariqt@nvidia.com>
	 <DLABL6GQC9HK.2P8KU1JJRO1XV@gmail.com>
In-Reply-To: <DLABL6GQC9HK.2P8KU1JJRO1XV@gmail.com>
Reply-To: Cosmin Ratiu <cratiu@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS5PPF266051432:EE_|IA1PR12MB9030:EE_
x-ms-office365-filtering-correlation-id: c6fa4d02-974f-4a9b-9688-08df14cc302a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|3023799007|10067099003|22082099003|18002099003|56012099006|11063799006|4143699003|38070700021;
x-microsoft-antispam-message-info:
 hAwhrmbOLpFFIP+LlpeIGfzXGqdLgFJiAcLrCxCrMkhjAOPwNFsg0lR5p+jFAcEkvz3lzTMN41twsr6TLC4SgohCbH2lBLO8eSk/ksU2cusqQOzjUbTEaV7pndz/wuN2PAm+hgTUrQ9TOLH00HDWemFj3L0uuVdaBAECZNuta7UTX97dGj0LecOqJbPW9DpflCInpQx245UVs9bcl8mCPSi9rlw+CG8quu9zOGOUlykg8B4e01fD4tVAO6Uawy7FwDHmaxYepCyl6Wt/n5bNquARTxLMMQiv9lZ/x0wHK2jhQAwFA+LYYhQ9ZDXnjOZ/9W+hPAqtmLCpTSZeeBUgvZLGlVcm/15/9mbJJ0azGQV9kmwtmdaqBPrHgQW6cSadJSPtPPNCHeGaxNXD8oVlkupb3QPeFeLWQlUMmBWUWRQYi5c917ZKAIaty3TSbq990l2ejva/Bh6wVKQk5qTpseJaiKdzbYuycfmnmwd1xOOgKuEAlBYJrD93e5TfHa/5xjwpbwRvQpeLva6eQlFAMAQgTYnef/0/Iyg5t6qGguqPqTxZFZjHGSkEQ24lzHEAtJgHbFhHkBFX+GB3XzndGkZcM4WLl59gilNdlH38fiqhiKZ92qC204A5GFaUO+vMZZpgmWSLdqfSjdHicNsfxDHdOhgSWFZADNyN11Ag9pqcpvk7Q38Cs9OLtsSMvwG/hffyk+Yd9WNmovreHg2/QS8tCYGLnHwJkR0ds18vems=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS5PPF266051432.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(3023799007)(10067099003)(22082099003)(18002099003)(56012099006)(11063799006)(4143699003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bWpYVHpMd0p6WFRKMHZmUytxR0ppMjc5c0tXQkh6V3pxTkRwYzRHK2oxenUy?=
 =?utf-8?B?cktEYklvTnFwSWVwM2tlRmpESXNOdG82enpUb1JSN1Jlc3F2R0FMdGNucDJE?=
 =?utf-8?B?RHZPZDlURkRBSEFvcDBEZjY4d2hwK0hyMkt5WWFQM2FOcC9FLzhPZWtYRnor?=
 =?utf-8?B?WVA2Q3RxK2JpNzRENloxZ2FYYW5Bc2pyaHhjSmNLR2tnVEdVL3J6K0ZBZ09F?=
 =?utf-8?B?SUpweTIyLzBiRTVVUmhHUWx5RkJKRjFENm5PenRZOHRESjY2VjRZdGN1OHhx?=
 =?utf-8?B?TGNBbmh5R2VKV2IraUE4Y09zKzVkc2gxbW5vWE5WVHZIK3Yxc2dHdElXcGRP?=
 =?utf-8?B?a0hhOEhLY3h1VkxyVDdsYmo4MHRLdDU0MnFpWnMwMU5Pa2FNK0MvMDBCUFA4?=
 =?utf-8?B?SmZuQldoOE15dlg2Q0drUm84dUI2L1VIbEtmdTNMaGQxSXBrYXkyRU5jTHIy?=
 =?utf-8?B?dmZkVXBBaUZLUG1FUmgva2ZNa3ZLTnNBM2VaQXlQWlpZRWwrZ25kaXFVd3hN?=
 =?utf-8?B?RmdCV0trV0FLS1Bac1JONFdBdHpGbjNqMkpKaGpGQkFSOWtpTWY0K0F4NkRU?=
 =?utf-8?B?VllDMkllV2EyRWdHWENpaDNLWS81dWFjbzdMeHpXNCs0NnZvRXQ1dnh0NGFk?=
 =?utf-8?B?L2dqOWxIUlh4UHBGREdhbGVRVldLclp2ZkpkdzZjTThBSnpKNis3djBJZjc5?=
 =?utf-8?B?TFVmZ1ZzdzhQYWhNcFo1ZEs5cHZVRitubVYwZ0N2Zk9NMytaZUVjZHd2RDQ5?=
 =?utf-8?B?bTRNaHpSOG5UenRDb2hXeVVIb2tZOTVRQnZVUWtaQnRwenJXWHo3d2FlT2lm?=
 =?utf-8?B?dzNzUW5TOTFldEh2SThVNFUvSWtvdXZDOGdDSUh1YlUzRjJhZ0hHZS91ZFR6?=
 =?utf-8?B?cHQ4U3RwUGh1MGxUblRZV3pkSFdkRVg2VFRVOVkvVDdyQTRqUm5EcGcxUko4?=
 =?utf-8?B?K0ZRbk9USVlqRk1OSVFVN1BCaTFJSEFTSkVRY1lYcnJDNTNqM01HQ2NHTGlW?=
 =?utf-8?B?Z3VIK3pyUEhRZSswNUR6RFdPWEJGSEpVQ3Y0L2k1TXpXaDJNV2tiMHNEZStw?=
 =?utf-8?B?bFNZWGJSWFQxZFBCYVhxWHBQQTdzVUIyRGthb0ZVNENEVFlTV3JsWnpBV1pl?=
 =?utf-8?B?ODdldlVXanlXdDIrVVNMOEhRSVZiZWRVMTlQRUhjL2tYMnhJOWhEVHFPdlBB?=
 =?utf-8?B?V3MxblJzN2QzODFFc2J3eEFFVXFIdEpIN21RSzZqZGZzVnVOVy9NM1V0aFhG?=
 =?utf-8?B?M21PcFNKL1NqM3pqanJoeHJpSFZHdC9iclhXMjhOS1JOdmRESGF4NDRKb2oz?=
 =?utf-8?B?bi9GY2pESTBNaFNmWFduMW0wb3l0RldyRTF5RXMzSlpQSUpuYXJtaTJTa0VD?=
 =?utf-8?B?MmhZZlRCcFpuc2l1N1ZBNEg2TkxYbUpBNUM4b1RzYzd6Z3VPaVRyN2JoeGpK?=
 =?utf-8?B?Q3M3NTBkSFpYQ0tmYnl2MFBQZUpSZ3Bqb3FtSDh0ZU40WStzWXYyQ1pzcXhZ?=
 =?utf-8?B?M3BIWndtdklsUzV6c29ORWdlaktVKzhuU3Ryb1pFNlFCZlNqam5ZMmxtOE91?=
 =?utf-8?B?VVRCeURuQitLYnMrUXVKejRNcGxNY2tXSEtYNXZramlMbENLK0QwQnlPOE1l?=
 =?utf-8?B?MzNqdXZzck9FQmdydk1jOUY3Q2w4QWxwaU1wQ011S2dkYlJYaWRwM243ckJR?=
 =?utf-8?B?OGNiM1pPeGtBdTErdmdHOFZKcmFUaU02WndEOTVPR3VYQ0hxK25MQ3BLaVZs?=
 =?utf-8?B?bUlhekdFVzA4WURpTS9zK3NKMFlOWmVvRHhnMysydkwxcDVxN1VUZ0FxM3k3?=
 =?utf-8?B?a2RnUGdNZzRJVlpjdmt3R0M5SG01YXhIV3RNS1BYTTlyUWxZZkRRRkJpNXJn?=
 =?utf-8?B?dU9XNVd4bWFWUW5GWnpUU1JLSlBTWjhsVEh0bXRHZ0xBZGVaa0F5SFhYZ0VF?=
 =?utf-8?B?YUZqU2lCQ2RUZjFtcG9zMXpWT1JQR2FvV3lETitCMWo2TVcyT0RqVm84NWNJ?=
 =?utf-8?B?eGtUV2ZGQkg4SU1DVzVzRUF0OE1lQmt3VHdmenB5WElONjBoRUM4a0NUVmZx?=
 =?utf-8?B?TUgvK1JuUzFhaENtWG5nMmlQS1dhQjh6cHpWSFJTVGJpdTU0QzJXNTB0TzdE?=
 =?utf-8?B?c2ZhTHpqRGw0aXVXbXZsQkcwME9yb0RrcTczU0VBT29HWFh1VXZ1Z2pRS0pq?=
 =?utf-8?B?MVpCS1VUYm42N0hyQjBmWTdoRHduTS93YjUxZE9KMnFUV3EycGZYamJ6M0RM?=
 =?utf-8?B?ejIrL0R6dU4zSWs2Q1M5TVE3R0o5Q1pjNE1QYW1ObHFzcURvbE1HZnVhQVhy?=
 =?utf-8?B?R2M4MXcxN1F5dDBNa1o2S081ZU1RU3Bpc2QwdVFtN0xoVk9hZjZnUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <269C298FCA85E84191769F416C1C3C33@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c6fa4d02-974f-4a9b-9688-08df14cc302a
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2026 14:58:52.3313
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bqTBCaKsheKdXxjV0KkmvfOZdw8hBsVSCOTkpIIG+Tn8GnQHkfxAnDumgyyUOUrhT1WyZJ94b4MsBcAAC7+V0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9030

T24gVHVlLCAyMDI2LTA5LTA4IGF0IDE5OjIyIC0wNDAwLCBEYW5pZWwgWmFoa2Egd3JvdGU6DQo+
IE9uIFR1ZSBTZXAgOCwgMjAyNiBhdCAyOjUyIEFNIEVEVCwgVGFyaXEgVG91a2FuIHdyb3RlOg0K
PiA+IEZyb206IENvc21pbiBSYXRpdSA8Y3JhdGl1QG52aWRpYS5jb20+DQo+ID4gDQo+ID4gQWRk
IFBTUCBjb25mb3JtYW5jZSB0ZXN0cyB1c2luZyB0aGUgc2FtZSBncm8gaGVscGVyIGJpbmFyeSBh
cyBvdGhlcg0KPiA+IGdybw0KPiA+IHRlc3RzICwgYnV0IGluIC0tcHNwIG1vZGUuIFNQSXMgYXJl
IHByb2N1cmVkIGJ5IHBzcF9ncm8ucHkgZnJvbSBhDQo+ID4gcmVhbA0KPiA+IFBTUCBkZXZpY2Ug
YW5kIGhhbmRlZCBvZmYgdG8gdGhlIGdybyBzZW5kZXIgJiByZWNlaXZlci4gVGhlIHNlbmRlcg0K
PiA+IGNyYWZ0cyBhbmQgZW5jcnlwdHMgcGFja2V0cyBpbiBzb2Z0d2FyZSwgdGhlIHJlY2VpdmVy
IHJlbGllcyBmdWxseQ0KPiA+IG9uDQo+ID4gdGhlIEhXIHRvIGRlY3J5cHQsIGRlY2Fwc3VsYXRl
IGFuZCBkbyBIVyBHUk8uDQo+ID4gDQo+ID4gQmVjYXVzZSB0aGUgTklDIGRlY3J5cHRzIGFuZCBk
ZWNhcHN1bGF0ZXMgYmVmb3JlIHRoZSBmcmFtZXMgcmVhY2gNCj4gPiB0aGUNCj4gPiByZWNlaXZl
ciBBRl9QQUNLRVQgdGFwLCB0aGUgZ3JvIHJlY2VpdmVyIHNlZXMgdGhlIHBsYWluIGZyYW1lcyBh
bmQNCj4gPiB0aGUNCj4gPiBhc3NlcnRpb25zIHJlbWFpbiBleGFjdGx5IHRoZSBzYW1lIGFzIG90
aGVyIGdybyB0ZXN0cy4NCj4gPiANCj4gPiBTbyB0aGVzZSB0ZXN0cyB2ZXJpZnksIGF0IGxlbmd0
aCwgdGhhdCB0aGUgZGV2aWNlIGRvZXMgUFNQIEhXLUdSTw0KPiA+IHRoZQ0KPiA+IHNhbWUgd2F5
IGFzIHBsYWluIFRDUC4NCj4gPiANCj4gPiBBZGRpdGlvbmFsIFBTUC1zcGVjaWZpYyB0ZXN0cyBh
cmUgZGVmaW5lZCB0byBjaGVjayB0aGF0IEdSTyBkb2Vzbid0DQo+ID4gbWVyZ2UgcGFja2V0cyBh
Y3Jvc3MgUFNQIHZlcnNpb25zLCBTUElzLCBlbmNyeXB0aW9uLXN0YXR1cywgZXRjLg0KPiA+IA0K
PiA+IFNvbWUgZ3JvIHRlc3RzIGFyZSBub3QgaW5jbHVkZWQgYmVjYXVzZSB0aGV5IGRvbid0IHdv
cms6DQo+ID4gLSBpcF9jc3VtOiB0aGUgY2hlY2tzdW0gaXMgcmVjb21wdXRlZCBieSBwc3BfZGV2
X3JjdigpLg0KPiANCj4gcHNwX2Rldl9yY3YoKSBpc24ndCBvbiB0aGUgaHcgZ3JvIHBhdGggZm9y
IG1seDUsIHJpZ2h0Pw0KDQpZb3UncmUgcmlnaHQsIHRoYXQncyBhIGJvZ3VzIGFyZ3VtZW50LCBz
b3JyeS4NClRoZSB0cnV0aCB3YXMgdGhhdCB0aGUgZW5jYXAgc3VwcG9ydCBpbiBncm8uYyB3YXMg
cmVjb21wdXRpbmcgdGhlIElQDQpjaGVja3N1bSwgc2Fib3RhZ2luZyB0aGUgYmFkIGNzdW0gdGVz
dC4uLiBXaWxsIGJlIGZpeGVkIGluIHRoZSBuZXh0DQp2ZXJzaW9uLg0KDQoNCj4gPiAtIHRjcF9j
c3VtOiBwYWNrZXRzIGFyZSBtYXJrZWQgd2l0aCBDSEVDS1NVTV9VTk5FQ0VTU0FSWS4NCj4gDQo+
IHRoaXMgYWxzbyBzZWVtcyBzdHJhbmdlIHRvIG1lIGFzIHRoZSBodyBncm8gZW5naW5lIGFuZCBp
dHMgZGVjaXNpb24NCj4gdG8NCj4gY29hbGVzY2UgdHdvIHBhY2tldHMgc2l0cyB1cHN0cmVhbSBv
ZiB0aGlzIHNrYi0+aXBfc3VtbWVkDQo+IGRldGVybWluYXRpb24NCj4gaW4gdGhlIGRyaXZlciwg
cmlnaHQ/DQoNCkFub3RoZXIgd2VhayBhcmd1bWVudCBmcm9tIG15IHNpZGUsIHNvcnJ5LiBJIHdp
bGwgYWRkIHRoZSB0ZXN0IGJhY2suDQoNCj4gDQo+ID4gLSBpcF9mcmFnNC9pcF9mcmFnNjogUFNQ
IGlzIGluY29tcGF0aWJsZSB3aXRoIElQIGZyYWdtZW50YXRpb24uDQo+ID4gLSBJUHY2IGV4dGVu
c2lvbiBoZWFkZXIgdGVzdHM6IFBTUCBkb2Vzbid0IGRlYWwgd2l0aCBJUHY2IGV4dA0KPiA+IGhl
YWRlcnMuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogQ29zbWluIFJhdGl1IDxjcmF0aXVAbnZp
ZGlhLmNvbT4NCj4gPiBSZXZpZXdlZC1ieTogRHJhZ29zIFRhdHVsZWEgPGR0YXR1bGVhQG52aWRp
YS5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogVGFyaXEgVG91a2FuIDx0YXJpcXRAbnZpZGlhLmNv
bT4NCj4gPiAtLS0NCj4gLi4uDQo+ID4gKw0KPiA+ICtAa3NmdF92YXJpYW50cyhfaXBfdmFyaWFu
dHMoKSkNCj4gPiArZGVmIHRlc3RfcHNwX3Zlcl9kaWZmKGNmZywgcHJvdG9jb2wpOg0KPiA+ICvC
oMKgwqAgIiIiRnJhbWVzIGZyb20gdHdvIGRpZmZlcmVudCBQU1AgdmVyc2lvbnMgbXVzdCBub3QN
Cj4gPiBjb2FsZXNjZS4iIiINCj4gPiArwqDCoMKgIGluaXRfcHNwX2RldihjZmcpDQo+ID4gK8Kg
wqDCoCBpZiBsZW4oY2ZnLnBzcF9pbmZvWydwc3AtdmVyc2lvbnMtY2FwJ10pIDwgMjoNCj4gDQo+
IG5pdDogd2hhdCB0aGUgYWJvdmUgY2hlY2tzIGlzIHNsaWdodGx5IGRpZmZlcmVudCB0aGFuIHdo
YXQgdGhlIF9ydW4oKQ0KPiBiZWxvdyB1c2VzLCBlLmcuIGRldiBzdXBwb3J0cyB2ZXJzaW9ucyAw
IGFuZCAyLg0KDQpXaWxsIGRyb3AgdGhpcyBjaGVjay4NCg0KPiANCj4gPiArwqDCoMKgwqDCoMKg
wqAgcmFpc2UgS3NmdFNraXBFeCgiRGV2aWNlIHN1cHBvcnRzIGEgc2luZ2xlIFBTUCB2ZXJzaW9u
IikNCj4gPiArDQo+ID4gK8KgwqDCoCBfcnVuKGNmZywgInBzcF92ZXJfZGlmZiIsIHByb3RvY29s
LCBbMCwgMV0pDQo+ID4gKw0KPiANCj4gY291cGxlIG9mIG1pbm9yIGNvbW1lbnRzOg0KPiANCj4g
UmV2aWV3ZWQtYnk6IERhbmllbCBaYWhrYSA8ZGFuaWVsLnphaGthQGdtYWlsLmNvbT4NCg0KVGhh
bmsgeW91IGZvciB0aGUgcmV2aWV3IQ0KDQpDb3NtaW4uDQo=
