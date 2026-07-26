Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010054.outbound.protection.outlook.com [52.101.201.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97A230D402;
	Sun, 26 Jul 2026 09:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785058241; cv=fail; b=DKLopDwXSPRegj16bClpglIdu1xyOtlFxAAUEJiTfL+Xm3J4+sIlFUvxNySv4CDGjEJKbGi7UVQP7jMXuDadQZcG84cikjEAOhoZ226Rlq/l9feKzInb8n602F3PWUa0Q8p4othKn1lIbr5Y736LIXYvgr/5Ex3oZWwuiDR/CGE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785058241; c=relaxed/simple;
	bh=Fu2YR6WJO4jfR0wnCYVWwgDPG+A7EUhWgXlnQZ0FBHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SSNT1EKY2EVi2V5BEIyXPSl/deoH2dqVi1ovhRDmnFwEjfrtAK3s4Wf3Yea2rctTVH1OZbMOKVRCvbRSe0POJR/AdEv/xa9IQqyTwrj2tk0uhWgSfgshmW6CLjXmpytXGYavw0kUYIC3abWOXYJD9xmk2HxnKaV99/LQPqE2E40=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GkiEx/Vk; arc=fail smtp.client-ip=52.101.201.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GkiEx/Vk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wodnxI9RJp2BVQX3F2gIkqxNqxvLGfw0UZqRzVzdwfz4+PWUUrq9cNFdhFs5WtL8Cxzyu5YC+S3zfghEHSIeE44tTIr3OfTtieFwkue8EekJ0HsNhnWZlCvyX/qrVkAutG+fHHclR9xWpa4wUvzdRmk4MoY+MN6A1IDUNmm5SqZPKBQPLW/pMfWKTbbm4KRP3EA1/75rp8CXGYmRG6BJKKQ2O7C6vTS2zyOIML2dQEm8S3zz7zICZNG0tVqDm20MdnUvpaeXHTAq5Nytt7QIzeMSBBPJiyfW6/yAQxdnRZc1rxDQ7nNKr01/utMvXS9Rq2UyFxEhlLWpWkhoNXLX3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bMcazBjerW6AZXqNzd3mtUhBP6Ua6uT/NDcCSVSEjHc=;
 b=mOvxLXY1ANd4JXOXXc03bEpLbroeqY+Ql1WRSesik/wfdh6LRqLhwPbXuf+qgRKdlL3/ZGRKeFt9NxA0lXqUC0DoLrw5h7c4BCpg/HxK3UFZAmdfgw9pa9PH+dbN6Aox4+E+4V99nTYbdbgSqkmnoxGTGLwNfbKKzpdIiI1U9WjkTPoj8vp70K0AhWXPdROVkjpaF6Ic9V7UxYwZSKvw9DPIyOqIiw5oOqLWDloWnkOVTkR8i9aSymwPehHVHSKvY9VnPfnB+lr+Dn2hN5eFT7TAATT/2F8OuaVsUvagY0Ox2VUMINR284OyVuWPi+97oau63RA1bCSRUVij+OnJmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bMcazBjerW6AZXqNzd3mtUhBP6Ua6uT/NDcCSVSEjHc=;
 b=GkiEx/VkKPEI2Cgh5b0/1OhhFCI1BY1Os5xw/4P9FH2KAReh8PZDI7UhZWdbLA1uGMbzACD6UP6wU3LbnKrdR4IGHXLAy+rk1chODxNWi5Vm4DTfKch9+p5Vq+uHf8mvVO68GXQ+pFOCoyAA1qhgnlB8VrNbLRToxcafrALRXKTgBT51XDMuEOLlSa5kj2PBX/7V7VtHLgA//oco/mfOEmCTX+EKKFbyrJ5K4Q+X1Vv2Z4gDqR344KSngxz5g/icFeov9tJkDxZ7WGyaW4SLEJW6P4CBYMuGRKE+eQxbde5APTKpXSqNYKMriKOmRs0KImqnbgtYnZf+btx36QMnxQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9715.namprd12.prod.outlook.com (2603:10b6:408:2a0::7)
 by CY8PR12MB7611.namprd12.prod.outlook.com (2603:10b6:930:9b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Sun, 26 Jul
 2026 09:30:35 +0000
Received: from LV8PR12MB9715.namprd12.prod.outlook.com
 ([fe80::e74f:2cf8:cf2c:142]) by LV8PR12MB9715.namprd12.prod.outlook.com
 ([fe80::e74f:2cf8:cf2c:142%6]) with mapi id 15.21.0245.012; Sun, 26 Jul 2026
 09:30:35 +0000
From: Michael Gur <michaelgur@nvidia.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org,
	Edward Srouji <edwards@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Raed Salem <raeds@nvidia.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH rdma-next 05/15] mlx5: Rename IFC bits of relaxed ordering fields
Date: Sun, 26 Jul 2026 12:29:19 +0300
Message-ID: <20260726092943.2880176-6-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260726092943.2880176-1-michaelgur@nvidia.com>
References: <20260726092943.2880176-1-michaelgur@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0138.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::7) To LV8PR12MB9715.namprd12.prod.outlook.com
 (2603:10b6:408:2a0::7)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9715:EE_|CY8PR12MB7611:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cb6b3b8-cb9d-4415-d3a3-08deeaf88be7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|10067099003|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	Uc9RpAK0IxDNJSYspnxJodKRcJnrrDsD51B882qMEIwzJ1rtdGwy9FIw3pLByDr0QPjFITTq7xGha+34zptykVN8fn8MJG6xkuVbopWayL6erunpBGURrXnG/twGcleI/bfGPAxUXT855JLJ2m8O2VEk50P/LfnDC5blkj0wAHRF9j0eDzCfyLg48ncnG9a5CA8Uj2hbZhDGMPTDfE2GXIZfKZoCsA1vheqTlVKq8FxOuRgwme812PB2nSQwBlHz66sr+mkFfqEbVE2pKHACWDDfYjvj5qNBsjuFaQypLXtROu0uSp5X8J57Wfjz15gC9C52YmSxMMMLUPShDNtIGqga2/Yrtm7CjzWhiex5l55eodWJpa/pRyVX54KEqt0Fi6xXb7kJW8cJfGrjGBSAziO7QjG0uWGhGiIz62V58Whc05g73vsmYSmqpH+eWUqkdazasaJp/EhMR9RXJiYZs3Zxnx+1+HSy1GITtRHuAStt6JZ17Aq9V1Kww2wSTAqt0gypxUNk4A7o8JkJkvtDh4Dc8q+oFzV6msKu6ToM9tZZp5VgmNNTr46JHRQgl9rVhizMgLvuvfzOZFBeD7Cyu2hpv+IyvrUkZw2TURnSTYpgwPdycEXc25JLsymGsnFvAsehbuN+4o6qhRlC2YETt+PmQOJAMHcA3rvyJlJCAAI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9715.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(10067099003)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zDnzOHpiuonejv8tcj/e4l1Rt1k+iIuPLapUbKyW8QRmIlZiSrED9/0OlM63?=
 =?us-ascii?Q?qZh8JhSZ5t8ArbNjBtaRJ/U2YzjBzbVTz8mR0Qo7U6efISP5iwdJBpuADtvC?=
 =?us-ascii?Q?YEKBukX9caqiOpRHnAbXzY6IA3+tL+s7uCUoGHeVd0Wh5vxdeW9Zqri6JPJp?=
 =?us-ascii?Q?mqjpF5VT6jC51wLzyMVx+VJAJhOV091AzdUaT5/UXn6sn1yMehX/pdCzAEYA?=
 =?us-ascii?Q?gxeLtHz0TJHDn8znZ/gDnUNrgcUQUmCpgEMPbp51MfEFdybnwGshExDI+JNS?=
 =?us-ascii?Q?tsiOqAsYzQMfY/g94srBBvQ3OgQGYHlfANp1lw2dQ7McnEyEvv5NyCq5Enwj?=
 =?us-ascii?Q?H8bZxygwiir85HLLpPMRw4t0fMXgVOrTGxPJRsk4d9vaIbHEPMn7bPUPiUTb?=
 =?us-ascii?Q?3ZTrP6eI+S6uYgu2Q50vMbYWsrp+1nkre5SA5QuFGGIj4vwCuSESPD0NMK5d?=
 =?us-ascii?Q?59eWH8LSAvxR1b+tMyiZ0qDmzTJMV4CEnVyZR3xlXQ9QtEUVGrVBkRIHNLPj?=
 =?us-ascii?Q?1r7xLQW3i7R8PmK+RWaqfarRyHfefsHZG/h9x4K2eAUfAm21FFnAAVd8wGE5?=
 =?us-ascii?Q?+3TW3ojywXfwyWopj6RebGaLLCHzM6g0+7LfDDb1q2fvmdyG4QMXW8vVXyri?=
 =?us-ascii?Q?lGgW/ZFzrjzLmBPxf0GWvCIogL2Jh9956h20ZNG6/SKz8GOJTHUXHIcAyuQX?=
 =?us-ascii?Q?FIK4fONjRWFyBEEr3mMChQwhVEVTMaBiGgRG1mGrUUCZ7l/ksdmFFa3ELkWF?=
 =?us-ascii?Q?t+t8z8BoklsSvIGeXiq+oHAHnB1t7sxG1iTp0mc6mzY+TBWfjYkP4nb2J2xJ?=
 =?us-ascii?Q?+7jSh5WB9cTbkU4GxdxokfWCLbrAort54PDyDaAnzDkOPugg44lWW9S6WfCx?=
 =?us-ascii?Q?nvq54gsWks/zNfL1Hxww1v8/yvpplGNio9siUswWk5WpaZC5zQcZTn2u6yZj?=
 =?us-ascii?Q?Fh8isOoyAfyQX3BpYo2dhFRbJoEif/+mjJ2jPynaAPaJBrj3SKLudzVyhX43?=
 =?us-ascii?Q?3M2dTf1igcAoU60RZl8t5ogbvFhdmk1HIkOtArlXQ8obpKWtFw3nAMVwtI+g?=
 =?us-ascii?Q?iZIxC4XxFMKq6RUs6uYNbvbuwEWfadMdyoWst1R+836Mq81Ay7tCo00s+ZdC?=
 =?us-ascii?Q?4Oa0korRYsFmsuxxeLUJQoDlOpBCIUzRiJphsPCpZ7Gpw5x7uidf3A3q+oF5?=
 =?us-ascii?Q?USg4L6YSRLzp8+NCerdK8q0iviKidvR9LhZ0Urlo9L7hMW0jl8TobipMMyzk?=
 =?us-ascii?Q?SxgoobX36BjosPB8tbf8Fhjpt5iNXbjLgk0BM8ZmvQwtu278uyxuHm81Z3A6?=
 =?us-ascii?Q?niBAmsYThwidXW+vEKapoRMjxCL63YtboUffi/pod044WyzhHZ5V0R7KrIFN?=
 =?us-ascii?Q?zhUafAFGlw9Bq42U5AYzwf6KE2Lsq8L/DwXMi8TtDhrIja445B2ELhrRrk0e?=
 =?us-ascii?Q?fkcRFkvuM8DpM/idf+0OLqJVFYfr7zBmpfakZOpQHd+h9/styakZfjn+BERf?=
 =?us-ascii?Q?FR5U9NwHgg7n3ONeriooBcOgjG0KDPtv51ku8I7K4cPYgMFPFLjjTtsiewez?=
 =?us-ascii?Q?U9ZRVSijcmB0PrTyx9WmAXfSPOY7kJDCnhd3mlGezBiUP7aJkz7qj/ulsO11?=
 =?us-ascii?Q?Wvr7bNiilp9gUscvlMKDY7RQfgNMWNqeXkBHfKV+yXZzvazWumcwCj2FAGHf?=
 =?us-ascii?Q?9TDrkAYKeqZP/LWSRL5wLrCSGlKfS1NEKDirmzrMZIYEKJKoz+uAf5eLHuHA?=
 =?us-ascii?Q?bUWqGBy0DA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cb6b3b8-cb9d-4415-d3a3-08deeaf88be7
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9715.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2026 09:30:35.4221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kra7nQZYACRxtjUIQ1gd3Z3k+c0B+KzmVIJbeO+16CV+/A/T+sS57d28Jurv7b5ZRjWg2LmzgN3bSjzz4+Vi8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7611

