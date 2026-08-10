Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010063.outbound.protection.outlook.com [52.101.56.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA923839B7;
	Mon, 10 Aug 2026 11:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786362738; cv=fail; b=fF4QSx0UQUt8LMeKoptID3WiO33/fUiVzKqHtxJicv1oidwJYx68AvQPrdIPbf+jTNXiZoBqtnC5Q4psxOCEJL5m72ca0Yy2X0OVKRg9D59U3QpW9+8U3+H1vP8Dq1lAjf168JIqLqD+tXsNpMna1Aze7atRjepdEesRtaEdkSc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786362738; c=relaxed/simple;
	bh=TzEHIsS+ZTgY6UNw75Jb8E/dszuaokLj5Y/arJYbIX4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ApcCon5RR3E1lnNlXFAOMqeJz/fcqd75sNNTi6VRC72NvUT82xCniuRbQeUY0tkRWWDgljTG+kmX2kTqL/8R6KN82T/FfsRiDcGZItOgTw/Frah/EP1MvRlX8leLEndYMnhdVW7xdPW70+VM3nxiXUm/vLdK9iFEduqEENNs7X8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JjDZsxZ9; arc=fail smtp.client-ip=52.101.56.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JjDZsxZ9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BGH4840Z9+hVRXCVqFDJkVP8Gm9oNhUNm0NBCNv13D5oK2ZqlLGBITSupEj7cXb2q28vcpEeTpajhcZGAWUgJsjUU4WSUOWbvpubptS2ur6C/6AASEXotFC2QuOvVQgjJzZkrT3PxyJE+vJshwnh8ebdQLFZ18A1pH0ex5ukffHqCXxtLThv+qRrNzm2AOr4KAZvjNDNmvfCqwg7HVDTFcf/5buueTG2wurljt/NETDLn2ZDePJOVFxHq3I+928NQ7+EFffJh22e+/JZuzGp6FJMUymJURFI/ZcdI66jlfcUyP0gG5keX5EJJvnBhhWEVOgJ04E8T62ZMtfA5UFfCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TzEHIsS+ZTgY6UNw75Jb8E/dszuaokLj5Y/arJYbIX4=;
 b=Nj6pY7dDYtKhtFzumkAAc3oqpB5zwFAQ6c7aMg30H/U+R4fnaJ4u7Ci1MIVve2oYGOyRY6ApN9nO3pq/ykBtdCXS6QZPTlNxfJBx0O/6SIK5x5OKGOxF2IHAzr7TDTm5myi1Nv+5sHgW91h8nHAumJ7q8uRoBTRNV4V+nz6vE6bD4lvi/5cYCcuy3GBTKEuAe8nkJoqz+Bgj7uv72WBXXf5PEjmZ/MrRWzI7w82PlSzogbJsgS2F3+5P2H2HiUR8uxD3HiVn8zrjer/VClQgkErK515wDnVCz1GYxI5cxWFERrKJ2Cg4ynNrsKGuVhSsam3sRuxExzPCp9rbqrj8xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TzEHIsS+ZTgY6UNw75Jb8E/dszuaokLj5Y/arJYbIX4=;
 b=JjDZsxZ9Iwm5/07m/1RzDwV5zV2ilq9x118EBpn3cPojfPSIsoY4tTHL9DEbiHWB8GXgpXsOID0e00pQuYaGTagktiWAbGYFFHpXgSBtMPcjEJNlg3VkFkBqbUv0XCvG2g73xrZHLfH1rUQ1pnmTdFvUnfTyCKDqYppzXbzQEN9VlFyDEoUwPlfpenGbT9uJMG9Z7FiZd+/U8qMeiymEMTfyn/X7mjjdU/Ma+Mqw2iaWopM3TGOlyNWsUFRjG0xX+zcS2womassDijKSh3BT/hj8D+6f6khmt481O05UWTCVfBUIQrMMg93cj5Po2VpEQ089VL6KPiOe6JRg3tQukQ==
Received: from DS5PPF266051432.namprd12.prod.outlook.com
 (2603:10b6:f:fc00::648) by SA3PR12MB8809.namprd12.prod.outlook.com
 (2603:10b6:806:31f::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Mon, 10 Aug
 2026 11:52:11 +0000
Received: from DS5PPF266051432.namprd12.prod.outlook.com
 ([fe80::25c9:b561:2aea:8e3c]) by DS5PPF266051432.namprd12.prod.outlook.com
 ([fe80::25c9:b561:2aea:8e3c%3]) with mapi id 15.21.0292.022; Mon, 10 Aug 2026
 11:52:10 +0000
From: Cosmin Ratiu <cratiu@nvidia.com>
To: "andrew+netdev@lunn.ch" <andrew+netdev@lunn.ch>, "davem@davemloft.net"
	<davem@davemloft.net>, Tariq Toukan <tariqt@nvidia.com>, "sd@queasysnail.net"
	<sd@queasysnail.net>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "edumazet@google.com"
	<edumazet@google.com>, "daniel.zahka@gmail.com" <daniel.zahka@gmail.com>,
	"kuba@kernel.org" <kuba@kernel.org>
CC: "sdf.kernel@gmail.com" <sdf.kernel@gmail.com>, "doruk@0sec.ai"
	<doruk@0sec.ai>, Boris Pismenny <borisp@nvidia.com>, "shuah@kernel.org"
	<shuah@kernel.org>, "linux-kselftest@vger.kernel.org"
	<linux-kselftest@vger.kernel.org>, Jianbo Liu <jianbol@nvidia.com>,
	"leon@kernel.org" <leon@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Raed Salem
	<raeds@nvidia.com>, "skhan@linuxfoundation.org" <skhan@linuxfoundation.org>,
	Chris Mi <cmi@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>,
	"kees@kernel.org" <kees@kernel.org>, Alex Lazar <alazar@nvidia.com>, Dragos
 Tatulea <dtatulea@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
	"sdf@fomichev.me" <sdf@fomichev.me>, Saeed Mahameed <saeedm@nvidia.com>,
	"horms@kernel.org" <horms@kernel.org>, "aleksandr.loktionov@intel.com"
	<aleksandr.loktionov@intel.com>, Gal Pressman <gal@nvidia.com>, Lama Kayal
	<lkayal@nvidia.com>, "Jacob.e.keller@intel.com" <Jacob.e.keller@intel.com>,
	Patrisious Haddad <phaddad@nvidia.com>
Subject: Re: [PATCH net-next V2 13/13] selftests: drv-net: psp: Add a test for
 PSP with HW-GRO
Thread-Topic: [PATCH net-next V2 13/13] selftests: drv-net: psp: Add a test
 for PSP with HW-GRO
Thread-Index: AQHdI+yv39DUnRTc3kqHa/IbPCZqaraOL/MAgAkFigA=
Date: Mon, 10 Aug 2026 11:52:10 +0000
Message-ID: <1724a2baaf36bfb6d5d264aa182ba73908870f22.camel@nvidia.com>
References: <20260804083535.2946459-1-tariqt@nvidia.com>
	 <20260804083535.2946459-14-tariqt@nvidia.com>
	 <9460e089-ed71-4f3c-986c-5d29b87b3500@gmail.com>
In-Reply-To: <9460e089-ed71-4f3c-986c-5d29b87b3500@gmail.com>
Reply-To: Cosmin Ratiu <cratiu@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS5PPF266051432:EE_|SA3PR12MB8809:EE_
x-ms-office365-filtering-correlation-id: 0dec095f-eb99-4a75-ac14-08def6d5cfc6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|366016|38070700021|6133799003|10067099003|4143699003|56012099006|11063799006|22082099003|18002099003;
x-microsoft-antispam-message-info:
 cN43+5OOghA+HP9QZm3jsOBAiIzxJ8jkzydLd7zWrrjE08/9TP4717iKfw0aI8X4Utoir5zSEx01mLPg+vb8OPYy6Et831oN19bSJSEWZKk7hscn3yk16vCUmxXT6lDDHNbh4HEkBd3r+LFEKHQHJ43Sx8As7Pgn2DY9s1zRASpvwLcOb1ErE48wZ+jgL2mW+Q6ZMlW3XO69zqPl5q2uCsYOoyJYTJmoiC4209larsdDL3zMoheajHupuzxTC1RQ19pR7AVX98veEYYym4aJCStbicQ9Y1oruKlj4cFYi1OWBo/3TWv2qVLimKUPBQ9r8pcHxgAxhenzIXq4jiI2ebvSgHV7nTzgXsHSiyuqkS4569PyIf7eWrfGiTsNXD67RBBrDNjmMZLqUbFov45GyW0+S+x4FjfcrwDg7MIE89FNcLj2CRPILxMtbCYDJU37Ga5/tDoiHCUKOOORAckHqRc9ekOxltdV44l0B8Qkt29Y8xdC8kbYuY84iMeZuOrhgnrMQ9Hhq7GixlpFSAfQEpddzEGoVBvdiUk3EkDtRu4YaqAHYkpDcrTSJ7UmaP4Q0Rh7RYiktwNVgGWwKIC+1RlzcgjUBpS/TZS8meL/Qs3aNpmUCVpH1l9rgcegoUeOqqPaIFKfYig0h7Gnn/R9jZWox3d/9pHwFPvpKS0C1k0AlXpGa+3AanVkLKJIJ7SIIOcg9/GS+JOHvauw8aGxJmYWGu5Z+6cCoRs4yf2kGFw=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS5PPF266051432.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(366016)(38070700021)(6133799003)(10067099003)(4143699003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bTA1TEJJbXZPMlMvVjRRYUh2TlIzM0Z5MkhpNWQwejFqampZUWorTGR0bzlX?=
 =?utf-8?B?bm0rNU9tTnBnRVl5a1VnRXhwbzZoT0dSVWRXY3A4citMNWxGVkF2V0lBenhO?=
 =?utf-8?B?ZlRXU1dnLytINDA5bVMwNUthbjc2M1YzWTY2c2lPSFYvVFFQYnQ3VkQ4QUxw?=
 =?utf-8?B?RklOYU9WV3pTbE5lQkwvaSsvUnQvMXF3RjJPcFlKTkd6SnlHRU9pTkVTblpt?=
 =?utf-8?B?dmVmRmhQeWFicUkyN0lWaUtPNitnS2xMUHR4T0wzSk1rb3lFRDRYNzJNTTdK?=
 =?utf-8?B?M1U4bWlJdWFlMmVRRU4xVTNwRHJVTWRQY3FpN2F4RXlJQTJGblQySFkvR1JN?=
 =?utf-8?B?UzBEYU96Mjdlck9KTXJTUEVYSW5hdGs0QUwxTHp2bytlbE1UQmdoelNRd1gy?=
 =?utf-8?B?dFl0ZlhuVEhoZzhSaUE2bXVrNXpOaVZxSUFqSHo1d25tWEwrdUlmNmdORlBG?=
 =?utf-8?B?VVh4N0ZMUXgzeGtpUFNSS3JUc1g3TnFybHhnQzlrNzNqRFNUa3hhbzVwc3lH?=
 =?utf-8?B?dmFQYWl0dkt5K0VsZlRsZWM3aDU5T3B4aHNEaU90Q0d1UW9FWGQ1Q2d6SHR2?=
 =?utf-8?B?aGZmcnpMUnZRZGF4WE1WVTdwSTBtWXVrbzJIZmgvYm5GN0NsWTZMeEpDTmVN?=
 =?utf-8?B?VUh2dWkyaHJrbU9CRC9yVTJ3N09lVGR3MFQxQXlxSjloNDNPdk1xYnRLQjRr?=
 =?utf-8?B?b2JJZjIyVXBNN3hIT0hqMEpzcUxTeVg3TWlCYVAzUGpMNWVKalZpQ3RCUU14?=
 =?utf-8?B?M1paTU00MTIxbkk0anBsa0RkV1FoaUkrYjYvazJqVDE2TFJKc1k1cW1aQUdU?=
 =?utf-8?B?ZVB0aWQzMUpnZDdnMm43VUZYSjRKSlpadzZtL0g4NFFpTVZMSGMwek9Dbll3?=
 =?utf-8?B?SCtjQmNVOXplOUZsMjlHMm9uTGxMLzRpQUlLZnRyYmxXbThGYjZyUnJWa1Rj?=
 =?utf-8?B?bisrWnpTQjRQcU96U3F0L0NhRUZkamV1UCtYY0V1NkJobmwyTVRESU1sZU9z?=
 =?utf-8?B?TDc1TEpEVTNGWDJqeTZjczUvcE51WU0xempJSWVhdVdEU3RBM0xRNTdpa2JR?=
 =?utf-8?B?aE9nSnNqMXZNMndQdWxodHMvcVVsS1g1N3g1OTEyVis0N3FYbGtmMlc4OEpT?=
 =?utf-8?B?NXZJS1M4QUUwbXJIQk9DU0RnbmdsSmhCbFA1UVdHZllPUFpPenh1c3JXSDd0?=
 =?utf-8?B?OHZ0ZWRxM0dlUVlpaW1TaWNWK0wzTjUrM0tsM3dwYVFqNnI3Y2wxb01kT2pz?=
 =?utf-8?B?WEdhRXJKbWpKQjZIL2YzMUpGZHAxSmJCaFltMTZLZFJ6S2lGOW0zZ3llQkUr?=
 =?utf-8?B?TDdyQWxXSGtsa0NXaGlJZVhPUjFMUll6YWVzWGN5T2lEck1wNkNWZWtjRVY2?=
 =?utf-8?B?RDFtcGg1b082QStCWUJRK01PVFFQM2NQSEltRkJER25NTXB1SkkrL0lLS285?=
 =?utf-8?B?UTdYVTM4TFBESzZGZUxMekVOaGZ0T1d0UktGOWRRbFJQSy9kSGdBYVBRRmdm?=
 =?utf-8?B?U3lKS25DZlJ4WWVDWCtja0lxalFNbW5SUFZBZEtPYWRGUEVOQm1pcGFoUytP?=
 =?utf-8?B?Q0NEZGZuc1JTenFXeUJGS29UREgwODdSUmN3dDAraU5ocEJOT29nRzIrQjNV?=
 =?utf-8?B?TG5qUEN0OUxRSDFPOEErd3d0TVZ0MmVlcW52OFFUQWo3WmRPeEdZWnB3Qnoy?=
 =?utf-8?B?TDhhamF3bjhzZmpMbVNQSEpxSlJPbk9XT25WRGpvRVdMRUg1K3NFV1dHZXA5?=
 =?utf-8?B?RmV1emxzZzVObEl3eEJCRTQ3NGRJNGNSTFdvYXIycGNEVGVkUTZZT0h2RlYr?=
 =?utf-8?B?ZlR2RXJjdHJyczU5VlVic0J6aHYrM3ZrQ1BOQzdPRnE5L2c1OVh5SkFVY2ZJ?=
 =?utf-8?B?Zis4OEFCc1phdWY4M0hnMTNldHlKdHhyRi84bmkwVXJaUGt4dTBFTXV5OWti?=
 =?utf-8?B?K3FHM0c3ZG5hT0JvODVtUGljWHg0cXN3NEFYUWJOVXdpL1VyeUVhQWxEMnVq?=
 =?utf-8?B?WTR1RDhiYTQ1YXJlWE9tVlV5SEd0VEhyVUtETDBhRERGSEFOQnN0a2duM2VB?=
 =?utf-8?B?VGpFTXl0eXVnVkpFeGttUm85WW1FUUwycFBEVjRRQjhkeGtiVG0xa0JsVDRj?=
 =?utf-8?B?UHB0WTdPd1MxTnpOV2ZEenJIZEoyOG5RQkh6VldGd21HZ3RRbTdObU1kbDJR?=
 =?utf-8?B?SHdEM0JEWUJONHIza0UyekJjT3RVSG0vYjRXTDQ2c1lCSzM4OVFnd3ZVS3F1?=
 =?utf-8?B?UkZLTG5teTZmcmNXM2s5WjRrWFN3S09NclRvNWV1KzJyc2NYOEZnUENENFVu?=
 =?utf-8?B?SVlSclMzOTdjbHl5SlZpcm55SjdWK09HZTRCbGRkRXliTjZoZkF5QT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B297EB073A58384286F7A040756521D6@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dec095f-eb99-4a75-ac14-08def6d5cfc6
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2026 11:52:10.7011
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BhIuM7XywvUxrpLECUx3d7mTZdw6UiOixOWERMM7ZAlZ1KXEvJQFNVxc3xqN3Whn4MllB6nCWrH/dwFJImhQbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8809

T24gVHVlLCAyMDI2LTA4LTA0IGF0IDE0OjA1IC0wNDAwLCBEYW5pZWwgWmFoa2Egd3JvdGU6DQo+
IA0KPiANCj4gT24gOC80LzI2IDQ6MzUgQU0sIFRhcmlxIFRvdWthbiB3cm90ZToNCj4gPiBGcm9t
OiBDb3NtaW4gUmF0aXUgPGNyYXRpdUBudmlkaWEuY29tPg0KPiA+IA0KPiA+IEFkZCBhIHRlc3Qg
Y2FzZSB3aGljaCBhdHRlbXB0cyB0byBzZW5kIHNldmVyYWwgNjRLIGNodW5rcyBvdmVyIFBTUCwN
Cj4gPiB3aGljaCBpcyBtb3JlIHRoYW4gTVRVLCBhbmQgdGh1cyB0cmlnZ2VyIEdTTyBvbiB0aGUg
VFggc2lkZSBhbmQgSFcNCj4gPiBHUk8NCj4gPiBvbiB0aGUgUlggc2lkZS4gVmVyaWZ5IEhXIEdS
TyBjb3VudGVycyBpbmNyZWFzZS4NCj4gPiANCj4gPiBUaGlzIHJlcXVpcmVkIHRoZSBhZGRpdGlv
biBvZiBhIG5ldyBjb21tYW5kIGluIHRoZSBwc3AgcmVzcG9uZGVyLA0KPiA+IHNvIGl0DQo+ID4g
c2VuZHMgdGhlIGRhdGEgaW4gb3JkZXIgdG8gZ2V0IGl0IHJlYXNzZW1ibGVkIG9uIHRoZSBsb2Nh
bCAoRFVUKQ0KPiA+IHNpZGUuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogQ29zbWluIFJhdGl1
IDxjcmF0aXVAbnZpZGlhLmNvbT4NCj4gPiBSZXZpZXdlZC1ieTogRHJhZ29zIFRhdHVsZWEgPGR0
YXR1bGVhQG52aWRpYS5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogVGFyaXEgVG91a2FuIDx0YXJp
cXRAbnZpZGlhLmNvbT4NCj4gPiAtLS0NCj4gPiDCoCB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9k
cml2ZXJzL25ldC9wc3AucHnCoMKgwqAgfCAxMzENCj4gPiArKysrKysrKysrKysrKysrLS0NCj4g
PiDCoCAuLi4vc2VsZnRlc3RzL2RyaXZlcnMvbmV0L3BzcF9yZXNwb25kZXIuY8KgwqDCoMKgIHzC
oCA0OSArKysrKysrDQo+ID4gwqAgMiBmaWxlcyBjaGFuZ2VkLCAxNzEgaW5zZXJ0aW9ucygrKSwg
OSBkZWxldGlvbnMoLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy9zZWxm
dGVzdHMvZHJpdmVycy9uZXQvcHNwLnB5DQo+ID4gYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9k
cml2ZXJzL25ldC9wc3AucHkNCj4gPiBpbmRleCAzMTU2NDhhNzcwZDAuLjliODk5NzIzYTYzNSAx
MDA3NTUNCj4gPiAtLS0gYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9kcml2ZXJzL25ldC9wc3Au
cHkNCj4gPiArKysgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9kcml2ZXJzL25ldC9wc3AucHkN
Cj4gPiBAQCAtMTYsMTEgKzE2LDEyIEBAIGZyb20gbGliLnB5IGltcG9ydCBrc2Z0X3J1biwga3Nm
dF9leGl0LCBrc2Z0X3ByDQo+ID4gwqAgZnJvbSBsaWIucHkgaW1wb3J0IGtzZnRfdHJ1ZSwga3Nm
dF9lcSwga3NmdF9uZSwga3NmdF9ndCwNCj4gPiBrc2Z0X3JhaXNlcw0KPiA+IMKgIGZyb20gbGli
LnB5IGltcG9ydCBrc2Z0X25vdF9ub25lDQo+ID4gwqAgZnJvbSBsaWIucHkgaW1wb3J0IGtzZnRf
dmFyaWFudHMsIEtzZnROYW1lZFZhcmlhbnQNCj4gPiAtZnJvbSBsaWIucHkgaW1wb3J0IEtzZnRT
a2lwRXgsIEtzZnRGYWlsRXgNCj4gPiArZnJvbSBsaWIucHkgaW1wb3J0IEtzZnRTa2lwRXgsIEtz
ZnRGYWlsRXgsIEtzZnRYZmFpbEV4DQo+ID4gwqAgZnJvbSBsaWIucHkgaW1wb3J0IE5ldERydkVw
RW52LCBOZXREcnZDb250RW52DQo+ID4gLWZyb20gbGliLnB5IGltcG9ydCBOZXRsaW5rLCBObEVy
cm9yLCBQU1BGYW1pbHksIFJ0bmxGYW1pbHkNCj4gPiArZnJvbSBsaWIucHkgaW1wb3J0IE5ldGxp
bmssIE5sRXJyb3IsIE5ldGRldkZhbWlseSwgUFNQRmFtaWx5LA0KPiA+IFJ0bmxGYW1pbHkNCj4g
PiDCoCBmcm9tIGxpYi5weSBpbXBvcnQgTmV0TlNFbnRlcg0KPiA+IMKgIGZyb20gbGliLnB5IGlt
cG9ydCBia2csIHJhbmRfcG9ydCwgd2FpdF9wb3J0X2xpc3Rlbg0KPiA+ICtmcm9tIGxpYi5weSBp
bXBvcnQgYmtnLCBldGh0b29sLCByYW5kX3BvcnQsIHdhaXRfcG9ydF9saXN0ZW4sDQo+ID4gQ21k
RXhpdEZhaWx1cmUNCj4gDQo+IG5pdDogYWdlbnQgaGFzIHBvaW50ZWQgb3V0IHRoYXQgdGhpcyBu
ZXcgbGluZSBpcyByZWltcG9ydGluZyBia2csIA0KPiByYW5kX3BvcnQsIGFuZCB3YWl0X3BvcnRf
bGlzdGVuIGZyb20gdGhlIGxpbmUgYWJvdmUgaXQuDQoNClJpZ2h0LCB0aGFua3MgZm9yIHNwb3R0
aW5nIHRoaXMuDQpOb3Qgc3VyZSBob3cgdGhpcyBoYXBwZW5lZCwgdGhlIHByZXZpb3VzIGxpbmUg
d2FzIHN1cHBvc2VkIHRvIGJlDQpyZXBsYWNlZCBieSB0aGUgbmV3IG9uZS4uLg0KV2lsbCBiZSBm
aXhlZC4NCg0KQ29zbWluLg0K
