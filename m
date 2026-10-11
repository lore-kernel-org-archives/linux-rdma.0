Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013055.outbound.protection.outlook.com [40.93.196.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690B013CA92;
	Sun, 11 Oct 2026 09:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791711132; cv=fail; b=MXkg6sVPY/AaCIVJMHX1C5UUEax7PuDfgnwJwIvZpwchd759wx7ZOK/Jy3mj2feirt5vGEQHVLmVzpG67yBb+PyP3Zq3nXxTcyxwR36w9d91bIGgGywmQzMEbEf9caBU1Zt/V/ONJCqHfebcSounm1JdxOHJ9gBZj8ke6GfCrgI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791711132; c=relaxed/simple;
	bh=4MfmwV8qufhWUaprpHWFBVU4AnojlE3qGH4MT4MnPGc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UkYPj1+Ps8ALQ5BgvfknNHlD5LxVAtrFfEHsHmaPpPOCtK0FO1qebPBCOYkY8u/Pl85QP5PegqLHUJRcMTMjct51Qe0Q5E6NiJSrXWuTG9GopvcFabU5kISfL/yyN1A5a6bFI/W9nKeTuRNH7F9WJLds+gwnVfvCq5URbKcQqqU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RfzITYbd; arc=fail smtp.client-ip=40.93.196.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RfzITYbd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ejpzbc6FyUroZOykd69FaJJ61ovKk4+r+SKRUeOOg1/FbTCS0avY/KSuCra/w/AlbADT9K9wxXLPR0VY7krsFHzZgu80GHX/u33IEvJhgye62FI6P0B0S0buO89my2ZOrdlXUwDjf2Zlk2Kf4bFckDTmOdHF88n+v5tUBno/+x6ax52YkPBYSgIq9RsGwzJYZi+oijMuItcSfdC3Che52sX5Z+YeLpgf/vhZTzjlTiPx2UocMVcf7PU7pAGbRlaOw3pL7sdA9S2k7Tyw8o6LAi3A0+UDSvMDlL1sClxE7ZcMT0+U62r6p7I2oQrXTzlYM0BpirIm9wgPBM24+ndzJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JpohDi9kokQfUZGJwQDGpF3mgfiuOjp9jxcdQ+UKDtw=;
 b=ihTcopdina8TlBmpNZxC94qg/8EBnsh7lVrr9MfM5LvK9+lwi1m3ATUkXs+OPp+BrH4W1fe8YONhq2Xk/Y9Yt+9HAZlMMJ6KbHXmeVSQnH5OMzCeMTWZz3DCE+tWxPcYG+pHyU5K0QzmMXOMwRZV8detbxSwqSI/SonXLqw/0S8dl6WoEmCuD+FOLG2wBaYDIJ9TnDgjw9L1lsMgJ+rh0glvb/7Z5HE61hiVZQeCfOVgBd2nghV7yvOzXJC3orq5V9BI5y1hIEN/Kggsj6luu4HFZtYgwK7VYnA+Yoq3rOAQFCPyGh27DInXusma1IrkRL5yNN3u3iXXTyHzqnAARQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JpohDi9kokQfUZGJwQDGpF3mgfiuOjp9jxcdQ+UKDtw=;
 b=RfzITYbdhLgC71SO83x/IebLyQn/tiM+0DCd3AEEdjUwrUJBElebbeUFsePLunFgYijVJyp4qWC91uiH/pOBmrngRUFuRzzi860o+xNwgiGTbEPyeu6mj2+9QgNeqmDPwGJPDYswrpOHGUhUyVE6CbXzebKFtsW4HPlxljlpDnbWcw9iOdWhnu1a9r3MskPD8uueVBKLvb1I/bT3aIn0UWm6PXVp4pWDipiJ+VSf59rXW2rxU7TUflW41VlD4fyQNF5HcdWaBoYt0DKRsLVJgbDIn3tbBtMKPfC4lrMeo3FeC1+KkBu/pLpIyah2pwE6WWqRrfBg0MEN5jtX1A1ouQ==
Received: from CH2PR18CA0051.namprd18.prod.outlook.com (2603:10b6:610:55::31)
 by BL1PR12MB5827.namprd12.prod.outlook.com (2603:10b6:208:396::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.20; Sun, 11 Oct
 2026 09:32:02 +0000
Received: from CH3PEPF0000000F.namprd04.prod.outlook.com
 (2603:10b6:610:55:cafe::3a) by CH2PR18CA0051.outlook.office365.com
 (2603:10b6:610:55::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Sun,
 11 Oct 2026 09:32:02 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH3PEPF0000000F.mail.protection.outlook.com (10.167.244.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Sun, 11 Oct 2026 09:32:02 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Sun, 11 Oct
 2026 02:31:54 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Sun, 11 Oct
 2026 02:31:53 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Sun, 11
 Oct 2026 02:31:48 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Aleksandr Loktionov <aleksandr.loktionov@intel.com>, Alexei Lazar
	<alazar@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Dragos Tatulea
	<dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shahar Shitrit <shshitrit@nvidia.com>, "Stanislav
 Fomichev" <sdf@fomichev.me>, Stanislav Fomichev <sdf.kernel@gmail.com>,
	"Tariq Toukan" <tariqt@nvidia.com>
Subject: [PATCH net-next] net/mlx5e: Rename state_destroy to rx_mode_active in flow steering
Date: Sun, 11 Oct 2026 12:31:00 +0300
Message-ID: <20261011093100.769149-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
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
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000F:EE_|BL1PR12MB5827:EE_
X-MS-Office365-Filtering-Correlation-Id: 676c0bc1-8a8e-4414-952d-08df277a81aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|7416014|36860700016|82310400026|56012099006|11063799006|261009223027099003|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	PmhaNSVRohzjcWy65c+aEWcNMrHOpxyZNOCFizlf/3QTH0/z+sNzFHNlPeWvw4zb4Yj8kQSq1+x2WdPM1dlDfQr5hnRAPnQv9URItR1u2+HfS63r7RNT1kHSswr+JiBJMP4Iypbcp47hR1MWIs5qytyYxeDPLdG0KBT9qKFI6N5yEehpaYrJJ9g7AHSYbewCxPEKbyzEEtWzcjyruzcvYk7gvu/r2pTH5C+U5vb9w+Y3lTSLYbEezagZ9A+rtOsisYVsLwjWzDzeTd3i8h4G7i12ebYlZzOEX/fiE6v7yBMuHKbArT0I4xZ2PD5RkshkgPRHVXWDNJQpYu6iWl8bXCzrqujgsPhzw7FGYMdy1OATbHQPYjMoTjjGWMMgyx6+SaRV/S0wEZnJZflZD7PHHbDCmqfZcoQlDa3JIeHJgkLzEe0tqmWuV/VumgNY+yDTbT8MdkF+oyF7215KYNv7KjIZGAc8ZqizyXV9ZQlWUckBmFBPfOCr2yfT/W+mHv5XYXv7L4H631lcIx41BT8/8KlpDfW+gv8jQFo0IMCf1AQmUKxO5SzZl3Kd25ginvY8jJmmibiy4ryRK/fr9UJ3akHDq2hdkBAkmy1OhisODPUQ0e3SZ4OzCq3RiqP0ZPYGO+d7DeOe0RKiszZvclJh/GL0bkrIg2xt9pV4g6KWy41E6K7KEGcC+nRCZLtUDe/4kdhBs7jeKrATkjBHr9LjCw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(7416014)(36860700016)(82310400026)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	u+n0ahPVFze03PWezREyQr1F7bsv2hBN797kuwczEmQFECcT7+RwMrYfimjSwyBcF2eO9QDpZw2SwsImmtcmZCyB2Qbn3/vBUWjmAsTdKo/JJxvVapr8dUzgGtRdYNTbCe0Y0hLXREHlEb7cy5B7DMP/xGodPU4MFieVqL07EevR5OnJ6IH0j5v7rsbg9HBZNAyG4Q0WsLl2SEV7P09Jjf61vfHeR7q82gxEInV0+734nsdm3G1FsyDbIeRkqwr2ILPgUN8Tel4GT5B+eGjamJ3KrL9GuqRQwaGzwWEr7S2KTHOObnAEAfGURmuOOqmwF2W+Paq7KfkOjmN4+xjymaXPoCqj0sbtU0YjBCnBlKRk8gDUryurb2gV07Pt7Q1k1fpy836uazbXOAU+WuUjaA3XxqsexmEtkToO0rp04p8rF0nIab6uthx7vjC5WlX6
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2026 09:32:02.3242
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 676c0bc1-8a8e-4414-952d-08df277a81aa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5827

From: Alexei Lazar <alazar@nvidia.com>

This flag controls the enablement of RX mode handling (promisc,
allmulti, broadcast, netdev addr sync). It acts as a safeguard
that prevents new FS (flow steering) operations during device
teardown. When the device is in destroying state it is set to
false to indicate RX mode operations are not allowed.
Its name is misleading, as it suggests a destroy-state flag
rather than RX mode activity. Rename it for clarity.

No functional change.

Signed-off-by: Alexei Lazar <alazar@nvidia.com>
Reviewed-by: Shahar Shitrit <shshitrit@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h |  5 +++--
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c | 17 +++++++++--------
 .../net/ethernet/mellanox/mlx5/core/en_main.c   | 15 +++++++++------
 3 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 4973fb473ff0..aa370227b7bc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -158,7 +158,7 @@ void mlx5e_destroy_flow_steering(struct mlx5e_flow_steering *fs, bool ntuple,
 
 struct mlx5e_flow_steering *mlx5e_fs_init(const struct mlx5e_profile *profile,
 					  struct mlx5_core_dev *mdev,
-					  bool state_destroy,
+					  bool rx_mode_active,
 					  struct dentry *dfs_root);
 void mlx5e_fs_cleanup(struct mlx5e_flow_steering *fs);
 struct mlx5e_vlan_table *mlx5e_fs_get_vlan(struct mlx5e_flow_steering *fs);
@@ -198,7 +198,8 @@ void mlx5e_fs_set_udp(struct mlx5e_flow_steering *fs, struct mlx5e_fs_udp *udp);
 struct mlx5e_accel_fs_tcp *mlx5e_fs_get_accel_tcp(struct mlx5e_flow_steering *fs);
 void mlx5e_fs_set_accel_tcp(struct mlx5e_flow_steering *fs, struct mlx5e_accel_fs_tcp *accel_tcp);
 #endif
-void mlx5e_fs_set_state_destroy(struct mlx5e_flow_steering *fs, bool state_destroy);
+void mlx5e_fs_set_rx_mode_active(struct mlx5e_flow_steering *fs,
+				 bool rx_mode_active);
 void mlx5e_fs_set_vlan_strip_disable(struct mlx5e_flow_steering *fs, bool vlan_strip_disable);
 
 struct mlx5_core_dev *mlx5e_fs_get_mdev(struct mlx5e_flow_steering *fs);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 12492c4a5d41..c19238bc821f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -44,7 +44,7 @@
 
 struct mlx5e_flow_steering {
 	struct work_struct		set_rx_mode_work;
-	bool				state_destroy;
+	bool				rx_mode_active;
 	bool				vlan_strip_disable;
 	struct mlx5_core_dev		*mdev;
 	struct mlx5_flow_namespace      *ns;
@@ -560,7 +560,7 @@ static void mlx5e_del_vlan_rules(struct mlx5e_flow_steering *fs)
 	for_each_set_bit(i, fs->vlan->active_svlans, VLAN_N_VID)
 		mlx5e_fs_del_vlan_rule(fs, MLX5E_VLAN_RULE_TYPE_MATCH_STAG_VID, i);
 
-	WARN_ON_ONCE(fs->state_destroy);
+	WARN_ON_ONCE(fs->rx_mode_active);
 
 	mlx5e_remove_vlan_trap(fs);
 
@@ -743,7 +743,7 @@ static void mlx5e_handle_netdev_addr(struct mlx5e_flow_steering *fs,
 	mlx5e_for_each_hash_node(hn, tmp, fs->l2.netdev_mc, i)
 		hn->action = MLX5E_ACTION_DEL;
 
-	if (fs->state_destroy)
+	if (fs->rx_mode_active)
 		mlx5e_sync_netdev_addr(fs, netdev, uc, mc);
 
 	mlx5e_apply_netdev_addr(fs);
@@ -840,7 +840,7 @@ void mlx5e_fs_set_rx_mode_work(struct mlx5e_flow_steering *fs,
 		goto update_vport_context;
 	}
 
-	bool rx_mode_enable  = fs->state_destroy;
+	bool rx_mode_enable    = fs->rx_mode_active;
 	bool promisc_enabled   = rx_mode_enable && (netdev->flags & IFF_PROMISC);
 	bool allmulti_enabled  = rx_mode_enable && (netdev->flags & IFF_ALLMULTI);
 	bool broadcast_enabled = rx_mode_enable;
@@ -1479,7 +1479,7 @@ static void mlx5e_fs_debugfs_init(struct mlx5e_flow_steering *fs,
 
 struct mlx5e_flow_steering *mlx5e_fs_init(const struct mlx5e_profile *profile,
 					  struct mlx5_core_dev *mdev,
-					  bool state_destroy,
+					  bool rx_mode_active,
 					  struct dentry *dfs_root)
 {
 	struct mlx5e_flow_steering *fs;
@@ -1490,7 +1490,7 @@ struct mlx5e_flow_steering *mlx5e_fs_init(const struct mlx5e_profile *profile,
 		goto err;
 
 	fs->mdev = mdev;
-	fs->state_destroy = state_destroy;
+	fs->rx_mode_active = rx_mode_active;
 	if (mlx5e_profile_feature_cap(profile, FS_VLAN)) {
 		err = mlx5e_fs_vlan_alloc(fs);
 		if (err)
@@ -1606,9 +1606,10 @@ void mlx5e_fs_set_accel_tcp(struct mlx5e_flow_steering *fs, struct mlx5e_accel_f
 }
 #endif
 
-void mlx5e_fs_set_state_destroy(struct mlx5e_flow_steering *fs, bool state_destroy)
+void mlx5e_fs_set_rx_mode_active(struct mlx5e_flow_steering *fs,
+				 bool rx_mode_active)
 {
-	fs->state_destroy = state_destroy;
+	fs->rx_mode_active = rx_mode_active;
 }
 
 void mlx5e_fs_set_vlan_strip_disable(struct mlx5e_flow_steering *fs,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index f90b5a34e097..478b5956044b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -6557,8 +6557,9 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 
 	clear_bit(MLX5E_STATE_DESTROYING, &priv->state);
 	if (priv->fs)
-		mlx5e_fs_set_state_destroy(priv->fs,
-					   !test_bit(MLX5E_STATE_DESTROYING, &priv->state));
+		mlx5e_fs_set_rx_mode_active(priv->fs,
+					    !test_bit(MLX5E_STATE_DESTROYING,
+						      &priv->state));
 
 	/* Validate the max_wqe_size_sq capability. */
 	if (WARN_ON_ONCE(mlx5e_get_max_sq_wqebbs(priv->mdev) < MLX5E_MAX_TX_WQEBBS)) {
@@ -6638,8 +6639,9 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 	mlx5e_reset_channels(priv->netdev);
 	set_bit(MLX5E_STATE_DESTROYING, &priv->state);
 	if (priv->fs)
-		mlx5e_fs_set_state_destroy(priv->fs,
-					   !test_bit(MLX5E_STATE_DESTROYING, &priv->state));
+		mlx5e_fs_set_rx_mode_active(priv->fs,
+					    !test_bit(MLX5E_STATE_DESTROYING,
+						      &priv->state));
 	cancel_work_sync(&priv->update_stats_work);
 	return err;
 }
@@ -6650,8 +6652,9 @@ void mlx5e_detach_netdev(struct mlx5e_priv *priv)
 
 	set_bit(MLX5E_STATE_DESTROYING, &priv->state);
 	if (priv->fs)
-		mlx5e_fs_set_state_destroy(priv->fs,
-					   !test_bit(MLX5E_STATE_DESTROYING, &priv->state));
+		mlx5e_fs_set_rx_mode_active(priv->fs,
+					    !test_bit(MLX5E_STATE_DESTROYING,
+						      &priv->state));
 
 	if (profile->disable)
 		profile->disable(priv);

base-commit: d8674294aefef02266c4d47ad10131f1bffbe534
-- 
2.44.0

