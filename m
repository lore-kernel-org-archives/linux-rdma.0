Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11022105.outbound.protection.outlook.com [52.101.48.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E143274FD1;
	Wed, 24 Jun 2026 22:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.105
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782341435; cv=fail; b=riZSPg4/SFeEM3cOBWAVworNjLya09BYqCZnQ8BTGmFJUefWwkfnr3Q3dOH36pLgKH/3u/Iu9QTMaiw1oaFBwK2yTHKWMq2c75BVLBx6d4x/fnwCE9/4UdH1yx/AKl9W9V7YRwgGDlTloIKL5tMxbn+IWXWVy9x+CpVIpX0AEvg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782341435; c=relaxed/simple;
	bh=aJrmBp1g13oO6oBQB6r/GMwXxDq2mofOtZ1mIht/O2A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fuo/sZvGpP/PeEFKnTjPCuGsMm9zf3tuPlbSeY/5SkFaUN6i7y0PtQ72lkwoPviGWtjy1U7w06Xmu4RumvinkWHcZGic/KzoUTsokEfbLpVFiR+kBgKLujTT/MtGrKP0KbMZfonzimagymjo3vTe8M1lspZOktSD0WMwLUbTuDs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=ahVe+yan; arc=fail smtp.client-ip=52.101.48.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="ahVe+yan"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PBPYdZHiL8Z9TgL56OD3wbSmDzzvIFEOGl3Jr+dOuT294i1WL71dgNFTYfUtdLBpqrmvjNFWH2zXj+bC0ShPNxZq9KYLbYWNhwHHqGNdMUAZSf4YElR/GEyH+39WnYb9+35DLul1q2SfCStElreso/BU/xvKZmQ0gzBF6vRe4ingmIPXbA6K45vEwexEXFMwpQslmtzoksDoEU3KecXyMUXNrICiG3adzV/ku8De9VKXM1nikf8FYZMzqmVMSokvVTIQ0TC2UNSMRDbrvJ8FMeaE/cqcLMlg/dvIIHu8Lo+Unttgd8HqNHXsgRxaljRpDpUX0hrxgKC9n0tBfT7X1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aJrmBp1g13oO6oBQB6r/GMwXxDq2mofOtZ1mIht/O2A=;
 b=BLh58+Sh7aIwWB0kdm+4Q00apuo8bkZ92nXtTTTSB4r+SnNeiMnZl8WKNYihShUNYAng0n/DnuJdNk7Uz2KROH+YNJ1KVifN1YQXjxOIMcEQ5PZA9jtNFiB5/mnyGI+GLIjzjp+pkQ7kwRwX33aZw3nPT2aZ7PaKUrX2YvOXloraxyP6WCUzrj4dS+T1z5VlxP1cNEosT23Ekk8Lvx2vW0MJuM6lvljaPMPFW5CVhDp3vru/Ksc18FRFsvkWV1A1KVfYm3mq7n6bWXCtv6D3Od9yrOumAZoGTo9R1JQ5x/x7Ax68WnL5IpFRuroJ+yxbt+A11aSnZJCIR8zxW63xFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aJrmBp1g13oO6oBQB6r/GMwXxDq2mofOtZ1mIht/O2A=;
 b=ahVe+yanUws7oyj7swI6glq0NxoHBfwH+Yj5Al8G9io1Fvb8eWodzDlzZcxeamnhwbnsuvrU9GwTCoS5CfCvkMQHa1kAma3JzaY6JAujkhCGAXSxQmYZMer5o3Bhh6k2nD4d0yut3T3havnCQCIAxB2K5Snvw0mPdiP7RWmTOuc=
Received: from SA1PR21MB6921.namprd21.prod.outlook.com (2603:10b6:806:4a7::11)
 by SA1PR21MB6201.namprd21.prod.outlook.com (2603:10b6:806:4a3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.3; Wed, 24 Jun
 2026 22:50:31 +0000
Received: from SA1PR21MB6921.namprd21.prod.outlook.com
 ([fe80::648e:8c2b:b5e4:aefc]) by SA1PR21MB6921.namprd21.prod.outlook.com
 ([fe80::648e:8c2b:b5e4:aefc%5]) with mapi id 15.21.0181.003; Wed, 24 Jun 2026
 22:50:30 +0000
From: Dexuan Cui <DECUI@microsoft.com>
To: Simon Horman <horms@kernel.org>
CC: KY Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>,
	"wei.liu@kernel.org" <wei.liu@kernel.org>, Long Li <longli@microsoft.com>,
	"andrew+netdev@lunn.ch" <andrew+netdev@lunn.ch>, "davem@davemloft.net"
	<davem@davemloft.net>, "edumazet@google.com" <edumazet@google.com>,
	"kuba@kernel.org" <kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
	Konstantin Taranov <kotaranov@microsoft.com>, "ernis@linux.microsoft.com"
	<ernis@linux.microsoft.com>, "dipayanroy@linux.microsoft.com"
	<dipayanroy@linux.microsoft.com>, "kees@kernel.org" <kees@kernel.org>,
	"jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
	"ssengar@linux.microsoft.com" <ssengar@linux.microsoft.com>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH net] net: mana: Sync page pool RX frags for
 CPU
Thread-Topic: [EXTERNAL] Re: [PATCH net] net: mana: Sync page pool RX frags
 for CPU
Thread-Index: AQHc/8rEsKaflwivok+NQI77f+CD7rZOVvxw
Date: Wed, 24 Jun 2026 22:50:30 +0000
Message-ID:
 <SA1PR21MB6921C97DBB667A6A8C8D89F9BFED2@SA1PR21MB6921.namprd21.prod.outlook.com>
References: <20260618035029.249361-1-decui@microsoft.com>
 <20260619090514.GT827683@horms.kernel.org>
In-Reply-To: <20260619090514.GT827683@horms.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=d96642d4-0ce9-46f7-acee-c25d07b808c0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-06-24T22:46:24Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB6921:EE_|SA1PR21MB6201:EE_
x-ms-office365-filtering-correlation-id: 2e56f192-0854-4ebf-d067-08ded242fe3d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|18002099003|22082099003|56012099006|4143699003|11063799006|38070700021;
x-microsoft-antispam-message-info:
 QPGtw73jLnmIJxz2OqrA/pwJeESLsjhzBh/x+a+HlZDegKJAoPUoBjKypUySxznkk5Ai5+TMpgeJQdWjhvMnS9fCa2oggg1FX6yuVIKw1DNSLf0bzlqs5B+eDUz5Nt8mWsUxJ2735vRqh4uXZ+vODNLdc5zx46PSmIWtQIAibtrUcdSPJXsizo40+LrtQc+r00+HnkHdny0yueH7AqVhzi+xcl1ToDgQwVMAuOT7etNXv7kzxWW04G2RmZz4FsXvcAVOhnQVOzghPiHwRv+2SOr1UeWJhcZX+A6JBCg0Q3jsnhc+Qu4y4SYrPnHucx2DxeQSepQXBwDkkHLdTGPZ/LSNSe9qEOkAZq10OdiZ/LkazaaLx7SajlRr6mR6nvphMJ2Fazq4QXPcqpnj7w/fbUdGLzT0BJ8Q4UFKBebxJxbiNNIeTk5S6nzZLUN4FGG1J5eYU0FIqTVaxEMCf14iOq3pnsMSFVmGO+evZaHfvtBgcltzo5XUOtVi1CGwdqcg7gx/AzC0kKtiUkvVZlV1zFgQOzOCewa805Adjb0lAfay1PgO+VMd6xq1ozUpCn9KPqHLXxZQ5LD0797VhXbMOSP3FM8XA2cOKofIh4lmmZIdX4JQVGVI6qlOJsBwnWds/i+nxvzRvJN6PhO6FdzhmNAOFvuf4h8mWWle8mWY8GQZPqFTGeOUly08ba3ePVlm8JWvYqGoDKhDOdriLsKBGpwRkwEGntH6Vnpjr1cVqU4=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB6921.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(18002099003)(22082099003)(56012099006)(4143699003)(11063799006)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?ABp7SwJRawF41WdTxcXzL2XbJKi/QJINQTvH5AJCBl/dGN5vEyaXEBb7FA9H?=
 =?us-ascii?Q?BzpceZ8964gjZWKyCCnNa/YJZXhmzs8zYZjMfTMoH+tqiy+HvnLydgbwrAQP?=
 =?us-ascii?Q?YnVZ4z0xA2ZaVUK2HAUCDNn23B9D/uM6IT+qX9Wi3iF+3QzRk4M0GXkLBDEz?=
 =?us-ascii?Q?37wOpdr8DaWnhCQbIKxenA1QzG1LL5uQYSs/r3C0oPm+9UFhF0vDI5kZtv7Z?=
 =?us-ascii?Q?VbL6QhpofviiOEylB7J42rf2jvG/GdB6CDFlkJTfpSe1U3EMAZGv08NMYjMi?=
 =?us-ascii?Q?rshb5Folyx9gn4/tzWxP930RH0rJ3xlqrkio6K+JMc4fDCte+Lh4LNLP+N1m?=
 =?us-ascii?Q?MSift4oqVI2/P5uxdQPa0/pvmnIT9MaxPqnIrbAx5YjtYKuiVT4ZlbAi96K2?=
 =?us-ascii?Q?w+/EvGZx3+31wl5aabOkatofwRFb15KIBtFG/z0gNpOxNh66bj6rMaBEK2xw?=
 =?us-ascii?Q?VAxxQCleFkh3ptaaCU17vpFbnL0jPLWroV3hOnohbaSzHbvSRG63wuwd+Trn?=
 =?us-ascii?Q?ZsF6kJaRuXGLboCbC68yir4IhCpX151iLzmq8MUaBJqirjhGjtFrbrndA7dt?=
 =?us-ascii?Q?4EB63T5IfAtsc13pLqWBo2VWNOwcBBGMBKRBSRpW8bWafmuoZfZjVmekif0E?=
 =?us-ascii?Q?WImIvD3kXaVnKBlk6O704qVtnRIePaqznp7cxUj86U5zYcWZ5SdXfSveEBAS?=
 =?us-ascii?Q?G3+DYOWeE52UzUryyVjCWLejNT6GUFo7BpVwNH6nEfneToB/UoqAvrM4akXE?=
 =?us-ascii?Q?BOA0xKobB3DLcl2PvxzMBcFXsCzbUPJhzYCt8keAuuaA6wziuzuKXLESuGjm?=
 =?us-ascii?Q?ugYBlU8V6uQLKZU7AlcxT3THwl920bHFxM2O6mZq43doCJjhjen1A+DBTe9/?=
 =?us-ascii?Q?HqpJRBPIIIjMPK+0GfOhSJJg8xDexK692VSudrdEaw9YVYDGml8fHnyLVZMn?=
 =?us-ascii?Q?AlzennBxpviGQ2B+OINrKULxkgLOn+GYKmCoS3fNBhUqMG+3Dqlnbt7gnG27?=
 =?us-ascii?Q?YJT+rJDznJ7ugoRk3P79zMzdlSkBfk6bnfGblKABJIEdSu+jV5esKLZrIkws?=
 =?us-ascii?Q?M720wVnHA9ClmJq27sei/3IUjvS+yArusugsjCdWyOOWocNoLForEX3qEVM8?=
 =?us-ascii?Q?/Nm4ScWiafzVAAepfNA1Ig900xi05tpFuQ4QS7EYC5UDCr7bXLd+wdofuiwb?=
 =?us-ascii?Q?MDPdihtJG3HcVD9lYYKvvFFTzmgfIRqCxAAXcaJzS0h0OhQjdXvPi5STjvcJ?=
 =?us-ascii?Q?yUdL91IuaWkaq0UBzgcKQMQvTKdYr2N5JqM3HfUNMk1tINVpgmtpRZrD4a39?=
 =?us-ascii?Q?M7sS9n44ooRd/9rwAvuP2v3Nov01B6iQ831iKZvYDsC6KrZdej4GXXaLDPun?=
 =?us-ascii?Q?6J5k1dTn6zoO8ys5W/jza6IL9qA6/30lkYBnB3vZmAbvLkxjgA6Ja5m0qBaN?=
 =?us-ascii?Q?j+wpGyyDhp/YRu+dsLaE5SUR5IZKue2Qxqe07RJkdwzeWKIOfqSUnxvfB2zn?=
 =?us-ascii?Q?x5I9I8C0uKNkBEFt89r7UyOsU74HRCKrAdJ/0VfsWFlk3nUPHCGRkww5TuwY?=
 =?us-ascii?Q?LPoQvehdN2s0J5HArLy43fUgAq70fAlNtPhGfccS6MffusC0QAEK4V3QHadm?=
 =?us-ascii?Q?aN1LEgkG1/rZ/b8VQxsknb36LU5e6nuwU8idsWgABl3QvZqzL0UB7j+snteT?=
 =?us-ascii?Q?lAugHRr0VERhB+Add+Lj/jqy9IjKlZxM98zFMv8PVC9xJCnx?=
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
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB6921.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e56f192-0854-4ebf-d067-08ded242fe3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2026 22:50:30.8142
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xXzJP6jmr88oY36tX63e/SCcIT/3KM7lDDDmpPtZXnOWPsjda/vuGZO1lgEG4IPXvLNhdkabVRG1FnUUPz106A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR21MB6201

> From: Simon Horman <horms@kernel.org>
> Sent: Friday, June 19, 2026 2:05 AM
> > ...
> > Also validate the packet length reported in the RX CQE before using it =
as
> > a DMA sync length or passing it to skb processing. The CQE is supplied
> > by the device and should not be blindly trusted by Confidential VMs.
>=20
> I think this last part warrants being split out into a separate patch.

Sorry for the late reply. I split v1 into 2 patches of v2, which I just pos=
ted:
https://lwn.net/ml/linux-kernel/20260624222605.1794719-1-decui@microsoft.co=
m/
=20
Thanks,
Dexuan
