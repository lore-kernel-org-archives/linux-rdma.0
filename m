Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012014.outbound.protection.outlook.com [52.101.48.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6121C46EC7C;
	Wed, 23 Sep 2026 08:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153461; cv=fail; b=dJVgRSflYy5CFRlOAqd9R6p3lDR3ci3HCV+J14BazLNS1Pm5ww+HkEjW/wyGZWHXpVgxvY8K6MAmPoBRPDx48SroYvvmC0rxo/w8kOOwqfUw8RKkRo0qwvG+Fw/bE7MyIu0hLcMYqsQPz8awV0A6UqqAFHmXFXwzXafBDGw18OU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153461; c=relaxed/simple;
	bh=HSM5OKabaifBde+lTO66qt7R0h2feLm4QvkcDF7T1bA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cN1y5AQIIHJW7/JvG/Z7DB5GVEgvObpT+Sm8Mt92ckH+/P7oeIg69EncLW7B4xtMYxNrjCO2lrhgpz8oF0suewpoQC19BTomvIDpf+VeftM89Eg6+R2H5No26CnoOcXcKyO4ZJZMv4f9Z2/eqayd/BchYSqx8irxLfRzA6rNAvs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tEM8lMhL; arc=fail smtp.client-ip=52.101.48.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tEM8lMhL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zGWTPQmWfjqMkNWeCZUbRfo7l3NQqkrE1ZwMlgUaJjyiF95gBqj0YO+j9/U3ljp55F+ST1sQvYhq83LEXvQm25y5Tk7dgg5hlPqLHuWPTh+UhIP/4J760G1LeFBwF3mG2p1VzYIe18NXHw3qFA3ZtJafD34T88ctj6v9dID0+EsrhvMe67nsfiKUro1OyzwC7cj/KCQeF+TWvoDt1zR8kxlgv7pPr9Nnon9LxxD8QlbjetbgUk+Btf5sbo/dqOEoufiF5ilsr+uI0K9AEEMG/puRV6CW72cIQoLTF0pPfWse3nlDNZG4LO3GtVz9R/aX8i8ccAiS1FdlQFoAZrK+6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HSM5OKabaifBde+lTO66qt7R0h2feLm4QvkcDF7T1bA=;
 b=wZXudBtW3ol5zVw1vqnipT77k+GJnInD3ETk4IBLnWkEd5f4lcrQTjdsP8jKFKHe1geTz25cXkGh22lqzmhxihfdG6Qi71V9XSROiIyKbtAc6ql3ZLjRcYX+nkJV0CxN+JvAupdzKynevX6H9mFybjoJ0tGuAVg+w70DR9kCJAe29vZw+VJfh/U7oEjnE6kv27LYGc8Vmo7s1U9D3klEu5WpdYQvOurCgMuNyd8/KUB7U0swytaMQ3ugn5kwCZUG/Qe/IZDHb7rQzz6fzHTsXVajT018OENb8HJdz2ES3CfF4VGg/b1nHBb7jl/F9lrnup02IvrN8LeQkfvOcIJESA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HSM5OKabaifBde+lTO66qt7R0h2feLm4QvkcDF7T1bA=;
 b=tEM8lMhLZM9rxskDfZewxDi/pYlepDpXAdVKF53IoTvp+boj7E+O3DxHHnIvIYqpuSAfr7Cydl5NcO3DTch83nMj6Qow9++SXPftdWg8YCS0a7D7/GslRtnSfCq+sgmtjhA4Ow1/vD3ImWVipWCilO/muuZ+QmFMd0EYQ4kvzdVaDR3yzI/Vy9WGgAmqT7qNnFUKSoPlAPOgViKelD/I3bqqENXUvGz6N4D6UySbeZIr+t+KeONbFwa5UQKQFHgKgPFMnZnCdFf77+8e1cOI8SmrQHXQ2URKyIFm7jHyBYGA8ZdGaRS+BiYePKmDUa5WgGSQ0Lc12O3C7TcdKuHhEA==
Received: from DS5PPF266051432.namprd12.prod.outlook.com
 (2603:10b6:f:fc00::648) by PH7PR12MB7967.namprd12.prod.outlook.com
 (2603:10b6:510:273::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Wed, 23 Sep
 2026 08:50:52 +0000
Received: from DS5PPF266051432.namprd12.prod.outlook.com
 ([fe80::9cef:7e0f:2134:13fe]) by DS5PPF266051432.namprd12.prod.outlook.com
 ([fe80::9cef:7e0f:2134:13fe%3]) with mapi id 15.21.0451.014; Wed, 23 Sep 2026
 08:50:52 +0000
From: Cosmin Ratiu <cratiu@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>, "netdev-bot+sashiko@kernel.org"
	<netdev-bot+sashiko@kernel.org>
CC: Boris Pismenny <borisp@nvidia.com>, "andrew+netdev@lunn.ch"
	<andrew+netdev@lunn.ch>, "daniel.zahka@gmail.com" <daniel.zahka@gmail.com>,
	"davem@davemloft.net" <davem@davemloft.net>, Jianbo Liu <jianbol@nvidia.com>,
	"sd@queasysnail.net" <sd@queasysnail.net>, Emeel Hakim <ehakim@nvidia.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"edumazet@google.com" <edumazet@google.com>, "pabeni@redhat.com"
	<pabeni@redhat.com>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, Raed Salem <raeds@nvidia.com>,
	"leon@kernel.org" <leon@kernel.org>, Dragos Tatulea <dtatulea@nvidia.com>,
	Carolina Jubran <cjubran@nvidia.com>, Roi Dayan <roid@nvidia.com>,
	"kuba@kernel.org" <kuba@kernel.org>, Mark Bloch <mbloch@nvidia.com>, Lior
 Nahmanson <liorna@nvidia.com>, Parav Pandit <parav@nvidia.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, Rahul Rameshbabu
	<rrameshbabu@nvidia.com>, Gal Pressman <gal@nvidia.com>,
	"steffen.klassert@secunet.com" <steffen.klassert@secunet.com>, Saeed Mahameed
	<saeedm@nvidia.com>
Subject: Re: [PATCH net 7/7] net/mlx5e: shampo: Do not merge PSP packets
Thread-Topic: [PATCH net 7/7] net/mlx5e: shampo: Do not merge PSP packets
Thread-Index: AQHdRs/vvOSfKmS3qkOtzqvdBc+rj7bZZieAgAJ9fQA=
Date: Wed, 23 Sep 2026 08:50:51 +0000
Message-ID: <92d0a1ddc4fa5e6c1ecf1e64920ad3eeab1b5fa7.camel@nvidia.com>
References: <20260917175433.4090878-8-tariqt@nvidia.com>
	 <179001655196.2160803.14482188682686687561@kernel.org>
In-Reply-To: <179001655196.2160803.14482188682686687561@kernel.org>
Reply-To: Cosmin Ratiu <cratiu@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS5PPF266051432:EE_|PH7PR12MB7967:EE_
x-ms-office365-filtering-correlation-id: fcd46af0-1bcc-4b1c-95fc-08df194fc59c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|10067099003|11063799006|6133799003|22082099003|18002099003|56012099006|4143699003|38070700021;
x-microsoft-antispam-message-info:
 T+SvwleuOFCN7YaCPULTGKksiYjKhJTuIy9Xq7VlpU5QKNNmG202DrHHjWtuZyCp7GZYwqU0iLKR+wnNER+6CfjK9HIDp4kOKbK9Kl+ld/0fZyTzjC7PqtHoMx/EtJGf33q6AbRrEAg9IvrbUGL/4Tb02UoG2LtUwwlH12Vn2qEAH/GUv+QspPIEx8FIC42Hm1t7/f3jkZKzvBbHFI6M0bT6lgr6RnRzGk/bG+yhqmOEYJzCLwrhFPVXsqbq1gU7fiC7CIQxPzQpKbxls+amFOqdeDJ++ATpZlPjpxnHBIkmE+pIKZ/HP12Pq2y+Hm9CSDd6sfZyIDaPvx1K+rFmqYsGhXYAjz+BO5h95OB4D88dWQQmQPOsmApvPdwv2U+qet38lLBzN2xFlQIrZfomW00aO46L3PidbLEvKZHU9iaLZZyNZIWpuXDshERc4hCDyt+cBuhCdRE8y/YB47tAkGGWubJIbMd4pzclOJ0NVC0zTrpWpYRooyNjCDhOLKhtrXHmGAR8I0BYJL4JXilJHeGMCVOOxZaIMTdEhggahFlbiWeVlEDWZv/Q2mWayLtDL5aMAtUZI+mb5j8JccvScUjZ2XBsWC4PCECmNAKb8OOpXObIE2gLYpQOZyVZaah+KR2shPrkkAKVngdOKk0Usp5nGBrubmMtKuOsp/I2PWOYyAZ7PkVAEvkA2/cnWUvZ4dBCC7DeA9IBd/Bw/6Wjug==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS5PPF266051432.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(10067099003)(11063799006)(6133799003)(22082099003)(18002099003)(56012099006)(4143699003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RkJXdVVESStPQWc1WlVzOUhEN2kvNXV4RmVyQWRrb1JHY3pHd3F4blh6cXcw?=
 =?utf-8?B?bXZzY2pBUmF1c3BtWG5WS043NWFoOUZ3TEZIVDhVcHJiSGIxeXhaQmFpT2ZS?=
 =?utf-8?B?Nkc4UFpScjFjSkN4Y2ROeWVqUC9JRHA3VGJLdE83SFNuMXE4UU1OOTNOOEdE?=
 =?utf-8?B?UmZNbHh0eTNpZHdyZXAremdOaVNzN0hITDc3NnNQNndIak9ud2liRXdCd3BL?=
 =?utf-8?B?T21SV3FrMlgzL2loMjVpdW04UnlIZnplUFBDRkowSGtVdmVvWmZoZ3RXNWg2?=
 =?utf-8?B?RU1jMEJoYnBVZHlhUDY1S3ZTYldlQW9wRW5WV2Rvc2RoNTlHL1Bkc2pYOU1T?=
 =?utf-8?B?YUlNNmpDa3RzYnRTYWRnei9HYWIxdGNjOW1LQ2RjdXczUFNKd1FCeEFqVGxD?=
 =?utf-8?B?d1lnVTNJa0JSN3dUMGxLT0dIekNKeTNPeTJDYnFLbnpyS3pLY2crL3FlZDl4?=
 =?utf-8?B?YWMrZ2c1WUtXZit3Y0dGRSt1MUFnWElieVorckFuSnBiMnViNXcxaWdUdGNZ?=
 =?utf-8?B?MEtpQlBEU3lJeHBocEFUSDFvLytjUlE2TkxROENmS2QyRmxiRHo4QTYrbTBO?=
 =?utf-8?B?U3dIcC9GaXBEOVVNcExqRUJYMXdZVXNqckpyVnlLYUFEK0JWNWt3VVhoZzEy?=
 =?utf-8?B?NWpHcUJ3T3FaTnpyNlJvbU9HRThRZXYwU1pGYk1IcDc3b1p5NnVuNVFTWjJU?=
 =?utf-8?B?anM1WnFFNUdmTCtHcmc3MDdlS0ZnT25JWFl3Vm85QzNjQ2pJOXRqZThvb1Nh?=
 =?utf-8?B?MWpPeVYvZ25JWFRWZVRGZFdDeVdFZGxzWWFTYkpqc2JuMy92YnlMV0xnalVq?=
 =?utf-8?B?RnM4SDF0d0RmeEF5M25SM2VxU2czREtCSzExbDlLb1FsRmZMTk5mNTY2Q3Nl?=
 =?utf-8?B?Y3BBMThtd1R3QnlJdjkyL3psMFVUV3VvU0JxdFRORTVMWGhyQ3FxZGZOUGJ2?=
 =?utf-8?B?b1J2Y2h4b1FtWDZYVVQycHZxQTJZMG1lMXNtOWdhbXhYQWZjajNLcFFwUm1m?=
 =?utf-8?B?dVMwOXpsNTNTang1bDkvWTR3SHVvVVJiMHNDV1B0MmdQd2FhN01CSFdHY2dE?=
 =?utf-8?B?aEpZTDYvbzBqZGQ2TlIrSkNGekxhdVpta3lFWlZaSm9mbzQwWEdzc0hwSm13?=
 =?utf-8?B?SXFGK2NTMGJ1NFI0VnI1YkRoUUd4bWg5bTFzaEhzZG9mYXBpQ3dsRmFUVWo1?=
 =?utf-8?B?aHFGcmV5elBvdkZaY2hLby92MFBqYkxXZ1Bwc2o5TFZsYmxmbFNjQkEvZkd6?=
 =?utf-8?B?TDhud2diVThrMUpNMTdBS0dnSlRsUWh1MUhEbWt5MnFWRUF2SmJobDNEZ2Zi?=
 =?utf-8?B?NVhqMlFHelRkcDJnK0VnODNOVEQxNUR2NU15Wml6TlNWK2ZKSm5xUklIb0Q4?=
 =?utf-8?B?VlVSUjVMRFNZZ0g2TGVMTk1KV3BhQVlrckw2d3N3L3hvSnQ0MWhkVkxINHEy?=
 =?utf-8?B?LzR6bSt1L2NwYllWWjZkWndvT0l6QTBiN3hzanduS0NSSzF3aHVYOFRLQ3Ro?=
 =?utf-8?B?S2NkNmI3L0wzMDE3NkZrdmtxN3RoblB5NHpkUS9mcmcxMGxKWEJnd2dGR2FJ?=
 =?utf-8?B?amVSajVrNWd4TG1nTDJsc0FTU1NSYUtOdDRsaTRGZUNmYXpZc2JCc2dLZDUx?=
 =?utf-8?B?YlJtR0lRMkhLN2UxUUsvOWU4MG1TTzFObDV3WVNEK2k2bFE0Y25ZemVUa3d3?=
 =?utf-8?B?RWlYd3QyUnh0Z1FUbnlZNTljaVJHT2RST1MvQ21MdkpMZDFsRnJzc2M1V2kw?=
 =?utf-8?B?YUJ3UkZlVUtiREFzYndraXVPMXQrMkVjbGJXQVovL2x4QnA5M0FqZ3hWN2ho?=
 =?utf-8?B?cThIaERwaHJZMU4zVnN6ZWxEeklDbkgzSUY0WDlVd0NDUjBmbkdMNlUyT1ha?=
 =?utf-8?B?dmZlZFhlQkJLUnJGL3paejlUdHN5K0lSMHlYckF2cys5dnV0OWIrZnlsUjFi?=
 =?utf-8?B?cFI1cGZ6TytvWVBjQ052ZDMzci83RTJMelpVQ0pneTQ0TndRd1U3blRSQUM2?=
 =?utf-8?B?dTU5bzU0NW41WW5jZzhhOUpDS2pvc2lVWWFrM1NmY2JXZVFBRnZEd3FCLzVM?=
 =?utf-8?B?aXN1SnBLUVh5WXAwSy9VQzRQRnJwYlhWb2crQnI3UDU1M0MwbStWcVhRMkl2?=
 =?utf-8?B?VnMrbEZ0alpabzdJU3R3eTZvaHFBREhLcmJlZjZFbWhud2xBOTNIckJmKzI5?=
 =?utf-8?B?VnFkVlJVUjNiL1dsTDY5Z0hyK2doVkh1UU5jWG42dnZveWpGVllXaVNxWndD?=
 =?utf-8?B?ZGJtbTE5V3NGTlFEM2RvQ1RTbFpMQi82SUxRSGlRQ01lTEZ0bU9FNFdPT3E1?=
 =?utf-8?B?RkdyczRXM0c2V3BQM0dWb1grck9rVFVLa2NHWjJVcFQyalJFNWhTUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <95C5A2F10E68204D9DB568BE7AE936C0@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: fcd46af0-1bcc-4b1c-95fc-08df194fc59c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2026 08:50:51.8279
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FQRPN2wL+QlsIWSPIhLSorN9BTcxz9De7+WTpvVziDI93DyprxHDhbo6eoGtVMZpixPMEAwoPMJIC8K81ADezg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7967

T24gTW9uLCAyMDI2LTA5LTIxIGF0IDE4OjQ5ICswMDAwLCBuZXRkZXYtYm90K3Nhc2hpa29Aa2Vy
bmVsLm9yZyB3cm90ZToNCj4gVGhhbmsgeW91IGZvciB5b3VyIGNvbnRyaWJ1dGlvbiEgU2FzaGlr
byBBSSByZXZpZXcgZm91bmQgbW9yZSBzZXZlcmUNCj4gaXNzdWUocykgaW4gb3RoZXIgcGF0Y2hl
cyBvZiB0aGlzIHNlcmllcy4gVGhpcyBtYWlsIGlzIG9ubHkgYW4gRllJLA0KPiBpbiBjYXNlDQo+
IHlvdSB3YW50IHRvIGFkZHJlc3MgdGhlIG5pdCBwaWNrcyBiZWxvdyB3aGVuIHlvdSByZXNwaW4u
DQo+IA0KPiBMb3cgcHJpb3JpdHkgLyBuaXQgcGlja3MgZm9yIHlvdXIgY29uc2lkZXJhdGlvbjoN
Cj4gDQo+IC0gW0xvd10gbmV0L21seDVlOiByZWR1bmRhbnQgI2lmZGVmIGZvciBQU1AgaW4NCj4g
bWx4NWVfaHdfZ3JvX3BzcF9tYXRjaCgpDQo+IA0KPiAtLQ0KPiANCj4gPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3J4LmMNCj4gPiBiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9yeC5jDQo+ID4gLS0tIGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3J4LmMNCj4gPiArKysg
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fcnguYw0KPiA+IEBA
IC0yMjI0LDYgKzIyMjQsMTYgQEAgc3RhdGljIGJvb2wNCj4gPiBtbHg1ZV9od19ncm9fc2tiX2hh
c19lbm91Z2hfc3BhY2Uoc3RydWN0IHNrX2J1ZmYgKnNrYiwNCj4gPiDCoAkJcmV0dXJuIHBhZ2Vf
c2l6ZSAqIG5yX2ZyYWdzICsgZGF0YV9iY250IDw9DQo+ID4gR1JPX0xFR0FDWV9NQVhfU0laRTsN
Cj4gPiDCoH0NCj4gPiDCoA0KPiA+ICtzdGF0aWMgYm9vbCBtbHg1ZV9od19ncm9fcHNwX21hdGNo
KHN0cnVjdCBza19idWZmICpza2IsIHN0cnVjdA0KPiA+IG1seDVfY3FlNjQgKmNxZSkNCj4gPiAr
ew0KPiA+ICsjaWZkZWYgQ09ORklHX01MWDVfRU5fUFNQDQo+ID4gKwkvKiBQU1AgcGFja2V0cyBj
YW5ub3QgYmUgbWVyZ2VkLiAqLw0KPiA+ICsJcmV0dXJuICFtbHg1ZV9wc3BfaXNfcnhfZmxvdyhj
cWUpOw0KPiA+ICsjZWxzZQ0KPiA+ICsJcmV0dXJuIHRydWU7DQo+ID4gKyNlbmRpZg0KPiA+ICt9
DQo+ID4gKw0KPiA+IMKgc3RhdGljIHZvaWQgbWx4NWVfaGFuZGxlX3J4X2NxZV9tcHdycV9zaGFt
cG8oc3RydWN0IG1seDVlX3JxICpycSwNCj4gPiBzdHJ1Y3QgbWx4NV9jcWU2NCAqY3FlKQ0KPiA+
IMKgew0KPiA+IMKgCXUxNiBkYXRhX2JjbnQJCT0gbXB3cnFfZ2V0X2NxZV9ieXRlX2NudChjcWUp
IC0NCj4gPiBjcWUtPnNoYW1wby5oZWFkZXJfc2l6ZTsNCj4gDQo+IFtTZXZlcml0eTogTG93XQ0K
PiBUaGUgI2lmZGVmIENPTkZJR19NTFg1X0VOX1BTUCBpbiBtbHg1ZV9od19ncm9fcHNwX21hdGNo
KCkgaXMNCj4gcmVkdW5kYW50LiBlbl9hY2NlbC9wc3Bfcnh0eC5oIGFscmVhZHkgcHJvdmlkZXMg
YSBzdHViDQo+IG1seDVlX3BzcF9pc19yeF9mbG93KCkgdGhhdCByZXR1cm5zIGZhbHNlIHdoZW4g
Q09ORklHX01MWDVfRU5fUFNQIGlzDQo+IG5vdCBzZXQsIHNvICFtbHg1ZV9wc3BfaXNfcnhfZmxv
dyhjcWUpIGFscmVhZHkgZXZhbHVhdGVzIHRvIHRydWUgaW4NCj4gdGhhdCBjb25maWd1cmF0aW9u
LCB3aGljaCBpcyBleGFjdGx5IHdoYXQgdGhlICNlbHNlIGJyYW5jaCByZXR1cm5zLg0KPiANCj4g
UGxlYXNlIGRyb3AgdGhlIGNvbmRpdGlvbmFsIGFuZCBqdXN0IHJldHVybg0KPiAhbWx4NWVfcHNw
X2lzX3J4X2Zsb3coY3FlKSB1bmNvbmRpdGlvbmFsbHkuIFRoYXQga2VlcHMgYm90aA0KPiBjb25m
aWd1cmF0aW9ucyBjb21waWxpbmcgdGhlIHNhbWUgY29kZSBwYXRoLCBhdm9pZHMgdGhlIHJpc2sg
b2YgdGhlDQo+IHR3byBicmFuY2hlcyBkcmlmdGluZyBhcGFydCB3aGVuIHRoZSBQU1AgaGVscGVy
IGNoYW5nZXMsIGFuZCBtYXRjaGVzDQo+IHRoZSByZXN0IG9mIHRoZSBkcml2ZXIsIHdoaWNoIHJl
bGllcyBvbiB0aGUgaGVhZGVyIHN0dWJzIHJhdGhlciB0aGFuDQo+IHNwcmlua2xpbmcgI2lmZGVm
cyB0aHJvdWdoIGVuX3J4LmMuIEl0IGFsc28gbWVhbnMgdGhlIHN0dWIga2VlcHMNCj4gZ2V0dGlu
ZyB0eXBlLWNoZWNrZWQgd2hlbiBQU1AgaXMgZGlzYWJsZWQuDQo+IA0KPiBXaGlsZSB5b3UgYXJl
IHRoZXJlOiB0aGUgc2tiIGFyZ3VtZW50IG9mIG1seDVlX2h3X2dyb19wc3BfbWF0Y2goKSBpcw0K
PiBuZXZlciB1c2VkLiBJcyBpdCB0aGVyZSBmb3IgYSBmb2xsb3ctdXAgdGhhdCB3aWxsIGNvbXBh
cmUgdGhlDQo+IGluLXByb2dyZXNzIHNrYiBhZ2FpbnN0IHRoZSBuZXcgQ1FFLCBvciBjYW4gaXQg
YmUgZHJvcHBlZD8NCj4gDQoNCldpbGwgYWRkcmVzcy4NCg==
