Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012054.outbound.protection.outlook.com [40.107.209.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C963C3438;
	Mon, 10 Aug 2026 11:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786362173; cv=fail; b=iaP4NnfBStPNyVPhm3ROqBnjIEjkLZU3+s+uka8N3GZH57Sh7I0HUdCBaxec+22nEtLuuT/T+vQBaVJjxEc8UIGAVVj3aeDY4yqeCJC7fZB+aXwPpHdv5MfuhxnJPX6u3CyOMuzvyFkE2808/Ekk3DkFYYuOivIBkLK3I9LopZA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786362173; c=relaxed/simple;
	bh=xIsZI5PeKuV2FOyDhhD45TFMgBhr4K2cB4sHM+mAWPk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rT0rBK7QDZNrw9lHKbag3uwDfD8ZHcK3MfqMzjMuGxrol8iXChlkRCrm1bsFrSsNJcdVctcXWgnsc+u0CSlgHOyWB1wWhrsC8c+etLp6LrUVcJeO/t6/xzH1y2nsrvtuGxq4jsAIaur/LJtCo+qrbTenpo2gx72TRV1JS+XgpEg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jZDgzjzq; arc=fail smtp.client-ip=40.107.209.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jZDgzjzq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xQ5HC47MzX10XfADNGV1vEmO5fJqONFPRpAAAFu662eMm0vwdzkvSX/9C5GW8RdDv67di/m1QqyO7nmS5XRj5N/U00OVlIJamxpp1jqYiquT9KLzVTygTm/FLYOhaNySU6doiPIchxnb7GCuLdqyQDQmN1HqHb4ui9YaaaC7oS1MN9AOPMaW8cEPMyNkn5orG3RI31LqvIJpbSAmUPH9/uRsS4QNxqcrrdq5QV+BY1MCe25DoUOzj0Q7Agzmng5+plIuJfUYSTuKmM9G+hzgC3vTk/fosA458rifRmy2D3B8LJF8rZ6cA04NyENKNB0qGS955gAIuAzEdWmepXv3tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xIsZI5PeKuV2FOyDhhD45TFMgBhr4K2cB4sHM+mAWPk=;
 b=AhKFmqV33eKZyaPM25V3aF1Ke7Twckqcen1cohy+DDfiTMs2+BAwZ2s1U50OnKkK/N8ZBcVcRVzkqk1jwH19asFSgkAPkX9lIp4Owc19BXt+C4Xr/k6+lZOD32UHgg0fegg3D72kL0JpH/GXhMTXD5C+cI6iDrYy44wob6mtP6U9jGBiPhE7xMcjKjlWElg1QW+LMEoc3Fld6jr5VyhqiH3sn6MPyIItO0RG12kx0EUABEEB7VSplXSFRQ1dxz3k7T5KHNFP8kAz5dRZ08irCpeP3Oqxa8f1+ESM+hbxka9u+4nA5DqWRaXLxfyrAiOPhhr1bMvO2OJzHx0qCIk4+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xIsZI5PeKuV2FOyDhhD45TFMgBhr4K2cB4sHM+mAWPk=;
 b=jZDgzjzqhboih00PyLfklsq3oTMqmXptJwT2I0Jw7GnIZ+agewvWhls0Xkfwm6J9O1pAASDIgAaslOQTrlti64rrm9yMhLJctXhsJw22uk9tV5exeiRIbP+rCBGmZWTDiWBKha4KAuVhicBkGAZA5lj7A3FDoC05eUtZKe7yu+UxeBIL6hZlSMmDjDTTXLNeMHNFbLEqgBmFyMlARut2Npoz5/murdDXYulmafn2Al5jkVh82QFjCWr/BBKTFNUVSY7rTRVV8x4/JbJQP/eSkclwTwienV/PeoiVfdfHR7oEEs0cTiTUhHx7kW7g466+pXl9hMvmdEZ/L0cLsOgOMQ==
Received: from DS5PPF266051432.namprd12.prod.outlook.com
 (2603:10b6:f:fc00::648) by IA1PR12MB6209.namprd12.prod.outlook.com
 (2603:10b6:208:3e7::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 11:42:36 +0000
Received: from DS5PPF266051432.namprd12.prod.outlook.com
 ([fe80::25c9:b561:2aea:8e3c]) by DS5PPF266051432.namprd12.prod.outlook.com
 ([fe80::25c9:b561:2aea:8e3c%3]) with mapi id 15.21.0292.022; Mon, 10 Aug 2026
 11:42:36 +0000
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
Subject: Re: [PATCH net-next V2 12/13] selftests: drv-net: psp: Fix responder
 parsing
Thread-Topic: [PATCH net-next V2 12/13] selftests: drv-net: psp: Fix responder
 parsing
Thread-Index: AQHdI+yn+RnS0tvdH0K/K6KpoNcjc7aTWlYAgAPYewA=
Date: Mon, 10 Aug 2026 11:42:36 +0000
Message-ID: <51b31f2497f1c42464f803818b0e9b6cc6b9aa56.camel@nvidia.com>
References: <20260804083535.2946459-1-tariqt@nvidia.com>
	 <20260804083535.2946459-13-tariqt@nvidia.com>
	 <20260807175858.70a717d6@kernel.org>
In-Reply-To: <20260807175858.70a717d6@kernel.org>
Reply-To: Cosmin Ratiu <cratiu@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS5PPF266051432:EE_|IA1PR12MB6209:EE_
x-ms-office365-filtering-correlation-id: 0892ff89-415f-43da-af99-08def6d47978
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|22082099003|18002099003|4143699003|10067099003|56012099006|11063799006|38070700021;
x-microsoft-antispam-message-info:
 5uQ2GKz6+/bwovQx5zG6BXKdRNthgxOs45pmUZZhIH2DuROORiQVkpE840yok1DP5dWP8uCWxQEkspKCB8+VwtC/A7yC7SDWW/WVvptGFPTZSYQTCmpEqEUiio1CsfqAVObzwPU78dkBoSc9x03a6AWCd1JSzQyLWWPN5rfT5AkA2fvmhAovSDNDJd9XP15ilo/Knj0RA1VcFdDBw962V4IF5Itf7Cl7TjbUz8Xa+xcfZyroxmhWwwh7mlqnp71M5VOB2BwTSqT83zfCZlAWCVr9aFw1dk8UHY1EeDInujD1eRES6Bbrs5OzWjixD7TQZ4PKMgw/K/emEKI+5KYn8u2/vfLXIb4ACRW7KYE6F8wVyOq9dlnHhFbj2T2vbCnNkBWGDxzbcXSRcElREgzc+CYU4WE2RJ9oBvSWo8vtOIGI0MXBFPtg40uLRr7NpwavNAzaZqRV6n66drLsjxEAyIl+4d8L1EDJ9w78F4KbmwGmK9bPS0OYSV5peQZCNseL12wQs0mQ3C2u0YJhiZ80UcMmurxEYhguRBxmtDTakDIEsBCIeRHholH/mCu44FJPevbc7ELew02MdqVXNZAB8c98kGIoOwERwioHzIjP6Y7In59God1Cc0NyDrsUKHNO70nOBf2uvHk6OyPOpIpfEeLV9JsVcBqCGk/8IOe+gs2dkycDqfgf7/t4gNl/qwFbBfl1Xp7Bg+h9GB/04YMnjg/ngIkglti+yvV71QzjoWo=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS5PPF266051432.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(22082099003)(18002099003)(4143699003)(10067099003)(56012099006)(11063799006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?R0dwOSthRkhFVWtrMnVrY3FWTjU5RmVVTlJGeFMwSlVhOFRuR2hxcEJLZC8z?=
 =?utf-8?B?TzdPOUNPKy9BUm9tNXdxbVFJa0g1em5OelVvQXlvNlJrRUNUVnR1OStjWHZw?=
 =?utf-8?B?TDZyT3V2aUJaU21yZTNrdWtNZUpvNVJqa0lLNWFNaHlCTytoNmE2NkxZcS9a?=
 =?utf-8?B?S2g4Q1F0R1JlQm9TWVZDamVzandlaDQ4RHZaYmFyRHZIVlJmQ3pNcVVxdG80?=
 =?utf-8?B?dWtYMmd6dUFVbXlLSDkzN0t6MnFTSEhFTFlYSFRMKzJ5dFptTFFBSGxUOGZK?=
 =?utf-8?B?YlFXam5XSFJwb1h1ZDFOQnJKRDRnd2gwdi9wMGRadVhtb1NhU2hMQWplNkw0?=
 =?utf-8?B?R1YzN0RXbjBXclN3Uk82Q2t4NkN5K25VMnp0U2d6b1JSLzczNGdic2V0ZWt0?=
 =?utf-8?B?WTRiWTJWWnVrcENOVnlGb2lqSnpTR0JidlQrZVlKaXVuR1B2OFBwMUR3UldT?=
 =?utf-8?B?cFovZmU3ZEE0WGxwSEpNekFEZVdVM2JZVVhCVlZvUlNsSUh0QnYra0ZMZUw1?=
 =?utf-8?B?WWpqQU1VbEorNGZWb2M2OHB1YWQxMituS05FejlwQ2N1b3NyOE9ncHcvRWM1?=
 =?utf-8?B?OUFFUWorb3ZLZHo5S05BczNDWWk2NjJxTUttSHhKY0F1MXNYQStqdHFFdnA2?=
 =?utf-8?B?Y21pWndUb1RqZDBjR0IvaU5odkZVOWRydFozSUJGT0RnYzh4cEZhaHZMR2Rj?=
 =?utf-8?B?clhPM3NyKzlsZTlzaTBaTzBWU1plMDRHN1lUcmFqSVBJbStGbHFEMkh1enYx?=
 =?utf-8?B?MDVFMWNjMXF3MU5QN1N3bG03ajkwdWJ1dW5WR1hzL2xBVkZEWkFHRExwWGJo?=
 =?utf-8?B?NjlVRklFNjhIOWk1cTUzK1d4OHFkMEtYRTY5Q3VIRGQ0OTcxOGpYREJ4WkpW?=
 =?utf-8?B?MzZYK3o2eTZHVWxzb1FaeG5lS2VRRkRDbTZ6UW1DMjZYVkJzSTNUMUlpMml0?=
 =?utf-8?B?dnlwYzBHeExsMVc1eENCcUdHWmhLaGkvbm94QlRmTkJPNkw4VFpxS3pFY2p4?=
 =?utf-8?B?eHVGNllXdUVubDRpODlvZ3VkNk5tTWpTbFpaRWFVRU1Ea2JpWkNFRzlHUFBK?=
 =?utf-8?B?c3dveldtVFJyWjU2OWlTTnRydW1vSnpxSmdxSENPRjJZVGhpSmpWQUpGeVlT?=
 =?utf-8?B?TzFneVVmOUlUWlBndk5DRCtNYk00dDRUUXZXSG9mNWF3K2k1MmZmMXc1dGhZ?=
 =?utf-8?B?K3B5VHlSMkE4SnpRbkhacEJPc3ArUmlOVzZ0T1BPakNQNE5yVmlWWjR0blRw?=
 =?utf-8?B?RU5kVWtZUTR0QWhPY3cxMkZvMDZ2aHFjRndyY2QzU1N0eXB3VktyUk1Xb21v?=
 =?utf-8?B?eVJ0UUwrVTg0cVNySTY5VzR6UlRQV01ENW9hckVrR0N3VFREbmtTc01RTkFv?=
 =?utf-8?B?RWRlQ0QyY1RKTUxPWU1heVl5OFcvME5XdmVGRjVFVnJsM1RrYUFJT0tGMWJI?=
 =?utf-8?B?WngvR2tuNWNaSmZtVTdXS3pQR1FiemhmZW5LYm44L1I5ejk5a3NMc2MwREhI?=
 =?utf-8?B?bjJwWkMxYU8yWlBNdzhySWdwcXR6Y3RRdG5PSjl0VE1oVjJza29vK0lieUNv?=
 =?utf-8?B?RDJlM2liOHNyRWh3WWFJd1d2TTBGMkF1RFI3SjRKYmZHcjByY1EzM2g4L2h1?=
 =?utf-8?B?bE9DOVdmUkQ0c3VzcmJDcFUvNzFzTGh1S1ZRQkFkb1ZsdTdiTkdjakY0L0Iw?=
 =?utf-8?B?MHRLRWZZVzFKZzcvM2FQN2h3OFNGVmdHa29OUlkzMkJzR1dveVUyc3hQQVZX?=
 =?utf-8?B?aTBubnV2Mm82KzRSYTQ4VVV3RWhsbi94UVpNQlFEMTlwOVJSdUIzd044Nm9y?=
 =?utf-8?B?MnRiVW1UdytoNjhyOVIxdXdBRzNmaWNvdlh2T2w0Ty94UWM0UndwUjdib3Vi?=
 =?utf-8?B?OGw4ak5lR0dMT01wVDlxNElrOXROWWcyNGdDNUVqbVppVTM3dGg0R2tqZkpM?=
 =?utf-8?B?OHovM21mMGZvVnpJeXU1V0lOaTlHRXBlNkNXU1cwdi8rUWJ3bVovdEZCcW0x?=
 =?utf-8?B?VndmSkxEZmUweUduQVhueFFud1V1NUluYm10YXNRRW0wT0crVnRWWUZUUzFI?=
 =?utf-8?B?eU9LajhkSDVDem1ZWkxmVkpIc09HL2tqNk9tZlFhWmpMbU4wS1h2MGNTWWFB?=
 =?utf-8?B?b1RtNnFtaDJsNG95eVV0VnFXMG1ZNHI3R0VmNkIvbktaaFEzSjgrUFJidGhj?=
 =?utf-8?B?Y2FmWGZkQ3RRSm1LRXVsNGZqM0Q4dkV0RHI0Y0NhUSsxbWxxQVVHamU2STI1?=
 =?utf-8?B?REdpQlpMOTF6SVBRdVZLREFvcHFOZDFNTldhS3pHK2FVdTRnZXRwZlJ1a3NZ?=
 =?utf-8?B?RnVVblpVazFWZFg3L29HanIwQnRPUVVZK3BZaXMyZHFoUm1vb2RDZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8D4A4B001F20F4498B279A74BDEE9F57@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0892ff89-415f-43da-af99-08def6d47978
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2026 11:42:36.4373
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F8+JnCp94tcHCyXBuE+VTr10SqO4jgLMo6JRYFlqrQe0uF4M+9XWYCrEDKbr4fXrKQjWTmMutzgqCnz3V5ydyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6209

T24gRnJpLCAyMDI2LTA4LTA3IGF0IDE3OjU4IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVHVlLCA0IEF1ZyAyMDI2IDExOjM1OjM0ICswMzAwIFRhcmlxIFRvdWthbiB3cm90ZToN
Cj4gPiDCoAkJCW9mZiArPSBuOw0KPiA+IC0JCQluID0gb2ZmOw0KPiANCj4gPiArI2RlZmluZSBj
bWQoX25hbWUsDQo+ID4gX2V4dHJhX3N6KQkJCQkJCVwNCj4gPiDCoAkJKHsJCQkJCQkNCj4gPiAJ
XA0KPiA+IMKgCQkJc3NpemVfdCBzeiA9DQo+ID4gc2l6ZW9mKF9uYW1lKTsJCQlcDQo+ID4gLQkJ
CWJvb2wgbWF0Y2ggPSBuID49IHN6DQo+ID4gJiYJIW1lbWNtcChidWYsIF9uYW1lLCBzeik7IFwN
Cj4gPiArCQkJYm9vbCBtYXRjaCA9IG9mZiA+PSBzeiArIChfZXh0cmFfc3opDQo+ID4gJiYJCVwN
Cj4gPiArCQkJCSFtZW1jbXAoYnVmLCBfbmFtZSwNCj4gPiBzeik7CQlcDQo+IA0KPiBQbGVhc2Ug
ZG9uJ3QgcmVwbGFjZSBvZmYgYnkgbi4NCg0KSSBhY3R1YWxseSByZXBsYWNlZCBuIGJ5IG9mZi4g
RGlkIHlvdSBtZWFuICJkb24ndCByZXBsYWNlIG4gYnkgb2ZmIj8NCg0KQmVjYXVzZSB0aGUgdHdv
IGFyZSBpZGVudGljYWwgYWZ0ZXIgdGhlIHJlY3YgZXJyb3IgY2hlY2tpbmcuIEkgZG9uJ3QNCnNl
ZSB0aGUgcG9pbnQgb2YgbWFpbnRhaW5pbmcgdHdvIHZhcmlhYmxlcyB3aGVuIG9uZSBzdWZmaWNl
cy4gRWl0aGVyIG4NCm9yIG9mZiBjYW4gZGVzY3JpYmUgdGhlIG51bWJlciBvZiBieXRlcyBpbiBi
dWYuIG9mZiBpcyBzdGF0aWMgYW5kDQpwZXJzaXN0cyBhY3Jvc3MgY2h1bmtzLCB3aGlsZSBuIGlz
IHRlbXBvcmFyeS4NCg0KU28gdG8gY2xhcmlmeSwgZG8geW91IHdhbnQgdG8ga2VlcCBib3RoPw0K
DQpDb3NtaW4uDQo=
