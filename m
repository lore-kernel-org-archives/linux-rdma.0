Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011010.outbound.protection.outlook.com [40.107.208.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9304756C7;
	Thu,  3 Sep 2026 08:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788425745; cv=fail; b=m3Qrue1mHEd01P1qt4UsPRwMOvCSyPctOjPGhpz5D94ZbndcS0kmaZmDopFko3JRRS7dmBIi6YOQgS/c/hPfsPlG2JP7TZ4aexiF/1BBIZOkbWICXImv+i3BDOdzJxjjpm1IcpHt+4II/5RuFOtOQ7lL/IK8yTmxNcbXWJ6Nqdg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788425745; c=relaxed/simple;
	bh=CX9T/Lo5qcKEw2zNVpisTUWqU6m0Jrx383ZmHgJbGOU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W+JkfTCnURzlLHqyPfagbSrYTMuFfnxxhVgpWoh3wpxK6jjD7JgZyB409srFX8j9GGJgFL/cyYUgjJG7Pi6P8NBxSXhXO0PpTMut7ImVd7NlQ9o56/ADbc2o9TlrEhVW87kztfuJ5E7Xpk078WfKYrfeQ3xhvbM5Sh7K5K6hz3o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sKOfOjqQ; arc=fail smtp.client-ip=40.107.208.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sKOfOjqQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NHiPkPo8Y1KPPN3N3pNbgvyW8X0yKfm9d2fPLxYuWgIKzbC2NZrng+/ZclcqJL7B8XJ9E5harUZkjK7gL/qoQ2LOPkWoau0cR6trB19OWwg5p6VUBkZeLLcd76osJt6mSqqBTTAoBvYSieDrXb27LS0Qoduc4tvoJzkpqTbDoGNfd8coTkDncGxxIfayPNktPbrMw1YoX1oLV3uCKovw+nAqlUxngkXfWMCvF+STDJip+lmJZBamt4AzHWrN5xbmrPrFwnQFm63l9hng3guYBOA58yjP51bPC5OwlqoOjOEBzrWo8Gf7nC+mR7z4iYp2HNV5dlzZvwZGdfJGn6CkgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iNSZKl+BLCp9hJ2K3pSkvo2oJbNQ3+Kaj3aeUNoBIqc=;
 b=NnI9IPtk+SwZgEVSxNc/st+mxKv5rDy3Kbp2Joc/7w5D0mMCCb/DwYj2BanoMLi8dzZJudtSDuEhmF6Wtg2uPlTWWmqUDaCSF8MM8dda7eghGqYYRJbz32k9r7a2EExOWUXCaevh5RvP1Wi8VWljpEUrYBizC3LjZi/ucYwbTGeNLuJ1g2aW2VlZzUuoRXmlI0HEh3zCG3pAYCvYRA76pUoeAq3PwCR70f3tnbSmV9o8tOezst9my9RQ02Dy4WS+D0Ng6TKu/zIC4pDH0XDKjIxaHJKYTnY2XIWrn+ntpKbbpEo68+yUzFHz7WVZ7XVo323UfSXUjbE69nVpMxjOuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iNSZKl+BLCp9hJ2K3pSkvo2oJbNQ3+Kaj3aeUNoBIqc=;
 b=sKOfOjqQgWUmzFL7hc8AiW2vMOvHE2Fg+82Q6sp/OSEgdrzkDV1dcT6LeHnkGb3SMvXQOYQKwecYnXsv3TQOPm3lAkaZg8NWamByycgr5qYe/s/fIofkJKadxivC3vhYZSAZQjGXZEMuGwaTiC8HTaLZdztz0R/y81epuUXe3NmCmbirPfokyF5FOxUIcjoDS9LGTseoMa8dTDddfL9xN7qGmsXGbd/eFRSLDaaF4bA/2igS3ziYeaMEzK7wPvU4fmFnRXVM8cWAhYC/c1/CBVXX0ty4VuS2I8R7yHqnugQo6UQdUj5oN6SEHpQnIaMrrcDcccQkiBFQaDipStVySA==
Received: from CH5PR02CA0022.namprd02.prod.outlook.com (2603:10b6:610:1ed::8)
 by CH3PR12MB9249.namprd12.prod.outlook.com (2603:10b6:610:1bc::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Thu, 3 Sep
 2026 08:55:33 +0000
Received: from BN2PEPF0000A800.namprd02.prod.outlook.com
 (2603:10b6:610:1ed:cafe::37) by CH5PR02CA0022.outlook.office365.com
 (2603:10b6:610:1ed::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Thu, 3
 Sep 2026 08:55:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF0000A800.mail.protection.outlook.com (10.167.245.167) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Thu, 3 Sep 2026 08:55:32 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 3 Sep
 2026 01:55:12 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 3 Sep
 2026 01:55:12 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Thu, 3 Sep
 2026 01:55:00 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>
CC: Aleksandr Loktionov <aleksandr.loktionov@intel.com>, Alexei Lazar
	<alazar@nvidia.com>, Alexei Starovoitov <ast@kernel.org>, Allison Henderson
	<allison.henderson@oracle.com>, Antonio Quartulli <antonio@openvpn.net>,
	Anubhav Singh <anubhavsinggh@google.com>, Bobby Eshleman
	<bobbyeshleman@meta.com>, Boris Pismenny <borisp@nvidia.com>,
	<bpf@vger.kernel.org>, Carolina Jubran <cjubran@nvidia.com>, Chris Mi
	<cmi@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Daniel Borkmann
	<daniel@iogearbox.net>, Daniel Zahka <daniel.zahka@gmail.com>, David Wei
	<dw@davidwei.uk>, Doruk Tan Ozturk <doruk@0sec.ai>, Dragos Tatulea
	<dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, Jacob Keller
	<Jacob.e.keller@intel.com>, Jesper Dangaard Brouer <hawk@kernel.org>, "Jianbo
 Liu" <jianbol@nvidia.com>, John Fastabend <john.fastabend@gmail.com>, "Kees
 Cook" <kees@kernel.org>, Lama Kayal <lkayal@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, "Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Patrisious Haddad <phaddad@nvidia.com>, Petr Machata <petrm@nvidia.com>,
	"Raed Salem" <raeds@nvidia.com>, Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	"Richard Gobert" <richardbgobert@gmail.com>, Saeed Mahameed
	<saeedm@nvidia.com>, "Shuah Khan" <shuah@kernel.org>, Shuah Khan
	<skhan@linuxfoundation.org>, Simon Horman <horms@kernel.org>, Stanislav
 Fomichev <sdf@fomichev.me>, Stanislav Fomichev <sdf.kernel@gmail.com>, Tariq
 Toukan <tariqt@nvidia.com>, Willem de Bruijn <willemb@google.com>, Willem de
 Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH net-next V3 11/15] net/mlx5e: psp: Dynamically reconfigure based on SHAMPO mode
Date: Thu, 3 Sep 2026 11:52:11 +0300
Message-ID: <20260903085215.3691657-12-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260903085215.3691657-1-tariqt@nvidia.com>
References: <20260903085215.3691657-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF0000A800:EE_|CH3PR12MB9249:EE_
X-MS-Office365-Filtering-Correlation-Id: 39884e15-7044-4032-25aa-08df09991cf2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|82310400026|36860700016|376014|11063799006|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	2EF53SauGd6Slz4i+8u5zUt3Mjd0rYmWaL0zvZfNgSspc7S+nFfrppbGZNtPzjS9idGOKZCBhNIKV2BQIkvlppUq/9clwAcgVegTqGP1ZBso5xiMZLX0O4hf/6Tqcb4cyMeSft2Z0zeWhPiA6FrXLczKMHUWV73qrG9WOiNROlJQWxadO+9K08Gckm6DP3GvXRev9AilofCEGRkxAPxZwiGTilNiNX6THWcwvWpsqdxgiV4sN/u+gWfMWtHv3R2v+w3pNWmgkrJsqM1gEUgOTx4/lo+c4CSMmIiHKlI2qfMlLBpSMNCOpSSh71YFjdy7E+Agof3GrGaiJ+jRl4Gi8YbHpR49NzTwqKk99aiiORB5ViyXBTb1wb4B9tLsGs5jbHjdbm7NYDCRgzld25iBVTHpmGoB83GBUq+aehPGiG0+9JiIyDv0q0/pz77fXYNKUtmgEDGq1O8n2tqDx0OgDlZ5M+xVm2oHXoZCHSnctTEYEuE902lmtKmTbZCrzDMJw2CeLwj7UYpcANjrlNYEcyw7fc/YxIPVuE0z1dIgeQDIbX8hLNB0xwvXcLDmE2aZE+Sz1RR5JYwtk/GNpkF2SaidU3Jm9z+O2H4cbiLFB0fRkxVy05ELdZ11sk2nncX93Nn7NVvnKm9ig71c1Pq7fK18xV4ptjui+5ZakRVuL0a9i1sGWh9yqHyuRH7vbUEbop4auHb4B240JM6688/BQQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(82310400026)(36860700016)(376014)(11063799006)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	S6jMJRS67rRno21OHOGP46QxZQ9NPwAZTpXDE2nmpshVnoFIUYCr/+d/jtC5IiTPL0SDM7INc549WXIiwNDvj5RNJBM9kYl3Y1c/g1GDr444LeOD8wCDOHDf4vOTa9tjTR0BT9Iciwucy1QqWp+ZeDVN875YuT69f1efGCS27zIKhXVaeHt+Za8BpEfBrlqrTBx4rrACVVPjYZFTHgHaj+YWcYvEOugYRMbvyGHgC+s/1JkToTjO9MqpTupd+SfKbhNmXTdV0pVNIU0Qc9huaZp4b7mvsdSzLYGPPELuhk9BfeQm8Zjpw61/u0sNV6ZHDcK4qVhRw4cg61G31Vr3YfUuqSDpdU0qqagCn2oD727c21QHiQVgYFYvqzwJS6JyA6t6fSklUaxrf5uYwZb1CIWi6iXEV3innTOkom4wlIQTFkm5AKfKkU/0pKDg5Etc
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 08:55:32.8696
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 39884e15-7044-4032-25aa-08df09991cf2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000A800.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9249

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

