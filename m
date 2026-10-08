Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010045.outbound.protection.outlook.com [40.93.198.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CD049C4CE;
	Thu,  8 Oct 2026 13:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791466161; cv=fail; b=nd6H+GewasihBFc8L74tBkSXcdTQ7E2GOxNg1kcGRxRTpClO+fMINqCw3955jYGC8fj2zfcVflg0UN5AS+HDgrY32I3mIh1IWiNHU98tZJMusehveCc6D2UpOjeLNnVUrrB4k1i3sfkCmAmZkqH2glS5Tk3K+970/dPprjAe40M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791466161; c=relaxed/simple;
	bh=LlnQQzbgl99mJw7690dcxVY9TsRBo8MrGKJ/UQNdRLg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pe+QzXpwCW8rH/4yh2uL9gAa3wXMansdoGl6LwIr5iod93NN/eWFiPjtirP7yLPtCNP/cf9LsNBdqGcI/hAn6o/YBR3ihswxaXok8vJfMFWvLl6fBmYIJ8+7w3ugw6ih7ldbOaU2SA3PP8fdVnZoT/Ce6ezRllv6yphZmQ6aL0E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Tmbbfgog; arc=fail smtp.client-ip=40.93.198.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Tmbbfgog"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lh5GHZkqDlDIW8mOKSLEkfxpVKOR/0ePwDa+bA75IM8Yz3jBnjQCO75syKl4/tn8YdVBh5QP848xx02V8CXnWqKWGaJBNzwcdu02aFUawxwuQOW6YroSfmyuY37qdsSRbrc0Nh5rMr+dWAiMSwjAMv2jTzKlJiJarYh4PANp2GHQDhBYR09vLjgyfeBqWZQb+8lQjmuInkO8Z6+Zkq4CIfUZGguJM9VOp2IVjoU8CZz+3lXgEahQCLUHZLsyfyAZHMIXP/Z53g4OxtjmziPAESy3LxkDqPOhrAZBy0DiPfj+z6Wl6fdwHCxzugk4VJGULSlUhAD/PhSmdLBvFmdTHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+BciuvNMw1+CbocuNZwbsEpmte+sf0tgzv3Ma2QNsLQ=;
 b=YXYBVKxBBS65jpp4wJEyAzLMDyyIYNiyXUkKXEVd8w810Y37c8STziHYK+WD68+Z6F3Kbb7WaAEGqVbrE1aBwNmkCGf26KZKZH7Qh9/VfJTrpkkO0O+xj7dUB0+lwMEMcoILu0iNrEGgY1rph2Zx6pGZL7ZedVGtmzO9a5Dyn93l/XzCmIa5xXis53WnpgB2CWcP+8ijUp3bdtP5DZz8yP+82Xl/a6RDSMC8RQWMnWBrLzAHD7+IMQfF0QqqjCWMbtAOEr83Ye27amqLo0dmwYrIw3oUmk+YOeCJX5BZxgJ+/ugGnHhlmIr7z9jjZvHqBoS8NBFyMTLipjAt+cN4lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+BciuvNMw1+CbocuNZwbsEpmte+sf0tgzv3Ma2QNsLQ=;
 b=Tmbbfgog2QHAt2INVFPogiYthKwuBIWNcQ5zm5vf2nSEz5UXaGA15yA1pSJEzyrhQ9YwF6nkXmiNBbOA8hGE5DCBlTtRi87n5aE96KrL/Fv6IWbRID3TeJQBBRb7eGiCP9MuUHemI5jBTkYRKX8K0+1r+5E4vZpLGETQ7rsny0PA8K3xzinq6x9EOjkmsB8GIY8TUcE8OSiRSWIvR5Ik8YbjhhaPD7YLBqb5+pXXFZvdXG5ki0R6gbpdHRiczZqh3gHHUQgqZBqgUdXbN6foWmCX9pYuFRWm0ruWJ7fn/OxQEdZet+x/3VNFSHXOHKHZZkOBCy852zVld9iCD+lD0w==
Received: from PH1PEPF00013300.namprd07.prod.outlook.com (2603:10b6:518:1::e)
 by DM4PR12MB6109.namprd12.prod.outlook.com (2603:10b6:8:ae::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.22; Thu, 8 Oct
 2026 13:29:08 +0000
Received: from SJ5PEPF000001D1.namprd05.prod.outlook.com
 (2a01:111:f403:f802::2) by PH1PEPF00013300.outlook.office365.com
 (2603:1036:903:47::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.10 via Frontend Transport; Thu, 8
 Oct 2026 13:29:08 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001D1.mail.protection.outlook.com (10.167.242.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.14 via Frontend Transport; Thu, 8 Oct 2026 13:29:07 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 8 Oct
 2026 06:28:49 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 8 Oct
 2026 06:28:48 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Thu, 8 Oct
 2026 06:28:42 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Bobby Eshleman <bobbyeshleman@meta.com>, Byungchul Park
	<byungchul@sk.com>, Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman
	<gal@nvidia.com>, Jacob Keller <Jacob.e.keller@intel.com>, Kees Cook
	<kees@kernel.org>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Matt Fleming <mfleming@cloudflare.com>, Mina Almasry
	<almasrymina@google.com>, Nikolay Aleksandrov <razor@blackwall.org>, "Saeed
 Mahameed" <saeedm@nvidia.com>, Shivaji Kant <shivajikant@google.com>, "Simon
 Horman" <horms@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, "Stanislav
 Fomichev" <sdf.kernel@gmail.com>, Tariq Toukan <tariqt@nvidia.com>, William
 Tu <witu@nvidia.com>, Yue Haibing <yuehaibing@huawei.com>
Subject: [PATCH net-next 03/10] net/mlx5e: Pre-calculate UMR padding and entry size
Date: Thu, 8 Oct 2026 16:28:08 +0300
Message-ID: <20261008132815.654147-4-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261008132815.654147-1-tariqt@nvidia.com>
References: <20261008132815.654147-1-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D1:EE_|DM4PR12MB6109:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e3d6bdf-88d4-484e-53d2-08df254020ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|23010399003|36860700016|376014|82310400026|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	20tDg3zzRFvB5zGhcvzsDu5uet3q9Ttn3NEcr+615eXnsxYCVh1nP9rUORSYtI74+68GKe0ljkZIFw2mlROSEXXdvUvohLUTYrt2EVv1Qanv1zDmlln92j1KTB3YR8i9N2CHj+QosoYGteNNq9Tc4RbkfsqTgFGS56OaTDtvD8P8acMrvcG/APqcixWgk5jUIk7kF+xTdR6XP0cHoCqezvUOTeIMvTzPUOEJELvZ1gedvSVzbsVnCOt7BOpmghdQaa1tnRuYrqF6FzqCn8T9+x7moMNyL6KbwXQp6T1gyLCuxO4fJltPbJd76u0LwT9lGh1IxpdyVx9HEMEEXfHwiXwz4uiqi2Unv39PBsUYHC7GT4y6FvuGNW5RKkVV2Olz1eHOOQx5mpzcY/sbRC6tF598nGRMyofWsYgh0zEt33Ye2J3daJOAy5p2M7PKEw5gjE4SN6laRFZp2H5ucevNqNUzDHAIeIQ711ierRTbnf2BGwfCkt/6rmw6zFIqdwWAEL5otx7lJgE1TqUXvTqtosPeIuyObSFo8a/G3iGen385KL5mWj76ZYFNeky2lTgUA92f9550u4SvFG7MiNtrdZxdlKP2iTtjsNhId+HuYMJGen9+g1Wyri7gKw71VIuuXjyOCNdTrEw0BwtGfJojkt4YCYDZ3vgZFGvJrs+LJk+BWfu5r7TtjvS53+8F9ZwvgQyfAYN7OFPIjaRZT7WrqQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(23010399003)(36860700016)(376014)(82310400026)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	pxLgQkUBtJq3XRO5xgj8mlgGP9ZNGuOImLMn5JsYFDHMRi7jW2ZHtziyAhoFswC4USfZe26ibNVcfxVFA8slcmuvgtQ4hwJOCFSAjqETeCUYByB/Je8mnCECGRAR/aq68838QXwBbqlTKGnt18HBAn2CA5zMKiFlEs8neZcR9PrfiobevkLic2cdpcbHSUFgpIXpQW4yeEGZyuioD+Z6ADQiiTMNkRRITDsSzliCRG/k8bF2cW6/a2SD8+pxGaZsk5KJq2KlkHcoVlwflA5pWNtEoKsNb5gSR8iPKZONV3ajCCZd/shTiZ6AltVP/+hCxmfO1ozb48na8HmHpvgLxoTKnyYLCxkQ5HMx6gdPJqaMu95dyYg0FGwbhctdoXhorUm+tDfn5m1g1o2MSjP2YbrAIaiPnnooQhXHZNpmq3tX44qXwpgP9pArGGnJ9snn
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 13:29:07.0184
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e3d6bdf-88d4-484e-53d2-08df254020ed
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6109

From: Dragos Tatulea <dtatulea@nvidia.com>

A future patch will add KSM UMRs alongside MTT UMRs for data direct. To
avoid having additional ifs in the datapath, pre-calculate the UMR
padding and entry size based on the type of mkey used for UMR type used.

An additional side benefit is that the padding check from
mlx5e_alloc_rx_mpwqe() is no longer needed.

This patch doesn't introduce any functional changes. The mlx5e_rq struct
doesn't grow because the new members were added in a hole.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h     |  3 +++
 .../net/ethernet/mellanox/mlx5/core/en_main.c    | 11 +++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c  | 16 ++++++----------
 3 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 78cf6aedd04d..000493f42912 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -696,6 +696,9 @@ struct mlx5e_rq {
 			u8                     umr_wqebbs;
 			u8                     mtts_per_wqe;
 			u8                     umr_mode;
+			u8                     umr_entry_size;
+			u8                     umr_pad_bytes;
+			u16                    umr_pad_offset;
 			struct mlx5e_mpw_linear_info *linear_info;
 			struct mlx5e_shampo_hd *shampo;
 		} mpwqe;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index a2b3ac3011c9..b86c7b52774a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -901,6 +901,7 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 	void *rqc_wq = MLX5_ADDR_OF(rqc, rq_param->rqc, wq);
 	struct mlx5_core_dev *mdev = rq->mdev;
 	u32 pool_order = 0;
+	u16 entries_bytes;
 	u32 pool_size;
 	int wq_sz;
 	int err;
@@ -947,6 +948,16 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 			mlx5e_mpwrq_mtts_per_wqe(mdev, rq->mpwqe.page_shift,
 						 rq->mpwqe.umr_mode);
 
+		rq->mpwqe.umr_entry_size =
+			mlx5e_mpwrq_umr_entry_size(rq->mpwqe.umr_mode);
+		entries_bytes = rq->mpwqe.pages_per_wqe *
+				rq->mpwqe.umr_entry_size;
+		rq->mpwqe.umr_pad_offset = entries_bytes;
+		/* padding can be 0 when no padding is needed */
+		rq->mpwqe.umr_pad_bytes =
+			ALIGN(entries_bytes, MLX5_UMR_FLEX_ALIGNMENT) -
+			entries_bytes;
+
 		pool_size = rq->mpwqe.pages_per_wqe <<
 			mlx5e_mpwqe_get_log_rq_size(mdev, params, rqo);
 		pool_order = rq->mpwqe.page_shift - PAGE_SHIFT;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index e3f915beebe1..9e1224930e06 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -674,16 +674,11 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 		};
 	}
 
-	/* Pad if needed, in case the value set to ucseg->xlt_octowords
-	 * in mlx5e_build_umr_wqe() needed alignment.
+	/* Pad when the value set to ucseg->xlt_octowords in
+	 * mlx5e_build_umr_wqe() needed alignment.
 	 */
-	if (rq->mpwqe.pages_per_wqe & (MLX5_UMR_MTT_NUM_ENTRIES_ALIGNMENT - 1)) {
-		int pad = ALIGN(rq->mpwqe.pages_per_wqe, MLX5_UMR_MTT_NUM_ENTRIES_ALIGNMENT) -
-			rq->mpwqe.pages_per_wqe;
-
-		memset(&umr_wqe->inline_mtts[rq->mpwqe.pages_per_wqe], 0,
-		       sizeof(*umr_wqe->inline_mtts) * pad);
-	}
+	memset((u8 *)umr_wqe->inline_mtts + rq->mpwqe.umr_pad_offset, 0,
+	       rq->mpwqe.umr_pad_bytes);
 
 	bitmap_zero(wi->skip_release_bitmap, rq->mpwqe.pages_per_wqe);
 	wi->consumed_strides = 0;
@@ -692,7 +687,8 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 		cpu_to_be32((sq->pc << MLX5_WQE_CTRL_WQE_INDEX_SHIFT) |
 			    MLX5_OPCODE_UMR);
 
-	offset = (ix * rq->mpwqe.mtts_per_wqe) * sizeof(struct mlx5_mtt) / MLX5_OCTWORD;
+	offset = ix * rq->mpwqe.mtts_per_wqe *
+		 rq->mpwqe.umr_entry_size / MLX5_OCTWORD;
 	umr_wqe->hdr.uctrl.xlt_offset = cpu_to_be16(offset);
 
 	sq->db.wqe_info[pi] = (struct mlx5e_icosq_wqe_info) {
-- 
2.44.0

