Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012001.outbound.protection.outlook.com [40.107.209.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55681379C38;
	Wed, 29 Jul 2026 06:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785307944; cv=fail; b=ZQxp0KxsjvY+/OeKR9vpEHLXCGfTcfjG7wZIGEg4/MYWEr0VtUQ/JK3bHV050Angd7WLuH54lsc9w8H9E8Pjt9ZvGuUFVGPLPsyBZiOxFLwOBoCtZ+QmmXAx3zXWzOuv7RtoVTzhrOWOiQ1adPw1/07dO73qT6rfC1RM2GEGXBQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785307944; c=relaxed/simple;
	bh=IsnuBtL8HuItdMoITuzu6XM16afZLvv2UpgcVUueb/M=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fBcy4Ot8VnWb+Re4A/03vnTfYi4XSPFFGpi9vvY+DBZP8qft/JU+Ju58kjpRvyVUnhqes3xCseERuKsy7sTGhsHRr6LZY6M6LG5pfT0PeVVZkZWLGwjsIok0C7Z6lCNiC11mlKPhYlM3PUJEiapgUlvDfg9oWolYvv2uGEBHlk8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ngO0EAd+; arc=fail smtp.client-ip=40.107.209.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ngO0EAd+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RVKaam66UthO7RwqULwH16lEM6X0QyIElO9jXs/ErYjI2UmMq/kuzVKQ7KTLTys8J9NYxBXUDo7QTV+cMlRQ8PDuF5ak1TniEl0L34ZootbzOPtmT4A8sCVoW2WFsE7R1SAGhAPR6D5uNQ5W42Uadpvq4UKdhQ5yE39/dCjfP6YgX+Czf84uKAID9u9YZDd/juNZb0MlAtAqubzP6BfhmTFS7Gyx2WnMgnkj86uYjf0ykaJFlacDhNd+HZWKP5yDP0N7DPWAUHZbcxP9hIGwcUC3NeFyYyHorVktHCiCv8OZb7Js3SCnFMm6T03GVxjGQVpXHs3h7RrsayX5He48pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n8FciBHn40easHI3RdYjFsCRvrXytzcDlZtAo4nPPxE=;
 b=dawOMFgALDHFRz85iUoBe5yT281yy3GAodgfaUca1iG4ELO3lNYdqCYN8UlESNq+xku0/R+jMJE1wldt7pMQzuPH8beGjYqK482wv5kF+DPTgBgWYqh5jEddHfe+U9cvAW74x/QauMBy834Tw6WzwN90Ph27ijviDkxM5kmH/yLjsCzlsgUaYZKHsspVUVJwG6rbBQYy7YX8GOWz/5fNE0vf1i0IgW79KN6NqNmBaequw3wUrsqxB3kuCO2EE8eqoC6JhdNx/tctoHKWvp06n9z/rvPzkJG/uB3T4Pj82GfeaEDeny634QTDBUaCdo8J6Orf/SmUmZZdnu4H9WfjqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n8FciBHn40easHI3RdYjFsCRvrXytzcDlZtAo4nPPxE=;
 b=ngO0EAd++URjlTwlbBN+Rd0dLXJBCcizW7afwDIVK6CVs0JR6X645+zNpGmnM9UjBoTmkTrI2YbNkKXnBcPqnvPaQxvOOoaYQaWObaae9RgsZK1wauMhLMnVE7OcXwhlJoLuEbtkH9nB+Brd6wp1FPItL9pq6jOh20fvxwAaP6yMQCqGwEKiSk0u8/dmJmtUy879m3TTUWDZxNXDgq1B8qfx1Le6iabPupKAgzQ7n8tm7CLTRbQcVVO/YJj/+yU/UjZDpvgc8g8z9JkXtqFmMZo/W+PFLLrXuKr1zhVuo1HoxhvrwE3N4njcwS6XuAF5c+2zaod6mGznLE1faZ2v9g==
Received: from DS0PR17CA0016.namprd17.prod.outlook.com (2603:10b6:8:191::7) by
 SA3PR12MB8762.namprd12.prod.outlook.com (2603:10b6:806:31f::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.12; Wed, 29 Jul 2026 06:52:15 +0000
Received: from DS2PEPF000061C8.namprd02.prod.outlook.com
 (2603:10b6:8:191:cafe::96) by DS0PR17CA0016.outlook.office365.com
 (2603:10b6:8:191::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.12 via Frontend Transport; Wed,
 29 Jul 2026 06:52:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DS2PEPF000061C8.mail.protection.outlook.com (10.167.23.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Wed, 29 Jul 2026 06:52:14 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 28 Jul
 2026 23:52:02 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 28 Jul 2026 23:52:02 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Tue, 28 Jul 2026 23:51:57 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Boris Pismenny <borisp@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>,
	Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Kees
 Cook" <kees@kernel.org>, Leon Romanovsky <leon@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Raed Salem <raeds@nvidia.com>, Rahul Rameshbabu
	<rrameshbabu@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net] net/mlx5e: Add mutual exclusion between PSP and PTP TX port timestamping
Date: Wed, 29 Jul 2026 09:51:37 +0300
Message-ID: <20260729065137.2420679-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF000061C8:EE_|SA3PR12MB8762:EE_
X-MS-Office365-Filtering-Correlation-Id: 586443c5-fe0c-4365-0e3b-08deed3dec45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|82310400026|376014|23010399003|36860700016|6133799003|11063799006|56012099006|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ndyV8ws4C5PHs8d76Mk22A1tqcY7hCGc2jKdDuohaZzSvq9OrSkhYEj2ACEXVOpB/067C38edtDHqsNxtz8b0NgBtzlvnSUfNd2BhE8j+Z+wharTsh9eyq5glFRxeqo1Ho4hF6zNHKjAaYHk9Dh5pXDgwkAGb4fqQ+ekbm6JlPRFV0j1ha7wRPeCxqP+JefE9EULXidFFqeJ/4KZMUDT+BHMQqPPykFkD6o/U/815D1NrqfN2JZKyhwoXr/AAaIqTkjKJ/9Awd6TGTQ5GJ95x4X0h9niS/xgd5R3e0dm+RhYrkdMf5y92/T8sF14eXlkjszX0BRdFf5pgnm99dNKJCmVfodFrJcDz5kNlbdXl4JygTzdMPllHLw19dN2XlocWciFzbDB1M8tNTx8NjQO+yHRhwozbpv86Zz5UdR1RCgb08RRRfZzWuugd3DUK7WzC4J/ATavwdGhmvaX81QKAxwXohL4TSkb0LkbVUlQnQDp+Id60hGiJJ0fc0XzyOlX8eI42jtjQWdLVN8ssnyoyaTRMP21OTPaZ8z4sGCZx/oysgC1Hf1XoHifBgK11eHmoRqpFFswwU3AOqrvZ8mwezoCDCxfcppKhTBanAlsYtyjVn/qNaUF1usnQ6iEyDa9gp0fW6MxaDiGExTV3JiIDP58yp9XqFrnh186jJx6L9NC1Qwi0HCDjSc3o/u/d/zw1YWiYEmXI7IcID6is8WzQA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(82310400026)(376014)(23010399003)(36860700016)(6133799003)(11063799006)(56012099006)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	PXCL/0nV0BYIGYlXjoCECvSLjOGbPuUC4rb4n8AxHGO1VGQkAbDFzM43Lzfhhdmf0Dsss3yOEt9csHz11YYsHdEuXFkQYiE7C+99I3yCcXqy75XDNEh1u9oP1yzJHnTipc5OAecRbjMMyd0YZ7oQBSuxbiE92Aw5tyJRI9sNE2kefPzsKDKsrqhH964gYC6ncrjZijttMIBgBxPJ+b1rVWXeqTuPZs0wF5sErady7E0z1ESfIp/R1Zp6ZS8ODpK3HkAkWJ4aLOXR9/te1APjbprYqoyxfyJqGw3z4TjEvPJ18/OgudhxQlv2UBYqWWARA4pWXYfh7uwLn8jvS1wc6iQEEfrBzQZ9M9QrMiei7JGm89Rkto4TrtK1c+SX40v6vrQHaj3J7ff5kj4Zb+pEsAvEPx1UBZCQ3sYQuFXIOa4g8KfMouYqozT5qXBf+qSC
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 06:52:14.4539
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 586443c5-fe0c-4365-0e3b-08deed3dec45
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF000061C8.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8762

From: Carolina Jubran <cjubran@nvidia.com>

The WQE flow_table_metadata field is shared by multiple TX offloads:
IPsec, MACsec, PTP timestamping and PSP each write to it.

Commit [1] resolved the conflicts between IPsec/MACsec and PTP
by shifting their markers to bits [8+], leaving PTP's 8-bit metadata
index in bits [7:0] without overlap.
But then PSP support was added in commit [2], which writes a 32-bit
keyid across all bits of flow_table_metadata. Unlike IPsec and MACsec,
PTP timestamping applies independently of encryption -- a PSP-encrypted
packet can also require a HW timestamp. When both write to the same
WQE, the values corrupt each other, leading to wrong PTP timestamp
tracking and potentially wrong PSP encryption keys.

Prevent the conflict at configuration time by blocking:
- Enabling TX-port-TS when PSP has active TX keys.
- Adding PSP TX keys when TX-port-TS is already enabled.

[1] Commit 2ac207381c37 ("net/mlx5e: Prevent WQE metadata conflicts
between timestamping and offloads")
[2] Commit 89ee2d92f66c ("net/mlx5e: Support PSP offload functionality")

Fixes: 89ee2d92f66c ("net/mlx5e: Support PSP offload functionality")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_accel/psp.c   | 16 +++++++++++++++-
 .../ethernet/mellanox/mlx5/core/en_accel/psp.h   | 11 +++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c |  8 ++++++++
 3 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
index d9adb993e64d..8d76dd488d77 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
@@ -993,6 +993,20 @@ static int mlx5e_psp_assoc_add(struct psp_dev *psd, struct psp_assoc *pas,
 	struct psp_key *nkey;
 	int err;
 
+	/* Mutual exclusion with TX-port-TS (shared WQE metadata). Reserve
+	 * tx_key_cnt under state_lock with the TS check so ethtool cannot
+	 * enable TX-port-TS until key creation completes or fails.
+	 */
+	mutex_lock(&priv->state_lock);
+	if (MLX5E_GET_PFLAG(&priv->channels.params, MLX5E_PFLAG_TX_PORT_TS)) {
+		mutex_unlock(&priv->state_lock);
+		NL_SET_ERR_MSG_MOD(extack,
+				   "TX-port-TS is active, PSP TX keys cannot be added");
+		return -EBUSY;
+	}
+	atomic_inc(&psp->tx_key_cnt);
+	mutex_unlock(&priv->state_lock);
+
 	mdev = priv->mdev;
 	nkey = (struct psp_key *)pas->drv_data;
 
@@ -1001,11 +1015,11 @@ static int mlx5e_psp_assoc_add(struct psp_dev *psd, struct psp_assoc *pas,
 					 MLX5_ACCEL_OBJ_PSP_KEY,
 					 &nkey->id);
 	if (err) {
+		atomic_dec(&psp->tx_key_cnt);
 		mlx5_core_err(mdev, "Failed to create encryption key (err = %d)\n", err);
 		return err;
 	}
 
-	atomic_inc(&psp->tx_key_cnt);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.h
index 6b62fef0d9a7..315c4b2101c2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.h
@@ -30,6 +30,11 @@ struct mlx5e_psp {
 	atomic_t tx_drop;
 };
 
+static inline bool mlx5e_psp_tx_keys_active(const struct mlx5e_priv *priv)
+{
+	return priv->psp && atomic_read(&priv->psp->tx_key_cnt);
+}
+
 static inline bool mlx5_is_psp_device(struct mlx5_core_dev *mdev)
 {
 	if (!MLX5_CAP_GEN(mdev, psp))
@@ -52,6 +57,11 @@ void mlx5e_psp_unregister(struct mlx5e_priv *priv);
 int mlx5e_psp_init(struct mlx5e_priv *priv);
 void mlx5e_psp_cleanup(struct mlx5e_priv *priv);
 #else
+static inline bool mlx5e_psp_tx_keys_active(const struct mlx5e_priv *priv)
+{
+	return false;
+}
+
 static inline int mlx5_accel_psp_fs_init_rx_tables(struct mlx5e_priv *priv)
 {
 	return 0;
@@ -74,4 +84,5 @@ static inline void mlx5e_psp_unregister(struct mlx5e_priv *priv) { }
 static inline int mlx5e_psp_init(struct mlx5e_priv *priv) { return 0; }
 static inline void mlx5e_psp_cleanup(struct mlx5e_priv *priv) { }
 #endif /* CONFIG_MLX5_EN_PSP */
+
 #endif /* __MLX5E_ACCEL_PSP_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 112926d07634..98941088d100 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -42,6 +42,7 @@
 #include "en/ptp.h"
 #include "lib/clock.h"
 #include "en/fs_ethtool.h"
+#include "en_accel/psp.h"
 
 #define LANES_UNKNOWN		 0
 
@@ -2387,6 +2388,13 @@ static int set_pflag_tx_port_ts(struct net_device *netdev, bool enable)
 			   __func__);
 		return -EINVAL;
 	}
+
+	if (enable && mlx5e_psp_tx_keys_active(priv)) {
+		netdev_err(priv->netdev,
+			   "%s: PSP TX keys are active, TX-port-TS cannot be enabled\n",
+			   __func__);
+		return -EBUSY;
+	}
 	MLX5E_SET_PFLAG(&new_params, MLX5E_PFLAG_TX_PORT_TS, enable);
 	/* No need to verify SQ stop room as
 	 * ptpsq.txqsq.stop_room <= generic_sq->stop_room, and both

base-commit: 3bd438a58e910db5dc369aa25dfed1fc95f1b596
-- 
2.44.0

