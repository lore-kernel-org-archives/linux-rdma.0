Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012045.outbound.protection.outlook.com [52.101.48.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE7754706B;
	Thu, 17 Sep 2026 18:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668632; cv=fail; b=bsj26XuELtqYxadnvnPD0Fp13jJf/KI1gFRf6cZMBpsILzFOD9x14WUe0CAQeyE6s7G0xqli+0ql7I8zCTos0H7nn5bIB5R00FB8PDgVVokJhc+uFceE/4wvG/UorWgXjBJXnQSzYu9ZnvBOK6adbjIxSPR19I6xerJMor6BA2s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668632; c=relaxed/simple;
	bh=qCyvdiA05ak6JSs4M5yJapmUBdkixOc57Yfe396sXaY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bvOGIL+WTvAJgVQOG1y2L2acKQjkYn0+z7T44qXPFSUXkfZ8s6J9EHwUBa3G9Yanf9Gv70K0WEeiII8jApcGsl2+QSzfZujkmcgZM/E533GbE+yRK7BIyO/AQ3saGCm1TxqYcnCFgrzALNAPNMmZ5i5I3qvK6MCKnSj/uZCy468=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WIkBeJ+v; arc=fail smtp.client-ip=52.101.48.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WIkBeJ+v"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q1jrFuphR5bWDreHtZDJmK/vblmOVMNA9ObZAq0YI7K3hAnBQrmuwYamD35pv9ZR/e9/B/CkLimuilve45wHfZ3D6jbT+y6/cZKCwv483zl9QATWu9sZNUTUqf8f1m1zpXFnNf6rQwODDJoi30ZhBAvpXLkKYYacWUXa1Mmh9+PXy1EjHE0Lio5aPzWLxWT2Adrn3IL84vu/jZzjUUJDn5ZHM4tX4U4Ngw9wnqvrkogsKMygzASVBKAV0hz5PcVk5VVAoUOUCTjadbSqh+E6WRf1zJfNp/aZH4hkzHqg2X0Xnd3ulbHNDr7dfUl/dW9HmphJwLrGKPwC7u128MYPtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OE9k+J6Gnp57nqKgGIzOiDOABYox1boSyscMnCifaNc=;
 b=IZqmkO7t9epnyYGIuAPkLNj68r6OyD12ZsX5sJbeKtLTolO/CRI9oUsPrrV6LGgtCTmEgVifMKfs/5mzlE3Z3wvPGTOUqHLQNmjM6LQx90plyrVmuiWhFubAp1oeIvmhiqTD/rcT1rRzGdt6MAUMZ8ZCoW/QZ7sEiFKmpjV5yYQoQpvw21ybTy/7rIgCoxxFg/5mFAE8AglcECpdjrs2OFqW98ID5R7ayWO0fXoerfYFHzIgb9TivfQTUhrfad0jREe3HBDOP9Kv+u9VJrKTruqzClEy9m1PRi7i3edx8C4Mqo6W5ijR4stVmk4DdEUVOP+JoaSIK82RzUVGLPUfMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OE9k+J6Gnp57nqKgGIzOiDOABYox1boSyscMnCifaNc=;
 b=WIkBeJ+vVNKrGSEiB5UmTGWXd4ZRps2k9EM2zlY85sr9LLrnJWzj+Y1+fxiqCRyPGRYLBfSenJJzTnJQ/qifqFwZ5Vco6EjEjKzSTZ1gEUKjA2YYqKn5iG/nhgBIBg0AqVirPit0QqR8oBylv2ZKOk3R2ZrctlK8qSdHfJxben3yFw+dvh/PUjsPnpLMT7v5lVcxywJI0g4m6Zja3ShMoct+QhxAES7mgIWuqmLZtUDkNjsog+Kgm8cKaKeAqOv1jVIEeALYAccb6NWPaD9reDXR3Faf+qLxKApnqmeUctqWem3pNRTWwzGqRMWS7L8woIqohwai6cM8j3HkXBEBeQ==
Received: from BLAPR05CA0008.namprd05.prod.outlook.com (2603:10b6:208:36e::11)
 by BY5PR12MB4148.namprd12.prod.outlook.com (2603:10b6:a03:208::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.14; Thu, 17 Sep
 2026 18:10:25 +0000
Received: from BL6PEPF00020E62.namprd04.prod.outlook.com
 (2603:10b6:208:36e:cafe::93) by BLAPR05CA0008.outlook.office365.com
 (2603:10b6:208:36e::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.8 via Frontend Transport; Thu, 17
 Sep 2026 18:10:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF00020E62.mail.protection.outlook.com (10.167.249.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Thu, 17 Sep 2026 18:10:24 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 17 Sep
 2026 11:10:01 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 17 Sep
 2026 11:10:00 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Thu, 17
 Sep 2026 11:09:54 -0700
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
Subject: [PATCH net 1/7] net/mlx5e: ipsec: Block eswitch mode changes during policy creation
Date: Thu, 17 Sep 2026 20:54:27 +0300
Message-ID: <20260917175433.4090878-2-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E62:EE_|BY5PR12MB4148:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c2bd56f-e33d-4f7f-42c5-08df14e6f250
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|82310400026|7416014|376014|1800799024|22082099003|18002099003|11063799006|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	36oUMUoFxgk40nxFe5nellEyCG+kgMQQLHCZKe17nW7wPSPbrB9N8EcP1/cRFMayblJSIe23foY3vATRjh+k5prxN4KgxBh4cHOzU3DjFPj1x1GlQB5seUv3rE10waHsarfTJQJk7TkV6hGsr8b89tSFKv1zZn+1Ydnrb+xNyC4srJf+AMT8lC5pI1ZoD+YUxnnNM6TPgOgQ5GG4wyPibUzHLYhevBdGes2C1Fmlw1PSJp1KVT7o733svO2BBfG0rxcePfRvR8+cam5IHjZDoQO/SAJ4mniG8CMSvEdfnDydq+4Iir4Ua2qrynW4cNy5BdDyeF7LLYhbb8179yHMwZMbR7MkQ5/huHf6MNz0EzyICKwa9OKDms6G9s/bccTAHAbEzZ2KRCizII4Weu8bekbVdm/7W3rnUX+jB/OuFOmG0f422MSnR6KS3eNB7cZCwg2cdyzAajAFB/pLSYG4/KC5/1J3YglSHp2wsHkgerWU7Obtj9TTrmoU0D2wsV/5OdzAwOOv/s9zcpVnwkfq4cLcJoIKzNPJf2WD2w9OMYYqE+MSrtxdkKhChh+xJDJilZTTyLrOFe7wYMPicRyHYonAVhlolIPgXIG+u09Z444fKz6Unl2bJ8kUJKko6cZKhwUEuSMTm5FtXiBse2XHodRdZs3dZhDJdfbf9PeSgHXraRNS4WYbqRVfKrW0on2Q9Hd9F0o9uO2Y+CWrEPT+wA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(82310400026)(7416014)(376014)(1800799024)(22082099003)(18002099003)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	TfPw3QX+O/tDTwfP+s4rYuLdPC+kJT3U6sA7ot18zZuLpKq0AJMk9VWA728eSEXL4bvz8v9p2S6MAE8aaPpTMTgUf1c+a/LEMGVPr2Glsppg/ZsWNTRMmkGqIgfQ3UKtkYsy0J3pDU8Ewr69H3Wjby7XYIwCf15DYdvygjr3Nah5yGwAj6BVuEVcMH7ImAzhxrPzBrg2IgsqtkkPkXpMm0idmoGm96oF/E4f1NGjytbuHMWsV1rHnjtFwoY9s4z0g0jLFXYrYbSng0prP1+2UQ5lwHRgJy2tKArl+DgH6w/iMxBfn5jOthxhd7N/6efb4k1HLpxFpjSueedogM91eC9zzBucN/hEsirSaARq3truVAy+0kHQ+Op/nKEvIRpNYtB2L9MAwk5tlM4AKn/S4ajuxu7aqr0m02nJ4ujBMqY1PWdyRaZ6zJ0XedyNrccL
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 18:10:24.7949
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c2bd56f-e33d-4f7f-42c5-08df14e6f250
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E62.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4148

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

Fixes: a5b8ca9471d3 ("net/mlx5e: Add XFRM policy offload logic")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 23 +++++++++++++++----
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    |  4 ++--
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 11 +++++----
 .../net/ethernet/mellanox/mlx5/core/eswitch.h | 10 +++++---
 .../mellanox/mlx5/core/eswitch_offloads.c     |  7 +++---
 5 files changed, 36 insertions(+), 19 deletions(-)

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
index 329608c59313..5c72656c623f 100644
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
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index fc197d1dc9df..0b48cc7a6734 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -3005,21 +3005,22 @@ void mlx5_esw_put(struct mlx5_core_dev *mdev)
 /**
  * mlx5_esw_try_lock() - Take a write lock on esw mode lock.
  * @esw: eswitch device.
+ * @check_users: reject the lock if eswitch users exist.
  *
  * Should be called by esw mode change routine.
  *
  * Return:
- * * 0       - esw mode if successfully locked and refcount is 0.
- * * -EBUSY  - refcount is not 0.
- * * -EINVAL - In the middle of switching mode or lock is already held.
+ * * >= 0    - esw mode if successfully locked.
+ * * -EBUSY  - mode change in progress or users exist with check_users set.
+ * * -EINVAL - lock is already held.
  */
-int mlx5_esw_try_lock(struct mlx5_eswitch *esw)
+int mlx5_esw_try_lock(struct mlx5_eswitch *esw, bool check_users)
 {
 	if (down_write_trylock(&esw->mode_lock) == 0)
 		return -EINVAL;
 
 	if (esw->eswitch_operation_in_progress ||
-	    atomic64_read(&esw->user_count) > 0) {
+	    (check_users && atomic64_read(&esw->user_count) > 0)) {
 		up_write(&esw->mode_lock);
 		return -EBUSY;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 8b1f93b13ea9..4a9a1656f6db 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -946,7 +946,7 @@ bool mlx5_esw_hold(struct mlx5_core_dev *dev);
 void mlx5_esw_release(struct mlx5_core_dev *dev);
 void mlx5_esw_get(struct mlx5_core_dev *dev);
 void mlx5_esw_put(struct mlx5_core_dev *dev);
-int mlx5_esw_try_lock(struct mlx5_eswitch *esw);
+int mlx5_esw_try_lock(struct mlx5_eswitch *esw, bool check_users);
 int mlx5_esw_lock(struct mlx5_eswitch *esw);
 void mlx5_esw_unlock(struct mlx5_eswitch *esw);
 
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
index eb74b6260168..996490e11625 100644
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
@@ -4351,8 +4351,7 @@ int mlx5_eswitch_block_mode(struct mlx5_core_dev *dev)
 	if (!mlx5_esw_allowed(esw))
 		return 0;
 
-	/* Take TC into account */
-	err = mlx5_esw_try_lock(esw);
+	err = mlx5_esw_try_lock(esw, check_users);
 	if (err < 0)
 		return err;
 
@@ -4485,7 +4484,7 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 		return 0;
 
 	mlx5_lag_disable_change(esw->dev);
-	err = mlx5_esw_try_lock(esw);
+	err = mlx5_esw_try_lock(esw, true);
 	if (err < 0) {
 		NL_SET_ERR_MSG_MOD(extack, "Can't change mode, E-Switch is busy");
 		goto enable_lag;
-- 
2.44.0

