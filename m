Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013000.outbound.protection.outlook.com [40.93.196.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBC23812DB;
	Sun, 26 Jul 2026 09:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785058278; cv=fail; b=ImSJhRJFYt0PJASGgYMXyJREapCSQNz6YeqT0g2P6/K4nTYdwx/mM6id5j7sgq08qrmoa47w5tyck6RsY6XX56qQfJqlPZB8pL0eQBAFb9cH6+mEpGkVz1E3qetbyn5J+xIQ0pmdah0mDSt6kKg+ULTg1ks7AwMLJpCYt2NYnao=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785058278; c=relaxed/simple;
	bh=MV5m7HotdTVDumZoBf+zJX2cJiLxKKPYtBmBR/bl3DY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gPIU+QRofNy4VxYHTyCpjw8LVtjd4+4HmXvXyELYh9zlXfpIuO/z6OVcatHzvhHd4tsEfrwn1VMK5dCx5mxHlzm20sraqKq+giVnwcIvoHYSzyeQ1hOX0kXKth1qJe+AQ9qD9/oRsX3/w5nEcmVE0jIp6QlyUc74olejTgdzWgs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Xy2ey6e2; arc=fail smtp.client-ip=40.93.196.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Xy2ey6e2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OO2XnXPiPjre57XdZlJ79dagCZiptD3jXm9dsK30H4M4i/jWQ4ZpAmVaaU7yrdannC3M6I9qDr1A4zeK+Q5Mvq38+70JNfNpLDt0qoGWE9eFEXYDk63YPFEN1s5bvzhgD7O3CGbJt0nWRrHupMzkePZCVHTDz6Wz2wAFBXN8jVLShraSRT+oHJ6dzBg88ks19nG9QPqa228XYOZsuSKZbG4BtUJmTtTaPWonvIZAndkLxGjAJ8O96rncblIDSmVqlljzxBPiuLg+DHwkc1qYmbytZIZisrWz1oT5bWBRXL5dP+Zedj5gF+N4rv499tNiRJK7kUh9SN3Q0eM0q1kAuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9UFXgU8TSAZrOZ4GtkmroAAvxtmF/UEqHxRHVa4pyZM=;
 b=YwHAOYct8SDnQQWABzEpFlLA58XbviA+bBSCGC9X446yV766IjgSzSG9pWBNGFWu68asUZz3W9+g92fOcrhEX9ZdjNONPa3qTyqB+zA1qFifqXHl/xMrgP/f/3pIPNcIYsY7jK73RsegbktPeQUhlIB4wzgIxlydwlMSeKMX+9suM/v9VhdK7mZaUUsZ6HaCti025YKhKYzin5yXDnI6VZzVyb/NVswNn1iT0f1nJaWL44Ue3gz5ehbm2U3a2qIyvxSSjlQJUtpOcz/bl6Fmt6duy62Hs+z6cCd5Ct++RxiGiUhROrsjMpo5f5yJFlG9TdkI8UjWeNdyykXqyKMxTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9UFXgU8TSAZrOZ4GtkmroAAvxtmF/UEqHxRHVa4pyZM=;
 b=Xy2ey6e2Z4C425N79o6yeV36rkK3yNHlRW3chzAZPNAr8b++NNLpN8Fy9CQkTNPqYy0wLRDPf840K/F9zxcaghfsgbhIIDV4GI69xdaX5Au2d7csDxZFQVvXc8WgX3kuNPKwMkd7qx5AfcVC+1dynP4RfjgZ6CiDvdleNSfIcyx0jIlXMcrcfpnndetEK5+y5uDmmE7dBdsq18cJA7IsRa5uKWWcussZGaHzewKSI4xFUisH6tdFotpgSgiRUjrJAMnz7guCjaPecaK5uI44rVWYSB6ZJ2deb9jf5sEFfv7tkUnTX688UfFlPuFwOiL81DeoDcTHxMwwnh6oXSpwwg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9715.namprd12.prod.outlook.com (2603:10b6:408:2a0::7)
 by CY8PR12MB7611.namprd12.prod.outlook.com (2603:10b6:930:9b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Sun, 26 Jul
 2026 09:31:13 +0000
Received: from LV8PR12MB9715.namprd12.prod.outlook.com
 ([fe80::e74f:2cf8:cf2c:142]) by LV8PR12MB9715.namprd12.prod.outlook.com
 ([fe80::e74f:2cf8:cf2c:142%6]) with mapi id 15.21.0245.012; Sun, 26 Jul 2026
 09:31:13 +0000
From: Michael Gur <michaelgur@nvidia.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org,
	Edward Srouji <edwards@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH rdma-next 14/15] RDMA/mlx5: Support new Unordered access flag
Date: Sun, 26 Jul 2026 12:29:28 +0300
Message-ID: <20260726092943.2880176-15-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260726092943.2880176-1-michaelgur@nvidia.com>
References: <20260726092943.2880176-1-michaelgur@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0398.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cf::16) To LV8PR12MB9715.namprd12.prod.outlook.com
 (2603:10b6:408:2a0::7)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9715:EE_|CY8PR12MB7611:EE_
