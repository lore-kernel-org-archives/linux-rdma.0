Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010068.outbound.protection.outlook.com [52.101.85.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646E6383325;
	Sun, 26 Jul 2026 09:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785058269; cv=fail; b=L6IYIYXHIMVaUnSAQaKfWEWweB+eFVUxRZf0TOBivPBg8OMlkGe2MKmTm3XeQSt0/6jgESAclnJOnTD3/KOQlLp2bkP4AWcCodviW4H0C5ZWsgyCMI7d3SS9C8fUYQVKIYyKPM2eWp9baa5So8kaQdfKeHO52R51COQnofXR6os=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785058269; c=relaxed/simple;
	bh=yzIpKbhyr2031h3cVXpsxQgCDECTSF7vyCUHKm1L8pw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Al0GMUq83OLdBmkcXrEIi9UBgDzpPWbe76Eux/tOKOkDZDs0AzQrnwflfDdqRln0xzVa+UsBwBGQ7KTWhVd+FzK4cKxkFK2b8ggewo8VfrhHYcWnv67uO84OgJFnKCcSPXjgaVyBzQMwuzvduEYN+BfJZ/L3dsxBv5EJBYGY0OU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=S+ErEIVN; arc=fail smtp.client-ip=52.101.85.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="S+ErEIVN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zW7BMmC/v+EV9icCIUdmyijBvDVCiWmpjgWggHQdzTi7AeoWcNYUesQ0MWVOo6mex0KyhDNt0G1vajNdJ5HpNPjTr8K8KaSKwM7eZQVumuWcH/e4+3rmy99OHdEr+uiV9PI24uYvVx8+ZxiqDIofsWRi11n9ZBsjfwRZ+GCwAa6M5i4qARivzbRAl0YqeDohXVk98RIxaZc5JmoixCZ4EKFZzg9hj5i41mwgrpa1X4nE1xxcTn+JC5diS3HjdjFGZ+hkQeTP0VUVF1HCjbKPdecphIyaPzaY7zcylGN/P+0ofhrvcQnHiCIez7bgE+oInL0Ngti2pL2Le8nk8vrbxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gv+AkU+KauC9XdrgMj8llb/u6AFx3XC4cjsOYgLW1Gg=;
 b=avRsCuX5AKMfbwMzn7bOn83q2YWFsclcLNJ4roE4dhq//eKl0Y9rHJ+og51rq+BOCRg7NyLcDl2cDC6k9HHhbW1KUJE//40MzBpXnfCuz5jkDvzNG+s2x+1bB/aQ8XWOgnv54MApWCgCY4MmY41lILZV1w1OyuyrhqF9oCvd4dooOJBZ3hJwAhUO9MRMZ3gia9QC23o7LEATah2XH0QG12Iij8Rz5gCsClh7JRY9xKftCd0zaOIHzg/ThG80o52b4hZNeMCifbtHOS3Se805zFpm9GLOPvc8J5QCoqZCI1F2ZBimSEdkr/oyGM1onP+Kno2ghWj8sjiEjWlEXP/zTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gv+AkU+KauC9XdrgMj8llb/u6AFx3XC4cjsOYgLW1Gg=;
 b=S+ErEIVNtoc6QMxfFnVV8HALcqiQP/Ro2zpg3XMrtAvIAwKfVqCWZNo7tpDwlyHhxGtA1F5IjqxUlRt+Xh6BXP2Nz5YwG0RXx/mRBRQW3X3aY+zS41jt7cbbWtzTpBFDEmMMo9GKVNLWiKDl0cDN/+Hh17JhqBI3dS5Peew2dB7lPMClizmKGxMNmspSYD2SV4PuHSXOurLOl4reApQMIrhIfOrNCSZKEyiYxcEgm/6Hcmrc1fzUTaMc2R8iEcOEMWnCyjelHaLUliZBO1vW+lElPO1VI86CnZ3h0w+VBPXZ/Lf4F7N69OUu25o86y6/FDZd0EhBfvVOdMGWcgplgA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9715.namprd12.prod.outlook.com (2603:10b6:408:2a0::7)
 by CY8PR12MB7611.namprd12.prod.outlook.com (2603:10b6:930:9b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Sun, 26 Jul
 2026 09:31:04 +0000
Received: from LV8PR12MB9715.namprd12.prod.outlook.com
 ([fe80::e74f:2cf8:cf2c:142]) by LV8PR12MB9715.namprd12.prod.outlook.com
 ([fe80::e74f:2cf8:cf2c:142%6]) with mapi id 15.21.0245.012; Sun, 26 Jul 2026
 09:31:04 +0000
From: Michael Gur <michaelgur@nvidia.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org,
	Edward Srouji <edwards@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH rdma-next 12/15] RDMA/mlx5: Converge UMR access-flag cap checks
Date: Sun, 26 Jul 2026 12:29:26 +0300
Message-ID: <20260726092943.2880176-13-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260726092943.2880176-1-michaelgur@nvidia.com>
References: <20260726092943.2880176-1-michaelgur@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0213.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e4::13) To LV8PR12MB9715.namprd12.prod.outlook.com
 (2603:10b6:408:2a0::7)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9715:EE_|CY8PR12MB7611:EE_
