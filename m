Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11020111.outbound.protection.outlook.com [52.101.61.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C263AA1A7;
	Mon, 28 Sep 2026 19:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.111
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790623014; cv=fail; b=d0K+yIpazjjmrfCFZTEBF82F/RoV9+yubTb5empE9jtEWgLU/FOEc0bPeIcbDQzzdZBKCmRCo0IfhBIZSofxq2NVsYga9zhXF944+FGIHgUWiBmvMZIPKvvJqNOuLtvAwJ0LFbWtMwI+2lED16slwQ7xxCMJ4aHb10rRyrCR2HE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790623014; c=relaxed/simple;
	bh=UcSLTj+hTBLj8LeV9RTxzIclyeDnYfjjcPqQQcwrXo0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sNvZIoJ2d8FjGTyO+eblEa+JYI4U3PuCPAoSmWhEzEj/kdDFsKS0BAhrDh9odxRKYEzRK1qQW1RH2qsNAq4PseuVgFqMKs3H9RJygLroLeKuKMm6hRUiLoMdE+Ak+/D9tNqG8//sIXRmgINDZbxh46lQ4+TlREaTaiHwb1Q1Zrs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=UBjDdcIZ; arc=fail smtp.client-ip=52.101.61.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="UBjDdcIZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kcfJMgNxLzQUq8HDf+bvjDacAYwhDexnJd2LIWGE2j7XQ3n//w9lzY8+iBB6OEY1ya7ysifcCEYCG8+mCRQBkbFIvCL5JvLmnyZ8r1UD42v/22dQ5Xxq79yo3KfmV4pqkFZVRkLOO8qnyXbz/4/YsIjZi/cfhMqv+oR0GXeVeIVsU0NDOz5xVLx7M9TT9XOOoMosowbYyZmUUdygyOUDm4iECOglQU3LWZSAbcBRVHj6tJWsEitCy8AxV61lpLMP5DIqn4H/wjqRMAl1nANkFBd+gBBFnae2tBopT45MSBhD3Y6HK5TvT9YLGpSjhXurkaRLG+UfgLJTUVzuAiTWvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UcSLTj+hTBLj8LeV9RTxzIclyeDnYfjjcPqQQcwrXo0=;
 b=HcisOuwLCEJq6Do+Tew/RpIrKaeiKouWljDmMUk0wsmnBixReqiYoJOSgxCaxpxK1dReRZBCWkRMTN8RUgH/OYmK+M8xsyPPe1O+i+mBGeVawxgrHEL0Tpao19nTnihBF0icm4u4BQpYg5a67BEdYia8HyeBBv2ddq7TvYPQuXEAOg581yewUeiUh/IREzHWwZsKIaLuqs5xGkBIWZuFJIBjegn9cf8iuc4pJJtZcPVloGV9G/Z6PIUgl2A+EwnI7CseFTo2HTnT2bajliZXfvTR7pjty0MPBx5o7v6wO5hDDQ5T4eQaq+OVYEjpRAo/8cXiCYtJP3GPxVRzRYAJbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UcSLTj+hTBLj8LeV9RTxzIclyeDnYfjjcPqQQcwrXo0=;
 b=UBjDdcIZA8E/loMjqIsG23f7Bt6utJ+uZahShav5X72N0XhWth8PGvaxz1H3H8MCoY+aznRVNuRcZ5Ba+KN1FqVWiY2Qf6DOtxIgGwn2p88CD0+nAri6fBuDSIfZzehQOHfOXWrWjkEKLri/noR9EJETOdo3AFfE+3yqOpNQcdY=
Received: from LV5PR21MB4704.namprd21.prod.outlook.com (2603:10b6:408:307::7)
 by LV5PR21MB5569.namprd21.prod.outlook.com (2603:10b6:408:2b7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.7; Mon, 28 Sep
 2026 19:16:49 +0000
Received: from LV5PR21MB4704.namprd21.prod.outlook.com
 ([fe80::144b:98da:1262:2ebb]) by LV5PR21MB4704.namprd21.prod.outlook.com
 ([fe80::144b:98da:1262:2ebb%4]) with mapi id 15.21.0496.006; Mon, 28 Sep 2026
 19:16:49 +0000
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Manish Awasthi <mawasthi@linux.microsoft.com>, KY Srinivasan
	<kys@microsoft.com>, "wei.liu@kernel.org" <wei.liu@kernel.org>, Dexuan Cui
	<DECUI@microsoft.com>, "longli@microsoft.com" <longli@microsoft.com>,
	"andrew+netdev@lunn.ch" <andrew+netdev@lunn.ch>, "davem@davemloft.net"
	<davem@davemloft.net>, "edumazet@google.com" <edumazet@google.com>,
	"kuba@kernel.org" <kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
	Konstantin Taranov <kotaranov@microsoft.com>
CC: "horms@kernel.org" <horms@kernel.org>, "linux-hyperv@vger.kernel.org"
	<linux-hyperv@vger.kernel.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"Gupta, Nipun" <nipun.gupta@amd.com>, "nikhil.agarwal@amd.com"
	<nikhil.agarwal@amd.com>, "gargaditya@linux.microsoft.com"
	<gargaditya@linux.microsoft.com>, "ernis@linux.microsoft.com"
	<ernis@linux.microsoft.com>, "kees@kernel.org" <kees@kernel.org>, Paul
 Rosswurm <paulros@microsoft.com>, Manish Awasthi <mawasthi@microsoft.com>
Subject: RE: [PATCH net-next 1/4] net: mana: Introduce gdma_bus_ops for
 bus-specific operations
Thread-Topic: [PATCH net-next 1/4] net: mana: Introduce gdma_bus_ops for
 bus-specific operations
Thread-Index: AQHdTEqP1EacqDNHr0enaWs1w3eIl7bkYuXw
Date: Mon, 28 Sep 2026 19:16:49 +0000
Message-ID:
 <LV5PR21MB4704C6090E9DFAAD1D6782D2CA8D2@LV5PR21MB4704.namprd21.prod.outlook.com>
References: <20260924173054.589291-1-mawasthi@linux.microsoft.com>
 <20260924173054.589291-2-mawasthi@linux.microsoft.com>
In-Reply-To: <20260924173054.589291-2-mawasthi@linux.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=44800805-55d5-45dc-b225-1cb768c3f0a1;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-09-28T19:15:35Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV5PR21MB4704:EE_|LV5PR21MB5569:EE_
x-ms-office365-filtering-correlation-id: c82fb836-9ffc-4992-2ad6-08df1d950bde
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|23010399003|7416014|1800799024|376014|38070700021|921020|6133799003|7146999003|10067099003|56012099006|11063799006|4143699003|7053199004|22082099003|18002099003;
x-microsoft-antispam-message-info:
 Xr1gIYW73rkNN5PwjLv1E9LGQ8Gj+1H+Q2ZP4baHLjFZn1XJb2MX6bpit0S4anHxif/NKZ2E2HnjqAC84T7QtoYtDbvGWWN/Fa1U8esKWYoYiUENrCPuzcHTBSjnE2dlRy0HwzIb1ohNy+7rv7RYK+AC10yT/OBihff0/iJqMgMxJ9ScoUd1CZSF21aw8+sLzAT14tmi0J88gqSEYFdp3GJtnHqrziWK8hrUy/bGAJu0sNGkQ7nNLc1oXwuzYRTPRRqBv17GSwaxUB/a9D5XAqgUwvu+3B6BybV0PhHhMrTRWG0LW0LBfQZl6D1SQ48llKZeNQ1HFjuH+fP080qF+5T8efio7Z4F7YtzQGMq1KlcDc9UEZeeOvp+BaIK+r8AtHdjt/Ge8/x+Rmvg8veAEg1dwh/6bRiZaC86smH65AJJPd70IijwphCSslihr0d4PJmyne5k6xkfe0ENF8N86Y/OMIEzU91GzPoXVqJOiNYOK1nCE45JTaeEN8+qK9mhJ8ASwpjCmSvPKT0JAHrmwu2quEm7jH7n5Fyy2xkkFcR77rnMD1LD++vC7Jq245iszlY/A76vwBVIl9nnDsISJEESThblpthQrrI9hBzhul6sbCXPelFBGCQJYOUDmHYk9CMsK9fHaRCXHb9Q6cxjQIvOR5wLdxR3U/WBo0edzIdoezE+EsFEPQsZXbEtj27Ar/2bTOtGZeJQzqJOLD12j90RTbRsAoJr8bdVh6zrhi4F3NHgGfKafETj3/P+PAyF
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV5PR21MB4704.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(1800799024)(376014)(38070700021)(921020)(6133799003)(7146999003)(10067099003)(56012099006)(11063799006)(4143699003)(7053199004)(22082099003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?cN2fz5VC2oEMT0XW3jbbpqYH9svLR/jamhc/LiXTen0Eawj/JI3PaT/KlVzw?=
 =?us-ascii?Q?srxPRIBUhImsgCd7Hx21qJfRRKGyrroDnRStsiKvnaUp40S9sbFUOadEaA/J?=
 =?us-ascii?Q?6FiJ0nctxyC6C68f8CnBQgzi7Ake2vd8nBIMi5vzwWmcPZ0D3Uv/x9TwN55j?=
 =?us-ascii?Q?ckckJG3RpUN05ZdxPHqnKpZfZwAzMN6Rhe7Rxk1U7YJn+OOg+queEGdPGQUm?=
 =?us-ascii?Q?6VsNdFpJWFmUwcbvut80w6Gwl58cg54g96Mf0cBX/v40ddLjCUbb7K55w5sX?=
 =?us-ascii?Q?4L+Qlz/8plEO0squJqt5eaD1jy45triGK/sIIv2ihloetqyUZj0TYAZDDh8d?=
 =?us-ascii?Q?UMOSLgM1fSbwmN55flac3EHke4NrN8FjLj2rN5l70V1l3AxJl83n135BwZPw?=
 =?us-ascii?Q?ImI78wi1Mg6ZZmXx98m/4bUd/TZ/y68O7R2EO2DmNiiLTzFd3S7xhR2faXSG?=
 =?us-ascii?Q?GHvaIWvG6CppZGwRK+gZPEB4xo/bUzQZCkq0RZ5STESNH0uTRV3JQypC2dUO?=
 =?us-ascii?Q?UMJpvQqwAwi+tGtXDNk2PThgyQXZvINMMICAU6wbyIogCXa82K/t/NjOTu4A?=
 =?us-ascii?Q?wt6reeiKUwkFrqqnawCJdwG+WYnXUP5LMmr4EdrYkCZDznz0oJiBDLY64X3L?=
 =?us-ascii?Q?KfKRdCEORPSNPE7Dk2cxsoh/Ez552YChoFkNtcIl/2pX47yhNExDI/LOVe89?=
 =?us-ascii?Q?RtimPS3ZVkxM4Fjn6TIEfFwNYNk93JdR+kilCFE4c933ZsvQFw5fkXWrX1Ds?=
 =?us-ascii?Q?qEQFhK9MAwycv1XyN3Z2+HhW4oKriTY3IzwwDkt0IWYVR+ukY9E6sdGvIGdH?=
 =?us-ascii?Q?CKmE6fQy/efw1v3cMs3WM9J3m/JrNRGfzVU3WNXmi2sMfsrrrTXN1gHwyBN2?=
 =?us-ascii?Q?hkDy/UlHj6GvqPIzMwtXlXtgZNVBkuiL9bP83ACUp8M9bbnv1UVipsFiUyF0?=
 =?us-ascii?Q?w8B97t4wqxEZDdv2gAhR1cScRq9ighlQta9jQUFbLMvamVPUjd/1qHtnarJ+?=
 =?us-ascii?Q?rBBKLi8mlYSQj2fxRHZzgAgXp2qjoquQW1m+RUwP0toIE//yt3ll//OsAGJ9?=
 =?us-ascii?Q?C1IHStFEk2u75fnDH6Btu7myeX1SKTNONiTBmQn4MzHlWQjfSYrV9Ogh/8u1?=
 =?us-ascii?Q?EdEx4Gg2U3kBzZ6rlf0mOYGcZa1shpDj5kvM/AhBkGR9dC18IvI+qnVKdhNp?=
 =?us-ascii?Q?WH5kVALT4AgV0HZzkOhv3HrAbd/omo0HU++HbHPqafGYWe836V+yxAjjgKoJ?=
 =?us-ascii?Q?5uVumWzRx7tN7oT7JvYXqTTKgCvDznEbQWN5sjrKCuYYYpA0O2eAtS6QZ3tc?=
 =?us-ascii?Q?p5x2Rjh88+545u3gWabg5YHx+EngJQ2XZp6C8c4Bjw5llTnhrusdgJyWu3d0?=
 =?us-ascii?Q?H7qd2CGEJJIzx7VCrbkxVEhVH0Dp9agCNv9b294DKf/Migda0s+n/uId+OZX?=
 =?us-ascii?Q?va/GOxCumUw4g1kcF0qPLNI+hgGc/zbQT6xzxQIWqP0WGBQWFbqH3RxvcQJ9?=
 =?us-ascii?Q?tQjgOGYXUpXIrrj/3r6psKM1nlAYBZCWicJvWhQ3J4PXLsp0fgvNj5pUDwnx?=
 =?us-ascii?Q?NSo2ixLaUCy6GA8rehyNs9dAbyCJZF+BA2iZeWsDRjPvqZzNtyIaTwjhvdPr?=
 =?us-ascii?Q?H7WsAoUYQ5r/LZMvfmfQNcRvDVG4UwyZ9pdMq7II8noU7cxV7QjiXO4JOphc?=
 =?us-ascii?Q?JnY3OhyfLgpOoonNk+lao4pdQdST70LClocJ+jd82e9hCdjpPg01kIc/Sth3?=
 =?us-ascii?Q?j1oD+EJDOg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV5PR21MB4704.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c82fb836-9ffc-4992-2ad6-08df1d950bde
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2026 19:16:49.6255
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YGLekp4hbXJuxwEbxnf4gpLL4FTv0hszTYxud/iKxXfXv3PD/Y2eu0e3WLvn29PULlDACuIzKiDh8jdh/m2nQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV5PR21MB5569



> -----Original Message-----
> From: Manish Awasthi <mawasthi@linux.microsoft.com>
> Sent: Thursday, September 24, 2026 1:31 PM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; wei.liu@kernel.org; Dexuan Cui
> <DECUI@microsoft.com>; longli@microsoft.com; andrew+netdev@lunn.ch;
> davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; Konstantin Taranov <kotaranov@microsoft.com>
> Cc: horms@kernel.org; linux-hyperv@vger.kernel.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> rdma@vger.kernel.org; bpf@vger.kernel.org; Gupta, Nipun
> <nipun.gupta@amd.com>; nikhil.agarwal@amd.com;
> gargaditya@linux.microsoft.com; ernis@linux.microsoft.com;
> kees@kernel.org; Paul Rosswurm <paulros@microsoft.com>; Manish Awasthi
> <mawasthi@microsoft.com>
> Subject: [PATCH net-next 1/4] net: mana: Introduce gdma_bus_ops for bus-
> specific operations
>=20
> Introduce per-device gdma_bus_ops for interrupt allocation, IRQ lookup,
> reset, servicing, and bus-specific capabilities. Route the shared GDMA
> code through these callbacks and provide the PCI implementation.
>=20
> Move common device bring-up and teardown into mana_gd_setup() and
> mana_gd_cleanup(), including hardware-channel initialization, device
> enumeration, interrupt-pool sizing, and servicing workqueue management.
> Record the vPort count for transport-specific queue sizing and keep share=
d
> IRQ context bookkeeping in the core.
>=20
> This prepares the driver for additional bus transports without duplicatin=
g
> the core or adding configuration checks throughout it.
>=20
> Signed-off-by: Manish Awasthi <mawasthi@linux.microsoft.com>


Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
