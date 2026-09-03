Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012058.outbound.protection.outlook.com [52.101.43.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24741469830;
	Thu,  3 Sep 2026 08:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788425703; cv=fail; b=uq36YcO/1sRFKsWT78mJn2CE6ioSNUaKM02l41TyzyhQmJYQGE3lBuSQ7UxJTGQKmoSOLI9CYHxn5Wv814s9pYF8saN2urqxxdbwh5nsibSmpQWFO4CDxdD4ne/uGXcN8sS19Kc2n0V60bZEvC68RwcVYESJhKpVmnYLtW9he50=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788425703; c=relaxed/simple;
	bh=A/szplpPqm0nvWIsOJw8IpyWltDrgFT+LD5XLPvLB/M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UJc5dU/q/J6k74RVCbcIjh+TlGnhEuZfNML4T2Dw541B0B7S6CF7G/CVGkHfpWDzAv/CTLWQqkYPCtX0EM+JKsBzPyJqKPsrs5xB4+rNLA3fcaCJLi2+dYMKHPRCxFt8LiPZWeERsGwPYqWh/VWi6lqnbw5rdgGMf5lBrzsxmuE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oekVjOpy; arc=fail smtp.client-ip=52.101.43.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oekVjOpy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mAUmnFHXSGeBGK62Xb6lV/FpxcbzFNyb9HqwH52cQwF0iaSWgRgYvLHigJj+GIVhlhaypchiUQ+uk4r6LFvlIZlCKCp/TjQ/hiNNwrhcShjnLDfMNaHQJjzzM5zAli7Bk5tT4ox3xzs4SDyY1OuEQv03fWllJA69YVQ5vs6DfcVeuUtQsKcTS8aEg/YSsIayzsa64pJ8uhY9O/nk4xwVsYvGVqxG4MbSfcH0AGDtgJ69q1fxmZvhXVRuxcsVshsFQ6mK8SCXYATlzDR0K6OAh/5+G+rpi/9IuUy6OlEoQxa9vAGlaQZHF6nzPY4yN3oltRBw9IpaixGwA0UQGCk7Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DY7rV8h96DGanbcJNYhajvNjphdvow00YP7emQ77ftQ=;
 b=rlvwJC0YQpKmvc1kTI8BmP7ai4pz/qGZSm/rxGbdT2YLJ83aFprAIQbMHZtSADCyG8Xwiw3J9t+ocUUqNVzULcRW1MZqASOVvcLPnGSn1OHrGxC9x6KhUy1ZWRvszkSLWeZgMuIv7cXgak6s7kjtnO8lawwcvZ0bwY8Wrg5TbwS5mWYy7DiFzNNsXkuJM8ndAY8BOA1eYZyAktGCwi+fVC5MGR4Rok1DC+qDQ92PJ3Ksft6lbuvb6W+W0z0FB5kIErwNOVs7tWu7yaZB1RSy2GHhazl0BlUEBLjrd6s2LGH3tQkQQhGHo/BSacq1IS1gblpTJqeinu8zX3hbNQZcBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DY7rV8h96DGanbcJNYhajvNjphdvow00YP7emQ77ftQ=;
 b=oekVjOpykGApGHu2Y8a3Ds8IvPgRUIpjcFZkr9Hq1wv3YHlpkSSuE0A8FLySFsfzikS5ZwZZx1IM8NZyVG/heGxjwYR4qFe/CeFbmlGkroHKirYVi9yHMTy1xqy28ijIZiWPevHvODNJTG4VSTL1KqMiBYrjy2b3fWPKyPuqC5ahGydjJqO1pedVpKf+maqP31fwZ5aHPy1wvCLWyvjevTxy0a+Dz5FSHneTEh/jCNO0ksILzEMze4QVnQWdAPgoKPJaAhg5a1MKD5E7iIIAl+EYFFzjXyyRMIZezX/eSp5kWo4yj1HfmMFL6VEB53L/sqY3pJn4eOzZ5Xsr71xPwQ==
Received: from SJ0PR05CA0122.namprd05.prod.outlook.com (2603:10b6:a03:33d::7)
 by PH0PR12MB7957.namprd12.prod.outlook.com (2603:10b6:510:281::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Thu, 3 Sep
 2026 08:54:55 +0000
Received: from CO1PEPF000075F1.namprd03.prod.outlook.com
 (2603:10b6:a03:33d:cafe::3c) by SJ0PR05CA0122.outlook.office365.com
 (2603:10b6:a03:33d::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.11 via Frontend Transport; Thu, 3
 Sep 2026 08:54:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000075F1.mail.protection.outlook.com (10.167.249.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Thu, 3 Sep 2026 08:54:55 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 3 Sep
 2026 01:54:36 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 3 Sep
 2026 01:54:35 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Thu, 3 Sep
 2026 01:54:23 -0700
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
Subject: [PATCH net-next V3 08/15] net/mlx5e: psp: Handle HW-decapsulated RX PSP packets
Date: Thu, 3 Sep 2026 11:52:08 +0300
Message-ID: <20260903085215.3691657-9-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F1:EE_|PH0PR12MB7957:EE_
X-MS-Office365-Filtering-Correlation-Id: 134d11d8-b7a0-44b0-6332-08df0999069e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|82310400026|36860700016|1800799024|10067099003|11063799006|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	qGhzQubJgIitTAlPPIqBZro5jrSqxsW1fhm4TBSCAkKgSG2Ls7+0GMKZWNMZ11ZWLKAd7kFE3oTDNsnR5rh1KTpU7zp2IZyII8JOneSZkep4eUu2uwFPN4nONdC63rANneGZSgjxd0fe633cNbX3R8fxG08fpS50NsfF5o4GvHQFlw5iuTF5uixa9nnAQJwLvwozJFApaXFPLxOqn2JyK2Un92mgU/uJ9QBZ9dB3A7zn41TdYVufX7Y2GWv1x/KLH577RLlkFOi6erFh7cBcPz4Tx6vkdy/JRMd5hvpbOuvq014tavcYgXxx9gbp6SzF67/Xyc2y36IXG0OPDYuGQ8RAyjQRx7d3fRiroR5O/cGUTEmWKdx5MLA6g4IoFplXNk6vDQdtIzFrV9Ft1aCJECbsWy4UhDJ1zZxzJxwZUO8bIJf1KZelkEnTnMwIsM+Me5122MB6ZfccXlJptQNR09V9PNUm7wBERni2+uaJQWxI92KWQYBGkhPsLELT1nIEs0N3YH2Uq5FXEziBx0gTW+cR+TBaHpZcXIl1GkM/FX4h/D7GgGEsgIDDTr7ExT3JZEXnRFMeqPUAblRQ80MAXvKK47S347dEsaJf3VWYgVB8t5VUZ2Gn3FxKXr/7W3EFD8Fdt2629u5+24iMhdDQgTmKU37IlkIR/Dj9mHQbWA0q+nfcuH03jRWc0Q5AJ2ghCSH0DrX5VviZfB5y6+B4Sw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(82310400026)(36860700016)(1800799024)(10067099003)(11063799006)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	EwcjVcGmpccEUhTnJ7wYfl3yzZC5pXsr4X7LJAUR+pQ2XRfT1yPKIx6xaNMq4D2qpyqtmq2009aEomD9X83rTWH9ebTlts1UJKMJhmFE8IiS2jBB4ms9J5KowdMyQ1GHU/GbXUHoS2pGDHhoiHLeNSKuvzDfX/O7B2SCw25uOMG4bQOVI+4dA7pLDhAJ79Z3CQNx1/wRhs5sW/99LNV/HxfMr8v2ssXSZ12Mu6xBbRl1cxDDi3h/XAH1vJKm85FdsJvQa/fQnctEXY/jkUhQJtRzHSGfhdIV365oyA/MqoBs8wun1Od69gc7JcdMxP4nvZgiBRfayPsMFISt5PTqJar4dl/NZf6rCxYWfOCvEUbzMAaUgT7i6kcLLv40hq7cSjq9uRBwLxV591Mc5XEOeZkOzltr//YwiIJ0E2f20DDfnPkFiDupunIu8BonXuGV
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 08:54:55.4526
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 134d11d8-b7a0-44b0-6332-08df0999069e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7957

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

