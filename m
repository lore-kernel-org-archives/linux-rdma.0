Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.24
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795012873;
	b=pL87ULUvK7Q3nybAtr+IEB5JhHo+iY76+XYrpEzD2a0XGmXxT7ESv4JMlH/hQQg7LR1X
	 7aIZ8yI5S95RKCWZlgdxXcfilUVYbwjY5pE9QPNv7aXrUEh1oDwkhbCt33zHUFeJqiVT9
	 wdh/mQw83AM2Df4V7KyKH1T8IP9PzRhWSeNhvu9BtG9CftRSDYPWMJP8n1EnzUsJEB9UU
	 FHQcODkLpSze4XztmaEx6PmTWxFf9M/a7xC4cOloQrJgFy7cqZtS+JZznCclQA/S3cmH1
	 Xze1lnD+AEnrt0UCnea504wwlXkXr4IX1IQSvMz/DoHFWEqvC/KxLQInfln0RvwMVlQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795012873;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-NV-OnPremToCloud:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=gl1rVTmtoTb6tfLloOqfGAJWKtCamVVh6q0B6IhVN2o=;
	b=3lwHqzjG6hgnxmp9Onf1NlN9Eej1wdFactZbQlZXjFgFA8Sy/ZLGpEiRDg18W7PIzUJ1
	 f6v2dQXQrsEGtqA4VrzRvh2dtBPj6qFYxpBwC5Fq9HxdWGGmsUw2K5BTZiYc4/hR64t5n
	 8yyh5zXKdAoIYoG/bI9CcWJ9a9fV185KDeCWZ1b7b89Rg6kGX+QDB0jcJfTOxIGg5r/OV
	 mSPtD/5+yUeMrwPneMwwTbK1eSJ/ofYROs9MG4QfU/M0z/ITQ3HmE5G45ESZMQ7f66nXN
	 wguQN/JXUIphBrRQHo58iQlgv/AWKw2aw01/6pAnPbgGgXYqaoZa0CWb4ygh6J4MSqA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ef9H8tWM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.24
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011024.outbound.protection.outlook.com [40.93.194.24])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E84E606A320;
	Wed, 18 Nov 2026 14:41:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E84E606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ef9H8tWM
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j922vQ/bygx/nqKac5gZwcuY4gbzsnNwT4B66/VMJ/E0kyf/qyXGQphorMcQ7wRabFOOye1EM/zp39Em5pTM27NPzJijMPuLmKhma1XTsypEzXqz6s6RURd2NiT0pxIjUElwGfjGXXu7ce7S71aSvBQA5QFgMROYOngguDWXgxLADS6WDIFfZ/ee2mp5PDBkr+lrpsC1t91gXvf2iQq1a+LUt3vkYN7OTGrJVNpLFpyFex0C1rJkqVfhI2zQfOnADIL26HEjRFokdYyldDHuDJ03jK9sxwDgSCHHY6eQnYlpdVFIfj1nNvAYFYbH77BVZ5cmqjnTMbzLxJXGrOCalQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gl1rVTmtoTb6tfLloOqfGAJWKtCamVVh6q0B6IhVN2o=;
 b=vvfzstrXvvFVPcTZ4SKcWCmuN9ZUpi5hn8IynQaUxzqwl6renhNghXpX1KIzQBZltoWr2uAlNJ7Zi99lRZmdShGfEPEMxlABT4rztIp97lQW7peco0IGEtbm5QTRASi7o428ZjPfDjeQ0TxxwBvHxWGTePJq+rwxnKRD4JuAYP7PgMukOFWn30sAG/RKoLR3FfOIApyPcrxKEQQ+WAI/Ag86O1+BzzPzEmxDALxxh9we1nrK5LGXr3CE98e0Y/kn3DyX52J6HiV0RL2TTiiEx9//HBEoaGDs0LHtDtt7hoY2/yfYRPObZLVFC4+rwchioziWou+GD0Am6Yk/M4HkCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gl1rVTmtoTb6tfLloOqfGAJWKtCamVVh6q0B6IhVN2o=;
 b=ef9H8tWMym0xtrpiFVdtXllDGPst/XNS4S+olLzpbaFQ8hxx1PlxTH0ae3JsZ5VY836bnRVjVbLwE/eIZjsUgmMXRCqBoN2Cv5+Dr+IrzIw/0V4j3reKQSv4bvth+FvZnGhtbCPoR4nskzIO4AWD+0E21xmXUaZeY5bs91S7dfarHIPZC03QEi+WryzFahFjUeEf5jVFJ0EfXJpPbtQ0vculib49UPmwrSF5Hrweo4L9OmPlm0IN/BVw4iedjb6aI0SfxIf4FLLaG6I8/J1E6kuL3CGlhBB1g1QquzYth783FoDZ1b9zTIFJscySYky2rnU8K5QIzPaRSX5uizvUSw==