X-MS-Office365-Filtering-Correlation-Id: 2839b491-c85e-410c-81dd-08deeaf8a295
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|10067099003|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	wpetS6rzJjj2nHhBdj7EuLd3bjtYInAwwx4Sjl4MCuaQHY80BxGkV8afFA/oEFIbxZAENxQP1iqNnGovxeG5YzGfzxW04QQKwG26a/9zhjrviLjBdkNIL4X1WxAH5+KsUNnhXd7oqKvxeBIIpLrES7GjivO0Sl9MYnyo4RfoATASXqwfDqZdfoT2Mm785ykr19IM9NUsviUwo/gZQJcdWXB+vvc+w889I8Fzf0mF5YIhnofPz987zLVwVsNTH05TTmcQo2EL+LZVCVXENZuBUoUNpF2SxE/xkBaODCtE3pTAaEkcNFDZSiw6dZQ6WuOq2LKSiY3w0I5ToPIZ0acM3KA95DXqTi7f6ok221d14uqNv3BQvbqe3xd29SzAb9eUyrd92PnughbM9Y5W4bPtgYSBTG6pOJd0931oUU2VUiJhi6M4hdR0hnjdj47KriTBDOF3V39cvS2D0wf/FTUcalazRxp+qHWXFFh+GrtyBZfcL1/ANIgkt/m3tr4x38MVyT77XgcMk/QhUDv+IP9VkXTIdTZYK6GRmI1H8eqR/60tsv7fVKfjpqKfVAsu7lEoSjqz7HToLNcz1ufqiPLNgKKXBSM3MH0+C3RpksBy5K8ApaGtA70Jq7tURs+l4AU+L1KPeliQb6P7rsAv2JcLNAHKlynJMnT+eZxVfqrxnwc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9715.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(10067099003)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4vmtygJBBTAkffDX+Kj2OauRoLknH4TKwLMyUgdJb+75MuDHGzGr3KkuAUmh?=
 =?us-ascii?Q?Weq7cv5pML/qg/MQAKgiBGJq/Joy6fUiJYiCnC0I0DfLKDdP+qFZeFsBf9io?=
 =?us-ascii?Q?dvFHPNKbjDN+a5f06RLp+621gasXhV8xVgp4b/FvnCFLex77i6/s6HtsJR2Z?=
 =?us-ascii?Q?umi3haFwDkFZsNDyQAf5Svcz97aDMyKLPojUZYYhy3efwwjfXf+Rh9wtwtBN?=
 =?us-ascii?Q?DwdVJ/oTMcr+PA4kRlkGRcRAG8BFtAAu2avqn8P7/cbsgJXlhztMj3YHhWrd?=
 =?us-ascii?Q?7M9AylcEDcreLPZW8tnEP1t5F2ZTiMsesNXJVRkV2hgtOTVOhs/k/zTQu0Uy?=
 =?us-ascii?Q?MjiQEhC8252vHBjZXEZWTtrnrOh14strntnxdMO5SGKpWnpk7A0YxH4P5tB+?=
 =?us-ascii?Q?NOWm2zs18zMNl/xNiLX7V89gdxvt8s6cA03h4XMcjelilTVO+wfKiZb9HMb+?=
 =?us-ascii?Q?iJx1lNZ3jMlNHPBrNDqZbhY7KmcKK4q6LKzosU+lvm7QdkDPFmvb8XnomHo/?=
 =?us-ascii?Q?9jddXf1+2uE8GdspBU6uG9AkHOBfXCoBR7+rRRI4PpnTkBqtMaJqmc1b8CTY?=
 =?us-ascii?Q?YQ5oFP7zF1ldGSS7HXnwTcoBreg+DqAWZZu5n+5J+t/IdQapLdU0RHo98fMA?=
 =?us-ascii?Q?LrL2nXLAT2m4YeKHnU2nAHGIOd/CxY5Q5m02XAfZ3JtBJl0xX3yhqT9i/TVq?=
 =?us-ascii?Q?BooKQkN61zSDRpm06Q4ZWyjaDXQZCYNQhIT8Ake+HWUaTeFT1+7veVXxDaL9?=
 =?us-ascii?Q?KlAtDesgjTSpED+VF1fgvH0DtBESB5f9EfwnXdYpeQ51Tk2oN8aY+BfPF/ww?=
 =?us-ascii?Q?u9RIcGvZ4BmUb3IbWstfWJyfAQa3x8wIurrrOkE1OnTtTw/82ocA5Pj2qb8r?=
 =?us-ascii?Q?48YB+ZdLabtyvx+emktiPbTpuHDDGZxrdOD+dcIvslkfBJXps6Fs+Fj50wam?=
 =?us-ascii?Q?sZrfK8OvJTHVqaHcVhYLak6U3RlrMAyWfqxNQoHrY8eu2mHyPA4d9abRdwe9?=
 =?us-ascii?Q?LuNqAWawPrYRQFQLOpqRBzFcFYmJh71vVHdbn6GWFOeLHggxPXnY5awNYC3c?=
 =?us-ascii?Q?nojEcFe9OU1eEJtJjQc/EMvTiO6jy6sTZZUz8ipdM93CSyL9QjeqDFftG7XI?=
 =?us-ascii?Q?1xjJ5PEWGyLEycTFUmO3uZ6FE7/tyFBDdJfNPQyLus1nfReUGWsloHB5i0RI?=
 =?us-ascii?Q?WrP2yNQ+zlnPBj1R1OGChcxg5fGNzdMSWtlchi/ftpLfRDGSCbxIuChLU1Og?=
 =?us-ascii?Q?lWu1QInWpbwdzPoVoEgfHJgiR9gXMx9fexpr3YRT5FEM6iRHfmxTfj7KTL04?=
 =?us-ascii?Q?OGUGKzJazJNMcEEu5KN4D+dq01TliSFQ8ekp7/dslmKfDUYLJ8qINemVnn3+?=
 =?us-ascii?Q?sJXq7S9gU/GVcC0KuEtBfw8FSTCNyt6MAAZw3Fn55SCO+D01bNpDkE4fsS+k?=
 =?us-ascii?Q?KTzM6fvQUqHUmFmcwVbbsbRqZc4fBis2Lq3Nr3DPCweiN7LfxufjU9KnA0T3?=
 =?us-ascii?Q?sGe9JJzP18fssIO+rz9a96EoUuXxu7sshgZvtSIMh3NaCpzZLI6GN6DeBtUj?=
 =?us-ascii?Q?qdYDn+v/DQZtr0iBhEUVFSutFoMnm1S+30TCcyKayTIw78Wfc/cv6nk9btk4?=
 =?us-ascii?Q?fF4p3X00PQIRMSQYHoPZOkUTANGTNriWdWkL+08Z9JDrps5SZturVK5lyqvN?=
 =?us-ascii?Q?I3+qqJQaC8kkM2EPKpBby7CI7DpRLWy3rzyDna2U2Z6MJNtNxnvo1rEf4n55?=
 =?us-ascii?Q?nNmOL4Zlxw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2839b491-c85e-410c-81dd-08deeaf8a295
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9715.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2026 09:31:13.4354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EjAo9aAMtYOswLQn/7x4dizzlwohPXjev1hTWWWAqWKzf7O86wvv0O6SNiuTg/EHS7YAnYJl5uAdCFDbsLVTLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7611

