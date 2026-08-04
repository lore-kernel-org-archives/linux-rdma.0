Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012026.outbound.protection.outlook.com [52.101.48.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43AD442B07;
	Tue,  4 Aug 2026 08:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785832721; cv=fail; b=MDWQ7DIqSAsxwcqOIvWOmknOyeUjhXvFT+izgCdkttuMHNA0QPJ1aX5fJPERIC4x32lzEGDIqZvKE2FV3LbDL10ztWN7k9HRzSOlJl6RasnM6I/svk0tB6HwJwv9VMwDK2v2/R0IOfawYaoQ9qojvo/8qOGGj66+E1PqrDsOFuQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785832721; c=relaxed/simple;
	bh=ri0NZ/oP0WLmD58TRrAZQL2y84HAeMjOXAvqLeScg4U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MJXmvzNbCh2Wwaka+ksMGjApaFK8fyL1ul0BA7EMozMWrcKQo2N7qNveK+se2hI0i3x08bqaw5YQL22AeU+ECPbted2QdFVax9qyUSMtrwuXQ29QGel8tGbInrsi72EeUGcWfy2j1SxuySLCaBfMqwspO4Djcai/K3yis26wlQs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dVbxQbSj; arc=fail smtp.client-ip=52.101.48.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dVbxQbSj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VopCDr9vmU2dfN2BsLRFAlLqvlzr5vAep+FzBEhaL9mV/xUEQn/nKWOef6rKLC3Vwnb3YQELaz75wB/yARLyVa34/LTagRkBGKV9HKjhU3zrl4zKGg9rLzBmstPEw0mPk3ui+koUtSs7sffcvCHcYcD/kin8guAHjlt8zVREPHkVQIRsVe8h9o9GMa/R4VT6nzayHbmXFIRkhz/t2lJtXLMo+JWuT9O6tiEkA39BfWy4Q+bB5RKM4h4tn5Sx+q+BN9lGGcI7UbS2QtDmYB+0TjT/BsM554whkCeFysU4ySfe9ch8mwScBGmi0Ws7t7qnPoU0cEYjY72L5a8vg64N+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VBACNLZYKBPceRl2Mwzb9g0F3IhZY/Q3yRssXECEbQU=;
 b=oK5I29OIOEuyqYCiXShqL8beZzuSBQDhjilKE/GXKWbiPNVSO9bel9ijJPzvjgJb3xQ9HfjyQFsYyylZ3YTf/Ct1sD7eu0wWV+b4cwHNFbsLU0QeTAVLIFdDPN8VBGrLieI0jLHjLfca6CWMKyHN42U+pgmuF9B/Cwtcsdw8DRGXNJ8IKnU8QQWnJJ9xnLm9pL4waga2WeuiUICxH/uD1SWA4plcWpOM8wNugSvzInSJ8lo5blDw1jTJow2uMlGGL4ic4m4vy47fXCx5diH5YE7qwWejdQqWuTn52mC0uw7ZAp1P5Y6jeCr+UR80Fkv2ywu0+f+gsHlYgZt5GcJOWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VBACNLZYKBPceRl2Mwzb9g0F3IhZY/Q3yRssXECEbQU=;
 b=dVbxQbSjyWQQTe8sb87DydigbvMzetI8wnVt43yxWnzz3Hhqu5cBITcPfxz32IcKTsGf6Ef81Yk9/hIn/lZ7SybIhjreBbjYja4vjAMkh5o+LgNFLVHbSXsONbY8FXgyGPMOOgHIV/WCb/647g4Oum2UiAZXg5dmtH+CYiApkOlK2m5Ik5MfGDzJwUbU1Ab6VN7xuVLjcutbkJ5jLJ6UjoAWYvcMzL2K8c6Jp9i/8hsMBBR7viVGdewEyW8Juhwpa+kXwDa7WRmjqbfx3d49UtxEwNV5yqVybitLO3eCE+qqOHXG23adcEXT+mUjDiiMND8G6cMLgfyo73rG/9Bmhg==
Received: from PH8PR20CA0008.namprd20.prod.outlook.com (2603:10b6:510:23c::18)
 by SJ5PPF01781787B.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::986) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.15; Tue, 4 Aug
 2026 08:38:29 +0000
Received: from SN1PEPF000252A4.namprd05.prod.outlook.com
 (2603:10b6:510:23c:cafe::11) by PH8PR20CA0008.outlook.office365.com
 (2603:10b6:510:23c::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.15 via Frontend Transport; Tue, 4
 Aug 2026 08:38:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SN1PEPF000252A4.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Tue, 4 Aug 2026 08:38:29 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 4 Aug
 2026 01:38:16 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 4 Aug 2026 01:38:15 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Tue, 4 Aug 2026 01:38:08 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>
CC: Aleksandr Loktionov <aleksandr.loktionov@intel.com>, Alexei Lazar
	<alazar@nvidia.com>, Boris Pismenny <borisp@nvidia.com>, Carolina Jubran
	<cjubran@nvidia.com>, Chris Mi <cmi@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>, Doruk Tan Ozturk
	<doruk@0sec.ai>, Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman
	<gal@nvidia.com>, Jacob Keller <Jacob.e.keller@intel.com>, Jianbo Liu
	<jianbol@nvidia.com>, Kees Cook <kees@kernel.org>, Lama Kayal
	<lkayal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, "Patrisious
 Haddad" <phaddad@nvidia.com>, Raed Salem <raeds@nvidia.com>, Rahul Rameshbabu
	<rrameshbabu@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan
	<shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Simon Horman
	<horms@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, Stanislav Fomichev
	<sdf.kernel@gmail.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next V2 11/13] net/mlx5e: psp: Dynamically reconfigure based on SHAMPO mode
