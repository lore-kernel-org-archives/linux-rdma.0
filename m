Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011006.outbound.protection.outlook.com [52.101.57.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449E54BB27F;
	Fri, 11 Sep 2026 18:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789151838; cv=fail; b=HSIMsg+3TqF21mH0RKxbEZJBC3alp1/9x8Ype00qqphhqPZBDX0HtKga5m6EsIJeYCQaLxETkH4PP66Bu8mwLnfJ+psrjdEIbpAaM3G8s49casGKEiMkcyPyPQ3E3FPGIxr2v/4PWcl9l69d8Ej0ZwdJ/lKPeY71UMbDm2JPnDw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789151838; c=relaxed/simple;
	bh=02JrbgqYBOwxI/g50S9BYYQPwWbeKD7kWGby63JM4XQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hy/i+1p4xZ9sXNIM/HILj/HuCA0h8NorNe5qCg9LPwEkj+uGlgXIRQxcPZL7dt0Avdfp+h882qy6aQ9l65e12LDXy6LJtlmEnmngXi09q2V4Tiqnc6iBqLZZA/iaPgKt5nZoHPibal4sFz965LT1O5B875OBORyB7MQLZ8XNYZA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NmJck1KS; arc=fail smtp.client-ip=52.101.57.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NmJck1KS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sokZFVE5ENZl7c0EOKywJJr6rjpoOoUk+LRmRfVzjR8iAPQ4inOJTPODhpc/Ce5KOESCHFuYsb3PqYMBGV9Kx3f5uMdLDNS89mQ7Dc9ui8eAbR+/0g5g0Ku517vo4ADuM0PTcUaWx2XJCyNx7BMVfup+F4N8C8XokhWiTa7bXYl6jtySAq4TAY0rA1uODoq+teYbVlx2GeO6FvOInDTNaMKdyNz0mrOKUwIkh1XhTKneqYXewbXwDkrJiox8OrBQ2z7k6VzT/Rk/rtEZS9iPFzZHfGha3PbSVfoGBFnMoeStzQ7nCe6nkWaPf0PhMEKh3+qebybI3hZZEoV2Obxjyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c++UqhlxuyFJ2zbr0GadNQoPo9l6Nsqgw5wxAf6DDCM=;
 b=xXiaN7VzbA3M+zM6LIcHwgLrhS0/YJgjKJme1dos5NvCH5NMUrPtCuIo8kMgYCcpFQdqoFKIMTynt/D23eZnp4zFwUK1pNBpe+mSGuFNA00ulwfHSVe3tYl+S0pP2R9NPYgrp611Mv7Iom+kOZxCsxowJxfxgGNaWIXimkEqwEsvWHMnodlesKJG7dumAoi0z7ITw6KBnPHWS/MCZKRf0aLN9KIIOyQQHXONP/6pvCBUiQMvFANZkHYCoSX5h6vKu303XpTaaLIXJMyzWcrvw+bAJm69xoPRoLXyPyR0Krby4wTj3ArU+RAwM43512Sa58ipOLrdyKGz+jEa/gkaNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c++UqhlxuyFJ2zbr0GadNQoPo9l6Nsqgw5wxAf6DDCM=;
 b=NmJck1KSNlhCwzn7Oay7ruL6IDYi6ISqefzto3Eqc8t7ga9iCSogl9I5jOpo+51d9xRSwrYGGQjE6DX8ETsfAIpz7G00ku32S7fuoIiUbFCuJzUamOtRy3ZYjWmcI+PBjetKj/chCJKxQO/Z2KmccnsEpqifypicUPaOeA+bvIbq9EKq3dtq3Q0Vmnf3VkXe92ZIkQXvwwZONCl2OGMrqgNcL8lgb6CZ7znP6Swf8EyCX1blGY0/F7JAaDfUakbWM9oDQidks4KvzGzdZ+DO/2AyhbgYuI3gWtb3wpwsI3l+K14P6uchPLmKUhOlfaIMidEnhinO23cPyFtBLGc5kw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by CY8PR12MB7539.namprd12.prod.outlook.com
 (2603:10b6:930:96::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.10; Fri, 11 Sep
 2026 18:37:04 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0406.007; Fri, 11 Sep 2026
 18:37:04 +0000
Date: Fri, 11 Sep 2026 15:37:03 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v5 08/10] vfio: selftests: Add mlx5 driver - HW init and
 command interface
Message-ID: <20260911183703.GA1350659@nvidia.com>
References: <8-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
 <20260910235832.4B4E51F000FF@smtp.kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910235832.4B4E51F000FF@smtp.kernel.org>
X-ClientProxiedBy: YT4PR01CA0278.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:109::19) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|CY8PR12MB7539:EE_
X-MS-Office365-Filtering-Correlation-Id: b3acfe91-161d-48bd-d2d5-08df1033ad18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|10067099003|6133799003|18002099003|22082099003|56012099006|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	OxoZsrP4Dw9p3HTgq1jHYNdodPBx2s8FPt/lMMdSJDHJ9mywOq/pAdYZchocM2OTjvXo3ECcohMU+Max+QxVDREnOEZ08OmotTelZYbEUYJziFawiVNnxL6AZvQbb9YgLwGBCW126DFC0tPSehqvFxKyJiJM2EDbqnVAhzN8K8tkcPrp6PrExtNWEowZQIH6qbrHox1Z9omlXvoALi4fDw4RqtmO6mYxwhtETcFwjZ1XZKt5DSAr8R0uXR0Not/a4pQ0iTFRPhiE1VqEk98DT9jTgBUQ/iIoaAyR+mJl4TqEcd9Q1ney/5Sgm6mve7ZlydWp64aG9l4WgyvB/XRXZ6do3G0L59Nn7ggikY7ufyJVnmBlOgbwARIXEalWw9Ktsb1S5o42FrOhrDWR6TlptXVi81fjU6m/JZ+Z/bVv0Hr16FwTOwUOaitWotI6zdcbmac5knO3dMFUGsyqp2o5kUwPPPXuoDSuNwz0ZTX4aMj2XITgFIjuwE0222lfHNAPlcFfJBmy1Sc3eSSSml7RmvT2iRdtKq3HDtyoVXV80RvLrpKEjkUB+6RenLAtxsXFHTGcj0xDssGqLjc2QZmzs6lTiORuXBpNQpJRwFNeGOWcuSinKphAyg1srITPK6hBNljOPZRfxIBr0lwNYwyaOopg3v6Cbc0QehwF57lj+Bg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(10067099003)(6133799003)(18002099003)(22082099003)(56012099006)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tkX5QuN2YNxxzOoqoIDdV9BjxHA5jMq6f0VwrmLwa3Ysk0nXmFpuAwwt8zIm?=
 =?us-ascii?Q?MHgfxhjajeiTE7ng7Gn1qmunBEWz3+aaFL27qnncJQTzBiHP4vKQJt9lbRCa?=
 =?us-ascii?Q?jx4de+CxSI+8WoAznorW1qj9bQMFWwAFy0fmEwSxgPlPYEVqHnT1mZLJnl8c?=
 =?us-ascii?Q?ptQhIkb5GN78Yxy6bRpMI7n516tzuEw+xS/tjwu966gRJ2XeAb2oVRQnmmG9?=
 =?us-ascii?Q?2cenWKPl0Qg9Dagowb1kHMkze++nt8A6ows2C2puJ27G+j96huDRVI7YFYdI?=
 =?us-ascii?Q?2nhLTHGRFjTcgC5EGiIcZaHfdtawVaJLdDMMIFe8plAEU+Wo4ozladFv2f3F?=
 =?us-ascii?Q?pvpkGbkiI4C+i+qpPbZYynueY4rmc+tv3gA7XFHXAHSOG0mfQWy4B2uL3dPU?=
 =?us-ascii?Q?HGvlSA7icjKDHWpM1P9oSG8EreWPBM8TIQTD66aUm92AgnDMlw3DX+Mv7uyz?=
 =?us-ascii?Q?nYgHaqBydidRjCjNXIoOgWU6VHulWeFjPJ8e+wA5jtGHasljAXnadohMHGtU?=
 =?us-ascii?Q?W4BEmUeM4nApRx+ijQDXj47uZtS4KZQopFuxH15DMWh2k6fLBRYbkIm6NaFJ?=
 =?us-ascii?Q?ixdaVl4tVLtny2Aa4ZXWqCHjBl01t4uEktk224F+IOl5lGwluwIqwd9lRlny?=
 =?us-ascii?Q?Hpd+G2qlLeqSr+rCWzkku/6Q5mGcwqwAuAb4RYiwWTcmIwSaGBFJ2ofe3OPx?=
 =?us-ascii?Q?Z5pONNXUMXY+DNAsMM98NHfLt9jbAcZ4KOzmRJ4xmxZnjBxG8QPlGaPFVh1X?=
 =?us-ascii?Q?8eeGbb8FZ0qgpz/wBkuM2BwPvSI3YH2y4LORLz7tRDsJrDOOwzV/WNv1kGn2?=
 =?us-ascii?Q?2ZE40ZjPaM7LPpO558Y3p/fT+IrJfi/ZXHngMTScIPFOpeQr6RIwE3YrynQ0?=
 =?us-ascii?Q?Lb1k6HW/TNxtUextDajHJJqSbbCehZD2foafDsRKQ3Kd4V+PDVNhUXRwD3DH?=
 =?us-ascii?Q?jrZwRHG/2FnpZ6HGjbJHqqEit4E6FYZBOJBlXYnG2dUHR9ZfJrAqHaFfcS/j?=
 =?us-ascii?Q?acM7Ex/RarZtBag4Py1/gMGm/ehDRCIPZsIS+wLvdZI90rpJPlOaLzjjEJTB?=
 =?us-ascii?Q?S6U4lJ/mg7kkIL7RLVCnZMmdHG081T80ZPjZdwjY4MjciXeKc/8Qg3ECRdXn?=
 =?us-ascii?Q?95+tjm2yHpiyrI2O5uxny+Mpt2YvGomCHFYqvZYFXKJQSDrVuObPG+zxAeMl?=
 =?us-ascii?Q?kl9lE3aXoe4ZYU5f64gZJz3cbeV1OaU78WoevSi1PhgXrfM2+4bnVbA41yS8?=
 =?us-ascii?Q?Mb2/w5d1xdO0xliqee+/2Yr/qwIhlEqlxne4YdPQC3i4cDgLSwMk+DYr1qa3?=
 =?us-ascii?Q?aB8hnMqcBH6IH/XDNUvxFrpH5IY8rT7bubo4NA7ALTnAg1plb0igiiR1kq/4?=
 =?us-ascii?Q?f8Fs+hUKa81sfhFZqySlJTg/lTVu4LdeYVofxdnRqR1+NUOicJ6z/CPLsLTu?=
 =?us-ascii?Q?QjLf0YhohYBKSts344TNKUbT31Iv9hIO3SmJzAOFqo1BlYiCoIaMtisZwtnz?=
 =?us-ascii?Q?IKHVGvAHZFTSoldO3/9E2hteBSjkUqUsLw2cv4t6PEefShuPRhnnMBJ5SckW?=
 =?us-ascii?Q?QIvcfrgeBFyr8Li+LSaWLweP6bmINwPsCkoxrwSvX/9GX5lFuhdgIrmujcxl?=
 =?us-ascii?Q?7lcOGBzkWBY8yFk6F6uzT2kTDzDeZrP2PUr6ZhMGnWdEbue3aWhe+JXuNlfC?=
 =?us-ascii?Q?SsSPG/ojmYIqdy1C1glQsfA7R/IdQa6l2gB8VH1nFDjKR54u?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3acfe91-161d-48bd-d2d5-08df1033ad18
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 18:37:04.4197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J3ndzEkfs0X3UDoTeqbXuuM133WBulHjy/i9+sf+kSpZPoxSABTLwSX8WU7qldbC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7539

