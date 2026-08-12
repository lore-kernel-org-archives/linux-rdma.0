Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012027.outbound.protection.outlook.com [52.101.53.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02BF31D375;
	Wed, 12 Aug 2026 23:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786577536; cv=fail; b=FNM7mUgKgPKuc0mdcKAOH56BEelZBNdBM0I7Mshz2f+2wylbh9jbm+R5065XbTzq5hJJGuXAlB0fGWTrjjucORVRyBt9w7e/1H9pyogcEhSTp+ORjrFw0hV2yojBxSyVthWpk2306KLN7Jdn2uJmf8mXTWLBdx3Zyh6Iyr1dPVQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786577536; c=relaxed/simple;
	bh=7TliKQeO8lyGiJx2c6PoxprfAFSRQqEiJxq40HYfP/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=theaztCMeeCJtoYIiqMOH8AdLKWR9xl8FUjUR8XiVt1dSZITXDFx8ZNo10p10ahqe6/D7GszxBLy2Ri+/Qld6RrtZoJ3OX8zEOddrxsNmsAyVtJ4+Mztjpshgn/dvF25pavUpfPjpIbb4Oup4iOo8+mH8qwAN45m4v7OvcPZXHA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jEtK3ZgH; arc=fail smtp.client-ip=52.101.53.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jEtK3ZgH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iTT+1qGHxGo4Re4azaDjJEBF4sQS+WZXX11hPV6SQlSYWHSlnvKYUpohmCCBFGk6u/iGCWgFOuHP11ELo/v5B43Vw/w1eC+bpIJHrajLNhMdfZgGzYZoPkmQ3kBkphd1jjOlVdwbdw0/EZfU7Kv970FlXoXN4sxH8l9ZmlOFTDBFXv9Icwe+ESz/uVocy193vdx4cHXtus/vjiPOy/m6jpSxGiCYQL2NdqY40AcjmNEevGB6pz5qFZ60iNHId/sJLt/QTHakuX3BQ/1DnefttAjVj1ZS8g9jQwCaVYNon7q+Q213VXel5vnIis3JtD9qQs1HsTkskNlZlbslpahuHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oO4xTIz1kZqIfG/4xJIUopLF37rH1ueyAMniA9yKx18=;
 b=cqw2mrUE1ruV3TJ9znLxPjfISUYLwEPvk18TfbdUmVm6Tynd1ik25MaFb2SLis+Nkk7sw0MPlO8tMqPSUnGRvEAoSSIgmjZXY/PoZ+gPXTqES/CQ1lrGLNQWEdyXAlaMEokcr5pAq8AuO4sVE2JTt52nXjkvCW3kte0+J+UNY+d8r5X9uEyeY9eA3D+myOUoPRFPO6NkXqYRLUM/ci0kg91k/5eTIkelZ2LVjiqOxB4+AnbX1AstvWVOwjV804Lk4T5WF3xweLsOvEPeDaDAGqQSvc15faX6DaWdKimeFx1NWowbhNxEr5ulhAYvCtE27D6ZP0YpyDgJm8iTg0i3wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oO4xTIz1kZqIfG/4xJIUopLF37rH1ueyAMniA9yKx18=;
 b=jEtK3ZgH3vcmAbgekINTFP+GCT31JV9srFCA81D4ePpKTFvM2KQm9CMpp6YCkBLYoN6jiSrtFFb58bpxaeIj35aT7Mw9YDqSHip+EbGpF1diB6hxEB2CRozN3+bdmGwEtpZ8hOxLBxt2pv0V/xj2XcJgpA9QJ+mHbDe6fAd9NMsYjH/99AH7BfHzq/+sb5dTXmvVdNfz0fST9m9cMQt9dRL/u/WSV+WivelXqywX9DhRhEkmnv+NbG+43jNeKfRQVK2sjsMkKCn4Kg5s/Rgl3ZV/6R4xtd3NwOn0gXJyPoub2CZ9GDiJLOifj3p6xxgBTvg6/mSRB3nuev9zj7NmYw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by MW4PR12MB7336.namprd12.prod.outlook.com (2603:10b6:303:21a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.12; Wed, 12 Aug
 2026 23:32:09 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Wed, 12 Aug 2026
 23:32:09 +0000
Date: Wed, 12 Aug 2026 20:32:07 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
	Shuah Khan <shuah@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH v4 08/10] vfio: selftests: Add mlx5 driver - HW init and
 command interface
Message-ID: <20260812233207.GB730363@nvidia.com>
References: <0-v4-021df3fb5a3f+98e-mlx5st_jgg@nvidia.com>
 <8-v4-021df3fb5a3f+98e-mlx5st_jgg@nvidia.com>
 <anzoiALsjiWrsZtl@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anzoiALsjiWrsZtl@google.com>
X-ClientProxiedBy: YT3PR01CA0088.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:84::21) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|MW4PR12MB7336:EE_
X-MS-Office365-Filtering-Correlation-Id: 75510834-ba59-47e8-5358-08def8c9ed62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|10067099003|56012099006|4143699003|11063799006|18002099003|6133799003|22082099003;
X-Microsoft-Antispam-Message-Info:
	QOV74R9AKrQt8JOtQ5E2plpXOGGvOaeHx73u4hFddyg/RUCLtBwSWWgKQ6VeA3Ano2XUDn/y1VxsRwiKmhNUEj4auSELmlw4eap/q19IySbxfznJmIrxRdpS46EXnc3ilTCOz3PUnKjQksf+08lH4bLjXwyZe3XPqDvDwDG6faem5sG6hbYOj/sYIo/bg5b0Pv/ENbGyGdtiFy9UHzPVd/AX8ZPe4+z35lr3Fe5gFfrmCvjWR6OGCHlJOohP97kjJsUZCRzr3kBCELT5zDEYYNrfBwzz3gYHvsLRPf4ThvsGEyZYAiuXbprjgqBzpjrVR6lAK9/CHA21s+x0cJjCsqFII3WVBkFLNgVBnH2f7nKNQSBSRTVGnpVEwv1gEy706fV2dzRrrsRw4B8H1NGgtCfykh8NWFUiZzDw+mXR81ZBTzSjzmZVg8jg79wTmB/cei7/vQV+fPZGpI3ej04tyXkIRXXFz33N1ibtwdCbDvRxcz4H32Qo83JcGPnN2xTADgRkJBczxdtBJ8PeMqWmxUVUIAuj+U74nUlS/KGXDX4qdnWt6iaZGJlTobzkdV9sHq398o9jikQKhzjQMeIdvEKEJMIAPfTF3KTF0MnTNx8grrt/78z9rcqaEGbWYCnfKS0hI1A/XiVJy42JWPprRwLECfgjGen/Bv9z/3IIxSk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(10067099003)(56012099006)(4143699003)(11063799006)(18002099003)(6133799003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KRT2Mlxtf901ltuJpTh7iuaLk4ztIBiXaOALwmXyi9FgJhpeM+8kWtDqST52?=
 =?us-ascii?Q?scTrgzlcWBqdNFdxDkXJxODcdYWJhBT3fYQ+zXw0dqadpdglRSaPlR8enxB8?=
 =?us-ascii?Q?P/kfOGznAoqCB5mONfzR80AQ+0VDYj8xBoJEcLRgRz3evsGS3gFM0K5rgJGT?=
 =?us-ascii?Q?+fIRC92OMK+LYKnQSpDjrVF5ggsmwiDkjgBKPsN6BDgeLfw6M6co99Bs66jb?=
 =?us-ascii?Q?IZXFf8NJH4/z5JYOhiSB2CI+j7t0xSHMKld7qqAD5UH/bvc3UOnDURPga1YG?=
 =?us-ascii?Q?KPjs7Q+3UL7HcXlDIBM4Yr/nVm+fpmFyu0Ckg/MAJg2uIahGs1Lx2xDaSjrI?=
 =?us-ascii?Q?g0yhbS0mYN8CML/x6zImPOf/lf1oRyueIAy6iqUNWlWiVNLsuzqCcG2YbCL2?=
 =?us-ascii?Q?9WjoQgUmztUdCPANAKJgWbWe1ZnRTtFA1MeoS3xiQ7hWS6/YEAC5P5B6iuxf?=
 =?us-ascii?Q?zvo1/8NFoZfkDRv7FIYtmwMa+sPVvVDNIF/A98CVU40+tUdzN6lOhWmUyAOp?=
 =?us-ascii?Q?pZxk4fZ4qQvXAzjHnISwlf+xHsKzq8PuF6+nhi3hLC5k492tv9SpZ/OZUdbz?=
 =?us-ascii?Q?hmbikzd22kLD1vH8LsTVf5hkEO9A31WNzHgqro8J0AfHHtWX9EqDCOUC5kfX?=
 =?us-ascii?Q?HBWjv/UPpm4977GQsfEboawcbt/NP4HBBJNjGL/3AFxOf6cfo9k9T/BNQbH6?=
 =?us-ascii?Q?pDUtXssQl9mKKtCzZlqXWZZ7HiFF1domVYnTPUt1bHktMppVA6vbRqUbKqiY?=
 =?us-ascii?Q?6c+74HjwVK3D4NGGW/Hqm5egTUJEP+BxrG3r7cWJzUXPE1ODHg8yjRd2B17t?=
 =?us-ascii?Q?Fx564qGYnaQ7Ng8BDraI1xNfVM9OsZq+8vwxlZkFLAxEfaEE3NFBUIZAmZFJ?=
 =?us-ascii?Q?RJy57J+eQQ8J/VoRz7BoGOwJi1KIenlkKVhn774amCxhzV70P3VVppq3C4Jq?=
 =?us-ascii?Q?wCNcPdBvNUo7yYJgZwWocnWEZCT5LuYA2ZKMtKWi2yITNAirKzIswubKmvmG?=
 =?us-ascii?Q?hDKIYE1R1yIu3NK8/DibnWtZbsAFqHFMjup9Hj/NY9iCNx9tgCbloGb8gCNd?=
 =?us-ascii?Q?cE123WvHzyOEzBeXhxXuK5zvtJ59sTIyLZAIOiJO3Ksz2l/8lOkUzLvCX9sj?=
 =?us-ascii?Q?eNBRpCs+AMMFbn2QhNoO25iCdUyC63A9kKmaqipgGAtndwkzn6PN1jIurylO?=
 =?us-ascii?Q?V6SsSeEwXAMz2QQAh5u0De7kFuccpEbbkWarPfbC6n6YwU4vFVsrtXfMBBtj?=
 =?us-ascii?Q?g9OTzTMZjoXBu4h8YUHsDk0iNhwq5ZOkxocBenRRSGJO5eJU3ESY2IQXP6WC?=
 =?us-ascii?Q?e3vO/CCymn4a0q4blqvXR5EY/XD72bwpFUZfA6gmcTO1T0OW1G9JgQtHAyoO?=
 =?us-ascii?Q?Ume8mfSqXn6FxWtvL1IM0ez+w+KYaVT7i+M/JbPXgjaLOF5sTMgaPHzjFHsg?=
 =?us-ascii?Q?OH/Uuqwk80/GqThH1vFog1LHx9Hwkme+qWXr0F/10gcBJZoKw5Lo3BUnUIkw?=
 =?us-ascii?Q?+NXCFLjjefvxBhahptqSrPWpBlmrevDq8Ms8jtNUA8U3QHTFcf7c4glnYaEy?=
 =?us-ascii?Q?Evdh8xZL2oEncjrmgrS6RQYtWgg6hpP1Bn+UGEMTfQKr5KIZlSapI9Eg/C2c?=
 =?us-ascii?Q?mpD2wvcHVlJtic1ga4GZrM42sahOAEyyupSZn6J3HVvpV/YfJ5RBc4V3en18?=
 =?us-ascii?Q?9SEuPRUATxXmj0t3bQvGNavWzOrXyoHrdczSPYSPdRmnjXmwzWUvK//lQ9AR?=
 =?us-ascii?Q?yFk+yT/VlA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75510834-ba59-47e8-5358-08def8c9ed62
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 23:32:08.9888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AcDT33QuMVzObVH/2c8XWcvu0qMXg+EVE98gP2KwkR9AWL76akfAcT0mdvrLrqAa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7336

On Wed, Aug 12, 2026 at 09:41:28PM +0000, David Matlack wrote:
> On 2026-08-12 11:59 AM, Jason Gunthorpe wrote:
> > @@ -0,0 +1,108 @@
> > +/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
> > +/*
> > + * mlx5 VFIO selftest driver - HW definitions
> > + *
> > + * Typed wrappers, constants, and helpers for programming mlx5 hardware
> > + * via the VFIO selftest framework.  Most HW constants and all MLX5_SET/GET
> > + * macros come from the kernel headers (mlx5_ifc.h, mlx5_ifc_macros.h).
> > + */
> > +#ifndef SELFTESTS_VFIO_MLX5_HW_H
> > +#define SELFTESTS_VFIO_MLX5_HW_H
> > +
> > +#include <linux/io.h>
> > +#include <linux/build_bug.h>
> > +#include <vdso/bits.h>
> > +
> > +#include "mlx5_ifc.h"
> > +#include "mlx5_ifc_macros.h"
> 
> I'm getting a compiler warning here when building with clang which is
> getting upgraded to error from -Werror.

I don't get that. My builds have -Wno-gnu-variable-sized-type-not-at-end
which comes from here:

tools/testing/selftests/lib.mk:

# gcc defaults to silence (off) for the following warnings, but clang defaults
# to the opposite. The warnings are not useful for the kernel itself, which is
# why they have remained disabled in gcc for the main kernel build. And it is
# only due to including kernel data structures in the selftests, that we get the
# warnings from clang. Therefore, disable the warnings for clang builds.
CFLAGS += -Wno-address-of-packed-member
CFLAGS += -Wno-gnu-variable-sized-type-not-at-end

Why doesn't yours? Are you building it correctly?

Jason