Date: Tue, 4 Aug 2026 11:35:33 +0300
Message-ID: <20260804083535.2946459-12-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260804083535.2946459-1-tariqt@nvidia.com>
References: <20260804083535.2946459-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A4:EE_|SJ5PPF01781787B:EE_
X-MS-Office365-Filtering-Correlation-Id: fe98bdf3-2aca-4793-0b23-08def203c278
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|36860700016|23010399003|376014|1800799024|56012099006|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	5lHatwGlpvIdEDZgQiPRar4B+wQ/LEY5y05U+C7hH7c4t72H7Al8fnGVYYJ2QRSjBL8qsITXx5RgzdXo+zi3MyiVMiGi8TCufsM5GQLzZrCKTthNNJMzeUT0MIJww3oJM986B39RTunimyfgLmb7/kXspf85RYGPJkIet8JTs5PuBfyfELMGLKKyzb/rfEdR7QxWrd8yMjI+ci0In+n07Ut4GQVHsN9RRL87x5X/wPfbqTUUKX6oAZMiJKYPPl6+9dN8FmmBHrZzKPctP23hDkGg6AFO6iuEX5LCIUJAdhcz1dNKoh7M//VOvBpTIKwss+azfwJ1Gi+LxgwTBb/oO+ban9nU+jeAeCw5LzqI/tFdeHL/uVpiqyORW+inWqpurE9eHmDsiSp/KAXPzsaXB9rEjvBqpqlRNJLn9HpUQ8keNqqFG0Zgp0PpEJXloTdvK35q+K+m+RUMMQiO50xGR2lO46MabuCLtPrT8ejMng5uC96pAkQ2yfGam4J4xDn4Og+D4pO9pda2Dl9DsfHmdtICMsMZqNfuPh2Te3/dOPhbfGwlJeXtmW7pfyvCzCQoJFQB1111oirS4IOdYoZMODCLOnB204lqKI0Kc8ChweMGyPe9mADhyMTVS8e3KlCyYe/u0o3LLVesn7vz6ZSf6fTZSHOz1a0GnHf6ulysnxm78KaZlx8xScNb1V+8m3hOuLm8T0q/HXt3ZYB9nAwpLw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(36860700016)(23010399003)(376014)(1800799024)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	VumWMBx0z3wZZLiHzyh4PewhPtZsL0Ap1JgOqGY1ALcPUMRJfGgbs/rYANs5K85VIpAtU7zOOZO0mDngTiCl9mWzOzLnPdpVbrkB2hvjBOCDdZ4UBSZmDaKGj7rftR4L9CBxan36zThGm2JAEfMfqzxA/UI6spCLm2MWfHV8UztwAbAYC/Wee05hHJPfbgyVxE69X1fuKz1I980EwGY32FwwGTK0CjCni6EJ0TpLDRkb5yXOK3ikVxKLM4yXPdOj7AWriuuHA0uAA1jE3bo2vq6vI2r95K3z1g2fCxIUM2M5/SC6IBa5lZBfKaxIk/3mPdbxqeL79m8ejXPmwKVBsAaqKrud7pjUIeJ1UGKzuT/vgztIGUJq6s+hmOhntb1qEeVCt/3/krYpw/9qSP3rPdRCTbp4Prjz5XW+3HUBtLKW6DEUZoxcpF+yvp4bt+tf
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 08:38:29.3300
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fe98bdf3-2aca-4793-0b23-08def203c278
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF01781787B

From: Cosmin Ratiu <cratiu@nvidia.com>

Add an mlx5e_update_nic_rx() -> mlx5e_psp_update_rx() hook.
This allows PSP steering to reconfigure when netdev features change.

When this signal is received, toggle PSP between standard and
decap modes when SHAMPO mode changes, optionally creating the decap
steering table.

The toggling of traffic is atomic (a single steering rule update), so no
packets should get eaten/lost. It is probable though that the rxhash
will change, and decapsulated packets will be received by a different
core than before. Established PSP connections receiving traffic might
experience reordering/retransmits as a result.

Also enable decap when configuring the device if the mode indicates it.

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/en_accel.h    |  9 ++++++++
 .../mellanox/mlx5/core/en_accel/psp.c         | 23 +++++++++++++++++--
 .../mellanox/mlx5/core/en_accel/psp.h         |  2 ++
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  8 ++++++-
 4 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index 8a2ea7616440..a0bb19cc956d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -251,6 +251,15 @@ static inline void mlx5e_accel_cleanup_rx(struct mlx5e_priv *priv)
 	mlx5_accel_psp_fs_cleanup_rx_tables(priv);
 }
 