Align the IFC field names with the new naming:
- relaxed_ordering_write_umr -> order_write_after_write_umr (cap)
- relaxed_ordering_read_umr -> pci_relaxed_ordered_read_umr (cap)
- relaxed_ordering_write -> mkc_order_write_after_write_ro (cap)
- relaxed_ordering_write -> order_write_after_write (mkc)
- relaxed_ordering_read -> pci_relaxed_ordered_read (cap and mkc)

Update all references across drivers.

Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Michael Gur <michaelgur@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c                |  8 ++++----
 drivers/infiniband/hw/mlx5/mr.c                  | 16 ++++++++--------
 drivers/infiniband/hw/mlx5/umr.c                 | 14 +++++++-------
 drivers/infiniband/hw/mlx5/umr.h                 |  8 ++++----
 .../net/ethernet/mellanox/mlx5/core/en/params.c  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_common.c  |  8 ++++----
 include/linux/mlx5/mlx5_ifc.h                    | 12 ++++++------
 7 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index d65ebdef2823..2f16fa40d269 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3513,13 +3513,13 @@ mlx5_ib_create_data_direct_resources(struct mlx5_ib_dev *dev)
 	dev->ddr.pdn = pdn;
 
 	/* create another mkey with RO support */
-	if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write)) {
-		MLX5_SET(mkc, mkc, relaxed_ordering_write, 1);
+	if (MLX5_CAP_GEN(dev->mdev, mkc_order_write_after_write_ro)) {
+		MLX5_SET(mkc, mkc, order_write_after_write, 1);
 		ro_supp = true;
 	}
 
-	if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read)) {
-		MLX5_SET(mkc, mkc, relaxed_ordering_read, 1);
+	if (MLX5_CAP_GEN(dev->mdev, pci_relaxed_ordered_read)) {
+		MLX5_SET(mkc, mkc, pci_relaxed_ordered_read, 1);
 		ro_supp = true;
 	}
 
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 00e13028762a..53bc844a7fc8 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -72,14 +72,14 @@ static void set_mkc_access_pd_addr_fields(void *mkc, int acc, u64 start_addr,
 	MLX5_SET(mkc, mkc, lr, 1);
 
 	if (acc & IB_ACCESS_RELAXED_ORDERING) {
-		if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write))
-			MLX5_SET(mkc, mkc, relaxed_ordering_write, 1);
+		if (MLX5_CAP_GEN(dev->mdev, mkc_order_write_after_write_ro))
+			MLX5_SET(mkc, mkc, order_write_after_write, 1);
 
-		if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read) ||
+		if (MLX5_CAP_GEN(dev->mdev, pci_relaxed_ordered_read) ||
 		    (MLX5_CAP_GEN(dev->mdev,
 				  relaxed_ordering_read_pci_enabled) &&
 		     pcie_relaxed_ordering_enabled(dev->mdev->pdev)))
