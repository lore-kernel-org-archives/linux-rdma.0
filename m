Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011067.outbound.protection.outlook.com [52.101.52.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7558B3BBFA7;
	Mon, 10 Aug 2026 11:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786362502; cv=fail; b=WOa8usgpJwzZ1KjDutYRUD8JY8oqDhWY7bX4v5k5ZChpm1xatGYsgrE/aosrwler6RM4/td3flKD787oraMP1qh7wutFMCRRwtgHCKlT+oowB7U9ZTVCQ+zZinWv/lDnOHoRTOj/etc6mp7ndWBwhyjkl2KfY2G4lmrIjN48pVM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786362502; c=relaxed/simple;
	bh=dSYNaFqDCtqR4GIH/jJeYgEDt3gxd7+lFiunCKzUZ+0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kxGciN3OUsD9QmacvF2GFv3hSGEUJ4DsfmTl5tM/nhY/std0J/sOeaKeGGjsqEj4C7VOEwAi7C/Au73k6cCbvWq5+wQ5/9ZOTXZMjp9Vl65lCAg8We48jb2EYjGS/8JpRZCm3i3zO5wxeg0rlrI35OOLlpaW0CabtKwXc5IHdIs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fptYB4OR; arc=fail smtp.client-ip=52.101.52.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fptYB4OR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TRBqMIotUOo7tvYW4J/pWhpzPAfi7/vOeZ1br+xEAnermO9UTP/raQoVf8OgkZ68BwrBrNU/I9EkLAo55iH1hXiYjmq4l0NfYaUDClud/XfW4+sDOza2DbiDLAlEv/oOxQYYMX71bcwSggcr1ADustHPBmHlXnAwoI/qwtDupMo3iek1fZL8bVebXU9OABRvNehHXJh8dz5QHAkrHEUnFBL+855JmXWeFCqhkTuWPpP9QzEFmRFfHL1peuEbDqt0QvD3zX53e74T/wgAv3w54DxwrRl+wIg81YAQAN2lZYUaiEtQss51C/3eSDibmQYFuJCGIFO0rQdWwnl2sBQ3nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dSYNaFqDCtqR4GIH/jJeYgEDt3gxd7+lFiunCKzUZ+0=;
 b=JamIWZ/uU//6FSuFbVqsK/pQZPEcjc4OMSd4Q1wfGwhbabidrI9nH4L1ejSLYms2kgWQqv0vqRdATy+0TWgpFy/zFKAMvEOJxLyIkfswDJmJ6AhkHQi2oxF7I1EMeIPfLTKxGSRPZDNI8Ztshn1qMRx+SBH9YH+JkN2R3IDTI/3TGiGitW12C53cRauh3rWWX3yYFhDLd5keQKDI+MFSAZ0+C6Q80bVKtYgC4I2c5MkTSnxLl9J/gd6sX9ANDtU4ST7XubfmlItoUEut5X6cnY9XK6d1VMRCKI+LkJHx6D4RSlBLkkXR4u7kIe2PixG/EDtbpsN1XMUxiit76EC2eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dSYNaFqDCtqR4GIH/jJeYgEDt3gxd7+lFiunCKzUZ+0=;
 b=fptYB4ORGFrdMVtjGYEc5ONMzG1ULnSTIa8GQRLA8Rk/IpUuiYh0MUxZFulE+aPXhfrrIBuW6qGBJRiGRsVrH+gHDM7F9uKqDTBTCpE6LoXbzqpZnTZqIC2p3xMsFD100ZiCyKkmEVri+012Vdv1Qg1XkAVZ0S/Un3pVQ8MDpQ2oGg3F5Ec+DYWoGhF2MT0GLizJMm02HF8QURoM9Di9yZbS3y3+R+GHeon7Oc1Z21deevU4bOQDcnEl2coC91YPN0/fyUFUkDSgU2f1PE2ul08TLqU08+v59CK9+ESV2KMXOnDGsOQvJfJrmJxqBC4TmmXNGCGA1m0m7yk/IyUnyQ==
Received: from DS5PPF266051432.namprd12.prod.outlook.com
 (2603:10b6:f:fc00::648) by IA1PR12MB6209.namprd12.prod.outlook.com
 (2603:10b6:208:3e7::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 11:48:13 +0000
Received: from DS5PPF266051432.namprd12.prod.outlook.com
 ([fe80::25c9:b561:2aea:8e3c]) by DS5PPF266051432.namprd12.prod.outlook.com
 ([fe80::25c9:b561:2aea:8e3c%3]) with mapi id 15.21.0292.022; Mon, 10 Aug 2026
 11:48:13 +0000
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
Subject: Re: [PATCH net-next V2 09/13] net/mlx5e: psp: Add an rx_decap
 steering table
Thread-Topic: [PATCH net-next V2 09/13] net/mlx5e: psp: Add an rx_decap
 steering table
Thread-Index: AQHdI+ya4v0+zDsChUG6aCZs3cYukraOIxqAgAkRSYA=
Date: Mon, 10 Aug 2026 11:48:13 +0000
Message-ID: <7a66866c0b66271924a07701911c2ec05f96e244.camel@nvidia.com>
References: <20260804083535.2946459-1-tariqt@nvidia.com>
	 <20260804083535.2946459-10-tariqt@nvidia.com>
	 <3a936f25-95b1-4b85-9d8d-d5ef9949b7d6@gmail.com>
In-Reply-To: <3a936f25-95b1-4b85-9d8d-d5ef9949b7d6@gmail.com>
Reply-To: Cosmin Ratiu <cratiu@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS5PPF266051432:EE_|IA1PR12MB6209:EE_
x-ms-office365-filtering-correlation-id: d4bc9dac-fdf2-463d-b32a-08def6d54234
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|22082099003|18002099003|4143699003|10067099003|56012099006|11063799006|5023799004|6133799003|38070700021;
x-microsoft-antispam-message-info:
 Osmr4nP6pX0ok2P5SmtLw7JGbWWRCz1MMTEByOVz5FC9Ev9yBkRCr54YF0ZabO1Kvbp9sp3GAuGILMbR0+SDFx73XVLqtfsE4OdJKSOc1HFTMfvwM52LpwdPc8VJR5u3kDwk4kHnIO76/rpzg54uCloRxrE1X+YLtibMsp94rzT0zPD0ZO3VrkK7gOnYdHEQIrvTrR4XO0a54cgBXrr0NLrAQJqTje2R/AbBZxkhxz20hW6giUvXY1BZIQwlZAneVc0P/WL48rKspsVt+z1PQB8QqVwfyX0cwZqKz2mmyvytytCrusXRpjCchzG2STHU/DFqgxI9VY0JxCRDr+uqqcQ2wu73ClHR967+HRaSkPLP+ckguEYvcHq20kuVv/Bp/LHyBWCu+R0l+B53NIuOVdcqJyBhSMgaTm9jVkImAv2Gip9c7hND1qeMEGut2e7Y/Bl7YmoK3OIS0kc/Lf7xs7GEqhJG7tcgN7a6sJq/gU5d/d3sWDOLLU6eVLWMV6raieR0myfx9gQB67/NpweBUSqmXSQX/eTUPEAQNFzxuOkEZE7H0PODQtFB50mZRQa0OYgHpBP+2ECNq3VSycTXEOVFs9KpLvA6K0V/MAcBDQFJQqcT63N5TWWeXSugCyFdeSIzoMnILmxanU5i1dGhsf61p+QMTos/LseeRGWUwntpKUcTJoXg+RXex4EdGBqdwe5B0LIgZRVhXC3b3/Y8oROAzJOKPZToBTs7fbE5nAU=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS5PPF266051432.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(22082099003)(18002099003)(4143699003)(10067099003)(56012099006)(11063799006)(5023799004)(6133799003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UXVGaitZZGhSNkVlSEx4QmVIbWtBaGRnQWtHNjRxUVk2aS9TNy9PbVdyVms0?=
 =?utf-8?B?V3d1WkJ5bk8zd3VQZFNybzdXTHhCZExROWdEN09tZmVmeHRUanBiYnZFVy9R?=
 =?utf-8?B?OHNrNVpWTkZod1psSmJzTjZUdlBSNk5GV0xrd1ppcVE5Nm9UYmpiQ05OV3V6?=
 =?utf-8?B?ZjlmL3Izbm42R1NwNVR2VHRyV0V2WTAvMzZLbTJMYkpnc2drcEN1MTAwTyt5?=
 =?utf-8?B?Zm83OU16Q3NseDFUZEdzdHMrWFBNNGVJbzZpVnlpWlRkeFF3MkdiVS9LMjR4?=
 =?utf-8?B?SHA4THluMkdSOGd4MXhFMk40UU1pN2crSmdsUDZsY0RRUGtuOThLZU9MYTlC?=
 =?utf-8?B?MndKbFVDS24wVENWUGtOL0VwbU00dDBtVzhvNmM5a2F4UEJNcjhwLzZMdWtv?=
 =?utf-8?B?VE9OaWd0MUFZTUVUOGM4NWt5MVN5Vk8ySlN3MzNMV3cvQWovcW4ydHh5ZFN2?=
 =?utf-8?B?eEx6Y2Z2WHhSQUVSdnl4eUQzU0s5RC9aa2cxWitydy9nL1NxRUpLS2QrWWFr?=
 =?utf-8?B?NXVoSkdPODY1Y2o1aWVZT0hZSlo0eldqbVJiOG1EQlUvdkczREY4RjM5N3ZX?=
 =?utf-8?B?ME5tQnh4UTRrTGswcDJNMEJlb2dlYWZPSE0vZ3FETkpaMWcxWWsrcU84dFA2?=
 =?utf-8?B?emRxTGF3Skd3UXhjMnMwZFVaYjJxM1BqcnFqQVRyOE1GWk5VMFMzWGNmMlox?=
 =?utf-8?B?eE9EbkljL0syaFVEYWNuWSt6UDdac0tMbEJlOUdsMVVRNU84ZHY5R05xKzgx?=
 =?utf-8?B?Z29zZ21ISzN2M0d1bG13c01HZDV6NDczNzlGQi9VR2hjTXE4UjJncC9yaGQx?=
 =?utf-8?B?UG5UNEI2cUZ0UFRNWHZiWTF1ZnQzbGVQcFJPUmMzNHUyaUdqYnFsTUhFVjVt?=
 =?utf-8?B?ejRNOHc1UmVxYVJwRHBWNXRpc1NkbnNrK1IwSlNEOVBzcTFyY0o0OHlmTnNP?=
 =?utf-8?B?YWFtQXkzUVNMVFpMRm1ud3dlcFpoNk9wYUFZaithR2ZYMGZwL1kzakg1TG1X?=
 =?utf-8?B?MVpnSDVkZUpvT3A5Yzl5V0tCeHdCK3l1WG5oRFlxODQ4U3lVbnVlTUI5bGRr?=
 =?utf-8?B?UWxBM285cjA3RVFoTE9lT3RzTWUxcGkyT1JJcHVmSDFTMTVVSkIwd1F2ZXBX?=
 =?utf-8?B?aGl6Y2FVRFozWFR1WmtBUU5ycngrdGJ3SzZEbFdzY3BPTDRyMmhNN0pBR29k?=
 =?utf-8?B?elFEU0h0M3dDREtmNHlOZllrdDluL2htK0R4aTB3RldoT0VTOWYrTHhONUx1?=
 =?utf-8?B?WlJ0Mk1TQzV6UzViM3R3U3U3NFk3SHJZejFzUXh4bkxuZTREaGNLYWtETDAv?=
 =?utf-8?B?MjhLRG9MbFdsV0gxSklwYWVkQ2d3QjJtbTNQcXB3YWU4b3IwdkdjQzUwbjhu?=
 =?utf-8?B?LzNTdzdxemRUMWdvdElYWXFPejRjZjBFRDVGMU02UlNJUUx5NE53VHRUeExC?=
 =?utf-8?B?MStjUkJyRi80bFZzVVhWdVNDTFpvZ2FVSFRGbGF0WjU5cTNnMWxxRFp1Q21I?=
 =?utf-8?B?OGFNcnIrSUVuYWw0cUtKK2o3aHl5dE8yaE9aNnYyNWRZdnpRV3AxR1lHZ3hU?=
 =?utf-8?B?ODFuU0IyV3VHeWZ3VTJ5QTZ0RmsxamZBazBRdVJxNHo3aHZ3ekpwVmpieVFq?=
 =?utf-8?B?VVY4dmkvYmVudTRlTFJHTTBaRk5lYUhRUG9LbUwxbWl5WHFURmRJWmV5a0Vh?=
 =?utf-8?B?b0c1Vk1qQ0YzUk5KSEJlbHFSdmJyUjRXT2FzYmdWWWlOUHNiT1RUYjJYT0tV?=
 =?utf-8?B?V1Z3dWtoZHFwN1hNcldmQkRGVCtkMlFkTldySEdKMUE1aVUxc2ZIZHJVUDlr?=
 =?utf-8?B?QVNGbU9wbzdQeFZaaU9vTUNabmNXSHlSaFlPMzZvdFkzTU1tUVllNkpwVC9R?=
 =?utf-8?B?a2tyNWU0WmhjNlhMMmZPWUZhN0FFOXZxRE1ZMFowa3M5bDlpZTI2MjZPUW1H?=
 =?utf-8?B?U05Jbi9TV0NkQWdtZFBMTFhnak5GR25TbXVsekl1TEEyZEFWaVppZVdGcWdQ?=
 =?utf-8?B?Z3B4bmFjeHVDUStnWVJRTzRxbTRMZ0w3R2hWRzRIOEVjV0F3Q1FCMTFmUWE2?=
 =?utf-8?B?ZnE3eXFWY2xEYTBpRlpwcVVxZGQ3WSsvdkF5c000VmJySk9BMkw0VlBsVHc2?=
 =?utf-8?B?WkE3bzhVeFVsRFdwOXU4ZU83WldicHFncGZBN04rc2tZT1VmcXRoN1RzUEVI?=
 =?utf-8?B?VlM5aUJ3L0JXMzVZS3kyUGF4RmZoRWhXUURpZE1jRHlIRHd0b0lHNW9PWW9U?=
 =?utf-8?B?emwzRVdxeG5pZElzSmEwWmxZcGNUV3ZETUU5MkJ6MWowOFR5M2JyYVR6bHFV?=
 =?utf-8?B?dEVqc2VHSWdpaURYWkJRNkN0L1JJODJLQkZMRzE0R1dBdWtjYVRVQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <023D0D2448A04240ACA977C48C43703A@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d4bc9dac-fdf2-463d-b32a-08def6d54234
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2026 11:48:13.2192
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NJBLZWtlb47eWHcBsItxppAfOhQwajqrTtZt3DpwN1E4zXzKPRfHjCqvmQwp/HQ2WEU+JPHopdbf/XKsrV8mEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6209

T24gVHVlLCAyMDI2LTA4LTA0IGF0IDEzOjE5IC0wNDAwLCBEYW5pZWwgWmFoa2Egd3JvdGU6DQo+
IA0KPiANCj4gT24gOC80LzI2IDQ6MzUgQU0sIFRhcmlxIFRvdWthbiB3cm90ZToNCj4gPiBGcm9t
OiBDb3NtaW4gUmF0aXUgPGNyYXRpdUBudmlkaWEuY29tPg0KPiA+IA0KPiA+IEludHJvZHVjZSBh
biBhZGRpdGlvbmFsIHN0ZWVyaW5nIHRhYmxlIGZvciBQU1AgdHJhbnNwb3J0IG1vZGUNCj4gPiBk
ZWNhcHN1bGF0aW9uLCBjb250YWluaW5nOg0KPiA+IC0gb25lIHJ1bGUgcGVyIHN1cHBvcnRlZCBQ
U1AgdmVyc2lvbiB3aGljaCBkb2VzOg0KPiA+IMKgwqAgLSB0cmFuc3BvcnQgbW9kZSBkZWNhcCAo
cmVtb3ZlcyBVRFArUFNQIGhlYWRlcnMgYW5kIFBTUCB0cmFpbGVyKQ0KPiA+IMKgwqDCoMKgIC0g
cmVjb21wdXRlcyBpcGgtPnRvdF9sZW4NCj4gPiDCoMKgwqDCoCAtIHJlY29tcHV0ZXMgSVAgY2hl
Y2tzdW0NCj4gPiDCoMKgwqDCoCAtIHJlcGFyc2VzIHBhY2tldCBoZWFkZXJzDQo+ID4gwqDCoCAt
IGNvcHkgU1BJIGludG8gcmVnX2IgKHdoaWNoIGVuZHMgdXAgYXMgY3FlLmZ0X21ldGFkYXRhKQ0K
PiA+IMKgwqAgLSBzZXQgYSBkZWNhcCBtYXJrZXIgYW5kIHRoZSBQU1AgdmVyc2lvbiBpbiB0aGUg
Zmxvd190YWcsIHNvIHRoZQ0KPiA+IFJYDQo+ID4gwqDCoMKgwqAgaGFuZGxlciBjYW4gbWFrZSBz
ZW5zZSBvZiB0aGUgcGFja2V0DQo+ID4gLSBkZWZhdWx0IGRyb3AgcnVsZSBmb3IgdW5zdXBwb3J0
ZWQgUFNQIHZlcnNpb25zIChwZXIgUFNQIHNwZWMpLg0KPiA+IA0KPiA+IFBhY2tldHMgYXJlIGZv
cndhcmRlZCB0byB0aGUgcHJldmlvdXNseSBhZGRlZCByeCB0YWJsZSwgd2hlcmU6DQo+ID4gLSBv
bmUgcnVsZSBmb3J3YXJkcyBVRFAgdHJhZmZpYyB0byB0aGUgVURQIGRlZmF1bHQgZGVzdGluYXRp
b24uDQo+ID4gLSBkZWZhdWx0IHJ1bGUgZm9yd2FyZHMgdHJhZmZpYyB0byB0aGUgVFRDIHRhYmxl
Lg0KPiA+IA0KPiA+IFRoZSByZWFzb24gaXMgdG8gYXZvaWQgc3RlZXJpbmcgbG9vcHMuIElmIHBh
Y2tldHMgd2VyZSB0byBiZQ0KPiA+IGluamVjdGVkDQo+ID4gaW50byB0aGUgVFRDIGRpcmVjdGx5
IGFmdGVyIHJ4X2RlY2FwLCBpdCBtYXkgYmUgcG9zc2libGUgdG8gY3JlYXRlDQo+ID4gYQ0KPiA+
IHN0ZWVyaW5nIGxvb3Agd2l0aCBSWCBwYWNrZXRzIG9mIHRoZSBmb3JtIElQfFVEUHxQU1B8VURQ
fFBTUC4uLg0KPiA+IFRoZSByeCBmbG93IHRhYmxlIGd1YXJhbnRlZXMgdGhhdCBwYWNrZXRzIGdv
IHRocm91Z2ggUFNQIHN0ZWVyaW5nDQo+ID4gYXQNCj4gPiBtb3N0IG9uY2UuDQo+ID4gDQo+ID4g
VGhlIHN0ZWVyaW5nIG1vZGUgaXMgc2F2ZWQgaW4gYSBuZXcgZmllbGQgJ2ZzLmRlY2FwX2VuYWJs
ZWQnLg0KPiA+IFVwZGF0aW5nIHRoZSBtb2RlIGlzIGRvbmUgdGhyb3VnaCBhY2NlbF9wc3BfZnNf
cnhfcmVjb25maWd1cmUoKSwNCj4gPiB3aGljaA0KPiA+IGNyZWF0ZXMgdGhlIGRlY2FwIHN0ZWVy
aW5nIHRhYmxlIGlmIG5lZWRlZCBhbmQgcG9zc2libGUuIEl0IHRoZW4NCj4gPiB1c2VzIGFuDQo+
ID4gYXRvbWljIHJ1bGUgdXBkYXRlIHRvIHJlZGlyZWN0IHRyYWZmaWMgdG8gdGhlIG5ldyB0YWJs
ZS4NCj4gPiBUaGlzIGlzIG5vdyBpbnZva2VkIHdpdGggZGVjYXBfd2FudGVkID09IGZhbHNlLg0K
PiA+IFRoZSBpbnRlbnRpb24gaXMgZm9yIGZhaWx1cmVzIGNyZWF0aW5nIHRoZSBuZXcgdGFibGUg
dG8gbm90IGJsb2NrDQo+ID4gZmVhdHVyZQ0KPiA+IHJlY29uZmlnLiBBIG1lc3NhZ2UgaXMgbG9n
Z2VkIHdoZW4gdGFibGUgY3JlYXRpb24gZmFpbGVkIGFuZCBQU1ANCj4gPiBmb3IgSFcNCj4gPiBH
Uk8gd2lsbCBub3Qgd29yayBpbiB0aGF0IGNhc2UuDQo+ID4gTm90aGluZyBoYXBwZW5zIG9uIEhX
IHdpdGhvdXQgdGhlIGFiaWxpdHkgdG8gZGVjYXBzdWxhdGUgUFNQDQo+ID4gdHJhbnNwb3J0Lg0K
PiA+IA0KPiA+IEFuIHVwY29taW5nIHBhdGNoIHdpbGwgYWRkIGR5bmFtaWMgcmVjb25maWd1cmF0
aW9uIG9mIFBTUCBzdGVlcmluZw0KPiA+IGJhc2VkDQo+ID4gb24gSFcgR1JPLg0KPiA+IA0KPiA+
IFNpZ25lZC1vZmYtYnk6IENvc21pbiBSYXRpdSA8Y3JhdGl1QG52aWRpYS5jb20+DQo+ID4gUmV2
aWV3ZWQtYnk6IERyYWdvcyBUYXR1bGVhIDxkdGF0dWxlYUBudmlkaWEuY29tPg0KPiA+IFNpZ25l
ZC1vZmYtYnk6IFRhcmlxIFRvdWthbiA8dGFyaXF0QG52aWRpYS5jb20+DQo+IENvc21pbiwgY2Fu
IHlvdSBUQUwgYXQgDQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8wZDcyYzViMi02ZDRj
LTQwZDQtOGNiZS04Y2Q5NWQ2MWEyMzBAZ21haWwuY29tLw0KPiDCoA0KPiBhbmQgbGV0IG1lIGtu
b3cgaWYgdGhpcyBpcyBhbiBpc3N1ZSBvciBub3Q/IEkgc2VlIHRoZSBwYXRjaCBsb29rcyB0aGUN
Cj4gc2FtZSwgYnV0IHdhc24ndCBzdXJlIGlmIHlvdSBkaWRuJ3Qgc2VlIG15IG1lc3NhZ2Ugb3Ig
aWYgaXQgaXMgYQ0KPiBmYWxzZSANCj4gcG9zaXRpdmUuDQoNCkFwb2xvZ2llcyBmb3IgdGhpcywg
SSB3YXMgb24gdmFjYXRpb24gYW5kIGNvdWxkbid0IHJlcGx5LiBBbmQgSSB0aGluayBJDQptaXNs
ZWQgVGFyaXEgaW50byB0aGlua2luZyB0aGlzIHdhc24ndCBhIHJlYWwgaXNzdWUsIHNvIGhlIHBv
c3RlZCB0aGUNCnNlcmllcyBhZ2FpbiAoQXBvbG9naWVzLCBUYXJpcSkuIEFzIG5vdGVkIGluIFYx
LCB0aGlzIHdpbGwgYmUgYWRkcmVzc2VkDQppbiBWMy4NCg0KQ29zbWluLg0K
