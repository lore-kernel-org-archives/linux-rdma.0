Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.64
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794318311;
	b=H2D8/CmB9yZiP2T2fLWCs5Hg2OxEmYzRUiagQSem4d0FWxGVsbhzCzRdXW3pwqsiKhaF
	 BlRJMG8DFsqvHJ39LBSs+Ky2tWcL9whTaemZsmPsABF8OY0uJXAX5IxxestBVf3VXzsee
	 SlRTnRDaIHNCytNVJ23GI52h4l3/hgfqrTWNwXE1ChaYOiR8ayXTD9+31byOq5JuY33N7
	 vmiQhV4aDVN9PQRNUc11btiOx9euqrwA8rRtdQNP9frepeCED0O7T6GcKxAnVoo+7P0o+
	 8wM+CmKFKmE4vR94apSq5wORyAe+BQ7mJsfkTHNQAesSZsOk3JE8cJrmBi6AVV42c1g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794318311;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-NV-OnPremToCloud:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
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
	bh=mK/Kci4ToryXHZwBqbRQTofXOYBGDSN4+gy0DuOdXGQ=;
	b=dCfB+ofCeFCG/vLqKTeDqYQCm16/3AsjybUwzle1Fd7lr2/twUoc9cQrwoD9RhGDR8nE
	 K3fzGBujJG+VZknK0Tp1x93fXdsSTJRSO5EQ0IEL2tJW3g6FViawAAUgTLx2DNkyToO/2
	 qOakVcd7bIwXEwwiYrXQiaZgURK9hjzeaDj8TOntV/fV3CwHphn1iMLQ+olsjEkDRQmCB
	 6c58gJoO+Mhu18nOgOSyB6EBi8IKf3TEyIHHaBpI4OfafduBguyAsKu93EfTV07ndaKli
	 2SVU9QAIZEEkw9njjQ9hjazh2Cty7edPQoRfn3QgApvYvWg9SplSw0Xi7eBCQYtCmbA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=hTq+8hS4;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.64
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012064.outbound.protection.outlook.com [52.101.48.64])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E818606A332;
	Tue, 10 Nov 2026 13:45:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E818606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=hTq+8hS4
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RY2gjknzdU70csHGUTlz6araCY7R8A945mqSYQz4n0gnbzKIxtmoD1bdHKeQ67awSny9dfFfgmFXrhziXUbZkNmgbzG4gFLIv8x9eBIyE5zH0HB9EcKyztauZQd2Y0GfliMm8egy79duXqA2BdsVwZqlSyO8hBtbm4giofTrxA5dKwD3iNHmjhTIwjwST4nKvPGAjaEGMBoEOpyifdbczz6UbfXxMNhWOZDg4wgUvTBaQDs9Z6VH9WgpUOSEbRIBT4tsWEeT7ZAIxsguQKJGtRnmFyPSii//+br237WRd4cCBMfS7OmUJgs1k9wlmGWnBy0XtdyAcao7hkV4kWE2Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mK/Kci4ToryXHZwBqbRQTofXOYBGDSN4+gy0DuOdXGQ=;
 b=qw9ihGkeruUaSOTpfYTI0+qikgupSn8p4EUzB1EFypMt2vuwoiNnBF4DYM4WcHv1p4JA6uR5GXk03DOL7OjVaArfmiZO5AMKqVjfAmacmlrgKxqz2Lzau36fAkFg3NJHnhYxuetVUtE/ZnY6GcA75Lo8pgxMSpxUZtLsMo6/p5qIvB/ced6SL3VzRlp79FlF0q9t88K+dBq+wLw21Oh8Y0Ga4YS5WInNygsU3vF7ABNkIkBIuJSqsk3IukeNarwD3JlWa8CGL6M98s5l7iWBjVcDmp6QA+fk0EeTKIwiaIseCBjZtYPjOsunraj5RntgvXmq0IN7/TN3il8H83008g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mK/Kci4ToryXHZwBqbRQTofXOYBGDSN4+gy0DuOdXGQ=;
 b=hTq+8hS4+m5xd3ILuVYtFse8MlfGbrAydslGDB98pVty7IuM6oS/JdP4sK3xS/v1ZY/kdKwihACVTnCRaFTdOmJ8sbOMwYfUL0e4d8VQYumrfdibxmK2Y1ps+hAYjSwFs7/XklvFE8uElS8ogct1spk86c6K2hcO6OR1Tcs2eYHf4t6E6cL+TUn4Zv0kDh1OiZkPFOo8qMeyN8Cg2JTya/13FnNsoRV1d1pz+ZP7CmvHrfLPxlHK8ekDOfiJw1TSMEffe7u8khw+TTYPH+dSNDx1j0FK617xoONhgJjkJ5v4J23gTaAue2fltLW/VqqyawUCzW2AcsK6Ark7pZdFmA==