-			MLX5_SET(mkc, mkc, relaxed_ordering_read, 1);
+			MLX5_SET(mkc, mkc, pci_relaxed_ordered_read, 1);
 	}
 
 	MLX5_SET(mkc, mkc, pd, to_mpd(pd)->pdn);
@@ -147,14 +147,14 @@ static int get_unchangeable_access_flags(struct mlx5_ib_dev *dev,
 		ret |= IB_ACCESS_REMOTE_ATOMIC;
 
 	if ((access_flags & IB_ACCESS_RELAXED_ORDERING) &&
-	    MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write) &&
-	    !MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write_umr))
+	    MLX5_CAP_GEN(dev->mdev, mkc_order_write_after_write_ro) &&
+	    !MLX5_CAP_GEN(dev->mdev, order_write_after_write_umr))
 		ret |= IB_ACCESS_RELAXED_ORDERING;
 
 	if ((access_flags & IB_ACCESS_RELAXED_ORDERING) &&
-	    (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read) ||
+	    (MLX5_CAP_GEN(dev->mdev, pci_relaxed_ordered_read) ||
 	     MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_pci_enabled)) &&
-	    !MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_umr))
+	    !MLX5_CAP_GEN(dev->mdev, pci_relaxed_ordered_read_umr))
 		ret |= IB_ACCESS_RELAXED_ORDERING;
 
 	return ret;
diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx5/umr.c
index 80d0d190b26c..05ab0a32ded6 100644
--- a/drivers/infiniband/hw/mlx5/umr.c
+++ b/drivers/infiniband/hw/mlx5/umr.c
@@ -59,10 +59,10 @@ static __be64 get_umr_update_access_mask(struct mlx5_ib_dev *dev)
 	if (MLX5_CAP_GEN(dev->mdev, atomic))
 		result |= MLX5_MKEY_MASK_A;
 
-	if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write_umr))
+	if (MLX5_CAP_GEN(dev->mdev, order_write_after_write_umr))
 		result |= MLX5_MKEY_MASK_RELAXED_ORDERING_WRITE;
 
-	if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_umr))
+	if (MLX5_CAP_GEN(dev->mdev, pci_relaxed_ordered_read_umr))
 		result |= MLX5_MKEY_MASK_RELAXED_ORDERING_READ;
 
 	return cpu_to_be64(result);
@@ -88,11 +88,11 @@ static int umr_check_mkey_mask(struct mlx5_ib_dev *dev, u64 mask)
 		return -EPERM;
 
 	if (mask & MLX5_MKEY_MASK_RELAXED_ORDERING_WRITE &&
-	    !MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write_umr))
+	    !MLX5_CAP_GEN(dev->mdev, order_write_after_write_umr))
 		return -EPERM;
 
 	if (mask & MLX5_MKEY_MASK_RELAXED_ORDERING_READ &&
-	    !MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_umr))
+	    !MLX5_CAP_GEN(dev->mdev, pci_relaxed_ordered_read_umr))
 		return -EPERM;
 
 	return 0;
