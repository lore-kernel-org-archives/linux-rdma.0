Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012067.outbound.protection.outlook.com [52.101.43.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB61F3859FD;
	Thu, 17 Sep 2026 14:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789656868; cv=fail; b=dphLOpAt7s1AvX1qNZ2Nj0sq+EObJxfyaac4pqHep26nOWmujyqjgMfSBPexFQq9INIWZZZae1bS4HATeqd9JNQeL4pSkdwG0sAz3tEVBg5ALPCUJ9haYzAC5zRSdBcvfqAPHKiGR68tP1M3DTsxZRcOnVChX5GKdE/G6CMazKk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789656868; c=relaxed/simple;
	bh=wXfYBUvnnYXVq96kVzVq4HzeITEu6qGuoMW51iTTDd8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CX9C0EbBIOxW3qcxBb8XuOsdx4JmRLtTJsr0N4BLqaayRG6mYEoAuQ1kWjyLqdNGIkjjpUNn0k0rPpnl5z33LlGhmLMlvLkR8SBXCw+Qz4jOewzRLXjv/Jmp4fqMku1uLdsrIav9Jl7Atc8nzi0kZf/PgFXHrvnTYYXLfAR/JP4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fqhkj8Sn; arc=fail smtp.client-ip=52.101.43.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fqhkj8Sn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=olFI9yTM+rVlBzUl9ZXYKH9F/wnqhEXGvD8gMjI4fS6JawUR9/G1iF1icRWepJd/jI5bMlr/7fium6UM5C0O+N/g4zQIL2FUUknVRE+NiYufV8diUg72G114Cs5wZLm0cpEiRCqo4pddDE4nwO20Ozg9mr930atNsz6OQ8RLxCiidPZ7TjcssnyQbjBDRS85in+bfk4Lw58qGNwwc0axgYfCksJafIjY69HbXvUsThQ6+DPJLWiwwXb11HpAY8PR2VtBe8waC85+vfPiC+1YzZolvu27zSK2KdN6QOfxgYBv1f2mgUjX/TrQOMNq2jez7rSGYrTgurc7oPu6zet4hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wXfYBUvnnYXVq96kVzVq4HzeITEu6qGuoMW51iTTDd8=;
 b=KDEhm3Pt0hzFQTV65CIKWYmbmVZi/LIUz/VAj9zhQ7rJRdbnpLtZn5awdiZz4328wDU0aqhlbkVGBbZIoHxo/hVdXiNBv7j4iWInISNn3z/XZIEY33GCQ8e6DpOXAS2DDc7OYKwSZ8sifLydrql/OqMtLkqbmEil+07bjIz8sqkZcCsGlzO34ZbOl7iIl64rALTceXvbhfs+hTiTW+yirt02SeiIXgp2PUP0UmpOXoQkI4fiVRvjNKr9fGTOn+GN8wYnxm36BFje5Js9FclZN4PBp5yOkbzvMBxIMybBjo35gH9Ea8n62TpBbW1l4Se0+5kUQF77pB3b8aiS0w5fUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wXfYBUvnnYXVq96kVzVq4HzeITEu6qGuoMW51iTTDd8=;
 b=fqhkj8Snwkhqqev7zKuEpWLVjwrESQMIPfWe65vb0y+xb1E/EZSPAS/gzKpQjghoFCd3bf+gGbbxxURkUWvAC3KpVGuhL4D08qMEu44C8pl+Y1SHoGGo3npTTCrIfsyr7TytxmjFln7OaAh1BGCKnVJLgQEtHIq7smNsDqVIO3cXymSVui7crEgi8lcB9aKr6RH7txj8sSx/EbwgQyzj3DPPhNav55c5SjOb/6ER7yfHUEdPaZknqQ3BTB3Wg21LZyFULY/tiPYZAw7SW9sMNPGiM8/shRPiWsmAmmbvPkA7WnRM3D7sbOtUw7IttDEF6EuJMA3vZ2YPw8GpgXaxdg==
Received: from DS5PPF266051432.namprd12.prod.outlook.com
 (2603:10b6:f:fc00::648) by SA1PR12MB7344.namprd12.prod.outlook.com
 (2603:10b6:806:2b7::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Thu, 17 Sep
 2026 14:54:01 +0000
Received: from DS5PPF266051432.namprd12.prod.outlook.com
 ([fe80::25c9:b561:2aea:8e3c]) by DS5PPF266051432.namprd12.prod.outlook.com
 ([fe80::25c9:b561:2aea:8e3c%3]) with mapi id 15.21.0428.009; Thu, 17 Sep 2026
 14:54:01 +0000
From: Cosmin Ratiu <cratiu@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>, "kuba@kernel.org" <kuba@kernel.org>
CC: Petr Machata <petrm@nvidia.com>, "doruk@0sec.ai" <doruk@0sec.ai>, Boris
 Pismenny <borisp@nvidia.com>, "shuah@kernel.org" <shuah@kernel.org>,
	"andrew+netdev@lunn.ch" <andrew+netdev@lunn.ch>, "daniel.zahka@gmail.com"
	<daniel.zahka@gmail.com>, "willemdebruijn.kernel@gmail.com"
	<willemdebruijn.kernel@gmail.com>, "leon@kernel.org" <leon@kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>, "sd@queasysnail.net"
	<sd@queasysnail.net>, Jianbo Liu <jianbol@nvidia.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "bobbyeshleman@meta.com"
	<bobbyeshleman@meta.com>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, "edumazet@google.com" <edumazet@google.com>,
	Raed Salem <raeds@nvidia.com>, Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>, "kees@kernel.org" <kees@kernel.org>,
	"horms@kernel.org" <horms@kernel.org>, Carolina Jubran <cjubran@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>, "willemb@google.com" <willemb@google.com>,
	Saeed Mahameed <saeedm@nvidia.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "skhan@linuxfoundation.org"
	<skhan@linuxfoundation.org>, Gal Pressman <gal@nvidia.com>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH net-next V4 14/14] selftests: drv-net: Add PSP HW GRO
 conformance tests
Thread-Topic: [PATCH net-next V4 14/14] selftests: drv-net: Add PSP HW GRO
 conformance tests
Thread-Index: AQHdP18K2aMxiqVMS0SVl9iLPnxsmbbKLDCAgAi9zgA=
Date: Thu, 17 Sep 2026 14:54:00 +0000
Message-ID: <5ef71fbce4e09d068fdc8881059000dfad128405.camel@nvidia.com>
References: <20260908065244.3799142-1-tariqt@nvidia.com>
	 <20260908065244.3799142-15-tariqt@nvidia.com>
	 <20260911182433.74d3f73c@kernel.org>
In-Reply-To: <20260911182433.74d3f73c@kernel.org>
Reply-To: Cosmin Ratiu <cratiu@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS5PPF266051432:EE_|SA1PR12MB7344:EE_
x-ms-office365-filtering-correlation-id: 2fa2282b-ad20-45cc-e2f2-08df14cb8260
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|38070700021|3023799007|6133799003|4143699003|22082099003|10067099003|56012099006|11063799006|18002099003;
x-microsoft-antispam-message-info:
 zH4ifhkw8G5NyDjbfvdLSTBYV+YNWAfBfHoeK195SQ7sG1wxGz5MJgCt8PLhQQYd5oewj3wV5UCpUs1r+3E7uj0pvtuo45QobuUMXaACCOWLuOjlpIOnf1Lxj0V4fWA3RTtwAphynZ1h6/wnuGP9a5HBIWF1i+SJ/pQgN/r8aYmRr4b9epY0ZBFpGl+e2jdKM0v6C2Z5BIrRakMn2zXjrg+Xe7UDLECuP7dmjNTXkKqhHD4Ct/2ZHXLPzZRAGdLR51DwiVqAFWVYqJJFpid4eamRPtnJfLStAt80vytyMwdBzYtbsD/k6IiyB1EMoqDGnFNOzkxyWHU38iToEnCzjOMwrTX3lf6VX/LD1hvINaNo9TwP8m1o0CMhijoLzrgQ/saWgu4YbBku4fxTYUERsG97eYfxOYfZaVm1sNdJgCkazyEXOiiXBrjVKWNefcCbyO3jwNU03bn+JUSWa2CADAOYiagkd+3UCcpR3LGRzRKGonbA6W2vPLhBVEZCGGPhM8tIshHiV0iS27MgKxbN+G5kX+OH7LX0JW/03jdqIs7gJOY85bx/RhEQIw9YhyyK24ISs+H9QbPJrgGcKXaFKRkJdZAkRVdUx0xhhw04liVdNaRQcq+UkVmSsulUCBHeJ5bvdpM1ADxcnpDPsumY5jGYC4c9VsYX8r3ZsA5+pwcDsCvN7I9Np8GzdEbc2gUeEpAG1TCI6CLt7oywF9BysBATfy1+sx/n+Hz9i8pTwV8=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS5PPF266051432.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(38070700021)(3023799007)(6133799003)(4143699003)(22082099003)(10067099003)(56012099006)(11063799006)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?U3Q1anA0QitjY2FXQWczZHBiaVBQNGt5RWFRVlRXbG9rNG9JckozZm5HUksz?=
 =?utf-8?B?alhpSS9XenRvWllpYjdCWHAvYmRIWTVDQm1kQkUyWkJxVmcvaXMxVjF3L1ZD?=
 =?utf-8?B?UncvMWpLeWl5aUN6ak0vaGFOdm02YVhhcy9VK00vbi94WldjS2lPTkRwcEps?=
 =?utf-8?B?VTROMExCRGU0L0tVUmVCNWN6UUFUMHZ1VDJ6YXNBSlM3L1RZM1E0T0pyajZJ?=
 =?utf-8?B?NnJkMXA5ekVlVHNSR2VYczhWYTltYUY0aUh4TDUvNXJoV3d5akVwdVYyN1dq?=
 =?utf-8?B?MVBMOGt1ODZCbUVvWmsxclU2SzVibXdOUjdpcjFPdEJzblc0VXFhUDN2WDVT?=
 =?utf-8?B?Q3VrNTNWWDdwdFR4MkZ4Ukd0RW1MUWp2TzRvU0RIWEV6cERGenBoZkF3YmZr?=
 =?utf-8?B?V3F2TFJwODRxYXFPb0tFeSsrcnVpdm8zTDVWajRVdmVNdlJmQWtnekk0Z05U?=
 =?utf-8?B?TmdVc1Fpcm42RENtbmRYYm5LazI1eHF3Nm1NWHA3QnVUZUtmU2lrZkFheUdl?=
 =?utf-8?B?Q29iOVhIcU01NGtXQm80aG9Ic0JtMnEvQ3ptUmxNQVE4Zk1HMm1oeU8wbE0r?=
 =?utf-8?B?SHZFbmwwUnFEaHhta3pwY0RoK1VBaWpQNzM5QUxEWUFQVkdPUS9STlFGTmNX?=
 =?utf-8?B?TzFxYWtNdDdIM280N3lRaGlIUlBaR1BlaGhRUjZXOGhtMVYrbkVYRXdZUzlF?=
 =?utf-8?B?MVlTdHhlYmc0UFVrTTFVTDB6OFd3UGc0a0U4NjM4RmNHR1BBVzk0VDh1ZFFy?=
 =?utf-8?B?THZxZ3AwNWgzWHRlZE5IajZIVFhGZStQcTdweksvQ2QxVE4yNHR2OTUxcmor?=
 =?utf-8?B?L1d0WEdpd0pvNk5vTkI0YURPb01WK0plRk03VmFXMGQ1NjNPYTFUR3dNK2x1?=
 =?utf-8?B?bUFCLzlDTVh5VFhocmZzbng2b0tuV29obFNIWm8zbjYrdG1kbGE1VHl2d0Nx?=
 =?utf-8?B?dWlxS2ttTktwZEhZcXM0UnVXdFp2SWJndkhzNVZiNHZGMWZhOHJHRGVXYk5h?=
 =?utf-8?B?cnNnVkJwbHFkYmZESE1DT05jTWdtK1BnOXR1TXU3ZzREdmFCYnoxc1dZdFIz?=
 =?utf-8?B?a1lKNkpWVlI0OE5WVTRPaUttR2dHRThjYzJOcHUvbWFnV2hJdHJXb1AzTU1v?=
 =?utf-8?B?SnpDTzdTVFV2UkV3RTJoc3lTeTF3M25EdGQyNk44UmlFTkwwTmZoOWFVbXZu?=
 =?utf-8?B?R3ByaXQrR3k5VzNzU25WTHZtd0x4S0JublE2RG1mUGdoOTBkc3Y5alM0OXVC?=
 =?utf-8?B?enJrNThVMHdDY0VlS2Z3d24vaTZYbnh6WDVBQmRkL3VydGpaS0VuMVhxQmpy?=
 =?utf-8?B?T1dlTWVUWmNaMEEwM2ZYQlFVazJ0QU9kbXpUcTAzbmVxK2x6Mm4xTkJ4UjUz?=
 =?utf-8?B?WXVLbS9kRzRBSTlrVzJialpLL0RUOGNuUkE3ckR3UFVVWjlSUEZzNlVnN3ND?=
 =?utf-8?B?REJ1bFQ0dUljVXZtaWJvYXRmTHRmMWZKTjYzeFNVVFVDYnNtazBicG5mUTVU?=
 =?utf-8?B?Z01KeTljTUE2V2dwSVZRWGRPdzhCTTlSdTBLUHAzRnl6bDNSY1JHL0Z1cThs?=
 =?utf-8?B?ZDh0UmIrN2RidEhRNTkzdGZKbm9RRmMvNlR1bHJOQXAvQmxMMkQ3a0ZNREdD?=
 =?utf-8?B?bUszOXA1VmdISC9mL2RXWDJtRWpzVlRlNzF4Z3cra0ZGZjNEek5sbHgvQTA0?=
 =?utf-8?B?YzFGY0ZYdW9abm9JRXIwYjRkUENTMGFqcHBXS3cvOWNmWHBLWUN2Mm0xdWhJ?=
 =?utf-8?B?M0d1OEFIWDVQZ0ZiN3dWU1pFNHZkSEJZWERvVTZ1U2lvOXduQVNkZUNpU3Fk?=
 =?utf-8?B?Z2I2ekNtc1pOZUYwZWJzUEVwbzdUSlNtMkU2ZVFUcEZLOXJGRGZpMDB5N3Jj?=
 =?utf-8?B?L2w4UFBoTUp5d2hzM1o2RXdOZlRHZVBpSWZ0RS9GTXNZVk5YLzk3bUkwQ0R0?=
 =?utf-8?B?US9nd09Zek9qZEplMDRDWGRiYksvUE55UEJXZERpdE5yK1AvVkxoRTBIRjlM?=
 =?utf-8?B?WFRYQXlzSjdzQ1ZDWEQrQkFydWpLTVdDelNrNTFJclpmeTlYZWl0dlUrTmxs?=
 =?utf-8?B?blNyZTZrYzdzYmNBS0ROSlRGWGw4SVN5WlhML0N3TTVuQ3dFbmc2aHlSMzht?=
 =?utf-8?B?OXczRWM5ZnNiTVpXWThqQVBkVm15YisxdG5UWDR5TXZtaDZ0WGczUFd5dFdD?=
 =?utf-8?B?bXBZUFFoZU5QQWt1VHlRTHFuenhJeGs3QmxKb29RdURUNS9XUi9CeEJjQldR?=
 =?utf-8?B?REFZTThZRmxNWjdWUElXZThrTW5hMkZ3MHRsQjdsL1JSbHp2NVMxVEJyRm9N?=
 =?utf-8?B?YlBhdThJS0U2WVBGVTVvbkhDTDFlUjQyM21IRmJOVzNMWVVCWW9Xdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8FDF5B901E600145944FAF5C0459F895@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fa2282b-ad20-45cc-e2f2-08df14cb8260
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2026 14:54:00.7699
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a1LZPwxoUlFesF2LDbO6/t+VcjMSkfw/iCQ290vU7kMXmLirhzVpzSsZ8tr6/6N5fVBT2/44Rf3XDUQdRmAiiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7344

T24gRnJpLCAyMDI2LTA5LTExIGF0IDE4OjI0IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVHVlLCA4IFNlcCAyMDI2IDA5OjUyOjQ0ICswMzAwIFRhcmlxIFRvdWthbiB3cm90ZToN
Cj4gPiBGcm9tOiBDb3NtaW4gUmF0aXUgPGNyYXRpdUBudmlkaWEuY29tPg0KPiA+IA0KPiA+IEFk
ZCBQU1AgY29uZm9ybWFuY2UgdGVzdHMgdXNpbmcgdGhlIHNhbWUgZ3JvIGhlbHBlciBiaW5hcnkg
YXMgb3RoZXINCj4gPiBncm8NCj4gPiB0ZXN0cyAsIGJ1dCBpbiAtLXBzcCBtb2RlLiBTUElzIGFy
ZSBwcm9jdXJlZCBieSBwc3BfZ3JvLnB5IGZyb20gYQ0KPiA+IHJlYWwNCj4gPiBQU1AgZGV2aWNl
IGFuZCBoYW5kZWQgb2ZmIHRvIHRoZSBncm8gc2VuZGVyICYgcmVjZWl2ZXIuIFRoZSBzZW5kZXIN
Cj4gPiBjcmFmdHMgYW5kIGVuY3J5cHRzIHBhY2tldHMgaW4gc29mdHdhcmUsIHRoZSByZWNlaXZl
ciByZWxpZXMgZnVsbHkNCj4gPiBvbg0KPiA+IHRoZSBIVyB0byBkZWNyeXB0LCBkZWNhcHN1bGF0
ZSBhbmQgZG8gSFcgR1JPLg0KPiA+IA0KPiA+IEJlY2F1c2UgdGhlIE5JQyBkZWNyeXB0cyBhbmQg
ZGVjYXBzdWxhdGVzIGJlZm9yZSB0aGUgZnJhbWVzIHJlYWNoDQo+ID4gdGhlDQo+ID4gcmVjZWl2
ZXIgQUZfUEFDS0VUIHRhcCwgdGhlIGdybyByZWNlaXZlciBzZWVzIHRoZSBwbGFpbiBmcmFtZXMg
YW5kDQo+ID4gdGhlDQo+ID4gYXNzZXJ0aW9ucyByZW1haW4gZXhhY3RseSB0aGUgc2FtZSBhcyBv
dGhlciBncm8gdGVzdHMuDQo+ID4gDQo+ID4gU28gdGhlc2UgdGVzdHMgdmVyaWZ5LCBhdCBsZW5n
dGgsIHRoYXQgdGhlIGRldmljZSBkb2VzIFBTUCBIVy1HUk8NCj4gPiB0aGUNCj4gPiBzYW1lIHdh
eSBhcyBwbGFpbiBUQ1AuDQo+ID4gDQo+ID4gQWRkaXRpb25hbCBQU1Atc3BlY2lmaWMgdGVzdHMg
YXJlIGRlZmluZWQgdG8gY2hlY2sgdGhhdCBHUk8gZG9lc24ndA0KPiA+IG1lcmdlIHBhY2tldHMg
YWNyb3NzIFBTUCB2ZXJzaW9ucywgU1BJcywgZW5jcnlwdGlvbi1zdGF0dXMsIGV0Yy4NCj4gPiAN
Cj4gPiBTb21lIGdybyB0ZXN0cyBhcmUgbm90IGluY2x1ZGVkIGJlY2F1c2UgdGhleSBkb24ndCB3
b3JrOg0KPiA+IC0gaXBfY3N1bTogdGhlIGNoZWNrc3VtIGlzIHJlY29tcHV0ZWQgYnkgcHNwX2Rl
dl9yY3YoKS4NCj4gPiAtIHRjcF9jc3VtOiBwYWNrZXRzIGFyZSBtYXJrZWQgd2l0aCBDSEVDS1NV
TV9VTk5FQ0VTU0FSWS4NCj4gPiAtIGlwX2ZyYWc0L2lwX2ZyYWc2OiBQU1AgaXMgaW5jb21wYXRp
YmxlIHdpdGggSVAgZnJhZ21lbnRhdGlvbi4NCj4gPiAtIElQdjYgZXh0ZW5zaW9uIGhlYWRlciB0
ZXN0czogUFNQIGRvZXNuJ3QgZGVhbCB3aXRoIElQdjYgZXh0DQo+ID4gaGVhZGVycy4NCj4gDQo+
IERhbmllbCBjb21tZW50ZWQgb24gdGhlIGNzdW0gdGVzdHMgYWxyZWFkeSwgaXQnZCBhbHNvIGJl
IGdvb2QgdG8NCj4gdW5kZXJzdGFuZCB3aGF0IHRoZSBwcm9ibGVtIHdpdGggZnJhZyB0ZXN0cyBp
cy4gUHJlc3VtYWJseSB0aGV5DQo+IGdldCBwYXNzZWQgdGhydSBzdGlsbCBlbmNyeXB0ZWQ/IE9y
IGRyb3BwZWQgYW5kIGNvdW50ZWQgYXMgZXJyb3JzPw0KDQpJdCBzZWVtcyBDb25uZWN0WCBIVyBk
b2Vzbid0IHBhcnNlIElQIGZyYWdtZW50cyBiZXlvbmQgdGhlIElQIGhlYWRlciBpbg0Kc3RlZXJp
bmcgKHByZXN1bWFibHkgdGhlcmUgYXJlIHRvbyBtYW55IGNvcm5lciBjYXNlcyksIHNvIHRoZSBQ
U1AgcnVsZQ0Kc2VsZWN0aW5nIHBhY2tldHMgd2l0aCBVRFAgZHBvcnQgPT0gMTAwMCBkb2Vzbid0
IGRlY3J5cHQgdGhvc2UgcGFja2V0cw0KYW5kIHRoZXkgZ2V0IGRyb3BwZWQgYnkgU1cuIElQc2Vj
IGJlaGF2ZXMgc2ltaWxhcmx5LCBJUCBmcmFnbWVudHMgYXJlDQpqdXN0IGxlZnQgdG8gU1csIGJ1
dCBmb3IgUFNQIHRoZXJlJ3Mgbm8gc3VjaCBvcHRpb24uDQpJbiBhbnkgY2FzZSwgdGhpcyBpcyBw
cm9iYWJseSBIVy1zcGVjaWZpYyBhbmQgdGhlcmUncyBubyByZWFzb24gZm9yDQp0aGlzIHRlc3Qg
bm90IHRvIGJlIGluY2x1ZGVkLCBzbyBJIHdpbGwgaW5jbHVkZSBpdCBpbiB0aGUgbmV4dCB2ZXJz
aW9uLg0KDQo+IA0KPiA+IGRpZmYgLS1naXQgYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9kcml2
ZXJzL25ldC9ody9NYWtlZmlsZQ0KPiA+IGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvZHJpdmVy
cy9uZXQvaHcvTWFrZWZpbGUNCj4gPiBpbmRleCA2MTA1YmU4ZTU5MGYuLmRhYTdlNTJmMjM2ZSAx
MDA2NDQNCj4gPiAtLS0gYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9kcml2ZXJzL25ldC9ody9N
YWtlZmlsZQ0KPiA+ICsrKyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2RyaXZlcnMvbmV0L2h3
L01ha2VmaWxlDQo+ID4gQEAgLTEzLDYgKzEzLDIwIEBAIGVsc2UNCj4gPiDCoCQod2FybmluZyBl
eGNsdWRpbmcgaW91cmluZyB0ZXN0cywgbGlidXJpbmcgbm90IGluc3RhbGxlZCBvciB0b28NCj4g
PiBvbGQpDQo+ID4gwqBlbmRpZg0KPiA+IMKgDQo+ID4gKyMgcHNwX2dyby5weSB1c2VzIHRoZSBn
cm8gYmluYXJ5IGluIFBTUCBtb2RlLCB3aGljaCByZXF1aXJlcw0KPiA+IE9wZW5TU0wuDQo+ID4g
K1BLR19DT05GSUcgPz0gcGtnLWNvbmZpZw0KPiA+ICtIQVZFX09QRU5TU0wgOj0gJChzaGVsbCBl
Y2hvICdpbnQgbWFpbih2b2lkKSB7IHJldHVybiAwOyB9JyB8IFwNCj4gPiArCQnCoCAkKENDKSAt
eCBjIC0gLWluY2x1ZGUgb3BlbnNzbC9ldnAuaCBcDQo+ID4gKwkJwqAgJChzaGVsbCAkKFBLR19D
T05GSUcpIC0tY2ZsYWdzIC0tbGlicyBsaWJjcnlwdG8NCj4gPiAyPi9kZXYvbnVsbCBcDQo+ID4g
KwkJCcKgIHx8IGVjaG8gLWxjcnlwdG8pIFwNCj4gPiArCQnCoCAtbyAvZGV2L251bGwgPi9kZXYv
bnVsbCAyPiYxICYmIGVjaG8gMSkNCj4gPiArDQo+ID4gK2lmZXEgKCQoSEFWRV9PUEVOU1NMKSwx
KQ0KPiA+ICtDT05EX1BST0dTICs9IHBzcF9ncm8ucHkNCj4gPiArZWxzZQ0KPiA+ICskKHdhcm5p
bmcgZXhjbHVkaW5nIFBTUCBHUk8gdGVzdHMsIGxpYmNyeXB0byBub3QgaW5zdGFsbGVkKQ0KPiA+
ICtlbmRpZg0KPiANCj4gTG9va3MgbGlrZSBzbG9wLiBXaHkgZG8gdGhpcz8gSnVzdCBydW4gdGhl
IHRlc3QgYW5kIHNlZSBpZiBpdCB3b3Jrcy4NCj4gRG9uJ3QgaGlkZSB0aGUgcHl0aG9uIHRlc3Rz
IGJlY2F1c2UgYnVpbGQgd2FzIGxhY2tpbmcuIFdlIGV4cGxpY2l0bHkNCj4gd2FudCB0byBzZWUg
YWxsIHRlc3RzIHJ1biBhbmQgZmFpbCBpZiBzb21ldGhpbmcgaXMgbWlzc2luZyBpbiB0aGUNCj4g
YnVpbGQNCj4gc2V0dXAgaW4gTklQQS4NCg0KV2lsbCBkby4NCg0KPiANCj4gSWYgeW91IHJlYWxs
eSB3YW50IHlvdSBjYW4gInByb2JlIiBvciBkaXNwbGF5IHRoZSBzdXBwb3J0IGluIHNvbWUgLS0N
Cj4gaGVscA0KPiBtZXNzYWdlIGZyb20gdGhlIGJpbmFyeSBhbmQgY2hlY2sgYXQgcnVudGltZS4g
DQo+IA0KPiA+IMKgVEVTVF9HRU5fRklMRVMgOj0gXA0KPiA+IMKgCSQoQ09ORF9HRU5fRklMRVMp
IFwNCj4gPiDCoCMgZW5kIG9mIFRFU1RfR0VOX0ZJTEVTDQo+ID4gQEAgLTQwLDYgKzU0LDcgQEAg
VEVTVF9QUk9HUyA9IFwNCj4gPiDCoAlua19xbGVhc2UucHkgXA0KPiA+IMKgCW50dXBsZS5weSBc
DQo+ID4gwqAJcHBfYWxsb2NfZmFpbC5weSBcDQo+ID4gKwkkKENPTkRfUFJPR1MpIFwNCj4gPiDC
oAlyc3NfYXBpLnB5IFwNCj4gPiDCoAlyc3NfY3R4LnB5IFwNCj4gPiDCoAlyc3NfZHJ2LnB5IFwN
Cj4gPiBAQCAtNjQsNiArNzksOCBAQCBURVNUX0ZJTEVTIDo9IFwNCj4gPiDCoA0KPiA+IMKgVEVT
VF9JTkNMVURFUyA6PSBcDQo+ID4gwqAJJCh3aWxkY2FyZCBsaWIvcHkvKi5weSAuLi9saWIvcHkv
Ki5weSkgXA0KPiA+ICsJLi4vZ3JvX2xpYi5weSBcDQo+ID4gKwkuLi9wc3BfbGliLnB5IFwNCj4g
DQo+IHVnaCwganVzdCBtb3ZlIHRoZSB0ZXN0IGRvd24gdG8gdGhlIGRydi1uZXQgZGlyLCBhbmQg
WGZhaWwgZm9yDQo+IG5ldGRldnNpbS4gQm90aCBQU1AgYW5kIEdSTyBsaXZlIGluIC4uLyBiZXR0
ZXIgdG8ga2VlcCB0aGlzIHRlc3QNCj4gdGhlcmUgYXMgd2VsbC4NCg0KSXQgd2FzIHRoZXJlIG9y
aWdpbmFsbHksIGJ1dCBJIGZpZ3VyZWQgc2luY2UgUFNQIGlzIGEgSFctb25seSBwcm90b2NvbCwN
CnRoZSB0ZXN0IGJlbG9uZ3MgaW4gaHcvLiBCdXQgSSdsbCBtb3ZlIGl0IGJhY2ssIGl0IG1ha2Vz
IG1vcmUgc2Vuc2UgaW4NCnRoaXMgY29udGV4dC4NCg0KPiANCj4gPiArIyBUZXN0cyBmb3IgYm90
aCBJUCB2ZXJzaW9ucywgYSBzdWJzZXQgb2YgZ3JvIHRlc3RzLiBNaXNzaW5nOg0KPiA+ICsjIC0g
dGNwX2NzdW06IFBTUCBwYWNrZXRzIGFyZSB2YWxpZGF0ZWQgYnkgSFcgKHdpdGggdGhlIElDVikg
YW5kDQo+ID4gbWFya2VkIHdpdGgNCj4gPiArIyBDSEVDS1NVTV9VTk5FQ0VTU0FSWS4NCj4gPiAr
X0NPTU1PTiA9IFsiZGF0YV9zYW1lIiwgImRhdGFfbHJnX3NtbCIsICJkYXRhX3NtbF9scmciLA0K
PiA+ICJkYXRhX2xyZ18xYnl0ZSIsDQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgICJkYXRhX2J1
cnN0IiwNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqAgImFjayIsDQo+ID4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgICJmbGFnc19wc2giLCAiZmxhZ3Nfc3luIiwgImZsYWdzX3JzdCIsICJmbGFnc191
cmciLA0KPiA+ICJmbGFnc19jd3IiLA0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoCAidGNwX3Nl
cSIsICJ0Y3BfdHMiLCAidGNwX29wdCIsDQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgICJpcF9l
Y24iLCAiaXBfdG9zIiwNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqAgImxhcmdlX21heCIsICJs
YXJnZV9yZW0iLA0KPiANCj4gUmVhbGx5IG5vdCBncmVhdCB0aGF0IHdlIGhhdmUgdG8gZHVwbGlj
YXRlIGFsbCB0aGUgY2FzZXMgdW5kZXIgcHNwLg0KPiBOYXJjaXNhIGlzIGFkZGluZyBCSUcgVENQ
IGNhc2VzIGZvciBpbnN0YW5jZSwgaG93IGFyZSB3ZQ0KPiBnb2luZyB0byBrZWVwIHRoaXMgaW4g
c3luYyA6Uw0KPiANCg0KV2lsbCBkcm9wIHRoZSBsaXN0cyBhbmQganVzdCB1c2UgdGhlIGdyb192
YXJpYW50cygpIGdlbmVyYXRvciwgd2l0aCBhDQpmaWx0ZXIgb24gdG9wIHRvIGJlIGFibGUgdG8g
YXZvaWQgc29tZSB0ZXN0cy4NCg0KQ29zbWluLg0K
