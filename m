Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012027.outbound.protection.outlook.com [40.93.195.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1664F3F8EB5;
	Thu, 30 Jul 2026 09:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785403188; cv=fail; b=WGhzLwlLZjjXOaL+5T5m3JWhaUEaVYzWhCBufmOZlphmkkeL5y0KhRzL9uQY+uxeTFBjQPBfZVZ4OUQUWIbsDWXvPH44qZBkfupEsxFIFxWZXOH/bry8jFpIQb8SWu+KcYZxH+QqO5QwY8pbeWrfEiKRzeFk4s/W3WArnIAbdM0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785403188; c=relaxed/simple;
	bh=kxOTU8L/4Bz2Ih2+a2ZPHMGlLL+Qch0TMoTytc2oE4M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AtoXuAExlY18wWFnKBpSsUosynQJWKlJ9DlDR/yae8gangyHSYPcs+YYmBfJtcqd8GyoN3QbJcFSWSwzm78G9NiQJrnD+vxz49+KIM0XT/7j5UYCZ+Es3qPeEbki3gYIU+vRJ78w8TywKQ4jGeCBp20F52/t80ucgW7wO89ZW/c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=amBSQNim; arc=fail smtp.client-ip=40.93.195.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="amBSQNim"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UO2mesMEf3x1146Dpq5PyrpNOlzUJ57zetOgmjHZnLzJ6vJjgVxl5+ClkNjZHEQi/49OmNqxt2GKUePjAAzc5hQ32sxedJkOpqW6xapNq31XKpnKhkOmaruPWBhCakFmx0+dujcb/Kf5B3FvjwQIh9JAskGC3oWZNoogVTV6UaF/ce7ked3TBGdG0xh7iNkm3C/beEv53gB8crC6pVIQc3KB4HY57n/3fPMJtlMhH6REAVNap4e62aE83uqWfmTsiTENQb4rMccVxV5PiS8ogjvtWHuhPTVivQFw4G5/m+aG4Yiq5KwR753isvXz5g0JY5t9yRsqtYOV9bsAeyREBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9hyHIL5NdCQ/KTN89/w1LSOcDEnoZkaPUlpEIL7mPgA=;
 b=ehh903PyfojGTN+D0sNH0vurMj/KLagiCN7dfi8auP8i9WPKIQhPgLpZj8r50RHrT9BfYe+IUpmIMlb5Zs1XSx6OOFK/bU5SmIRr9czMVcsnDjl273yZEczxD6g3dDJGfRTnyuLB6C1sWSCQA+iOoql/Y0faIZGNYM+ucnuFF+epTN3J1pwsyyCqLzywD3AXOmqWGOXPuauuiWOY4razPCHBXEo4RfWToDGEkmS+x9z35AIqeiCqL3AbzGg9/ZpctmZ2uMTOKj034aj+W1mQBqo4GGoPfYSdoKqac6oKxnMYlXlWqVePa/G/HhOpm/U1TIGILlm/89m4/jeBzqP+7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9hyHIL5NdCQ/KTN89/w1LSOcDEnoZkaPUlpEIL7mPgA=;
 b=amBSQNim/j9Rl2UdWRaedZ3DqzsMyyZVx4oh4bXWSyaMBRXpzPppjqHos9DqM9Go4wYD1/lH7UF2zpyHmI/qoGS8UVVrMCqx23bkwxoLDi16eeoTa/WTEsAhboXq903g1WUDNMqv2kActNvbll/Mm4jiNdbgtB0mTd2Xz1zy+ZXzGERSBo9Fg9VbDBTSa03x1j740xJOmLD4FQD7mNW/z5IzlWulyxuy2+NqzvsTDENzR5g/RkyNVLtdtbWwBWovtIqhX2Go6bOH/kte/V91G88UneQJ5oQGglMdkYVh/GWPCVoCuqGu43cAwxSCUXedxNGZfmUpr6TXCMO8dZ34fw==
Received: from BY3PR10CA0026.namprd10.prod.outlook.com (2603:10b6:a03:255::31)
 by IA1PR12MB6044.namprd12.prod.outlook.com (2603:10b6:208:3d4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Thu, 30 Jul
 2026 09:19:41 +0000
Received: from SJ5PEPF000001CE.namprd05.prod.outlook.com
 (2603:10b6:a03:255:cafe::64) by BY3PR10CA0026.outlook.office365.com
 (2603:10b6:a03:255::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.13 via Frontend Transport; Thu,
 30 Jul 2026 09:19:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001CE.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Thu, 30 Jul 2026 09:19:40 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 30 Jul
 2026 02:19:27 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 30 Jul
 2026 02:19:27 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Thu, 30
 Jul 2026 02:19:19 -0700
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
Subject: [PATCH net-next 08/13] net/mlx5e: psp: Handle HW-decapsulated RX PSP packets
Date: Thu, 30 Jul 2026 12:17:50 +0300
Message-ID: <20260730091756.2543777-9-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CE:EE_|IA1PR12MB6044:EE_
X-MS-Office365-Filtering-Correlation-Id: be969f71-eec9-4242-8e8b-08deee1baf73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|23010399003|36860700016|11063799006|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	A53j1wLJdRqL1KqHu4Hhx8VZNwsqOsJ1XXTv+7xzVNzsNmMKjKcpvxMnjceUnvz32ESuD9WOQei+F9r4V/NPQIXVhTj0DEn37TVYlKn52+JIP9qaRnVLNdXd7rbtc9lrbfNkypUW3lknIm5rPjCKCQ4CZiLD6mR491Qss3JC+StKrKh5SGEvjCky47bD3fCfF0OGCB78PyIbcnu9+YTiOEl+CqfSb+oNfoS+kgIBpj9BfRrecJGKHYj2i/lWH9p6NNBCo0wZlAu/y0hM6A8jAwYAUXM48ZLKM6IVQmCo1EYcup1ZqW+2gDbOaXVRl7xySYTqhkcHytv6WxnCVr2Hj76RL0SgEWbISIm6kpLqzFgLZu+sUQV620lXv6eNqy0Z6w/toKzWRqkd7oSKDctE5FtkNM17vKKoJQhoHypOxm/6jGqKULNpL9h/dq+S8jKMoHjHPpnND/xpZ49w1/bqjyX2HQq7jEmgrH7pfiOUFIxXdSU0xglgXxAqY84KtknEuIlcvHdUAmzfNexS7ZrKxxDJXnR8YLjWGXtqNPxd9BYZ7iGN4buMJ9/iDATQ5FNilAvcxnhEmsvOTEVv7cxfqtHoCZslJpGAYu4cky1ALHeQAY21FUjButXi+JEBRyomsYfQhrk/Q/lpXQgFQ8zywNR6hxo1BLUx7xh9xVf7F/6obOlDYlT0kxSr9LbIs0WkV3/ybyh7le7uCcbMScKTcA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(23010399003)(36860700016)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1TGuQQIuSk5Pjv8pNTatOjW869qaoUwCQACEBx6jn60vkpQ1H3lI7ywT8vJtUqdlrstdXrwIiI9WdS81APkWAQxBRxsqXXjd/E3tWSPn5qpppLqTBB7eMwQBzagn/1dg3jxPXdOLMohftYKBKT2NG9bEXkQRQkRS5zQ89Ae9535zmvh8awus+u7140lgAMqd6tQIjE6VyCt/mst2ylW0YBW8XFs3HdALJ/LiGtKKu5FKLFE8jgIeGfB3XH4EucfLcBdNT9eBnyk+wnaorcmtcipL7ASXbgYuGMoiRQKgpr0Jsqai2hytfp3WdO7ZljwyYpF2pHAQAC667I0rIwRelanzj/gWzcILqaDb08HxDtP1cYJS96NQHPivUGPg7SYCvelsnkuBrR3KDL+AjN1LIweg515hlmvWgVKgx0B6THjBMeT5jckdHMx5nDdQemc1
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2026 09:19:40.8028
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be969f71-eec9-4242-8e8b-08deee1baf73
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6044

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