Add mlx5 driver support for IB_ACCESS_UNORDERED, the new uverbs access
flag that enables relaxing the order of read after write on mkeys.

Extend the current enablement of ATS over DMABUF with RO access to also
enable for DMABUF with Unordered access.

Mark IB_ACCESS_UNORDERED as non-UMR-modifiable: there is no UMR
mkey-mask bit for order_read_after_write, so UMR cannot drive it.

Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Michael Gur <michaelgur@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 2 +-
 drivers/infiniband/hw/mlx5/mr.c      | 7 ++++++-
 drivers/infiniband/hw/mlx5/umr.c     | 2 +-
 drivers/infiniband/hw/mlx5/umr.h     | 2 +-
 4 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 427e7f706c8a..ab245ec1af6b 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1679,7 +1679,7 @@ static inline bool mlx5_umem_needs_ats(struct mlx5_ib_dev *dev,
 {
 	if (!MLX5_CAP_GEN(dev->mdev, ats) || !umem->is_dmabuf)
 		return false;
-	return access_flags & IB_ACCESS_RELAXED_ORDERING;
+	return access_flags & (IB_ACCESS_RELAXED_ORDERING | IB_ACCESS_UNORDERED);
 }
 
 int set_roce_addr(struct mlx5_ib_dev *dev, u32 port_num,
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 5f6d91c47483..31879c0ecfb3 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -71,9 +71,14 @@ static void set_mkc_access_pd_addr_fields(void *mkc, int acc, u64 start_addr,
 	MLX5_SET(mkc, mkc, lw, !!(acc & IB_ACCESS_LOCAL_WRITE));
 	MLX5_SET(mkc, mkc, lr, 1);
 
-	if (acc & IB_ACCESS_RELAXED_ORDERING)
+	if (acc & (IB_ACCESS_RELAXED_ORDERING | IB_ACCESS_UNORDERED))
 		mlx5_core_mkey_set_relaxed_ordering(dev->mdev, mkc);
 
+	if ((acc & IB_ACCESS_UNORDERED) &&
+	    MLX5_CAP_GEN(dev->mdev, mkc_order_read_after_write))
+		MLX5_SET(mkc, mkc, order_read_after_write,
+			 MLX5_MKC_ORDER_READ_AFTER_WRITE_RO);
+
 	MLX5_SET(mkc, mkc, pd, to_mpd(pd)->pdn);
 	MLX5_SET(mkc, mkc, qpn, 0xffffff);
 	MLX5_SET64(mkc, mkc, start_addr, start_addr);
diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx5/umr.c
index b0799f86994d..689d4542d1ad 100644
--- a/drivers/infiniband/hw/mlx5/umr.c
+++ b/drivers/infiniband/hw/mlx5/umr.c
@@ -451,7 +451,7 @@ static void mlx5r_umr_set_access_flags(struct mlx5_ib_dev *dev,
 	MLX5_SET(mkc, seg, lw, !!(access_flags & IB_ACCESS_LOCAL_WRITE));
 	MLX5_SET(mkc, seg, lr, 1);
 
-	if (access_flags & IB_ACCESS_RELAXED_ORDERING)
+	if (access_flags & (IB_ACCESS_RELAXED_ORDERING | IB_ACCESS_UNORDERED))
 		mlx5_core_mkey_set_relaxed_ordering(dev->mdev, seg);
 }
 
diff --git a/drivers/infiniband/hw/mlx5/umr.h b/drivers/infiniband/hw/mlx5/umr.h
index a6c4f35b75e6..78b91d614a17 100644
--- a/drivers/infiniband/hw/mlx5/umr.h
+++ b/drivers/infiniband/hw/mlx5/umr.h
@@ -49,7 +49,7 @@ static inline unsigned int
 mlx5r_umr_get_unchangeable_access_flags(struct mlx5_ib_dev *dev,
 					unsigned int access_flags)
 {
-	unsigned int ret = 0;
+	unsigned int ret = access_flags & IB_ACCESS_UNORDERED;
 
 	if ((access_flags & IB_ACCESS_REMOTE_ATOMIC) &&
 	    MLX5_CAP_GEN(dev->mdev, atomic) &&
-- 
2.52.0

