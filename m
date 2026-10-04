Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012061.outbound.protection.outlook.com [40.107.200.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0494A3EEACB;
	Sun,  4 Oct 2026 08:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791102990; cv=fail; b=hY+Wpvi9oTJ658y6uqZKrsBdnSiff3zM87FOUgSS0DxHSRBXJl8SAdf5ddWjiIMJ7NuzA6ud5gEQi6Dl+4DVFw3ZjfVdK/yj5yEHlJWze0QuFbfDlru8eE+Z/6EcPv4aPULbD2Q2XnimyA8O7AIn1xX1XggfS6r5Tv6xZB+LKfQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791102990; c=relaxed/simple;
	bh=kctlMZlzclEutisB9OjmkA5Stfe0U91D3PiLBhEKpQk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IbDCvjowYU/LU3NQxaJnLCj2ASGQm1eQTuNVFskBctM8qAkLv7iTR3ye6ty4mXXv9+U+BfC5PvghaUwXhxbz5acrkacxRxTct6+tboaxSNj2F3qxnry5zlVreJsm8ERcuQptFY9fT3k07xqBFnoaBNUWdXjUp4qWi5fkxCmYN68=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nV6gh0pt; arc=fail smtp.client-ip=40.107.200.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nV6gh0pt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P7PGdWk6d5+5paICSnMrqlN0nu4wSNLUpbI73iDyM5BnCvb4zRoLhtaPgTL26WEIcDXDfuNGRmzamYwpA1MGkdkAD9QW8c1fSyc/qFF/fnlnxqj+YCglfv5cx/3zmebsB2dGKnhlPJhcFz4Zv+3uymDdBVpAxQncP+xVAiKRJ/TQ8mV8ameWrY1jnv7K9BShe9WOEbG5yaWHkeObeFYgQPnU3UkYmANw6QLM/TBxSYVj/TgsLSFp5D2Kj6nsHEJ9AEWmlKhigH5Bi8RCt+qu1OUu0XSo4WkmnBEa3nIYHMxVPz/K7cboV7JTco9fwlt7kS/ECHo3iHL8i5ja5h7nMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DAzs9teOHAck/fP57ExC/jBLoAMyJEAVC03COMAn1ZI=;
 b=prY8szd+Kf6VdXedVYptKz+2Ls+t3QeAgYNQw7wE/+xLYLfLx9H4IoK2THJlRFfjv6szZc+Euku4H0pSvJYcGY1tYhcsrZ0JT1BbNlWWnrCz79JIxjmZcuphgDw4hhxiizbmbyGVn2jy++bZSSXWT7w+V36IXiadvrPRwXgHgAdkeBvfyIEjwDWFi3vXutCN5rTdwJlzd5SJfvREvlzOk1u6ICZo37bAvxQnDzYim9uvJNyzZEWbE7R9XLu+WNE83dIRQ7HZuMU1x2wDGFftHj7Iqr+bCbvZGG+W9cEb1ZdMdZMMkm382Ij8Pr+ugVEcPWmUVWGto0vCPfsLE59YzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DAzs9teOHAck/fP57ExC/jBLoAMyJEAVC03COMAn1ZI=;
 b=nV6gh0ptbfjQhDvMUMkFl1/IOihA84ObegWUTzZwWOc0pA3NlnSrVN9DtTmueJSwetMsJABVLwoDykfw8oIUxbgBq3+7L3ff8qS71Tw3rgdWz/i+0h+pUoo7PLxux7x6b3oOWWSsAYsHThPyiHNERO8hmWV7MZivT5mVWbeuGAlDyXOEaaq4Ds7vpgoJ8dVE9vHTspGNd5Puvzi+dBRqiZ2bWRCCmUtmoVkWlhO6ouKvozVXKHyLWLfKx8DPD6dzwvNVBZvuHgcoJuPeuyCfawvUm5XhKQlM/CyR1w7UiojPgEam5e4yFlYQ99+qCmLmJEX/tklKMC3MLn/CkaVhmw==
Received: from CH0PR03CA0444.namprd03.prod.outlook.com (2603:10b6:610:10e::12)
 by PH8PR12MB6772.namprd12.prod.outlook.com (2603:10b6:510:1c7::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Sun, 4 Oct
 2026 08:36:20 +0000
Received: from DM2PEPF00003FC2.namprd04.prod.outlook.com
 (2603:10b6:610:10e:cafe::69) by CH0PR03CA0444.outlook.office365.com
 (2603:10b6:610:10e::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Sun, 4
 Oct 2026 08:36:20 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM2PEPF00003FC2.mail.protection.outlook.com (10.167.23.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Sun, 4 Oct 2026 08:36:20 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Sun, 4 Oct
 2026 01:36:06 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Sun, 4 Oct
 2026 01:36:06 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Sun, 4 Oct
 2026 01:36:02 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>, "open
 list" <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark
 Bloch <mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Or Har-Toov
	<ohartoov@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drori
	<shayd@nvidia.com>, Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net] Revert "net/mlx5: E-Switch, preserve max tx speed on vport state modification"
Date: Sun, 4 Oct 2026 11:35:31 +0300
Message-ID: <20261004083531.216988-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DM2PEPF00003FC2:EE_|PH8PR12MB6772:EE_
X-MS-Office365-Filtering-Correlation-Id: 70212f20-c04d-425e-e531-08df21f290b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|36860700016|82310400026|1800799024|56012099006|10067099003|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
	oSkFdT4O0uLDS3GxkQATZ7wb+9fc2NOqw/fTRTn2H3NcNTURq99F2ow/apm9hEFytfdH2bm2OfwdYMppVA08QaiiFnZC82j6E970E7ZhRHVgKdClUA40PgDHxp5HdS5j8vjoCFPkVM7ervxlYjU9orwMf7g4dMFM/HqwnNd6N98CzYm0GGbhx26YgdtSDXZbkeDTZWd+AGE6zE0cFw02E8wYS9B5R3e+L+Omkw2uT28U079FwjA/L1dIm8Bwaith4ygAFKrCPIJKb1ZGlsvYJV1lvmPRf4bEQHyohrSBg1WAqpB0kuIuVV3/sJyuZ+7cMcQvK3JCCYKH6ee+uZLEz2ZgkwgCSESRHTnLvBzJqtmlT0EmLfNELGPlAEf7n/rxrqcPcJPvB2Q6TAspbiGmw1i6uUs+j94tjyLb2LZbc1eLZEO1c2n/2uOpzZ1DsR5hL1Rt+dLnyWC1T8tk6ap2Y1yCmD575ieuNoZCIVGTc6lsCTlqEPnULEUL4JxvXHojAV824xY8I30qq2QhqglyOofZidzmQxv/UDXNP6t1s2IKZM/E5g2ZJ82jSibHsHVclfZJQJtpXESsoUyq0+MSX88qGXftQ3gA6ydwMX28VYDnttHjKOTMJiaF+5V7cujtYNejcJ7U39XMKPIkf/tQDhjkusMwmKI71/jgNLqCllHLoF+vj6bL06d3w/mnFUUv0DESbDfp8wdhpH3K43g78g==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(36860700016)(82310400026)(1800799024)(56012099006)(10067099003)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ozvOLzglU+g4JX42C+oF+fvB8ozebT9b93yqkSjuXQhdSyhmXXmpODlddA6mRP6CgG8xkuuP/UdHA1au4/Id6aJQSDA6MLdr5CS2wMmBghCNPFr4RUIkrulMG4PDpL/1Zy8E+puRO5kcrMOMsyUI94ZiQMy7hjuIY6GlSy2/cJ5KQsarpRaHY+98uInzVIB4p0XqByIy7aXo7eM+fMwX4pwg+Kc5g2E12qDoLG/EGIdlIbm2EJ+n9b00+rdlxiipxrj6WrIB7r1kZVQPtKFZChWSwp9M7NRQQl2CLDJn96haZ7iIkhijcJuyaIHat03uoAUDSkoPAnljzc7jm5921XygFvYhUBV8DMW1altihScorshxg2blYs3zvyG1he07OxrLEMTVeGM8tICVy2N1Hhx7IjnEcIsfKXZ2ouiU8xDhXBgb2PIDC4EEe70ha+Jw
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2026 08:36:20.2044
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 70212f20-c04d-425e-e531-08df21f290b5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM2PEPF00003FC2.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6772

From: Or Har-Toov <ohartoov@nvidia.com>

This reverts commit ad0ae7aefa7a ("net/mlx5: E-Switch, preserve max tx
speed on vport state modification").

mlx5_modify_vport_admin_state() and mlx5_esw_adj_vport_modify() query
the vport's current max_tx_speed before modifying its state, and
write that value back, to avoid resetting it to 0 as a side effect
of an unrelated admin-state change.

That's unnecessary: max_tx_speed is optional in MODIFY_VPORT_STATE -
FW skips writing it whenever it's 0, treating that as "not provided"
rather than "reset to zero". Leaving it unset already preserves FW's
current value, with no query needed.

Fixes: ad0ae7aefa7a ("net/mlx5: E-Switch, preserve max tx speed on vport state modification")
Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/esw/adj_vport.c        | 20 ----------------
 .../net/ethernet/mellanox/mlx5/core/vport.c   | 24 -------------------
 2 files changed, 44 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/adj_vport.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/adj_vport.c
index 7950b82d8b8a..3624c680a861 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/adj_vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/adj_vport.c
@@ -11,26 +11,6 @@ int mlx5_esw_adj_vport_modify(struct mlx5_core_dev *dev, u16 vport,
 
 	lockdep_assert_held(&dev->priv.eswitch->state_lock);
 
-	if (MLX5_CAP_ESW(dev, esw_vport_state_max_tx_speed)) {
-		u8 op_mod = MLX5_VPORT_STATE_OP_MOD_ESW_VPORT;
-		struct mlx5_vport *esw_vport;
-		u32 speed = 0;
-		int err;
-
-		err = mlx5_query_vport_max_tx_speed(dev, op_mod, vport,
-						    true, &speed, NULL);
-		if (err) {
-			esw_vport = mlx5_eswitch_get_vport(dev->priv.eswitch,
-							   vport);
-			speed = IS_ERR(esw_vport) ? 0 :
-				esw_vport->agg_max_tx_speed;
-			mlx5_core_dbg(dev,
-				      "Failed to query vport %d max tx speed, err=%d, using cached %u\n",
-				      vport, err, speed);
-		}
-		MLX5_SET(modify_vport_state_in, in, max_tx_speed, speed);
-	}
-
 	MLX5_SET(modify_vport_state_in, in, opcode,
 		 MLX5_CMD_OP_MODIFY_VPORT_STATE);
 	MLX5_SET(modify_vport_state_in, in, op_mod,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index 5774ec117428..78f3d15b599d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -93,30 +93,6 @@ int mlx5_modify_vport_admin_state(struct mlx5_core_dev *mdev, u8 opmod,
 	lockdep_assert_held(&mdev->priv.eswitch->state_lock);
 #endif
 
-	if (MLX5_CAP_ESW(mdev, esw_vport_state_max_tx_speed) &&
-	    opmod == MLX5_VPORT_STATE_OP_MOD_ESW_VPORT &&
-	    vport != MLX5_VPORT_UPLINK) {
-		u32 speed = 0;
-		int err;
-
-		err = mlx5_query_vport_max_tx_speed(mdev, opmod, vport,
-						    other_vport, &speed, NULL);
-		if (err) {
-#ifdef CONFIG_MLX5_ESWITCH
-			struct mlx5_vport *esw_vport;
-
-			esw_vport = mlx5_eswitch_get_vport(mdev->priv.eswitch,
-							   vport);
-			speed = IS_ERR(esw_vport) ? 0 :
-				esw_vport->agg_max_tx_speed;
-#endif
-			mlx5_core_dbg(mdev,
-				      "Failed to query vport %d max tx speed, err=%d, using cached %u\n",
-				      vport, err, speed);
-		}
-		MLX5_SET(modify_vport_state_in, in, max_tx_speed, speed);
-	}
-
 	MLX5_SET(modify_vport_state_in, in, opcode,
 		 MLX5_CMD_OP_MODIFY_VPORT_STATE);
 	MLX5_SET(modify_vport_state_in, in, op_mod, opmod);

base-commit: 6dc989ea46b96ce170840174b4a38c4a387fb005
-- 
2.44.0

