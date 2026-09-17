Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012050.outbound.protection.outlook.com [52.101.53.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339D94F93C4;
	Thu, 17 Sep 2026 18:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668678; cv=fail; b=Qpv7h/Luju/vYNkJO4cPP8s0OZkIOuShNJWTy2Vs4dIGr6rLztavO0NBKxNwQJ6m+bZRPGSRRsCmBjDJLVJLwRqQqhz8hamq5nHYIQlqJ7Z93/5CqeaXQJTWTlbRyFHYKkd6KQHiHt9yZ8/bkRhrCOI+2KB8w1o7uD9rajvdqzk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668678; c=relaxed/simple;
	bh=wRjnL6V9v3iKoWkgYcBRozar8i5dAVNoj+x0xmDE9aw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qc09nkcTmsvQ+JsChp5HBQmFHlOw/kyVz6cX61Dasm0PL8XW9eLVdW5+KfdbLB1gRg9tlHXG92dAevMzbK48Q9LaU7E8QCpCwD4ZePzoXeVwq5N7HRaE0x6l8YwfHSzZELCfYRKm10zy7IDLBxGWvEwh8ztd1VS1oN+9HfAbqMY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BPkwmgSv; arc=fail smtp.client-ip=52.101.53.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BPkwmgSv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YBdNv2IlK+i/rLLr7cyLsVl8zqeZE85R+aWlP48DmisgXbgbUpAR+vcg83GjHluw+wWSpvvaSQcgvMrHUOgFqRw2n0PQQVIFQ0a/aY3kUOmqnXSKUjnH8e4ThFb1NcfXVZS0+AARsC9iK7vmpu4RCCe8P+4XbOW7Ncq37i1hMoLZPdeDugWxQAZjTgRhkrpcrIgY+bx1s8uAfIdnoJmVdGBWqkAcXOxsMoXOHgC6qi413mduFwZcXeGtwnIFhe015IWifeJ4nD3wSHrbFnTZCxHvlHmoD+TOxP297vNOarTO4oykn3I5Ld/5LiFoWL5oKXSVFz70OuT7mEOj4U+NNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LvLXZunHvYl2GT7QyEqEC0eoCQqHBTtaPy291Z5VHyQ=;
 b=ULRjf+Uq9b3BRZ5DkVjbLbpNqgwPnLJMLNKdAvPAxV6gLQ6QuXH4WteTtUvGwFGyaniDYErEuYLd9/Quf0sQ/sHRVgppyS4AQVeIu9UwWlqyfrpVrYKNxXkgk6EAWrF//meCJCdGok+F1PhVAHEUI5lYA+gIlgRZL0tVKnudm4q2eHt2ERAQlpaiAN3u/GEY3JCu6EOyCeJJJtC6ZuXK7hU5gbbzlJdhbL+iMrvs3aock2KvR3Zlrs6GSWvaoUhuVI6rZD+EgP2+6UPYjgPIewitM0qDHY0NGDlKYskHpKWlT/2bK4Hhly3amGYiozA/rn0937syC1xwxmTuXHw+dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LvLXZunHvYl2GT7QyEqEC0eoCQqHBTtaPy291Z5VHyQ=;
 b=BPkwmgSvGnKST2mj7Cpxjf8+K4kVWEepW/61MfxYQWse35IZkpKYpYsZjTPwmnFipCDP1ael/j5nS7+u5PVtIsFTJLlJ2Wsfizv4Li3ePIto6iac485lCWzouKP5vbYzKqZS3CiVnOxt/8vfi7PbbaRmvWyFYXIMWYgM1rFB/bRs5fbONCo5l01xuZSwVj8cT+Q7C+kE5UUHrlxDs4sR5dxidYI0eY7inuWKFHbiRcUVLHjVYCjTGP6Y6s+WKLF6XgLy80JIuzmTf+lTFOCCgPQA7aBlAGMSYQH9hBv0aq9p0wk/XVJ1ZtBO9socrRMx5EvS21wQTMjMPpl8j6o1Hg==
Received: from CH0PR03CA0216.namprd03.prod.outlook.com (2603:10b6:610:e7::11)
 by IA0PR12MB8327.namprd12.prod.outlook.com (2603:10b6:208:40e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.12; Thu, 17 Sep
 2026 18:11:06 +0000
Received: from BL6PEPF00020E61.namprd04.prod.outlook.com
 (2603:10b6:610:e7:cafe::2e) by CH0PR03CA0216.outlook.office365.com
 (2603:10b6:610:e7::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.12 via Frontend Transport; Thu,
 17 Sep 2026 18:11:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF00020E61.mail.protection.outlook.com (10.167.249.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Thu, 17 Sep 2026 18:11:05 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 17 Sep
 2026 11:10:36 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 17 Sep
 2026 11:10:35 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Thu, 17
 Sep 2026 11:10:29 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>
CC: Boris Pismenny <borisp@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>,
	Dragos Tatulea <dtatulea@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>, "Gal
 Pressman" <gal@nvidia.com>, Jianbo Liu <jianbol@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Lior Nahmanson <liorna@nvidia.com>, Mark Bloch
	<mbloch@nvidia.com>, Parav Pandit <parav@nvidia.com>, Raed Salem
	<raeds@nvidia.com>, Rahul Rameshbabu <rrameshbabu@nvidia.com>, Roi Dayan
	<roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Steffen Klassert
	<steffen.klassert@secunet.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net 6/7] net/mlx5e: Serialize TC and IPsec offload exclusion counters
Date: Thu, 17 Sep 2026 20:54:32 +0300
Message-ID: <20260917175433.4090878-7-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260917175433.4090878-1-tariqt@nvidia.com>
References: <20260917175433.4090878-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E61:EE_|IA0PR12MB8327:EE_
X-MS-Office365-Filtering-Correlation-Id: b8ba8505-92a9-426e-f338-08df14e70aab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|376014|7416014|1800799024|56012099006|10067099003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	6GJlxSoq7MRJl7iRgEq0oaL443vvyn9ceUKXgh9tHOSwEn3JiGy5kM1sUUiuqaH9TbAqop6IHUH2imK++qevPBlkGGmgOHaR4VvhjcfGurY9AhpdBc73HIEm1idPVS9qb5S8MRabn7z2sZQFekQLczGSyeSL1blzDKvaOr/mWSv/dOBobEjRHpKXv/LjJi44SBpFzzz7DHQKq4WAaosjaSJc57s2NLkhzapcGl0MOmlYqaGPH+gAKEUULeF76tsmDtOaPBnfs9Xz3S4+KE2ptEYmvtwLFfHNdD6Vw51OmsYCrxm+ZYg3wdWLkxBye+6Qz1D1wGyp7Pl1ZMvPc0jMn62iPOU4+IBo22xiugbEkyNUlAB2LqZtO3f5jaQShvToidihns9Sdt/joRWSZ1/nCNQrBX97ZzoAiS1cl+0fSkJARt7WPPMIT7lgwUWe2ibTIm6xibJhoccmbGk4VT0434vtGODyc9u+WPcB/rOR90QrY8HeXuC0u0TSub5qBX3yFG0OUiA57EAsvK9odY7L+EkTZgzgoj0E3U0upj6t2T41GFHzB3WYKXCi/PF1/MOk3q6vYhbOBGu9ZPhCLuYZSBf5ZnNaCgqrD2T0s7eQLVXewktK+Pse5RpL3TELLEcCJbEqxv4B4d5fBu7l85wz6UR77lwSYi1Pz2etZ3liSqofycMNuaCm12rp/Fi72E2WEX3QL/9Y0oBv1w2BcyeiVg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(376014)(7416014)(1800799024)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ekK8epkDQbXR9py2GDULjTfjAi18uKvbs0BQAEx10IKcfif6SWMJqN6R8fMpmChAJSB8bUiPTKAGz9KprfJAhcIsjSc6EUFYmcuFZ3e8pdYorsI9tpxHb+G/cVx56HvA/NAV/VzSOLlZ5/Lx/EMMifbHxocSoljId5VECan7zp4vliT8NJARLwF1pN08zJViWKMzkvQR+o1vigHmE4J4zpxo+npHcWtEm8mI9pLBs5jHq5MS1pP37d22q4V6Kjnr6mQvrcUCK/RstaS7f1dUHq3SIRn5fywemFWS5wHUzVZWS309cecNol/cjcrIAQ7PHAV9O7I/C76RVTZBYGO28Hqspr/QRKcmhBB3D5mY61uHHSNqVgHFZivPyC1fMO+FJuy6ACjry26cTB63fNyXjlrlWY5MX4fP8QlNphc0xpJPj9UQjeJoxTpqqU8ptj5n
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 18:11:05.6939
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b8ba8505-92a9-426e-f338-08df14e70aab
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E61.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8327

From: Cosmin Ratiu <cratiu@nvidia.com>

The counters enforcing TC and IPsec packet offload mutual exclusion are
not consistently serialized. The IPsec add path conditionally takes the
eswitch write lock, but neither release path takes it. The TC add path
only holds the eswitch read lock, and devices without an eswitch cannot
rely on that lock at all.

Concurrent read-modify-write operations on the same counter can lose an
update. A stale nonzero count can keep rejecting offload requests after
the last user has gone, while an undercount can allow conflicting
offloads to coexist.

Move the counters into mdev->offload_block and protect all checks,
increments and decrements with a dedicated mutex. Keep the
opposing-counter check and reservation in the same critical section,
independent of eswitch availability. Initialize the lock for the core
device lifetime and add warnings for unbalanced releases. Remove the
now-unused mlx5_esw_lock() helper.

Fixes: c8e350e62fc5 ("net/mlx5e: Make TC and IPsec offloads mutually exclusive on a netdev")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 43 ++++++-------------
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 18 +++++---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 12 ------
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  1 -
 .../net/ethernet/mellanox/mlx5/core/main.c    |  3 ++
 include/linux/mlx5/driver.h                   |  7 ++-
 6 files changed, 32 insertions(+), 52 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 5c72656c623f..2b856d0db917 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -2574,45 +2574,26 @@ void mlx5e_accel_ipsec_fs_read_stats(struct mlx5e_priv *priv, void *ipsec_stats)
 	}
 }
 
-#ifdef CONFIG_MLX5_ESWITCH
 static int mlx5e_ipsec_block_tc_offload(struct mlx5_core_dev *mdev)
 {
-	struct mlx5_eswitch *esw = mdev->priv.eswitch;
-	int err = 0;
-
-	if (esw) {
-		err = mlx5_esw_lock(esw);
-		if (err)
-			return err;
-	}
-
-	if (mdev->num_block_ipsec) {
-		err = -EBUSY;
-		goto unlock;
-	}
+	int ret = 0;
 
-	mdev->num_block_tc++;
-
-unlock:
-	if (esw)
-		mlx5_esw_unlock(esw);
-
-	return err;
-}
-#else
-static int mlx5e_ipsec_block_tc_offload(struct mlx5_core_dev *mdev)
-{
-	if (mdev->num_block_ipsec)
-		return -EBUSY;
+	mutex_lock(&mdev->offload_block.lock);
+	if (mdev->offload_block.num_block_ipsec)
+		ret = -EBUSY;
+	else
+		mdev->offload_block.num_block_tc++;
+	mutex_unlock(&mdev->offload_block.lock);
 
-	mdev->num_block_tc++;
-	return 0;
+	return ret;
 }
-#endif
 
 static void mlx5e_ipsec_unblock_tc_offload(struct mlx5_core_dev *mdev)
 {
-	mdev->num_block_tc--;
+	mutex_lock(&mdev->offload_block.lock);
+	if (!WARN_ON_ONCE(!mdev->offload_block.num_block_tc))
+		mdev->offload_block.num_block_tc--;
+	mutex_unlock(&mdev->offload_block.lock);
 }
 
 int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 44fc421e7b8c..89463d18880c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4856,16 +4856,19 @@ static bool is_tc_ipsec_order_check_needed(struct net_device *filter, struct mlx
 static int mlx5e_tc_block_ipsec_offload(struct net_device *filter, struct mlx5e_priv *priv)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
+	int ret = 0;
 
 	if (!is_tc_ipsec_order_check_needed(filter, priv))
 		return 0;
 
-	if (mdev->num_block_tc)
-		return -EBUSY;
-
-	mdev->num_block_ipsec++;
+	mutex_lock(&mdev->offload_block.lock);
+	if (mdev->offload_block.num_block_tc)
+		ret = -EBUSY;
+	else
+		mdev->offload_block.num_block_ipsec++;
+	mutex_unlock(&mdev->offload_block.lock);
 
-	return 0;
+	return ret;
 }
 
 static void mlx5e_tc_unblock_ipsec_offload(struct net_device *filter, struct mlx5e_priv *priv)
@@ -4873,7 +4876,10 @@ static void mlx5e_tc_unblock_ipsec_offload(struct net_device *filter, struct mlx
 	if (!is_tc_ipsec_order_check_needed(filter, priv))
 		return;
 
-	priv->mdev->num_block_ipsec--;
+	mutex_lock(&priv->mdev->offload_block.lock);
+	if (!WARN_ON_ONCE(!priv->mdev->offload_block.num_block_ipsec))
+		priv->mdev->offload_block.num_block_ipsec--;
+	mutex_unlock(&priv->mdev->offload_block.lock);
 }
 
 int mlx5e_configure_flower(struct net_device *dev, struct mlx5e_priv *priv,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 0b48cc7a6734..989ca26e8851 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -3028,18 +3028,6 @@ int mlx5_esw_try_lock(struct mlx5_eswitch *esw, bool check_users)
 	return esw->mode;
 }
 
-int mlx5_esw_lock(struct mlx5_eswitch *esw)
-{
-	down_write(&esw->mode_lock);
-
-	if (esw->eswitch_operation_in_progress) {
-		up_write(&esw->mode_lock);
-		return -EBUSY;
-	}
-
-	return 0;
-}
-
 /**
  * mlx5_esw_unlock() - Release write lock on esw mode lock
  * @esw: eswitch device.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 4a9a1656f6db..d52146cff496 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -947,7 +947,6 @@ void mlx5_esw_release(struct mlx5_core_dev *dev);
 void mlx5_esw_get(struct mlx5_core_dev *dev);
 void mlx5_esw_put(struct mlx5_core_dev *dev);
 int mlx5_esw_try_lock(struct mlx5_eswitch *esw, bool check_users);
-int mlx5_esw_lock(struct mlx5_eswitch *esw);
 void mlx5_esw_unlock(struct mlx5_eswitch *esw);
 
 void esw_vport_change_handle_locked(struct mlx5_vport *vport);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 5f28d906c35b..46b34c80c458 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1810,6 +1810,7 @@ int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 	lockdep_register_key(&dev->lock_key);
 	mutex_init(&dev->intf_state_mutex);
 	lockdep_set_class(&dev->intf_state_mutex, &dev->lock_key);
+	mutex_init(&dev->offload_block.lock);
 	mutex_init(&dev->mlx5e_res.uplink_netdev_lock);
 	mutex_init(&dev->wc_state_lock);
 
@@ -1901,6 +1902,7 @@ int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 	mutex_destroy(&priv->alloc_mutex);
 	mutex_destroy(&priv->bfregs.wc_head.lock);
 	mutex_destroy(&priv->bfregs.reg_head.lock);
+	mutex_destroy(&dev->offload_block.lock);
 	mutex_destroy(&dev->intf_state_mutex);
 	lockdep_unregister_key(&dev->lock_key);
 	return err;
@@ -1928,6 +1930,7 @@ void mlx5_mdev_uninit(struct mlx5_core_dev *dev)
 	mutex_destroy(&priv->bfregs.reg_head.lock);
 	mutex_destroy(&dev->wc_state_lock);
 	mutex_destroy(&dev->mlx5e_res.uplink_netdev_lock);
+	mutex_destroy(&dev->offload_block.lock);
 	mutex_destroy(&dev->intf_state_mutex);
 	lockdep_unregister_key(&dev->lock_key);
 }
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 83d0a83bbfbc..4e207bf49c31 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -788,8 +788,11 @@ struct mlx5_core_dev {
 	u32                      vsc_addr;
 	struct mlx5_hv_vhca	*hv_vhca;
 	struct mlx5_hwmon	*hwmon;
-	u64			num_block_tc;
-	u64			num_block_ipsec;
+	struct {
+		struct mutex lock;
+		u64 num_block_tc;
+		u64 num_block_ipsec;
+	} offload_block;
 #ifdef CONFIG_MLX5_MACSEC
 	struct mlx5_macsec_fs *macsec_fs;
 	/* MACsec notifier chain to sync MACsec core and IB database */
-- 
2.44.0

