Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011036.outbound.protection.outlook.com [52.101.57.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0497409103;
	Thu, 30 Jul 2026 09:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785403214; cv=fail; b=NnBUa9YoThAZlLDGOMfZuj7YYMxLpHIC3jv1z/IXQU0C0A2L3fvepFJGwuVSEQdzuF0RkJjoUFGRhe7WXYlAxwWtkToBwmUWeMD5iupwyqKBPAyWd112CaBGNhbcJU2PVIU8wop/SGbQ9fnfP5U86CUq7l7Abju7mn4opnL3ItU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785403214; c=relaxed/simple;
	bh=0AbbskDKiafNAhkmoOpBS0anyUngBkfNM16NpaYbc2s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bMAkbXwZTbooNRANvWuu/BF/BWfLq5REcCbR6kG4giwvRVs/QANob7BvIFetzrKAKhM+r3Jp+tsjtOUdfx7M9uCrSL5h9A3pQH8/MnRpc/Lw3XrfCLV+BTIdbj14QHwKenNvr0iotbapXvdTvNcRUCy9F/69oVBHMMe9jrwIvyI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=B2ergrta; arc=fail smtp.client-ip=52.101.57.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="B2ergrta"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kXSNetBp7VURJrH7mKIYe9TuQowFLTD95M1iYQQlMHqBgS1O8dsIh9n++bp7TyFDyQyUVP+y2+Rj6iYzt+4TUadltjphtJAXMo/bhNEbWAG5P8JToRP5j1r2BBG6wv8XwAhWLbUasfkL28wQpwp0HvlF3VyPHtg33/SBqJKZt4qHGOqtMK7M29pr9OOseZgVQ0Iq3ONqXmuqEiorj1uwbGq1IFSn3KTjk9XKd6w4dyYfUh/07oZd4ublbXz3QC2UNKuRlRmsHWxQXIGMmid8kZ0Q5IW8Nq/+VvWonXDUExKe3EuC4h9mzNyzbrSnGG5kr4Mdov7Qb+Ac4vSMH8M4Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Msw+qMf+iZaTLLyiaIb/D7Fc3QFxtER/T+e5lgFLDwM=;
 b=NQS0rvGb5yEj/oIwUxdb+/rxoalrewnguyj1bE3vnUUXVpOROkTO0MF04anMJuM5Hy/OwdWK5n5ZAQP3oD84RBlTKpz2pkk4KKvIXNP7kj3Sik3no/vuvHKsSEIih6JMk0CHr3Wccu6K/qXXM2hRmfbArcavn5hI3CWDS81ppXXjoRDDgZwgl0jYeWRiL9E5V3MsuhG5crEgZHA65DY9hqKUDbcvkcn3G9I1vmCV3pdn2SC+jvkmj5sbrX7rayDMEAmOpayOB7bgOoKZ9oTbzaQaZ1ckNUJikrDjmTB8E3gPwrbO0B+tc3K3wpppHCLrISko5NYFVQrwslzAj1jeeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Msw+qMf+iZaTLLyiaIb/D7Fc3QFxtER/T+e5lgFLDwM=;
 b=B2ergrta/kBHz0iH3es/pgDRmbZFWhIIJ2i8HQlb4UBHfXqNJ9N12nSb3FURUqeXOQUqyIE9GXDrmS2p4HNxEHz5rX7dKdlGmxxWkn5tTS/qW26nycDxJrJDVfvsfbc6TxoI4KB8G52t1P/+BAxddFUKofbM+d+kfxWNyEiXhgmA/93tYV65WWdkpCQOcAUmOpk3UOWJzTXT44Tvqr5JypVdKk/MylWDYtrbjC2DVMjplEiaMvRfD6bqWZVTEFGH6VI3MNkjQ8yGg1oQL40kgoh58QQ7Jkfi+9yhsEDKIIXrXg2Za5bt14RQCBrLSdTEyoZjhdwW4akE4WSPDtU9SA==
Received: from SJ0PR03CA0277.namprd03.prod.outlook.com (2603:10b6:a03:39e::12)
 by PH8PR12MB8431.namprd12.prod.outlook.com (2603:10b6:510:25a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Thu, 30 Jul
 2026 09:20:07 +0000
Received: from SJ5PEPF000001CC.namprd05.prod.outlook.com
 (2603:10b6:a03:39e:cafe::73) by SJ0PR03CA0277.outlook.office365.com
 (2603:10b6:a03:39e::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.13 via Frontend Transport; Thu,
 30 Jul 2026 09:20:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001CC.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Thu, 30 Jul 2026 09:20:06 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 30 Jul
 2026 02:19:53 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 30 Jul
 2026 02:19:52 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Thu, 30
 Jul 2026 02:19:44 -0700
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
Subject: [PATCH net-next 11/13] net/mlx5e: psp: Dynamically reconfigure based on SHAMPO mode
Date: Thu, 30 Jul 2026 12:17:53 +0300
Message-ID: <20260730091756.2543777-12-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260730091756.2543777-1-tariqt@nvidia.com>
References: <20260730091756.2543777-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CC:EE_|PH8PR12MB8431:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bfbbf0f-1b89-4acd-7d02-08deee1bbefb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|36860700016|376014|7416014|82310400026|56012099006|10067099003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	vfGc8QiMTN9BdLRDSltcYIPwXOtsUx6WdDO+Gj8nv/vgyszvQ3qO6OUOAhuwXnxgoDUwWpXaCVLa+iCQNHYAHHNVru19hSgyZI7CHSEw3dZIc/k47Jt43/Xqr+rixTjaUunnOVYBqU2b1Mf+SayPv/scf6/Bwg5dfW907446xFv4CM7t7B3XYg2Laj4rp3iYJz4To5pilJfmZUZjIIgFuBR1dolHi/PIXh3DfsifiQM0SEwoOu+lKpjIBgQsqBCz9+F651ObVwXhH6QSPIq0D4oJ2PBNkpf4BYJgY9bwgO8+pIGls44yrYxwDC7PuNDi7Y6hm/IgfBZwRPgnuoikefG2+VY29/mh4eHcNNZaSpjrW2sluLegf4OvKQ0yioyDnGGjAzxDHq6UBxGxhI1qrPNEnqFrQzilSJkeNlboLD0GMd1caEPj/CLIQBk1PL9bHTSjJjLw1D2RZ7A+GFSPrUi4fEfrV7TY7TsKHXjcv0dgFPytmW+n1iFBWBQozJFBvaf8Rff74SDfP0SZRhExidycbhLfK5We0tWt5QCj3aRXqniG8R5ADwB4FkkhK2+Lyc346IWBle9OpyWZG2pEtGH6s3sIfb4s1ySwsdmuzXlnVvWX3Ps7LV33bUMU7npbO0dy8SWTWuMql9R+I655eaa4zdypoVMToUHgcJEUegNigXGCXQOh6TlC7jIU6xPVa+Ug2rcCWiDSdUrz4RTU/g==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(36860700016)(376014)(7416014)(82310400026)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	4NKplmDPpqz7N8/RyyXZO3T/TKC/9UJnDm5U4/2TTlSMNtPHA8pLLqV70hqlXPSuOmxu+34BjYtq4Ig/2jpf17x9kTJfo++BHDUp2Te3SXLbHoKu5/yxSMo9y5CfI9I4BEdS7NlWl4V7OSFqM8N4EiIBHDINAR3ips6GSKDO+6HkgYrwpD8YzOKP5v8fweqMEKMpaD/vYGGKf+bkMjJKbu6uWT+pKHaWTYzwz7Q+D3RxBd3ge90TtTP2k2hob0yBpem360pnzrFyfqre1agWtSea0mKVia3TBDP+XE9IhvhddkqZellmgo3Ak0zJ/Y0PnWTbTcVCeKCiNmIw5JLCwfubR/oUzQzeAFIt8AcY9aZBDuL0/xydXnCywTM2ZgH05tz2wF5znFJT5+qZwIVBgo14qGnkP2bCsNl47ovq3zl6gYt6RaapZCoh7hJBOHO1
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2026 09:20:06.8587
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bfbbf0f-1b89-4acd-7d02-08deee1bbefb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8431

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
index 4a8351f95b27..e8b4b9cc7dac 100644
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

