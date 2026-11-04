Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793791217;
	b=jmNnYT69n8q92dpgqs85RKppn2EYY9f5WDzbBHu3/duc+Ln378LkRqvqiK8yPfmFaQDR
	 jmBzmTAJ/uhcwk6jHMQNH6BYKcpPbXy5iRjeg2LbFTLJVbZZZAxZovS5Z21VJftFdsnSH
	 L0VVT0liujuUciEL8G70LLx/08rBmDpOVbQgnqnc4R2eKDHb8yXPqQx1NqRlnF1rR7JkI
	 ad5OIJs4eKQrrhAaQO72anN2NAENPg83WKINEpY0HxC1JqW1hbnTY1CsGYyL4nZ4NYxAJ
	 lyE4o0WMgZATZeCc8oRh0WFDo5Z4rkT6qmg75xmiYm8wGeaG3Ogm5v8dah+jqn+6gcA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793791217;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
	 X-MS-TNEF-Correlator:x-ms-publictraffictype:
	 x-ms-traffictypediagnostic:x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-senderadcheck:x-ms-exchange-antispam-relay:
	 x-microsoft-antispam:x-microsoft-antispam-message-info:
	 x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:Content-ID:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=PB0SYS1LG41csbnfRfm0a7jHH6DfMhTadDleE5RAS1M=;
	b=EvQqUKdiA1sK01UT+vUuZ3ZbcFVVIOKJrQhGR7as2E6Fpeyhh5sK38NoSasmuW2lrdtc
	 VCZGwhEOa8tUDWQpyq598wxAAvRQFWwCSldR8LbZmCvzG1ynmVDT//wcJp7aI91ykvkXz
	 YLi5Y7ho59f21FWbu/tnxtU2SybECPG0HEq+xpFpoWpqckidrIs8pMMOmlSqQBJWlEEjk
	 y0uo9YAvQOEulRNr8XhApr71Jnj1crWcF3oB+NbmVwlblD4NoVuZoEWjn3Q8QJyzB38YL
	 qxZqJgF9+hOBtXxZiiNkuNtcVOhoDx27Sw9uatXBh65BJ6djNF5Ccgu3MFPTHjmfZhg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="dk9uy8Z/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.47
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012047.outbound.protection.outlook.com [40.107.200.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59676606A31B;
	Wed,  4 Nov 2026 11:20:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59676606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=dk9uy8Z/
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ahYtuQF9r85NucjGCFrHHEP3YG0fluJBErsMyJUKV1NriYJU3KH8GMMkpvKWADlqlCA8T5prQYV925IuKS5FMZMl1sLvL8eVCTIvuRMvzkDYm2p6qetLJK+rtQQ4t/0KhYngFOyjGtU3fTS1lh71+8qhoBT1FaZIMdTR3L1xQJrMbFVGWU68bfh/5OqfbSBBtqmRqVvTj+g8tCNNKhlRafyj2w6GKmeTadybFwnZF1YQawAgzgcs8Ln4bhOw2tKycKvEILXrS5qXTEMDW2DzdV28dWtMdy4NxGnDW08b/QjW9qFp0it6pUUwMIkBJCw+ZG5YdT2GOo6+6g/GQohP/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PB0SYS1LG41csbnfRfm0a7jHH6DfMhTadDleE5RAS1M=;
 b=ywHX4zuP5PESnqyF+ne/irMjNkgvox/nL4ia45C4gQuhlUTi8R6tXCUnSuyLHM4IJggD8nsTjpqWN+hehN5IjYwmkJTwmdzY91bWNQWbhnsya5xPfjbbbGRnLiigJQHpNix2ccr5vbbzUQxIW6MtGbbMLdSqVmcoOkii5uiO7fnctDJLOctGnagtJUqqpF80W9S/GQG1GuZZig6w6PlyG4oM4nadXXeUaYA+nBg0Zl5NO5oN6TZRLM9MtvzCNDmd0YWBC4DxJI2P0ZZqg4Thb+kx0RBPJMSSr5KstQlIhvPbWDH0tOiRQwTW4WG7Mwvx9/u6y1BDT7fNFhl2Jkh3kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PB0SYS1LG41csbnfRfm0a7jHH6DfMhTadDleE5RAS1M=;
 b=dk9uy8Z/T6R9socGVfzNAv3Tru2ZUa3HEOXzS1qCRoxZvJZPlKr9WrgzscqxcEUI90XkRTyytzxmXL0WQi7YiLD9KWmutIHrAbZsddeDd8e/B74Zhx0vKDCrCzAAH38pfeWjVNnnM/2n+ZpomRFZr6lSF+sOQWZsrnC4K2TwFAYzc5ilqUPeqQaAxnWuZo1dITjj3SMxjtuGvvgDdLsPTMFgaCNG341/ntpfGrz9KaHhi0tmSAuGdyygKEgKQCeZR6pJ7YYjRSjFKfgM578zq3iFTpZY1YT+wccHHA8HokWA32iqNgWOqQ+1UQHN18MyDwnSrd5jtvNNUQ9qmu0+lw==
Received: from DS5PPF266051432.namprd12.prod.outlook.com
 (2603:10b6:f:fc00::648) by IA1PR12MB7568.namprd12.prod.outlook.com
 (2603:10b6:208:42c::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Wed, 4 Nov
 2026 11:20:12 +0000
Received: from DS5PPF266051432.namprd12.prod.outlook.com
 ([fe80::9cef:7e0f:2134:13fe]) by DS5PPF266051432.namprd12.prod.outlook.com
 ([fe80::9cef:7e0f:2134:13fe%3]) with mapi id 15.21.0592.007; Wed, 4 Nov 2026
 11:20:11 +0000
From: Cosmin Ratiu <cratiu@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>, "joasantonio108@gmail.com"
	<joasantonio108@gmail.com>, Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, "leon@kernel.org" <leon@kernel.org>
CC: "andrew+netdev@lunn.ch" <andrew+netdev@lunn.ch>, "edumazet@kernel.org"
	<edumazet@kernel.org>, "davem@davemloft.net" <davem@davemloft.net>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"sd@queasysnail.net" <sd@queasysnail.net>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"horms@kernel.org" <horms@kernel.org>, "kuba@kernel.org" <kuba@kernel.org>,
	Boris Pismenny <borisp@nvidia.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>
Subject: Re: [PATCH net v2] net/mlx5: macsec: free struct mlx5_fs_id after an
 RCU grace period
Thread-Topic: [PATCH net v2] net/mlx5: macsec: free struct mlx5_fs_id after an
 RCU grace period
Thread-Index: AQHdZliUvYi59+u/PUORNVhruXmISbcd0CyA
Date: Wed, 4 Nov 2026 11:20:11 +0000
Message-ID: <e91e786d3bf20ed981ab2d214ae3358d137d597e.camel@nvidia.com>
References: <179313582625.87630.11382992904624255106@gmail.com>
In-Reply-To: <179313582625.87630.11382992904624255106@gmail.com>
Reply-To: Cosmin Ratiu <cratiu@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS5PPF266051432:EE_|IA1PR12MB7568:EE_
x-ms-office365-filtering-correlation-id: 58bf22e2-5c31-4924-66f8-08df3a659787
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|23010399003|1800799024|366016|261009223027099003|38070700021|261021123027099003|261021121427099003|5023799004|11063799006|56012099006|261028144727099003|261022105027099003|261022075727099003|261026121527099003|261026140227099003|10067099003|18002099003|261102123227099003|22082099003;
x-microsoft-antispam-message-info:
 4sYRywgLqiaXbKg6eo4ryDrWuxYYuNBXreIP/43AneJ8AwDACOI1Affy4XpPl/mT3N0sAdsKK7CjPUAVlChUM57iMs1RA1X/ki/qN313eAOpe01kAE6p3HAj0pMhgGODIbBmpSbVruDnFhMu0Mh6u5MEz5WLe1JEZpLdTu8s3AC5h3T5mfQctZHRbCnBeU+TOgsLeFXTF+Q/ysxyyLofEK/in2zeAKIJcYwEgzeJvonYzo6bomOotcrG9JJVqW5CUt9rOR23O3L4mL/BBinQzxemCYM0+ZWOStEE37DEeIbmr7QlNe7MIRUbGRBafezzX2BetAOmMcShMPaeWEN3bT1T/VuGpoVdqIXBffdwm/wdqiqYMuKwJUNivuIvyGXltnJKk1DEhhvJpsQvayMoGfzQGb8f8YQjlKHnHZlfI2UqQge2KnewmPs793PH+CFp6E9MYVLnjHvDv7HOqulnPooCwXAQMnVto4E6ey0Qi2ZSHL2uPWLZmriV7mZ3adofPH7z9uyaawRBGxxkW7xSuEQsVh1O+dKzEKaO5JF6LCMjzBP5CFFyjGRi0Tpvlrc/QOzxbJftZSEjcXn9pk7EPidTI0OhOcBl6V8YLDAD5hlA6CTmgcqK129xI++Qe6lxwMKuNnKga4Zwu78/IqAMnDj/81lWn2qSZ7iqYJGVSRXxeErCzYToYpQHP4HZg9duNZnDXvYMYhhGv+Y1iemf9WNmrN2CLLVAZtlfF3IGtcg=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS5PPF266051432.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(1800799024)(366016)(261009223027099003)(38070700021)(261021123027099003)(261021121427099003)(5023799004)(11063799006)(56012099006)(261028144727099003)(261022105027099003)(261022075727099003)(261026121527099003)(261026140227099003)(10067099003)(18002099003)(261102123227099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cC9zODJESXgxM2RKa3VnaGN1OFBzQy9wWXUrbDZ4SEdHVDZBNFZBMm5Gbmg2?=
 =?utf-8?B?Q2VHZ0ZkTmJ5NUN1c3NSUEg3NllDdzUvbVd2T3RBajRwSWZHUTA3RjZYTXlC?=
 =?utf-8?B?V05VT2JQZGtTa3VDeDZtcytYbTRMTjl1VnViT1VCeHhsakNKUENJcU5ZMnhL?=
 =?utf-8?B?Zm93bENOc2JZSyswS0U4dmdHdXhyMDExazNjRlZ2dVN0OEkrMEt5ZDQ1MWlM?=
 =?utf-8?B?M09uSUZ3TFpEeXd1WUtuMWlJT2h6ckNhMjVjV0cxMlZJUUwzQ2VSbnNkTGJ4?=
 =?utf-8?B?V0lyeU1tVEdlc21HQ1g3elNad3RyTWcxSFZpeStYY0EwZDc4SnRkR3Fpdkxi?=
 =?utf-8?B?T2NCeUxsTVZYKysvRFNoMlZub0RNNEFESlZVNU81bm5jdTBCS3N2ZHVramZT?=
 =?utf-8?B?RGVQdzdHMmpoRDM0Sjd1RGFKUTErbGxDejZwVlRzMW95QWVSU1ZybkdRc3VZ?=
 =?utf-8?B?TWdVOXZKY3RIZ1ZzUW1JM0ZGQ2dEYXFJU3N4ZDk5SGJsZEE4aHMydGRiYTVs?=
 =?utf-8?B?dUpMdzhnbFMvN1dzV3NTZHl6VllKV3NFOHRNd2hDNG9zRElDL0VMQnFXajdI?=
 =?utf-8?B?Q2xjQlI4cURtRy9BNFV2aFNtVmQ3TnRWL1Jub3NuSWZXd0o2RVpKa0szU3h1?=
 =?utf-8?B?b291elB6Sm9XQnVjdFQrSzdhdExKcGRtaExsaUs4L1ZDc3BDTFQ1S1ZlV1Fw?=
 =?utf-8?B?Zmlka05Bc2Fad29VaEZyKzRQd3Z5UWFOWEtoQ0d2bUlSbTIxcjFpNEczVDJ0?=
 =?utf-8?B?RVExVCtFYk5IWldBd0pOcXo1RDhlSTFwdkZhdVNhbDB1azFPMnp5THZZTGtn?=
 =?utf-8?B?WWdGUE03ZEcxRldtWm9kYmsxRVJRNVdZSHRPaEZTRFRCWFJTMlgrbnJFYXZ0?=
 =?utf-8?B?eHZxcjFvZjV6dnc1MVh2QWtnV3lZblp6WmFqMkN0ZU4xYnozUEF2YXJqLzVO?=
 =?utf-8?B?QTREajAzYXBpVnRvV3ptZUU1VC9PMFExK3lBb1QveEtZVTgrbDFLOW43eWVy?=
 =?utf-8?B?MVA4Z0lULytUVDFOY0lrZDN2R1RvSFdNNktjd2dLeHVEQmpWZG1YNXBjcTQ5?=
 =?utf-8?B?RlNLTWFPeEo1bWFuTWY1MCsyRTNhcWZmdmlCVU5HTTFyY3BTbDNvNTVWRmtn?=
 =?utf-8?B?RVdOc0hkb3ZmRTBKT1lMNjZUa3lDL29TbkxWMFhrbGJYK3dqV2t6eVhvWU5H?=
 =?utf-8?B?WWF1TU45cXdvdkdINVVpSkNOc2pCMUdHVEFqSDBxdWs0VDJlb2pMOFdPK2xa?=
 =?utf-8?B?Q2NaQm9oMGlzdVdVS3Q2WnBTeWhQTEIyZXRtNVZUSzROenU0RlNIeTk3UEZy?=
 =?utf-8?B?bG1YaEwvUWdXazRNdE50cU4zazJXNmJDcW1aMytvanBRcDlmdGhmcjd4T3F1?=
 =?utf-8?B?MkRpK29ONk5XeW5PUEU2emdibGMxOW1yNmk1Qk5pbXNsVU1HUzA3cXoveEpQ?=
 =?utf-8?B?WjYxaE9VUkdpcHhwNG1PSzNBL1J0QStyRnNzK2tlRTRiYWtHMGtKSzVTb09Y?=
 =?utf-8?B?S2ZmQ2hnanJEQlprQlpVQ0RhQ2Y1dUx1aDVodFAzajRpVkFLb3paVkxQUlhO?=
 =?utf-8?B?eUNJMzFPQytSZmYyTCt5SkJpVUpHY2c2YXlGL0FqemtJQ1k1NmJNc0lzMFFQ?=
 =?utf-8?B?bjlPbkN4emRZMFYxWG91VFQyelZxUlRlUFEzMG1zeXdpaDFYWTZPUm5iK3BF?=
 =?utf-8?B?b2VDNCtaS20xTjRNcTlBN1JVNzBveEt2TEEzL095UWg3RTM4Nk5mTzJMWUxz?=
 =?utf-8?B?MnBKa1dmaS96SjVhMllTMFYveUswcSsvUGVibzhWTjdabUZtSm5iMDl1SERH?=
 =?utf-8?B?dnI3L0JnSFpDN3NJdHdKWFdwdmhjb1J4M0pwUDE1V3lPS1lxMWhndU95RmJw?=
 =?utf-8?B?ZjFLNE9qajFwLzU2dXh5aGdCYjlqMEFLVllmb0FVOXJQWlRzWGMzWC82Mng4?=
 =?utf-8?B?MklHNkd6M3RtczNjOFZYUERVbjZtbzg2aWo3WTh2blRNQU1qNnV5T0gwVGFD?=
 =?utf-8?B?NGVJT3U3Tyt5Y1I0YXBLVkZYeTF3aENUeTZUOEY4cTlyOFZ3YnpURlA3K01L?=
 =?utf-8?B?S2xUQXRYdEVaZlNuV0QzOENoamdZamQzU1FJLzZjNnl2UlZJL2FROHpVMXA1?=
 =?utf-8?B?UnJkb0ViYjlGU1dMU083aGx1cGlwbGJRMjhMcER3d3JTL2xtclpwb0hURmN3?=
 =?utf-8?B?NDVQN1lrTkRidk5jRlEvVWVWbDR4Sy9ULzJscHk3clJxTHZxdmlReitNU2Rm?=
 =?utf-8?B?bDAwR2h0L05QdHM4cDJlcUFkVllreVQ4LzFRb3F6SWZIMFZ2Z2VuZVpOY1Rn?=
 =?utf-8?B?b0FOWkVLaHZzRjFMREZGRzd0WjdFaVYrZWtBekZqdG1uSEVXLzExQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <35D998EE1024CB47ABEEE305168A09EB@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS5PPF266051432.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58bf22e2-5c31-4924-66f8-08df3a659787
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2026 11:20:11.7666
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MSQG1DKRnQLJrg5/ay+IYWXc04qnOAb3ebzmph6hJ2t7HiGJ4ZzItEeT6wmea7s9GfpFh0e6z5RI0nneu7mCjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7568

T24gVHVlLCAyMDI2LTEwLTI3IGF0IDE4OjE3IC0wMzAwLCBKb2FzIEFudG9uaW8gZG9zIFNhbnRv
cyB3cm90ZToNCj4gbWFjc2VjX2ZzX2lkX2RlbCgpIHJlbW92ZXMgYSBzdHJ1Y3QgbWx4NV9mc19p
ZCBmcm9tIGl0cyByaGFzaHRhYmxlDQo+IHdpdGgNCj4gcmhhc2h0YWJsZV9yZW1vdmVfZmFzdCgp
IGFuZCB0aGVuIGZyZWVzIGl0IHdpdGgga2ZyZWUoKSByaWdodCBhd2F5Lg0KPiANCj4gVGhlIFRY
IChTQ0kpIHRhYmxlIGlzIHJlYWQgbG9ja2xlc3NseSBmcm9tIHRoZSB0cmFuc21pdCBwYXRoOg0K
PiBtbHg1ZV9tYWNzZWNfaGFuZGxlX3R4X3NrYigpIGFuZCBtbHg1ZV9tYWNzZWNfdHhfYnVpbGRf
ZXNlZygpIGNhbGwNCj4gbWx4NV9tYWNzZWNfZnNfZ2V0X2ZzX2lkX2Zyb21faGFzaHRhYmxlKCks
IHdoaWNoIGRvZXMNCj4gcmhhc2h0YWJsZV9sb29rdXAoKSB1bmRlciByY3VfcmVhZF9sb2NrKCkg
YW5kIHRoZW4gcmVhZHMNCj4gbWx4NV9mc19pZC0+aWQuIEEgdHJhbnNtaXQgdGhhdCBsb29rZWQg
dGhlIGVudHJ5IHVwIGp1c3QgYmVmb3JlIGl0DQo+IHdhcw0KPiByZW1vdmVkIHJlYWRzIGZyZWVk
IG1lbW9yeS4NCj4gDQo+IEJlZm9yZSBjb21taXQgZDRlY2UwOGY0YjFkICgibmV0L21seDU6IE1h
aW50YWluIGZzX2lkIHhhcnJheSBwZXINCj4gTUFDc2VjDQo+IGRldmljZSBpbnNpZGUgbWFjc2Vj
IHN0ZWVyaW5nIikgdGhlIFNDSSB0YWJsZSBoZWxkIHN0cnVjdA0KPiBtbHg1ZV9tYWNzZWNfc2Eg
ZGlyZWN0bHksIGFuZCBtbHg1ZV9tYWNzZWNfZGVsX3R4c2EoKSBmcmVlZCBpdCB3aXRoDQo+IGtm
cmVlX3JjdV9taWdodHNsZWVwKCkuIFRoYXQgY29tbWl0IG1vdmVkIHRoZSB0YWJsZSBpbnRvIG1h
Y3NlY19mcy5jDQo+IHdpdGggdGhlIG5ldyBzdHJ1Y3QgbWx4NV9mc19pZCwgYnV0IGZyZWVzIGl0
IHdpdGggYSBwbGFpbiBrZnJlZSgpLg0KPiANCj4gQWRkIGFuIHJjdV9oZWFkIHRvIHN0cnVjdCBt
bHg1X2ZzX2lkIGFuZCBmcmVlIGl0IHdpdGgga2ZyZWVfcmN1KCkuDQo+IA0KPiBUaGUgc2FtZSBp
c3N1ZSB3YXMgZmxhZ2dlZCBieSB0aGUgU2FzaGlrbyBBSSByZXZpZXcgYXMgYSBwcmUtZXhpc3Rp
bmcNCj4gcHJvYmxlbSB3aGlsZSByZXZpZXdpbmcgdGhlIEhXLUdSTyBmb3IgUFNQIHNlcmllcy4N
Cj4gDQo+IEZpeGVzOiBkNGVjZTA4ZjRiMWQgKCJuZXQvbWx4NTogTWFpbnRhaW4gZnNfaWQgeGFy
cmF5IHBlciBNQUNzZWMNCj4gZGV2aWNlIGluc2lkZSBtYWNzZWMgc3RlZXJpbmciKQ0KPiBMaW5r
Og0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyNjA5MDkwNjU1NDIuNEI4MEQxRjAw
QUNBQHNtdHAua2VybmVsLm9yZy8NCj4gU2lnbmVkLW9mZi1ieTogSm9hcyBBbnRvbmlvIGRvcyBT
YW50b3MgPGpvYXNhbnRvbmlvMTA4QGdtYWlsLmNvbT4NCj4gQXNzaXN0ZWQtYnk6IFlhZ2EgQWdl
bnQgSGFja2VyU2VjIENsYXVkZTpjbGF1ZGUtb3B1cy01LTUNCj4gLS0tDQo+IHYyOg0KPiAtIERy
b3AgdGhlIG1hY3NlYy5jIGh1bms6IHRoZSBzY194YXJyYXlfZWxlbWVudCBmcmVlIHdhcyBhbHJl
YWR5DQo+IGZpeGVkDQo+IMKgIGJ5IGFkMTdhZDUwYjhkYyAoIm5ldDogbWx4NWU6IEZpeCB1c2Ut
YWZ0ZXItZnJlZSBvZiB0aGUgTUFDc2VjDQo+IHhhcnJheQ0KPiDCoCBlbnRyeSBvbiBSWCBTQyBk
ZWxldGlvbiIpLiAoU2ltb24pDQo+IC0gRW1iZWQgYW4gcmN1X2hlYWQgYW5kIHVzZSBrZnJlZV9y
Y3UoKSBpbnN0ZWFkIG9mDQo+IMKgIGt2ZnJlZV9yY3VfbWlnaHRzbGVlcCgpLiAoU2ltb24pDQo+
IC0gRml4ZXM6IG5vdyBwb2ludHMgYXQgdGhlIGNvbW1pdCB0aGF0IGludHJvZHVjZWQgdGhlIGtm
cmVlKCkuDQo+IC0gdjE6DQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8xNzkyODU4ODg4
MjkuOTAyNzUuMTczODYwOTcxMDU1MjUwNjgwMTZAZ21haWwuY29tLw0KPiANCj4gVGVzdGluZzog
Y29tcGlsZS10ZXN0ZWQgb25seSAoYXJtNjQsIFc9MSwgQ09ORklHX01MWDVfTUFDU0VDPXksIG5v
DQo+IG5ldw0KPiB3YXJuaW5ncykuIEkgZG8gbm90IGhhdmUNCj4gTUFDc2VjLWNhcGFibGUgQ29u
bmVjdFggaGFyZHdhcmUsIHNvIHRoaXMgd2FzIG5vdCBydW4gb24gYSBkZXZpY2UuDQo+IA0KPiDC
oGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9saWIvbWFjc2VjX2ZzLmMg
fCAzICsrLQ0KPiDCoDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24o
LSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvbGliL21hY3NlY19mcy5jDQo+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL2xpYi9tYWNzZWNfZnMuYw0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9t
ZWxsYW5veC9tbHg1L2NvcmUvbGliL21hY3NlY19mcy5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0
aGVybmV0L21lbGxhbm94L21seDUvY29yZS9saWIvbWFjc2VjX2ZzLmMNCj4gQEAgLTk0LDYgKzk0
LDcgQEAgc3RydWN0IG1seDVfZnNfaWQgew0KPiDCoAlyZWZjb3VudF90IHJlZmNudDsNCj4gwqAJ
c2NpX3Qgc2NpOw0KPiDCoAlzdHJ1Y3Qgcmhhc2hfaGVhZCBoYXNoOw0KPiArCXN0cnVjdCByY3Vf
aGVhZCByY3U7DQo+IMKgfTsNCj4gDQo+IMKgc3RydWN0IG1seDVfbWFjc2VjX2RldmljZSB7DQo+
IEBAIC02ODQsNyArNjg1LDcgQEAgc3RhdGljIHZvaWQgbWFjc2VjX2ZzX2lkX2RlbChzdHJ1Y3Qg
bGlzdF9oZWFkDQo+ICptYWNzZWNfZGV2aWNlc19saXN0LCB1MzIgZnNfaWQsDQo+IA0KPiDCoAl4
YV9lcmFzZShmc19pZF94YSwgZnNfaWQpOw0KPiANCj4gLQlrZnJlZShmc19pZF9mb3VuZCk7DQo+
ICsJa2ZyZWVfcmN1KGZzX2lkX2ZvdW5kLCByY3UpOw0KPiANCj4gwqAJaWYgKG1hY3NlY19mc19p
c19tYWNzZWNfZGV2aWNlX2VtcHR5KG1hY3NlY19kZXZpY2UpKSB7DQo+IMKgCQlsaXN0X2RlbCgm
bWFjc2VjX2RldmljZS0+bWFjc2VjX2RldmljZXNfbGlzdF9lbnRyeSk7DQo+IC0tDQo+IDIuMzku
NQ0KDQpUaGFuayB5b3UgZm9yIHRoZSBmaXgsIGl0IGxvb2tzIGdvb2QuDQoNClJldmlld2VkLWJ5
OiBDb3NtaW4gUmF0aXUgPGNyYXRpdUBudmlkaWEuY29tPg0K
