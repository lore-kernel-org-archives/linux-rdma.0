Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11020136.outbound.protection.outlook.com [52.101.201.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCBE47AF6F;
	Wed,  5 Aug 2026 15:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.136
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785943536; cv=fail; b=NeVkXIgnn8QJik+XLU38wZyHVhdbtWpl+WiUjUQA3QV8bRH1MrQPLRL4k+FNEhnaHUQYJdl1c/qotlKCU8J97nLSlw06frMA1CSOT+PnyzsXYNT4pxv4Apof0vZxkVNWXyAFxSC/7BlvcWtw6rUCsqH79hclP315kQgXsfT1Ruo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785943536; c=relaxed/simple;
	bh=5DioBRVaJVF1CaYektuFxYBLKaJqTH8saJnsR8Uqcmk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=p4x6QLyePYbf0UEVU+u3b02uXuEmULVSSvnq02M3DNb/j2szy2BOyLxPqBJ+MoRPQTTO6FJ3ikZ3KPbyev2/nTLArajb9XnYhuyAcDYTjTpyojAmcaOLXw5MIYTstI4cSn95GgZvfksh5XpzRsotnn1EGVNuM8cD0L/J6D3ZbxU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=XPZcNDAu; arc=fail smtp.client-ip=52.101.201.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="XPZcNDAu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OycDuvnvoFCCDQQB4QNGdMFnR52zwJ+IpI1Fc3SrsEeuoinsN/mMBNL9/rahO35WufKtWqR5fzd8HINIjB8vcGSYi1vRupUskn8VjycD2RohUGJ2qeL8oWNHmoFc5Zuq/IogHsR9T6g2yGWUib1LiHU+n5IRiXZTdJz/Pf26m55pJg0mWuBE/A6YyDY8ZAO3OmCVPjvq5z6PUbXMO+XV9FcKr6NO9CXty02ccXUEZ3sWz427SafUyGr+qZxXLXn3fEKI2o3c0jGiP48k8QgALBvOLorCXEevejiFrrhxDxIgNOs4vwuxQ5k2kGC/ScBjcUdaD+j8g4euS4c7u60mxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LRF8jspBYq1iLuY2eqD8se0ygmr9+Y4yRYdqTc+z0/c=;
 b=CgQ3UYZe3CFdxECvoZWtY8F7XuSqDqwxSbEQR9S+olTkFM7ZmCIP3Xi10GkYXZNbJvvyu1Ctd85O6f88y2K8kyvLyCn9kS9N9Uxkm3ffrHDLtof9SB+OwsTCzfXARVMpgCYS/kT52vvGBnFhgrgrTwuETiP4tA8yM93HIZewA55v8t5dHHA4EXFWy5/jcZnophfWVGl8klFIn9YcvMCpo9ooGV2I8sDLzOnFhf2rXv6VMKp52VX7uSvx6qfDEkvmwYPYHR/6GJPwGEsdHxfkW305s12qmtLjgympgVvhuh4v7il5uBd6WleLXJ98NP651Q3DP5wOdvealxYoc1CjKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LRF8jspBYq1iLuY2eqD8se0ygmr9+Y4yRYdqTc+z0/c=;
 b=XPZcNDAupBU7HXm9jKDeyFoMcM1cwz2x4VQ5Bm/Gvo6UUafhLgiNw7ch5f3vKOwPZC4cFxuwpv8u9krMC+X4ryWMNQ7/xnr5wBeIeVHnrPitDZyoZZDd+xAcXrbaI2Bi8IjdA8KuFIOdUX4ntRxE4/fdr462nB6wjs233zS21Xs=
Received: from LV5PR21MB4704.namprd21.prod.outlook.com (2603:10b6:408:307::7)
 by LV4PR21MB6293.namprd21.prod.outlook.com (2603:10b6:408:356::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.6; Wed, 5 Aug 2026
 15:25:18 +0000
Received: from LV5PR21MB4704.namprd21.prod.outlook.com
 ([fe80::144b:98da:1262:2ebb]) by LV5PR21MB4704.namprd21.prod.outlook.com
 ([fe80::144b:98da:1262:2ebb%6]) with mapi id 15.21.0315.001; Wed, 5 Aug 2026
 15:25:18 +0000
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Breno Leitao <leitao@debian.org>, Haiyang Zhang
	<haiyangz@linux.microsoft.com>
CC: "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, KY Srinivasan
	<kys@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui
	<DECUI@microsoft.com>, Long Li <longli@microsoft.com>, Andrew Lunn
	<andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Konstantin Taranov <kotaranov@microsoft.com>, Simon
 Horman <horms@kernel.org>, Erni Sri Satya Vennela
	<ernis@linux.microsoft.com>, Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Aditya Garg <gargaditya@linux.microsoft.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, Paul Rosswurm <paulros@microsoft.com>
Subject: RE: [EXTERNAL] Re: [PATCH net-next v2] net: mana: Extend RX CQE
 coalescing up to 8 packets
Thread-Topic: [EXTERNAL] Re: [PATCH net-next v2] net: mana: Extend RX CQE
 coalescing up to 8 packets
Thread-Index: AQHdITLarjnyHDTDWEaw7yPPrfhHaraPXiYAgAA54HA=
Date: Wed, 5 Aug 2026 15:25:18 +0000
Message-ID:
 <LV5PR21MB47047F0C806C38AE8551AFF9CAD32@LV5PR21MB4704.namprd21.prod.outlook.com>
References: <20260731212306.4098773-1-haiyangz@linux.microsoft.com>
 <anMikirGHvq7ne_q@gmail.com>
In-Reply-To: <anMikirGHvq7ne_q@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=0e4f7082-9c46-4fdc-96ad-3c4bb3208000;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-08-05T15:15:12Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV5PR21MB4704:EE_|LV4PR21MB6293:EE_
x-ms-office365-filtering-correlation-id: db3c33c5-71e9-4f66-7d1d-08def305c19c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|22082099003|18002099003|11063799006|4143699003|56012099006|38070700021|7146999003|10067099003;
x-microsoft-antispam-message-info:
 Mr+XAO0eqiMUhZ2vLENayTXxLbN4pM4qvEIOhC3ekbpZR3GE5sLnh+9PCsgXl7qzrmIj3Q0N6nM6duLWJrCTTsq2KAf+cETtMbxscWv0OzruqssMG9fS73d5GePd/SPHl2bvNppza7gRVyqBzTvBN7gMEXu1/W+bxRqQakWNAUF3MjVyVXAqk6JyPtZMYiML+7c9dBB9TtnUrkslnkjJ2ty1ymaHXHN8U4Ski9nP5/DfS7Gv27N6Dix7ptYKxuekZubWhaPXxRLWKushcmYihJgtGJV0P0gmtZyTTNkOnHPw6zVx4ntXUT+z9DcUIXf4rSqemFaTanPNphi1hiw7aPvNgTmGLUEuPjSR89B6hxGnGjLjSiStlCEk+eb8n0JrjsK99EFPQuyu7JdFSP0bA3KPyd15/AlL/X01Oa68dn/SNumSGEE//w4EQBjmAu1HWM6kHP39zZbfc8jewSz+JiO75VZw8D80jymTj7pSvuT51M6AylowSmtIKG7vgd2i2fM1b7jgejmbeWp8Ovg4z4tU/BwdnSKx1++x2QU6RxC/XPDU/3Mhp7VF6sXVydBIB0p+tJLf2gZPrg20Q/QSkZbj6EvX4p1J7bkJ4cczIw1TkPMKgeG8MCjNwkYzjBM0qvxsR23QQoYtWELI/zfZPQhcC4wS18y4IFrT32vFKuA5bnz09lRnuMGsDnzUMcUEtEsJ0pXw7URsHOFEr6iPi22GA7k7ukVX4gj3qqOq2qY=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV5PR21MB4704.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(22082099003)(18002099003)(11063799006)(4143699003)(56012099006)(38070700021)(7146999003)(10067099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?D7FNSeAjL7Eu/g763NKOBuRyI8ZRfQMTWvT0W2kn3t9SWHiUYPsiVmvxHIN9?=
 =?us-ascii?Q?USqKdSCktkkkY0iRO/cZorlArQw5Fz1uUgiPmwhK2Wx5ugX3BfdVCoyg+wX8?=
 =?us-ascii?Q?snTI1srYkMHFOEAh0weeAGYR5SofNTWYlBs4IV2xlYoZV5czHX6GHLsz9+zA?=
 =?us-ascii?Q?BptNTFHDxcvYJAwKWrA1p5hA3nYSR6UxnNtAwYuSje8amnR718LuwFQgp4Kx?=
 =?us-ascii?Q?4gSdE1BocrqUd9btN5B6glGZpyPhOY4MJiIeub9alQCFQDmMtgn1oGaLCEzD?=
 =?us-ascii?Q?rQHO+FcHgzEFU/H/2SLYT5p1m6kfefgLuFLi2mFgRdxUgKTnMSQlNSDlsQ6q?=
 =?us-ascii?Q?oFL1OVpFGDqUUoimb8SYIurIo03Rg13k4kv1iDVqAY0voVMCTrdipa2FrxFA?=
 =?us-ascii?Q?xYtSB4oWe1cr9b6uSbWuNiMbXIksGIVFI3RDP7TUBm/tpa1FIIUlPXLXIzpr?=
 =?us-ascii?Q?81PK2CKq4HIr8Y3D/4BugnGhfQwY8sXN04G8VfFAo0z2bLECg4n2AXqE7zEH?=
 =?us-ascii?Q?FPejsuOrVyMowosWK8yM6C8SaLJ+NHPydMMG3mBjYjwf6CGdHmGZ3pIvJl5Q?=
 =?us-ascii?Q?JFkroj5Y8t6Yvp4Ndxayk6zJM8mXevKWAmnbUZRbDipMUpnHGmSUDyWjJd05?=
 =?us-ascii?Q?cShsuorrhleSInRWGI16AshfSewukSEX3kN5cODdXGgeLHZNLEco40+T/1qZ?=
 =?us-ascii?Q?4gHCrnp7+aUuIXxZXSZmm9oh6tqw6w/UQkXthyRRO/QQiL/9G9kqIxwOor4k?=
 =?us-ascii?Q?lzwHnm6HAVqjKY4wdWn5KMthO0jxZh3Fujuu9DzZ3NznLnHP08zHyG7zbvni?=
 =?us-ascii?Q?HzEEVGJnPPe1ZVAcPu5qpdb82NZBqaOOz+maem4qdRz6kYT85uz5srFf/Fx/?=
 =?us-ascii?Q?z41nc732TAHYZq1zMM48lpY8KlAGSG/Gda2+dABY0qUQXtqGPXFwRBqTSDhA?=
 =?us-ascii?Q?ePbkfue3b8YcvMgR0+ZvMLL9ADeEmnQYq5pZyQaMtBMc3hCSyMTy5YTynKs3?=
 =?us-ascii?Q?z1kXxK7f1bNG9V0S7x7UYYcsyXNifFOYwQN8uXxgVKJlw9PM2UrQSJiXZC7G?=
 =?us-ascii?Q?yK/hx7QKJUxpmMawAYmin6lhjypKhKYVRNAxWgUS9s1vtrzWXJ3GGi5odyKl?=
 =?us-ascii?Q?9Fwd/okL917QcvtI4XEGLlZQX+N8WA6G+on3HWZL3VexTg4iWsttZUB9aT14?=
 =?us-ascii?Q?PqMsU11VH+Xc3cC2uRhUr4GtIdlbZ9O7c3ZC1yhpjoUQugoJx+31ajaaX7E8?=
 =?us-ascii?Q?VctQZxkAZQ9XNx8CnydFecTVnq10ocsI03Qgb+LLmQjuoAhttfJttqfKioLj?=
 =?us-ascii?Q?THlDGyGwbdREx92tv0q3lzC/W/SW/1yoDQufA+/5DDApYvXUqL++rphQ6v0m?=
 =?us-ascii?Q?UAV5IeVE6BT1mmVJ3tAroP4jRlnAgo+GOeNtwgG/xMzgswsx26hE+llLWAbK?=
 =?us-ascii?Q?iEERNaRjOOx7r4naCMDzjbQ9dOPFu58zkC76QPwfrEOo8cu+zx8x3w0BeqWn?=
 =?us-ascii?Q?+Mkv43XGnNR47hMjV4/Q3ONH/i0d2ZlmosUjEnyA2enlxNx1VZdxVU7mUkxw?=
 =?us-ascii?Q?yWHhbE5P5nY7evcpu1HB0HcpXPfy/e5VuanTKs6TVhe7Tj0dVxR2wM486kVy?=
 =?us-ascii?Q?PUwuofTwAE5aYm9me9WWXqStE1mETYv4aqqXtkMxbjcpzbd97i24na3q3VdM?=
 =?us-ascii?Q?S/SUoPS4I3tw/twHH5Duwq5gLG6JP1zUtRCzirhI5pl6v4NeR3ZbDF2EM5B3?=
 =?us-ascii?Q?sjChHBIwsg=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: db3c33c5-71e9-4f66-7d1d-08def305c19c
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2026 15:25:18.1547
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J31QPzRRTW+pQYRxVMOYoyy0qvVnQqqzToo95wShrZVltt+hr4CrmhfByCUaJb/+/Y1OciKYATuAaTZLpSEcJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV4PR21MB6293



> -----Original Message-----
> From: Breno Leitao <leitao@debian.org>
> Sent: Wednesday, August 5, 2026 7:48 AM
> To: Haiyang Zhang <haiyangz@linux.microsoft.com>
> Cc: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; KY Srinivasan
> <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.com>; Wei Liu
> <wei.liu@kernel.org>; Dexuan Cui <DECUI@microsoft.com>; Long Li
> <longli@microsoft.com>; Andrew Lunn <andrew+netdev@lunn.ch>; David S.
> Miller <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub
> Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Konstantin
> Taranov <kotaranov@microsoft.com>; Simon Horman <horms@kernel.org>; Erni
> Sri Satya Vennela <ernis@linux.microsoft.com>; Dipayaan Roy
> <dipayanroy@linux.microsoft.com>; Aditya Garg
> <gargaditya@linux.microsoft.com>; linux-kernel@vger.kernel.org; linux-
> rdma@vger.kernel.org; Paul Rosswurm <paulros@microsoft.com>
> Subject: [EXTERNAL] Re: [PATCH net-next v2] net: mana: Extend RX CQE
> coalescing up to 8 packets
>=20
> On Fri, Jul 31, 2026 at 02:22:53PM -0700, Haiyang Zhang wrote:
> > From: Haiyang Zhang <haiyangz@microsoft.com>
> >
> > To support up to 8 packets per CQE, update related CQE processing
> > code and structures.
> > Update ethtool handlers to set this feature.
> > Update per queue stat to show the coalesced CQE counters.
> > This feature is supported on NIC hardware showing the relevant
> > PF flag.
> >
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
>=20
> Reviewed-by: Breno Leitao <leitao@debian.org>
>=20
>=20
> > +/* 8-pkt mode packs up to 2 packets per PPI entry */
> > +#define MANA_CQE_COAL_PKTS_8 8
>=20
> nit: The name encodes the value, so a future 16-packet mode would need
> a second macro with the same role.  Wouldn't something like
> MANA_RXCOMP_MAX_COAL_PKTS age better?

The FW API uses mana_cqe_type like CQE_RX_COALESCED_8 for the CQE coalescin=
g
x8, so I followed the same convention for the naming here.
When it supports 16pkt mode, we will decide if we rename this one or add a
new name based on the future API.

Thanks,
- Haiyang

