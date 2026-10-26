Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.60
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792999403;
	b=xCf9E3UbcMdEa9t27bgAi9XyrynwWk7u/X4fvHuQsGTFPCuwkWpaCq9nUJF+cIW6lcFV
	 eLM0CaMTbNYQnqYmaEm6/fUW718FL5rJ+serMttBFYZErNaajX9AkOYb0cX+3vAvfS+55
	 x8n8RMDFlgUOLCxpD7ZZu2LBAAZPhvURfZ8nOUPh9482NI+cxMuOcUyIb0ZzmWiarYFrM
	 5Agpf6QGU/EN0ACGDzynI9ckYT9IIY0BR1WStbuHIid1V/xcQVrClepPicHVXbaOK7/na
	 Ox7IYEeVJr1602Pe0uztQxStiQXEAfMX8gD4Z0RhfL8a6mcc4QzWpR0ms8zhvaib9PQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792999403;
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
	bh=uuE1ArneFpXLDtTfQxd6A1XkmVnzO2KlkwGSCjBX2tg=;
	b=R2HWhuMhzgDir6wbMuJScGmlviGUKDQDM3bBKbuv057/g1J4LydkbwDtREiNwnuhX3+0
	 ZKWhlu6+soMLQaNaDtBu/PKLwujgthbUP8MQLgS1gX7+TSATH9JFopL7EHo/iD0QA/fd3
	 9mRXyxFChJOtG3VI2yrv7kDXqulfolWjAjpvax1wS0fBvipiw/5joZYrpORst9WAb9Izg
	 QfllhKV2D+l7WyaXx1mRblc+VJROPGNNT+sp1xhw9H4g1Jp2ESFkAn101Tbjejk56b0M2
	 5w0P6yhkMyOhC5ZGGm7rt6DIdPLhj+iZ2HnkuMN9IT6Ey06xhGOde6hWrvkVM0rYZ6Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=S0Oc+ShL;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.60
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011060.outbound.protection.outlook.com [52.101.57.60])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66DBF606A31D;
	Mon, 26 Oct 2026 07:23:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 66DBF606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=S0Oc+ShL
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g4LMsf6rXDTnwyDLhpduMGRFxaKvs9rvqtB6Bt9OWCDRK2ZA97vEp/38fywvf39jLA8dX0DZzHuayOVrY4Pk5kwy6oU0z2ggut8/OayDKpH2Y/iGBOlvW32K34hzk7TuEwtXV2aVXhbFLEDLj83FWC4sunkYyVegTJyNdTVzT6Pgusuf9yTFm1dg/NW348ugHc818uwNN0hyIXT0vjQ5L0hnK/LROYEBGZaBlSPUqpw9Cjw7Q74sc7dx/lKWyX4E/+IAqQ1knIvuEba82PbGCqjGt27BJSBGFzJKL8m6CkEcLABkLmNcXzfHxFa5b8ur77k6r0lTFIF65SzL8ah7BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uuE1ArneFpXLDtTfQxd6A1XkmVnzO2KlkwGSCjBX2tg=;
 b=t26spGhZR4Le0NwDsx2mJDqy5xzrgDU0zjDqWwRrvYzFNOwun5fk/gt1QYsXWT6vnBJcRsOhFK63eNc2Ftefi9UD9q0LY7TV9+8R03fnrYi4zUTnWvqXT7BUqncJvhwsfui1lN7iBJvD26KN8hOBbgRT8QeOv6Zpe5XRsUOdvoxTH2kPKgc/eOE+n4jZwQFkVdLOhM//OnzVc8d1NrnBXwDo8CPZx0kvZ7c4a4HwvIUGWacscytf25PCqxT+I0cqDxlqgrmIKci6fRM6H0CSxIF3ChzW/WN8qoye5Xi07XFTwZFnZQsiVTLP/f7QQ6L1QY3LG/8AElWrB4iLReBAUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uuE1ArneFpXLDtTfQxd6A1XkmVnzO2KlkwGSCjBX2tg=;
 b=S0Oc+ShLFAXZBWCfHZXLCA66+eAw0CaHfkTJL34PKgztLhGzGaMpe8N+Czt9IyzILUdIyD3dYiBYcZNXSYfapdNbC5YeAmNjdCGN4NONCMVZgyHCsEiSXIwRa571lDUe8kpvxfclwxLiErTp5/CIzNfZXi4wQ1KrezOyqGuwIElHbB6SpP2saEVAuXNUnXFep1StHrWbuvbUjgPhxRDuku586+EUQEW5NJpn7JN9daP3KSsTwp60CChk7fGFFaKqbad2T0TOMxyrOC9vQOFBTy9YGkQ7P7BzcDcWxvyaoOxXQVB+OqW3FAJUls5eKnd2Id1Gerc3UdXqxvyAkIu2wg==
