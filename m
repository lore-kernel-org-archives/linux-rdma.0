Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013000.outbound.protection.outlook.com [40.93.201.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F581367F2F;
	Tue,  4 Aug 2026 08:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785832700; cv=fail; b=cM1dba5iuwSuAwkPCSnd/ncyMDUYleVyb1sJpwc54XZaK9K4xT/L74TubHPMbL692WLG6WtzcJx8V2fieesosJWkiVOUjTDotf+vskPT3OIcM2mm2TtOk0+9BvRCGosgp7Ule1tD7IBeGaxIumKBU4JRrRRp/Nel2Ve9it3EHzg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785832700; c=relaxed/simple;
	bh=kxOTU8L/4Bz2Ih2+a2ZPHMGlLL+Qch0TMoTytc2oE4M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oNmJRcfxm3OsR9TwhGkoEU9p/XXhMnUTl/OOw7ZuFOH2CI+evYNQ60+4MPJKBeCvWLkK5e9ylybN0LZTQ8MGJm8uJ8+YzUrqnoFwA6wiTLUsLn6EId31ssgxJX60QtbgizOjN4QAT1fzXlYBO8B6FG7vV+0w8fVCb14mSYamRS4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Iu9uML/a; arc=fail smtp.client-ip=40.93.201.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Iu9uML/a"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=broHAvgyA9K+Mk2vvBgFgrkhLtRYODt3jHchbM/lv/2cC31bFJfO60PhmO6y3NvZoPOi1/+JAYXTcD5FGmeQ2MHvfXYI90IHucg8wrpBHXDxDwLivGNVu8YWctyHw+AxhdU2ODa0Vlt4odljmj7nkf1mmI+yGqpsg3YaauiZlzleAC4/XuqSoVYHQoU6F3UHgE05JSbopdKr5tdOKjniVc9wDbNGGfNo/Su79O7OUAmgOoSwfKgIOnNo1uC6u8WEzVKvB94qEbIP179NBm/XXYFYye5n09/WWRmrj+6iZl8Y5ejP/Ek1+wCLprGzjNlTdMXcZUdtOlSbL60WXV6G9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9hyHIL5NdCQ/KTN89/w1LSOcDEnoZkaPUlpEIL7mPgA=;
 b=n3B3TxP9SQRwv84VXDakputKhpHU/lqmAtxVvRlAbwXGXcjacGeeFLEx2G2ClqoERgPmC9EMAPTSfLEpoAZ5PUUx94Ax698Sp8umLhwjGHGmQjhZ4tdk1m4iiJa9OKqf8PFIC4Tr4uFGBF6TWi0C0byaWML7i7DcqeF2IabDy9kpv3D/ub4OHeQZj4yMf/wk7oasCuM4jy05FNLYFPuv61pH3aKrZQQ5KNgJxWVziKSMBE9ULXHFC3jdAD2+Hucv68plDroTRIvxWmvNPsfkNdOgyCvhWzlixyYnk/XlLcNko32qlTSn7iz6vbpsy3DLeJYJIo+aOTL3EX73ag78hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9hyHIL5NdCQ/KTN89/w1LSOcDEnoZkaPUlpEIL7mPgA=;
 b=Iu9uML/aog5JRFvsj2DbUEH6WdFn3/WwpwqFxYa7hWhNBAvnKU+ePSeQG4SEMPfxpXAh6m8aMmrwLWoYdzb0tMvhlefvfWem8/BQg2kb3fh43Gskn6ZF88kxerxw/uBFJ51FIsnRsfaszq6Zt7khcen6swmJgjUY0yy9jzQgVGTUIQEtr/XfZTrCgpH0U7XsUNaDaYNIo7TtFCnPch6ozY5W8ncVPF5bdXxz8kteYomyUEJwQVQy/67ppkhvxTfRveYQNjJ/dYLKN//h0k1/WZl5LPnCyHOU1v8jT/oQiZd/4mzBHAaK20QByyIk1cqRPPjqkEBdAv9QSm+0HLVqDw==
Received: from BL1PR13CA0108.namprd13.prod.outlook.com (2603:10b6:208:2b9::23)
 by BY5PR12MB4324.namprd12.prod.outlook.com (2603:10b6:a03:209::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.15; Tue, 4 Aug
 2026 08:38:10 +0000
Received: from BL6PEPF00020E63.namprd04.prod.outlook.com
 (2603:10b6:208:2b9:cafe::1c) by BL1PR13CA0108.outlook.office365.com
 (2603:10b6:208:2b9::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.15 via Frontend Transport; Tue, 4
 Aug 2026 08:38:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL6PEPF00020E63.mail.protection.outlook.com (10.167.249.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Tue, 4 Aug 2026 08:38:09 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 4 Aug
 2026 01:37:51 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 4 Aug 2026 01:37:51 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Tue, 4 Aug 2026 01:37:43 -0700
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
Subject: [PATCH net-next V2 08/13] net/mlx5e: psp: Handle HW-decapsulated RX PSP packets
Date: Tue, 4 Aug 2026 11:35:30 +0300
Message-ID: <20260804083535.2946459-9-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E63:EE_|BY5PR12MB4324:EE_
X-MS-Office365-Filtering-Correlation-Id: 84212470-6c95-4a96-6ba8-08def203b68a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|376014|7416014|1800799024|82310400026|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	JqFbr2jWjt4H6hdk17RqPXeEM9uiLsIvRKXD+Sg+k3I9QwN1/z+fKYcFXzs3NTO5JZ6SBIkdfgMyVn4QvR9Z69XOs1ilSkcjjQu/DX59VLYf6s3d7n7U5Ug80M/Z0KVgZ36Dt4bdqVBR+NaCA/++2m84zOGwuR/GiuHIrSkPwUq+Pzv1CFAbh7gXtuRNuWDLEq01GXMr4lWS/O3qWh+7JmTkSXsxwVAsWtoF+cTC+0OfgrhDS35Cgi7eiPze6Hs0hkUMtCqjTbKOk8O1EqL2XLAw/rwsdHfK6Io8zP9Qk9ju+Ezvp2/nMYN0FzBtuSEIK15c22S9o3g7dqEGi1k0T1GTOoOXF5iPA0HojW4UUhrNA5rC4qhY8Ck2iFZOEL4yyNR9mMVTsYmGAn478jwqlzaueRS8BxXSmbKEfhhGKGUEd39n+KpknQpttaKO/qPyCrXq9XMMdRzzRDxRSW8jnqeUVc9vwre6yTiQQbRXivAA4haIhv0nbRitM+9sX6W6w/pAQFyMu1djbE1CTwE+DKWP4fRREPr07rr9hTKCDJMKGlrnlK9egMjnUV09BUbLivX3a47Pso6dclyT95gJifQPxljcN+HDRustW8yDNYm/NViBCsq8jOSElEgVRT/lFqGmfpZe8+OR0uWD+v1NQMz3lj5JE47iVQo5DUPb9ufTwCRmIuX8lYxM9MyrZ05klLUx3EhqsNI7QfslAf2WfQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(376014)(7416014)(1800799024)(82310400026)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	xkXTdbgUlqxo0eGjYkIbp/saHHWQtFDdQnHuVKllKyoVuTH50oGnpLmBwyZz6yDIzL9p1IXIrYieyplc6Gji8THR0A46thhkVwuOVRmBSnhvR7+jQHcM8wW3jgKIbu1a5CmE/XOCyMVFLvEY35gcd89NW/mSyswbYs0REXcqtCdw4xrAJLGaKADrdI0l/BN60L71Y6lceNIrcY11N3N+QzWXFJ/5f2dVJVabGc6NN+XU0dVEKkZcgncbAHWtiSmbtb/s9Bqo9LohrpJ2zDZyFoXt0wqybDwsZ8KQbxMyQ2ZmTQ5DRMGAeJAjbzbrAaA9XxTRxHcGavI/MJG7WmjawesfmUH8axOBK47SfOyQcKw0//G+UlaRol1Y0Pc7W6meOllAjv2IHnzeD1RvkJLy022aAG0V718QWEyHkEdenyMXtaYikieA9ioWMt79ACUE
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 08:38:09.2456
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 84212470-6c95-4a96-6ba8-08def203b68a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E63.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4324

From: Cosmin Ratiu <cratiu@nvidia.com>

mlx5e_psp_offload_handle_rx_skb() handles RX PSP packets.

Add an additional flow tag marker and helpers for decapsulated PSP
packets and extend the handler to construct the PSP skb extension from
the CQE fields (SPI in ft_metadata and PSP version in flow_tag).

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/flow_tag.h    | 10 ++++--
 .../mellanox/mlx5/core/en_accel/psp_rxtx.c    | 21 +++++++++--
 .../mellanox/mlx5/core/en_accel/psp_rxtx.h    | 36 ++++++++++++++++++-
 3 files changed, 61 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/flow_tag.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/flow_tag.h
index 28b4470bc91f..d422f96ffced 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/flow_tag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/flow_tag.h
@@ -16,8 +16,10 @@
  *              1 = IPsec
  *              2 = MACsec
  *              3 = PSP (HW decrypted, PSP header present)
- *              4-7 = reserved
- *   [20:16] = reserved
+ *              4 = PSP decap (HW decrypted & decapsulated)
+ *              5-7 = reserved
+ *   [20:17] = PSP version (4 bits, valid when proto == PSP decap)
+ *   16      = reserved
  *   [15:0]  = used by other subsystems (e.g. TC).
  */
 #define MLX5E_ACCEL_FLOW_TAG_PROTO_MASK		GENMASK(23, 21)
@@ -25,6 +27,10 @@
 #define MLX5E_ACCEL_FLOW_TAG_PROTO_IPSEC	(1 << 21)
 #define MLX5E_ACCEL_FLOW_TAG_PROTO_MACSEC	(2 << 21)
 #define MLX5E_ACCEL_FLOW_TAG_PROTO_PSP		(3 << 21)
+#define MLX5E_ACCEL_FLOW_TAG_PROTO_PSP_DECAP	(4 << 21)
+
+#define MLX5E_ACCEL_FLOW_TAG_PSP_VER_SHIFT	17
+#define MLX5E_ACCEL_FLOW_TAG_PSP_VER_MASK	(0xF << MLX5E_ACCEL_FLOW_TAG_PSP_VER_SHIFT)
 
 static inline u32 mlx5e_accel_flow_tag(struct mlx5_cqe64 *cqe)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.c
index 348fd7a96261..2beffee14278 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.c
@@ -118,10 +118,25 @@ bool mlx5e_psp_offload_handle_rx_skb(struct net_device *netdev, struct sk_buff *
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	u16 dev_id = priv->psp->psd->id;
-	bool strip_icv = true;
-	u8 generation = 0;
+	struct psp_skb_ext *pse;
+
+	if (mlx5e_psp_is_decap(cqe)) {
+		/* UDP + PSP headers and PSP trailer removed by HW.
+		 * Construct the PSP extension from CQE metadata.
+		 */
+		pse = skb_ext_add(skb, SKB_EXT_PSP);
+		if (unlikely(!pse))
+			goto drop;
+
+		pse->spi = mlx5e_psp_get_spi(cqe);
+		pse->version = mlx5e_psp_get_version(cqe);
+		pse->dev_id = dev_id;
+		pse->generation = 0;
+		skb->decrypted = 1;
+		return false;
+	}
 
-	if (psp_dev_rcv(skb, dev_id, generation, strip_icv))
+	if (psp_dev_rcv(skb, dev_id, 0, true))
 		goto drop;
 
 	skb->decrypted = 1;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.h
index a26faf7cfc27..41b60259b3bc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.h
@@ -81,10 +81,29 @@ static inline bool mlx5e_psp_is_rx_flow(struct mlx5_cqe64 *cqe)
 {
 	u32 proto = mlx5e_accel_flow_tag_proto(cqe);
 
-	return proto == MLX5E_ACCEL_FLOW_TAG_PROTO_PSP;
+	return proto == MLX5E_ACCEL_FLOW_TAG_PROTO_PSP ||
+		proto == MLX5E_ACCEL_FLOW_TAG_PROTO_PSP_DECAP;
 
 }
 
+static inline bool mlx5e_psp_is_decap(struct mlx5_cqe64 *cqe)
+{
+	u32 proto = mlx5e_accel_flow_tag_proto(cqe);
+
+	return proto == MLX5E_ACCEL_FLOW_TAG_PROTO_PSP_DECAP;
+}
+
+static inline u8 mlx5e_psp_get_version(struct mlx5_cqe64 *cqe)
+{
+	return (mlx5e_accel_flow_tag(cqe) & MLX5E_ACCEL_FLOW_TAG_PSP_VER_MASK) >>
+		MLX5E_ACCEL_FLOW_TAG_PSP_VER_SHIFT;
+}
+
+static inline __be32 mlx5e_psp_get_spi(struct mlx5_cqe64 *cqe)
+{
+	return cqe->ft_metadata;
+}
+
 bool mlx5e_psp_offload_handle_rx_skb(struct net_device *netdev, struct sk_buff *skb,
 				     struct mlx5_cqe64 *cqe);
 #else
@@ -110,6 +129,21 @@ static inline bool mlx5e_psp_is_rx_flow(struct mlx5_cqe64 *cqe)
 	return false;
 }
 
+static inline bool mlx5e_psp_is_decap(struct mlx5_cqe64 *cqe)
+{
+	return false;
+}
+
+static inline u8 mlx5e_psp_get_version(struct mlx5_cqe64 *cqe)
+{
+	return 0;
+}
+
+static inline __be32 mlx5e_psp_get_spi(struct mlx5_cqe64 *cqe)
+{
+	return 0;
+}
+
 static inline bool mlx5e_psp_offload_handle_rx_skb(struct net_device *netdev,
 						   struct sk_buff *skb,
 						   struct mlx5_cqe64 *cqe)
-- 
2.44.0

