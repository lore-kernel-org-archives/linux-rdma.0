Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012013.outbound.protection.outlook.com [52.101.66.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4A638757D;
	Tue, 25 Aug 2026 12:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787659719; cv=fail; b=UZyraNhszNUenMdRsTLE+2MClsVJ1lzEd/OQI16SiqvpQnLki7R0/P9jtj/IWBDkSOJDvRko/obfwP1DED5u+o41ZFcnSGhY2Fmr4P/gESLhuhh0hJgEzMerLCgID3BRjKTX5V/GimzuMT74/Vq+ja4Lwo6qL0ipyweAhnB75Xg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787659719; c=relaxed/simple;
	bh=JndMmY0aqitSir/J1cGv10aqJg4mTm409o0QuRW1OXc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DXKaQlTLdl75cM/xnOJmkyUn7W7Ab9cvX1WA+mM3kOkRPoV5T/LyjbmzUeKJfmbH3282taZ0W3vbJaeeMTxPdERXztiGx4mDKaYeafPyLAa0dNJ5fv6q0egmI+bByeJWfz4JfZHS55hQEkuPggP/vOXSEdpi06XFG+0NzA7bj24=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=Z5L/RRbz; arc=fail smtp.client-ip=52.101.66.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="Z5L/RRbz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FtcOZKyq2ynHq76wnQZRjKHEPuFqqPWscCARR5fZXoWnbfSDEYUJCt6EoD+kELluSXql4EM6phf9BkGBeBWawJAmVwAyTA7uDHaPffApdVS2G/1oXMNIj3S/KUiQboFyyDxCIK41P5iEW07smEr1vR0c9NU3d9RSHG0tH4/30xddTE5jm+JdkN8nc1Dv2wmkrhQ7x5uXQduYQ4AT163w5cNm7VQAc6BHvtysRWWuwSNZCHR8AQoaQ/FtOMReNdWkXbQzVKddBzm6IQ7KwbMnM0WKOgeXWa1AHce5MtP79cdzg9kE1v/rSaK5pXM8tQwff0XvUecP5Ut/gsFmlA5EsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JndMmY0aqitSir/J1cGv10aqJg4mTm409o0QuRW1OXc=;
 b=ECNRh1OqYQZFUyLmjkkHX/r/q5paTT4JLurDmJWQo3VjTjm4Jf+7xXVMusFzjjY+fRGoQInVxZLuy4EnEhxPHHFDx17OdtkdWHvSJLFsctd8ifTm6IXhq8TncRj2mEV6peQvVthsiwXYLcSEqSk6Yux41aLeCxBjRW0XVXK2yikL3uYr3v61BjL2j/cXSrwU0Pzku50mru8a7zGomcIo71otMpBMcAUXuV0I25+emRKOqOcj9SKWzDy8o+B0XmGlukrcccU+dRjlLyaKbAe1FTl7S22geB7hb9E9xoHa9/D6qMy2bJ3020znkM32jOzcYlk+5gaIcijaWJYgzBwPJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass action=none
 header.from=nokia-bell-labs.com; dkim=pass header.d=nokia-bell-labs.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JndMmY0aqitSir/J1cGv10aqJg4mTm409o0QuRW1OXc=;
 b=Z5L/RRbzBjWAqk8pgwXkEIn7BwhHIBgU5MkFjBPEZIaLt2DqYiYcQdjTPmV6pzSSE6nLUs7697uIq35muI6SOBsO0BfoTJ2Mh/QzWbPXUZJjsbOgWf8ZWVaw7kXA7JyhI9b0S+w4U7k71CVCWRLPPdH9/Bb+qYQ3DL3u5PiXTNmKCTeZpGa4HL6D3ymNsGOW3SPoVB19BDEgQnko7URellQdvOQJNIw1BD6TTnfSb8x02dLmERTdriWqE7F8TjD7wfYlOkjcWCQGPEPVAyybXjs2zxSl2iLaj5eJhIKwUqjjp7ZgAvvqE3F4XwWtxr0TSxoZo0YUyBCNbjw+H+b5Pg==
Received: from PAXPR07MB7984.eurprd07.prod.outlook.com (2603:10a6:102:133::12)
 by PR3PR07MB8241.eurprd07.prod.outlook.com (2603:10a6:102:178::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.6; Tue, 25 Aug
 2026 12:08:32 +0000
Received: from PAXPR07MB7984.eurprd07.prod.outlook.com
 ([fe80::f708:4bd3:9987:b9e5]) by PAXPR07MB7984.eurprd07.prod.outlook.com
 ([fe80::f708:4bd3:9987:b9e5%2]) with mapi id 15.21.0360.005; Tue, 25 Aug 2026
 12:08:32 +0000
From: "Chia-Yu Chang (Nokia)" <chia-yu.chang@nokia-bell-labs.com>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>, Jakub Kicinski
	<kuba@kernel.org>
CC: Mirja Kuehlewind <mirja.kuehlewind@ericsson.com>, "shaojijie@huawei.com"
	<shaojijie@huawei.com>, "shenjian15@huawei.com" <shenjian15@huawei.com>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"eperezma@redhat.com" <eperezma@redhat.com>, "jasowang@redhat.com"
	<jasowang@redhat.com>, "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>, "mst@redhat.com" <mst@redhat.com>,
	"xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "edumazet@google.com"
	<edumazet@google.com>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "corbet@lwn.net" <corbet@lwn.net>,
	"horms@kernel.org" <horms@kernel.org>, "dsahern@kernel.org"
	<dsahern@kernel.org>, "kuniyu@google.com" <kuniyu@google.com>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "dave.taht@gmail.com" <dave.taht@gmail.com>,
	"jhs@mojatatu.com" <jhs@mojatatu.com>, "stephen@networkplumber.org"
	<stephen@networkplumber.org>, "xiyou.wangcong@gmail.com"
	<xiyou.wangcong@gmail.com>, "jiri@resnulli.us" <jiri@resnulli.us>,
	"davem@davemloft.net" <davem@davemloft.net>, "andrew+netdev@lunn.ch"
	<andrew+netdev@lunn.ch>, "donald.hunter@gmail.com" <donald.hunter@gmail.com>,
	"ast@fiberby.net" <ast@fiberby.net>, "liuhangbin@gmail.com"
	<liuhangbin@gmail.com>, "shuah@kernel.org" <shuah@kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"ij@kernel.org" <ij@kernel.org>, "ncardwell@google.com"
	<ncardwell@google.com>, "Koen De Schepper (Nokia)"
	<koen.de_schepper@nokia-bell-labs.com>, "g.white@cablelabs.com"
	<g.white@cablelabs.com>, Ingemar Johansson S
	<ingemar.s.johansson@ericsson.com>, "cheshire@apple.com"
	<cheshire@apple.com>, "rs.ietf@gmx.at" <rs.ietf@gmx.at>,
	"Jason_Livingood@comcast.com" <Jason_Livingood@comcast.com>,
	"vidhi_goel@apple.com" <vidhi_goel@apple.com>, Parav Pandit
	<parav@nvidia.com>, Willem de Bruijn <willemb@google.com>
Subject: RE: [PATCH v5 net-next 1/2] net: update comments for SKB_GSO_TCP_ECN
 and SKB_GSO_TCP_ACCECN
Thread-Topic: [PATCH v5 net-next 1/2] net: update comments for SKB_GSO_TCP_ECN
 and SKB_GSO_TCP_ACCECN
Thread-Index:
 AQHdJFkmsZErp6HN50yIAT4nHZCuDbaZmsyAgACaoWCAANzxAIAAlzCggACG4QCAARyLgIAAA24ggABKB4CAAFt1gIAAA6wAgBCZcOA=
Date: Tue, 25 Aug 2026 12:08:32 +0000
Message-ID:
 <PAXPR07MB7984F0C072220066856DD8ACA3AF2@PAXPR07MB7984.eurprd07.prod.outlook.com>
References: <20260804213510.673084-1-chia-yu.chang@nokia-bell-labs.com>
 <20260804213510.673084-2-chia-yu.chang@nokia-bell-labs.com>
 <20260811173017.3d18dfdc@kernel.org>
 <PAXPR07MB79849A3F1724DBB2DA8EA20AA3DC2@PAXPR07MB7984.eurprd07.prod.outlook.com>
 <20260812155430.6ec81eec@kernel.org>
 <PAXPR07MB7984E3E73868BF8966821C27A3DB2@PAXPR07MB7984.eurprd07.prod.outlook.com>
 <CAF=yD-LQbndjPZiXcfA6fMp6msza_+YdzqqwyeUDVTdOCOHhDw@mail.gmail.com>
 <47BE8A8A-F80C-4C30-BC95-C85FEBFFB606@ericsson.com>
 <PAXPR07MB7984ED42ED0849D3A9AB8C19A3DA2@PAXPR07MB7984.eurprd07.prod.outlook.com>
 <willemdebruijn.kernel.c248a28f9c86@gmail.com>
 <20260814120121.50e61d01@kernel.org>
 <CAF=yD-L1-Sxz9uyP_4WqtNRJHnwTVMhQba_KF-=Eiy=d9Jf-qA@mail.gmail.com>
In-Reply-To:
 <CAF=yD-L1-Sxz9uyP_4WqtNRJHnwTVMhQba_KF-=Eiy=d9Jf-qA@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nokia-bell-labs.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR07MB7984:EE_|PR3PR07MB8241:EE_
x-ms-office365-filtering-correlation-id: 66b91ab8-609d-4cbb-3b51-08df02a1952c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|38070700021|6133799003|5023799004|3023799007|10067099003|56012099006|11063799006|4143699003|22082099003|18002099003;
x-microsoft-antispam-message-info:
 ZuHoSQeYeTFdkJSzZCMGJ3hy9H9sPFqO/d7Dl+LKCeDdqc7/V+Cykg4i3fZA9z3c1aXMUisH6mMfUehi7ni22Ykhw3QUjWOzp/A7zlbKSa6WI8hIxlAzD39E8uImM6+y0U0q8LPil75zrMHR+9q58PPiRCCnH3tXnpZrsfWaFPXwtb3g1JPbMuTUHLmfpkOMpr+5e+pQTh/yh3qx9qeiWONjT9JzBxV9txwiMWyolvAOia67D14dkr2brKD+Bc8CaKSmM0dIMEFN8Hc6ndjRhhTb1X7ZJ+RlG5sYvsggXgtLc103vcRus/tnSkyuPrMV53Cl1h+KbQJNcEC+jNhh0qMmAOp54fM7wpWJvj1SEOjEEmZffzhW8Z2HsjWKtRL+ddREYseTHRYpVENluXWuyWhzQsM4IouWjlTqrVTH/a7rseeOLIH3CQnTgTqbL/LoubcRnUtHzrjSIqav/6TeUVCzUW0EkPUekGgzo7QVCZAroZcp3qVAghyA7YD9a2KOvzTuePioPVj2GjWTX7TVSAD6WoQwrb52r1EMQ1xE0Z6xsDOEswkDpApqg9Vd6EgRlB6IFVWu7D2mrDyAz1eiLs9w16FPhn5wE/6HYGx5/1gKEuSMOAJI7IzOfulid3J2hqkaB/JgmDWjLUx1XFjbTnNOtSuQG92EfqB93E9jLH759W1Rao219G9FdUaObf4ECqUWTgRtQZxKeztPzXuAvA0a6vx8W4F6QcRNN5QktGA=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR07MB7984.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(38070700021)(6133799003)(5023799004)(3023799007)(10067099003)(56012099006)(11063799006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?OG95cFJVRmVXanRNQnd1V2Rmc2Z2Qk1yb25maG1XdVNidlNYMGlnYWhxSFQ1?=
 =?utf-8?B?RnpnWkRyaFVkMEtZSjJPN1d1UXF0QkdRRkVza2FYc1Z2ak54a0h1QWl5amh2?=
 =?utf-8?B?ZnhLRHY2U2NXMlBNVDc1RlhTb2tCR2VQTFhoSDhUZG1LVDJCSE1wcHcrdVAr?=
 =?utf-8?B?NEF4WVVqK21ZM2FSdmZQWVZySHcrMFZzWXBmaVovWEk3bjFJcnY3ME81NFEz?=
 =?utf-8?B?aTVSWnZMeTgySUZLc0p5TkdWUUxEWTVjUmlWMENVYy9qcmNaZ3d2THlBd3p1?=
 =?utf-8?B?eWM1emRzY3hyTElSRnlRdGpwM1BoM2F3c0FGdlJqeW43WllXbEJDOUNUaCtI?=
 =?utf-8?B?YzRneE1VQmJGck8wbDlndnRrQlJUVW5pT1Z2KzBFNWVYKzc0TmJpbmF5bEM0?=
 =?utf-8?B?eVRpd2grcDlZOGtScE8xeU9UbnkwS3lENGFjU1BMWktONWNuTFFVdS9yYmVu?=
 =?utf-8?B?cVJSRFhzb3FzZjIxQTFhY3hnR01wdDVjMDczbzYyWmRlaFAxaE5ueE8yY3dJ?=
 =?utf-8?B?UXpmMTdQVmVKSVd0YVBHbnNxcEZNbkdqcHBpMjUxZktFZjZWSlpxRTN3UnJQ?=
 =?utf-8?B?Sk1OdkJ3TWlMSHgwa2VKRkZWTkhURzJvUU1WRW1BTngyb0VUdyt0VmRDL2x1?=
 =?utf-8?B?TWlSRUhoRG9yaGQvL1lNOFluZGgrQks0TWxFMmFOY2FMdXF6VFpqdkhiU2tK?=
 =?utf-8?B?RjVRQ0NPZFVySksxMmk4L01hdHFvQ204ZkY5WXZCL3oya3hrQTNlaGhyREQ0?=
 =?utf-8?B?TG9LVDlKQklWTDVyUU1RVFBlKzhoaDJLaVI5SExsVEVXdEtyM2lWZTI5NDk5?=
 =?utf-8?B?QmRIV0tGdUpGVHFnazBCdVM1RWdzNTcwWVArcWpsb2NQc1hMNW9LQjEzSlVz?=
 =?utf-8?B?enk1Q25BY1FYYURBaHhEbWpIVlQwYVpnZG5VNWRkMkpOQUttVkphOW00VEtB?=
 =?utf-8?B?d1kycXQ2TVhCZTBvS0VDZ0kzRlBvUXNzK3FDUFBYbmVkM0tmR3hKOGF6YldN?=
 =?utf-8?B?STd1ZUxsNjh2OGN5cXE2VWJoL25DUHJyVzJHQ3Fjd25VcHJYb2MwdFdlbm1Q?=
 =?utf-8?B?RFZ6RUJLanpwV29MTTNzWk9RMEIzSDc0R2hwak1qRS9YVnNGa2Z1REg4UmtC?=
 =?utf-8?B?VnJuZGE2cENRTGh2SUkyNzFuTXgrWVpFOGtIakVtRDN5Szh0OEVNVmVEUkpE?=
 =?utf-8?B?NGVUR2JFYW82bXlEcVN0M2MrVEFZTzhjL0xZVkRrWE9xcVFHRHRpZjFCUXk0?=
 =?utf-8?B?b3lrUEVHZzllMnY3akhBWWtjMy9xSFRCeUY0VjcwcGlrZUtBYjV5L3NzcGJp?=
 =?utf-8?B?Z0h0azk2VjcvcUI1VHFuZkZkTjA2TlQxbmVOMi9IQ0lLSGhVSEJiOWhNak5z?=
 =?utf-8?B?clV0QTlkYTNhemo0VnRuSnptOEtSU0N0Z2dpSkcrNzdoV0QyNU5MSWxTNDE5?=
 =?utf-8?B?RmcrejU4K0hEc013VURmbDZ6aEtYVEk5YmtnUVVPNjJIb3lsVG9QbEZTbDE2?=
 =?utf-8?B?K3I5MmxTUmZsMGxsYWxRbXVEQWZ5eVlBczkrbTNxUGNBbXZ3bVdGRTJWcis2?=
 =?utf-8?B?MTV4ZFFZZ1ZsZXAxSlFMbzl0WS9RN2RkaWljRXdYRlp0M2RSK2QwQXZUQ3RQ?=
 =?utf-8?B?aVBIWFFxOEZVUGZ5REg0Vlg2bkhiZnAzeFdWTnJTRTN6dmF4cHZCZ3NHRStO?=
 =?utf-8?B?Yy9kbkpabXprb0tqZ1Y2alZ1M2g4aVo3ekY5aVBSNHEvcVJTdTNPY3k0Y051?=
 =?utf-8?B?WVlncGsxcFl3TG5ZaEMvRlE1cERJclZ4dmV4eVNPQTdNSXpVcWt0WXduY3ow?=
 =?utf-8?B?OXl1eFViQW11dmltOW1xQmd2K3lVWWNXdisveDNCRjd3OHk4S0RVNzJ4VHhE?=
 =?utf-8?B?bmRPQzREdkJoeTJMLzdMSUVTWW14a29tc3FnSVhnVjlDejNuanNaUjdlbXpu?=
 =?utf-8?B?MXg5Vk41Zks1aHh5UlBiUkRkQW9nYTNOL1FFcGRZWGVLOG81KzNGa0dpdWx4?=
 =?utf-8?B?NVEzU09HTFZhZVhuM1kxSzVPR0c3L0JPWkEyU0g0NW9ncFNPODIzb2xpeTgw?=
 =?utf-8?B?bXVseXBWcVh4bDNoUUttMWkyOFZhVWZlalFTbHg2SWRoUG1WdmsrRlNESTZN?=
 =?utf-8?B?M0ZNR0ZDQ2pXMC92cCsrYkd1R1dscWpoWjFFN2N3Ukh5RnBFdjkvSnNSRkRh?=
 =?utf-8?B?djVIZUhua1JKMFM4RjF2Rk1BZk9PQnlUMU1IY09QcEc4Z2VsdzBmR081VWlq?=
 =?utf-8?B?SzB5VUpLZ041WXFPZk5wc3dOdVNBZE9VaWYzRTZKbSs4SU9VWnZGV3IvN29n?=
 =?utf-8?B?bWpFWlBqMjlnYW5VZkNNVUs0NFE0NWtjQTY2eUZ6OHByZnhwQllHelVNUmRE?=
 =?utf-8?Q?c9Kl7Nhducm9jVWA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR07MB7984.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66b91ab8-609d-4cbb-3b51-08df02a1952c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2026 12:08:32.5551
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UylxjgDOmci08/r+AG18C2qLljXpmOuwcVVVWJJddmtJm42GtuqiklYcm+f5CLeNAvTe39Pc8Lrk65ezvDZar/TtObwr+HA+6J6//BJcQubenYEy7Qe8JNMH+6W9Za0G
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR07MB8241

LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IFdpbGxlbSBkZSBCcnVpam4gPHdpbGxl
bWRlYnJ1aWpuLmtlcm5lbEBnbWFpbC5jb20+IA0KU2VudDogRnJpZGF5LCBBdWd1c3QgMTQsIDIw
MjYgOToxNSBQTQ0KVG86IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+DQpDYzogQ2hp
YS1ZdSBDaGFuZyAoTm9raWEpIDxjaGlhLXl1LmNoYW5nQG5va2lhLWJlbGwtbGFicy5jb20+OyBN
aXJqYSBLdWVobGV3aW5kIDxtaXJqYS5rdWVobGV3aW5kQGVyaWNzc29uLmNvbT47IHNoYW9qaWpp
ZUBodWF3ZWkuY29tOyBzaGVuamlhbjE1QGh1YXdlaS5jb207IGxpbnV4LXJkbWFAdmdlci5rZXJu
ZWwub3JnOyBlcGVyZXptYUByZWRoYXQuY29tOyBqYXNvd2FuZ0ByZWRoYXQuY29tOyB2aXJ0dWFs
aXphdGlvbkBsaXN0cy5saW51eC5kZXY7IG1zdEByZWRoYXQuY29tOyB4dWFuemh1b0BsaW51eC5h
bGliYWJhLmNvbTsgcGFiZW5pQHJlZGhhdC5jb207IGVkdW1hemV0QGdvb2dsZS5jb207IGxpbnV4
LWRvY0B2Z2VyLmtlcm5lbC5vcmc7IGNvcmJldEBsd24ubmV0OyBob3Jtc0BrZXJuZWwub3JnOyBk
c2FoZXJuQGtlcm5lbC5vcmc7IGt1bml5dUBnb29nbGUuY29tOyBicGZAdmdlci5rZXJuZWwub3Jn
OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBkYXZlLnRhaHRAZ21haWwuY29tOyBqaHNAbW9qYXRh
dHUuY29tOyBzdGVwaGVuQG5ldHdvcmtwbHVtYmVyLm9yZzsgeGl5b3Uud2FuZ2NvbmdAZ21haWwu
Y29tOyBqaXJpQHJlc251bGxpLnVzOyBkYXZlbUBkYXZlbWxvZnQubmV0OyBhbmRyZXcrbmV0ZGV2
QGx1bm4uY2g7IGRvbmFsZC5odW50ZXJAZ21haWwuY29tOyBhc3RAZmliZXJieS5uZXQ7IGxpdWhh
bmdiaW5AZ21haWwuY29tOyBzaHVhaEBrZXJuZWwub3JnOyBsaW51eC1rc2VsZnRlc3RAdmdlci5r
ZXJuZWwub3JnOyBpakBrZXJuZWwub3JnOyBuY2FyZHdlbGxAZ29vZ2xlLmNvbTsgS29lbiBEZSBT
Y2hlcHBlciAoTm9raWEpIDxrb2VuLmRlX3NjaGVwcGVyQG5va2lhLWJlbGwtbGFicy5jb20+OyBn
LndoaXRlQGNhYmxlbGFicy5jb207IEluZ2VtYXIgSm9oYW5zc29uIFMgPGluZ2VtYXIucy5qb2hh
bnNzb25AZXJpY3Nzb24uY29tPjsgY2hlc2hpcmVAYXBwbGUuY29tOyBycy5pZXRmQGdteC5hdDsg
SmFzb25fTGl2aW5nb29kQGNvbWNhc3QuY29tOyB2aWRoaV9nb2VsQGFwcGxlLmNvbTsgUGFyYXYg
UGFuZGl0IDxwYXJhdkBudmlkaWEuY29tPjsgV2lsbGVtIGRlIEJydWlqbiA8d2lsbGVtYkBnb29n
bGUuY29tPg0KU3ViamVjdDogUmU6IFtQQVRDSCB2NSBuZXQtbmV4dCAxLzJdIG5ldDogdXBkYXRl
IGNvbW1lbnRzIGZvciBTS0JfR1NPX1RDUF9FQ04gYW5kIFNLQl9HU09fVENQX0FDQ0VDTg0KDQoN
CkNBVVRJT046IFRoaXMgaXMgYW4gZXh0ZXJuYWwgZW1haWwuIFBsZWFzZSBiZSB2ZXJ5IGNhcmVm
dWwgd2hlbiBjbGlja2luZyBsaW5rcyBvciBvcGVuaW5nIGF0dGFjaG1lbnRzLiBTZWUgdGhlIFVS
TCBub2suaXQvZXh0IGZvciBhZGRpdGlvbmFsIGluZm9ybWF0aW9uLg0KDQoNCg0KPiBPbiBGcmks
IEF1ZyAxNCwgMjAyNiBhdCAzOjAx4oCvUE0gSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9y
Zz4gd3JvdGU6DQo+ID4NCj4gPiBPbiBGcmksIDE0IEF1ZyAyMDI2IDA5OjM0OjAxIC0wNDAwIFdp
bGxlbSBkZSBCcnVpam4gd3JvdGU6DQo+ID4gPiA+IEN1cnJlbnQgU1cgR1JPIHNldHMgU0tCX0dT
T19UQ1BfQUNDRUNOIHdoZW4gdGhlIGZsdXNoZWQgc2tiIGNhcnJpZXMgQ1dSIGluIHRjcF9ncm9f
Y29tcGxldGUoKToNCj4gPiA+ID4gaWYgKHRoLT5jd3IpDQo+ID4gPiA+ICAgICBzaGluZm8tPmdz
b190eXBlIHw9IFNLQl9HU09fVENQX0FDQ0VDTjsNCj4gPiA+DQo+ID4gPiBBbmQgSSBzdXBwb3Nl
IGl0IGZvbGxvd3MgY29ycmVjdCBBY2NFQ04gcnVsZXMgZm9yIGNvYWxlc2NpbmcuDQo+ID4gPg0K
PiA+ID4gVGhhdCBpcyBhIHBlcmZvcm1hbmNlIHJlZ3Jlc3Npb24gZnJvbSBSRkMgMzE2OCBFQ04s
IGFzIGl0IGFsbG93cyBmb3IgDQo+ID4gPiBsZXNzIGVmZmVjdGl2ZSBjb2FsZXNjaW5nLiBJIGhh
dmUgbm8gaW50dWl0aW9uIGhvdyBtdWNoIGl0IHdpbGwgDQo+ID4gPiBkaWZmZXIgaW4gcHJhY3Rp
Y2UuDQo+ID4gPg0KPiA+ID4gPiBGb3IgSFcgR1JPIG9mIGEgbGVnYWN5IGRldmljZSB0aGF0IGlt
cGxlbWVudGluZyBSRkMzMTY4IHNlbWFudGljcywgc2V0dGluZyBTS0JfR1NPX1RDUF9FQ04gc2Vl
bXMgcmVhc29uYWJsZS4NCj4gPiA+ID4gSG93ZXZlciwgc3VjaCBhIGRldmljZSB3b3VsZCBub3Qg
YmUgYWJsZSB0byBwcmVzZXJ2ZSBBQ0NFQ04gc2lnbmFsaW5nIGFjcm9zcyB0aGUgR1JPL0dTTy4N
Cj4gPiA+ID4gSW4gdGhhdCBjYXNlLCBpZiBwcmVzZXJ2aW5nIEFjY0VDTiBzaWduYWxpbmcgaXMg
cmVxdWlyZWQsIGRpc2FibGluZyBIVyBHUk8gbWF5IGluZGVlZCBiZSBuZWNlc3NhcnkuDQo+ID4g
Pg0KPiA+ID4gUmlnaHQuDQo+ID4NCj4gPiBJJ20gc3RpbGwgbm90IGZvbGxvd2luZy4uIE1heWJl
IFdpbGxlbSBjYW4gRUxJNSB3aGF0IHRoZSBwcm9ibGVtIGlzLg0KPiA+DQo+ID4gX1NXXyBHUk8g
Zm9sbG93cyBvbmx5IHRoZSBBY2NFQ04gcnVsZXMuDQo+ID4gQnV0IGlmIEhXIEdSTyBmb2xsb3dz
IFJGQyAzMTY4IGFuZCB3ZSBtYXJrIHRoZSBhZ2dyZWdhdGUgYXMgDQo+ID4gU0tCX0dTT19UQ1Bf
RUNOIC0gVFNPIHdpbGwgYWxzbyBhYmlkZSwgYW5kIHNlZ21lbnRlZCBvdXRwdXQgd2lsbCBiZSAN
Cj4gPiBpZGVudGljYWwgdG8gcHJlLUdSTyBpbnB1dC4NCj4gDQo+ICsxDQo+IA0KPiA+IEFyZSB3
ZSB0cnlpbmcgdG8gYmFuIFJGQyAzMTY4IGJlaGF2aW9yIGluIEhXIHB1cmVseSB0byBtYXRjaCBT
Vz8NCj4gDQo+IEkgdGhpbmsgdGhhdCdzIHRoZSBpbnRlbnQgaGVyZT8NCkhpIFdpbGxlbSwNCg0K
SSB0aGluayB3ZSBjYW4gc3RpbGwgY2hhbmdlIFNLQl9HU09fVENQX0VDTiBpbnRvIFNLQl9HU09f
VENQX0FDQ0VDTiBvbiB0aGUgUlggcGF0aCwgZXZlbiBpZiBIVyBHUk8gYW5kIFNXIEdSTyB1c2Ug
ZGlmZmVyZW50IGFnZ3JlZ2F0aW9uIHJ1bGVzLg0KQ3VycmVudGx5LCBTVyBHUk8gZmx1c2hlcyB3
aGVuIHRoZSBDV1Igc3RhdGUgY2hhbmdlcyBhbmQgc2V0cyBTS0JfR1NPX1RDUF9BQ0NFQ04gd2hl
biB0aGUgcmVzdWx0aW5nIHNrYiBjYXJyaWVzIENXUj0xLg0KDQoNCkZvciBIVyBHUk8sIGlmIHRo
ZSBkZXZpY2UgZmx1c2hlcyBpbW1lZGlhdGVseSB3aGVuIGEgQ1dSPTEgcGFja2V0IGFycml2ZXMs
IHRoZXJlIGlzIG5vIG5lZWQgdG8gc2V0IGVpdGhlciBTS0JfR1NPX1RDUF9FQ04gb3IgU0tCX0dT
T19UQ1BfQUNDRUNOLg0KSW4gdGhhdCBjYXNlLCBlYWNoIENXUj0xIHBhY2tldCBpcyBlbWl0dGVk
IHNlcGFyYXRlbHksIGFuZCB0aGVyZSBpcyBubyBuZWVkIHRvIHByZXNlcnZlIG11bHRpcGxlIENX
UiBpbmRpY2F0aW9ucyB0aHJvdWdoIEdTTy4NClNvLCBpZiB0aGUgSFcgY2FuIGJlIGNvbmZpcm1l
ZCB0byBhbHdheXMgZmx1c2ggQ1dSLW1hcmtlZCBwYWNrZXRzIHdpdGhvdXQgY29hbGVzY2luZyB0
aGVtLCBwcmVzZXJ2aW5nIG11bHRpcGxlIENXUiBpbmRpY2F0aW9ucyB0aHJvdWdoIEdTTyBpcyBu
b3QgcmVxdWlyZWQuDQpJbiB0aGF0IGNhc2UsIHVzaW5nIFNLQl9HU09fVENQX0FDQ0VDTiB3b3Vs
ZCBub3QgcHJvdmlkZSBhbnkgYWRkaXRpb25hbCBiZW5lZml0Lg0KDQoNClRoZSBwcm9ibGVtYXRp
YyBjYXNlIGlzIHdoZW4gYSBIVyBHUk8gYWdncmVnYXRlcyBtdWx0aXBsZSBwYWNrZXRzIGNhcnJ5
aW5nIENXUj0xIGFuZCBvbmx5IHNldHMgU0tCX0dTT19UQ1BfRUNOLg0KRHVyaW5nIEdTTywgb25s
eSB0aGUgZmlyc3Qgb3V0cHV0IHNlZ21lbnQgd291bGQgY2FycnkgQ1dSPTEsIHdoaWNoIGxvc2Vz
IHRoZSByZW1haW5pbmcgQ1dSIHNpZ25hbGluZyBpbmZvcm1hdGlvbiByZXF1aXJlZCBieSBBY2NF
Q04uDQpJbiB0aGF0IGNhc2UsIGNoYW5naW5nIGZyb20gU0tCX0dTT19UQ1BfRUNOIHRvIFNLQl9H
U09fVENQX0FDQ0VDTiB3b3VsZCBwcmVzZXJ2ZSB0aGUgb3JpZ2luYWwgc2lnbmFsaW5nIGJ5IGVu
c3VyaW5nIHRoYXQgdGhlIHNlZ21lbnRlZCBwYWNrZXRzIGNhcnJ5IHRoZSBjb3JyZWN0IENXUiBp
bmZvcm1hdGlvbi4NCkFzIEkgdW5kZXJzdGFuZCBSRkMzMTY4LCByZWNlaXZpbmcgYWRkaXRpb25h
bCBDV1ItbWFya2VkIHBhY2tldHMgaXMgaGFybWxlc3MsIGJlY2F1c2Ugb25jZSBhIHZhbGlkIENX
UiBoYXMgYmVlbiByZWNlaXZlZCwgdGhlIHJlY2VpdmVyIGFscmVhZHkgc3RvcHMgZWNob2luZyBF
Q0UuDQpBZGRpdGlvbmFsIENXUiBpbmRpY2F0aW9ucyBkbyBub3QgY2hhbmdlIHRoZSByZWNlaXZl
ciBzdGF0ZS4NClRoaXMgd291bGQgaGF2ZSBhIHBlcmZvcm1hbmNlIGltcGFjdCBzaW5jZSBpdCBk
aXNhYmxlcyBIVyBUU08gZm9yIHRoZSBza2IgYW5kIGZhbGxzIGJhY2sgdG8gc29mdHdhcmUgc2Vn
bWVudGF0aW9uLg0KQnV0IElNTyBpdCBwcmVzZXJ2ZXMgY29ycmVjdG5lc3MgZm9yIGJvdGggUkZD
MzE2OCBFQ04gYW5kIEFjY0VDTi4NCg0KDQpCZXN0IHJlZ2FyZHMsDQpDaGlhLVl1DQo+IA0KPiA+
DQo+ID4gPiBBbmQgdGhlcmUgY3VycmVudGx5IGlzIG5vIGtlcm5lbCBBUEkgdG8gZGlzYWJsZSBv
bmx5IEVDTiBjb2FsZXNjaW5nLiANCj4gPiA+IE5FVElGX0ZfR1JPX0hXIGVuYWJsZXMgb3IgZGlz
YWJsZXMgSFctR1JPIGVudGlyZWx5Lg0KPiA+ID4gT3IgZXZlbiB0byBzaWduYWwgd2hldGhlciBh
IEhXLUdSTyBpbXBsZW1lbnRhdGlvbiBpcyBBY2NFQ04gY2FwYWJsZS4NCj4gPiA+DQo+ID4gPiBE
aXNhYmxpbmcgSFctR1JPIGNhbiBiZSBhIGh1Z2UgZWZmaWNpZW5jeSByZWdyZXNzaW9uLiBJIHN1
c3BlY3QgbWFueSANCj4gPiA+IHVzZXJzIHdpbGwgcHJpb3JpdGl6ZSB0aGUgZWZmaWNpZW5jeSBv
dmVyIHByZXNlcnZpbmcgdGhlIEFjY0VDTiANCj4gPiA+IHNpZ25hbC4NCj4gPiA+DQo+ID4gPiBU
aGF0IHNhaWQsIHNvbWUgZGV2aWNlcyBtYXkgaGF2ZSBvdGhlciB3YXlzIHRvIGNvbmZpZ3VyZSBz
dWNoIGZpbmVyIA0KPiA+ID4gZGV0YWlscyBvZiB0aGVpciBIVy1HUk8sIGV2ZW4gdGhvdWdoIG5v
dCBhdmFpbGFibGUgdGhyb3VnaCBFdGh0b29sLg0K
