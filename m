Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011010.outbound.protection.outlook.com [52.101.62.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59522E719B;
	Tue,  8 Sep 2026 06:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788850509; cv=fail; b=lBPS3kzgA8JP1ys+Kmsl0K4umjXrYTOFrfdy2uyzaT/SbFFtDUl7nqxwqlfjyDmXsflC8xCCOIvq0IP0K/b2h+mF6TYz0ZntF0DHb4ItldIHBMYF0ScG8Vrret0FMxKNlWoDfzMyYi7m3ne5f79tCRcfizPh4CeB3AscVe2kIno=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788850509; c=relaxed/simple;
	bh=CX9T/Lo5qcKEw2zNVpisTUWqU6m0Jrx383ZmHgJbGOU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fTiFeqWqxUiw5ND9LjEpF0YzyxbyfoakpddDywNflXoHqXshokBsTBXDIPQsjPpkjL0qImVGXVDPgAWSK/ODVTs9Xp3weYMqAKf9sd9pBsWgkDhgQ2dKvO0+95ldqCcx3Ue62H2GIyTmAPLyOGkcel4dx57tU/4kQqaIFxdKDtY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nzrmqVnG; arc=fail smtp.client-ip=52.101.62.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nzrmqVnG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D9sEt7f/p8Wbgv4lgZy+lkKu403k15gvLsCT0Np10ogorVPuHXPaEDo0ED69fYWLn5oygXOIFq4Gc1QBeNRE5ZBPQ86NYvoYiM066AfZs3uVREwLUVZidvXPLeXITYXKux7Qajzw/+EjuGtlsrdPDB/Hk71i+0+lAerjaLY0cliBmvSficktuSOOLNoELCK+LFqQFlfJ4lRI25e3rKtvKvze26S+9e50R4cWQggC2l+wBzE0+B3FGoZ7Gz+ixWseddAMdQy/wVUlCmQNEBLy+90oxCMCuav2Hhnmk04giRM3GjUgB1eggFw2Afq8+OLIu4J4vqmfrx8oevdbh8tDjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iNSZKl+BLCp9hJ2K3pSkvo2oJbNQ3+Kaj3aeUNoBIqc=;
 b=ksAc4mEu4ZPZVBo/tnMvWE0NslmcegkpxPVNbPp6ON4ck/Mc/TOSOq5yp3rs8XKYJkcorZHdiS+VFnDySsZgKq7e7a6LclyiqjYvtldb4AWjzMbLGMtYDTe6qcdiwas//AZ50zhhDnAx7gLTd2Zb76inne5PZQ8/axNZeODKhdURDIMUZw6tS0QiHi+hJqK/Y6e1jUfZy+emISY1PijR+GJigQSaK6oQ6sIZNtq6FHWKThdQvLHZpCyeYZqA4Xdsry/kFHMYZUbiydvzbWyJbH98fWYyumppvFyQCfTw8Wrs1PqjS0OOlOga8k+XrrXP15ekNF3aFsAjgSbz8H323A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iNSZKl+BLCp9hJ2K3pSkvo2oJbNQ3+Kaj3aeUNoBIqc=;
 b=nzrmqVnGKZ/e638kr1NEj2nes0bUzPdI1TRH0QFPpLsBtskolN6xCG9+i4B7324BtiftsBDbV0beoaEt93RHr4VyJIvmgpqw4sodOl1IMpeRQF40ewEYYfLsrl+rBs9/IBVLudru3wMXf0y+vQPdwRqC2kWHiEkI0lslH6WowS7SRZ7/r65mZ2DefoOYHs2jSsO+GERRBJyesVfh9apeMvA3HfJZxgiDeoblA8823BBcaYUUIfPP8sDYHEwccirCtRZEUtcMbgQInXO90LUF3WG2ByrPaJEpHvQI2rmA6YiD9Gvs+Ok2cZtBxS3YGJxnbCqwQcpyEra9svj6aqXpdg==
Received: from BN8PR04CA0062.namprd04.prod.outlook.com (2603:10b6:408:d4::36)
 by PH8PR12MB7206.namprd12.prod.outlook.com (2603:10b6:510:226::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.14; Tue, 8 Sep
 2026 06:55:02 +0000
Received: from BN7PEPF000000AB.namprd05.prod.outlook.com
 (2603:10b6:408:d4:cafe::7e) by BN8PR04CA0062.outlook.office365.com
 (2603:10b6:408:d4::36) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.7 via Frontend Transport; Tue, 8
 Sep 2026 06:55:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN7PEPF000000AB.mail.protection.outlook.com (10.167.245.235) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Tue, 8 Sep 2026 06:55:02 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Mon, 7 Sep
 2026 23:54:48 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Mon, 7 Sep
 2026 23:54:48 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Mon, 7 Sep
 2026 23:54:40 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>
CC: Bobby Eshleman <bobbyeshleman@meta.com>, Boris Pismenny
	<borisp@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>, Doruk Tan Ozturk
	<doruk@0sec.ai>, Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman
	<gal@nvidia.com>, Jianbo Liu <jianbol@nvidia.com>, Kees Cook
	<kees@kernel.org>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Petr Machata
	<petrm@nvidia.com>, Raed Salem <raeds@nvidia.com>, Rahul Rameshbabu
	<rrameshbabu@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan
	<shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Simon Horman
	<horms@kernel.org>, Tariq Toukan <tariqt@nvidia.com>, Willem de Bruijn
	<willemb@google.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH net-next V4 11/14] net/mlx5e: psp: Dynamically reconfigure based on SHAMPO mode
Date: Tue, 8 Sep 2026 09:52:41 +0300
Message-ID: <20260908065244.3799142-12-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260908065244.3799142-1-tariqt@nvidia.com>
References: <20260908065244.3799142-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN7PEPF000000AB:EE_|PH8PR12MB7206:EE_
X-MS-Office365-Filtering-Correlation-Id: aa2693ec-9d01-4585-a719-08df0d761b7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|7416014|82310400026|1800799024|376014|10067099003|18002099003|22082099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	LB9RMwsa9Gx2TGAn0YjYC6SV0zGhvAzUsJhm6LsQuiHw2wd0+KiVF6vpl8XRNwTGgR6+M3RJnzDd+oBWCqXacQe2t0yHDZxN1J53GJcqjISazgBD8UE50AQygVE1F8JFXqvA5zkAF39PpFyJcUxEB8JNz/Mj3HJPiiQhudZMxHwKSSp6vgvgwS011byKLU9nW3uPTTD5RkKQorbDtqON2IgO0fbI4l51T23BpIhl07lKUkfRvmhYSIsuOI9X2EnVj5c675yZohZ7/hCdn/PtiBrYoGmlJJuyG2sobjCWBsU6vOyzw2fSeiu9vZSra+9yzkYv7VDkrMNX6fzg+6xp0kH47tfmUfkdvhe9mOc7AMDLPylf6fCIToihR0n/Pnea0e3TfyopluaPVa8DM7EFQ+6wbpKggkpu891ts4NQcC3voGPkDNJ2ffX9h/iGkT4ibfvIgI8EHw6SAdvSc7HGQcgvKtmYBDOxgaK7dX3LGQu2oS0s4dmgTjD7JCtmk8LdniVJ7mG+S7F+jJfuRBJncvIJpq4VRtNMjgDHjJj6HyiSqwUhPyFos2YkkE+zueYcrtJxDvAQ+O0pTnvGhKjHyYzvVSguXZ5KANRiDV35QGHpXnJddk5JJrdgMILTY3y8BGXut5T6DleSXcYTip45WvVs6GyRq5VVeEzvo1jj8UwbkatJGDBYdTbmV9MPYk5nMDK4P4O68f1ugs7M7195jA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(7416014)(82310400026)(1800799024)(376014)(10067099003)(18002099003)(22082099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	PQRZ36m0LiuxhOHDUX2B1RX4z1Q9GplYHWLdck4+Xpb//muol/JuHVSeizfy10r/8ULYcJ/Z+FHOn+cOOtyY2nUgecsYIIfadKPxEM0IEmxyFCbmVsbKhSEgbRq4A4GNjUhuPmoxfpAqa17XmT6kfx6afRteG++uOVtsrjpbDm+qTyaPf5ymvkmiacvZ2w5Fb2BAnYuvJtgbSJL7GbgMayF1TPFfZ2+CpFQ/EOGV8Ygk+0dhTDQ3awIj3ppk3nA7ge3sFq59qjDMw/ZhxTI+DAt+Z2ygXMoVj5KAE5usp6UfrtINomx0Dwi8uTCSRrR5A+XG50q/rnWEsuxzPVHJD4iJyOIq1oykU6xJh/wQ0UwuPoZlFCY+3QDLIj7R3ABdJZnljxizZuWkhNE+lJ3n0pqhBR6+yckK+0+WAxwlpYl02qsfZIwb0MV1K0VbdzD4
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 06:55:02.6363
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aa2693ec-9d01-4585-a719-08df0d761b7c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN7PEPF000000AB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7206

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
 .../mellanox/mlx5/core/en_accel/en_accel.h    |  5 ++++
 .../mellanox/mlx5/core/en_accel/psp.c         | 23 +++++++++++++++++--
 .../mellanox/mlx5/core/en_accel/psp.h         |  2 ++
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 10 +++++++-
 4 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index 8a2ea7616440..98709d48b801 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -251,6 +251,11 @@ static inline void mlx5e_accel_cleanup_rx(struct mlx5e_priv *priv)
 	mlx5_accel_psp_fs_cleanup_rx_tables(priv);
 }
 
+static inline void mlx5e_accel_update_rx(struct mlx5e_priv *priv)
+{
+	mlx5e_psp_update_rx(priv);
+}
+
 static inline int mlx5e_accel_init_tx(struct mlx5e_priv *priv)
 {
 	return mlx5e_ktls_init_tx(priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
index 84133cbf8689..c40d2ddf6af2 100644
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
@@ -767,6 +773,7 @@ static void accel_psp_fs_rx_destroy(struct mlx5e_psp_fs *fs)
 }
 
 static int accel_psp_fs_rx_create(struct mlx5e_psp_fs *fs,
+				  bool decap_enable,
 				  struct netlink_ext_ack *extack)
 {
 	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(fs->fs, false);
@@ -808,7 +815,7 @@ static int accel_psp_fs_rx_create(struct mlx5e_psp_fs *fs,
 		mlx5_ttc_fwd_dest(ttc, fs_psp2tt(i), &dest);
 	}
 
-	accel_psp_fs_rx_reconfigure(fs, false);
+	accel_psp_fs_rx_reconfigure(fs, decap_enable);
 
 	return 0;
 
@@ -1078,7 +1085,8 @@ static int accel_psp_fs_create(struct mlx5e_priv *priv,
 {
 	int err;
 
-	err = accel_psp_fs_rx_create(priv->psp->fs, extack);
+	err = accel_psp_fs_rx_create(priv->psp->fs, shampo_enabled(priv),
+				     extack);
 	if (err)
 		return err;
 
@@ -1355,3 +1363,14 @@ void mlx5e_psp_cleanup(struct mlx5e_priv *priv)
 	priv->psp = NULL;
 	kfree(psp);
 }
+
+void mlx5e_psp_update_rx(struct mlx5e_priv *priv)
+{
+	struct mlx5e_psp *psp = priv->psp;
+
+	netdev_assert_locked(priv->netdev);
+	if (!psp || !psp->fs->check.ft)
+		return;
+
+	accel_psp_fs_rx_reconfigure(psp->fs, shampo_enabled(priv));
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.h
index 3f441e7dd55a..43571a039ea6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.h
@@ -49,6 +49,7 @@ int mlx5e_psp_register(struct mlx5e_priv *priv);
 void mlx5e_psp_unregister(struct mlx5e_priv *priv);
 int mlx5e_psp_init(struct mlx5e_priv *priv);
 void mlx5e_psp_cleanup(struct mlx5e_priv *priv);
+void mlx5e_psp_update_rx(struct mlx5e_priv *priv);
 #else
 static inline void mlx5_accel_psp_fs_cleanup_rx_tables(struct mlx5e_priv *priv) { }
 static inline void mlx5_accel_psp_fs_cleanup_tx_tables(struct mlx5e_priv *priv) { }
@@ -61,5 +62,6 @@ static inline int mlx5e_psp_register(struct mlx5e_priv *priv) { return 0; }
 static inline void mlx5e_psp_unregister(struct mlx5e_priv *priv) { }
 static inline int mlx5e_psp_init(struct mlx5e_priv *priv) { return 0; }
 static inline void mlx5e_psp_cleanup(struct mlx5e_priv *priv) { }
+static inline void mlx5e_psp_update_rx(struct mlx5e_priv *priv) { }
 #endif /* CONFIG_MLX5_EN_PSP */
 #endif /* __MLX5E_ACCEL_PSP_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index fc110a7d16e8..b5449d849838 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -6288,7 +6288,15 @@ static void mlx5e_nic_disable(struct mlx5e_priv *priv)
 
 static int mlx5e_update_nic_rx(struct mlx5e_priv *priv)
 {
-	return mlx5e_refresh_tirs(priv->mdev, false, false);
+	int err;
+
+	err = mlx5e_refresh_tirs(priv->mdev, false, false);
+	if (err)
+		return err;
+
+	mlx5e_accel_update_rx(priv);
+
+	return 0;
 }
 
 static const struct mlx5e_profile mlx5e_nic_profile = {
-- 
2.44.0

