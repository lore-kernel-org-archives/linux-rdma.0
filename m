Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013025.outbound.protection.outlook.com [40.93.201.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D874F4A13B9;
	Thu,  8 Oct 2026 13:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791466172; cv=fail; b=tz6qJAm46/2h69WyNsL2IZRYXyG4nRFJaYcb4rp47ZXEqjAUQkjoixd3fVqIgAiAUszC+n1DLAoWiDAS5dahrtD5cVtjnLQIBB2okkgae4IFY7nQMlD0uOh0v3/58b2UaT8CieLPiYQa/bgJF0benaSPYXmQpSXBvUO4Z9H918Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791466172; c=relaxed/simple;
	bh=n3k6KQ7p5x9yCQWXaMJm5MFpUV2tYzT5pdGK5Gf2gOg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bcsInZwHFNk0RKs+O2gezmPQMye1brceLmQKY/Wf1k7c5zaCuvvsqEkt00xUwdWVp6xDme1S3cwBk45sLv8S5Ga/BMf3FXZyf658K0CQsZlDpAdZWwOqIrIZKi5pD8MunSV9UKDkvHpl14OyMeNYxwS3sdLVB+p6fyF1MLg1Ggs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QHP2LDTY; arc=fail smtp.client-ip=40.93.201.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QHP2LDTY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xdeh/3K3c0pwzWWOZUb6PKhC9hfG8ErH0/LOS9MxwKMypQ3KZsy3Y4I/P1yPI0lNo0a9MmNFOYpvte67e7Gs355XbO8B7oZjbXaKA9Y2LJZ0iK0njtpDTVqR5o/4ic6yXLGzjMk0B7CU8WH9qM0hLRK0vNuTXqIqh1ivOyRpXjAG95OEm6TbYF+ayGjq54Jq6KxsstztBYvCaa3fuU2zmgSZbJ8G6EshyBS51hWlcOMCqenTiitGnI9ut8AzhsICxHsI4UBbP2qIylrAFfUyedTrBl2eFFNYsFb/QvkBWubJgm/gw4Q4L6MHOB/G3AZ9EQiNfktHw60wFPWbMf0mZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sVGIJgqT6moeVJtehPnFgvvvUKixVynrDhumTMntR3U=;
 b=hWAgn7GXl6q3pSf3geTK9SGMMXW22H6gxg6eITX61i2YGc69GdLA7fndb5hG3vjAIKtCt8BpXEKs1gw5ujKa/bFV34ydFB7OII9TKzO/1GBi9C0kv67rIKEZ/Vlzu6s42O0NcBzAX9R2k/JgSS/L429WpoH0AEFs7jyfj2QCP3yqoA7lcetH6iI2B5egbTKP2m40G8X83a5lC0IXXm8NX7j2zEJWvl5QE+ABvRalPW0dYvp4rdkrYnTHE7iLOhGxCk07hhmu5woxAXBmmvLB9m9AagkRALUptTDGvvvLENemndnev5gaXYdoYmDrJ08b+57X84JbhVivSo4XEdh25w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sVGIJgqT6moeVJtehPnFgvvvUKixVynrDhumTMntR3U=;
 b=QHP2LDTYMbx0XP1g8QMxGQ+G3VcCOHi4BmyPotIe8Jr3009RVQWA9JeOW2RzDl460uWcY5OShlYsN8Qf1lTm9xzaSc+3mCUd7GBvBjLjS+Y7c8drrV4cEBcLTZnrsHDDxgy0TXLAHSOM6YWxtdW7auCRBna4aDNjdRCdFyXqpvqJodUdMpZMusQYBmxRmyIoo6soj1vo+wEhxTzEJPU5p3Ahc9FVY7h9Lf38JJXgFBQWR8kusDzolSahmPP8yzC9mK9kbCWrRxffEcHsLznhtFCq5Au/fvRULfbntHfdmMpnYdCW6RSXEE3BlnomOhX0FF/Vq7B8sTeacHWDZlQ7qw==
Received: from DS7P220CA0001.NAMP220.PROD.OUTLOOK.COM (2603:10b6:8:1ca::6) by
 DM6PR12MB4419.namprd12.prod.outlook.com (2603:10b6:5:2aa::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.17; Thu, 8 Oct 2026 13:29:24 +0000
Received: from DS2PEPF000061C2.namprd02.prod.outlook.com
 (2603:10b6:8:1ca:cafe::99) by DS7P220CA0001.outlook.office365.com
 (2603:10b6:8:1ca::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Thu, 8
 Oct 2026 13:29:23 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS2PEPF000061C2.mail.protection.outlook.com (10.167.23.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.14 via Frontend Transport; Thu, 8 Oct 2026 13:29:23 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 8 Oct
 2026 06:29:04 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 8 Oct
 2026 06:29:03 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Thu, 8 Oct
 2026 06:28:56 -0700
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
Subject: [PATCH net-next 05/10] net/mlx5e: Add data direct RX infrastructure
Date: Thu, 8 Oct 2026 16:28:10 +0300
Message-ID: <20261008132815.654147-6-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF000061C2:EE_|DM6PR12MB4419:EE_
X-MS-Office365-Filtering-Correlation-Id: e248ee03-53d0-4152-df4c-08df25402b01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|376014|7416014|82310400026|1800799024|56012099006|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	wlHp6HN3KL1VlKGMTG/a28jOvPLjkYdO3Nqh1volu/2JtZlpmtolo02dtMFJ/4e04BejcQI5BJkXBHJtDJhW5LaqEFEhXU2uz9JXFPP35Q/Sj9PEfj8z7N3T3yZLbtInDzXmaUglT4XAqVyKuxpNMuYmiHlS/X3Nn2R8W0H++F/erDFKVhBUGjvgA9LUJwQKle79cg8qRUP54/tGwc1a9xLlyFM+pbO8ghtqK6i2hg1jRBEf+oRuMLPPbxEltRdNTrvHMLo7/l7Mxb+uyO+Rg7nThZ0iNcC97ga1ydJVNh4mxhNkP4aiDoh8BIl4Z0pXov9//6PRP082I5w5NkMxos+eC83pAviBBiwIPWHu4OqtwAVkvyIu8KrjdmpcIZqatuXIbNDka5Ac+Zrv+3jkkG0Izjvjx2q7LO29gHJNBTM2C1MtjhrOC15NaOhNkNP4nQDmUWFEVltMH1gpqN/hMpoMVy1f6EnPHoLCY8Z8Jq4z+ie2TAc7LNN2pagVsECIWErluSQlr01p76Oxb6N/YIeEEm6VcJN+IcXvzNJgGX2DMSNbOXqFO4r+38lIe3tEYEP9lu9rMe2AQKyQE4qRIFrCYVSy3/iQqAYI8irODELydPhAqVtk8O1gHV2KK4g5jkrgdiKsiftbz6VPSM7YjtLUGUQoClvcyPsAqH5zNOBygQ0vPMjaR/+2sWjrd9amPuuXJgmAyMYHcGwLQ6VGgA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(376014)(7416014)(82310400026)(1800799024)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	6sURsv9M7UveWkYXUYf0gaMA/2hFC+lIg6B86nIM8XL6vpoHgGtLXzUDZW0ngtN/v6A81MlzPaoPdZcriByv55lAKjqnBCwf+3pytB2WUcM98hNbNb57/4/xFgLsbTsLEuFE3v6P0WUNfFOhib+G0TdUHR22tKJIX+hG8Q33GYSbBTpSAs+26buC3gyAnpBz7+QuSMrHo73ijR3iSclhli9w1ccbFQfgq+nkWy7yPTUWBf+93SpC9NdApzN2ZvU1AArbaiqkDQGZ938oVGn33H3uo3ePuHR9h2iuhDK9/T4ekQqc+3fwXE+Ys3sOP9iKbUjKvAF6yFB8wTQsyhFCBIV/F+dhnOrbYShlzkfwd1mAEnjUfmv+ixNkUXEQ7CVhFw//8uJgw2XYt7lX8huQG3Xy0HHT/6isgSS02rMYv1IrmI+ZZS8bNguvZFQqcku2
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 13:29:23.8526
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e248ee03-53d0-4152-df4c-08df25402b01
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF000061C2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4419

From: Dragos Tatulea <dtatulea@nvidia.com>

Data direct is a HW feature that allows a type of peer-to-peer DMA
between the NIC and another device (e.g. GPU) going through a specific
PCIe topology.

For data direct to work on the RX path, the RQ will use a KSM mkey whose
entries will point to the crossed mkey. This is necessary to enable DMA
from the NIC to the other device.

This commit adds the necessary infrastructure on RX side:
- New RQ state flag for the data direct state.
- Create crossing mkey.
- Create KSM mkey and in data direct PD and make it point to the
  crossed mkey.

This commit has no functional changes. data direct mode will be
enabled in a subsequent commit and mlx5e_queue_get_dma_dev() will then
point to the right device.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   6 ++
 .../ethernet/mellanox/mlx5/core/en/params.c   |   5 +
 .../ethernet/mellanox/mlx5/core/en/params.h   |   2 +
 .../mellanox/mlx5/core/en/reporter_rx.c       |   1 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 101 ++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  12 ++-
 6 files changed, 118 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index c5bbe5adea45..d716e70c6d47 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -342,6 +342,7 @@ enum {
 	MLX5E_RQ_STATE_SHAMPO, /* set when SHAMPO cap is used */
 	MLX5E_RQ_STATE_MINI_CQE_ENHANCED,  /* set when enhanced mini_cqe_cap is used */
 	MLX5E_RQ_STATE_XSK, /* set to indicate an xsk rq */
+	MLX5E_RQ_STATE_DATA_DIRECT, /* set when the rq maps data through data direct */
 	MLX5E_NUM_RQ_STATES, /* Must be kept last */
 };
 
@@ -685,6 +686,8 @@ struct mlx5e_rq {
 			struct mlx5e_mpw_info *info;
 			mlx5e_fp_skb_from_cqe_mpwrq skb_from_cqe_mpwrq;
 			__be32                 umr_mkey_be;
+			__be32                 ksm_child_mkey_be;
+			u32                    crossing_mkey;
 			u16                    num_strides;
 			u16                    actual_wq_head;
 			u8                     log_stride_sz;
@@ -1202,6 +1205,9 @@ static inline bool mlx5_tx_swp_supported(struct mlx5_core_dev *mdev)
 extern const struct ethtool_ops mlx5e_ethtool_ops;
 
 int mlx5e_create_mkey(struct mlx5_core_dev *mdev, u32 pdn, u32 *mkey);
+int mlx5e_create_crossing_vhca_mkey(struct mlx5_core_dev *mdev,
+				    u32 crossed_mkey, u64 crossed_len,
+				    u32 *crossing_mkey);
 int mlx5e_create_mdev_resources(struct mlx5_core_dev *mdev, bool create_tises);
 void mlx5e_destroy_mdev_resources(struct mlx5_core_dev *mdev);
 int mlx5e_modify_tirs_lb(struct mlx5_core_dev *mdev, bool enable_uc_lb,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 5caf7820a136..88b4cd5497d8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -62,6 +62,9 @@ mlx5e_mpwrq_umr_mode(struct mlx5_core_dev *mdev,
 	bool unaligned = xsk ? xsk->unaligned : false;
 	bool oversized = false;
 
+	if (rqo && rqo->data_direct)
+		return MLX5E_MPWRQ_UMR_MODE_UNALIGNED;
+
 	if (xsk) {
 		oversized = xsk->chunk_size < (1 << page_shift);
 		WARN_ON_ONCE(xsk->chunk_size > (1 << page_shift));
@@ -1296,12 +1299,14 @@ void mlx5e_build_xdpsq_param(struct mlx5_core_dev *mdev,
 int mlx5e_build_channel_param(struct mlx5_core_dev *mdev,
 			      struct mlx5e_params *params,
 			      struct netdev_queue_config *qcfg,
+			      bool data_direct,
 			      struct mlx5e_channel_param *cparam)
 {
 	u8 icosq_log_wq_sz, async_icosq_log_wq_sz;
 	int err;
 
 	cparam->rq_opt.qcfg = qcfg;
+	cparam->rq_opt.data_direct = data_direct;
 
 	err = mlx5e_build_rq_param(mdev, params, &cparam->rq_opt, &cparam->rq);
 	if (err)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
index 275f9be53a34..43332015f445 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -15,6 +15,7 @@ struct mlx5e_xsk_param {
 struct mlx5e_rq_opt_param {
 	struct mlx5e_xsk_param *xsk;
 	struct netdev_queue_config *qcfg;
+	bool data_direct;
 };
 
 struct mlx5e_cq_param {
@@ -146,6 +147,7 @@ void mlx5e_build_xdpsq_param(struct mlx5_core_dev *mdev,
 int mlx5e_build_channel_param(struct mlx5_core_dev *mdev,
 			      struct mlx5e_params *params,
 			      struct netdev_queue_config *qcfg,
+			      bool data_direct,
 			      struct mlx5e_channel_param *cparam);
 
 void mlx5e_build_xsk_channel_param(struct mlx5_core_dev *mdev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 6efb626b5506..f9fce1d0e9e7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -21,6 +21,7 @@ static const char * const rq_sw_state_type_name[] = {
 	[MLX5E_RQ_STATE_SHAMPO] = "shampo",
 	[MLX5E_RQ_STATE_MINI_CQE_ENHANCED] = "mini_cqe_enhanced",
 	[MLX5E_RQ_STATE_XSK] = "xsk",
+	[MLX5E_RQ_STATE_DATA_DIRECT] = "data_direct",
 };
 
 static int mlx5e_query_rq_state(struct mlx5_core_dev *dev, u32 rqn, u8 *state)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index b86c7b52774a..e0d46e067c72 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -425,7 +425,7 @@ static u8 mlx5e_mpwrq_access_mode(enum mlx5e_mpwrq_umr_mode umr_mode)
 static int mlx5e_create_umr_mkey(struct mlx5_core_dev *mdev,
 				 u32 npages, u8 page_shift, u32 *umr_mkey,
 				 dma_addr_t filler_addr,
-				 enum mlx5e_mpwrq_umr_mode umr_mode,
+				 enum mlx5e_mpwrq_umr_mode umr_mode, u32 pdn,
 				 u32 xsk_chunk_size)
 {
 	struct mlx5_mtt *mtt;
@@ -465,7 +465,7 @@ static int mlx5e_create_umr_mkey(struct mlx5_core_dev *mdev,
 	MLX5_SET(mkc, mkc, access_mode_1_0, mlx5e_mpwrq_access_mode(umr_mode));
 	mlx5e_mkey_set_relaxed_ordering(mdev, mkc);
 	MLX5_SET(mkc, mkc, qpn, 0xffffff);
-	MLX5_SET(mkc, mkc, pd, mdev->mlx5e_res.hw_objs.pdn);
+	MLX5_SET(mkc, mkc, pd, pdn);
 	MLX5_SET64(mkc, mkc, len, npages << page_shift);
 	MLX5_SET(mkc, mkc, translations_octword_size, octwords);
 	if (umr_mode == MLX5E_MPWRQ_UMR_MODE_TRIPLE)
@@ -531,9 +531,11 @@ static int mlx5e_create_umr_mkey(struct mlx5_core_dev *mdev,
 static int mlx5e_create_rq_umr_mkey(struct mlx5_core_dev *mdev, struct mlx5e_rq *rq)
 {
 	u32 xsk_chunk_size = rq->xsk_pool ? rq->xsk_pool->chunk_size : 0;
+	bool dd = test_bit(MLX5E_RQ_STATE_DATA_DIRECT, &rq->state);
 	u32 wq_size = mlx5_wq_ll_get_size(&rq->mpwqe.wq);
 	u32 num_entries, max_num_entries;
 	u32 umr_mkey;
+	u32 pdn;
 	int err;
 
 	max_num_entries = mlx5e_mpwrq_max_num_entries(mdev, rq->mpwqe.umr_mode);
@@ -546,13 +548,80 @@ static int mlx5e_create_rq_umr_mkey(struct mlx5_core_dev *mdev, struct mlx5e_rq
 			      __func__, wq_size, rq->mpwqe.mtts_per_wqe,
 			      max_num_entries);
 
+	pdn = dd ? mdev->data_direct->pdn : mdev->mlx5e_res.hw_objs.pdn;
 	err = mlx5e_create_umr_mkey(mdev, num_entries, rq->mpwqe.page_shift,
 				    &umr_mkey, rq->wqe_overflow.addr,
-				    rq->mpwqe.umr_mode, xsk_chunk_size);
+				    rq->mpwqe.umr_mode, pdn,
+				    xsk_chunk_size);
 	rq->mpwqe.umr_mkey_be = cpu_to_be32(umr_mkey);
 	return err;
 }
 
+int mlx5e_create_crossing_vhca_mkey(struct mlx5_core_dev *mdev,
+				    u32 crossed_mkey, u64 crossed_len,
+				    u32 *crossing_mkey)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
+	int access_mode = MLX5_MKC_ACCESS_MODE_CROSSING;
+	void *mkc;
+	u32 *in;
+	int err;
+
+	if (!MLX5_CAP_GEN(mdev, crossing_vhca_mkey))
+		return -EOPNOTSUPP;
+
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return -ENOMEM;
+
+	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
+	MLX5_SET(mkc, mkc, access_mode_1_0, access_mode & 0x3);
+	MLX5_SET(mkc, mkc, access_mode_4_2, (access_mode >> 2) & 0x7);
+	MLX5_SET(mkc, mkc, crossing_target_vhca_id,
+		 MLX5_CAP_GEN(mdev, vhca_id));
+	MLX5_SET(mkc, mkc, translations_octword_size, crossed_mkey);
+	MLX5_SET(mkc, mkc, pd, mdev->mlx5e_res.hw_objs.pdn);
+	MLX5_SET(mkc, mkc, qpn, 0xffffff);
+	MLX5_SET(mkc, mkc, lr, 1);
+	MLX5_SET(mkc, mkc, lw, 1);
+	MLX5_SET64(mkc, mkc, start_addr, 0);
+	MLX5_SET64(mkc, mkc, len, crossed_len);
+
+	err = mlx5_core_create_mkey(mdev, crossing_mkey, in, inlen);
+	kvfree(in);
+	return err;
+}
+
+static int mlx5e_rq_alloc_data_direct_mkey(struct mlx5e_rq *rq)
+{
+	struct mlx5_core_dev *mdev = rq->mdev;
+	u32 umr_mkey;
+	u64 umr_len;
+	int wq_sz;
+
+	if (!test_bit(MLX5E_RQ_STATE_DATA_DIRECT, &rq->state))
+		return 0;
+
+	wq_sz = mlx5_wq_ll_get_size(&rq->mpwqe.wq);
+	umr_mkey = be32_to_cpu(rq->mpwqe.umr_mkey_be);
+	umr_len = (u64)wq_sz * rq->mpwqe.mtts_per_wqe << rq->mpwqe.page_shift;
+
+	rq->mpwqe.ksm_child_mkey_be =
+		cpu_to_be32(mdev->data_direct->mkey_ro_valid ?
+			    mdev->data_direct->mkey_ro :
+			    mdev->data_direct->mkey);
+
+	return mlx5e_create_crossing_vhca_mkey(mdev, umr_mkey,
+					       umr_len,
+					       &rq->mpwqe.crossing_mkey);
+}
+
+static void mlx5e_rq_free_data_direct_mkey(struct mlx5e_rq *rq)
+{
+	if (test_bit(MLX5E_RQ_STATE_DATA_DIRECT, &rq->state))
+		mlx5_core_destroy_mkey(rq->mdev, rq->mpwqe.crossing_mkey);
+}
+
 static void mlx5e_init_frags_partition(struct mlx5e_rq *rq)
 {
 	struct mlx5e_wqe_frag_info next_frag = {};
@@ -900,6 +969,7 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 {
 	void *rqc_wq = MLX5_ADDR_OF(rqc, rq_param->rqc, wq);
 	struct mlx5_core_dev *mdev = rq->mdev;
+	bool data_direct = false;
 	u32 pool_order = 0;
 	u16 entries_bytes;
 	u32 pool_size;
@@ -937,6 +1007,11 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 		if (err)
 			goto err_rq_wq_destroy;
 
+		data_direct = rqo && rqo->data_direct;
+
+		if (data_direct)
+			set_bit(MLX5E_RQ_STATE_DATA_DIRECT, &rq->state);
+
 		rq->mpwqe.umr_mode = mlx5e_mpwrq_umr_mode(mdev, rqo);
 		rq->mpwqe.pages_per_wqe =
 			mlx5e_mpwrq_pages_per_wqe(mdev, rq->mpwqe.page_shift,
@@ -975,10 +1050,14 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 		if (err)
 			goto err_rq_drop_page;
 
-		err = mlx5e_rq_alloc_mpwqe_info(rq, node);
+		err = mlx5e_rq_alloc_data_direct_mkey(rq);
 		if (err)
 			goto err_rq_mkey;
 
+		err = mlx5e_rq_alloc_mpwqe_info(rq, node);
+		if (err)
+			goto err_rq_free_dd_mkey;
+
 		err = mlx5e_rq_alloc_mpwqe_linear_info(rq, node, params, rqo);
 		if (err)
 			goto err_free_mpwqe_info;
@@ -1071,7 +1150,9 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 
 			wqe->data[0].addr = cpu_to_be64(dma_offset + headroom);
 			wqe->data[0].byte_count = cpu_to_be32(byte_count);
-			wqe->data[0].lkey = rq->mpwqe.umr_mkey_be;
+			wqe->data[0].lkey = data_direct ?
+				cpu_to_be32(rq->mpwqe.crossing_mkey) :
+				rq->mpwqe.umr_mkey_be;
 		} else {
 			struct mlx5e_rx_wqe_cyc *wqe =
 				mlx5_wq_cyc_get_wqe(&rq->wqe.wq, i);
@@ -1105,6 +1186,8 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 		kvfree(rq->mpwqe.linear_info);
 err_free_mpwqe_info:
 		kvfree(rq->mpwqe.info);
+err_rq_free_dd_mkey:
+		mlx5e_rq_free_data_direct_mkey(rq);
 err_rq_mkey:
 		mlx5_core_destroy_mkey(mdev, be32_to_cpu(rq->mpwqe.umr_mkey_be));
 err_rq_drop_page:
@@ -1132,6 +1215,7 @@ static void mlx5e_free_rq(struct mlx5e_rq *rq)
 		mlx5e_rq_free_shampo(rq);
 		kvfree(rq->mpwqe.linear_info);
 		kvfree(rq->mpwqe.info);
+		mlx5e_rq_free_data_direct_mkey(rq);
 		mlx5_core_destroy_mkey(rq->mdev, be32_to_cpu(rq->mpwqe.umr_mkey_be));
 		mlx5e_free_mpwqe_rq_drop_page(rq);
 		break;
@@ -2849,6 +2933,7 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 	struct mlx5e_xsk_param xsk;
 	bool async_icosq_needed;
 	struct mlx5e_channel *c;
+	bool data_direct;
 	unsigned int irq;
 	int vec_ix;
 	int cpu;
@@ -2873,7 +2958,11 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 		goto err_free;
 	}
 
-	err = mlx5e_build_channel_param(mdev, params, qcfg, cparam);
+	data_direct = MLX5E_GET_PFLAG(params, MLX5E_PFLAG_DATA_DIRECT) &&
+		      netif_rxq_has_unreadable_mp(netdev, ix);
+
+	err = mlx5e_build_channel_param(mdev, params, qcfg, data_direct,
+					cparam);
 	if (err)
 		goto err_free;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 9e1224930e06..c992da08caae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -669,9 +669,15 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 			goto err_unmap;
 
 		addr = page_pool_get_dma_addr_netmem(frag_page->netmem);
-		umr_wqe->inline_mtts[i] = (struct mlx5_mtt) {
-			.ptag = cpu_to_be64(addr | MLX5_EN_WR),
-		};
+		if (test_bit(MLX5E_RQ_STATE_DATA_DIRECT, &rq->state))
+			umr_wqe->inline_ksms[i] = (struct mlx5_ksm) {
+				.key = rq->mpwqe.ksm_child_mkey_be,
+				.va  = cpu_to_be64(addr),
+			};
+		else
+			umr_wqe->inline_mtts[i] = (struct mlx5_mtt) {
+				.ptag = cpu_to_be64(addr | MLX5_EN_WR),
+			};
 	}
 
 	/* Pad when the value set to ucseg->xlt_octowords in
-- 
2.44.0

