Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011012.outbound.protection.outlook.com [52.101.52.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A963B3A453A;
	Tue,  8 Sep 2026 06:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788850490; cv=fail; b=romBfH4c+GxrCBY4HN4XIfUzPJhSs7CJSSEcoB0xDB1TnyaLlhAbsOikf3TejdUvZsHbkHsbJpSPUX3ZYxJ2D0YdwfR3QE2xXxefg6gnnipUYWE6fxedaQ4px7LF9/QrZ/DwoZjemBBfNwUN+tJXp294ChvvGFNLM9LrHWkf0no=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788850490; c=relaxed/simple;
	bh=A/szplpPqm0nvWIsOJw8IpyWltDrgFT+LD5XLPvLB/M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qUpiHt3+WL8ULT4ZDsSuFXl/SUVGadcSigW/da04KiRTgnUyGt/DsCimuiOyOG5fOZMEOSntbX6hvlh/D9WmORph3un2DqhhN2Afi7HsyHw1nPGgfXEfJDxnu9abgCx87w9HMHUtW7hLY2w3/abz+/uMMd6Qnccu5uwCH0qhFn4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XMv/qls+; arc=fail smtp.client-ip=52.101.52.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XMv/qls+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uU90XLlx8wjuvH2EsTGsufIOT77KwTF/JAU99HO3begwfcoqEKzi3iSPmPlzGQDaaqhSSK8gioYGtjOpfHcZyX2XJuOhaKbJtm20U2glWgNM9zNXnl0RLR17U1SRHS258nhVdBCmMqgBdt5exTTOZlL9jj28Moln8iAGqRF/OpkmYI39yNWA0YbeUk16p0R8AaxCkdB76rMdTKj7enu88GCwtS8+s0Xf5bbzUXpdBQnBcc8PlDa8Gbgb+3wxq4S3XL6DR4LxGeIoeLhmEPp4jujpLVvyRTnCMopo8/KqNGKn/RkL3sZaRrIH6LlZfQWU90Sd3pJ5aSzpAEVdPfCNpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DY7rV8h96DGanbcJNYhajvNjphdvow00YP7emQ77ftQ=;
 b=DwHxt7meYWqGMUYBzc1KDHSEkDciRfYnlLrdKch66CHBW8Q8OeswnmArHbs1nOkCruNDEdwbUHCfhdAhbS7bIpwWyET8lvooYLcFMyiiAKrt7HaYP/X3eKFT1bB4BqGq44oSq5Vc2tPKwBTO7ABlmSL88q9IMtmSMuByL6TpLNJkvSMofho/xqaKLJT3VhD8tM7neYNfteFWBn+OGD3cnBowgWSq2fvqmNHszPdmV0tM3ehDGbZEiFHUEGMK1MUBVyIFZUUz9hYYKqS0Rm85D2D6byKIW1Qj+/eZ2BJ8We0XkVb6zZeuue4a89p6L79qogqf9ocR53mAKr3BXme+/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DY7rV8h96DGanbcJNYhajvNjphdvow00YP7emQ77ftQ=;
 b=XMv/qls+dIiu3Miw+MqQMU9DaRa/dsSpTPAmK/qmqk6h2Nidgm02jjlWeZ6uuG5Y4Ng2wKBgEUrBiKe/CtgzgZpGht+0m+N84lIPet7PHVstPkZDPEBeiOTWdMZWJVsWcxxjnr1kf27b5meBj7f4z7KcS2Hnut4xuQerqzWsTHAGDaHlLCO1SGK8jhsv/2Ct2uLzowEXC1fRgUBY+oXlk0uoX1bDuaq2yPypbQz6JXRnYlr1IzNEUJQx3CTQhisXaDQw8oQfLtLQtuOR2yv6Ecn3jHm6lBftqQPHgHOGizTfAq8GqdaOzMaXm9admtUVs4HYkjxD3anIegLIgsQ/Zw==
Received: from BN8PR04CA0045.namprd04.prod.outlook.com (2603:10b6:408:d4::19)
 by DM4PR12MB7669.namprd12.prod.outlook.com (2603:10b6:8:106::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Tue, 8 Sep 2026
 06:54:41 +0000
Received: from BN7PEPF000000AB.namprd05.prod.outlook.com
 (2603:10b6:408:d4:cafe::8d) by BN8PR04CA0045.outlook.office365.com
 (2603:10b6:408:d4::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.15 via Frontend Transport; Tue, 8
 Sep 2026 06:54:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN7PEPF000000AB.mail.protection.outlook.com (10.167.245.235) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Tue, 8 Sep 2026 06:54:40 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Mon, 7 Sep
 2026 23:54:24 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Mon, 7 Sep
 2026 23:54:23 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Mon, 7 Sep
 2026 23:54:16 -0700
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
Subject: [PATCH net-next V4 08/14] net/mlx5e: psp: Handle HW-decapsulated RX PSP packets
Date: Tue, 8 Sep 2026 09:52:38 +0300
Message-ID: <20260908065244.3799142-9-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN7PEPF000000AB:EE_|DM4PR12MB7669:EE_
X-MS-Office365-Filtering-Correlation-Id: e255f266-b71c-4d34-4683-08df0d760e92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|376014|7416014|1800799024|18002099003|22082099003|11063799006|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	PRwYFu5UF89JzQYrGBxb6AJqZEtLHFyhkREYCo85PybRuUbg9byLKnGTUJI/OhNOjbv0/6/LM5bapJWiMJQOkV2brVAtsTxoibnxajWz/dl1zLEi70oMzoTLU67/hmyUyGAvHbXGFsPETwe0rHqQDfrRxKd+j+cOY0AdfhDBdN3OLUoTHiw4oyyiiteK7/+xGa+yoNS/aUkJdpAPled6Utiw1aOL0i9kcQWPdAVAJ9LymOI9UJVI+HPghcoAoRvdWunL2GXFOxfnGDTpTwVM1uXgpodv/UBMCsH3O7dGI1MtarDHMJKeAYZLoYSqptdC2eri24MZqB7s2HW8V1DQoPq5jYoiIIj7TjGp7eOo8f/Ons8B9FzUr7W16c9vCse7WrHXY2IsDIbU+vsctCQwZG1Mg+3b4lutyB222WmyeSqMM1YT/T0lcaxLBAm0ZKA1veBaNgVAKPjQsdI2w5o60J8nIZPLzojbNFd2qXhR+zTeIca+dsZKHfZHEr2wCEr/j308kRv20fjcb61tX3p8zOMY3ZklZ/g4s9uM5KpIuoOpRJN7ycUCHYfZLf4gUXzjpLvvzl7noGAgoRMqscifYv1ssi9+YS3Bg5EMqBew8SPCCBo38KOBsEixjw4pJH4vVAa/jpgRuwRxF+p3ZzcbPnufqLfIM8BFs3EXvO8tz/1WSQQDOvcm/D3h3kNsm16cLzOznCA8Vtm9uatPFQEVQg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(376014)(7416014)(1800799024)(18002099003)(22082099003)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7/B7KqByNsvL4Ddfcre5MODJL7HAkMGoRsq/YaxfjIZgtJq8NAjm68ytJUajyPLhr8gaTM6NZ1Kcot6WTJxoVbQPF+bwPaizW4PwiBpJFo1wy1jzi8ajbgB9pnboo6C3YWBUZ80dfXApc+AnQoIuqtVz1X5cA2+G9hFmHnJ4nkdUU7CY5Lab2nC6CElvd1fySdCgczv8yPx0COjs7pIwLu9YDGPYLMeOBvsUDI6wSO0pi+1s86mefqULVWPiIe5CCWqsLxTtjPhKVjWymI+DP2U10j8dvsZLXV3WFUiQsUNkRa3Axts8Kr6aKLzvRAslRSv0nOlLcN87TV9S57xAfOtIlXh6smpHELG6BzX7Nx8/NijQLNbNnPW78TswFOUAdvOfLyEG+hMt/iZIIJd0UElc3RRISpn79Cfr9sVuDoRu3tqJ93dmrFOW6xEK4Xgl
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 06:54:40.9825
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e255f266-b71c-4d34-4683-08df0d760e92
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN7PEPF000000AB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7669

From: Cosmin Ratiu <cratiu@nvidia.com>

mlx5e_psp_offload_handle_rx_skb() handles RX PSP packets.

Add an additional flow tag marker and helpers for decapsulated PSP
packets and extend the handler to construct the PSP skb extension from
the CQE fields (SPI in ft_metadata and PSP version in flow_tag).

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/flow_tag.h    |  8 +++--
 .../mellanox/mlx5/core/en_accel/psp_rxtx.c    | 21 +++++++++--
 .../mellanox/mlx5/core/en_accel/psp_rxtx.h    | 36 ++++++++++++++++++-
 3 files changed, 59 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/flow_tag.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/flow_tag.h
index 1b6b0b3de738..cd10a74e2b27 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/flow_tag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/flow_tag.h
@@ -17,18 +17,22 @@
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
 #define MLX5E_ACCEL_FLOW_TAG_MASK		GENMASK(23, 0)
 #define MLX5E_ACCEL_FLOW_TAG_PROTO_MASK		GENMASK(23, 21)
+#define MLX5E_ACCEL_FLOW_TAG_PSP_VER_MASK	GENMASK(20, 17)
 
 enum {
 	MLX5E_ACCEL_FLOW_TAG_PROTO_NONE		= 0,
 	MLX5E_ACCEL_FLOW_TAG_PROTO_IPSEC	= 1,
 	MLX5E_ACCEL_FLOW_TAG_PROTO_MACSEC	= 2,
 	MLX5E_ACCEL_FLOW_TAG_PROTO_PSP		= 3,
+	MLX5E_ACCEL_FLOW_TAG_PROTO_PSP_DECAP	= 4,
 };
 
 static inline u32 mlx5e_accel_flow_tag(struct mlx5_cqe64 *cqe)
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
index a26faf7cfc27..32a8330027c0 100644
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
+	return FIELD_GET(MLX5E_ACCEL_FLOW_TAG_PSP_VER_MASK,
+			 mlx5e_accel_flow_tag(cqe));
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