X-MS-Office365-Filtering-Correlation-Id: ff09df20-ebdd-4d65-cf32-08deeaf89cee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|10067099003|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	APq/WzpXq/qODOB/2x9nkL3vkaV1MuxFC2jm9dZdP6dcSwJ0aczzorq+Ak8yhGsE7+v3WTYJ0gkYV+qPNSNoTXt51MjBdhYrcIBpHvJMAdcpBEp6SSnb1en8vjaJCR7rxjfdG09kogKVhI39tnp/QHBvMnz3je47Pm0eMCGI014TRVtuvea+tMpqF48NAQinm33JxeMsP1mERY9a+e7sj+k5ADfW1utBnIDnbY/zSsuyl03/jBH7hm75DqzEVedxE54o+1mPeryD3CEVcMu1mAXRREEuBGbS5SDh4ZAv0kzDm0y3kEtCSuH0si5E14FdMc5AV1vTBEODIT28iJ0JoVIPizg5YstjhbWZ3WbS8lyXglc8XzK+OAF2dnO+tpUvvWUK82x35CLmAWHj6DpBQcuuoC7Hcba3IJ2YU3mZ1e6+w7toWoXhhJVG393B8e6WXmCrHWmcitPROz20u5veEL8sLlnrmOkaz1czzW7r64GtZenqS7as6u9lnyscOn/i3c9aBp/7apMnL73QbCqe1DVOMJBpT5n2KH2J93WPJu41XAwxVYk+2uiKGKPQ1OQN1jsbmAS2qzeO/+cAKmwqi37yCtzxceRCSQtXF9M1Wy1kavPCeDVAE61rUNV1thEKjO5eZqdmXfY793ceqHg8UNitxwvBwvGqHrDV5tozPsY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9715.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(10067099003)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VOeI/dkO56ZwAc2YZ1Ijn8XArjmLMd1g7+WuXC/78S1i4duOIBJkFNRSNTr3?=
 =?us-ascii?Q?eq6zn5iRzY0TkqTCCzsmn64FU8R+We2g77duXLXiZHLFvBQmOfrK50rvxn4S?=
 =?us-ascii?Q?+uLTwqYf1jy9xf+Bm4bE2Zpp6/clvVpsqRm5hWrpUTKgWxR8EmgqeanK2jt7?=
 =?us-ascii?Q?OaTv8+XUNkdOpizEdRo72pUk+LhyFDLENO9q/lojVYb5x0Bg3Uu9/lA77Vw9?=
 =?us-ascii?Q?vOMHP+Nq6f2foLzyWXxOef4TfFUU7yhxgVsyxxbikU/blp9tABxsYG+RXzWI?=
 =?us-ascii?Q?U4O3lcfGqbDsrmwHx3lS4DS4Z72UdlDmi8N7FT/4rnaEHKfMAw90AEl4fL9s?=
 =?us-ascii?Q?upa3Csbu7jOZ8OWOYER0ggbK15lAYRdjK90s6iIQsZGwSDtALfuN/VkdYklW?=
 =?us-ascii?Q?sEis5VcfbSeiCCAU32vype2gcXcsyYBd2HG528LRYEeod6aQoloxE3ojnzis?=
 =?us-ascii?Q?bq/ZBMi5+NZh66xWpG2sEjf+GYEG7OxOTDs2Km6uflbcmOwwpZaNLDljH18Z?=
 =?us-ascii?Q?uvDvikEWb1O7qOdQyDEYgsLSMUc0RMkHVUR09LW1ln7qUeP9iEdGf/F4rMI3?=
 =?us-ascii?Q?qluG3NzdveW5OO65+JnB3Bka8IMxA878owDPn/e4oFQHiVYTQIcHPUtpCM2O?=
 =?us-ascii?Q?oTTJ3AbMl9sVB3ZGEDHEdJ0CELkbk7mtZirGxV6IvpOGxlL7Mdshr5cQ22fg?=
 =?us-ascii?Q?+m6TqvmI9B9h5PhVchv5xt/cgy+JgQGmY24krG8XIQV3HEZwtcpK0OhGuog+?=
 =?us-ascii?Q?Su4atSKDOFvDT+Q1XtbLPhizSbnq5GAxgL/0a9aC/JaGLVYd39e/R5eBWVHV?=
 =?us-ascii?Q?8uhjBZJm6w39K979fzrBZq42vgT+VKD45zsnr85D+yUP0JcvmPh75w/SZsE6?=
 =?us-ascii?Q?xad4G4GhB5hl/u9HHfoW4zNgvQFsr75PF9hOz5eGfaACj6Z5ozQePtd7vqFR?=
 =?us-ascii?Q?XuiRwBvGxGS1sQ/PiG8YI6UKTZgNBPOYwJVX6iibHljxKajiHRnDpM506m+j?=
 =?us-ascii?Q?eZMmwHHEd6KTCoxfbpXCXoTe5/Emxf+heIUwchFfMgOP+xLrztkKUAF9ZDc4?=
 =?us-ascii?Q?Uz47Hr1aJuKCjXRafmsiNln3rcY99iUsP6OPu5+6iQIiHWb9Rzn3ostbacx6?=
 =?us-ascii?Q?2svcj3ZKl6o5hwk/fxA/esM5z/jGCE43NWC26gQU4vQQFuILyxs524LvoYbT?=
 =?us-ascii?Q?+IiW+JYpd52zPwUvfguskq1iH6aF7NZ2lMTmJMVKxMHmSfhTn18EDktpAm+z?=
 =?us-ascii?Q?Hu6oF/nbWtzTxbDSduuhw6gR9f20f9KlOY7CTh8K45HAJAa6ycV0AOleF5jj?=
 =?us-ascii?Q?0IzLF9XPqmqtYdglct0hRTB2fUVTcSc9Lg4Jdl8FN2HP4NjFJqgNpeY4+003?=
 =?us-ascii?Q?f4y6aOXYkozxuZM6QcSaNt7/9G75k/IoOT/kUOVViHcI39BOi5sUDWtSir0R?=
 =?us-ascii?Q?xZo4N7zDPvgaJ5DewiRe2f62dx4p6URTkbrEgGQacokV386DN+MlDwUcL+G1?=
 =?us-ascii?Q?k5VtEuR3T+HDoXcCE00hKRN44+6Hg0yhHbO82aAK/OJ4idogLrhD1O2OhyOJ?=
 =?us-ascii?Q?Ac48iqisKkLP/JOG3L/xTaOPDgyOL25EU831EV5HnmLFPhIxvxc4159ddTWd?=
 =?us-ascii?Q?AncEJA6kXui7tM3e0yaUOoyBnsJ4dCekqhMLHYF4G36iXYrPFoqX6SQoGvsr?=
 =?us-ascii?Q?oBrrilTASQLy/CKfSHm9UT3C14+kCgAha8P7hlF6fka7ca5EhkhAIQIHahG8?=
 =?us-ascii?Q?ELhoiOtmKQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff09df20-ebdd-4d65-cf32-08deeaf89cee
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9715.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2026 09:31:03.9751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t6xNG03Cx1250GSRT3I9BPSfDjhZExk80D+kv8x0NiAzF9puhC9e7HUvvvX53MS4GOfhgOiFaMFDI4Q4avDzzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7611

