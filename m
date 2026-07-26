Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010012.outbound.protection.outlook.com [52.101.201.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6BB0381EBE;
	Sun, 26 Jul 2026 09:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785058274; cv=fail; b=rw/UJDWRQhQUu9B88Jerl7O3egBnRPcBY4npcw/heDfGxP05FZVpFhTxrYOv4SVQmYMtHeBJXUnefr8j9ToxdUYPph6qkAueKkKoORyvglJ9M8M8OiDgsQ5ogHVkY7mhbNXIfmSDbKp3mJIpI9iQWwjrh/OYyoTowys5gvvKnJs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785058274; c=relaxed/simple;
	bh=4fNEN+aWxxd4CQajhsZS18cSmbKk97vGyAOjK0bw5jU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pRLsPclrlGQ5w/AWRJnLoN8Bn0zXN68Taazdztf/BTyhbayHw8rAN8vyFQAdbs963R+3L9mQcWL9Ea85Mb1PCfDcPBXaz6LrR/QGffn//EVNRxi9gqe4v41mlhfS53Umff2PlAOWnyBUu1JSeos6YhXq9Kxoxdwc2Qaj46y/o3o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tZUuL5LB; arc=fail smtp.client-ip=52.101.201.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tZUuL5LB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sI95wjP4A4OjgCuY/5yeJPV+ZOvFwc+Ir9vT4l6uZibMPhA7EdseUAh4ulBdhcislrH+1I2AtlAPnZBPOnaO/cQEm/CiheMvCS10zwo2zYcxBhvUewSmQWcOAUyEhILdw3Mhq50ZMvHnubM78X0I0STx5E6g10I+zzKEETf9TSTiapaoHalCJSRtkzCRFFh0SUwMyLAkD+KmxCAPB/w5a7GAqSkNSQigFxCADxv/vsYphCP+5N4ev4TQ1H/cSfERVlamn26JORr+FV5qSUabCvmSnee6kTkWR5MUOt7jVzGUKxh4XjAkKx8IZFqgMSGKJFLxyZqRlUwOxGnEAIMvOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B0OFgeSngCe1ul5y/bIht8zbLhSW5qkMEFOJqVHrN+I=;
 b=V6PKn2af5uqykIYVcUch2am5xBKvbpykDw0jTzMPSyE8mossJYTo2O8dQKXYk+UbXhx+1s+NlbWmfbtBgi9kK/FyVGB22Du/VWZ9E9eJyEOzX1KIJMMt1ZKxQgDShPT8zfFqey2GH0oWrGT47onND9ufsLR/7hmHPael9w7tRbXUogQUGS5VG7/kEqZT7GBLFHSy/c6l19YQcWdePEITVyQuOHvquyhoqFcuTmZ9iLMwKZHWkMs+rwQZgcy3bVThg82F2zanIUTpqGPxEbQBZNIe74iB0Yh8ib1d2ChrWcSTRg1c87wPOmpbi5aB3EfxEVIiGXa23Nv94EG24aRXdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B0OFgeSngCe1ul5y/bIht8zbLhSW5qkMEFOJqVHrN+I=;
 b=tZUuL5LB+xv0io3nz40cL1BMi8PYNxnTCKM9gvqlrh9dp865sm+gUArXsVEzKampxYLZVvTwGn9zcHnn2y++IXO0CT5LEch79nWw9vbnKvHLqUl6Gp3U0fuHnQepjb1CJwCYcA2XipsgomnpLCj0OcikTcI47RfhaEyTSkCNvZALUAlNqDOSD/o8HmxVrLtyokzuma96yroyDolmXomxf8aX0zgw6EelVHGFF5B2G8/Y96/9dQqFRCgA69hiv8j5cmP1xzsyP5UudwHV+0rlZmArAVCOs8NBYWzqsVA6AyDbJfwftf77YGFiS7B5rb0kniafXJ6mhl5b5cHQq/HouQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9715.namprd12.prod.outlook.com (2603:10b6:408:2a0::7)
 by CY8PR12MB7611.namprd12.prod.outlook.com (2603:10b6:930:9b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Sun, 26 Jul
 2026 09:31:09 +0000
Received: from LV8PR12MB9715.namprd12.prod.outlook.com
 ([fe80::e74f:2cf8:cf2c:142]) by LV8PR12MB9715.namprd12.prod.outlook.com
 ([fe80::e74f:2cf8:cf2c:142%6]) with mapi id 15.21.0245.012; Sun, 26 Jul 2026
 09:31:09 +0000
From: Michael Gur <michaelgur@nvidia.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org,
	Edward Srouji <edwards@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Li RongQing <lirongqing@baidu.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH rdma-next 13/15] RDMA/uverbs: Add new Unordered MR access flag
Date: Sun, 26 Jul 2026 12:29:27 +0300
Message-ID: <20260726092943.2880176-14-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260726092943.2880176-1-michaelgur@nvidia.com>
References: <20260726092943.2880176-1-michaelgur@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0064.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ce::16) To LV8PR12MB9715.namprd12.prod.outlook.com
 (2603:10b6:408:2a0::7)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9715:EE_|CY8PR12MB7611:EE_
