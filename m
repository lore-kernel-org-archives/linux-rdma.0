Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010001.outbound.protection.outlook.com [40.93.198.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CEF49CF29;
	Wed, 23 Sep 2026 10:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790160448; cv=fail; b=mioa7kHqSLDPgnXgtNDgCNphw+hc+xBY2tttJX8ihgdg/+fwKizr6nV2SpQiFDtDa18Vr30sUoXG5483K3Nnc4kt4cJo93N7ELdXgR0ssVpDXJka9PWC1jtzYSPq0+nBi5r66CvVPKO7/EGmyKXY8HfZTSTojh4r/vRIRddAyUo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790160448; c=relaxed/simple;
	bh=tO49cpbACHfTnGc+19UlgKThShO2kK89TzguqNhLDR4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=taAHDYSyGMp/tJQOdTZqk/h0pJQ/7TUC/y/+JNDtITFzGItwQHYaeOtWg/rHlxWQ8MoOVVsHujV0TdkqlAA/KKpT/EzD2G4M+KMdKOeYWl7YCs/cWTaMnlqAKYJNOMiQYWfn2SJPv/XCXvQcK/HHQZm9xnWENSPTrO/57YCASio=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=b+7DMYuu; arc=fail smtp.client-ip=40.93.198.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="b+7DMYuu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j770iMFn2kwEeP1HlVjUBUTwlIyiEZo9tJLokPQnfsE1E+ola4lbplv/uAu6Nu4StBJHWdgH2VB4vM7EXL9WqKvXaeUtrOktxgeiXIssxHpAKex+PcM3MpqAF3WB9B+Qxi8ko8FGrV0NuJE+vRZLYQbYIY2dcAL2StyxMiIQz4ssMtajXhTTmfkezJwFVTdu6g50j4FCDdHOWYQM8oYFJDSGlT3Cvbg/TDR4yQdZrxKpL0tdqmanEQFpKhVhnb+yWKME/Y3BJ7GlvmMSRlTY+7WlEqyt/mzmP8OpyjnqiQnAp3ihKUTJvNqKjZ+4zZOjdFK+c30zQyzVFNSiQ8tkDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tO49cpbACHfTnGc+19UlgKThShO2kK89TzguqNhLDR4=;
 b=Y+/uTxhCF4a2Ut5vfHnSiQYBCuF23CEx9xmVp9utNvry6EImp/1olvMO9S4P4LfSwD7wiekNtKg/7nuwrOBEmRugrAP+JG3vgEHez9vxSANAwecLuDdvCdbhyuqH7N+B9zq5a4vREnBSjNrKGW6b0yzmhGIRHxrU2oKPjbWAI/IO8Wp+ctVFbH7W2TRwCBD/XlkE0946OzNGRBpCdR7zIc4PrnoBisGOMV4//sF+uW+mmTaL2MvJ0Q6ImWJQDZbQx94kVDongwZfX+GGws4OYehBM3K2lM98JOzoY6vxA2Gq8gu8nis+e1L5jAU12FvcS4SEQRze20efXQn+vdNMtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tO49cpbACHfTnGc+19UlgKThShO2kK89TzguqNhLDR4=;
 b=b+7DMYuuHpsK+TndBv5Q3uNFj7vFa+j9URLCIsRhEDU0HF5MHLyHOn7vhE2gdEjTlksSV9yL7swb6ULkUk5ZFMZyYTVfGoc7F3LvfmlTuKU+MYP+4QIu63iuaD1trgYj5D8sdFD8Emlbs5vYQk7DbnitdEpP8yOuhhEdoj+zSp9usMVcC+dKq+Z5Ew8+smHm79ubJesogSRrpG5eZnRzSSyBParxHYGE1OtiVbkbVbr2l8RfgG9mQ3jH+jWFdMaTI4Z8tfUrToEWwH49p3PX+rfAm9AabNfTX8kAZtluIyCnqGjBEWR7aWhZluC2oj20fNQiYtqezva5pIH/rjeBUg==
Received: from DS5PPF266051432.namprd12.prod.outlook.com
 (2603:10b6:f:fc00::648) by CH2PR12MB4039.namprd12.prod.outlook.com
 (2603:10b6:610:a8::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.14; Wed, 23 Sep
 2026 10:47:13 +0000
Received: from DS5PPF266051432.namprd12.prod.outlook.com
 ([fe80::9cef:7e0f:2134:13fe]) by DS5PPF266051432.namprd12.prod.outlook.com
 ([fe80::9cef:7e0f:2134:13fe%3]) with mapi id 15.21.0451.014; Wed, 23 Sep 2026
 10:47:13 +0000
From: Cosmin Ratiu <cratiu@nvidia.com>
To: "andrew+netdev@lunn.ch" <andrew+netdev@lunn.ch>, "davem@davemloft.net"
	<davem@davemloft.net>, Tariq Toukan <tariqt@nvidia.com>, "sd@queasysnail.net"
	<sd@queasysnail.net>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "edumazet@google.com"
	<edumazet@google.com>, "kuba@kernel.org" <kuba@kernel.org>
CC: Boris Pismenny <borisp@nvidia.com>, "daniel.zahka@gmail.com"
	<daniel.zahka@gmail.com>, Emeel Hakim <ehakim@nvidia.com>, "leon@kernel.org"
	<leon@kernel.org>, Jianbo Liu <jianbol@nvidia.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Rahul
 Rameshbabu <rrameshbabu@nvidia.com>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, Roi Dayan <roid@nvidia.com>, Raed Salem
	<raeds@nvidia.com>, Parav Pandit <parav@nvidia.com>, Carolina Jubran
	<cjubran@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>, Mark Bloch
	<mbloch@nvidia.com>, Lior Nahmanson <liorna@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, "steffen.klassert@secunet.com"
	<steffen.klassert@secunet.com>, Gal Pressman <gal@nvidia.com>
Subject: Re: [PATCH net 0/7] net/mlx5e: Fix offload lifetime, cleanup and
 exclusion bugs
Thread-Topic: [PATCH net 0/7] net/mlx5e: Fix offload lifetime, cleanup and
 exclusion bugs
Thread-Index: AQHdRs/SAhhNYd9g2k2V0keVRoXq27bcBCaA
Date: Wed, 23 Sep 2026 10:47:13 +0000
Message-ID: <e19f54d36221cc370bdcda1eaabbae9e54f377aa.camel@nvidia.com>
References: <20260917175433.4090878-1-tariqt@nvidia.com>
In-Reply-To: <20260917175433.4090878-1-tariqt@nvidia.com>
Reply-To: Cosmin Ratiu <cratiu@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS5PPF266051432:EE_|CH2PR12MB4039:EE_
x-ms-office365-filtering-correlation-id: dbdbfbb1-75df-4a39-ca6e-08df196006fb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|56012099006|11063799006|10067099003|18002099003|22082099003|38070700021;
x-microsoft-antispam-message-info:
 ioz+kXv+Ogz0/RxcNvmQzyKWwmqzFgY5eTU8AIZwHFfBfgjOYbCpEu/2ZS3RIR7QbeQXVH7O0S8+00BU5+AlnVh3LyCnsYf7lMaO/1BZBeaOHn0x19Qjjii0YG0tRD74bnl19ERJbMx61og4BMJHxBBev4teJrFhNUEgKtfFvODZSdq4D22p7U13gaaA8//7D8Z4S36bSlOVdshp86vHWFskuUqYRzhX6lNgQDsU7R0+bz0bKPjKOXXTXioGvdzkPHhngU1S7rmRgy3aaJUq0qJrEB8AQAlAMZfhZdGR1pWUOxA2ZoL9GqlrJ5upUeWuFsDcBGN1OYVV5u7416GEKMBjQBjuBDd/2iu3k3jHu7MoHS3gXOghQS0XkWJigP3VY7KqDMegOvtAlA4EGEGNgqB37y4P6+bFIEcszfYYFnsQbWnybyRzPORzlZzykbdVPm2I+R7LEiptkQCBOmegUJAZnEKqD2Ed8p89UPOoHetHYmrYN72WeSE1hXWr66xbp8JQEJ2Fkb5nBydDiBRwjYHWs8Wz0M2qJJcwmFmAQyGexx5ZS7/6vMizklhuZ8dXvVNBXyiJrW6SHb1gMOiiEbvB+g4NWg5WcSw1yKdapCvhS108ze/29Cfoj+/u6FAKLpbbSGth6p2XwEFZgVSboA9E/tzFNgdpsqetu1Q1huzgz8Lu1v5s4Qz+Q/xvsGurDg1FAlSvF7oxUUhzggD90Qs2WlNXEFotU6Vri2KaptQ=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS5PPF266051432.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aS9MczJYNmVnNlI5ZjkrbC84RkhpbTI1RDlDVTBBK1hlUE4rTEw3N1JUK0Fa?=
 =?utf-8?B?a0RUUWJ3OElRY1JWeHE4ZWFVYzJoTS9RWTlYSEo5UkhaM2w2bWZpeDVNM2JH?=
 =?utf-8?B?QVZEYXNFY1lrbjVqTUlsNzZmOGZybFliOFp5d2JVTlEzYkNud1hMRzB4eFZ0?=
 =?utf-8?B?LzRjM1JHUkFyMHVadENQdVpuUWFCMFZrWXUxbzdYZElCUlh5S2RIajN6YUR3?=
 =?utf-8?B?ZS80aVFXWnFxdEJSUzRrbk5ibVdkZDZTdmt2S25sa1U2SGhtSnFqWnBWNGtt?=
 =?utf-8?B?OFZMTkR5U3hUdVpId0oxRnRDejhZOUp4S1RvSndZTUthSTNLZkQzUERRVzB5?=
 =?utf-8?B?MEM5Skh1YmMwWGordkgwekpwN3hXRWEzNmM4NUdYUXROY0tjMDN3aVhxMFZ3?=
 =?utf-8?B?ZWs1R0RVM01vV1RnbFRmaDd6djYwM2FMbWlJengvNnlOYXZlbEFRTTg2QU9o?=
 =?utf-8?B?blRGQWdmQlNVWGd6WGxNdzFEb0ZoL25vb2lmcW9rVTFHcWkzMzZkVzR0Nkkw?=
 =?utf-8?B?VGtzOVl0YW9Wc2NnUllZTUtHdGFjK2hnbkNwclNwNEVqTkZleXcxK2RoQ2Y3?=
 =?utf-8?B?UDdIdVZsUG5ZUnl4aFphS1czc1RRVUt4WWV3ZzROQUUzYnFsckpHRTR4azVq?=
 =?utf-8?B?NWd5ZHJHRnhic0tkRGxFeERwamtSTlpVenZxN2N6VGFKbnpNRXd0MWpCZTBH?=
 =?utf-8?B?aUptVFBJTFIvRE5ERURZVlNDVTNJMVdpdDhmaDR3akI2RzVPNW9PTlcza2Qy?=
 =?utf-8?B?TG9TODh5SHFRT2g1eS80RCtXeEV6QUhmeW5QTUFwbzd6OG9MK1hYWm9DWDd5?=
 =?utf-8?B?VlpHZ2tidi9uTzJpSkhhZ0RGdnZmSXFQQmlmV0k2TGhWMGwxZktJZ2JOUDF6?=
 =?utf-8?B?TElUZ1VzZjJtbXlQT3lpdENYQlpEUXFZbHVZTWkrYmcvTEptTlRKbVNxL1RD?=
 =?utf-8?B?RmxWZit5Rk94WU52RzVETEhKcnI1R2laa1NrdG9HOTlUeDZPU1oxekJiUmhX?=
 =?utf-8?B?UEFsMHVLdzMrQ2lmOURXZW1pek1PN3hzSjAxb2xxOFhFRFVGdHNIUE1OdDJM?=
 =?utf-8?B?ZHVOWGlyMHpiUEJRdm5Fc09KQndaRCtON1lMM2daZURZc0ZQdzFKVFNUeGEy?=
 =?utf-8?B?aWZyYVR5bno4Tm9nNnhja1l6amJLYzdPQzd3Q05aL0hvMjJQYlZycG14OU9K?=
 =?utf-8?B?ckNyZDU4bkFUdm10SXVRbEhvRkl6OE1SMWxJZWMrTHFhNkpCd2tQcVNqYmxx?=
 =?utf-8?B?UExWRlBWTzNYTlYvMzJPQ0I3MUI3VTA5Y3VZK25FUlk3RzFxQzRGSVNXd2V0?=
 =?utf-8?B?RE53VThyWGMwZW9ndG1xN0JudDZ3ejlnTlpxaG5mMENOVFVtbkxlRitEMlJX?=
 =?utf-8?B?YlI0dnRaU1ZWY3BndWlJOUFNcmpUMEZQZmk0bisrYzg0NWgyZXl0a29BMFVz?=
 =?utf-8?B?TjZzdzVkZitya2d5NFppc3dSSmx1dHc3ZVlWVGJwNFk5UXdiU2Zhd0lrRUJw?=
 =?utf-8?B?UFJ5NnZhOUg5Tmp4cTZPMDlId0hDbEJvUWNtaEtYYnpHc1lUcXovdXg0UlYz?=
 =?utf-8?B?NS8yZlVuZUxEU01HTkFRazhMcEVHaXdhcmpBcDZvNEtYSTVxY2ZnZHgvWTd2?=
 =?utf-8?B?TWpSVmUzeW9aUUt1TXlEMlRDMkJPZ05EQ3N0K3ZocUE5aVBJWEUrLzE1WW5j?=
 =?utf-8?B?UmF0anB3dXpqSXdUVkNhNTZXYWFoaUl0Tm1TSDhJeUF5M0MzVmxpRUo1elZ6?=
 =?utf-8?B?bldPcTFocC9HbXNDaUozVVJLRlZaOHd3T2Z5R3dlTGdqOGYvRWFQZTJqdjlS?=
 =?utf-8?B?ZFNRRS9jSG1wdjZzd2wwVjY0NFhwTmI5MG9xbmhKOWxTVUE0ekNOT0JTdmJ3?=
 =?utf-8?B?V0Zxdzg2SWI5Vk9XK0VzckFsUDJraUxGenVFOXlxSFc1ZDFpUDdNOVhzcXYx?=
 =?utf-8?B?QjNDc0pyWVJVbkpIYnM3cC9sU2Z5RTBMcjV0djFjbFc0dXlobk9PTS9yUFJY?=
 =?utf-8?B?di9ueEJROXQ3T29YbWRFUXFHeWhFVjVaSUxxSHlnOHFXWS9HWnFyL3ZheEZn?=
 =?utf-8?B?Zkg4d01yOWNDQXB3b2Z3WXV4dlFZeTVlK3FlMHYxVnhRQlNhRUN2Z3BQMEt2?=
 =?utf-8?B?VEVYK1lMVWNkSDNuK3l1TXBKUTZZNW9EbzRRUEFUYXBrWExhOURWQW1Kb0pn?=
 =?utf-8?B?d0NqOU9lcytuY05OdG0vdnpwanEwaGRQSzk3Zm5UVkp6bGVFN3MrcVF5V1l1?=
 =?utf-8?B?d1U0ZldEdU9HQ05VZ2FDZjBqbFhBelgya1Rtei9jSmtBekRNWnN1ZE9mWnJU?=
 =?utf-8?B?R1Z6Ky92THFmNVQ0a2h5bzVieHUzbEd3dWxLVkFkTThYQ1RWMmtidz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <62C63BE45D408747B9AA7496C1136AA4@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: dbdbfbb1-75df-4a39-ca6e-08df196006fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2026 10:47:13.4262
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M7/ppm391aVBFZhI+CeolFRyX3ql7jmDxrYGYKAmVsaEhoMDLvLBwvP91onKI18kXGoMH4w4gdHADuRNWoJklw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4039

T24gVGh1LCAyMDI2LTA5LTE3IGF0IDIwOjU0ICswMzAwLCBUYXJpcSBUb3VrYW4gd3JvdGU6DQo+
IEhpLA0KPiANCj4gVGhpcyBzZXJpZXMgYnkgQ29zbWluIGZpeGVzIHNldmVyYWwgbWx4NWUgb2Zm
bG9hZCBpc3N1ZXM6DQo+IA0KPiAtIEJsb2NrIGVzd2l0Y2ggbW9kZSBjaGFuZ2VzIGJlZm9yZSBh
Y2Nlc3NpbmcgdGhlIElQc2VjIGNvbnRleHQNCj4gZHVyaW5nDQo+IMKgIHBvbGljeSBhbmQgU0Eg
Y3JlYXRpb24uDQo+IC0gVGllIFRDIGVzd2l0Y2ggYW5kIElQc2VjLWJsb2NraW5nIHJlZmVyZW5j
ZXMgdG8gZmxvdyBkZXN0cnVjdGlvbiwNCj4gwqAgY292ZXJpbmcgYnVsayBjbGVhbnVwIGFuZCBm
bG93cyB3aXRoIG91dHN0YW5kaW5nIHJlZmVyZW5jZXMuDQo+IC0gVHJhY2sgTUFDc2VjIGhhcmR3
YXJlLW9iamVjdCBvd25lcnNoaXAgZXhwbGljaXRseSBhbmQgZGVsZXRlDQo+IHJlbWFpbmluZw0K
PiDCoCBTZWNZcyBkdXJpbmcgZHJpdmVyIGNsZWFudXAuDQo+IC0gU2VyaWFsaXplIFRDL0lQc2Vj
IGV4Y2x1c2lvbiBjb3VudGVycyB3aXRoIGEgZGVkaWNhdGVkIG11dGV4Lg0KPiAtIFByZXZlbnQg
U0hBTVBPIGZyb20gbWVyZ2luZyBQU1AgcGFja2V0cy4NCj4gDQo+IFJlZ2FyZHMsDQo+IFRhcmlx
DQo+IA0KPiBDb3NtaW4gUmF0aXUgKDcpOg0KPiDCoCBuZXQvbWx4NWU6IGlwc2VjOiBCbG9jayBl
c3dpdGNoIG1vZGUgY2hhbmdlcyBkdXJpbmcgcG9saWN5IGNyZWF0aW9uDQo+IMKgIG5ldC9tbHg1
ZTogaXBzZWM6IEJsb2NrIGVzd2l0Y2ggbW9kZSBjaGFuZ2VzIGJlZm9yZSBhY2Nlc3NpbmcNCj4g
wqDCoMKgIHByaXYtPmlwc2VjDQo+IMKgIG5ldC9tbHg1ZTogdGM6IFRpZSBlc3cgJiBhY2NlbCBi
bG9ja2luZyByZWZzIHRvIHRoZSBmbG93J3MgbGlmZXRpbWUNCj4gwqAgbmV0L21seDVlOiBtYWNz
ZWM6IFRyYWNrIGhhcmR3YXJlIG9iamVjdCBvd25lcnNoaXAgZm9yIFNBIHRlYXJkb3duDQo+IMKg
IG5ldC9tbHg1ZTogbWFjc2VjOiBEZWxldGUgcmVtYWluaW5nIFNlY1lzIGR1cmluZyBjbGVhbnVw
DQo+IMKgIG5ldC9tbHg1ZTogU2VyaWFsaXplIFRDIGFuZCBJUHNlYyBvZmZsb2FkIGV4Y2x1c2lv
biBjb3VudGVycw0KPiDCoCBuZXQvbWx4NWU6IHNoYW1wbzogRG8gbm90IG1lcmdlIFBTUCBwYWNr
ZXRzDQo+IA0KPiDCoC4uLi9tZWxsYW5veC9tbHg1L2NvcmUvZW5fYWNjZWwvaXBzZWMuY8KgwqDC
oMKgwqDCoCB8IDU1ICsrKysrKysrKysrLS0tLS0NCj4gwqAuLi4vbWVsbGFub3gvbWx4NS9jb3Jl
L2VuX2FjY2VsL2lwc2VjX2ZzLmPCoMKgwqAgfCA0NyArKysrLS0tLS0tLS0tDQo+IMKgLi4uL21l
bGxhbm94L21seDUvY29yZS9lbl9hY2NlbC9tYWNzZWMuY8KgwqDCoMKgwqAgfCA2MCArKysrKysr
KysrKy0tLS0tLQ0KPiDCoC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3J4
LmPCoMKgIHwgMTUgKysrKy0NCj4gwqAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9lbl90Yy5jwqDCoCB8IDY2ICsrKysrKysrKysrKy0tLS0tDQo+IC0tDQo+IMKgLi4uL25ldC9l
dGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaC5jIHwgMjMgKystLS0tLQ0KPiDCoC4u
Li9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2guaCB8IDExICsrLS0NCj4g
wqAuLi4vbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2hfb2ZmbG9hZHMuY8KgwqDCoMKgIHzCoCA3
ICstDQo+IMKgLi4uL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbWFpbi5jwqDCoMKg
IHzCoCAzICsNCj4gwqBpbmNsdWRlL2xpbnV4L21seDUvZHJpdmVyLmjCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgIDcgKy0NCj4gwqAxMCBmaWxlcyBjaGFuZ2VkLCAxNzIg
aW5zZXJ0aW9ucygrKSwgMTIyIGRlbGV0aW9ucygtKQ0KPiANCj4gDQo+IGJhc2UtY29tbWl0OiBj
OTE1MTA4OGYxNjc0ZmQyOWZmMjZhMjBmNWZjNjg3YWNmNTNhMmYwDQoNCnB3LWJvdDogY3INCg==
