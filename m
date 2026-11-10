Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794318348;
	b=YP1wLLqsH6Do0Vd9knpE6NW3jOBwwNPBCiKWHON8KOd7NyPCPWnOl61a+6paXVZ9pZlO
	 hS7hByQPv35/WqvjxFhaVJOHJysbHHbhHAMzTLI7Ne0+6J+SurfEXSfBCy4Sdmq7ze4BL
	 0b97tlLYZTJK3oh5J4Cy021Ks2eM5Vg90Ab0ZqpZUn+6jmwyowo3NJdNjH8rTTHxJjkgl
	 M41rBLdYbf/Ch16jlgM0QaWbrcGfnyl1Hw+/pgWp4HBVFhY6IDCZHil2X8VxTYOm6POek
	 Cukcgdf/Gzptrk7ydBaqwUSKmt1JTIaOn83BdVi3Q2JPSisLy3Fbl6P2t86gSQDFapQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794318348;
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
	bh=T9mNLay2BCwKHr6bn9M76oEfW+D3lVuybhHz2U8w9UY=;
	b=DnD174FvBrO9/yHAU1NOXDgbUmQVcfwShVtAUKrVICTX+4bdj28reLi3YtG/uexCjZ6A
	 Ov75WvHGjINGB9n1fbXN914Fx+DahTIunoSMd7DBGkrmo65o5hs8xvaSE/A/vfjlozSQe
	 eogZABmFKBncXlKA5KsHZvl6R2XW3P5zszxWKGVTh2NZbR7yFbyWyvS0XThTk1rcNkQ1T
	 n+94GdPTiQY47SZ0t99eLfty6dyrKDJ2iRTDyrgez305tr0yd9KwEtWuZHkkxtJF5gG59
	 VBuWjWSVyGgjvF0p9WxtbZ8zoA5gAu0LBVNN/d1dL3uMeEITYXMCvxcw2r3d7vbEnpw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=nMHVk4pO;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.53
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010053.outbound.protection.outlook.com [52.101.56.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94C3606A333;
	Tue, 10 Nov 2026 13:45:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C94C3606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=nMHVk4pO
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B5NrmAI2GutkIFaoeMIDoKhTqdgahfUpcGQeD6SAiS0eWQmEjUOoG31RreyjgcP5QBpTcrnlHL+JPN+a7xGTxa5vMLuTt6JFtsv0SSUC09S7E4EJMGMQW1WlAY+QO7j0mQBzwsTxO9cfhEQiaBs6o+p1QT3JPqEXO+WBe2Rcd1i9aIriy5vuT0wvfqv/DNKt4PR1Uk7xlH4LCbfrkMxs65RESQFNKgybpsoFG6dIpIJuhNbiBZ77zOf+NEdGINwRsefnFyPXNu9eA5cp9EoefpfbgQGL3wBf2zK/5jJj2J6SM+tL8rPtWq+rG+kLYv279qMfPuAiJzhzFyHp/IN3Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T9mNLay2BCwKHr6bn9M76oEfW+D3lVuybhHz2U8w9UY=;
 b=a9/h6wn3TlViTRJOgsO3v16GBtgZxs8iuGLAiURONiHvpS2Xd3e/8xR7SBJFCOsg25XcOZT2OV4X/D8u4XbHKqyyVT3b3KiI0oGQqygQSIkO9ltUhJjcdAv/cBEAeZcD3hPupaKiAF/sHVvmGNQHkx6QZ8Gq4jQ4Vunqf/RHHGOjWdo6T7/YbVokLhcVVd7G8FxUlRI4XXzZRbaEIBEaOEhNHXePVWyoV51uLunO6VJXfPGki/WElqnOxiBtXEY2Jn3dgMzUnZYtvNJ8EJCftvood1dgIB7f7g3evp7Y01mKNBDOSvpEFNw5iEo8gdZDQf2+QJrhrRXvZHW4ggxTCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T9mNLay2BCwKHr6bn9M76oEfW+D3lVuybhHz2U8w9UY=;
 b=nMHVk4pOLDxPc10puniBh9FzOtcjUjazn4TWDou3q6isLsMqspv+LFLnozTXa1rcTdJoM2F0sGWCNENnFZQ6vLJqdc+VSwP4/B9udxot0OIpwKvNH7fK9n2fQ1d674EyqSX8klaQGmR/42zxu3rLLk6pR3XmFGU12JY/ktaoUFiRBQQFpwWXWxiZFvf5y9XE/Olqxh6YcHy1AFxrt4hqeaWYj6BVVeZromMEwKjFd10tgw8gOt//y/J6XQ708yRWVyac8UPYAdjhG3kFOUJnHDVWv0nblDEIACQdemyfMvm8fa2zTfpCqceN5M8duIfMCI9eS2Al06YeJoH3uQeLjA==
Received: from MW4PR04CA0115.namprd04.prod.outlook.com (2603:10b6:303:83::30)
 by DS2PR12MB759364.namprd12.prod.outlook.com (2603:10b6:8:403::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 13:45:43 +0000
Received: from SJ5PEPF000001F3.namprd05.prod.outlook.com
 (2603:10b6:303:83:cafe::76) by MW4PR04CA0115.outlook.office365.com
 (2603:10b6:303:83::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 13:45:42 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001F3.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 13:45:42 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:45:24 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:45:24 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 05:45:20 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 21/24] RDMA/mlx5: Clamp log_max_* shifts in QP and WQ limit checks
Date: Tue, 10 Nov 2026 15:43:17 +0200
Message-ID: <20261110134320.34408-22-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F3:EE_|DS2PR12MB759364:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fa9b2d8-c80e-4caf-9a9b-08df3f30ea14
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|1800799024|23010399003|82310400026|56012099006|11063799006|22082099003|18002099003|10067099003|261009223027099003|261102123227099003|261022105027099003|261022075727099003|261021135927099003|261021123027099003|261021121427099003|261028144727099003|261026121527099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	9m29JE5tRJHBb1kqNdOkij8AFZ+U6IZKsYn/LVRFOnuwrUVZpgPxwe/BoRdS9Jewa4/VVDbSYh03hdg5ENXf0M5kDVCAUs2+akxY9XKEu4fzsHVVzmHAkgtuYSfF/ub0TLfABqh+MLc9MmesSvCIwsx3bMe7JI7KsB+FnKX2h4AfpeRaWlhK6JytiJV/e7c6wuBtHpaZTigQav8ewnYOA3rfAN019B8q8vGKyWf6CNIQ7nRP165w1sYt45RPb9KQqbWHXH1TKGOTr55NlHW+Posqgk5GRN98z9agwkl6Ftd/Dh+swbLiZaINoTFFwY6oxTqw2RSUcEiEPOzf22B/qyPEvefjMHoPvoKjP/mjs8Sg2lgcpUrli8oqBOfxkz+NoQ4DIp4muT/jOur+vvguRctIJkL0zI73B1s+WmWzUauX/RuFT5KiRCkD2pTKX3nNoz8e9UYjeGmtZmoYKHvTh910dnxNK8QMpxfmCG6ab/w5x3Bq5WBfMGIEgxtxJXC64FZHMgXUDR6I9Wn5lB7m5Rt25YkELzQqO57ZjtXcf7sS+wjNZemcvo2MwI551Kbhmk3Wtgp+FDOEIhsdtwZmjhZJ8rdPRiVjBLXSHOMOuFG9d20QGOfYil51edroDn47FOq2YxicoBsCtt9XjyLXFBfc8NSTlVWZIbZfe9w5xmXP+Dz4BdFc0NFHyIh8bLzu5ct8cVUk229+DRuMTTcFMA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(376014)(1800799024)(23010399003)(82310400026)(56012099006)(11063799006)(22082099003)(18002099003)(10067099003)(261009223027099003)(261102123227099003)(261022105027099003)(261022075727099003)(261021135927099003)(261021123027099003)(261021121427099003)(261028144727099003)(261026121527099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	HfstCyVpEFdzao2YbpqixYX30jOoeZkkX0bCwPCLamryBwWQCAfKFpl9NWj1cTIamUtji3etbAPPuPevlMEKBjQhZVhmY1WFvdTx5kjah/BcZvZ7Pcyw0ukfCCTqdkIuiRAx1iC68zajD4HLPjFwe14Z7hUk3r7nNM0VQjw8G2KotGVMDeVAaSzMLV4x81AxauyJoKQ7AGPG1L9itjuEDMcT5dIIJOlhTsi4DKi7IEr+tYMsFs6B0f5esr6bZZA12jw9B62NZSxtBrDabjYbC9xbWS1kL8NY1C+9UiOCFydpRdj+piedSs1g73LYz/DPd5ShH5qGmkXB4nrsLliCAbMn8JKZyefosWFZQ3ij1iw8WstOPWT9YpJsnlleFT+/S1wUphWLL5jvpBIXYPNhWXnlPhZiYIUWugsBSxDk/0NEG1qS/t81xlH2Dnznfq5f
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 13:45:42.7851
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fa9b2d8-c80e-4caf-9a9b-08df3f30ea14
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB759364

Several QP and WQ size checks in qp.c compute their limit as
1 << cap, where cap is a log_max_* FW capability. An untrusted NIC can
report 31 or more, which makes the shift undefined.

Use MLX5_CAP_GEN_LOGSZ_U32() for these limits, as done for
log_max_cq_sz.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 36 +++++++++++++++------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 05e8e75d734f..d784a35675d5 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -447,7 +447,7 @@ static int set_rq_size(struct mlx5_ib_dev *dev, struct ib_qp_cap *cap,
 	int wq_size;
 
 	/* Sanity check RQ size before proceeding */
-	if (cap->max_recv_wr > (1 << MLX5_CAP_GEN(dev->mdev, log_max_qp_sz)))
+	if (cap->max_recv_wr > MLX5_CAP_GEN_LOGSZ_U32(dev->mdev, log_max_qp_sz))
 		return -EINVAL;
 
 	if (!has_rq) {
@@ -621,11 +621,11 @@ static int calc_sq_size(struct mlx5_ib_dev *dev, struct ib_qp_init_attr *attr,
 
 	wq_size = roundup_pow_of_two(attr->cap.max_send_wr * wqe_size);
 	qp->sq.wqe_cnt = wq_size / MLX5_SEND_WQE_BB;
-	if (qp->sq.wqe_cnt > (1 << MLX5_CAP_GEN(dev->mdev, log_max_qp_sz))) {
-		mlx5_ib_dbg(dev, "send queue size (%d * %d / %d -> %d) exceeds limits(%d)\n",
+	if (qp->sq.wqe_cnt > MLX5_CAP_GEN_LOGSZ_U32(dev->mdev, log_max_qp_sz)) {
+		mlx5_ib_dbg(dev, "send queue size (%d * %d / %d -> %d) exceeds limits(%u)\n",
 			    attr->cap.max_send_wr, wqe_size, MLX5_SEND_WQE_BB,
 			    qp->sq.wqe_cnt,
-			    1 << MLX5_CAP_GEN(dev->mdev, log_max_qp_sz));
+			    MLX5_CAP_GEN_LOGSZ_U32(dev->mdev, log_max_qp_sz));
 		return -ENOMEM;
 	}
 	qp->sq.wqe_shift = ilog2(MLX5_SEND_WQE_BB);
@@ -663,10 +663,10 @@ static int set_user_buf_size(struct mlx5_ib_dev *dev,
 
 	qp->sq.wqe_cnt = ucmd->sq_wqe_count;
 
-	if (qp->sq.wqe_cnt > (1 << MLX5_CAP_GEN(dev->mdev, log_max_qp_sz))) {
-		mlx5_ib_warn(dev, "wqe_cnt %d, max_wqes %d\n",
+	if (qp->sq.wqe_cnt > MLX5_CAP_GEN_LOGSZ_U32(dev->mdev, log_max_qp_sz)) {
+		mlx5_ib_warn(dev, "wqe_cnt %d, max_wqes %u\n",
 			     qp->sq.wqe_cnt,
-			     1 << MLX5_CAP_GEN(dev->mdev, log_max_qp_sz));
+			     MLX5_CAP_GEN_LOGSZ_U32(dev->mdev, log_max_qp_sz));
 		return -EINVAL;
 	}
 
@@ -2155,7 +2155,7 @@ static int create_dci(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	    ucmd->rq_wqe_count != qp->rq.wqe_cnt)
 		return -EINVAL;
 
-	if (ucmd->sq_wqe_count > (1 << MLX5_CAP_GEN(mdev, log_max_qp_sz)))
+	if (ucmd->sq_wqe_count > MLX5_CAP_GEN_LOGSZ_U32(mdev, log_max_qp_sz))
 		return -EINVAL;
 
 	ts_format = get_qp_ts_format(dev, to_mcq(init_attr->send_cq),
@@ -2322,7 +2322,7 @@ static int create_user_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	    ucmd->rq_wqe_count != qp->rq.wqe_cnt)
 		return -EINVAL;
 
-	if (ucmd->sq_wqe_count > (1 << MLX5_CAP_GEN(mdev, log_max_qp_sz)))
+	if (ucmd->sq_wqe_count > MLX5_CAP_GEN_LOGSZ_U32(mdev, log_max_qp_sz))
 		return -EINVAL;
 
 	if (init_attr->qp_type != IB_QPT_RAW_PACKET) {
@@ -4809,19 +4809,15 @@ static bool mlx5_ib_modify_qp_allowed(struct mlx5_ib_dev *dev,
 static int validate_rd_atomic(struct mlx5_ib_dev *dev, struct ib_qp_attr *attr,
 			      int attr_mask, enum ib_qp_type qp_type)
 {
-	int log_max_ra_res;
-	int log_max_ra_req;
+	u32 log_max_ra_res;
+	u32 log_max_ra_req;
 
 	if (qp_type == MLX5_IB_QPT_DCI) {
-		log_max_ra_res = 1 << MLX5_CAP_GEN(dev->mdev,
-						   log_max_ra_res_dc);
-		log_max_ra_req = 1 << MLX5_CAP_GEN(dev->mdev,
-						   log_max_ra_req_dc);
+		log_max_ra_res = MLX5_CAP_GEN_LOGSZ_U32(dev->mdev, log_max_ra_res_dc);
+		log_max_ra_req = MLX5_CAP_GEN_LOGSZ_U32(dev->mdev, log_max_ra_req_dc);
 	} else {
-		log_max_ra_res = 1 << MLX5_CAP_GEN(dev->mdev,
-						   log_max_ra_res_qp);
-		log_max_ra_req = 1 << MLX5_CAP_GEN(dev->mdev,
-						   log_max_ra_req_qp);
+		log_max_ra_res = MLX5_CAP_GEN_LOGSZ_U32(dev->mdev, log_max_ra_res_qp);
+		log_max_ra_req = MLX5_CAP_GEN_LOGSZ_U32(dev->mdev, log_max_ra_req_qp);
 	}
 
 	if (attr_mask & IB_QP_MAX_QP_RD_ATOMIC &&
@@ -5511,7 +5507,7 @@ static int set_user_rq_size(struct mlx5_ib_dev *dev,
 			    struct mlx5_ib_rwq *rwq)
 {
 	/* Sanity check RQ size before proceeding */
-	if (wq_init_attr->max_wr > (1 << MLX5_CAP_GEN(dev->mdev, log_max_wq_sz)))
+	if (wq_init_attr->max_wr > MLX5_CAP_GEN_LOGSZ_U32(dev->mdev, log_max_wq_sz))
 		return -EINVAL;
 
 	if (!ucmd->rq_wqe_count)
-- 
2.18.1