Received: from BY3PR04CA0011.namprd04.prod.outlook.com (2603:10b6:a03:217::16)
 by BY5PR12MB4243.namprd12.prod.outlook.com (2603:10b6:a03:20f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 14:41:09 +0000
Received: from MWH0EPF000A672F.namprd04.prod.outlook.com
 (2603:10b6:a03:217:cafe::56) by BY3PR04CA0011.outlook.office365.com
 (2603:10b6:a03:217::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.13 via Frontend Transport; Wed,
 18 Nov 2026 14:41:09 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 MWH0EPF000A672F.mail.protection.outlook.com (10.167.249.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Wed, 18 Nov 2026 14:41:08 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 18 Nov
 2026 06:40:51 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Wed, 18 Nov 2026 06:40:51 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Wed, 18 Nov 2026 06:40:46 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Ben Ben-Ishay <benishay@nvidia.com>, Boris Pismenny <borisp@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>, "Gal
 Pressman" <gal@nvidia.com>, Khalid Manaa <khalidm@nvidia.com>, Leon
 Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, William Tu
	<witu@nvidia.com>
Subject: [PATCH net] net/mlx5e: SHAMPO: Do not merge packets with different kTLS RX state
Date: Wed, 18 Nov 2026 16:40:42 +0200
Message-ID: <20261118144042.1916204-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A672F:EE_|BY5PR12MB4243:EE_
X-MS-Office365-Filtering-Correlation-Id: b1b8b30d-3e69-419e-1111-08df4581fbba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|1800799024|23010399003|376014|261022105027099003|261102123227099003|261028144727099003|261021123027099003|261021121427099003|261022075727099003|261026121527099003|11063799006|261026140227099003|56012099006|10067099003|18002099003|6133799003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	Ma0183QrhSpLTgm3fLF9fTSRNnGfeFEP9a/gF9XIDIkBRW4qKziyoNMZB6DXM6vAhkI9Kg2aLAdjsCyi/9Te6W/pJKytVvcOFURXcSdsyFWA8yfYYhgaAdPaPXUb/9KC1pQSIuhSoJ39GYiamMiShsz4BaSqcPNBs7ryGhSIMWlfXqovMXiM1rlL05k95Te4ya26A4xUQsvdeR1nW7UfWXYyGWAK+fxsYBQXQbIe+hIDRxP7pv6tfwwjB9RCozkiac69OjIR6EZ/HJnnZHh7KwrS52A+6X3JgRW6+v37tT4lttNooirbln/Q5LmhuvFYhSvQm0AxLQ+pkT/ZLQyFp2JF0erz0hAaiD71g8X17adeoHB9ic4OG3CsTxI61XlYWrMCtGUYe1yjRkESxDFOL9pvU38n8K7EQj5SCH9I7Qml98ljfNZgCCu8B9g13DJJFaEgv2+BguXPz/u8OopWaQ1OFZcmp9c/gXaR/r6F6AORzkjeIj2Z47C/WYLSvoYfyfhAHUxmMVuzTkoJh0abs7u536asnBLsNkcRzlOK+9/r8iV4pugfCsaWTbiFXMjNg2gk7qSIr19okD6ZcgOV5A8346Rz8+ugIT35a+pFQAEL4XGs34WXNuXrW/e1pTeXKPhK8ukKzI00LdZixPSLyXqe6lGMvNYG5dN5Pr+hln/sn2oXD1RBhUJSzRgznWtnqKIarU//d3FPqBzkmL53Rg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(1800799024)(23010399003)(376014)(261022105027099003)(261102123227099003)(261028144727099003)(261021123027099003)(261021121427099003)(261022075727099003)(261026121527099003)(11063799006)(261026140227099003)(56012099006)(10067099003)(18002099003)(6133799003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gp6f8qH+V3rsgmTp0ikxLBPQMkFpdZHbnXHgKzTVjxwOKB1ppdQQ9RyFHGTUte19RBvr6Q/M2HJMekoPOFY0K+xDrZB5k/amm0n9p3uEFPLhdFEyJF60sUZdhQI5Zexie593U7l2NifV5B0egJjRm1R8Wd+2oTupljCGOJMA+ji602eDpLrYwEB+gh0OEDcPgujkNo2hLPwpEWDO0XUO+KODBT6uHXHZAkdxzMw+6sRi3T6sQIbKMau9eFTq4OQ7PlAEmKcpvyxHcUf6iwFTVGIuDO4v+EERP+zyLqz4q4wb0rCAxRm/6j7yvFUcFUf1iLvnOa7ZVgvbOCWHIWUKXgaGbfUVLnL+vCrkoAHIGlR49c2FIJXbiguIIGi9pWQdq7a3pHJz/GaeaWb3Tc4WC4i81z+MijUZNGC5doQfzDhszC8CBwrdMEr/B0lnZw3N
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 14:41:08.5293
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1b8b30d-3e69-419e-1111-08df4581fbba
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A672F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4243

HW-GRO (SHAMPO) sessions are not terminated by HW when the kTLS RX
offload indication in the CQE changes. The driver applies the offload
metadata of the first packet in the session only, so ciphertext and
plaintext can end up in the same skb under a single skb->decrypted
indication, and resync requests carried by non-first packets are lost.

Do not merge a CQE whose decryption state differs from skb->decrypted,
which the first packet of the session sets. Never merge a CQE that
carries a resync request or a TLS error, so that each of them starts a
session and is handled.

The failure was reproduced on ConnectX-7 with HW GRO and kTLS RX offload
on and 0.3% loss added by netem on the sender's egress: TlsDecryptError
increased and the receiving sockets failed with EBADMSG. With this
patch, TlsDecryptError stays 0.

Fixes: 92552d3abd32 ("net/mlx5e: HW_GRO cqe handler implementation")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/en_accel.h    |  5 +++--
 .../mellanox/mlx5/core/en_accel/ktls_txrx.h   | 21 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  2 +-
 3 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index 5a340f1435e6..554c225f7376 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -219,9 +219,10 @@ static inline void mlx5e_accel_tx_finish(struct mlx5e_txqsq *sq,
 }
 
 static inline bool
-mlx5e_accel_shampo_can_merge(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
+mlx5e_accel_shampo_can_merge(struct sk_buff *skb, struct mlx5_cqe64 *cqe)
 {
-	return mlx5e_psp_shampo_can_merge(rq->hw_gro_data->skb, cqe);
+	return mlx5e_psp_shampo_can_merge(skb, cqe) &&
+	       mlx5e_ktls_shampo_can_merge(skb, cqe);
 }
 
 static inline int mlx5e_accel_init_rx(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
index 93bd383a23d8..20e5dc6a718e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
@@ -60,6 +60,21 @@ mlx5e_ktls_handle_tx_wqe(struct mlx5_wqe_ctrl_seg *cseg,
 {
 	cseg->tis_tir_num = cpu_to_be32(state->tls_tisn << 8);
 }
+
+/* The first CQE of a HW-GRO session sets skb->decrypted. A resync request or
+ * a TLS error is handled on the first CQE only, so it starts a new session.
+ */
+static inline bool
+mlx5e_ktls_shampo_can_merge(struct sk_buff *skb, struct mlx5_cqe64 *cqe)
+{
+	u8 tls_offload = get_cqe_tls_offload(cqe);
+
+	if (unlikely(tls_offload > CQE_TLS_OFFLOAD_DECRYPTED))
+		return false;
+
+	return (tls_offload == CQE_TLS_OFFLOAD_DECRYPTED) ==
+	       skb_is_decrypted(skb);
+}
 #else
 static inline bool
 mlx5e_ktls_tx_try_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
@@ -93,6 +108,12 @@ static inline void mlx5e_ktls_handle_rx_skb(struct mlx5e_rq *rq,
 					    u32 *cqe_bcnt)
 {
 }
+
+static inline bool
+mlx5e_ktls_shampo_can_merge(struct sk_buff *skb, struct mlx5_cqe64 *cqe)
+{
+	return true;
+}
 #endif /* CONFIG_MLX5_EN_TLS */
 
 #endif /* __MLX5E_TLS_TXRX_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 22fea4739a2c..1586cb2404c0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -2271,7 +2271,7 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
 	if (*skb &&
 	    !(match &&
 	      mlx5e_hw_gro_skb_has_enough_space(*skb, data_bcnt, page_size) &&
-	      mlx5e_accel_shampo_can_merge(rq, cqe))) {
+	      mlx5e_accel_shampo_can_merge(*skb, cqe))) {
 		match = false;
 		mlx5e_shampo_flush_skb(rq, cqe, match);
 	}

base-commit: aa40afa831ebfe45e40a23721711059f2ac584d4
-- 
2.44.0