Move the UMR cap check from both MR registration and UMR paths to a
single helper checking the access flags non-modifiable by UMR.

No behavior change for the current flag set.
Converge to prevent code duplication when adding support to new access
flags that are not modifiable by UMR, like the new Unordered access flag
added in following patches.

Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Michael Gur <michaelgur@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mr.c  | 30 +++-----------------------
 drivers/infiniband/hw/mlx5/umr.h | 37 ++++++++++++++++++--------------
 2 files changed, 24 insertions(+), 43 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 29a9da5c6dca..5f6d91c47483 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -128,30 +128,6 @@ static int get_mkc_octo_size(unsigned int access_mode, unsigned int ndescs)
 	return ret;
 }
 
-static int get_unchangeable_access_flags(struct mlx5_ib_dev *dev,
-					 int access_flags)
-{
-	int ret = 0;
-
-	if ((access_flags & IB_ACCESS_REMOTE_ATOMIC) &&
-	    MLX5_CAP_GEN(dev->mdev, atomic) &&
-	    MLX5_CAP_GEN(dev->mdev, umr_modify_atomic_disabled))
-		ret |= IB_ACCESS_REMOTE_ATOMIC;
-
-	if ((access_flags & IB_ACCESS_RELAXED_ORDERING) &&
-	    MLX5_CAP_GEN(dev->mdev, mkc_order_write_after_write_ro) &&
-	    !MLX5_CAP_GEN(dev->mdev, order_write_after_write_umr))
-		ret |= IB_ACCESS_RELAXED_ORDERING;
-
-	if ((access_flags & IB_ACCESS_RELAXED_ORDERING) &&
-	    (MLX5_CAP_GEN(dev->mdev, pci_relaxed_ordered_read) ||
-	     MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_pci_enabled)) &&
-	    !MLX5_CAP_GEN(dev->mdev, pci_relaxed_ordered_read_umr))
-		ret |= IB_ACCESS_RELAXED_ORDERING;
-
-	return ret;
-}
-
 #define MLX5_FRMR_POOLS_KEY_ACCESS_MODE_KSM_MASK 1ULL
 #define MLX5_FRMR_POOLS_KEY_VENDOR_KEY_SUPPORTED \
 	MLX5_FRMR_POOLS_KEY_ACCESS_MODE_KSM_MASK
