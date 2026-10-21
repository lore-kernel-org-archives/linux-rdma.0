Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.1
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792564112;
	b=Wsdai4J8CqbpbcSYwnAL58SrNX9GKFZWz9r7NgrY+o9q6TI8gYh0NFl/QMKzSJFludCb
	 wYygwQdgOVHjyeQCJe2BHCswgPohJb+cBVKo13qWEmbYFPmZVf/XySKLnHDSuL2jZRJvc
	 nLJNyvCaYYz7wlmFHFGNF23ep6rvPUni2AnQaq641Mj9nDurjNTUEF9RLFzM1EFFO4Fee
	 pZ9OLmLOfDkbeVD258cU1Nc6Suy1kyNn5J642G77emPeR9qoBzuvcJEAaaFU0CFc4D8u0
	 Zct9D55ngT3mo4Fm32hx1B+S8jBt4ahvhFIp29yXI4OtsCC9MS/znc/USrhxUIn9NJg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792564112;
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
	bh=jIFTTej/y+5oFuiG9CZfbn8dfBNLngp+zvcYRjgJiNM=;
	b=Qg4IFMg/svXr7zbuql1H+hmeSEzq7iQYMDE+M36OLBHj2weW9Hi5TECNehlK4Xa43hfs
	 YHCszqsSPgA3BKGF44pw9nqtLouDHP+Zrl0SqsxyzhplbhGldVMHQzxodrj0yuKvbRpjA
	 yr2lOExFoOhOKJIRC6UKpMAAlFK2XKJoY2w+eGonUyoKC9pi7J3PTUNXJvuNDq93d5pqA
	 PS09E+B76lD8JvtfZXT6OFGPf/mRzGD8DKoNq1naB7PSqnxTFV3Nkpaj/r8Hmah5UcqsC
	 4WUe1mabEQcQk0I38Si1YV6IYmnLbqXLGsNOlT7JyRsXaxn5LDL9hly15t4eCgpX+Cw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=HJrfdobD;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.1
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013001.outbound.protection.outlook.com [40.93.196.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC5C606A31A;
	Wed, 21 Oct 2026 06:28:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6AC5C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=HJrfdobD
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DprZZy53WzMqnjjc0kTL7cIIaTN5qQomPvrhxe0S8IwEV/4xkLdeZEUh6E6b5aUuUHHdbhXZAoGu55kif6/HN6CR0EdyY+1vrp3Eo6zMChSZDuR/smXUxe+B6SfuJEiFX13B3clPkf1V1BUVwoG+2PGM85/tue/B9aME6yH9JfUe/TYdYDPz+Q83q7HXrX8SQgsVRKFESf+FchPP4UrYu8n/0KfdBnnih1WvggDp3J1uhOVT71+/l9D+1lwDV8bzQiDKc39CPabZhoq/tn5inkNGtSZMxriq3KPyerCJOCDr4qN638QsrtbvJp1qNGY4pckXiBCYxVjhY8qDRfJKhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jIFTTej/y+5oFuiG9CZfbn8dfBNLngp+zvcYRjgJiNM=;
 b=rLdhQ0pa8F/vAMDJqYcsSBkP+XgT8WF/PYbjb1lzAcmIEKhdhB5k1wnwlmwTIjtwGT7ilOk0tfmOo1ZVlU4hlP182+wgholn3aU5ofQZAF5imtM4Jg4V3a7caSx+yh5aFyHxyEw6nWLipNDYFeeRvk0eWcpIvNqQLts2TiGVXCeRQmn2RJmr8QanAQNEqHyzkkDBjuB+t4IZwEzEZMTy3pd1fv0mCAJ0kaRNfaNoXbid2cH292mOJK8Wz9GsTYxji4s/vXTwyiH8YReyJveKsJdcTCf5ARiX6WSDSOaxVFRYtTtyM58dwdKAGZt9sTZ7i4ThdDBI7rp1BvCNJ9O3yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jIFTTej/y+5oFuiG9CZfbn8dfBNLngp+zvcYRjgJiNM=;
 b=HJrfdobDvm/X1GtkodiIMC9Bv4oye5yUivPRcN14MAh1ea6dN9Lh8S+vdm0sx+kUt9PFUY6T2jWjsUNPLpj9D6G5uJfl2lVVX9bi/mMfBa0DKfDcBzUVF2bg6ESdTue1+ngxfRBwJZzyAPsMSuKFij2NWImK6ZcjpmpIU1NFvIJJJl5VBvxEOPNapJQGBWp3Blhlf/GGYOkw2ua6uJbjTT2eZsF4wfPVub+vrxx6W/8Hrn0502qGmq/jhCYxYnbZ6J6AZmVE+FJcZiylnf3FxtGMxZvBis5Rw+bmtmXMIe2sByx+zEr3Ml/+aMQr9BwVGk67WjYLoWiG5aEsDoNw6A==
Received: from DS7PR03CA0297.namprd03.prod.outlook.com (2603:10b6:5:3ad::32)
 by PH8PR12MB6820.namprd12.prod.outlook.com (2603:10b6:510:1cb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Wed, 21 Oct
 2026 06:28:26 +0000
Received: from DM3PEPF000265B7.namprd04.prod.outlook.com
 (2603:10b6:5:3ad:cafe::70) by DS7PR03CA0297.outlook.office365.com
 (2603:10b6:5:3ad::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.546.16 via Frontend Transport; Wed,
 21 Oct 2026 06:28:26 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM3PEPF000265B7.mail.protection.outlook.com (10.167.23.244) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15 via Frontend Transport; Wed, 21 Oct 2026 06:28:26 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 20 Oct
 2026 23:28:16 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 20 Oct 2026 23:28:16 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Tue, 20 Oct 2026 23:28:11 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Boris Pismenny <borisp@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
	Daniel Zahka <daniel.zahka@gmail.com>, Dragos Tatulea <dtatulea@nvidia.com>,
	Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Raed Salem <raeds@nvidia.com>, Rahul Rameshbabu
	<rrameshbabu@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net V2] net/mlx5e: SHAMPO: Do not merge PSP packets
Date: Wed, 21 Oct 2026 09:28:05 +0300
Message-ID: <20261021062805.3466208-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DM3PEPF000265B7:EE_|PH8PR12MB6820:EE_
X-MS-Office365-Filtering-Correlation-Id: d43f2e2f-70af-4092-3244-08df2f3c83b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|82310400026|23010399003|36860700016|13003099007|11063799006|261009223027099003|10067099003|56012099006|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	5JaMnMej8zcbaxGe3zBQIiQ0ubYajNy/cPQHJZFJCe6P/6a21sgAl+HVzR0GPQqC7qcVlt8OSoHI+VGuwYCleeo72RP593KKPPTM2pp1JwyuAitz3RMpziWcKgXFq4d5WO572g5E4auv0M8F0xnCWAXeTeL75+DxK13HTt0TpNl/jRUvrMxIEUUvrYZFEw4E2rMhHi1L8mYJYN8oDBXb9S6N0DepX8vbtAlY909wJnLVrwzaS8Muv0Bj9BN3muAGC785GcA/FLy/U1xtOI/7ZX3erHWrchC+tLaUM7gjPreKYhbliB3o5ixOsyccruMX7W2vsKVQXB9mQXA0M2FNI13LEDBphCSxFF8Sgl2GBUz2tpldUcut1z6nLOc7jC913NcddQLA8Sv+A7FVzaWX44fvE3DK2a2b2UIL3p/Xb89yvD6Kn6QqUByRtYUrHZgsmisVTGmbzJGZvloDOOfFUkAX2kPz5IrVUhuiovTLiIGShIJbbGEqN4UtVuTK6TUV6RyeSphL7nbmreJpqb78605IVdTTLBrUknrpnWH2Lv63hxsFrYAW+d9LhmT1qyLKKhwznD9o9wm1dsLV7tlszZab9sOyYPqlCwlyvj6V0HBfs8AGz6hVxrvCE7P87uyjxdvaHj5BuQD/mc/yFau/Sp1zppVuQdqizfjmzJnCyeczlQDSuMcufb9LiwStMg6WNta7qvIKlxq1tExNn6EGWg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(82310400026)(23010399003)(36860700016)(13003099007)(11063799006)(261009223027099003)(10067099003)(56012099006)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	6Xpr9hRM7kbdDI1EWy8Gm8HE9+kg89aMDaYv3LtLg4Xc1lRvK1fLXWLSjZGLt0g6shiXO9SRnVef7aFM3AfD2qIqSxBHbcp8aNQxeIS41jYgyLvnh2PZ6oO05oDpCE/2UO3FkWboTen3yyXS6Ja0UsFX6l8LBSFtZmJiu7FWmlppwIutc+S5dGAy64naBu1mB+slyIxTMeCUkIEA2FRmt5eLUm0i93R78rtIWt9Tj8v3QDe00PsRArVQx1ezfdoh9rbGsttlfJJhpdzzrle3cQLK/405i8vzbttxlQHnBmaCaQGjwN5wNOSKgVcIyOxlzKyW66Lrc29dNC8aboHoDIJNRyL+hgud/x5/P9H5SbfnRlyEuiJbgwVWoOGWmVxeV3/lKfZNFraeK3NNvcKAsAEcrnZHyibVRs0v0NswTnP7jOv69gPvTKEBy17A70Kb
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 06:28:26.2533
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d43f2e2f-70af-4092-3244-08df2f3c83b3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM3PEPF000265B7.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6820

From: Cosmin Ratiu <cratiu@nvidia.com>

PSP packets are UDP-encapsulated, and enabling HW GRO (SHAMPO in mlx5)
makes it possible to merge those packets in a silly way:
IP|UDP|PSP1|payload1|PSP2|payload2|...

That happens because the HW GRO machinery doesn't know about PSP and
considers it part of the UDP payload.

Reject merging when the incoming CQE has PSP marker or the pending skb
has the PSP extension.

Fixes: 29d7f433fcec ("net/mlx5e: Add Rx data path offload")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_accel/en_accel.h |  6 ++++++
 .../ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.h | 13 +++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c     |  6 ++++--
 3 files changed, 23 insertions(+), 2 deletions(-)

V2:
- Separated from the patchset.
- Moved the PSP merge check into a helper in psp_rxtx.h, with a stub
  returning true when CONFIG_MLX5_EN_PSP is off, and an en_accel.h
  wrapper, replacing the #ifdef in en_rx.c.
- Also reject merging when the pending skb already has the PSP
  extension, not only when the incoming CQE has the PSP marker.
- Fixed the commit message diagram and capitalized SHAMPO in the
  subject.

V1:
https://lore.kernel.org/all/20260917175433.4090878-8-tariqt@nvidia.com/

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index 3f212e46fc2f..5a340f1435e6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -218,6 +218,12 @@ static inline void mlx5e_accel_tx_finish(struct mlx5e_txqsq *sq,
 #endif
 }
 
+static inline bool
+mlx5e_accel_shampo_can_merge(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
+{
+	return mlx5e_psp_shampo_can_merge(rq->hw_gro_data->skb, cqe);
+}
+
 static inline int mlx5e_accel_init_rx(struct mlx5e_priv *priv)
 {
 	return mlx5e_ktls_init_rx(priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.h
index 2b080c39cc37..9fd1ee789de0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.h
@@ -85,6 +85,13 @@ static inline bool mlx5e_psp_is_rx_flow(struct mlx5_cqe64 *cqe)
 	return MLX5_PSP_METADATA_MARKER(be32_to_cpu(cqe->ft_metadata));
 }
 
+static inline bool
+mlx5e_psp_shampo_can_merge(struct sk_buff *skb, struct mlx5_cqe64 *cqe)
+{
+	/* PSP packets cannot be merged. */
+	return !skb_ext_exist(skb, SKB_EXT_PSP) && !mlx5e_psp_is_rx_flow(cqe);
+}
+
 bool mlx5e_psp_offload_handle_rx_skb(struct net_device *netdev, struct sk_buff *skb,
 				     struct mlx5_cqe64 *cqe);
 #else
@@ -110,6 +117,12 @@ static inline bool mlx5e_psp_is_rx_flow(struct mlx5_cqe64 *cqe)
 	return false;
 }
 
+static inline bool
+mlx5e_psp_shampo_can_merge(struct sk_buff *skb, struct mlx5_cqe64 *cqe)
+{
+	return true;
+}
+
 static inline bool mlx5e_psp_offload_handle_rx_skb(struct net_device *netdev,
 						   struct sk_buff *skb,
 						   struct mlx5_cqe64 *cqe)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 903af3b3e779..d49f26323b1e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -49,6 +49,7 @@
 #include "en_rep.h"
 #include "en/rep/tc.h"
 #include "ipoib/ipoib.h"
+#include "en_accel/en_accel.h"
 #include "en_accel/ipsec.h"
 #include "en_accel/macsec.h"
 #include "en_accel/psp_rxtx.h"
@@ -2268,8 +2269,9 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
 	}
 
 	if (*skb &&
-	    !(match && mlx5e_hw_gro_skb_has_enough_space(*skb, data_bcnt,
-							 page_size))) {
+	    !(match &&
+	      mlx5e_hw_gro_skb_has_enough_space(*skb, data_bcnt, page_size) &&
+	      mlx5e_accel_shampo_can_merge(rq, cqe))) {
 		match = false;
 		mlx5e_shampo_flush_skb(rq, cqe, match);
 	}

base-commit: b6ef0d965fe8ce0ee4b4dcb58b3511f83003e42d
-- 
2.44.0

