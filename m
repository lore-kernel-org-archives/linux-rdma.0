Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.36
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793724114;
	b=J9offvEvCEecQMkZlRWaJk7aonDGbPm0cAyn2vv1Jr6eq4A0AHDON4EWEMZhnCyEoxb6
	 DLwgB9n4YjBvON5ezezPEIBQ7RKhZfgn1FQa961+zD7NDmQvw8qXUmbYnvDlDgRWhZlJB
	 CmOTKXGzhjCY6KWJT2dHklnKxFOMCZejZWAsIhAVwHIIAPSnQ4G68jHZ327MyZWOYdHeo
	 2InaZbDc0scBBAnG5eWZYGY7HzQ7XGgRMUkfH62tx/KWT0Yezf1HbTWAKhHWeyBp1aHdA
	 meN/MRc345OckjOuZWFlqXytuqWm2omTPg7xZPt5iw6kDHRrQmaDlH0Omdx/S+i6upg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793724114;
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
	bh=y1dqJhYy87wM6Hg0z2R088z6zlwII5pYx8g7E2ZD3r4=;
	b=Mj+tFUxh5DoU+gj/BrEJ/TwaZlnrHq2APf0CQU7zcFrtlCUosKA9nTvXRVb84/4tq+im
	 n8QJcinvVu1xQmULefHXDY0kraG2O3ePHtUHQi9l1OFvcwVplZ/H+Mhgjst6rgRRqkjjn
	 oa6h1WZRpS2PBg2F2BoijUsubBgeG0ajL0Gj80sL8olIT0jk2+ZkoHs/jUw9afHYe4nlZ
	 xf1I1vLDsqGBnCBnd2Z5XSH04/BTpzE+qjKPHx/+Z5fcu10XpiIuw1DpS5qHtMjgUO4ip
	 E58IdyS1HfLSf7JAG8eteT+uXr8/uuC5F0H2bdAb8dyMp9YrC3OHVxDdAFb1Z9D4j5Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=YuzXnxE4;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.36
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012036.outbound.protection.outlook.com [40.107.209.36])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B28606EEAF;
	Tue,  3 Nov 2026 16:41:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 95B28606EEAF
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=YuzXnxE4
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M+RN1gqDodTYCPoU2jvKS91jpG3gtcYeKJA7cbJtKneZ/yDPepO+XFyY0EVseBeWZvOISIYprfWGyhWXZYn/XBaWdmQniyuq6/QFed+sEnDwQHQTgXT+o2Zun3JE3qim1Y4bl5SGpOM4KfScMll7SkImOvUbCqbyhhKRNTJvipumHuYM9nNjkQ9wkdm+9tez/YENta+KO+O2/WkT8/0QiyBzIvDa4sl4NAYocDfMxq4bWK9Su6Ik0jrtTEPCLedIMkKU0jzAKtbf0ns9mzUP/0xRyzTBJAx3LjfYzO2ylsvR5W0pdYcoyTWwv1KIfBNes+s3tB5Su/JpmChKZsoCvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y1dqJhYy87wM6Hg0z2R088z6zlwII5pYx8g7E2ZD3r4=;
 b=pQdt30TKo19djAqk7UQn4uq6fQ0xKw0ZXwM4Dafia+FR+8P7YIhtHYeOHUEBR3dCOwA6Lc0ekQa5RwZthavq4qx14cQxVvF4RFZOIGc4IdbgiswJXfh6talYbVOdwQStIusDA0uUd54EmdW+OoExEgLOSoNIjOs4uAtgyi473t5JT7LILhYJ4O30ELv/Yu1dxoiNQX94xNL65qc2X0HqB0F4IYeHxT9mFckBR4bWxZyg6+9tdb2ZarCm6VSfoaE3JHKMuh5+ZhC2Hehne5/K341Wee3z98ToxmHuVgYCaqHyDCVXFL4Hp0h6Aax9iako1A/8pBmm3VJXDluIs4Aflw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y1dqJhYy87wM6Hg0z2R088z6zlwII5pYx8g7E2ZD3r4=;
 b=YuzXnxE4dzuRYBZgRNHgYigqhyiPuj7VzFQ3fw3K9MtQ/bgoxYiAQgef1P7SzZAFs2vr53a1y2FFL4HV8LmdgLp+fu5B2HNy+SBYOA32u02IjHMWDaobCUrW0sZqbZPpXK5gytsr40WpzkwaHLcU6vKqoao5Y1rshXwtsly5wbQvmloQCwQX02/3zwaIioUq1FOVlg6ad9GqpA5cXVx9x7WbnUNkp92XXgv44Mo3VW2bGLCQJIF8XjIa1QefJr4E0bfmuJ3Nj6YAk05lAR0MCShMk4kdM7260eDJ6eef2W4Gv5EPb2/qkk0cNnkSTeDiqMAcoQKBPT/0C7hb2WLYSA==
