Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010056.outbound.protection.outlook.com [52.101.56.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBD84CC63E;
	Wed, 30 Sep 2026 12:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790770349; cv=fail; b=s6UjJK+T9kq6mmjdtDf5JtXIvw+apnyJ8gei78aI1YRFuJOFN1ncmTx6HZObC3nSt32DElWawOi6+H1kOGki1fFp5xFMLucZ6ibEBny6wKcA7DyLiXEdJpaZnf1LGpSo+t0VGqyAxz9uf9Ua8Lf1OA8dwgy+zih+JndwahwYK04=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790770349; c=relaxed/simple;
	bh=CF7inB5FRvO66Zfw/JfiUZ7h0aB/D43WXJ+9BLA8SeA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kG9NgE7jSgPWjXLX16T2XKC2/9U4bLeaRzdZySD3hIwDYyH0nO3ZrJhBlplUs3B78FzBySyy7sVUQsMVtHV/AXOuvpCp+HFVvQbdAgiqx5An6JVs/G7S3cVGUGygwgUn+igpgavkY/IY4OIxCkFV34twfkSbEQdZdnxzWT3i7Jg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BhiOts4z; arc=fail smtp.client-ip=52.101.56.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BhiOts4z"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XiBZgjlnxAtULO6g2XYGBycrLrLwhrJnff6HFYPZ907PnTPrZ7clfPREE+feY8LmrUC975UEXauCzgWG0yzRb3Xw5K/sqmYTW6c71O5jaGwxXKQV+2nO+YuCqkAwEAFvJ69ZppBNMVbzh4VFtP+ovZ5ATmeKgtuDFrGcTd30xUFosfRmFTnW8MRtbP5dHStXNLmUR0NE2QJpQCS//6XT9ENDbb1lx0da0ZbkqGlhAPMRFeMOuE+6xGgFnytS09gU1gP43sTz4hJH7p7OpbK2txZzLK9aOVfkjyAPF2zfk9+IIEE0hG0wMULgII31BZgAy+Rp2OoYHejYFTa6dzSggA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TALVe84Udk1M+qTFnk8wvuMnK32ttAeUqJ4wFlcM2Ps=;
 b=K3SXZCKneWq9P5TibWFz6g6r23SlkbHS64ApU4LIhUk0CCf9led7i71Tmxhjs7BD7ciHb9INU7j5/ZGk5k2BfNos1JWyLeja1CQRaIL53TrACJS32cq55m4PJfGECgKrOHSo/7ilUDJJWdzVCJR/nlTPIAMvPwSTFD0SySF+EBPQ/iSQ6mhQ5joDTCC64lceqC0IGqsXGc0gByB9Cz95vWYLDVXU/vOiiL5LU34Ks8DnPXtKlnQIsPsMsGFa9lWP1oSrAV8Ensmyb0GgiWCbDqxw6MUvYUxKRDpLScBvrvujssCZta68Q16PawT3/dOR4KQOGZAYubvm+Aunrgh/Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TALVe84Udk1M+qTFnk8wvuMnK32ttAeUqJ4wFlcM2Ps=;
 b=BhiOts4zN5AOIkPatgSYAfqR82swJ+Vqoymyqv3dD7YPO+z0ca7Z6abNBbTAWetDSG2ASN9O6px1G4Wl8CkF0UfxPUj8cgZvjSzGN1QQD21ETd+8waZgQ5l/74AVso5kp+J2o2etvFzQ4xaK7s1nIzg8EJwQhkCamtHbOCRrYUiermXxYLDS7WmdOaV5XVdCE3s2ssqDV7A7UIn1YChtXDUPPG9H4qy1ncDkyWnMpPr4QwdtYX+TxOQ6zcisrvvn9IIbhsKgit88Gi36AXkmzx2ySKTqrJAA6FWU1TJHUvrXVY/UoQAzrMoj3unPqgvqpcBGAb0xddEi29wR+KHR1Q==
Received: from CH5PR03CA0023.namprd03.prod.outlook.com (2603:10b6:610:1f1::21)
 by SA3PR12MB138305.namprd12.prod.outlook.com (2603:10b6:806:517::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Wed, 30 Sep
 2026 12:12:18 +0000
Received: from CH3PEPF0000000F.namprd04.prod.outlook.com
 (2603:10b6:610:1f1:cafe::77) by CH5PR03CA0023.outlook.office365.com
 (2603:10b6:610:1f1::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.16 via Frontend Transport; Wed,
 30 Sep 2026 12:12:17 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH3PEPF0000000F.mail.protection.outlook.com (10.167.244.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 12:12:17 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 30 Sep
 2026 05:11:55 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 30 Sep 2026 05:11:55 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Wed, 30 Sep 2026 05:11:49 -0700
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
Subject: [PATCH net V2 1/4] net/mlx5e: ipsec: Block eswitch mode changes during policy creation
Date: Wed, 30 Sep 2026 15:11:16 +0300
Message-ID: <20260930121119.141953-2-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000F:EE_|SA3PR12MB138305:EE_
X-MS-Office365-Filtering-Correlation-Id: 2dd39094-4202-4395-2b8c-08df1eec124e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|1800799024|7416014|82310400026|23010399003|22082099003|56012099006|11063799006|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	8QDK8PpG8gXiuoXSsvy9103WXFXgvCGZkd6tWJH9SONBpZvr9tkag3Bao4b1lTBrnOo6oJAE0y4w/fDKSgBdPRu2PBTZty6TwMI4cAbhjX5pXla8hmtnNOkQww7jtoV2+TKSZZZzlfHXwZbMcWIUwB+axuC+wIZXNZfzaBak3AfcePga/lijc6TPTCmgsBnf6/3dMj013mE9CRwQ+P2qkhEle8+5Dz8VKFMXbBttZUgJVx+g/r7wA8SzLzf+xWDNYNbmBszwkIeNM642+cf1+AKu3N+L9ApbLip5z4ADkqxVnisQFf+BOofDpE4tZ4U14xbi4tUTV5go2jHZtnEZxyG10PnXTsmDxo1qBIer8WoYivbPEqEh6IjTUb2XMaw66NGyRctzqVWqalEI7zhQVc/9nDMjvW8EdioA1vO/3bTXl5JDrYBz55x2sILgD32MLcMOiVvEXmLfQkegA7Imk2CQ38YzkWTvtcqB7ZwZCLz803wbWXI0Y+s6y/tH5fS1f+oFkJYGAlv7g+EM+AWut2VENhNbLOPj9fNRsbLeo5WCDOn3P7ExMpTD1Uh2eYTbPW91Oqq18Uef+B4OOm7pWR7TMqO7+SPyWDCuJ++qDI2fQi5mDZPxFdSPuwaQfYMDsjTuZLXNfMSDHPflzxHKIvtBsxGgtxasq61olhqFoLQNkcXGf+GJAWkymdli4CZarVzGKtEsvmII/2w/h2vwSA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(376014)(1800799024)(7416014)(82310400026)(23010399003)(22082099003)(56012099006)(11063799006)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	MrE2c0y3QRydWIn52SYLIK9lSMxU9erZFr2WzpiVcJ2q3vOklyXe3Vrj0fMwTHXtqYRJk8HOd7HBpiU1SjggrRcTMnaBefEohEzGvY/VeqDDCRi1U1y+TOSv3fEzn+RTqe5Pfve7JBLF4TO4bI4+wA3oVRWR8pvLDyMr/upD9KtrSUCvJTYkETBhUugsJ2EGXYBDviOA2Thqp7PyIXa3ERHpaq8AwAlTYtdh4xr6Q64nI0d01rPg/Natp0k+ir8Un2s3DItoD52ifC50AUCdB0qZbjcx3ToGh+A1Rgjp+Q7g6lEsitS8vLpuP3V9gCOAtmMZOVJOMeqFrDTpR8F80a7UAlODix5UKQAC6oDIMfomCraa0J6uhqAhqJMUcPzaYHR09Ub/5esLYNwBNZg7JWcrwpsqLkosj01Fka/i9rrF+DynkJgd2AlN1devDmwH
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 12:12:17.6589
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dd39094-4202-4395-2b8c-08df1eec124e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB138305

From: Cosmin Ratiu <cratiu@nvidia.com>

Eswitch mode changes can tear down the IPsec context while policy
creation is accessing it. The mode-blocking reference acquired when
creating a flow table comes too late: the table lookup already accesses
the IPsec context before taking that reference.

Block mode changes before checking the IPsec context and validating the
policy. Release the temporary reference after successful setup, when the
flow table holds its own reference, or after unwinding on failure.

Unfortunately, simply using mlx5_eswitch_block_mode() for this would
introduce a regression where:
1. An offloaded inbound IPsec policy is added on the uplink.
2. A TC flower rule is added on a VF representor.
3. Another uplink IPsec policy using the same RX tables is added.

Before this change, the 3rd rule would reuse an existing RX/TX table
from 1 and would avoid an mlx5_eswitch_block_mode() check in
rx_get()/tx_get(). After this change, the temporary mode block added
would reject the 3rd rule because esw->user_count > 0.

To avoid that, I was forced to separate the mode blocking from the TC
check by introducing a check_users argument to
mlx5_eswitch_block_mode().

mlx5e_xfrm_add_state() has the same race, and will be fixed in the next
patch.

Fixes: a5b8ca9471d3 ("net/mlx5e: Add XFRM policy offload logic")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 23 +++++++++++++++----
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    |  6 ++---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 11 +++++----
 .../net/ethernet/mellanox/mlx5/core/eswitch.h | 10 +++++---
 .../mellanox/mlx5/core/eswitch_offloads.c     |  7 +++---
 5 files changed, 37 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index db260e3d1412..841ecdc2c4d9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -806,7 +806,7 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 		goto err_xfrm;
 	}
 
-	err = mlx5_eswitch_block_mode(priv->mdev);
+	err = mlx5_eswitch_block_mode(priv->mdev, true);
 	if (err)
 		goto unblock_ipsec;
 
@@ -1266,18 +1266,28 @@ static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
 	int err;
 
 	priv = netdev_priv(netdev);
+	/* Block esw mode changes until the policy holds its own block. */
+	err = mlx5_eswitch_block_mode(priv->mdev, false);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Eswitch busy, can't add policy");
+		return err;
+	}
+
 	if (!priv->ipsec) {
 		NL_SET_ERR_MSG_MOD(extack, "Device doesn't support IPsec packet offload");
-		return -EOPNOTSUPP;
+		err = -EOPNOTSUPP;
+		goto unblock_mode;
 	}
 
 	err = mlx5e_xfrm_validate_policy(priv->mdev, x, extack);
 	if (err)
-		return err;
+		goto unblock_mode;
 
 	pol_entry = kzalloc_obj(*pol_entry);
-	if (!pol_entry)
-		return -ENOMEM;
+	if (!pol_entry) {
+		err = -ENOMEM;
+		goto unblock_mode;
+	}
 
 	pol_entry->x = x;
 	pol_entry->ipsec = priv->ipsec;
@@ -1293,6 +1303,7 @@ static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
 		goto err_fs;
 
 	x->xdo.offload_handle = (unsigned long)pol_entry;
+	mlx5_eswitch_unblock_mode(priv->mdev);
 	return 0;
 
 err_fs:
@@ -1300,6 +1311,8 @@ static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
 ipsec_busy:
 	kfree(pol_entry);
 	NL_SET_ERR_MSG_MOD(extack, "Device failed to offload this policy");
+unblock_mode:
+	mlx5_eswitch_unblock_mode(priv->mdev);
 	return err;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 8ffa8068e90a..cd7ff3613524 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -1127,7 +1127,7 @@ static int rx_get(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 	if (rx->ft.refcnt)
 		goto skip;
 
-	err = mlx5_eswitch_block_mode(mdev);
+	err = mlx5_eswitch_block_mode(mdev, true);
 	if (err)
 		return err;
 
@@ -1416,7 +1416,7 @@ static int tx_get(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 	if (tx->ft.refcnt)
 		goto skip;
 
-	err = mlx5_eswitch_block_mode(mdev);
+	err = mlx5_eswitch_block_mode(mdev, true);
 	if (err)
 		return err;
 
@@ -2581,7 +2581,7 @@ static int mlx5e_ipsec_block_tc_offload(struct mlx5_core_dev *mdev)
 	int err = 0;
 
 	if (esw) {
-		err = mlx5_esw_lock(esw);
+		err = mlx5_esw_lock(esw, false);
 		if (err)
 			return err;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index fc197d1dc9df..69d922712048 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -3009,9 +3009,9 @@ void mlx5_esw_put(struct mlx5_core_dev *mdev)
  * Should be called by esw mode change routine.
  *
  * Return:
- * * 0       - esw mode if successfully locked and refcount is 0.
- * * -EBUSY  - refcount is not 0.
- * * -EINVAL - In the middle of switching mode or lock is already held.
+ * * >= 0    - esw mode if successfully locked.
+ * * -EBUSY  - mode change in progress or users exist.
+ * * -EINVAL - lock is already held.
  */
 int mlx5_esw_try_lock(struct mlx5_eswitch *esw)
 {
@@ -3027,11 +3027,12 @@ int mlx5_esw_try_lock(struct mlx5_eswitch *esw)
 	return esw->mode;
 }
 
-int mlx5_esw_lock(struct mlx5_eswitch *esw)
+int mlx5_esw_lock(struct mlx5_eswitch *esw, bool check_users)
 {
 	down_write(&esw->mode_lock);
 
-	if (esw->eswitch_operation_in_progress) {
+	if (esw->eswitch_operation_in_progress ||
+	    (check_users && atomic64_read(&esw->user_count) > 0)) {
 		up_write(&esw->mode_lock);
 		return -EBUSY;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 8b1f93b13ea9..1200018ced7a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -947,7 +947,7 @@ void mlx5_esw_release(struct mlx5_core_dev *dev);
 void mlx5_esw_get(struct mlx5_core_dev *dev);
 void mlx5_esw_put(struct mlx5_core_dev *dev);
 int mlx5_esw_try_lock(struct mlx5_eswitch *esw);
-int mlx5_esw_lock(struct mlx5_eswitch *esw);
+int mlx5_esw_lock(struct mlx5_eswitch *esw, bool check_users);
 void mlx5_esw_unlock(struct mlx5_eswitch *esw);
 
 void esw_vport_change_handle_locked(struct mlx5_vport *vport);
@@ -970,7 +970,7 @@ bool mlx5_eswitch_is_peer(struct mlx5_eswitch *esw,
 bool mlx5_eswitch_block_encap(struct mlx5_core_dev *dev, bool from_fdb);
 void mlx5_eswitch_unblock_encap(struct mlx5_core_dev *dev);
 
-int mlx5_eswitch_block_mode(struct mlx5_core_dev *dev);
+int mlx5_eswitch_block_mode(struct mlx5_core_dev *dev, bool check_users);
 void mlx5_eswitch_unblock_mode(struct mlx5_core_dev *dev);
 
 static inline int mlx5_eswitch_num_vfs(struct mlx5_eswitch *esw)
@@ -1081,7 +1081,11 @@ static inline void mlx5_eswitch_unblock_encap(struct mlx5_core_dev *dev)
 {
 }
 
-static inline int mlx5_eswitch_block_mode(struct mlx5_core_dev *dev) { return 0; }
+static inline int mlx5_eswitch_block_mode(struct mlx5_core_dev *dev,
+					  bool check_users)
+{
+	return 0;
+}
 static inline void mlx5_eswitch_unblock_mode(struct mlx5_core_dev *dev) {}
 static inline bool mlx5_eswitch_block_ipsec(struct mlx5_core_dev *dev)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index eb74b6260168..95e856f8d834 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -4343,7 +4343,7 @@ static int esw_inline_mode_to_devlink(u8 mlx5_mode, u8 *mode)
 	return 0;
 }
 
-int mlx5_eswitch_block_mode(struct mlx5_core_dev *dev)
+int mlx5_eswitch_block_mode(struct mlx5_core_dev *dev, bool check_users)
 {
 	struct mlx5_eswitch *esw = dev->priv.eswitch;
 	int err;
@@ -4351,9 +4351,8 @@ int mlx5_eswitch_block_mode(struct mlx5_core_dev *dev)
 	if (!mlx5_esw_allowed(esw))
 		return 0;
 
-	/* Take TC into account */
-	err = mlx5_esw_try_lock(esw);
-	if (err < 0)
+	err = mlx5_esw_lock(esw, check_users);
+	if (err)
 		return err;
 
 	esw->offloads.num_block_mode++;
-- 
2.44.0

