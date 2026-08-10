Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011061.outbound.protection.outlook.com [52.101.52.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9AF3C3C02;
	Mon, 10 Aug 2026 11:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786362413; cv=fail; b=l1iFJnTy0KMHePabAx3tNmneBNOjJsCUWo/eUL2V7n+JNP2RvKIDsUEWP6i4FuwbSje/XZJ//qCSwS6sAKRrVEmnv8RadO6JPddQJaWEJ2pmhKlYmBAl2zj8onHud8bDMjYIq3PZub3CY4hSHqUdLuAjzZZIKC5Y8tNqyTqz+Tc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786362413; c=relaxed/simple;
	bh=DpXqTCzBU0FoZbLdcDf6UiHfgP1ERT5Kuq5vQpeISyk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WTpO/ON5xzGfleSeejX7Lz0MYlRaqQcrVePxJMJzV7q4SluCwDgnUkZf51YVSnzuX+fN9y/dYY1unsAg04pwtMOZJsdabb3+MQMgtrBzySFhhcNUf5MeGQPEw7bBBosmAHDP3Qa004JofIcVjr+yhhU5M6xt8jSsjGstw2hYmyI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ooDfHuTo; arc=fail smtp.client-ip=52.101.52.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ooDfHuTo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZKiyWzkHtWd7gBAY/ZzBYj3EicGAMcGEPJgQDZYMaCp1tybzSLS8grBfloAsAUgc/AjKDPWV8SKEY13i9XUCYjuvntrNaqiv1DHwfd1rqaAQ2I+DTJdHpzG4L8eHXGh2z5ndS1d0Nh2IbJuCGJgLvYC25g06g42PPi4F6VQV7qUTVhZKn8yJeG3hnFKGCBd6TtHqcbPf2WwoPBnAgWPK2a4njqdpj2wMQ1g89mGk1U+Yd7g6TZQKGBYS2M6vhS0giw4iFlWKG1rEjxU3DUy6S2HxzRr8bedGQgv6cGiZdB8eN8lun+nXCs8KqpoGCED++QIJDxu7ITisJ6jiB/DoVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DpXqTCzBU0FoZbLdcDf6UiHfgP1ERT5Kuq5vQpeISyk=;
 b=vypE89ykDhHphggePtNhfrSoRrsmwecIbLQZZEvy/AEsRZ9zUoPIpnUKdpvL7q1d0o1VXUGf+LJN20Cmf3zIIIeI5owG+br+hI3WcATh5kdL+DPX7xw7OtnVYIlBf098T2XrLbVE3Z7eAivNKfqtA14ybU6iuYyOXWS/3SnJSvRFFBS/mWwKbk7uHzsP3lo7QRi97zYhT81ALq0IOvX6gIQq1vFxwaSJ5XJG+aXRTHrkfkrlU5hI45THK4dahsFQD2d4N7zpi1kAaZlin3yw38liSnBxYcth5bminRxDdwH332ihYDURSVgtYzY/sG5Wdvx2l0OrKOGTgv6TitN9UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DpXqTCzBU0FoZbLdcDf6UiHfgP1ERT5Kuq5vQpeISyk=;
 b=ooDfHuTooZSWgfwkZlGedbJMt/BOtFMvGmVG4HGnl4u2wC1YoI3O357QbRMIEUCixmIkRorkyGtIS2IEnWK0TlV3NXjFQse/+543tfuYy2/Osmc36HnQDFz8dAAmscZq6uBi0KGtz1XqJsq8smlrTb9s1AS7fgG2UdyeLbFCXbkFj9yW9cArcLwwC2qLNvBMrAcNfQ33QpB7ZFV5b0QHM7ijjLSUcLPSjVa1yqp71foCBCOwmxEk+tyl7o3U/KzDLvbU/9KTrIY9Somc40VHmty+tYrKUXA8KvlFpW8sOc+S1dPFo30lsYmFK7Lx4Gz8hk89LtY3SqFukJdymuE09w==
Received: from DS5PPF266051432.namprd12.prod.outlook.com
 (2603:10b6:f:fc00::648) by IA1PR12MB6209.namprd12.prod.outlook.com
 (2603:10b6:208:3e7::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 11:46:46 +0000
Received: from DS5PPF266051432.namprd12.prod.outlook.com
 ([fe80::25c9:b561:2aea:8e3c]) by DS5PPF266051432.namprd12.prod.outlook.com
 ([fe80::25c9:b561:2aea:8e3c%3]) with mapi id 15.21.0292.022; Mon, 10 Aug 2026
 11:46:46 +0000
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
Subject: Re: [PATCH net-next V2 08/13] net/mlx5e: psp: Handle HW-decapsulated
 RX PSP packets
Thread-Topic: [PATCH net-next V2 08/13] net/mlx5e: psp: Handle HW-decapsulated
 RX PSP packets
Thread-Index: AQHdI+yXvLu5v7hFQEq9ml22V6oC9LaOJwiAgAkM8wA=
Date: Mon, 10 Aug 2026 11:46:46 +0000
Message-ID: <bc8477dc4d17edd21245d1594e837d6aab17c223.camel@nvidia.com>
References: <20260804083535.2946459-1-tariqt@nvidia.com>
	 <20260804083535.2946459-9-tariqt@nvidia.com>
	 <0b3278c9-550e-4b72-8469-00c86180c2ea@gmail.com>
In-Reply-To: <0b3278c9-550e-4b72-8469-00c86180c2ea@gmail.com>
Reply-To: Cosmin Ratiu <cratiu@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS5PPF266051432:EE_|IA1PR12MB6209:EE_
x-ms-office365-filtering-correlation-id: 285b4874-13b6-43f8-c5ca-08def6d50e76
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|22082099003|18002099003|4143699003|10067099003|56012099006|11063799006|38070700021;
x-microsoft-antispam-message-info:
 1CNqOO8zu2YhOkiWtmFtXeeZQflKQqmROpQ1SB6nyzrtkZSfizlUywm9OhUW6R5ICKgJncaDlShLYiRmsWYdAv85jttM22+z3RBgJaoC+3ot0afpbFD69CytFbNq+ZMvmogN2xSWitoYADmbRuv0UeEL6KtLiPOnMXiQP1+mV1kM8BUKvswHxEVXoT228Wd+GhGGHNPkxF8rz7iy7dc+3yi5IJ8tfp+7NZpStHX1lxztCSAa51z16yUC9Yqp5msu59ffxZB85rSJOUBVbXqRtfjv8Qkr6IsHa69gp2nj9Sw6u+BszhnELmBjOj37oI1I5/hrN35OqzO9O+qiqvXuyYp1yLpCYHzJ6l7dj3bP5fu8FVDQsEz/RWXsciITGfOR00D9FHe4M5sD9ZIWIHaNLmsamg4apNLOnPVth6LW5pKWMeovaD3X85zAMkyDlXAcJLpqHtEcZDi0xetaSCjXtPrGdp6yjbbXNcb/xUezHiCoQYXuV4/e2w0M656VNxxtWZB4th0ittxbH5V35KDr0nOBfX3U/AqewmcX5DMcGV14nMLmD0wbv+4iClNl2sLrWLSiCE/5VW3lp98FERPDCEqkqPzv/OdrRhixsoIBhRhXwUvUyqPUQvtCtUs5PwiL1eAQWuZhXUOOoBaxaDd7NS63RBWLkn0ZWq/1+xvYde+Oiuf7o5S7mIYFgPvon5qWR7ViXfbeKIQe26Zjo14lvLAn8PS8xWQRhSw+D09waZw=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS5PPF266051432.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(22082099003)(18002099003)(4143699003)(10067099003)(56012099006)(11063799006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UkNoc3JMbm9qS1huTERHZUk2TE55NDEzVm8rbDVoNTUrMVZ5aWg5M2VKai9R?=
 =?utf-8?B?NmtseTN1TFYzL0RBRy9UdXM1QWVlWEd4RGRoTEFnMHByUERHYnJrNXdpVnpv?=
 =?utf-8?B?VGNJK0sxS0owQW5yZVY4SHQvU0tPZWxaNTRUcC96dEM3NU51SHZkVjkxQm9i?=
 =?utf-8?B?TzFLc1hIZ1cwVEpKc1BQbTlJUjJQUXBJeGZEc3NWcVlhbnhRRnpzcTNVeGV0?=
 =?utf-8?B?TGdmN3cvZGE5TGtlSU9rQWdWL2FQakd2SGRZVzAvWG5wM0NpQUJvVlhCV2kx?=
 =?utf-8?B?R0FwTmhCUHNoYkRoRkx4djdORGRVMW1ydnJ0MUhrUmMxcXdLdThNUHg0Wmtx?=
 =?utf-8?B?allydjJldk1GVFFBdy9NM1FjZ3FDek9zVVVhQW93ZzgxK0JjdzFFU1JmRlEz?=
 =?utf-8?B?eHMzTVJYdllGV2k5Zks4SndIbzJPVy8vZ1Y3aTRRays3T3VOWXIvdzYxdFQ1?=
 =?utf-8?B?eTBJdjFTSmdBOXYzbE5KbUVFeG9SYk5qWFpiRkR3OUtMbndrU09hU25ZaU9Q?=
 =?utf-8?B?T2ttSXpESG10N3VvZWpmRzJqSHUxTm1hNHpodUJINnR4TEJXcWRELzNzeHVE?=
 =?utf-8?B?Sk03eDlRRERaMWNpdmtwOW9zbDc1Y3pOazJwUEp1Q3hOQ2R0a0RYcFRBK0RD?=
 =?utf-8?B?VFFZR1BSTFRUOXczaGg5YitOUHRvdzhPcWNIeWw1T1gxb3FXOFd0ZlBtb1Av?=
 =?utf-8?B?eFhneitqaGdSUzN0Ymo0dnhTRlgvdXoxYUg1TnVBd0s0ZGVOT0w2UjBQeDZC?=
 =?utf-8?B?T3E4bXVlbHp1ZU0yUUxyMDZuVGhXaFl2Tkp6bXVIRXlNdCtuYmxkTkgwcEdz?=
 =?utf-8?B?QkZodlJYSHZxTk94b3dzSTlnT3R3eTVwOGt5a0doL0JUMlZyaGl4LzFlN04w?=
 =?utf-8?B?dkJsTHQ4eWplOVVlL0J1TzlPb3lHNUpuYWpTWkxRVHlaVW4yOXRSRjZNZnJq?=
 =?utf-8?B?c2RjVzR5MlhiMUdCMHZaTDBRMllCcys4MHRicnBMZElESktUTGJzVkwyeW5Y?=
 =?utf-8?B?cUVpWWxuUWhuTEV1dUp6bzVHb1FnQjlVVnpTQjBROFMzaW1iaEMrY085Sytz?=
 =?utf-8?B?dTBmNUdoaDNUK2txMWFUNThVbDJDckYwdGE5eGJPdHlMbE9UYUNxM250dnFL?=
 =?utf-8?B?YXEvZG1RamttMTk1RzF0M2lWR1Y3NThHM1FKZi9hRElyV0xxem93SnNzZlJT?=
 =?utf-8?B?Tkg1RUh5dTB3bHZ1MTQ2SnNIU05YZlZyWFZGVUYwenpjUjF6aFFvMjlGVzBV?=
 =?utf-8?B?RWgxN2h4MkxIMUQ4b0o4WUViUW9mb29wWVBHUDRtbnFBV2NGWUZFZXBLSVNQ?=
 =?utf-8?B?cTF2Wnp0OTJHWHo3a204em12VDRWL1dzbDlRWDUvSHBvekd5ZWVseHFYdzJH?=
 =?utf-8?B?dGkyZ2Y4KzRqWGEvQjN3clVVZ2t5MkZwT0x3UmZsUC8vUE1DVWdJVjdreXEx?=
 =?utf-8?B?RHN5VVZram1tM1NJMkJBYzlya25jMmxON3dtNTlYMzJ3cmFFUE5KS2NFbEtt?=
 =?utf-8?B?dGlmYlFQb3ZkNURRYkh1NTVWOFR4QjhMZzJmQTFIUm55eG5kWDh3UFIrK2dn?=
 =?utf-8?B?RnFtY1g4bEZhT3dvUDJmYjVzZnlhUk1nZGdjWG92R3M2MThCb3ZmK2U2MnJ2?=
 =?utf-8?B?bnd1MnF0c2ZZT0gvS2orMFZTY21aSHZKbjdiUXp3ZmxERC9WTmYwS2lkSlRG?=
 =?utf-8?B?YzJFYmxHa1NKMk1NdEZNNkRsZnNTcGtIUHR5MTJlWWloNHZKOFZTd1FZWllw?=
 =?utf-8?B?Vk5tc09DTktNRmhPd2g1bnhybVd2ZXo5RERQTXlFNTdhRlpVaVJBRmZQcGc0?=
 =?utf-8?B?QXNEckhWekhybVhYU2p1TTIrWHZvM2dDRzVMTFNOREtFamgwL3FnVkZlNTdD?=
 =?utf-8?B?MUxNb09MQzVMdWxLa3pDd0ZLdnJwQ21EM1R0ZWlMRHEwQm1IeENVQ243b1RQ?=
 =?utf-8?B?OFBLYTBaODdSOGYrTSt5NXE3bU5xbmtETXAxcU5xcTR3R2ZWZGU4MFVuNWNI?=
 =?utf-8?B?aUIyd25sUWNGaGoxZ2ZteTlVQm5HVnV6Zlh6NXByaVZ4WnB6bUg3aEFXRm9a?=
 =?utf-8?B?VUN3Zk5TS2xtSHJ5U2xuVFpHUVBKcXd2Zy9GUDZGUUVuSmg2SVZQeHVhZWVX?=
 =?utf-8?B?TXAraS9RSmZ6SlRYTUx6NGZENTFGZVVsSXdqcmFGM1JaYVUxU2VIZk95S1BP?=
 =?utf-8?B?dWZXTmtNRjUrVHR5MW5mRkFxNmFveVMxMDRBVWhYaDBKTlpkSXlIRlFOZFNs?=
 =?utf-8?B?QVBad2FvcXZ1eVFJaFAwaFR6WTJYWllsUGpKOFdtcDNnVGFiTm1DQkhacW1K?=
 =?utf-8?B?OWdKYUJRb1J6OGJvTW42eXRKZi9vbytHMWR6QncwWDdjc0JtWkpEZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2778704F2F41A6418D2745E710B9986E@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 285b4874-13b6-43f8-c5ca-08def6d50e76
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2026 11:46:46.3518
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xxULis/KSScJCoF0g0Dun3Kwo52jBy/4KBxNTU0aK6Pd8qd6EUiEyBKQQ9t9mO+OYWRPysGQe7vsJq7cHq99FA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6209

T24gVHVlLCAyMDI2LTA4LTA0IGF0IDEzOjM0IC0wNDAwLCBEYW5pZWwgWmFoa2Egd3JvdGU6DQo+
IA0KPiANCj4gT24gOC80LzI2IDQ6MzUgQU0sIFRhcmlxIFRvdWthbiB3cm90ZToNCj4gPiDCoCAj
ZGVmaW5lDQo+ID4gTUxYNUVfQUNDRUxfRkxPV19UQUdfUFJPVE9fTUFTSwkJR0VOTUFTSygyMywg
MjEpDQo+ID4gQEAgLTI1LDYgKzI3LDEwIEBADQo+ID4gwqAgI2RlZmluZSBNTFg1RV9BQ0NFTF9G
TE9XX1RBR19QUk9UT19JUFNFQwkoMSA8PCAyMSkNCj4gPiDCoCAjZGVmaW5lIE1MWDVFX0FDQ0VM
X0ZMT1dfVEFHX1BST1RPX01BQ1NFQwkoMiA8PCAyMSkNCj4gPiDCoCAjZGVmaW5lIE1MWDVFX0FD
Q0VMX0ZMT1dfVEFHX1BST1RPX1BTUAkJKDMgPDwgMjEpDQo+ID4gKyNkZWZpbmUgTUxYNUVfQUND
RUxfRkxPV19UQUdfUFJPVE9fUFNQX0RFQ0FQCSg0IDw8IDIxKQ0KPiA+ICsNCj4gPiArI2RlZmlu
ZSBNTFg1RV9BQ0NFTF9GTE9XX1RBR19QU1BfVkVSX1NISUZUCTE3DQo+ID4gKyNkZWZpbmUgTUxY
NUVfQUNDRUxfRkxPV19UQUdfUFNQX1ZFUl9NQVNLCSgweEYgPDwNCj4gPiBNTFg1RV9BQ0NFTF9G
TE9XX1RBR19QU1BfVkVSX1NISUZUKQ0KPiANCj4gWy4uLl0NCj4gDQo+ID4gK3N0YXRpYyBpbmxp
bmUgdTggbWx4NWVfcHNwX2dldF92ZXJzaW9uKHN0cnVjdCBtbHg1X2NxZTY0ICpjcWUpDQo+ID4g
K3sNCj4gPiArCXJldHVybiAobWx4NWVfYWNjZWxfZmxvd190YWcoY3FlKSAmDQo+ID4gTUxYNUVf
QUNDRUxfRkxPV19UQUdfUFNQX1ZFUl9NQVNLKSA+Pg0KPiA+ICsJCU1MWDVFX0FDQ0VMX0ZMT1df
VEFHX1BTUF9WRVJfU0hJRlQ7DQo+ID4gK30NCj4gbWF5YmUgR0VOTUFTSygpL0ZJRUxEX0dFVCgp
IHdvdWxkIGhlbHAgZGVhbCB3aXRoIHRoaXMgYml0ZmllbGQ/DQoNClRoYW5rcywgd2lsbCBkbyBp
biB0aGUgbmV4dCB2ZXJzaW9uIGFzIHRoZXNlIG1ha2UgdGhlIGNvZGUgbXVjaA0KY2xlYW5lci4g
SSBhbHNvIGFkZGVkIEZJRUxEX1BSRVAgaW4gdGhlIG1peC4NCg0KQ29zbWluLg0K