Received: from CH5PR03CA0015.namprd03.prod.outlook.com (2603:10b6:610:1f1::13)
 by CH1PR12MB9600.namprd12.prod.outlook.com (2603:10b6:610:2ae::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 16:41:44 +0000
Received: from BL2PEPF000352CB.namprd02.prod.outlook.com
 (2603:10b6:610:1f1:cafe::6e) by CH5PR03CA0015.outlook.office365.com
 (2603:10b6:610:1f1::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 16:41:41 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL2PEPF000352CB.mail.protection.outlook.com (10.167.249.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 16:41:41 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:41:12 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:41:12 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 3 Nov
 2026 08:41:08 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 11/23] RDMA/mlx5: Add shadow FIFO infrastructure for UMR completions
Date: Tue, 3 Nov 2026 18:39:37 +0200
Message-ID: <20261103163949.1554-12-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261103163949.1554-1-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL2PEPF000352CB:EE_|CH1PR12MB9600:EE_
X-MS-Office365-Filtering-Correlation-Id: 9dc84aba-fe0d-425d-40a5-08df39c956a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700016|23010399003|18002099003|22082099003|261102123227099003|56012099006|10067099003|261009223027099003|261022115727099003|261022113327099003|261022105027099003|261021121427099003|261021130227099003|261021133027099003|261021123027099003|261021135927099003|261022075727099003|5023799004|11063799006|261026130827099003|261026121527099003|261028144727099003|261026135527099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	aeCHCjOOK5pZxZtPNI/oAJl+MYru2l8dOgDQc657JR2gBQkOQx/CBio8AWQ1dullv8+iNZgfJOWpsse//eumnBAeO9kRccMaYCTIX6u5JpT+Qwm8GzMRxWyvdZwIzlGcsu8VFqF8/xKglocfhJdB/eKLQubpJKEjK+BNlUWzEvOV2ZoDiJ10jAu5JGDZBN6ExZDmP7F9p1No7Wr02ZhWCxBxmsr4c0dccGafxLUk9Y9XxI2uL6st9RnyX9+lFaP+XtQw82bpuzjyI5FTZgH5cUq9ShNIO6n9nOVmb8HLA/FTOQbcO1/iPtTpsxus4Z7W+xbcnkJm5Jb+G+jwmCoZxY+HRsG+Ls8e6B6ia81HOObvlckrzl1jEOH+ZNYgTw+bsYpfw8Z0TdxpvHxafNDDvrQMQhWpNaRzLdH0Sxfg/apeL25CMTIBtb1npRjm42eLpuIOyqNVUCyDxYfGj8xU8EYJOeZDRyKPnZIY39q5wE12+MGFTVHIE8Qey/Pk2kHp5Hltd+7GP0tmcqDVONQZvwsB1ylKpoFGXfK9egG2EuC8D2onm/LLJeXj6wNjyLZvbxdZmzcavu+qeHFl865dDUjO/d8YH+c5lO8KQyO/O1jx1QCPL/FCSh6kfTJ5TIpJhMzAoiw6BZXkSo9nCKsIwqPvqXMlDDPRN+ENlmVq3w0r6xqVqsCaCVrgqfba/eaBZbZ0cMPQENn1ycdCdjFHTQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700016)(23010399003)(18002099003)(22082099003)(261102123227099003)(56012099006)(10067099003)(261009223027099003)(261022115727099003)(261022113327099003)(261022105027099003)(261021121427099003)(261021130227099003)(261021133027099003)(261021123027099003)(261021135927099003)(261022075727099003)(5023799004)(11063799006)(261026130827099003)(261026121527099003)(261028144727099003)(261026135527099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	fniTOyB2EzXQCPjthuH2f0+9/6SkUyJmI3cpc0/ym9Dal6XrGf4t4eiH341uZJvXGY7/TI0vOKxQzp4DWaWdm78DS87+1hztlanRjK9C0empSTvsv462PCwDnICBhQtFwjz6nqrk3LGA+1uwHIla9rqSRBL46i46C23XiXrWhqTTItFbCX87KfNak1WO0lSvt5iDqKVLInlp6sEX1K1ZvjUCTxqvPfJvsSdRJQA4pgvzwqEirJYwOetwhz5eV/9VyedqX55QbLBAGoj7XayTuIvFyG83i2sjrahlIrg0x4y9NaWpAeSY+AEMA735V5B/z67wxWStof9VAsWPcIBWk0wFLdNwGNbmSx1w3n9K3Bi1trpUYqDGVBZ/PTGhy6eWFSiwDGsuI+XQsAV8TqX62/jKAK06dYEE/cpQFjK4X/JETCLFWiEQkyJIkEyTYjiK
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 16:41:41.2923
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dc84aba-fe0d-425d-40a5-08df39c956a3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL2PEPF000352CB.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9600

The UMR CQ is polled by the generic path, which finds the completed
request by indexing qp->sq.wrid[] with the CQE wqe_counter. A hostile
NIC can forge it to complete a request other than the one that really
completed, or one that is not pending at all.

The UMR QP is RC and signals every WR, so its completions arrive in
posting order. In adversarial mode, keep a FIFO of the posted UMR
contexts, so a follow-up patch can check each CQE against the oldest
pending request instead of trusting it. Each context also records the
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

