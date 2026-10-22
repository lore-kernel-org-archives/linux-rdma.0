Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792697516;
	b=1ESYCihSABZ7tKRNFIuPLi3EEkp3tov0g2vobmIxzwor7UeoeKJeRt6aPxJc1mTbJ8r1
	 nBCYGXsnlkL7O+dH389KMYssJoaIaBSnWapvuK0hG+DnnTiveXbzkcrkAq1OBaJVng7VC
	 kvwylqQsoy9+bRULC6wO5xZBpaoQ21sT3rMXtSK5XrvkUrJQO54H19pXXmYnDM80YycJk
	 fVSMrOi0Kwz8iAICoIRrEKCZAJSNDdhharnXAq2fHG8+BJgJnLPLoqPEZv9+/Cy3IStRP
	 eJ3eeM6dm5x5PrJmZwWheAmmBHDI/Qj22rR69MHU3fhLik4QUFrdtImS26zet8ZgDXA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792697516;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-NV-OnPremToCloud:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=Uei805ykbYrYdKwE6wcuoGmaJnKgP88NZAdWUZeDQjo=;
	b=ScUlRwxyQbcLTqanJphmn/oPqu3GYWATu2ux5Kb08RTNPDTZCU/GCBXJeMFaiq5Hut9m
	 MFrHnk+eEdva6TxEFy/tfNTBweOcXdVPtfOaK39rDexnt77bGmPgWbjq1yaazK7kVH1WZ
	 99NYh9mV6camN8w3SpaZ6u58QX4lPjxEw7DSfP/yddIYKPxhrmlaqY9znUPQKFDn8tL3D
	 2ixFvkELsfhihh9HBrc7ThLk+GpuiuU07izKkl4clA0yuMxlc0lAI8liHAZGuHPjOEcbz
	 NVEtosV+kV8sfZ1WCBL1rwq4+2kVNO0O7BOLURkiwdz9B0xFRmy3wWZ98Kc1yOjdqyg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Uk5JpbhH;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.51
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011051.outbound.protection.outlook.com [52.101.52.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99AC606A320;
	Thu, 22 Oct 2026 19:31:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A99AC606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Uk5JpbhH
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k/AqupI3qskxv2T2+NqfvbpgLlReYwTFkI1iVYTgvCxrONR/y4nPgmtrm3fZseOmm9g5Wfi/uBVo6ukVlSBTsmk0zQVI5btiQIXPk+ag0vmyhAYq1r245N51oW3c+H8rhjxQE4oFF/OOAyZtI3QZ7auXt2L7qHilH/QfvI7l6VxPUstgEkj2EvZbvic5YJR6cCSK6VfaViunhwEOA1alGaiw2J6VxdISP/796QcPWzqe732nvA71aUqXaS3WoRb2LgrH6Xakn6mKxOmvvPvQHOcyqkj5wOHMfvuewJy6koYPJfQODz80LeAAAGMRQc+zw4Uhxc2cu+p6TvL8RTgYMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uei805ykbYrYdKwE6wcuoGmaJnKgP88NZAdWUZeDQjo=;
 b=I9NPPMbRYAegGygeGB4jZWqztVuvNsYX8Jc/jyAq8dlOiVEcqH07OId8anNipaSipK4MU85VcQ8vGXIEJ0rn9b/n0pOwYGE78oTTU/aTVcPIX9ShDI2wBsg3jMahizs5MnTte8ZqJmPTo7ItmnpaHkZe3GQG5NtAeD2DNGRD7vImL96utriD1I390IxFbg+XrfLk1mzXFdh/1+QbxY6CftuVs9PclQl+g01RFUbedvVerPLsL0dhWoTro9oOQg/jfm6J11ISrV/oZ95gq5v7awSIyTZBjTuDuJMuOUHdoD0pe3LW5yGr90tlzeK3UeHURc6ND2SidHANkAVUTeBAJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uei805ykbYrYdKwE6wcuoGmaJnKgP88NZAdWUZeDQjo=;
 b=Uk5JpbhHU03HxO2gDHu8GaaIqf//dfmf9aOwurkKlsquahY0ZqX8ucb37dnd0R0lWq3njGwQnMtITZbLyc61BBXWEx9Cdt1c9B8JWuIf2fJEt823aweAAkrJU/yDuXsJU/zNwt2idv0Ir1plpZh2Np0k0pfRKnYG+vCPvTC6VeB2wl+jj7O3GTRU2gkvQYoGvPz0/44VcHQYdsKYl/qjRJc5Cff2GuzjyFjkk2gAVOLYeGOoguAg5Xv//CCN1C1jwgrbFSR8w/nup/2BkSWNp0f0WMrMkSPNxL4UmgcHcxoj5T9HGzb6+HUYd/UKiO8yYJmg4d8SZxDCAPLjb77bdg==
Received: from BN9PR03CA0547.namprd03.prod.outlook.com (2603:10b6:408:138::12)
 by DM4PR12MB6229.namprd12.prod.outlook.com (2603:10b6:8:a8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.24; Thu, 22 Oct
 2026 19:31:47 +0000
Received: from BN7PEPF00000091.namprd03.prod.outlook.com
 (2603:10b6:408:138:cafe::65) by BN9PR03CA0547.outlook.office365.com
 (2603:10b6:408:138::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Thu,
 22 Oct 2026 19:31:47 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN7PEPF00000091.mail.protection.outlook.com (10.167.245.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15 via Frontend Transport; Thu, 22 Oct 2026 19:31:46 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 22 Oct
 2026 12:31:20 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 22 Oct 2026 12:31:20 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Thu, 22 Oct 2026 12:31:15 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Carolina Jubran <cjubran@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>, Edward Srouji <edwards@nvidia.com>, "Gal
 Pressman" <gal@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Kees Cook
	<kees@kernel.org>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Maher Sanalla <msanalla@nvidia.com>, Mark Bloch
	<mbloch@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drori <shayd@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net V2 1/4] {RDMA,net}/mlx5: cache and use TX-enabled aggregate speed for vports
Date: Thu, 22 Oct 2026 22:30:50 +0300
Message-ID: <20261022193053.3815866-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261022193053.3815866-1-tariqt@nvidia.com>
References: <20261022193053.3815866-1-tariqt@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN7PEPF00000091:EE_|DM4PR12MB6229:EE_
X-MS-Office365-Filtering-Correlation-Id: a7260561-a346-4e5a-28b5-08df30731cc2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|36860700016|376014|23010399003|82310400026|56012099006|261021135927099003|261009223027099003|11063799006|22082099003|261021123027099003|6133799003|261021121427099003|13003099007|18002099003|10067099003|260925021911599003|260925022911599003|261022105027099003|260925021311599003;
X-Microsoft-Antispam-Message-Info:
	cN2Ta6QDz484/7rRNyG2i4NwIbPIew03a4uYhSESOURvkOSyUkYL4mdNJFueZ3d9XHJLqGZnIk87LT2VXru7GB6IPb5FPElpdcZaDd1D/4vOvAOPxvS3ZLyXAkpk3mLtDghX1TiB579kZkOgE4fe1J3gyd+xgbWK4HLwn4yctOi8rvDT0dk9yqM4ivLmkYYS4Q3A+kewQ4vztgGcTAoKVIQUkCF+2zJuN8aG3ZvIxp645QUkegc9uJHBro0D1401HjCKpQZd9ZfyBIN7zV8i3hKvfq0aL86RVsEbBYse4x6VE5sDCWkVtaDvXVU4bfvIdiMSOn4ONLtlAt3h5Sy9suGfOgFi+8gY92mPVs52UXQb0S6KaHwilJZlYC0f6BQF0z7Aj/7g9f8SCLlS9IInNkfkx84Gl5Lx7Lnw/OyZtqTL0Jr4acs57aKX3AAfi29IBFf4sECzwiDvWwmbiVp7cEa+8BUH4l9Z+fYrkC2ZGoZFQFD8i/B+4hzZUhIFtNflRrAQUM7CVuZSA6PDpvpAK9V5GLTu6jjpq99j2Tf613yVhFG71LJyJ4rqXSZ3QhiM9Ycl4afFBMnD0Q2zCI2txiOFbwELAXjHQRmYvUqOSmVBgQ9NDBxIffS3CvkadPRdEwtgdASwXCxOFL+VJ1sbkh1O1hDXP8fCEgk0M8q9Agpa4TPFe0GEM5ZoYzpbAvCLQ727501O7kvo/ruQIRm4mw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(36860700016)(376014)(23010399003)(82310400026)(56012099006)(261021135927099003)(261009223027099003)(11063799006)(22082099003)(261021123027099003)(6133799003)(261021121427099003)(13003099007)(18002099003)(10067099003)(260925021911599003)(260925022911599003)(261022105027099003)(260925021311599003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	97ogMiXYBA63fZg9EBZgfqASU7aTeAaTG6WhCgxJl8MYpEy6YKN95Ojh9XuAy9ydlH7YT/UsRS+PYehQ1wIWr4w1D/JzG+FtWfyVGMldLxVpy+it3VzS/KGgkKRTJ7kfTlY8TELDSOHz0ZfYAa3fQ+SA7TO3OVzrAqLfccu1EEkiG427oN0ejBZf3kBqzXAZu2bg0gTXMVRRrQVZb5gj2uidnMbRVpiP1DjF3OUeJEntp8sgxkukx09reEiZMxuJulxFVnBRe2RHWj9IkZmyfGoxltwLdI77R8W2MNwfMLaNEzommsqD2STbdyVxg9WSd9cOseI+DRbX2ymFF9C4o4z+FDuqDC0qppU28Z2HGGzGCPg1WkYzGOVSYTffemWdl6uyxk5fKeNxkdK0zJW2P5A9pOMwLqyvZRwhtaVRQ76JokbZpL5+9JsoAcKKfjo3
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 19:31:46.9947
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a7260561-a346-4e5a-28b5-08df30731cc2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN7PEPF00000091.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6229

From: Or Har-Toov <ohartoov@nvidia.com>

Cache aggregate TX-enabled speed we calculated, and use it instead of
querying the bond speed so we can, in the following patch, limit it by
the PCI bandwidth.

The bond speed takes the calculation from PTYS, and PTYS is not bounded
by the PCI bandwidth of the NIC.

The max-speed fallback in mlx5_lag_set_vports_agg_speed() is local to
VF/SF vport rate-limit programming; agg_speed_mbps stores operational
speed only, and mlx5_lag_query_aggregated_speed() correctly returns zero
when all member links are down.
Until the aggregate has been measured, or after a failed measurement,
mlx5_lag_query_aggregated_speed() returns -ENODATA.

Fixes: 50f1d188c580 ("net/mlx5: Propagate LAG effective max_tx_speed to vports")
Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c             |  2 +-
 .../net/ethernet/mellanox/mlx5/core/esw/qos.c |  1 +
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 86 +++++++++++++++----
 .../net/ethernet/mellanox/mlx5/core/lag/lag.h | 16 +++-
 include/linux/mlx5/driver.h                   |  2 +-
 5 files changed, 84 insertions(+), 23 deletions(-)

v1:
https://lore.kernel.org/all/20260910102432.3845360-4-tariqt@nvidia.com/

Changes in v2:
- Count only TX-enabled, link-up ports from the LAG tracker for
  non-MPESW modes; MPESW keeps the vport state check
- mlx5_lag_update_agg_speed() returns an error, and
  mlx5_lag_set_vports_agg_speed() bails out on failure instead of
  using the previous cached speed; the #else stub checks the return too
- Stop exporting mlx5_lag_query_bond_speed(), which has no users
  outside mlx5_core
- Describe in the changelog what mlx5_lag_query_aggregated_speed()
  returns when all member links are down
- Start agg_speed_mbps as SPEED_UNKNOWN and reset it to SPEED_UNKNOWN on
  teardown; mlx5_lag_query_aggregated_speed() returns -ENODATA instead
  of a zero speed until the first successful measurement
- A failed measurement invalidates the cached speed

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index a457647edacd..6594d38cf199 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1654,7 +1654,7 @@ static int mlx5_ib_query_port_speed_from_bond(struct mlx5_ib_dev *dev,
 	u32 bond_speed;
 	int err;
 
-	err = mlx5_lag_query_bond_speed(mdev, &bond_speed);
+	err = mlx5_lag_query_aggregated_speed(mdev, &bond_speed);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
index 0d20f51b9702..0148306421ad 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
@@ -5,6 +5,7 @@
 #include "lib/mlx5.h"
 #include "esw/qos.h"
 #include "en/port.h"
+#include "lag/lag.h"
 #define CREATE_TRACE_POINTS
 #include "diag/qos_tracepoint.h"
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 4e173b08cb37..57755ceab8a7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -360,6 +360,7 @@ static struct mlx5_lag *mlx5_lag_dev_alloc(struct mlx5_core_dev *dev)
 
 	ldev->ports = MLX5_CAP_GEN(dev, num_lag_ports);
 	ldev->buckets = 1;
+	ldev->agg_speed_mbps = SPEED_UNKNOWN;
 
 	return ldev;
 }
@@ -1431,10 +1432,10 @@ static bool mlx5_lag_should_disable_lag(struct mlx5_lag *ldev, bool do_bond)
 	       ldev->mode != MLX5_LAG_MODE_MPESW;
 }
 
-#ifdef CONFIG_MLX5_ESWITCH
 static int mlx5_lag_get_devices_oper_speed(struct mlx5_lag *ldev,
 					   u32 *sum_speed)
 {
+	bool mpesw = ldev->mode == MLX5_LAG_MODE_MPESW;
 	int pf_idx;
 
 	*sum_speed = 0;
@@ -1452,15 +1453,21 @@ static int mlx5_lag_get_devices_oper_speed(struct mlx5_lag *ldev,
 		pf_mdev = pf->dev;
 		if (!pf_mdev)
 			continue;
-		ret = mlx5_query_vport_max_tx_speed(pf_mdev, opmod, 0, 0,
-						    &speed, &state);
-		if (ret) {
-			mlx5_core_dbg(pf_mdev, "State query failed (err=%d)\n",
-				      ret);
-			return ret;
-		}
-		if (state != VPORT_STATE_UP)
+		if (mpesw) {
+			ret = mlx5_query_vport_max_tx_speed(pf_mdev, opmod, 0,
+							    0, &speed, &state);
+			if (ret) {
+				mlx5_core_dbg(pf_mdev,
+					      "State query failed (err=%d)\n",
+					      ret);
+				return ret;
+			}
+			if (state != VPORT_STATE_UP)
+				continue;
+		} else if (!ldev->tracker.netdev_state[pf_idx].tx_enabled ||
+			   !ldev->tracker.netdev_state[pf_idx].link_up) {
 			continue;
+		}
 
 		ret = mlx5_port_oper_linkspeed(pf_mdev, &speed);
 		if (ret) {
@@ -1476,6 +1483,31 @@ static int mlx5_lag_get_devices_oper_speed(struct mlx5_lag *ldev,
 	return 0;
 }
 
+int mlx5_lag_update_agg_speed(struct mlx5_lag *ldev)
+{
+	u32 speed;
+	int err;
+
+	lockdep_assert_held(&ldev->lock);
+
+	err = mlx5_lag_get_devices_oper_speed(ldev, &speed);
+	if (err) {
+		WRITE_ONCE(ldev->agg_speed_mbps, SPEED_UNKNOWN);
+		return err;
+	}
+
+	WRITE_ONCE(ldev->agg_speed_mbps, speed);
+	return 0;
+}
+
+void mlx5_lag_reset_agg_speed(struct mlx5_lag *ldev)
+{
+	lockdep_assert_held(&ldev->lock);
+
+	WRITE_ONCE(ldev->agg_speed_mbps, SPEED_UNKNOWN);
+}
+
+#ifdef CONFIG_MLX5_ESWITCH
 static int mlx5_lag_get_devices_max_speed(struct mlx5_lag *ldev, u32 *max_speed)
 {
 	bool take_max;
@@ -1559,19 +1591,18 @@ void mlx5_lag_set_vports_agg_speed(struct mlx5_lag *ldev)
 	u32 speed;
 	int pf_idx;
 
-	if (ldev->mode == MLX5_LAG_MODE_MPESW) {
-		if (mlx5_lag_get_devices_oper_speed(ldev, &speed))
-			return;
-	} else {
-		speed = ldev->tracker.bond_speed_mbps;
-		if (speed == SPEED_UNKNOWN)
-			return;
-	}
+	if (mlx5_lag_update_agg_speed(ldev))
+		return;
+
+	speed = ldev->agg_speed_mbps;
 
-	/* If speed is not set, fall back to the max achievable speed */
+	/* If speed is 0, fallback to the max speed */
 	if (!speed && mlx5_lag_get_devices_max_speed(ldev, &speed))
 		return;
 
+	if (!speed)
+		return;
+
 	speed = speed / MLX5_MAX_TX_SPEED_UNIT;
 
 	mlx5_ldev_for_each(pf_idx, 0, ldev) {
@@ -1594,6 +1625,7 @@ void mlx5_lag_reset_vports_speed(struct mlx5_lag *ldev)
 	int pf_idx;
 	int ret;
 
+	mlx5_lag_reset_agg_speed(ldev);
 	mlx5_ldev_for_each(pf_idx, 0, ldev) {
 		pf = mlx5_lag_pf(ldev, pf_idx);
 		if (!pf)
@@ -2089,6 +2121,23 @@ static int mlx5_handle_changeinfodata_event(struct mlx5_lag *ldev,
 	return 1;
 }
 
+/* Returns speed in Mbps. */
+int mlx5_lag_query_aggregated_speed(struct mlx5_core_dev *mdev, u32 *speed)
+{
+	struct mlx5_lag *ldev;
+
+	ldev = mlx5_lag_dev(mdev);
+	if (!ldev)
+		return -ENODEV;
+
+	*speed = READ_ONCE(ldev->agg_speed_mbps);
+	if (*speed == SPEED_UNKNOWN)
+		return -ENODATA;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mlx5_lag_query_aggregated_speed);
+
 static void mlx5_lag_update_tracker_speed(struct lag_tracker *tracker,
 					  struct net_device *ndev)
 {
@@ -2146,7 +2195,6 @@ int mlx5_lag_query_bond_speed(struct mlx5_core_dev *mdev, u32 *speed)
 	spin_unlock_irqrestore(&lag_lock, flags);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(mlx5_lag_query_bond_speed);
 
 /* this handler is always registered to netdev events */
 static int mlx5_lag_netdev_event(struct notifier_block *this,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index e9f0ef83ce1d..45b0e8fd8f99 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -99,6 +99,7 @@ struct mlx5_lag {
 	/* Protect lag fields/state changes */
 	struct mutex		  lock;
 	struct lag_mpesw	  lag_mpesw;
+	u32			  agg_speed_mbps;
 };
 
 static inline struct mlx5_lag *
@@ -258,12 +259,23 @@ void mlx5_lag_rescan_dev_locked(struct mlx5_lag *ldev,
 void mlx5_lag_add_devices_filter(struct mlx5_lag *ldev, u32 filter);
 struct mlx5_devcom_comp_dev *mlx5_lag_get_devcom_comp(struct mlx5_lag *ldev);
 
+int mlx5_lag_update_agg_speed(struct mlx5_lag *ldev);
+void mlx5_lag_reset_agg_speed(struct mlx5_lag *ldev);
+int mlx5_lag_query_bond_speed(struct mlx5_core_dev *dev, u32 *speed);
+
 #ifdef CONFIG_MLX5_ESWITCH
 void mlx5_lag_set_vports_agg_speed(struct mlx5_lag *ldev);
 void mlx5_lag_reset_vports_speed(struct mlx5_lag *ldev);
 #else
-static inline void mlx5_lag_set_vports_agg_speed(struct mlx5_lag *ldev) {}
-static inline void mlx5_lag_reset_vports_speed(struct mlx5_lag *ldev) {}
+static inline void mlx5_lag_set_vports_agg_speed(struct mlx5_lag *ldev)
+{
+	mlx5_lag_update_agg_speed(ldev);
+}
+
+static inline void mlx5_lag_reset_vports_speed(struct mlx5_lag *ldev)
+{
+	mlx5_lag_reset_agg_speed(ldev);
+}
 #endif
 
 static inline bool mlx5_lag_is_supported(struct mlx5_core_dev *dev)
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 83d0a83bbfbc..ff38086c6c56 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1154,7 +1154,7 @@ int mlx5_cmd_destroy_vport_lag(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_roce(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_sriov(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_active(struct mlx5_core_dev *dev);
-int mlx5_lag_query_bond_speed(struct mlx5_core_dev *dev, u32 *speed);
+int mlx5_lag_query_aggregated_speed(struct mlx5_core_dev *dev, u32 *speed);
 bool mlx5_lag_mode_is_hash(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_master(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_shared_fdb(struct mlx5_core_dev *dev);
-- 
2.44.0