Received: from SJ0PR03CA0103.namprd03.prod.outlook.com (2603:10b6:a03:333::18)
 by SJ2PR12MB7942.namprd12.prod.outlook.com (2603:10b6:a03:4c3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 07:23:17 +0000
Received: from SJ1PEPF00002315.namprd03.prod.outlook.com
 (2603:10b6:a03:333:cafe::ab) by SJ0PR03CA0103.outlook.office365.com
 (2603:10b6:a03:333::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.546.22 via Frontend Transport; Mon,
 26 Oct 2026 07:23:16 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF00002315.mail.protection.outlook.com (10.167.242.169) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.4 via Frontend Transport; Mon, 26 Oct 2026 07:23:16 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 26 Oct
 2026 00:23:05 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 26 Oct 2026 00:23:04 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Mon, 26 Oct 2026 00:23:00 -0700
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
Subject: [PATCH net] net/mlx5e: Fix false WARN_ON_ONCE in flow steering cleanup during RX init failure
Date: Mon, 26 Oct 2026 09:22:53 +0200
Message-ID: <20261026072253.4118892-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002315:EE_|SJ2PR12MB7942:EE_
X-MS-Office365-Filtering-Correlation-Id: 7da5abff-bfc4-44d5-224b-08df333200c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|36860700016|82310400026|11063799006|56012099006|261009223027099003|261022105027099003|261021135927099003|261021123027099003|261021121427099003|10067099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	qyf1diQ7bE4HpMqWCxKfw3dnrnAU+HDofaehux8+pvl+xJKKLoV9xC/PvXOOUV0zmRvnvoqla7pV4PKcWARB8GkKWrSQro/BK9hN55uPQgj1Ub7qgSdO0ibADTLHnID1J6uNEJUqod7A3VduFiELGx6ehexPeTA62/TwTeUFsa3ndNMf9WLcnM3wWa2wzvxdoajTnNMwgHZrGRlZ+lIEuLoNnq+shf17QXSGCcSEDE+TFwhJfGKU9nUmSWDVo43vzFsXjJT6ufBLGeMhxAexajtFy7c1jQG6vNQgvXVc04lac9XvPWFz/1rMRK8BEmOKJY4lFM5lA8H4J8xRFR9G9TdOvW3FyvOWVWjl1ye65WakvgaOBXXJplmbp78rkAQOCVNaITmMSenjIBVK0OjIlDMFSPNF2N0NjEGCy7maQ9fXuE5RLbeUVPy7CRVkbTAUh+9y0ewrW59wQCXufJzFtmjR5HKeC6+sRdpB9lq3APbLofSwJpHjjfUuahRoeqDhlnno4IlycPjLaU0Ejja5787GPUQm8JM3ZwyOA6YUMVzbrS17uoFlaYdkz6bjbG1POGHqgsrr0AzXwgAfduFu6+7VC/SvI6504eSsCAmcaY+NuMZ+JCqt4AgjJT5js9VkrU0Q5Xy8VOv0jtrSTaURa4VYLbCLQKI1v6bQPcS+LZ8nmLttD7+7b3ntIMATpusRIwRJ1zTx01ARXiD8VAnQeA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(36860700016)(82310400026)(11063799006)(56012099006)(261009223027099003)(261022105027099003)(261021135927099003)(261021123027099003)(261021121427099003)(10067099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	tErc/LnRNWDb/wAjOQWfTZVe8E1ShCIowOjocuHRjM4wYzwrGrhpoV1pVnuy5HjwMY3h+dcjG15/e5tXAS6BRZqqgIo8W4YZS3S8SUy3lCLXV8CFuHUUJsK9g7bGvGCbrtioXKE/WwHVb4Uv4Aa5S2ZWv79MFJw+/G+74LrUc1YqugQf3lesaUAI2B2K005h04/5tGpJ7CyL9UetT9yQOjGk4r/7QjclIHbMYrsSboHzVGq6i7N5WFwb9L3Kry/kW2e9hI+4gyH0hr4YMuYw4on3u7qbiXAq8VOdu5urmSJu9XoMOfoVIuo0PR2qqPjDsIR00CEL+raapLRcQc0PM2AR5cBZrxPfpMD8tqnjJT6rYrhxV6FEMDdEOcfHRN6LbYNK9UrvO7Ot7hgp8v7hKiM3nWyB73Z08RCaLMU6Pjb5sxxG/rdthVoDIGoRtryi
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 07:23:16.3729
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7da5abff-bfc4-44d5-224b-08df333200c0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002315.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7942

From: Alexei Lazar <alazar@nvidia.com>

In mlx5e_init_nic_rx(), a failure subsequent to
mlx5e_create_flow_steering() initiates an error cleanup flow, where
mlx5e_destroy_flow_steering() calls mlx5e_del_vlan_rules() that contains
WARN_ON_ONCE(fs->state_destroy).
This warning fires because state_destroy is set before flow steering is
fully initialized.

To fix this, initialize NIC flow steering with state_destroy cleared,
and set state_destroy only after profile->init_rx() succeeds.
This keeps the flag cleared while mlx5e_create_flow_steering() is
building its tables, so its internal error paths can destroy partially
created flow steering without triggering the warning.

The flag is set in mlx5e_attach_netdev(), rather than in
mlx5e_init_nic_rx(), so non-NIC profiles such as representors also get
state_destroy set after a detach/attach cycle.

Previously, the 'out' label in mlx5e_attach_netdev() cleared
state_destroy on every attach failure. Now that the flag is only set
after init_rx() succeeds, the sole failure path that can observe it set
is profile->enable() failing. Handle it at err_cleanup_rx: clear
state_destroy so that cleanup_rx() can tear down flow steering without
triggering the warning, and cancel set_rx_mode_work, which enable() is
responsible for queueing, so the worker cannot run against flow steering
that is being destroyed.

Fixes: 8c7353b6f716 ("net/mlx5e: Fix VLAN cleanup flow")
Signed-off-by: Alexei Lazar <alazar@nvidia.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Shahar Shitrit <shshitrit@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 20 +++++++++----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 38ce7d0a9001..13409f6585ba 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -6039,9 +6039,7 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 	priv->dfs_root = debugfs_create_dir("nic",
 					    mlx5_debugfs_get_dev_root(mdev));
 
-	fs = mlx5e_fs_init(priv->profile, mdev,
-			   !test_bit(MLX5E_STATE_DESTROYING, &priv->state),
-			   priv->dfs_root);
+	fs = mlx5e_fs_init(priv->profile, mdev, false, priv->dfs_root);
 	if (!fs) {
 		err = -ENOMEM;
 		mlx5_core_err(mdev, "FS initialization failed, %d\n", err);
@@ -6556,9 +6554,6 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 	int err;
 
 	clear_bit(MLX5E_STATE_DESTROYING, &priv->state);
-	if (priv->fs)
-		mlx5e_fs_set_state_destroy(priv->fs,
-					   !test_bit(MLX5E_STATE_DESTROYING, &priv->state));
 
 	/* Validate the max_wqe_size_sq capability. */
 	if (WARN_ON_ONCE(mlx5e_get_max_sq_wqebbs(priv->mdev) < MLX5E_MAX_TX_WQEBBS)) {
@@ -6619,6 +6614,9 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 	if (err)
 		goto err_cleanup_tx;
 
+	if (priv->fs)
+		mlx5e_fs_set_state_destroy(priv->fs, true);
+
 	if (profile->enable) {
 		err = profile->enable(priv);
 		if (err)
@@ -6630,6 +6628,10 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 	return 0;
 
 err_cleanup_rx:
+	if (priv->fs) {
+		mlx5e_fs_set_state_destroy(priv->fs, false);
+		cancel_work_sync(&priv->set_rx_mode_work);
+	}
 	profile->cleanup_rx(priv);
 err_cleanup_tx:
 	profile->cleanup_tx(priv);
@@ -6637,9 +6639,6 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 out:
 	mlx5e_reset_channels(priv->netdev);
 	set_bit(MLX5E_STATE_DESTROYING, &priv->state);
-	if (priv->fs)
-		mlx5e_fs_set_state_destroy(priv->fs,
-					   !test_bit(MLX5E_STATE_DESTROYING, &priv->state));
 	cancel_work_sync(&priv->update_stats_work);
 	return err;
 }
@@ -6650,8 +6649,7 @@ void mlx5e_detach_netdev(struct mlx5e_priv *priv)
 
 	set_bit(MLX5E_STATE_DESTROYING, &priv->state);
 	if (priv->fs)
-		mlx5e_fs_set_state_destroy(priv->fs,
-					   !test_bit(MLX5E_STATE_DESTROYING, &priv->state));
+		mlx5e_fs_set_state_destroy(priv->fs, false);
 
 	if (profile->disable)
 		profile->disable(priv);

base-commit: f4377bf85887f57b59abb5479f7660a81ffe4449
-- 
2.44.0

