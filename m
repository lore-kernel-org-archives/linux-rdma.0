Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012033.outbound.protection.outlook.com [40.107.209.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2784C9574;
	Tue, 14 Jul 2026 20:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784059552; cv=fail; b=fNF1gq3TqRadi1AAEfzJFj/GV2qesM0bEhVBGgMRFSabYvxUc5BBaJ7vKmdEKztR4BRlafoxQdqJ15I3hUQzkvjMlAP7SCvvgXm3h0K+igOgJ++eNXDJjSP5BudY4irSei6CQTvQ8ngHI8tuD2GCG64agBmjQdhaI4z3mPXWUkQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784059552; c=relaxed/simple;
	bh=6jNgun+lzyf+3aJNiWzwkMNlDsyOGb21mrGYeckZo18=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=O5XeSMfHBgqx/H7KPwuMfoX/aE0u/Wrv1Td/ySK9Nmo3jldbroXN9H8L/GjimFR/LW8kBMecB2U8NyTcYf+CMSUpfQ32IG/PHbJ2KRM8bF12+cmUDzzxJHnU6asuSRmS+Ms6HrY8iK37s2L2fzk+aP+FFAPt6FlxDm9hafgPE/I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=as0EVYch; arc=fail smtp.client-ip=40.107.209.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="as0EVYch"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SSBVnFZRnuhg4EK3FP8GczHLIoHTqavnXCSQkDXwqkFKfjO4fWw5Cum//i+dJ5AQNJ9hIYYTHpI/YIdbokWxtsFqaIuhMSAwRKGenD3VbZ/8L4fj9qyNPNDW61keGzvUswIKIv0pGmKYh8HaiT464DMvZBS3OEljVDN1Bjm/1PNbKqJj2s3xivd94B3WF0/3r7aVJjpFAI5hTwKZJUT5oWGlVeeIsqVROvz8F/xOh6wcOIZLokRqNXY2/ieMBFulGVzvnhXyXxRjTCG0bldQm00dMK3t3OZzWsZDYNlUvND2bZhvkbkUBeloRgPtlb1MqMQMN4FdeDeZP3bhiVmWmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6jNgun+lzyf+3aJNiWzwkMNlDsyOGb21mrGYeckZo18=;
 b=ONBZMFzFh2f3pVIY+dNqvZOR/2U+Yp0vLAtaYoRdQBGvgw4TjagjO+XnNe4hmj3923to1SMD3JMQ06AvU2eFcb+F1hj1LW96H7lufgBCqlm06uR87UBHLuVCeSuo35AsCGLeH05P3V8pq+4vAJBxYT8ddEKhvSL39QvdYrBShsA3YWPXsBpUvtElN7P/EIF5LvFhQMOyehhmsp/SpBLOeadeBeB4IB4OPpq9KO2/hNw1aqBs4wXyiAy5T2g5Y7zOsZO3vxlJRr015753CQHlMsvE5tMrWuOevqAh77Pw7pB0me61wtCxagaAZ/4+RgmC1I4Fut7oSngFG7iU0ZRccg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6jNgun+lzyf+3aJNiWzwkMNlDsyOGb21mrGYeckZo18=;
 b=as0EVYch34SXos7Bvqs7ECx2JrDhKDmCb3GkPESJBuGfjRmYbYXSD0+lsYXOxMMQo8/+uFr1LsBZ3sVCeMzGQoDGgdzBEYBd6hfaRXgFgMNEc9/UovaTb0++0RLyT3RRRkdAsdwFxp2ieJEa00/h5FzZ/TVjhmIWnuyahaL1KOnOIiYy8KlWjjzj5G/ZXdMvSe3CfUWOWnc6Fm1NIM7tNj/vjlw4Wd4cH/jOD7nQZcFMohwfdXPG4qneJn27aHmVV2QTms84zqEV+FVnjYMdh7ENM6I2D2l3BQW6utpKjbcmOVx0g7G0M/1djWQVjr28oYPXMifB+sHVe4lCd/wbuA==
Received: from DS5PPF266051432.namprd12.prod.outlook.com
 (2603:10b6:f:fc00::648) by DM4PR12MB6542.namprd12.prod.outlook.com
 (2603:10b6:8:89::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.10; Tue, 14 Jul
 2026 20:05:40 +0000
Received: from DS5PPF266051432.namprd12.prod.outlook.com
 ([fe80::d512:9f9:1c70:e24e]) by DS5PPF266051432.namprd12.prod.outlook.com
 ([fe80::d512:9f9:1c70:e24e%5]) with mapi id 15.21.0202.014; Tue, 14 Jul 2026
 20:05:40 +0000
From: Cosmin Ratiu <cratiu@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>, "horms@kernel.org" <horms@kernel.org>
CC: Rahul Rameshbabu <rrameshbabu@nvidia.com>, Boris Pismenny
	<borisp@nvidia.com>, "willemdebruijn.kernel@gmail.com"
	<willemdebruijn.kernel@gmail.com>, "andrew+netdev@lunn.ch"
	<andrew+netdev@lunn.ch>, "daniel.zahka@gmail.com" <daniel.zahka@gmail.com>,
	Jianbo Liu <jianbol@nvidia.com>, "davem@davemloft.net" <davem@davemloft.net>,
	"leon@kernel.org" <leon@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"edumazet@google.com" <edumazet@google.com>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, Raed Salem <raeds@nvidia.com>, Chris Mi
	<cmi@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>,
	"sdf.kernel@gmail.com" <sdf.kernel@gmail.com>, "kuba@kernel.org"
	<kuba@kernel.org>, Mark Bloch <mbloch@nvidia.com>, "sdf@fomichev.me"
	<sdf@fomichev.me>, Saeed Mahameed <saeedm@nvidia.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"aleksandr.loktionov@intel.com" <aleksandr.loktionov@intel.com>, Gal Pressman
	<gal@nvidia.com>, Lama Kayal <lkayal@nvidia.com>, "jacob.e.keller@intel.com"
	<jacob.e.keller@intel.com>
Subject: Re: [PATCH net-next 13/15] net/mlx5e: psp: Make PSP steering config
 dynamic
Thread-Topic: [PATCH net-next 13/15] net/mlx5e: psp: Make PSP steering config
 dynamic
Thread-Index: AQHdDhI/zMnV42hJZ0eSjqOqd1u2tLZtUL+AgAArX4A=
Date: Tue, 14 Jul 2026 20:05:39 +0000
Message-ID: <a7f3a36f058d7ee1298c8f3f5d5c65c1aa7863b6.camel@nvidia.com>
References: <20260707130858.969928-14-tariqt@nvidia.com>
	 <20260714173021.1862773-1-horms@kernel.org>
In-Reply-To: <20260714173021.1862773-1-horms@kernel.org>
Reply-To: Cosmin Ratiu <cratiu@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS5PPF266051432:EE_|DM4PR12MB6542:EE_
x-ms-office365-filtering-correlation-id: f73c8534-94ba-4e3d-d40f-08dee1e3473a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|18002099003|22082099003|38070700021|6133799003|4143699003|56012099006|11063799006|5023799004;
x-microsoft-antispam-message-info:
 zXV0gCFIxiw1+JGrtGZSjFB7eMCnKigGK8Sxo64LCm9ZLP9PmnUGc7EvUTx6QlUWVyYpvlza3uENvkEaWFMlpCVVHR6DmKnMuKzpG3V9dd+YQf5XDZZR0L1SLfQJFptHSiboe8vuqT4MctIL714ULSY1b9TQwdEgGMDsgbhtlDVMTB4LwA8L6zCoQRqtHaX2E7wJd2SclcvQgs2m1BUXGFJuRfKYAmxfU2JMbrM+4MfAnefLH8zT6YvZVSV6I3NnpRDHN5KVmmFoRtTAywzX7Upi7eE2CvyKrQYJYXaLqO3Q+sI8Y+JJLoOP48KmxeUtNFuPRUPoDFYHU2oS0feSF4ow6q+NL4pdonrUesTz03pEsVZwuv4FBGZQnypCE/U7El7lL/x97A1gesJO6d5FQ+JU4KSLrhKzaQbvJAbChhtoYmv//DX2DlGfBGYyOC6tJ6pxPvMMEkZ0mzVCozBrWsoQ6ApWcX7ZOsF+vJhz+nzoAFKABSJUiV2cNR1NTp89j1poIcUY+CMoR36tdK9b+dBKtXxItysB2TPR+aYSJP72p+le0dDDUCdLvBY91cU3kX8s//ldoLfDbZUQ+ECj/EAhUp/51Gg0o+0Ogg6kf4tPkb0r/l6q7wTQa0LTmWbubdz24nGzt1Ws4gt4dQVZ2I5mOrKQgErIeMfnJnCIc3vmvfi59RTlaB7peyMa5bs+SQUYxO2KhMRc3BkEPg3XcjOB+dhJgPn6OkU9GstSyVs=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS5PPF266051432.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(18002099003)(22082099003)(38070700021)(6133799003)(4143699003)(56012099006)(11063799006)(5023799004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dFB1ZWJmS2NROE5QQkplODlYOTFEVFlmUjRQRFVrb1lYQ1Z5QUsxZFN5T1dV?=
 =?utf-8?B?UG5QakpoRmtiTmdLQ1ZFNVE4d0Z0clJHNFEyNnN4T0g0aGV3ODIyOGtIUXRn?=
 =?utf-8?B?eU9YcWRyc0JJWXBldWFqOUJGcEZCOTlPZll0UGdIa2J1WmlWV2lRUDNOeCtW?=
 =?utf-8?B?ZHc2MDNIVHoreDJnM1JhL3RLTWZqVFR4ZWY1NDV0VFJpUmQrTFMrSzBiWXMr?=
 =?utf-8?B?S3p1VFlTVHNiR05uQ1BlT3d6aU5Oa0NQQ1BEeVMvb2x1eElrSjlzR3ZaZm1X?=
 =?utf-8?B?NnUya0xRaUxVSEhvY3EzbVRyY3ZMWHBpeG9yYTBKVlNoY2s2UHBNV29jUlFn?=
 =?utf-8?B?aWNGZTFwMU9VZkZ4eVI0WU1CYnhZVVgzYmFhZ0RXY0N6LzBIaS9rMlBLZEtU?=
 =?utf-8?B?M2NHUEZTL3hXK3MyVm5BNjlaZy9oRWVwU28vWjd5dXVGazRKRXMyT3lJU0ZU?=
 =?utf-8?B?UC9FM1owUk4xVGdzRnIxRHY1TzFmSW02SEtVN3Vqb21Za1BtTVI5Snl2VmQ5?=
 =?utf-8?B?bHJpb1pNeVlQOW1TdXN3OWhZTE1RTnV2SnhBNDFMNDJJSzhQUEowWGp0b2Ux?=
 =?utf-8?B?TmpIaWUwb0cxK0x3VEphK3BranBpdFhjNkp6VG9vVlhjYUl2MmxWU0FYcHpv?=
 =?utf-8?B?eHE0VUNxeEV0TDdIZ1dlSmFuSWxCY2pQUWdidHhKYy96NFV0SXByU2lFU3Bi?=
 =?utf-8?B?VUhQUEVuUUVUYU5BNDUvVFNLSWphbmEvc0gxbmszdUNlN0QvWXpsbmQwcS9B?=
 =?utf-8?B?eG5iTWJNeGZwcTBXUFBWV2xHclNva3BIWHlVVXZJY1NWQ2dsUys3K1NEVnRl?=
 =?utf-8?B?VFdqRnJpbmpYU0pvMVhUTERyZmhVRHdrWnF4VjJGWmxQSEdaSnRSSTF6bElT?=
 =?utf-8?B?ckFKdDgxb3o0L3o5L1ZpdXFZSkpOV21sYVdUcnRkZFFXZ1d0SWRMOFhlRXB2?=
 =?utf-8?B?bDQ1YVRxcmYrMXo3UlRPQlBnTEdKMUFyT2FwcVZmVXVuR3cvZGtHb1NkUUVw?=
 =?utf-8?B?NGdSd1FhVmtLbWdpbDNmbTZKU2hNcnYzT0tmTWtxc1d4V1g5Q09TNUdjVU53?=
 =?utf-8?B?K3IzTFN1ZEdQRlZabU1zSEpJVFlzVStFME8zZVlIbzlpcUQ2bUZiU0NVZC9H?=
 =?utf-8?B?VWUwcmlRNFNHbE1sYmRKSml3QUNWbjA1NGhyUjRjN2wzaVBrMll0Q051bm9E?=
 =?utf-8?B?UVBNSDVNT29JQWt4ZW95WEwvTnkyUzZnMXJmTGtqRGFxbnF0M01wdmZRTTR3?=
 =?utf-8?B?NlBiR3pXYW5HamFhUTc5Vll2bVZ0L0VReG1aVVYxTUtYUzZzNHZZNTR2UXpO?=
 =?utf-8?B?Y3NiVmc0RDNyN0lYa3REem5NTFd4TzhjYmJXWlEzWGtPRzBlNlJpNTFLS2VV?=
 =?utf-8?B?QUkySGtVMGNxNmVpVy9lRVNaOFBHY0pTUWVkSndHRWp1RDByTmpMWTdVWmJa?=
 =?utf-8?B?UnFaNEhmS0Y5bGxVTlFsMVVjdDZlWm1rWmREQXI5Y3NKZjd0V0tJUVczak9a?=
 =?utf-8?B?ZXo1YzJRNFpFSUwvWjhpRHdKc05PRVRzQnZhWEFPUDRvb2gydU5oblNhRk5o?=
 =?utf-8?B?cnNuc0lwTWVuTWloTHVFUFJzaklNVUE3YnFXL1BKVVdqK3psWDM2cUpwYWZL?=
 =?utf-8?B?RVQyVWxNcElvalNIZzFNTm9vM21vZ1F3bUtwcVAwMzZRaDZDNkRTQThZVTA2?=
 =?utf-8?B?SDgyK2dyR2phWWRsMHBWZS9XaGN1aEhtQ0dYNmZDeEJyb24wdUw1QXdEeU1p?=
 =?utf-8?B?QlNLTUlIRWNFMDQzWmZ2L0wrRWRXS1V5bzFKbDQrQ3BjbHVPeE9SQnJDenRS?=
 =?utf-8?B?R0ZveE9Fa0FnVCtPSllSRjFnT0ZadFIza1BMZ1JOcVBOQ1o2L1R6SjB6bnVN?=
 =?utf-8?B?Zi9VY0lzLzNLamNKUkh1cXZsalBvdFdzaHFycWdyZk5MMkEwREtzSHZXQjFx?=
 =?utf-8?B?ZzQycC9ucFBCUjNUNkFPSENtZGxPNG9QeGdYWlJYMWhmRVMwZmVYVXFyaGFn?=
 =?utf-8?B?UEkrTGYxUWFoVllYeVVPemtRKzNoTWRpanptVm1sNXN5OXJpRHllL3oxeU5z?=
 =?utf-8?B?M2dtcUM1Um9kcXhBZmROdHdtOXpsbFlNY3BnejkxNUpjNXNHT2QyTGozbGNU?=
 =?utf-8?B?eXBHbWVWdU1sQUhhcExXK2pVcDlRYldNemZMNGlkOTRTNWFTZWZrTWZJSHZH?=
 =?utf-8?B?VUZ0YWg4Y2E4Q05FRFVQSWFYeWtSNFhVR1pBVVFYSlZPUmhhdUdxVkhwUm5Z?=
 =?utf-8?B?N2NpZW9nUi91NklXVVBvdzFEVUhFVTMyUnhYT2RQbXhKclB3Q0U4d1dWc25D?=
 =?utf-8?B?VlVYSEpRN0xMMGs1ZHUwNlFMWTJWR2g0ZjBnR0tMdUkxM1VSZWhHZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3AABCC4467651740A472D4BF7B267A34@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f73c8534-94ba-4e3d-d40f-08dee1e3473a
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2026 20:05:40.0899
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wbJE0NVhHQTDBSqg5Fjy9rph9ixyi7sfy+INUAG3iN5FmWaEcIo9gq9lJUw6jf3Rh+vVlCX2H8MFbot6nwMEJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6542

T24gVHVlLCAyMDI2LTA3LTE0IGF0IDE4OjMwICswMTAwLCBTaW1vbiBIb3JtYW4gd3JvdGU6DQo+
IFRoaXMgaXMgYW4gQUktZ2VuZXJhdGVkIHJldmlldyBvZiB5b3VyIHBhdGNoLiBUaGUgaHVtYW4g
c2VuZGluZyB0aGlzDQo+IGVtYWlsIGhhcyBjb25zaWRlcmVkIHRoZSBBSSByZXZpZXcgdmFsaWQs
IG9yIGF0IGxlYXN0IHBsYXVzaWJsZS4NCj4gRnVsbCByZXZpZXcgYXQ6IGh0dHBzOi8vc2FzaGlr
by5kZXYNCj4gLS0tDQo+IC0tLSBQYXRjaCBbMTNdOiBbUEFUQ0ggbmV0LW5leHQgMTMvMTVdIG5l
dC9tbHg1ZTogcHNwOiBNYWtlIFBTUA0KPiBzdGVlcmluZyBjb25maWcgZHluYW1pYyAtLS0NCj4g
Y29tbWl0IDEzM2Q5YTMyY2JmOWMxYjkzOWFlNGNhODQ3M2M0MTYyNGMzMTM5NTENCj4gQXV0aG9y
OiBDb3NtaW4gUmF0aXUgPGNyYXRpdUBudmlkaWEuY29tPg0KPiANCj4gbmV0L21seDVlOiBwc3A6
IE1ha2UgUFNQIHN0ZWVyaW5nIGNvbmZpZyBkeW5hbWljDQo+IA0KPiBUaGlzIGNvbW1pdCBjaGFu
Z2VzIFBTUCBzdGVlcmluZyB0YWJsZXMgdG8gb25seSBiZSBjcmVhdGVkIHdoZW4gUFNQDQo+IGNv
bmZpZ3VyYXRpb24gaXMgZW5hYmxlZCBvbiBhIGRldmljZSwgaW5zdGVhZCBvZiBhdCBkZXZpY2UN
Cj4gaW5pdGlhbGl6YXRpb24NCj4gdGltZS4gVGhpcyBhdm9pZHMgaW1wb3Npbmcgc3RlZXJpbmcg
b3ZlcmhlYWQgb24gYWxsIFVEUCBwYWNrZXRzIHdoZW4NCj4gUFNQDQo+IGlzIG5vdCBiZWluZyB1
c2VkLg0KPiANCj4gPiBkaWZmIC0tZ2l0DQo+ID4gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxs
YW5veC9tbHg1L2NvcmUvZW5fYWNjZWwvZW5fYWNjZWwuaA0KPiA+IGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX2FjY2VsL2VuX2FjY2VsLmgNCj4gPiBpbmRleCBi
NTI2YjM4OThjMjJlLi4zZjIxMmU0NmZjMmY5IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0
L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9hY2NlbC9lbl9hY2NlbC5oDQo+ID4gKysr
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX2FjY2VsL2VuX2Fj
Y2VsLmgNCj4gPiBAQCAtMjIwLDE4ICsyMjAsNyBAQCBzdGF0aWMgaW5saW5lIHZvaWQNCj4gPiBt
bHg1ZV9hY2NlbF90eF9maW5pc2goc3RydWN0IG1seDVlX3R4cXNxICpzcSwNCj4gPiDCoA0KPiA+
IMKgc3RhdGljIGlubGluZSBpbnQgbWx4NWVfYWNjZWxfaW5pdF9yeChzdHJ1Y3QgbWx4NWVfcHJp
diAqcHJpdikNCj4gPiDCoHsNCj4gPiAtCWludCBlcnI7DQo+ID4gLQ0KPiA+IC0JZXJyID0gbWx4
NV9hY2NlbF9wc3BfZnNfaW5pdF9yeF90YWJsZXMocHJpdik7DQo+ID4gLQlpZiAoZXJyKQ0KPiA+
IC0JCWdvdG8gb3V0Ow0KPiA+IC0NCj4gPiAtCWVyciA9IG1seDVlX2t0bHNfaW5pdF9yeChwcml2
KTsNCj4gPiAtCWlmIChlcnIpDQo+ID4gLQkJbWx4NV9hY2NlbF9wc3BfZnNfY2xlYW51cF9yeF90
YWJsZXMocHJpdik7DQo+ID4gLQ0KPiA+IC1vdXQ6DQo+ID4gLQlyZXR1cm4gZXJyOw0KPiA+ICsJ
cmV0dXJuIG1seDVlX2t0bHNfaW5pdF9yeChwcml2KTsNCj4gPiDCoH0NCj4gPiDCoA0KPiA+IMKg
c3RhdGljIGlubGluZSB2b2lkIG1seDVlX2FjY2VsX2NsZWFudXBfcngoc3RydWN0IG1seDVlX3By
aXYgKnByaXYpDQo+ID4gQEAgLTI0MiwxMiArMjMxLDYgQEAgc3RhdGljIGlubGluZSB2b2lkDQo+
ID4gbWx4NWVfYWNjZWxfY2xlYW51cF9yeChzdHJ1Y3QgbWx4NWVfcHJpdiAqcHJpdikNCj4gPiDC
oA0KPiA+IMKgc3RhdGljIGlubGluZSBpbnQgbWx4NWVfYWNjZWxfaW5pdF90eChzdHJ1Y3QgbWx4
NWVfcHJpdiAqcHJpdikNCj4gPiDCoHsNCj4gPiAtCWludCBlcnI7DQo+ID4gLQ0KPiA+IC0JZXJy
ID0gbWx4NV9hY2NlbF9wc3BfZnNfaW5pdF90eF90YWJsZXMocHJpdik7DQo+ID4gLQlpZiAoZXJy
KQ0KPiA+IC0JCXJldHVybiBlcnI7DQo+ID4gLQ0KPiA+IMKgCXJldHVybiBtbHg1ZV9rdGxzX2lu
aXRfdHgocHJpdik7DQo+ID4gwqB9DQo+IA0KPiBbU2V2ZXJpdHk6IENyaXRpY2FsXQ0KPiBEb2Vz
IHJlbW92aW5nIHRoZSB1bmNvbmRpdGlvbmFsIHRhYmxlIGNyZWF0aW9uIGhlcmUgcHJldmVudCBQ
U1ANCj4gdGFibGVzDQo+IGZyb20gYmVpbmcgcmVzdG9yZWQgb24gZGV2aWNlIGF0dGFjaCBvciBy
ZXN1bWU/DQo+IA0KPiBTaW5jZSBtbHg1X2FjY2VsX3BzcF9mc19jbGVhbnVwX3R4X3RhYmxlcygp
IGlzIHN0aWxsIGNhbGxlZCBkdXJpbmcNCj4gZGV2aWNlDQo+IGRldGFjaCBvciBzdXNwZW5kLCB0
aGUgUFNQIHN0ZWVyaW5nIHRhYmxlcyBhcmUgZGVzdHJveWVkLiBIb3dldmVyLA0KPiBiZWNhdXNl
DQo+IG1seDVlX2FjY2VsX2luaXRfdHgoKSBubyBsb25nZXIgcmVjcmVhdGVzIHRoZW0sIHRoZSB0
YWJsZXMgYXBwZWFyIHRvDQo+IHJlbWFpbg0KPiBtaXNzaW5nIGFmdGVyIGEgc3VzcGVuZC9yZXN1
bWUgb3IgZGV0YWNoL2F0dGFjaCBjeWNsZS4NCj4gDQo+IEJlY2F1c2Ugc29mdHdhcmUgcHNwX2Fz
c29jIHN0cnVjdHVyZXMgcmVtYWluIGJvdW5kIHRvIGFjdGl2ZSBzb2NrZXRzLA0KPiBjb3VsZA0K
PiB0aGlzIGxlYXZlIHRoZSBkZXZpY2UgaW4gYSBzdGF0ZSB3aGVyZSB0aGUgaGFyZHdhcmUgVFgg
c3RlZXJpbmcgdGFibGUNCj4gKHdoaWNoDQo+IGNvbnRhaW5zIHRoZSBDUllQVE9fRU5DUllQVCBh
Y3Rpb24pIGlzIG1pc3Npbmc/DQo+IA0KPiBJZiBzbywgd291bGQgdGhpcyBjYXVzZSBlZ3Jlc3Mg
dHJhZmZpYyB0byBieXBhc3MgZW5jcnlwdGlvbiBhbmQgYmUNCj4gdHJhbnNtaXR0ZWQgaW4gcGxh
aW50ZXh0Pw0KDQpXaGVuIHRoZSBkZXZpY2UgaXMgc3VzcGVuZGVkLCAxLiBhbGwgVFgga2V5cyBh
cmUgcmVsZWFzZWQgYW5kIDIuDQpzdGVlcmluZyBydWxlcyBhcmUgcmVtb3ZlZC4gMy4gcHNwIHN0
YXRlIGlzIGNvbXBsZXRlbHkgZnJlZWQsIGluY2x1ZGluZw0KdGhlIGNvbmZpZ3VyYXRpb24gaW50
ZW50aW9uLg0KDQpXaGVuIHRoZSBkZXZpY2UgaXMgcmVzdW1lZCwgcHNwIGlzIHJlaW5pdGlhbGl6
ZWQgdG8gYSBibGFuayBzdGF0ZS4NCg0KQmVmb3JlIHRoZXNlIGNoYW5nZXMsIHBzcCB3YXMgYWxz
byByZXNldCB0byBhIGJsYW5rIHN0YXRlIChubyBrZXlzLCBidXQNCndpdGggc3RlZXJpbmcgcnVs
ZXMgcmVhZGRlZCkuIFRoaXMgYWxzbyBicm9rZSBleGlzdGluZyBQU1AgY29ubmVjdGlvbnMuDQoN
CkkgZ3Vlc3MgZml4aW5nIHRoaXMgYmVoYXZpb3IgZHVyaW5nIHN1c3BlbmQgaXMgb3V0c2lkZSB0
aGUgc2NvcGUgb2YNCnRoaXMgc2VyaWVzLiBJIGRvbid0IGxpa2UgaXQsIHdlIHNob3VsZCBkbyBz
b21ldGhpbmcgYWJvdXQgaXQsIGJ1dCBub3QNCmluIHRoaXMgc2VyaWVzLg0KDQpDb3NtaW4uDQo=