@@ -446,7 +446,7 @@ static void mlx5r_umr_set_access_flags(struct mlx5_ib_dev *dev,
 				       unsigned int access_flags)
 {
 	bool ro_read = (access_flags & IB_ACCESS_RELAXED_ORDERING) &&
-		       (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read) ||
+		       (MLX5_CAP_GEN(dev->mdev, pci_relaxed_ordered_read) ||
 			pcie_relaxed_ordering_enabled(dev->mdev->pdev));
 
 	MLX5_SET(mkc, seg, a, !!(access_flags & IB_ACCESS_REMOTE_ATOMIC));
@@ -454,9 +454,9 @@ static void mlx5r_umr_set_access_flags(struct mlx5_ib_dev *dev,
 	MLX5_SET(mkc, seg, rr, !!(access_flags & IB_ACCESS_REMOTE_READ));
 	MLX5_SET(mkc, seg, lw, !!(access_flags & IB_ACCESS_LOCAL_WRITE));
 	MLX5_SET(mkc, seg, lr, 1);
-	MLX5_SET(mkc, seg, relaxed_ordering_write,
+	MLX5_SET(mkc, seg, order_write_after_write,
 		 !!(access_flags & IB_ACCESS_RELAXED_ORDERING));
-	MLX5_SET(mkc, seg, relaxed_ordering_read, ro_read);
+	MLX5_SET(mkc, seg, pci_relaxed_ordered_read, ro_read);
 }
 
 int mlx5r_umr_rereg_pd_access(struct mlx5_ib_mr *mr, struct ib_pd *pd,
diff --git a/drivers/infiniband/hw/mlx5/umr.h b/drivers/infiniband/hw/mlx5/umr.h
index bda7123781a9..04dec726b267 100644
--- a/drivers/infiniband/hw/mlx5/umr.h
+++ b/drivers/infiniband/hw/mlx5/umr.h
@@ -61,14 +61,14 @@ static inline bool mlx5r_umr_can_reconfig(struct mlx5_ib_dev *dev,
 		return false;
 
 	if ((diffs & IB_ACCESS_RELAXED_ORDERING) &&
-	    MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write) &&
-	    !MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write_umr))
+	    MLX5_CAP_GEN(dev->mdev, mkc_order_write_after_write_ro) &&
+	    !MLX5_CAP_GEN(dev->mdev, order_write_after_write_umr))
 		return false;
 
 	if ((diffs & IB_ACCESS_RELAXED_ORDERING) &&
-	    (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read) ||
+	    (MLX5_CAP_GEN(dev->mdev, pci_relaxed_ordered_read) ||
 	     MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_pci_enabled)) &&
-	    !MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_umr))
+	    !MLX5_CAP_GEN(dev->mdev, pci_relaxed_ordered_read_umr))
 		return false;
 
 	return true;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 1f4a547917ba..a52ff01038e2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -912,7 +912,7 @@ static void mlx5e_build_rx_cq_param(struct mlx5_core_dev *mdev,
 static u8 rq_end_pad_mode(struct mlx5_core_dev *mdev, struct mlx5e_params *params)
 {
 	bool lro_en = params->packet_merge.type == MLX5E_PACKET_MERGE_LRO;
-	bool ro = MLX5_CAP_GEN(mdev, relaxed_ordering_write);
+	bool ro = MLX5_CAP_GEN(mdev, mkc_order_write_after_write_ro);
 
 	return ro && lro_en ?
 		MLX5_WQ_END_PAD_MODE_NONE : MLX5_WQ_END_PAD_MODE_ALIGN;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
index c2d4bae533de..2dbcf6673916 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
@@ -40,13 +40,13 @@
 
 void mlx5e_mkey_set_relaxed_ordering(struct mlx5_core_dev *mdev, void *mkc)
 {
-	bool ro_write = MLX5_CAP_GEN(mdev, relaxed_ordering_write);
-	bool ro_read = MLX5_CAP_GEN(mdev, relaxed_ordering_read) ||
+	bool ro_write = MLX5_CAP_GEN(mdev, mkc_order_write_after_write_ro);
+	bool ro_read = MLX5_CAP_GEN(mdev, pci_relaxed_ordered_read) ||
 		       (pcie_relaxed_ordering_enabled(mdev->pdev) &&
 			MLX5_CAP_GEN(mdev, relaxed_ordering_read_pci_enabled));
 
-	MLX5_SET(mkc, mkc, relaxed_ordering_read, ro_read);
-	MLX5_SET(mkc, mkc, relaxed_ordering_write, ro_write);
+	MLX5_SET(mkc, mkc, pci_relaxed_ordered_read, ro_read);
+	MLX5_SET(mkc, mkc, order_write_after_write, ro_write);
 }
 
 int mlx5e_create_mkey(struct mlx5_core_dev *mdev, u32 pdn, u32 *mkey)
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 695c86ee6d7a..0593913fd25f 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1709,15 +1709,15 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 
 	u8         max_sgl_for_optimized_performance[0x8];
 	u8         log_max_cq_sz[0x8];
-	u8         relaxed_ordering_write_umr[0x1];
-	u8         relaxed_ordering_read_umr[0x1];
+	u8         order_write_after_write_umr[0x1];
+	u8         pci_relaxed_ordered_read_umr[0x1];
 	u8         reserved_at_d2[0x7];
 	u8         virtio_net_device_emualtion_manager[0x1];
 	u8         virtio_blk_device_emualtion_manager[0x1];
 	u8         log_max_cq[0x5];
 
 	u8         log_max_eq_sz[0x8];
-	u8         relaxed_ordering_write[0x1];
+	u8         mkc_order_write_after_write_ro[0x1];
 	u8         relaxed_ordering_read_pci_enabled[0x1];
 	u8         log_max_mkey[0x6];
 	u8         reserved_at_f0[0x6];
@@ -1949,7 +1949,7 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         reserved_at_320[0x3];
 	u8         log_max_transport_domain[0x5];
 	u8         reserved_at_328[0x2];
-	u8	   relaxed_ordering_read[0x1];
+	u8         pci_relaxed_ordered_read[0x1];
 	u8         log_max_pd[0x5];
 	u8         dp_ordering_ooo_all_ud[0x1];
 	u8         dp_ordering_ooo_all_uc[0x1];
@@ -4524,7 +4524,7 @@ struct mlx5_ifc_mkc_bits {
 	u8         reserved_at_2[0x1];
 	u8         access_mode_4_2[0x3];
 	u8         reserved_at_6[0x7];
-	u8         relaxed_ordering_write[0x1];
+	u8         order_write_after_write[0x1];
 	u8         reserved_at_e[0x1];
 	u8         small_fence_on_rdma_read_response[0x1];
 	u8         umr_en[0x1];
@@ -4566,7 +4566,7 @@ struct mlx5_ifc_mkc_bits {
 	u8         translations_octword_size[0x20];
 
 	u8         reserved_at_1c0[0x19];
-	u8         relaxed_ordering_read[0x1];
+	u8         pci_relaxed_ordered_read[0x1];
 	u8         log_page_size[0x6];
 
 	u8         reserved_at_1e0[0x5];
-- 
2.52.0