+static inline int mlx5e_accel_update_rx(struct mlx5e_priv *priv)
+{
+#ifdef CONFIG_MLX5_EN_PSP
+	return mlx5e_psp_update_rx(priv);
+#else
+	return 0;
+#endif
+}
+
 static inline int mlx5e_accel_init_tx(struct mlx5e_priv *priv)
 {
 	return mlx5e_ktls_init_tx(priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
index 37635be7346b..ad8dbd8c2f27 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
@@ -92,6 +92,12 @@ struct mlx5e_psp_fs {
 	struct mlx5e_psp_rx_table rx;
 };
 
+static bool shampo_enabled(struct mlx5e_priv *priv)
+{
+	return priv->channels.params.packet_merge.type ==
+		MLX5E_PACKET_MERGE_SHAMPO;
+}
+
 /* PSP RX flow steering */
 static enum mlx5_traffic_types fs_psp2tt(enum accel_fs_psp_type i)
 {
@@ -766,6 +772,7 @@ static void accel_psp_fs_rx_destroy(struct mlx5e_psp_fs *fs)
 }
 
 static int accel_psp_fs_rx_create(struct mlx5e_psp_fs *fs,
+				  bool decap_enable,
 				  struct netlink_ext_ack *extack)
 {
 	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(fs->fs, false);
@@ -807,7 +814,7 @@ static int accel_psp_fs_rx_create(struct mlx5e_psp_fs *fs,
 		mlx5_ttc_fwd_dest(ttc, fs_psp2tt(i), &dest);
 	}
 
-	err = accel_psp_fs_rx_reconfigure(fs, false);
+	err = accel_psp_fs_rx_reconfigure(fs, decap_enable);
 	if (err) {
 		NL_SET_ERR_MSG(extack, "Failed RX steering config for HW GRO");
 		goto err_decrypt_ft;
@@ -1081,7 +1088,8 @@ static int accel_psp_fs_create(struct mlx5e_priv *priv,
 {
 	int err;
 
-	err = accel_psp_fs_rx_create(priv->psp->fs, extack);
+	err = accel_psp_fs_rx_create(priv->psp->fs, shampo_enabled(priv),
+				     extack);
 	if (err)
 		return err;
 
@@ -1358,3 +1366,14 @@ void mlx5e_psp_cleanup(struct mlx5e_priv *priv)
 	priv->psp = NULL;
 	kfree(psp);
 }
+
+int mlx5e_psp_update_rx(struct mlx5e_priv *priv)
+{
+	struct mlx5e_psp *psp = priv->psp;
+
+	netdev_assert_locked(priv->netdev);
+	if (!psp || !psp->fs->check.ft)
+		return 0;
+
+	return accel_psp_fs_rx_reconfigure(psp->fs, shampo_enabled(priv));
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.h
index 3f441e7dd55a..76f6c69de0e9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.h
@@ -49,6 +49,7 @@ int mlx5e_psp_register(struct mlx5e_priv *priv);
 void mlx5e_psp_unregister(struct mlx5e_priv *priv);
 int mlx5e_psp_init(struct mlx5e_priv *priv);
 void mlx5e_psp_cleanup(struct mlx5e_priv *priv);
+int mlx5e_psp_update_rx(struct mlx5e_priv *priv);
 #else
 static inline void mlx5_accel_psp_fs_cleanup_rx_tables(struct mlx5e_priv *priv) { }
 static inline void mlx5_accel_psp_fs_cleanup_tx_tables(struct mlx5e_priv *priv) { }
@@ -61,5 +62,6 @@ static inline int mlx5e_psp_register(struct mlx5e_priv *priv) { return 0; }
 static inline void mlx5e_psp_unregister(struct mlx5e_priv *priv) { }
 static inline int mlx5e_psp_init(struct mlx5e_priv *priv) { return 0; }
 static inline void mlx5e_psp_cleanup(struct mlx5e_priv *priv) { }
+static inline int mlx5e_psp_update_rx(struct mlx5e_priv *priv) { return 0; }
 #endif /* CONFIG_MLX5_EN_PSP */
 #endif /* __MLX5E_ACCEL_PSP_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 3b9d42c7e9c2..3c6ef500d0fb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -6286,7 +6286,13 @@ static void mlx5e_nic_disable(struct mlx5e_priv *priv)
 
 static int mlx5e_update_nic_rx(struct mlx5e_priv *priv)
 {
-	return mlx5e_refresh_tirs(priv->mdev, false, false);
+	int err;
+
+	err = mlx5e_refresh_tirs(priv->mdev, false, false);
+	if (err)
+		return err;
+
+	return mlx5e_accel_update_rx(priv);
 }
 
 static const struct mlx5e_profile mlx5e_nic_profile = {
-- 
2.44.0

