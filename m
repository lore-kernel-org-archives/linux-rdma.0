Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013024.outbound.protection.outlook.com [40.93.201.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D5553D0B7
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 21:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792098871; cv=fail; b=Ep3eWkwZIO51iIuYhAx50CCWVtOQB+6R6BgymGcTsQ4TqktXX7z3lI0fVcHtcQKmTMQmw+XCrQ7c2JGmq0X62IqICTHl74CL221z2SdGde36fugToDeseHbIK3YPUuLbEY69tcU852g26vyvoUs8qJh2GZ4lPz3OENJw8pd8bCM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792098871; c=relaxed/simple;
	bh=MfVcGsVyi8XnBamYpui37RqCV44fpvwj/Xr+vjrBxOo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JD4Jq21aBrkL3mUw4ASxK6wfIi6xy2FpDEnnLVNc01caKKumvcuApz0Cja+VGUP35HnmtQDyFU1GHkEMvmis1O9yi8hnTN7ybRGyWxWlJYGvAltlaIlWw4tOWUIoketU73l2vqgc/iBqQgquFEhHApClmkhsb4LZ16yRsogu8tc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aXc+jGvw; arc=fail smtp.client-ip=40.93.201.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aXc+jGvw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oZfp5bgBiFVeCfrjSrsXrpjP9rHP3FeZLr4nj9WAYYljPctwQgcmVUNpJSvPeLGcSpfcA7lr2oiHUd9QNEcsOh5o488HM/6PGTO++YVFerlZAH489D/IzwxhDN92ma67TlRtOieMQpeM0Qmr4c1ulDgA4mV7P37O1DCRo8PxY5YG3rLrn+6sqIxbKv75dw1VrX3EL4ZQQog6343cCMlIsC5D0+pN1NvS+E581y9ZKF+eiKg8/Fvts7ORc80BOzbwmKoaTt5Fx8C8uKYwqGuK0Nlk6jPB0REZ/G4n7fRmFcwo0aY8F1mzgxvxAukFJKRRyFkNs+YHH+AgCrviAcG35w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MfVcGsVyi8XnBamYpui37RqCV44fpvwj/Xr+vjrBxOo=;
 b=t4r7+s+YAHwrGyOWZWZhw7PNDabk7d8BkJN/7ONVmN9rWAVgn0NDjGzyZCccPi6wiU+FfA3opjQ6bz9N+WmSVPLisjmCyGMVHTiTl+QDBWwfNiz+lYslaq+CmB2lMMAJmf1ufZtIaT5Gamt8XgXReBkDoVguofm2XOgg+T4jV1e1qJDDRG7GWUt87dnZ0vZsOKk/HCDNObf4iDhJemAPBZOV+DyRFep5/F9rXeTG49FSSlTTavYpfbTxV2d5wJJ1FkTXg5MV2SEqxkSeybuiJK0GHbWjjg6uCUBKqOnc26qDt9XfG37xSFUcI0QW0d/l4qDJFK6vG6J7DFZtzgMtTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MfVcGsVyi8XnBamYpui37RqCV44fpvwj/Xr+vjrBxOo=;
 b=aXc+jGvwJdRI2qkPhAWfP5vfCB1qoUmlCc91MzxjF6ABYoFlHf1ObYVCmWIuSpcMiQ/maVZWnFKy5xReV08xiEVHP8eCvD1s8KwfCX9O/jx3rl4z00VkykrKa5gXcmBHHL6SttZED5I5I+3MJck8hEIKVSHvRw1sCKnzSCgkzq3BuBkATFhdoS0qOIG8ijGl59kVLbrIW6nbDz6JP/6rOlInmzzhQq+QiNOVltIz12AvZNCo6RtaAoFg6veQgcWeLFcXPKGcO95LBtIo8Rr/awNE37CkL1XuDks2bwE0Nyl3vhZopLMwF6KUZYFC2MqxBVDh6bH2ecLiRJfvpeme8w==
Received: from DS6PR12MB534567.namprd12.prod.outlook.com (2603:10b6:8:498::17)
 by SN7PR12MB6929.namprd12.prod.outlook.com (2603:10b6:806:263::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Thu, 15 Oct
 2026 21:14:23 +0000
Received: from DS6PR12MB534567.namprd12.prod.outlook.com
 ([fe80::4b0a:a4e0:694f:c2de]) by DS6PR12MB534567.namprd12.prod.outlook.com
 ([fe80::4b0a:a4e0:694f:c2de%5]) with mapi id 15.21.0522.013; Thu, 15 Oct 2026
 21:14:22 +0000
From: Sean Hefty <shefty@nvidia.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: Eric Davis <eric.davis@broadcom.com>, "sashiko-reviews@lists.linux.dev"
	<sashiko-reviews@lists.linux.dev>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, Leon Romanovsky <leon@kernel.org>
Subject: RE: [PATCH rdma-next 02/13] RDMA/core: add the UET GID types
Thread-Topic: [PATCH rdma-next 02/13] RDMA/core: add the UET GID types
Thread-Index:
 AQHdXCpo3QYvbgzNxkCV986BMmoEJ7b9oFYAgAEjKQCAABq+gIAABevQgAAhZACAAA9roA==
Date: Thu, 15 Oct 2026 21:14:22 +0000
Message-ID:
 <DS6PR12MB534567DB240CF76594BE5B5D0DBD9C2@DS6PR12MB534567.namprd12.prod.outlook.com>
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
 <20261014-uet-ib-core-v1-2-a0e626117113@broadcom.com>
 <sashiko-outbox-171976@kernel.org>
 <CAMouMY+nCYZ1V_-0La4phKNkvYBke7Njhsr+HRwWkAfahgf3pg@mail.gmail.com>
 <20261015173327.GU14213@ziepe.ca>
 <DS6PR12MB53456734E5A7CFFCDD7FBCCC0CBD9C2@DS6PR12MB534567.namprd12.prod.outlook.com>
 <20261015195408.GX14213@ziepe.ca>
In-Reply-To: <20261015195408.GX14213@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS6PR12MB534567:EE_|SN7PR12MB6929:EE_
x-ms-office365-filtering-correlation-id: 3d4dd247-2018-4641-8657-08df2b0148fb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|10070799003|23010399003|366016|1800799024|4143699003|38070700021|56012099006|11063799006|18002099003|22082099003|6133799003|10067099003|3023799007;
x-microsoft-antispam-message-info:
 1du58QO52RgkN02qnUvkiW7jhUkgwrcvSV61JDVPgrutqhHlNZUWOjm+qXfHokGO9rOXG5EAkFFqrvYQ/iOAvhLd14OLAgNMPv7egTBXsiPBlGk2vnuEw74HzMUqcMTpLFwQIeM7ECDvPipEt9Cz2yXXFGmUKgv38z/YEHFPPKyg/tVxOjCdaiZQT1yIyBH06zOG0O+So2BBeLMdMo0j8npAne+poQ0ibczXJqnVFFHUq+Cv2Jl1JccUVNRDUGJliMFY+fBs//JevbF/k86l87Ixbt2L20KmGJTI0LIYz+EepkeKQhLOaBpUbLs9Yx1TCboDPu/UBNTj0pxVskxEiVUnkJYDBQhtOGlr0WfPFptEepeB3P6T7Mg6mrAjSxJdja2qYqCBS1u4xlrrEffLJvYEErRHaV/myi4VMvqBwoa5/IXczxwUBobb9ZPu8RbX3BxGxkd3LmZ4En2kwnPi1V2r6n9k02ppfwU+bp2lwJfbDKdSb0FkJrtLyqoR3uMa7+CnIVbr3XvhBlPSB+gbe5H5kPz0KrZFteiWaU24qRrV4MTbrO2AqP6HnSRBsufYsG8Nag+rvxQjyTrm7C68KMrQns/6y5ehltccRDPOuyXvZTq4v6cZI7D/g5aNbmK8sWNyO7YcuTeb78HEg8JjHHI/vtazqQ38Sztc7n71WCZ9xYJubSatJuOh/I2LIzpbrMOV19K7C+c3mE9lXJaInVZq3p+LojLPvIVguUucd9I=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS6PR12MB534567.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(23010399003)(366016)(1800799024)(4143699003)(38070700021)(56012099006)(11063799006)(18002099003)(22082099003)(6133799003)(10067099003)(3023799007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cGFLZXBWdS8wdnczNzYrbG5PUzNiTitCbnVaNTFobW94bDR0ZFltNlFiQWs2?=
 =?utf-8?B?L1V0ZHBCTVVQV1RBWHdXczVWRTd3ZkUzekNLOHZxZWFkamRNQ0tkQU1xd3Yz?=
 =?utf-8?B?aldubHhsOG9QVUprWGhuOHFhZVd4SC9KR1U0S0pzbStVZ2NZQzBTZGxrRlJu?=
 =?utf-8?B?UGFBNUIzdmViMzFicm5aejlLY1hLRU5rYkdzRThySkk4bWV0c01LMEsxekhq?=
 =?utf-8?B?VERNZ09rUHZmbU4wbk5Ba291VXdGaHZsSmdYdEFZUVQreUxGOTRyK25GZjE2?=
 =?utf-8?B?L1VHU2xiY1k5N2xKZkxQNDlRRnNFR2ViWHRwZ3NabEk5bjRYUzh5LzYzT2pZ?=
 =?utf-8?B?WVZpM2ZnMmpwa1V1M2MrbFRwUTdvQ0lWQUMvNzFsOTVranozdSthbzV3WC9q?=
 =?utf-8?B?eTY4L0t0Zy9sWTZDckVmOFVWUm5DOWVhQmc0SHBOMUZ0ZWVmQWduU0JDOEZm?=
 =?utf-8?B?VURoWW52RkN4MTVXQ0lEV2E0ek9jK3VNRzR4SEc3bk9RMlViVW5GRFRxMEVy?=
 =?utf-8?B?OTFLYTdpNjRmVTdpeFBlaGxwMVAwZW5uRVBTTFFEMkhXWDUrSXE5bVhoUHN6?=
 =?utf-8?B?TmtLVWkyRFZSVUMvQzluMUNFSDl6N2tjUkVYdHBybytKMkh5aGlIZ2tvRS84?=
 =?utf-8?B?MDhCK1JtVGkxdFVFNEhSZmlqd3FZaFYrcldPTWFrOXdBZThoNnFUSGZTRWc2?=
 =?utf-8?B?Z0tLQjJ6Q1lMWjRualFrWWJrbk5JSWFxaWhDN2M4NnhITEFGQlJ4THZqOEVG?=
 =?utf-8?B?T2pTSVJIRzFXMm9UdVQ3bjVDYVY4aDJlY1g0ZUh1cXNxS1I0RWIwWnBCZ1p3?=
 =?utf-8?B?NFVHN3YxZUNzeVp1TFVUdE9mUXJEc0J5NHZWVDBGMjg4cmVYTkxQRWZaNnRE?=
 =?utf-8?B?d205WjBBczVpYVVkSGJ1VWZ2UFYxeTlxMEN3TVhrbURPd2p0MHpvc3lycmVS?=
 =?utf-8?B?YTNaeE8xQTVncDlNbitQZkhnamxvcHNreUhsc05lR3hiTmw3V0xrTFhyZjFx?=
 =?utf-8?B?TTllM2VUVjllWk4zdHQzVWprbVlzQURzMG1ndmJJQndNTlVkTG9JaWNsRVhq?=
 =?utf-8?B?S3Fsc09OYzdmRzFaQ01tUGtWOHgvVmNwelhEWjVWWW5MQkNkN0piN1psVDAr?=
 =?utf-8?B?YUtTQ3hoR01ncDJ3Rjd6SHpFdFU5TGg2aWk5dlplWXhOZk55VGNyLzJlRzc0?=
 =?utf-8?B?aTAyNWYvSk15cG9jcExQTGtBbXNCaHVtcDFPNDNWa2hqMk9VSTVyRzlKMUVT?=
 =?utf-8?B?RVVVYlBKTTZoK25pRGxEWGtaakZYSE5welByYUNkWktIWVFpNVlVRldSdWRE?=
 =?utf-8?B?K2xma2lNNFdKSVVMNTFBK0VBeWhjUGVpWE1KSmwySWpERU12eFdYMXNmL2tm?=
 =?utf-8?B?cUNlK1kvc3F3bWVTaFFMR09zNlpmWVFlSm05eXdQVTlIVk5ISXRXMm1wTFcw?=
 =?utf-8?B?azBzQ0tWM2pwLzdicXhBZTZzSUFwbEhnWWswS2h4WHN6cUliWU1PeC9VQzdC?=
 =?utf-8?B?c3FualZDL2lQUWpzd0h2d2JOdWdKRXlwUUN6Rk9HRTVTZDR1ZTVqWFlNOGts?=
 =?utf-8?B?RXk3TFdiWUdMekhoSVU1YnluOUt2TUtvWi8yTzRkVHVFeXpjeURrRVp5M0Zj?=
 =?utf-8?B?UG1VVlhOdHl1ekJwRzkyakRnQ2JiUDF1bmUycjBVOFMvejRUMUx3Y2UzUkYx?=
 =?utf-8?B?TTdKNE05cnlnSWZZaUhiZS9HRHJJSUhjbWdnOU9aaUhFZmY5cVpFNjJZa3hv?=
 =?utf-8?B?ZVBGcTkzZUZJaWVoSXptZjQ2cEVzMk1nRmFhMVQwYnI5M0Uwa0xjalorcVBE?=
 =?utf-8?B?V0trQW1NZUxuRS81Nm9KVXhTb3NlTkFUZ0ZGb2NCUnZIN3dPUEJuV29vQ2w4?=
 =?utf-8?B?MFFadlQyNmd3OUZ1VnBvZXhlUkFoTTV6NDNYcU1tbW1lWjZpT0xKaFdPYm9i?=
 =?utf-8?B?L0NEU3QzWWY1bE5WTmNGeHNGd2J6ZXJZQjV3SGt3R2kwaTJ2TVYyUURUNkVq?=
 =?utf-8?B?b092cWtTV2hrTHM4R0tBY3A3Ym9wN095bWJYOHF0UHNvRFk4am11VUJSL1RC?=
 =?utf-8?B?cDcvUmdCOEZIQWlQOG5HS1VWRUlla21sMVhJUW1SQ3locXUvT1BHWERZNGJX?=
 =?utf-8?B?ak85by83R2MzUFcxL2dlYmhBQ3NNKy8vTk5yRmxNakpPSXVYMjlrMkZhY1kr?=
 =?utf-8?B?ZUoxTnZ4RWVVYjEvb2RvVXovYVpJaWw3R3d4dHI0dzlBMW83Mk94NzFKU1E5?=
 =?utf-8?B?WGYwOS9iVzRiWnJldjNNRnVOR0tvWXJka0djbVBtY2hhV3U5TnRXcEkwbVpj?=
 =?utf-8?B?aGpxbjZxd3VHNmx1OEpXcHo1SERSMkVnekpTRnhIUDdFbDJKa0Jwdz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS6PR12MB534567.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d4dd247-2018-4641-8657-08df2b0148fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2026 21:14:22.8749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lCJEKiqWc1wzYW5l6Lk7bEcXsDzBSG0BKAiCTdtragdQkpSBO433GhknDxyf0Drvz68AmJM3pHDwlasngG/zIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6929

PiA+ID4gPiA+IENvdWxkIHRoaXMgY2F1c2UgaW5jb21pbmcgVUVUIHBhY2tldHMgdG8gYmUgaW5j
b3JyZWN0bHkgbWFwcGVkDQo+ID4gPiA+ID4gdG8gYQ0KPiA+ID4gPiA+IFJvQ0V2MiBHSUQgaW5k
ZXgsIGJyZWFraW5nIHRoZSBVRVQgdHJhbnNwb3J0IHJlc3BvbnNlPw0KPiA+ID4gPg0KPiA+ID4g
PiBPbiBhIHBvcnQgdGhhdCBydW5zIGJvdGggUm9DRSBhbmQgVUVUIHRoZSBNQUQgdHJhZmZpYyBp
cyBSb0NFLCBzbw0KPiA+ID4gPiBtYXBwaW5nIGl0IHRvIFJvQ0V2MiBpcyBjb3JyZWN0Lg0KPiA+
ID4NCj4gPiA+IFlvdSB3aWxsIG5lZWQgc2VwZXJhdGUgUk9DRSBhbmQgVUVUIGliX2RldmljZXMg
d2l0aCB0aGUgY3VycmVudA0KPiA+ID4gc3RhdGUgb2YgYWZmYWlycywgd2UgZG9uJ3Qgc3VwcG9y
dCBtdWx0aS1wcm90b2NvbCB0b2RheS4NCj4gPg0KPiA+IFVFQyBpbnRlbnRpb25hbGx5IGNvbnNp
ZGVyZWQgbXVsdGktcHJvdG9jb2wgZGV2aWNlcywgd2l0aCBhIHZlbmRvciBkZWNpZGluZw0KPiB3
aGV0aGVyIGl0IHdvdWxkIG5lZWQgdG8gcHJvdmlkZSBzZXBhcmF0ZSBTVyBkZXZpY2VzLiAgRS5n
LiB1c2luZyBVRVQgZm9yDQo+IE1QSSwgYnV0IFJvQ0UgZm9yIHN0b3JhZ2UuICBQcm90b2NvbCBz
ZWxlY3Rpb24gaXMgdmlhIEdJRCwgc2FtZSBhcyBSb0NFdjEgdnMNCj4gdjIuDQo+ID4NCj4gPiBX
aGF0IGJsb2NrcyBtdWx0aS1wcm90b2NvbCBzdXBwb3J0Pw0KPiANCj4gUHJpbmNpcGFsbHkgSSBk
b24ndCB0aGluayB3ZSBoYXZlIHRoZSBBUElzIHRvIGRpc2NvdmVyIGFuZCBsaW5rIHRoZSBHVUlE
IHRvDQo+IHByb3RvY29sIHRvIFFQIHR5cGUgYXBwcm9wcmlhdGVseS4uDQoNCkknbSBtaXNzaW5n
IHNvbWV0aGluZyByZWdhcmRpbmcgdGhlIEdVSUQgY29tbWVudC4NCg0KVGhlIFFQIHByb3RvY29s
IGNvbWVzIGZyb20gR0lEIGluZGV4LCB3aGljaCBpcyBkaXNjb3ZlcmFibGUgdmlhIGlidl9naWRf
ZW50cnk6OmdpZF90eXBlLiAgKFVFVCBRUHMgcmVxdWlyZSB0aGUgR0lEIGluZGV4IG9uIGNyZWF0
ZS4pDQoNCkUuZy4gYSBkdWFsIFJvQ0UgKyBVRVQgZGV2aWNlIHdvdWxkIHJlcG9ydCBub2RlX3R5
cGUgPSBVTlNQRUNJRklFRCAmIHRyYW5zcG9ydF90eXBlID0gVU5TUEVDSUZJRUQuICBHSUQgZW50
cmllcyBpbmRpY2F0ZSBzdXBwb3J0ZWQgcHJvdG9jb2xzLg0KDQpGb3IgY29tcGF0aWJpbGl0eSwg
aXQgbWF5IGJlIHBvc3NpYmxlIGZvciBhIGRldmljZSB0byByZXBvcnQgbm9kZV90eXBlID0gQ0Eg
JiB0cmFuc3BvcnRfdHlwZSA9IElCIGFuZCBleHBvc2UgVUVUIEdJRHMgb25seSB0aHJvdWdoIGli
dl9xdWVyeV9naWRfZXgoKS4gIEkgaGF2ZW4ndCB0aG91Z2h0IHRoaXMgb3B0aW9uIGFsbCB0aGUg
d2F5IHRocm91Z2guDQo=