X-MS-Office365-Filtering-Correlation-Id: 309cc5a8-0841-42cb-7e2e-08deeaf8a01f
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|10067099003|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	qDv/fxua5AwOa895Xc813f+slSZgEFXEj+hzbnB6RIWsia0pJgQHNUCCbbwGA0spspNfbJZwP5/k4R3v01QIPRlXGHkRWt6V1vtAmkchgclN3UlCgrLqDDMamxeSwmyS2ne/l4lhODrbaFOzsw4G/f6ZXRoVTs4A42pLmDq19zEQIJXRVM8Y7yWnQUuZc9vg54waMDEJQfpaBAc5QCq3K+y7rcMyV4wmI6Stcfmob9xg9QCdE3B3ibIV0HseDMZdhDFjH4NTqijP2gtPCKSvLTB2nY5ijq+Ct1ZFQPaprOUAxUfj3XcB0Y5EXiGo03TztvzpxqrRTEgHPxYzXlefsek0R9LWfqJcoY0xjALzEnFwWBxKOjbZK6GW/cF3N/EQ0HoG3+o28BrgThjPn3Ql7buc/IIsv0bNNkOb1UFH1ZHho88m1HePZULtiyDk78cfpobeA/dxWTdol/CaKjgUtvtPx6b4gjxhTqk//RYFQbaULV/tSBRJhoZDdFnkr7i0ckJtUMzSnJjQj6+Mq43PY4ccubYjqEwXmi2X5Us51ENPvwJnSiey2qy1+UTBidjqTDnnSb0U5UFR/A3KX8MJWlppJdoQtOmny0eC1Rd2UFUhBTWfby1DeRaA+V+6lRkaBxA9Rhtc4AHnl+Fung6fSnenT0AJxvXD8xtFoTvCl2k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9715.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(10067099003)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sixqeC7FGnB7fwC6MnbLGzIyscjOR1QF4UCiSSYtCBc9GzPmRo1Xc16oo4Qr?=
 =?us-ascii?Q?h22NG/C+cUnBXe+3KWXfqXF4xRLCG0gKdbZY3wfNV395j3JkiFgXQcwOgeDa?=
 =?us-ascii?Q?hoUXhpBxXnZaX0rlI3YriDO9rVWTQrUDKS04Mhb/LtAsIZ+AIy7UspSEPuBC?=
 =?us-ascii?Q?TdPyQ/agb9pEq5Tps8bBIn0469ddYKneRSd3FEUxZYRsb5W+dS3k+Hvrsm4Q?=
 =?us-ascii?Q?pvMtTdBUjJDCzDermqyV3sLXsiKOBIHVVzdiEr20rbJ6Bt/fvNcvs5wFsL/m?=
 =?us-ascii?Q?7434W2/MpxZ3UvLXACzsXSNXFBPOa7kmf6ESkCh4LHvz3/bG/Y7iU50oBich?=
 =?us-ascii?Q?bbJX+5aqJ5y1+I/TtsPXu0SlK27okPcL4FeR9orHsLH0veqASRfc7SLxeXjm?=
 =?us-ascii?Q?uUBqdgvNCczlaGdCmLkbo9geJYnzW64oTS1cxxWXiKItjjV4+kOblsdXe4fF?=
 =?us-ascii?Q?PCLauRgvx22nxIdrfPeHRCfhW8FefQ8UBpCls/OdEZpFOPxwHWlB+bDrGeCM?=
 =?us-ascii?Q?+xXNDGc0x3YDLyrYQK2dSfXMSKZraT/vtPRzBOZynmVUQhATrq0dLrbhCBrP?=
 =?us-ascii?Q?P08mDlsIxGXVz6ViFyoosVSs3YYfpqKK0iJe2ZcTV8wvu37RlYB03N4WLAac?=
 =?us-ascii?Q?WySzG0z+LmHki1QiqUfRC/I6Ok5I97NjrcQGSLP6rvZbAtF+RfhzHy6qXqkv?=
 =?us-ascii?Q?CeOJJP2nKE7RrJ8/8Zc2d4nYrUIRsFyOWgwYUwNyBPOcdf9g2QAfwcEHQdn1?=
 =?us-ascii?Q?BTzgikbymAtviuEct25/UDGvWpq9RFgd5h8oBPfX8E3uh8geQp2YgU4ky1sv?=
 =?us-ascii?Q?2rLa+8PUMHZc21UcnMgwJcXhzsnQEhz1OICwfEVcgH7PMGEIECdi0K8qvNc9?=
 =?us-ascii?Q?Qu7eVXsssOB2+7nMpXRod9G1AkyE2eo/E1YY4KcNTqy0vZXJHEfi1pLFmbjc?=
 =?us-ascii?Q?JiBOzhOyUcwBNkT67JjJwGRwK/hMRks9wWrFgcW3z81dpQOYdJ0yZYagxs8F?=
 =?us-ascii?Q?N6rMrgSI4o7Mps84BEx4UB78azLmnd+57Pn7eUnyOmO6D3urdw2EGYeMGsdW?=
 =?us-ascii?Q?lXtmORDZStmc5IST88nbPRstuHhginnIaEWMyEUYIAFw8qsf+IAFqKSeDMa/?=
 =?us-ascii?Q?A1BfBKs5Fbv13LRWOUB0/WPRlf5XPCSm7Wsmdd0xrX94PhnQOVyiL//HfhKj?=
 =?us-ascii?Q?RyX+wq7uCGqF8vqhFr32jgSi3RGI0Z6bEGqwD2ZyY/aUUbTxxtlCa6i8LQN1?=
 =?us-ascii?Q?chhlmkDVcq1LMpNK7YHI/qu4p7Lq4zLvVfxMvnmoDNxPgNjFZR91GF93dghJ?=
 =?us-ascii?Q?Z9QkA2PUTmSHcXzU5rXPmtWdGdEiw/7mWHpwJ+VdTJp0EyIO0xJZXUoKDFWT?=
 =?us-ascii?Q?cFr9dWoER8S9U3MJDQXhMZq9sedLc1UY0TA13Fc0vEoeMx1YevX4EBlRh6Tn?=
 =?us-ascii?Q?xHwj/siML3xzXKiPXZ6+wdHrnG7gOjqn1GB5DOaME/W4hh/s5oGmb+v1JQU9?=
 =?us-ascii?Q?AFCJmIkkHTqs+negsQuIf2o8fgmPs/39kgNej6TcXTODXemFuE7DxvBfHhBJ?=
 =?us-ascii?Q?Vb5eUGNKW2S52h+tTk/yRA5VzAG2lUutsseeCCCsZCSYXW/sDI9t6iNZ3n4W?=
 =?us-ascii?Q?wdMJbz5YDKb/sjOax8hd0WdsT9RVe+ufJP+FITXKoX+cHIqO+lWRY71jw91H?=
 =?us-ascii?Q?9jlGaXbHBdm3fgTw37FOBdfFKbNTQcWhPvKI/9zE48tuoZ8pOnhd0dmgy9CK?=
 =?us-ascii?Q?jsMxptHxMg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 309cc5a8-0841-42cb-7e2e-08deeaf8a01f
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9715.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2026 09:31:09.3302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KViAnh8kdtNDy03ASKVbM+G0wjQgdjFeANH6VDtwRVLagUL1cF3yNplw+fbjOS3hmL1VM4Su0izZ1PJ+v+jwdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7611

