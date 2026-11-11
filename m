Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794385340;
	b=SuM86PxDK8FNQyJ8ovrY8IyDLwTtEVuoq7oR2TXf88Znk3Vos4/fEKnVrMpigLMMjvvV
	 K6+Zbk1zjxVarrXfiU77OubDSzWqlX2yF8Y1bPzUAARvC7rgX4FdmpJpksQ+e2IhVYaRc
	 ku1vWOEJQtOphY8llvB4JOqagzKP6rnsguDtPPOJwnYqhESyrBB4+q8TkOXYDPnUIFJXh
	 Txw/aD28CupGgAnQ+KYBoBWmvRpI7+Ff8l2zEic+nfj7olapaEG7PwdYF/mEANxZuTFwO
	 rUy0a3VhwT8yzJWOZecCJwOgcPDnFieZaMcl0B80nGK9wosra2l4ZpBAo+yRv3alqRw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794385340;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-NV-OnPremToCloud:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=J6jKtpIMEwkzAh4ulzxgCC1DTSspzp0JCP5DYjkRj0A=;
	b=zC0fcpZ2N84heZrFGKZ+mmNjOT7jLY9eyMUyZrY9o7+kmq3s2wb9KFObLalQLSP8UW50
	 0pbGMwhoHY4yIzNUkcsU0WTmybdhWnt85ReU0VovX7qBMhIG6fVrUeCRyKE+YYwKt2fpH
	 a1UvI0FduUEfjygJ2ensgSyVHqjsBtXwAhT3xZJannuNj1IPdvyZk+oLhV+P1Sy/x+8NC
	 XHw1LCCsPCf97UsDkNtKTr5gdM2fSTJNCvJdeq8cIQ5DBAL+WlrCeZdxLgidQ4CsBEnhR
	 xPiLatLr/Nfw6V4p6yX3ysdRuOWvQw+mx0tZdTBIc0VLVAcKe7Mj4GLNhUUmFcPSUiQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=h9u2Ltew;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.51
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013051.outbound.protection.outlook.com [40.93.201.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB279606A32E;
	Wed, 11 Nov 2026 08:22:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB279606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=h9u2Ltew
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=huTZ/aiFyjfK5igNyyJ7JC4EvFtM+TPKu8l4ng4SayP+rc5lt0cvhCluzTJToq3FCXGIuY2NUXwK+8muYz0VvJ7s0NO/1Mi2nm/q8+ADhhZoLsMPbILWuEXDw+CCzk+D74JvRmmuG4JDxbHA+J0mMqnYN+d89IoCK7oLZBGFLEZyesWG7dRXJMG68khnCUwJcQB9VTz2tO7ImU9r4Q+ag+dhAzuhIAeVOdbfHQiqDpNu3A7AMqXfT+hYnE5xd5lKdfXEoXIGjnzyfRGd1drCUL5P00n45OwjsqbEcw4P2tjEkrSUrCcmuH66eZLPmDYy59FQNTju6q2USBIGUmxcJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J6jKtpIMEwkzAh4ulzxgCC1DTSspzp0JCP5DYjkRj0A=;
 b=YxcYeyvT58wy9k/mJlU5mSHsWQKGeSZO/Ks1P1Hi6QqzgaCaEKlHeU71jfZQsAh4fqnY7IOlluGbU/uvoj3ThfSwyP/eIBanfLCzOUQXJqXX8PMvhkXhMm/eMMhMnLcRhUs6serEb3VwgU9Z2l/ohfR9GGYh/e/sP9c32bws/ecmHlJmhotrrnudAuDAg7NUev+9t4C3rCayVLMlYorW9SBTKf2+1G73XxTd7XRLvhF+R5aORmOHaAxjxcw1ky5AHuxti9kf0MQ/HDJVhkvb0jQebEykclDGcqnK8jBcvyZPgwwiKH4aGlJyu4aJAYdxz6FyCgSFN4U2UxruqrqB2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J6jKtpIMEwkzAh4ulzxgCC1DTSspzp0JCP5DYjkRj0A=;
 b=h9u2LtewbJteLIXwGeXjh1WFiVdpkojfJSamWLGJLX/DdtOPrlc6KDO/LSdO9h+pBu2arnWdIjpIPDiTHgjuCJl9AH+r+2tLrfxgMgLxLsojmhtdjVhqX9vv+ToxF7ppkGkSVwfcwvg7Hk+gEeaG+gGP9uGG3TM0ckEzM6sRh71txVICChKjo8isuZgYCDWb7S8p9NYRqsFb2nttdo16BHEKOs8Asa7c86l3DjoV+47Gf2SfgRsU8R5x5NKIsKtnoVf3WXyHekKaTqwMTgf2yGnICa24asQ4Hd6g/X1mOTHm5KHoiiwdwx/ykqNyUhFdtF94TaJyUEVxt33pJ5DiQQ==
Received: from MN2PR22CA0022.namprd22.prod.outlook.com (2603:10b6:208:238::27)
 by DS4PR12MB999077.namprd12.prod.outlook.com (2603:10b6:8:2f9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Wed, 11 Nov
 2026 08:22:14 +0000
Received: from BN1PEPF00018074.namprd04.prod.outlook.com
 (2603:10b6:208:238:cafe::3) by MN2PR22CA0022.outlook.office365.com
 (2603:10b6:208:238::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.9 via Frontend Transport; Wed, 11
 Nov 2026 08:22:14 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN1PEPF00018074.mail.protection.outlook.com (10.167.245.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Wed, 11 Nov 2026 08:22:14 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Wed, 11 Nov
 2026 00:22:03 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Wed, 11 Nov
 2026 00:22:02 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Wed, 11
 Nov 2026 00:21:58 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Alexei Lazar <alazar@nvidia.com>, Aya Levin <ayal@nvidia.com>, "Gal
 Pressman" <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shahar Shitrit <shshitrit@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net V2] net/mlx5e: Fix false WARN_ON_ONCE in flow steering cleanup on RX init failure
Date: Wed, 11 Nov 2026 10:21:42 +0200
Message-ID: <20261111082142.3131746-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00018074:EE_|DS4PR12MB999077:EE_
X-MS-Office365-Filtering-Correlation-Id: 40b13b3b-e87a-46f1-eb49-08df3fcce436
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|82310400026|36860700016|10067099003|11063799006|56012099006|261022105027099003|261021123027099003|261021121427099003|261021135927099003|261026140227099003|261028144727099003|261102123227099003|261009223027099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	9AUMqrc5ASqSU2mbHnZUgjhnS4Ed49CjdGBKPvkjajrlKulGgkEQmYu7B/qjy0MWEK53pDEuUaTABnMMQFe6eW5+/xop7LbPB0DN9Cy9PMR+yyY3Om3SAVis4W8l9mdnJTE3Cd4M26zPpuoIfhZUTpq9EeZE/bd+UI51acopI+F+Vx3sdDM5h3ijihAYrwnGxOCcE9+Ep42QE5OyCoKGnYesE7NjrmCV5ZAQTxBINn9Adz6HKbpX0yT+c1xKR8XmHHzN3QjPzXCi7QZvx9dGZ3pDHQsyzeD7oyMgvuZMxDUNwNdFMieIXUAzO9kR2UxHVOKMbCiMw2ChuoN7Zk4dqd/LVay9cBsXzNoho/FAWYjcIqsOGwH6OPbLRmg/2qc6i7TCUM3KXNUjmU/Mot1LWCr9JlLhj/FSyIDphuU6sis6zxVBw9NhBjoHhqSGJErjNqAzLM4B1oO0EYoHJr/11RykB4YgP6veAZMXngp5bghB0qHtHpG/PvQVxX+v2S6qUdFIRVw++0HhZwuZwsJJYErWke9JROpve2LZ41NHEAnkv4hpMKV1P6gzdlEeleCnyadnZppYmWwzesXh3SBN89rptNmVMKyQ2OPVRS1l5aIDNZ+7gjyvf/3AHVC+9cTrfVZ/mGQ20DhvuDQvYx7iR9Xc80VrUPKFnoD5IbouG3+vJ47j22fKmA8mE7zb1q/GxUdcpxZjlpOTLuNQVYcC3A==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(82310400026)(36860700016)(10067099003)(11063799006)(56012099006)(261022105027099003)(261021123027099003)(261021121427099003)(261021135927099003)(261026140227099003)(261028144727099003)(261102123227099003)(261009223027099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	JiHhw2kUhxi8HnqgUm40F5v8flkLNkgBibIMk7+FugQAXTXuRHwPsxTVPUxIVFWW0JZdya8ZOw5MY4cs2F7jADM+sWw8UsR18Uiy1tins/3heypd0fLYHxgUGexftsMnDqLptDHt/MTQoSG313NZs2Es+b6492HMlWSH/qUpORtrn5BPL9YwneikgnmFKLn7N3BL6uFU2RygE88cmK1OuxBAW1868M/x2i5dgVXVYQQ+3qvJXwAWbHWld/E7LuuIs899Q3nBNw9gpyKjUZV5MwpOILVNZHKRs7hKKMfxgXY/W7x98z5SkMvPtZim/g9idU67Ily6+KXTDHOaOgFiY+n82iai70Ydfi5U1go6MIWnFFU6vVOJNw1eJVuU9zuK3WbjeIl313rPLeAcS+S27c1gXNjb4XHHnrabpqOEMOF/cHjzWVh0KZ5qDjhkyBOi
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2026 08:22:14.2911
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 40b13b3b-e87a-46f1-eb49-08df3fcce436
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00018074.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB999077

From: Alexei Lazar <alazar@nvidia.com>

mlx5e_attach_netdev() sets rx_mode_active before calling init_rx(), so
any init_rx() failure after mlx5e_create_flow_steering() has succeeded
makes mlx5e_destroy_flow_steering() trip
WARN_ON_ONCE(fs->rx_mode_active) in mlx5e_del_vlan_rules().

Hit in internal regression testing, so kthread creation failed
with -EINTR:

  WARNING: CPU: 3 PID: 170 at drivers/net/ethernet/mellanox/mlx5/core/en_fs.c:564 mlx5e_del_vlan_rules+0x295/0x2b0 [mlx5_core]
  mlx5e_destroy_flow_steering+0x34/0xc0 [mlx5_core]
  mlx5e_init_nic_rx+0x137/0x200 [mlx5_core]
  mlx5e_attach_netdev+0x105/0x360 [mlx5_core]

Fix it by creating NIC flow steering with rx_mode_active cleared and
setting it only after profile->init_rx() succeeds. This also lets the
internal error paths of mlx5e_create_flow_steering() destroy partially
created steering without warning. The flag is set in
mlx5e_attach_netdev() rather than mlx5e_init_nic_rx() so that non-NIC
profiles, such as representors, also get it set after a detach/attach
cycle.

Fixes: 8c7353b6f716 ("net/mlx5e: Fix VLAN cleanup flow")
Signed-off-by: Alexei Lazar <alazar@nvidia.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Shahar Shitrit <shshitrit@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 23 ++++++++-----------
 1 file changed, 9 insertions(+), 14 deletions(-)

V2:
- Rebased.
- Updated commit message.

V1:
https://lore.kernel.org/all/20261026072253.4118892-1-tariqt@nvidia.com/

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 72bca10c579d..990d2fa6a914 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -6041,9 +6041,7 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 	priv->dfs_root = debugfs_create_dir("nic",
 					    mlx5_debugfs_get_dev_root(mdev));
 
-	fs = mlx5e_fs_init(priv->profile, mdev,
-			   !test_bit(MLX5E_STATE_DESTROYING, &priv->state),
-			   priv->dfs_root);
+	fs = mlx5e_fs_init(priv->profile, mdev, false, priv->dfs_root);
 	if (!fs) {
 		err = -ENOMEM;
 		mlx5_core_err(mdev, "FS initialization failed, %d\n", err);
@@ -6558,10 +6556,6 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 	int err;
 
 	clear_bit(MLX5E_STATE_DESTROYING, &priv->state);
-	if (priv->fs)
-		mlx5e_fs_set_rx_mode_active(priv->fs,
-					    !test_bit(MLX5E_STATE_DESTROYING,
-						      &priv->state));
 
 	/* Validate the max_wqe_size_sq capability. */
 	if (WARN_ON_ONCE(mlx5e_get_max_sq_wqebbs(priv->mdev) < MLX5E_MAX_TX_WQEBBS)) {
@@ -6622,6 +6616,9 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 	if (err)
 		goto err_cleanup_tx;
 
+	if (priv->fs)
+		mlx5e_fs_set_rx_mode_active(priv->fs, true);
+
 	if (profile->enable) {
 		err = profile->enable(priv);
 		if (err)
@@ -6633,6 +6630,10 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 	return 0;
 
 err_cleanup_rx:
+	if (priv->fs) {
+		mlx5e_fs_set_rx_mode_active(priv->fs, false);
+		cancel_work_sync(&priv->set_rx_mode_work);
+	}
 	profile->cleanup_rx(priv);
 err_cleanup_tx:
 	profile->cleanup_tx(priv);
@@ -6640,10 +6641,6 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 out:
 	mlx5e_reset_channels(priv->netdev);
 	set_bit(MLX5E_STATE_DESTROYING, &priv->state);
-	if (priv->fs)
-		mlx5e_fs_set_rx_mode_active(priv->fs,
-					    !test_bit(MLX5E_STATE_DESTROYING,
-						      &priv->state));
 	cancel_work_sync(&priv->update_stats_work);
 	return err;
 }
@@ -6654,9 +6651,7 @@ void mlx5e_detach_netdev(struct mlx5e_priv *priv)
 
 	set_bit(MLX5E_STATE_DESTROYING, &priv->state);
 	if (priv->fs)
-		mlx5e_fs_set_rx_mode_active(priv->fs,
-					    !test_bit(MLX5E_STATE_DESTROYING,
-						      &priv->state));
+		mlx5e_fs_set_rx_mode_active(priv->fs, false);
 
 	if (profile->disable)
 		profile->disable(priv);

base-commit: b71c101bbb9814d163c00234d43c41f0a17907d4
-- 
2.44.0

