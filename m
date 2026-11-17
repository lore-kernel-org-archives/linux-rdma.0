Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.70
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794935511;
	b=WwmZ1VB8ak8LEsQiLORzU8JNd+rKDNTfKjUc//nZgQO6P2SfL1L7dts39POf1ieXHOtc
	 k7QCZ5aHUCZMd6vIg47HxyDvgxIsX+7R/ekZut/piPIIe8uU5uGle5ms0fLe3k5uj5aIn
	 FF65+4g8st3UsJUkUbMGRxjfex9kdXL+F3ttOzN0xmqlThCiA/LxFdgPueZVH0ndFjI1e
	 kyRUGKXVXl2+Na0Mmlx1Xnhql2orpYH0B82ZZzzElNF9eW0pexPULCUeXoQPWXrHNbn8I
	 KUez8Kt7cxdVpi0QjO+I26VCLTb27BkjGR0S++9hWluQz9v5GoasdlLq8LzuqzFUHlg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794935511;
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
	b=NKTpIN8zPsLnz5DnnTojuQh5UvJqjmzBeXKoYZOSHzWtCQ59xk0j7sa5CpU9q2U6LyFN
	 ko5w8zl65HoAC0/9GRMjeDY/Cipsy+8ljQ4NC3kmF4cyGKxnKFV+jEU33zKBwwUKAAbWQ
	 c5l9UzG2th0j8K2cQ7NqHAXclHY1C7IGpS7EMu98yBSgrpcXg8MO0Q9gLKdnPM/OMjZbC
	 7IrqKcRg9UGEA5U0U0q716Nfzfm7aDdnOYlm8qVWSmZyjA3F9ozIq0BcDZFIOjS4MNbIF
	 cZ/uvf1B8K0ne0cHHpkCz038KrIUxLFe/7sBwgtjCZb9P/hy2bemgeTExh8fuabgqmA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=txNqPMgf;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.70
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012070.outbound.protection.outlook.com [40.107.200.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780E2606A885;
	Tue, 17 Nov 2026 17:11:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 780E2606A885
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=txNqPMgf
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aW2semzVQ8N/wPSBEHUloXF1J17h9JNtWT+PdwPy6KdeB6YEi2FaHHtm1w9CMwSo2lXOuRaLhDHkepeGnJw8S44Eq1LD5guCYlQ1qsTdEfz3z/Xr/WgvcsUGKmefdTetGvQIg7Mma1N5FFUQWgSoJzJap6mANnW3OdkSB8GF4ITqdi51A5FBxeyK/LQjcaE04BQxsEKIgUcJ3FesOWBpRHhdwG1MwQKBJYD2Dr6rVYYqnLeP9xRjovXR0SCM182X6jwqFXQRVuFwHcrctJO8ASjMbfeA5FaCppuVPHTS+4VhGWFKNdx8R6GISMrUgBBGbB/SGnidk/Ec1xN5S2umYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T9mNLay2BCwKHr6bn9M76oEfW+D3lVuybhHz2U8w9UY=;
 b=BOHy51nsQmhiZcW5pSSNWjeRXy18bK3bEEQuGFGtJT3sky9OegrutFIcH+ceLjZpNS3b3cOiZjQWdlJGR1Qw+9VRNWWIjzrhcalZAzgdvk4WPmj7iHuq6yTip51Pf42/Lf7TOM5mH7Ls8egWWkTk1Uno+i3oj66lOxVa1uYYRyy7Ol/pmu3op6nuDrgTsB5eU1yZMI5WQ0lU1Tn4pN7nPsAFe3O02AhYgcfhELyOgvTmhGiQxhB1wnhwpfaH/CxMMn/xEOVecw9fd+EfUuOZud46rJDxxBTJuYpmwm6i++imaJtvUPvX5qb/8dtdzjBVgfkNqYVSFvztYEAH5f9z1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T9mNLay2BCwKHr6bn9M76oEfW+D3lVuybhHz2U8w9UY=;
 b=txNqPMgf6NMbq0xzDUPG6AOXEP1RfHVTedviAK26D97KseU3ZCCJvabgN2G7/QsyIoxqe+bAwQ6jc0XZ7V+9aWgBBAWIPMbrJ5jodEBH2HeNd+5ofKgFm7yvHXk4wPn0Xsdyy02VZwS9NeMLpavnhytmzqqNXiLqxxKIanMSKr4KKIMIe4eLxl8TF+j7hvqbTYuf9mNrpbT2dFZoP14A6fXFzT2Ydp+TN+KKcr19hIoXHqsVBEpEASWUFp7HENouvGyuoOWX/66mCCo5qTbbmYhzyS0zDuAYREvpSUnrebRmt5PdzIqru97QT1AILc7YuoNKg5zBp2bh1yGYrDK19w==
Received: from PH8P223CA0003.NAMP223.PROD.OUTLOOK.COM (2603:10b6:510:2db::15)
 by CH9PR12MB070576.namprd12.prod.outlook.com (2603:10b6:610:353::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 17:11:46 +0000
Received: from MWH0EPF000A672F.namprd04.prod.outlook.com
 (2603:10b6:510:2db:cafe::2a) by PH8P223CA0003.outlook.office365.com
 (2603:10b6:510:2db::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.14 via Frontend Transport; Tue,
 17 Nov 2026 17:11:46 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 MWH0EPF000A672F.mail.protection.outlook.com (10.167.249.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 17 Nov 2026 17:11:46 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 17 Nov
 2026 09:11:12 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Tue, 17 Nov 2026 09:11:12 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Tue, 17 Nov 2026 09:11:08 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 rdma-next 19/21] RDMA/mlx5: Clamp log_max_* shifts in QP and WQ limit checks
Date: Tue, 17 Nov 2026 19:09:12 +0200
Message-ID: <20261117170914.27410-20-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261117170914.27410-1-yishaih@nvidia.com>
References: <20261117170914.27410-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A672F:EE_|CH9PR12MB070576:EE_
X-MS-Office365-Filtering-Correlation-Id: ecae7477-eafa-48ca-ba2c-08df44cddc14
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700016|23010399003|18002099003|22082099003|261009223027099003|56012099006|11063799006|261102123227099003|261028144727099003|261026140227099003|261026121527099003|261021121427099003|261022075727099003|261022105027099003|261021123027099003|261021135927099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	nF1Cu9tjKox98upFuxaULv8EmMKSJ4Op/1F2kjngK1z8+Vz8Ze1d+9xtDrIyQKThHFFSRGGMBCq5LCv/HM0T8gMOoz+FK8m9W/tYkimwCe9aM5vcJ4a445B40piq8E3xgfHA/OMrYOBSeizKGDb8MFmXQiK6tnGVbkNe9TuVxTleqaDU8TCdO/5gR+RsURQlzTew8vOvVjLrDsu0/a3S6ljtJiwOKuUTugYiZYDGQ/yTtyjRvlKIxz6N3WswrTGrVkHaLC9tj3UA1at3ea5DviC6yZeFQmfhNUWzsHZgSI1ywvT5mNiecoi1T/1B/8tO7eDZvXY39oIbHviJCl4JRzQqWtsX5xp+3KjG30BZG/syhFuZ0p4D6hDwVnK5A3YgU3YeYIPOfWhJ0ZZyE03UUkU+sVkD4m2MuHpCcUOg69VJ/FSY04E63HrabLV22BAXqfAR4N3EWQsYtjD6uOHnJLkMLjcW9qtnepHkfoQNsTxNYrzKygxuhdFfeKRcrWPg06yn57/bZAJXtka+f2HIg2lRH399RhEZwMnhBCkhX1zcmzUUOYYiVpYT9HDGwT7UaC+QGmBLTYz6WF1mtFWA7XArVgzCDweeX0yloergd27lzpZSgF+KjMSc1YOxJbcxtqKWeZRpMDJbRNfi05/hTBvoJkCs7UpvondSxqZiRmMJC0dccVDdbyZpdP/8qQzzdg9FfsynrW5FXKs1T1U2Cg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700016)(23010399003)(18002099003)(22082099003)(261009223027099003)(56012099006)(11063799006)(261102123227099003)(261028144727099003)(261026140227099003)(261026121527099003)(261021121427099003)(261022075727099003)(261022105027099003)(261021123027099003)(261021135927099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	bPfgY3GHjTaRAImj4F9Mv0Qou4ZycArPv33MTZriVxoteOjwxgde+Hi+2GmSj3FBbbnDWb5BeLeWO1Iy3D6Ihfp1sH4pcyv2szBIeLzPg1ost+N2EjfPzHxk+UUhP0lYAlI5Dn7omG37hyxHyifX6MkoOQ8lxKep+GPotkp71iT+8XTzxr7+8Pu61lCmWg4oc+d6agUBiES/LEVUVwXYYx8yN6++ugooKoiygWunUjjDelLX10Gs9evWg2tSY6mhU//pcgCzBARDAz5Ov/dy7YkHkHDXDGEomq1h/6obavRnStw+F/GnAZgqVpLUE/JRxXeptyhyPKExpSRqH5adY/F/5f3vTdyQax2UNFLgLIqvTX64EGRxoEUtMzR1sov6fkX02Zt/Cy2X0NTTWateAeTzfI5JtHA48cSW0LrpjsZf/EPtg6cRj4JpYDYQTB7U
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 17:11:46.0271
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ecae7477-eafa-48ca-ba2c-08df44cddc14
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A672F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH9PR12MB070576

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