Received: from PH8PR02CA0054.namprd02.prod.outlook.com (2603:10b6:510:2da::14)
 by CH3PR12MB9314.namprd12.prod.outlook.com (2603:10b6:610:1c5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Tue, 10 Nov
 2026 13:45:07 +0000
Received: from CY4PEPF000392DD.namprd03.prod.outlook.com
 (2603:10b6:510:2da:cafe::3) by PH8PR02CA0054.outlook.office365.com
 (2603:10b6:510:2da::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 13:45:07 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF000392DD.mail.protection.outlook.com (10.167.247.123) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 13:45:06 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:44:43 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:44:43 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 05:44:39 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 12/24] RDMA/mlx5: Add shadow FIFO infrastructure for UMR completions
Date: Tue, 10 Nov 2026 15:43:08 +0200
Message-ID: <20261110134320.34408-13-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261110134320.34408-1-yishaih@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF000392DD:EE_|CH3PR12MB9314:EE_
X-MS-Office365-Filtering-Correlation-Id: fea6150a-b74b-49b3-a7a1-08df3f30d4ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|376014|1800799024|18002099003|22082099003|5023799004|56012099006|261028144727099003|10067099003|11063799006|261102123227099003|261022075727099003|261022113327099003|261022105027099003|261021133027099003|261021123027099003|261021135927099003|261026130827099003|261021121427099003|261021130227099003|261026140227099003|261022115727099003|261009223027099003|261026135527099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	I/Bduyd/V3+KluN994Vu312CfjDNb8mtP4BVBZbAdSPweyMomsQXr74jdiiTym3yQ9VojXq4OOKw/hX84Bjh5sj+FoxBmAjDN1gqOYu291RvJagpj6BQcTWtf3oJ18lhl0DRF8kqn3L9hr97NeC6Ldh0gXubf/kcwgX4S84dz/5FdlNlScN7crIZgj46olaQQ3ZbY++wG0bagubHIySXcOd8DlBzBGT6r/lNSBxCu2C/LDeoJTgZGrt267pEsWxGPmQbii5Yw1aBei2y6LZ/aR0jJahsPgmloyOFQGPGajdBelUZF+GYL/N0ICZzkMi7WvbSDUs6zRtQyCybVZixgVqVYqasVj4+HK8FVfYL2g01uviZcVBpiTTgyBsEyAAB29MRWHherbpYItL08bFzBmd+3qqK9AozscHjz/SjpqnUExKmXH7N5a+HEI4rOzWWzYwFCHFiP9Yq2ZPdWvm7GENOnJKb7Vx73Cct9jd3bveeOmHRt2TaNi49tNglXUB5dAbLrCMnt11yFIpYdO6JI7XU2eCWWJGTMc9EDmI3nPJB8566WDbZlQWfmvDXgFlL0LtXYvFQ9OzEmPHFU44YA6guIqRbZymH3O0cUd5NSMG0R9+OWuw6Ii/bDQn6WtgsRIuFY7QYr+1XXT2u5IMySpig1P+85RezDWvU2ePKA5kJ1j8IgOqTXVKNv9Q36BuJF7khE9Wmx1f2jQqnp8U1mw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(376014)(1800799024)(18002099003)(22082099003)(5023799004)(56012099006)(261028144727099003)(10067099003)(11063799006)(261102123227099003)(261022075727099003)(261022113327099003)(261022105027099003)(261021133027099003)(261021123027099003)(261021135927099003)(261026130827099003)(261021121427099003)(261021130227099003)(261026140227099003)(261022115727099003)(261009223027099003)(261026135527099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	9WgOiRoig4F7koCUGI7YYwBJR0gsmhorHrwDBc0EL11dvFpmzCv4RFmLtujM6u3uJwnHCwxgnoSXrYfDcnGqq/IreU/pYBpCXhq3aIC9LxL28k9I7fjH2QwkUscXKCzUYXFZa2ODczOVU7iPpk/T5wq9WGodWGIvgcC2Z5v1O2To2pEOAux9/bdUbkBLfLXRa6wf49iNzOntXJ14liXloxvEUQlP21+cku0y9Kgz9CCA7k0khPjNEOS4isvXMTj7Z3iCxhMV8bZiwwyExN42DMZJusAeKXGxS4m/q6Wly9Ccf3YUK7KcXThFIWya6EQSJTUzsPbVYLKaCTomW+9JcLWpqmP7If8HnTVhvkrsBHrSvh/6qbCSvEEvt/DXwUiXwBeruxqQ1uvp5Hpkxzjpo6Ig7FJcOhzauJwJ1guIyWpYl0uCdA/unff/wyFBJ/2P
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 13:45:06.9971
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fea6150a-b74b-49b3-a7a1-08df3f30d4ca
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF000392DD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9314

The UMR CQ is polled by the generic path, which finds the completed
request by indexing qp->sq.wrid[] with the CQE wqe_counter. A hostile
NIC can forge it to complete a request other than the one that really
completed, or one that is not pending at all.

The UMR QP signals every WR, and its send queue completes in posting
order. In adversarial mode, keep a FIFO of the posted UMR contexts, so
a follow-up patch can check each CQE against the oldest pending
request instead of trusting it. Each context also records the
SQ producer counter it was posted at, as its address alone doesn't
identify the post: it is usually on the stack and reused across posts.

Nothing consumes the FIFO yet.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 10 +++++++
 drivers/infiniband/hw/mlx5/umr.c     | 42 +++++++++++++++++++++++-----
 drivers/infiniband/hw/mlx5/umr.h     |  6 ++++
 3 files changed, 51 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 4833f42b3fd1..9cc4b2f99b69 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -758,6 +758,12 @@ enum {
 	MLX5_UMR_STATE_ERR,
 };
 
+#define MLX5_UMR_MAX_WR 128
+static_assert((MLX5_UMR_MAX_WR & (MLX5_UMR_MAX_WR - 1)) == 0,
+	      "MLX5_UMR_MAX_WR must be a power of two for FIFO index masking");
+
+struct mlx5r_umr_context;
+
 struct umr_common {
 	struct ib_pd	*pd;
 	struct ib_cq	*cq;
@@ -771,6 +777,10 @@ struct umr_common {
 	unsigned int state;
 	/* Protects from repeat UMR QP creation */
 	struct mutex init_lock;
+	/* Posted UMR contexts in posting order, adversarial_mode only */
+	struct mlx5r_umr_context **pending;
+	u32 pending_head;
+	u32 pending_tail;
 };
 
 struct mlx5_ib_port_resources {
diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx5/umr.c
index 4a3fa79eba3a..aba79a19d627 100644
--- a/drivers/infiniband/hw/mlx5/umr.c
+++ b/drivers/infiniband/hw/mlx5/umr.c
@@ -98,9 +98,7 @@ static int umr_check_mkey_mask(struct mlx5_ib_dev *dev, u64 mask)
 	return 0;
 }
 
-enum {
-	MAX_UMR_WR = 128,
-};
+#define MAX_UMR_WR MLX5_UMR_MAX_WR
 
 static int mlx5r_umr_qp_rst2rts(struct mlx5_ib_dev *dev, struct ib_qp *qp)
 {
@@ -181,6 +179,16 @@ int mlx5r_umr_resource_init(struct mlx5_ib_dev *dev)
 	if (ret)
 		goto destroy_qp;
 
+	if (mlx5_ib_adversarial_mode) {
+		dev->umrc.pending = kcalloc(MAX_UMR_WR,
+					    sizeof(*dev->umrc.pending),
+					    GFP_KERNEL);
+		if (!dev->umrc.pending) {
+			ret = -ENOMEM;
+			goto destroy_qp;
+		}
+	}
+
 	dev->umrc.cq = cq;
 
 	sema_init(&dev->umrc.sem, MAX_UMR_WR);
@@ -208,6 +216,7 @@ void mlx5r_umr_resource_cleanup(struct mlx5_ib_dev *dev)
 	/* After device init, UMR cp/qp are not unset during the lifetime. */
 	ib_destroy_qp(dev->umrc.qp);
 	ib_free_cq(dev->umrc.cq);
+	kfree(dev->umrc.pending);
 }
 
 int mlx5r_umr_init(struct mlx5_ib_dev *dev)
@@ -236,7 +245,8 @@ void mlx5r_umr_cleanup(struct mlx5_ib_dev *dev)
 }
 
 
-static int mlx5r_umr_post_send(struct ib_qp *ibqp, u32 mkey, struct ib_cqe *cqe,
+static int mlx5r_umr_post_send(struct ib_qp *ibqp, u32 mkey,
+			       struct mlx5r_umr_context *ctx,
 			       struct mlx5r_umr_wqe *wqe, bool with_data)
 {
 	unsigned int wqe_size =
@@ -245,6 +255,7 @@ static int mlx5r_umr_post_send(struct ib_qp *ibqp, u32 mkey, struct ib_cqe *cqe,
 				    sizeof(struct mlx5_wqe_data_seg);
 	struct mlx5_ib_dev *dev = to_mdev(ibqp->device);
 	struct mlx5_core_dev *mdev = dev->mdev;
+	struct umr_common *umrc = &dev->umrc;
 	struct mlx5_ib_qp *qp = to_mqp(ibqp);
 	struct mlx5_wqe_ctrl_seg *ctrl;
 	union {
@@ -267,13 +278,30 @@ static int mlx5r_umr_post_send(struct ib_qp *ibqp, u32 mkey, struct ib_cqe *cqe,
 		goto out;
 
 	qp->sq.wr_data[idx] = MLX5_IB_WR_UMR;
+	if (mlx5_ib_adversarial_mode) {
+		/* mlx5r_finish_wqe() advances cur_post, so record it first */
+		ctx->wqe_ctr = qp->sq.cur_post;
+	}
 
 	mlx5r_memcpy_send_wqe(&qp->sq, &cur_edge, &seg, &size, wqe, wqe_size);
 
-	id.ib_cqe = cqe;
+	id.ib_cqe = &ctx->cqe;
 	mlx5r_finish_wqe(qp, ctrl, seg, size, cur_edge, idx, id.wr_id, 0,
 			 MLX5_FENCE_MODE_INITIATOR_SMALL, MLX5_OPCODE_UMR);
 
+	/*
+	 * Push to the shadow FIFO before the doorbell, so the entry exists
+	 * before a CQE for it can arrive. A hostile NIC can post a CQE before
+	 * the doorbell, so the UMR CQ poller, on another CPU, can't rely on
+	 * the doorbell to see ctx->wqe_ctr and ctx->cqe.done with the entry.
+	 * Publish it with a release, which pairs with the poller's acquire.
+	 */
+	if (mlx5_ib_adversarial_mode) {
+		smp_store_release(&umrc->pending[umrc->pending_tail & (MAX_UMR_WR - 1)],
+				  ctx);
+		umrc->pending_tail++;
+	}
+
 	mlx5r_ring_db(qp, 1, ctrl);
 
 out:
@@ -303,7 +331,7 @@ static int mlx5r_umr_recover(struct mlx5_ib_dev *dev, u32 mkey,
 	 * This will ensure that all the previous WRs got a completion before
 	 * we set the QP state to RESET.
 	 */
-	err = mlx5r_umr_post_send(umrc->qp, mkey, &umr_context->cqe, wqe,
+	err = mlx5r_umr_post_send(umrc->qp, mkey, umr_context, wqe,
 				  with_data);
 	if (err) {
 		mlx5_ib_warn(dev, "UMR recovery post send failed, err %d\n", err);
@@ -380,7 +408,7 @@ static int mlx5r_umr_post_send_wait(struct mlx5_ib_dev *dev, u32 mkey,
 			continue;
 		}
 
-		err = mlx5r_umr_post_send(umrc->qp, mkey, &umr_context.cqe, wqe,
+		err = mlx5r_umr_post_send(umrc->qp, mkey, &umr_context, wqe,
 					  with_data);
 		mutex_unlock(&umrc->lock);
 		if (err) {
diff --git a/drivers/infiniband/hw/mlx5/umr.h b/drivers/infiniband/hw/mlx5/umr.h
index bda7123781a9..0b245eec521f 100644
--- a/drivers/infiniband/hw/mlx5/umr.h
+++ b/drivers/infiniband/hw/mlx5/umr.h
@@ -84,6 +84,12 @@ struct mlx5r_umr_context {
 	struct ib_cqe cqe;
 	enum ib_wc_status status;
 	struct completion done;
+	/*
+	 * SQ producer counter the WQE was posted at, matched against the CQE
+	 * wqe_counter in adversarial_mode. Unlike the context address, which
+	 * is reused across posts, or the ring slot, it identifies the WQE.
+	 */
+	u16 wqe_ctr;
 };
 
 struct mlx5r_umr_wqe {
-- 
2.18.1

