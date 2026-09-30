Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011030.outbound.protection.outlook.com [52.101.52.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85BCA4BA1E8;
	Wed, 30 Sep 2026 12:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790770363; cv=fail; b=UYIjyUCfwFKgs2OQvi3hVdyHYCxvaHUQntXQdGdrsS8fUpUh87rga7tkMZVhyeQfvouSEgjePMQZymDqsn57sXKJnkyqCo0GPYrkdGha6CkSzIUZyJ+w0SaVHU3Yjai02HdW9sMQDizAVFhBQIq+9zxeh5ED8VNVNb4WHxLVm9k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790770363; c=relaxed/simple;
	bh=mnEal1NrJJO60ro1WX9zcfPXv6m+c3/H8e/rSasyalA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lPL2zmT4Yx8yVxJ8hGk1R0Y29deQH7sxqmudmu5roKe1XWpPaCvfjigSsOre/VW77whXBdXK7077p2wU87ocvOg+RXqXaLE25bCqoOIGRYVf01iZlfRNRsqeF+GfhFJGQQnXn4eT/iRTxoQ3Ag9FwD1RIXX76KDk50QXdCDfncA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HXxc+aHf; arc=fail smtp.client-ip=52.101.52.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HXxc+aHf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aken6if7HkWkTozq1K7haTu1BuMFuIJJKUufB3a0Z+PQ2tReWcnp4Al5NlNITcrrfsHaIwkrrN6mbJQi5EJ8J6JgCFyTm0+nEz44xtYV9WuObMdUjk9kkNiBywBc5itfWyrsGp3dP6KDO+dJKsio0xEMkbBRw1leCU44gDUm9ZdU/fe8X4Pz5JfljuR+BJWDFyQF3Q7LfF3+u6UQH3Ogmpfz1K5wZk1FJyCCIHWGuWCUYI3YdVwoj6iYzq8UvzbmqVemdxWhya6KcbK2BIrHV3iGU7baT/iklicPb650WM2k9kFbjs3SysRVqaIwng7QivNvyPEf6J98dHSMfmSuHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0TfS5K26TcCZIDNFimJb/q26rCG8sMqrh/NBmwdhtJU=;
 b=rc2640wNI6Cu9nyVSJiauQw/zwl2bE7EDMK7dNuTPO8ovLFTLfYNTNmmnetKl5wzW2G+1EiAO0ynOJloLMgNRTDm4cKYFZ95LnWM4BI8KXxP+K9Hy4ZGBx7wfA/IFsrzwzqnKuRUuovsWeTMxgyD0N3AfxnV16ImYynnGEbQlxF75Xo5OAEmt9V52+Q29iPZVLf+c3T9Q+yCDS/sIYSSEkWkGyXLiaFy8UfAmZXFrEw+9gczayHTr9O016X/+U7WO5CDffW+90c4CMj0vnV8to44npwsJL2UkERqSOJsioNJxot5LkyCO6d5MUb5WALxKMDAzqdGbvgXtUpW9PYQ6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0TfS5K26TcCZIDNFimJb/q26rCG8sMqrh/NBmwdhtJU=;
 b=HXxc+aHfQhTLtlM9IHDdbljXvssvr3gief+PTFquzKfGiIxl3NrJkZSnTL32bBs8lmA1z+0t4D8UpHgyHtcfFWz782Fz6NMW329r3XFESMQMO4672DfRc1idWsxzGewRoofCYTr4ElXKXyTx06yPBlz/zjinw565uf4iE3dWXMirUervdUwXg5r3PjQTRq1dM9nQc5oupI1rsEd0+fWTuGjy+5+B6PrsLOG74vNZMnLl765FWI9WeJug9tS6ON+oiRsdjgX8mk3snFstJF9Ca5BxxxPKuw2fCLujKQRQlAXSZ2HKqgkA8X/P6rdjop+JT/4izJZQTw+rDThTT5poeQ==
Received: from BN9PR03CA0100.namprd03.prod.outlook.com (2603:10b6:408:fd::15)
 by BY5PR12MB4050.namprd12.prod.outlook.com (2603:10b6:a03:207::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.16; Wed, 30 Sep
 2026 12:12:29 +0000
Received: from BN3PEPF00022BD1.namprd03.prod.outlook.com
 (2603:10b6:408:fd:cafe::7c) by BN9PR03CA0100.outlook.office365.com
 (2603:10b6:408:fd::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.16 via Frontend Transport; Wed,
 30 Sep 2026 12:12:29 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN3PEPF00022BD1.mail.protection.outlook.com (10.167.248.171) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 12:12:28 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 30 Sep
 2026 05:12:07 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 30 Sep 2026 05:12:07 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Wed, 30 Sep 2026 05:12:01 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Andrea Parri <parri.andrea@gmail.com>, Boris Pismenny <borisp@nvidia.com>,
	Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>, Fernando Fernandez Mancera
	<fmancera@suse.de>, Gal Pressman <gal@nvidia.com>, Jianbo Liu
	<jianbol@nvidia.com>, Kees Cook <kees@kernel.org>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Parav Pandit
	<parav@nvidia.com>, Patrisious Haddad <phaddad@nvidia.com>, Raed Salem
	<raeds@nvidia.com>, Roi Dayan <roid@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Steffen Klassert <steffen.klassert@secunet.com>, "Tariq
 Toukan" <tariqt@nvidia.com>
Subject: [PATCH net V2 3/4] net/mlx5e: Serialize TC and IPsec offload exclusion counters
Date: Wed, 30 Sep 2026 15:11:18 +0300
Message-ID: <20260930121119.141953-4-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260930121119.141953-1-tariqt@nvidia.com>
References: <20260930121119.141953-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BD1:EE_|BY5PR12MB4050:EE_
X-MS-Office365-Filtering-Correlation-Id: 809b58c1-3c1e-4d2c-888f-08df1eec18ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|82310400026|36860700016|18002099003|22082099003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	yT7a8zuMPIfazFDpMrL5Ut8SHkmUTEzhRIyQDn/7lhBo86jRTqb2J8Cujux6UAcyXvVYGTXgUCE3rB46NU3Omnu1aoOheQHlLuTsqHZErBKSiFCzDCqcUHTKSTLVcU1AMvKbDqaUU7QyJmvIRJ8LeBThsEGLizhfRZ/BZ3AVltRgWFhZHUHMPlfmylu8VCX6OeFv7bkB0s39U33xaXSXZsEddJ7wrlasla8QDdsLZit8iU1TmpAkIYCdQ1TlWAp2wuXX54zjKXntxTheC+NTB35rvZ7fX0iO1j1+jbRj8ONOT82fMAdtDtUnIg+qb7YOOOOKh+o9yeY8mnDp35fdubD+5G/61b6p5qWaXiwynUbnV3Mwwc4p64181+esFm0RBTtcnviM9jQ5avwsuh34xYV3dSQfJXrkNOQzn7Xf7/DMBeB4ypp0atZB5vGsdIkRcd5Jsmz3FFhsrB3AZTV3IIaU3LebiBC3gHwSPeriGqSrsdZm+lW4n6hWpp7y1nLHS9FVKySSLBGDaP9PWkaNsJSeU6uuNdD/PPt6T3sIaTHjbEejWQw/42FdRPM6LxYut/OZztj1VJEKsR0xVIi7f7m/Y02bKNuTZIwsNKe7hQVzX5qK1gW+2dXRu/elym71oT0CvBknlA8ABF1NvELBxCMOvSMKN/YbvXnw4CReTHyQSNnO+V/axJpzUKSeUg97CjZeTVXt0q1/QYf//C1gAw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(82310400026)(36860700016)(18002099003)(22082099003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	hYNAR7/TwTAGvUj9u8knIcPwnOSFPAuQuC5fCAa4HoqsU6S6XFhLpFMlhJMn1wG9AOHvwdGnOyYWGUA6F9txS0YhcqWVKL999ljT3xGeGpocuwQlhZYxNlfQw2N+6VBkhSqEXKpVCs+yfwdK8mkxEV327BcxQwlQSrj/6JTzzPKDbjL6DzKOJRGXPIiBpVQdZDJv5WyqOJtl0MAHgz0BMJZdTICkOR9J6F3ZHuA58CAPY2/PsyVigZhwLJFSNUkB/VaemFL1NMWESeoenYe6z91XXxfnNnSm38pypVUV6vaYAUVEbn7D/vFzNFHUL+OmuL+A2Fg3CKr3426KhpWJi/4LKELj7bx3YSn6pu7Zs6DQ+X1ULhSFeR31ZNRingMhuZdo+AoOvaVUtmW86Vy0c9B9PyljDbus5YqjeqmTuGqrBseye8PvUAoXwr+ha7GR
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 12:12:28.2994
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 809b58c1-3c1e-4d2c-888f-08df1eec18ab
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BD1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4050

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
device lifetime and add warnings for unbalanced releases.

Fixes: c8e350e62fc5 ("net/mlx5e: Make TC and IPsec offloads mutually exclusive on a netdev")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 43 ++++++-------------
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 18 +++++---
 .../net/ethernet/mellanox/mlx5/core/main.c    |  3 ++
 include/linux/mlx5/driver.h                   |  7 ++-
 4 files changed, 32 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index cd7ff3613524..1a4145d039ea 100644
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
-		err = mlx5_esw_lock(esw, false);
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
index b290beb4369a..3d2850e2d76e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4833,16 +4833,19 @@ static bool is_tc_ipsec_order_check_needed(struct net_device *filter, struct mlx
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
@@ -4850,7 +4853,10 @@ static void mlx5e_tc_unblock_ipsec_offload(struct net_device *filter, struct mlx
 	if (!is_tc_ipsec_order_check_needed(filter, priv))
 		return;
 
-	priv->mdev->num_block_ipsec--;
+	mutex_lock(&priv->mdev->offload_block.lock);
+	if (!WARN_ON_ONCE(!priv->mdev->offload_block.num_block_ipsec))
+		priv->mdev->offload_block.num_block_ipsec--;
+	mutex_unlock(&priv->mdev->offload_block.lock);
 }
 
 int mlx5e_configure_flower(struct net_device *dev, struct mlx5e_priv *priv,
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

