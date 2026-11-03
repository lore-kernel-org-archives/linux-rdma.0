Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.12
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793724159;
	b=HsugwfcPyzBTINZWwhNaACT6gzcaKK1zC8XzCgqqyIam5kWsVjYLvfR+/CY5Oft2R1Ma
	 HJ3tF6Vnx9xQDAu2P2aR9mJYaRkcwWnQ00XeEKUqyn3KO8F+C3VWOmHc1R+55GY0I86DS
	 td6wEsCViOY7UGvkczN6MB7vzBYUkY2kzdkNAEtZByf1mpYHz5Rk5ZPZ625x/JkFT4ZI0
	 N7PqN+Jz3Bx7BT6nYXcD0rIJLcv31HDDnxy1UqRHxWQWsAHavzQZOO3L1A9+aciU6uSGf
	 6zXg6EOF56WnsgXzDVTXIUSHmfZyubroHzOqpvCjK0+8lRN9Ju6DvX5kXVTcz1+V1dA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793724159;
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
	bh=R8drD+4/uyLMqY7jPyLzpMwIEYLL7X1Zu5kC+zoIXCA=;
	b=mikYwTHKC+nwv4zAqY78yoNLXnjgXo1cxEE04z1fW4gHaAbYHBDBqxbX0W8V20UK7wkl
	 PAWANHRynxxECd+5oiCB/3HyD+FM0noKIMT+MpJx5KCQeawaF/dGnS8PrTLs6sHCL6CVK
	 9y5f3s7QESo94JHKRp0ICUOHBMG79T9gA5Sjh+vceeCofJCO/VBVEvqtg5QcwxoyXlkiY
	 8DZAgFTmgXXCVgivlvumjAXPQfyag7yzMnwl1OirY4gCjM4FhoNX59xk2IQl/L3eIxneB
	 OlRPl9CPPAxjeumvFWKRkZuE9LKFzNd0XeFgiq1/jSGaHVkkj9elojM+l+grhao/ATQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Vt0YgEn9;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.12
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010012.outbound.protection.outlook.com [52.101.85.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77BB606D822;
	Tue,  3 Nov 2026 16:42:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A77BB606D822
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Vt0YgEn9
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BLl1K2ffLaejqZQWQj3uUS0+cxmO396QrqLt4xqSGhidI2t9sO6TueXGNPTfd8//5Q38SFClDTRfas9ORD4RYAE819r0TnZ412D9//61v9pc55qZE/zno19O3QxVtkrHXrYan2cHs41svICXn9vhFu8KKYnTPmRgUymBAP54gNXEljD3VZAKkp2vPuWjKKTLEBvy5mLWQCTapFej7L2Cfu9HnF8FmBgfVJacZ4y0iK0TWJcvNiTNPEObngg1V0vkezTlOXJhcr+OhZndw2bDxcgPaAKDPgNEM0a6hU3l/sXrtipVj+YwqegBX3/KXHLACOfwhIK3IUD/B5A5+p92AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R8drD+4/uyLMqY7jPyLzpMwIEYLL7X1Zu5kC+zoIXCA=;
 b=qItzk9l5nL2JIZdN5hRcY6ifqokTI0VMN+e4GsUsfWqyGvoVs4QvVAkO1BAH100H/X8ziU7yWhEaArRbM3tQo+DZz+nwNTt0ozDj3VozPzXVFnUcDxGeLhhPT2e3V0Vs9kECl7ymqF7Ic7BldVz0elegxuLx/vUWshfskJ8qPt5Dn6+iaunTjMIk/OTo0eqFhWonbySdMV28GSo+83kpf6Z5U2qJmwPsZs/jWVj8I3c/muf9nP3hX0cIRnjJz4nv/fYhS/eSHcGAaARQFJVTV5wgwOqnDnoem+Aw1MSiQ2efpYvB4liMg0W4ORFbpnx0xky312xqCggSI59v/U5FKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R8drD+4/uyLMqY7jPyLzpMwIEYLL7X1Zu5kC+zoIXCA=;
 b=Vt0YgEn948Q3VCAu8GN2zxCw9SIG66JBXjxVA4H2LihyYhuzT/4Gl/HPPDDubejrI9t1w9FhZaBG2DFo+PqvEYlfDyoHAccVbtqVbSA0z8diyKEVMebbTLESRg2nD8VNUJb/Fl78QsDssj5ZukdgcXke2mmKZs1QxHjyRzruQ98tETRW63h8+OjwVx5bPyo+gRIm1QrQbTExm6AT/vDxtzkTkXbSIKlYTe19UqJkQxbaoeaZtw2ZoehLupopLloQ4rcJxkLxVR66WGvxpW5Q/IOH1ot+GgqZob2FSrDFJrbofBInRPu3EdBImdTZzAo6hsMkFzNhZ5dZ/pDWRfKoFg==
Received: from CH2PR20CA0030.namprd20.prod.outlook.com (2603:10b6:610:58::40)
 by DS7PR12MB6024.namprd12.prod.outlook.com (2603:10b6:8:84::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 16:42:31 +0000
Received: from BL2PEPF000352CF.namprd02.prod.outlook.com
 (2603:10b6:610:58:cafe::49) by CH2PR20CA0030.outlook.office365.com
 (2603:10b6:610:58::40) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 16:42:31 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL2PEPF000352CF.mail.protection.outlook.com (10.167.249.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 16:42:30 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:41:52 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:41:51 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 3 Nov
 2026 08:41:48 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 20/23] RDMA/mlx5: Clamp log_max_* shifts in QP and WQ limit checks
Date: Tue, 3 Nov 2026 18:39:46 +0200
Message-ID: <20261103163949.1554-21-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL2PEPF000352CF:EE_|DS7PR12MB6024:EE_
X-MS-Office365-Filtering-Correlation-Id: bdf0759a-96df-44c6-0a43-08df39c9742c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|82310400026|36860700016|261021123027099003|261021121427099003|261021135927099003|56012099006|261009223027099003|11063799006|261028144727099003|261026140227099003|261022105027099003|261022075727099003|261026121527099003|10067099003|18002099003|22082099003|261102123227099003;
X-Microsoft-Antispam-Message-Info:
	w+oxxG/SFFaFVjboqNCd6BBixKYA2n7Azle+vXngqObTRUmjo5KBUY/4b4xB5SW65Qu0qizkYv0Eg1J87ZqBwg11C/gcWVjVaU1GFbFg8le/Ff1XMoFT7AIJ71ZvzOjAJV0qu+jzEYA5kAj/7jLMLrB+plAZ/42Mgg9g7Qe5ve0KPxIEWtGAVLXr2kthrFfmK5amtm1nezV1371tOHG15DGlElreEgYfe8zjK40X88pZUB+8UfFORWv/suxZMNaG1sMW+nPArqbkwRVbXtJdCXmZEhD4mxnvMe1WspE8EaegK1dAm3g15k+D5dqce2FMKalp2Pr1BDMMDcS2kLk3BrTaIP6sqDI+Y65uf9icg6ALB6ckk24wEip95qwD4cD79VaIjFRu5Y9ITuNnoFHcEfzAf6zzwt9+KeL2+tyqP32FVe7xahDIyB3SpdPITLgIES+W5+nVzgu22/Q86Y0e8MIjvT8vn8CRWraRqEsyXnnZZ7AUZ9Q+OFOmTWFUe1sHwcFES7umbcsT6jCisSbdKbykqaUsRNBCdbbwMIauFMiNpEQTjLuosdQcteE9ZJXQSKH8YBKRXd7gqODZPE4bJB5eHACQur9pZMXfISip1+ytxGbO8QPFZt0cXvXY1PPtgZWIzWlGBdN9aivJzsBVT6sqN8L0Yd+pyKL+c5A7v0/2xyV2h3IOfwiW4weLOCJgSg7pcPzA0iaZVB6i2zfWbg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(82310400026)(36860700016)(261021123027099003)(261021121427099003)(261021135927099003)(56012099006)(261009223027099003)(11063799006)(261028144727099003)(261026140227099003)(261022105027099003)(261022075727099003)(261026121527099003)(10067099003)(18002099003)(22082099003)(261102123227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	j23DcTYr69C7nadlnu+FJYMe+z4morqiHoqVJyHIOqW0AAsxvEP8iC8+va+HmFyyhwz+TmMJ3ix4Z5/i3fQIireQ5sD7+0DXc5zO5gHPQQGoPzwu7unG2dYHNixLil/UBBFZ3EU1re+jk90osuN57Ci/nsPtmx35gpWeAtYQmsF7bFkyYlL9CbvGYLlzDBmSJdhSQzOq0RoJjv3GoZ6H3sQDXGEjFK2CNOM0JXLNpPtvl0qEXruZmLWEOtFwd+Cm98d61Zu7OgBvq4/dKbRXdmt0qrCwPxy/Nl8/ob3tzuHpaqEWKJMh8FZYdiBMyg3lQ5sS4WDavnGnD3Rofsw7YTG+nBbvcLYH8shqap48FrY4SaTWPTndtUN5UYA+1v7sVsMI+45QV/nZbX/tJtTmtMocr8F1qEptse8ZGgCrbOksI1kAdNM40VbDymzABnjW
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 16:42:30.8403
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bdf0759a-96df-44c6-0a43-08df39c9742c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL2PEPF000352CF.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6024

Several QP and WQ size checks in qp.c compute their limit as
1 << cap, where cap is an 8-bit log_max_* FW capability. An untrusted
NIC can report 31 or more, which makes the shift undefined.

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