@@ -173,7 +149,7 @@ _mlx5_frmr_pool_alloc(struct mlx5_ib_dev *dev, struct ib_umem *umem,
 
 	mr->ibmr.frmr.key.ats = mlx5_umem_needs_ats(dev, umem, access_flags);
 	mr->ibmr.frmr.key.access_flags =
-		get_unchangeable_access_flags(dev, access_flags);
+		mlx5r_umr_get_unchangeable_access_flags(dev, access_flags);
 	mr->ibmr.frmr.key.num_dma_blocks =
 		ib_umem_num_dma_blocks(umem, page_size);
 	mr->ibmr.frmr.key.vendor_key =
@@ -205,7 +181,7 @@ struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev,
 {
 	struct ib_frmr_key key = {
 		.access_flags =
-			get_unchangeable_access_flags(dev, access_flags),
+			mlx5r_umr_get_unchangeable_access_flags(dev, access_flags),
 		.vendor_key = access_mode == MLX5_MKC_ACCESS_MODE_MTT ?
 				      0 :
 				      MLX5_FRMR_POOLS_KEY_ACCESS_MODE_KSM_MASK,
@@ -324,7 +300,7 @@ static int mlx5r_build_frmr_key(struct ib_device *device,
 
 	out->ats = in->ats;
 	out->access_flags =
-		get_unchangeable_access_flags(dev, in->access_flags);
+		mlx5r_umr_get_unchangeable_access_flags(dev, in->access_flags);
 	out->vendor_key = in->vendor_key;
 	out->num_dma_blocks = in->num_dma_blocks;
 
diff --git a/drivers/infiniband/hw/mlx5/umr.h b/drivers/infiniband/hw/mlx5/umr.h
index 04dec726b267..a6c4f35b75e6 100644
--- a/drivers/infiniband/hw/mlx5/umr.h
+++ b/drivers/infiniband/hw/mlx5/umr.h
@@ -44,34 +44,39 @@ static inline bool mlx5r_umr_can_load_pas(struct mlx5_ib_dev *dev,
 	return true;
 }
 
-/*
- * true if an existing MR can be reconfigured to new access_flags using UMR.
- * Older HW cannot use UMR to update certain elements of the MKC. See
- * get_umr_update_access_mask() and umr_check_mkey_mask()
- */
-static inline bool mlx5r_umr_can_reconfig(struct mlx5_ib_dev *dev,
-					  unsigned int current_access_flags,
-					  unsigned int target_access_flags)
+/* Return subset of access_flags whose mkey fields can't be updated via UMR. */
+static inline unsigned int
+mlx5r_umr_get_unchangeable_access_flags(struct mlx5_ib_dev *dev,
+					unsigned int access_flags)
 {
-	unsigned int diffs = current_access_flags ^ target_access_flags;
+	unsigned int ret = 0;
 
-	if ((diffs & IB_ACCESS_REMOTE_ATOMIC) &&
+	if ((access_flags & IB_ACCESS_REMOTE_ATOMIC) &&
 	    MLX5_CAP_GEN(dev->mdev, atomic) &&
 	    MLX5_CAP_GEN(dev->mdev, umr_modify_atomic_disabled))
-		return false;
+		ret |= IB_ACCESS_REMOTE_ATOMIC;
 
-	if ((diffs & IB_ACCESS_RELAXED_ORDERING) &&
+	if ((access_flags & IB_ACCESS_RELAXED_ORDERING) &&
 	    MLX5_CAP_GEN(dev->mdev, mkc_order_write_after_write_ro) &&
 	    !MLX5_CAP_GEN(dev->mdev, order_write_after_write_umr))
-		return false;
+		ret |= IB_ACCESS_RELAXED_ORDERING;
 
-	if ((diffs & IB_ACCESS_RELAXED_ORDERING) &&
+	if ((access_flags & IB_ACCESS_RELAXED_ORDERING) &&
 	    (MLX5_CAP_GEN(dev->mdev, pci_relaxed_ordered_read) ||
 	     MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_pci_enabled)) &&
 	    !MLX5_CAP_GEN(dev->mdev, pci_relaxed_ordered_read_umr))
-		return false;
+		ret |= IB_ACCESS_RELAXED_ORDERING;
 
-	return true;
+	return ret;
+}
+
+/* true if an existing MR can be reconfigured to new access_flags using UMR. */
+static inline bool mlx5r_umr_can_reconfig(struct mlx5_ib_dev *dev,
+					  unsigned int current_access_flags,
+					  unsigned int target_access_flags)
+{
+	return mlx5r_umr_get_unchangeable_access_flags(
+		dev, current_access_flags ^ target_access_flags) == 0;
 }
 
 static inline u64 mlx5r_umr_get_xlt_octo(u64 bytes)
-- 
2.52.0