On Thu, Sep 10, 2026 at 11:58:31PM +0000, sashiko-bot@kernel.org wrote:
> > +static void mlx5st_query_fl_caps(struct mlx5st_device *dev)
> > +{
> > +	u32 out[MLX5_ST_SZ_DW(query_hca_cap_out)] = {};
> > +	u32 in[MLX5_ST_SZ_DW(query_hca_cap_in)] = {};
> > +	bool fl_roce_en, fl_roce_dis;
> > +
> > +	/* Query RoCE capabilities */
> > +	MLX5_SET(query_hca_cap_in, in, opcode, MLX5_CMD_OP_QUERY_HCA_CAP);
> > +	MLX5_SET(query_hca_cap_in, in, op_mod,
> > +		 MLX5_SET_HCA_CAP_OP_MOD_ROCE | HCA_CAP_OPMOD_GET_CUR);
> 
> [Severity: Medium]
> Does the MLX5_SET_HCA_CAP_OP_MOD_ROCE constant need to be shifted left by 1?
> 
> If the constant is defined as 0x4, passing it unshifted results in an op_mod
> of 5. This causes the hardware to interpret bits 15:1 as capability type 2
> (MLX5_CAP_ODP) instead of RoCE, causing the driver to query the wrong
> capabilities.

This looks correct, I will fix it and repost

For the others, the driver does not validate fw information (aka hardening)

Jason