Add a new Unordered access flag for MR registrations.
This access flag allows additional relaxing of the order of memory
accesses to the memory region.
Using this access flag allows for concurrent reads and writes of this MR
to be reordered.

This access flag is part of the optional access flags range, drivers
shouldn't fail registration for any value in this range and are expected
to treat them as best-effort.

Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Michael Gur <michaelgur@nvidia.com>
---
 drivers/infiniband/core/umem.c          | 2 +-
 include/rdma/ib_verbs.h                 | 1 +
 include/uapi/rdma/ib_user_ioctl_verbs.h | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 81f44dadfa52..c44a7509ebf2 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -204,7 +204,7 @@ static struct ib_umem *__ib_umem_get_va(struct ib_device *device,
 	umem->writable   = ib_access_writable(access);
 	umem->owning_mm = mm = current->mm;
 	umem->dma_attrs = DMA_ATTR_REQUIRE_COHERENT;
-	if (access & IB_ACCESS_RELAXED_ORDERING)
+	if (access & (IB_ACCESS_RELAXED_ORDERING | IB_ACCESS_UNORDERED))
 		umem->dma_attrs |= DMA_ATTR_WEAK_ORDERING;
 
 	mmgrab(mm);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 8d82d303b723..a28ec96057cd 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1505,6 +1505,7 @@ enum ib_access_flags {
 	IB_ACCESS_ON_DEMAND = IB_UVERBS_ACCESS_ON_DEMAND,
 	IB_ACCESS_HUGETLB = IB_UVERBS_ACCESS_HUGETLB,
 	IB_ACCESS_RELAXED_ORDERING = IB_UVERBS_ACCESS_RELAXED_ORDERING,
+	IB_ACCESS_UNORDERED = IB_UVERBS_ACCESS_UNORDERED,
 	IB_ACCESS_FLUSH_GLOBAL = IB_UVERBS_ACCESS_FLUSH_GLOBAL,
 	IB_ACCESS_FLUSH_PERSISTENT = IB_UVERBS_ACCESS_FLUSH_PERSISTENT,
 
diff --git a/include/uapi/rdma/ib_user_ioctl_verbs.h b/include/uapi/rdma/ib_user_ioctl_verbs.h
index 51030c27d479..d2f9564e96db 100644
--- a/include/uapi/rdma/ib_user_ioctl_verbs.h
+++ b/include/uapi/rdma/ib_user_ioctl_verbs.h
@@ -62,6 +62,7 @@ enum ib_uverbs_access_flags {
 	IB_UVERBS_ACCESS_FLUSH_PERSISTENT = 1 << 9,
 
 	IB_UVERBS_ACCESS_RELAXED_ORDERING = IB_UVERBS_ACCESS_OPTIONAL_FIRST,
+	IB_UVERBS_ACCESS_UNORDERED = IB_UVERBS_ACCESS_OPTIONAL_FIRST << 1,
 	IB_UVERBS_ACCESS_OPTIONAL_RANGE =
 		((IB_UVERBS_ACCESS_OPTIONAL_LAST << 1) - 1) &
 		~(IB_UVERBS_ACCESS_OPTIONAL_FIRST - 1)
-- 
2.52.0

