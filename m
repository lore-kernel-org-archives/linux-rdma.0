Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012004.outbound.protection.outlook.com [40.107.200.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0528A52D2CB;
	Tue, 22 Sep 2026 09:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790071157; cv=fail; b=N50wK2ACgF9ktYHMcgAolx5LRLxsPrUJEiB+DENzrdqHwz5ht/EYmqVyiZHncGR6pxG/TkO17dPZuxGaO+y2948ngCoCljIpsMi4v99rZqYp6heXa4BoMHcNJvr9AHgpLcrTXUgHufncCecADxw2dQiSulTNNlwohNWLDhygloY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790071157; c=relaxed/simple;
	bh=pGT516zNZb4P3GwHDigYT9/KqIegDDH6eGM827x2OO8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=enGHVJXQiDb4CCtGUgQ4rEglVFIJu2u8sk8S+zS4Xk1al7GU5yyetglSF20Xo0i4LIj3PzLxnNQQn3veu1ySmc6tCa/KVf6VUDFtbLuzvjR7E9z+PKe1gLV1E307ohRsdDLYYpKlEfpi/d6aayyXJwDuSqikdnLGy4bvatzN95I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zdPG3pkR; arc=fail smtp.client-ip=40.107.200.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zdPG3pkR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R/OcCpo/sa+Z2P2/jfdq1s0UCmTRr/Q/lBzQd5g+penLCWteTf8McwXC2A4Ad5z+wvl4Iw8kjW5nC2ZzcxXb3FHme9L2T9NyfKfNpx2VZOZKze3wjE+tyANtpP3msbdbyapjg5DbL1N0l4Yi5JSC+7KMzJJoH7Ft0uvc7lAVUwJxU83bz1ZtLJj6faXgW/pWXv1j7tq6YbwpPbslDX4+GpcE/u3H0PP3hc/VIPR3khJZiZnCxxbyJOsWXAarvZbbgk2omXSEW6Fny8/1CSPxdznKRZmHPkvBZdeHR0i3ADXT0YdAGM/x8Yy9MxB7fghD8iv8jyR+qAcx4rTV7doA7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aWty5WT4Amyxz5OWnfftPkWANaF98vCkkyl8w6aAzgQ=;
 b=FtnC4euuqJAh3Gx8YYh9W4xr7MjQlQ63AqvLGogM09mlS8Ar+Tquq2fm1ObRu7CW8DPlsCiuzO1VJ/Rw+365NzfiWwfuImWTx5ejhIzYXJoTikFcZARr3VgIj4P0mPeLiYLyBXd1/UMUwaNR3zcFMF/TOTDih287xqLXMURJXpVqiCBE10CD7KRkFM5L4VTJ+1pXZpIKb7IhZijzXXpwn5btct37g9HfE1RIVKeTgF4AQDbxnP6b1gtOKqodDhtVdZXWRe1uGcBInJoSbJNpFV6HpU5jJ20W/7xdesGrVnhTKZDqBOHHgCdDl/d02Yq3II6OXfcDo1qkVnAXMdu2xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aWty5WT4Amyxz5OWnfftPkWANaF98vCkkyl8w6aAzgQ=;
 b=zdPG3pkR2ubyJ/Ox+qqh28ENDQo7DFiZ9CuTTAiLnf2Nh5d/jRqtTq7rHKhwkZRLgourPkrPqcl9sERz8PPWgNgO5AguYYIu2QkFDfzp7FgGKnJejGgSzPJ8wQ9zwTucR+QFI9VvTp784V4eUefR9TMvcz9aA/MDJKt1iaqHsfc=
Received: from SJ0PR03CA0068.namprd03.prod.outlook.com (2603:10b6:a03:331::13)
 by MW4PR12MB5667.namprd12.prod.outlook.com (2603:10b6:303:18a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.14; Tue, 22 Sep
 2026 09:59:07 +0000
Received: from BY1PEPF0001AE17.namprd04.prod.outlook.com
 (2603:10b6:a03:331:cafe::a5) by SJ0PR03CA0068.outlook.office365.com
 (2603:10b6:a03:331::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.16 via Frontend Transport; Tue,
 22 Sep 2026 09:59:07 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BY1PEPF0001AE17.mail.protection.outlook.com (10.167.242.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Tue, 22 Sep 2026 09:59:07 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 22 Sep
 2026 04:59:06 -0500
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 22 Sep
 2026 04:59:05 -0500
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Tue, 22 Sep 2026 04:59:02 -0500
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <brett.creeley@amd.com>,
	<andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <allen.hubbe@amd.com>, <a.k@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Abhijit Gangurde <abhijit.gangurde@amd.com>
Subject: [for-next v2 4/5] RDMA/ionic: add Shared receive queue (SRQ) support
Date: Tue, 22 Sep 2026 15:27:23 +0530
Message-ID: <20260922095724.3683011-5-abhijit.gangurde@amd.com>
X-Mailer: git-send-email 2.44.4
In-Reply-To: <20260922095724.3683011-1-abhijit.gangurde@amd.com>
References: <20260922095724.3683011-1-abhijit.gangurde@amd.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY1PEPF0001AE17:EE_|MW4PR12MB5667:EE_
X-MS-Office365-Filtering-Correlation-Id: b9b58081-857b-49f3-63d8-08df18902434
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|23010399003|1800799024|7416014|376014|10067099003|56012099006|11063799006|22082099003|18002099003|3023799007|6133799003;
X-Microsoft-Antispam-Message-Info:
	QwA4FV+82q1ceVWWdH0FsIMn55oBwEshBEigeZJ3vls2rV1iG9KIyy73obtYBq7dvjNTqC53CT+GzueVXSkPyw7ehB75TpH5Jo41XvZEBj79fUNIVlWFWwwlYlfohyjwO15wQAsuGR9GCWbDzKN9zFIWYphCzVKa64/Ro/72xFBCyivGcLeaImnAqXQoxEQaDA/VLszj/jlcTqXUpyw5Uz3O4+fBpZZVXkLrwMnbbuRkijpk5fAaztMgNZrmOwDHdiAMye5b0GvKoAT0+IR1HyKowS6cHUlq6OO7zBxe79mpJV4yLLNZs2esa1Bs4KpDqS4VFtTdqF+QJm+pFCCy8smRsC5vFddIZg0hKdedu/kU13vY6mH6a2aUI6zw3dScCa02j28rR3czq15u6e4PH6xoj4eBnQ2lqVi/zD5P2+cSC3WgbAw8/2Ch6mkkRgEEzZrbVMGbMZomupIl/94q+vTbPv0XUfHLtPbMX3OYnmMX9R9bzhXDCc9rxAyjC13sumWVHHuOIgY0iI6PI13yn9FGPMSi+SiPp/yMXv2A06FcloN2ofzjaib4GvU9jW6IqPititZA4+LafSKk5jdYGbhXvfmSObp2FGZboSO3K1A7Q7/5YrWNW49V3kC+m/b8KxwIHfuCyNdE2g5DrAhERwkVF/LgnTQxg2UqV1wB6kGv+5dsyi3h4mrH2VtjJWTBm0NbM70Km1VFTislXloJRQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(23010399003)(1800799024)(7416014)(376014)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003)(3023799007)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	cusNrkoJYrue1Gt9TlQO3xoA5TpAAsJJbMRG05PyhOOHN493IHzXJnL71ezo/T3rAvllxUpZ2EAyEGAUk/+eON8Er/ATHSyioshE3UM9BgJsVJjIVhLaLdQU7OIFZRmBosavJPHbtWYN9qgB+n/0XxcrM3bcX9iWXes/wn4I6mBkY7ygSYIpe/1DVgc8rrei3W1Dr0eWd7qnMccxtDCrRZBsIHqiXyUNLjANWUizRFqntp8O2CUxaETZmUkK899UUQZhueSRTWJ7wFP3fuxwmpR0PIWQCrbeQ07LZ5Z3d+lVEvcTJg6olLEaadU2lLBqlvyNWFlLs2nOxdRp04xD243ADYG/FaOEgx+Qc84nzJqyTvWgSvVl0a03fUsoY9V7BVQenlkrWmgky4W0PV9qVsS/6kR7eqkyeoRkwmxPFdXNIl/c0MogPdhh9tEGURjL
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 09:59:07.0391
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b9b58081-857b-49f3-63d8-08df18902434
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0001AE17.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5667

From: Amit Kumar <a.k@amd.com>

Implement device supported verb APIs for shared receive queue.

SRQ is supported for userspace only. ionic_create_srq() returns
-EOPNOTSUPP when there is no ucontext, so kernel ULPs cannot create an
SRQ.

Signed-off-by: Amit Kumar <a.k@amd.com>
Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
---
 .../infiniband/hw/ionic/ionic_controlpath.c   | 394 +++++++++++++++---
 drivers/infiniband/hw/ionic/ionic_datapath.c  |   8 +-
 drivers/infiniband/hw/ionic/ionic_fw.h        |  53 +++
 drivers/infiniband/hw/ionic/ionic_ibdev.c     |  16 +
 drivers/infiniband/hw/ionic/ionic_ibdev.h     |  24 +-
 drivers/infiniband/hw/ionic/ionic_lif_cfg.c   |   1 +
 drivers/infiniband/hw/ionic/ionic_lif_cfg.h   |   1 +
 include/uapi/rdma/ionic-abi.h                 |   2 +-
 8 files changed, 439 insertions(+), 60 deletions(-)

diff --git a/drivers/infiniband/hw/ionic/ionic_controlpath.c b/drivers/infiniband/hw/ionic/ionic_controlpath.c
index 7f0e8b63ed76..ec9e1188f556 100644
--- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
+++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
@@ -1503,7 +1503,7 @@ static int ionic_create_qp_cmd(struct ionic_ibdev *dev,
 		wr.wqe.cmd.create_qp.sq_dma_addr = ionic_pgtbl_dma(sq_buf, 0);
 	}
 
-	if (qp->has_rq) {
+	if (!qp->srq) {
 		wr.wqe.cmd.create_qp.rq_cq_id = cpu_to_le32(recv_cq->cqid);
 		wr.wqe.cmd.create_qp.rq_depth_log2 = qp->rq.q.depth_log2;
 		wr.wqe.cmd.create_qp.rq_stride_log2 = qp->rq.q.stride_log2;
@@ -1512,6 +1512,9 @@ static int ionic_create_qp_cmd(struct ionic_ibdev *dev,
 		wr.wqe.cmd.create_qp.rq_map_count =
 			cpu_to_le32(rq_buf->tbl_pages);
 		wr.wqe.cmd.create_qp.rq_dma_addr = ionic_pgtbl_dma(rq_buf, 0);
+	} else {
+		wr.wqe.cmd.create_qp.rq_tbl_index_srq_id = cpu_to_le32(qp->srq->rq.qid);
+		wr.wqe.cmd.create_qp.rq_cq_id = cpu_to_le32(recv_cq->cqid);
 	}
 
 	ionic_admin_post(dev, &wr);
@@ -1697,7 +1700,7 @@ static int ionic_query_qp_cmd(struct ionic_ibdev *dev,
 			ionic_v1_send_wqe_max_data(qp->sq.stride_log2, expdb);
 	}
 
-	if (qp->has_rq) {
+	if (!qp->srq) {
 		attr->cap.max_recv_sge =
 			ionic_v1_recv_wqe_max_sge(qp->rq.q.stride_log2,
 						  qp->rq.spec,
@@ -2071,6 +2074,42 @@ static void ionic_qp_sq_destroy(struct ionic_ibdev *dev,
 		ionic_queue_destroy(&qp->sq, dev->lif_cfg.hwdev);
 }
 
+static void ionic_rq_mmap_cmb(struct ionic_ibdev *dev,
+			      struct ionic_ctx *ctx,
+			      struct ionic_rq *rq,
+			      u64 *cmb_offset)
+{
+	bool wc;
+
+	/* set mapping by default to uncached for
+	 * expdb (to guarantee writes order) otherwise
+	 * writecombine, unless this default is
+	 * overridden by userspace
+	 */
+	if ((rq->cmb & (IONIC_CMB_WC | IONIC_CMB_UC)) ==
+		(IONIC_CMB_WC | IONIC_CMB_UC)) {
+		ibdev_dbg(&dev->ibdev,
+			  "Both rq_cmb flags IONIC_CMB_WC and IONIC_CMB_UC set, using default driver mapping\n");
+		rq->cmb &= ~(IONIC_CMB_WC | IONIC_CMB_UC);
+	}
+
+	if (rq->cmb & IONIC_CMB_EXPDB)
+		wc  = (rq->cmb & (IONIC_CMB_WC | IONIC_CMB_UC)) == IONIC_CMB_WC;
+	else
+		wc = (rq->cmb & (IONIC_CMB_WC | IONIC_CMB_UC)) != IONIC_CMB_UC;
+
+	/* let userspace know the mapping */
+	if (wc)
+		rq->cmb |= IONIC_CMB_WC;
+	else
+		rq->cmb |= IONIC_CMB_UC;
+
+	rq->mmap_cmb = ionic_mmap_entry_insert(ctx, rq->q.size,
+					       PHYS_PFN(rq->cmb_addr),
+					       wc ? IONIC_MMAP_WC : 0,
+					       cmb_offset);
+}
+
 static void ionic_rq_init_cmb(struct ionic_ibdev *dev,
 			      struct ionic_rq *rq,
 			      struct ib_udata *udata)
@@ -2307,19 +2346,26 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 	spin_lock_init(&qp->rq.lock);
 
 	qp->has_sq = 1;
-	qp->has_rq = 1;
+
+	if (attr->srq)
+		qp->srq = to_ionic_srq(attr->srq);
+	else
+		qp->srq = NULL;
 
 	if (attr->qp_type == IB_QPT_GSI) {
 		rc = ionic_get_gsi_qpid(dev, &qp->qpid);
 	} else {
 		udma_mask = BIT(dev->lif_cfg.udma_count) - 1;
 
-		if (qp->has_sq)
+		if (attr->send_cq)
 			udma_mask &= to_ionic_vcq(attr->send_cq)->udma_mask;
 
-		if (qp->has_rq)
+		if (attr->recv_cq)
 			udma_mask &= to_ionic_vcq(attr->recv_cq)->udma_mask;
 
+		if (attr->srq)
+			udma_mask &= BIT(to_ionic_srq(attr->srq)->udma_idx);
+
 		if (udata && req.udma_mask)
 			udma_mask &= req.udma_mask;
 
@@ -2346,13 +2392,8 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 			goto err_ahid;
 	}
 
-	if (udata) {
-		if (req.rq_cmb & IONIC_CMB_ENABLE)
-			qp->rq.cmb = req.rq_cmb;
-
-		if (req.sq_cmb & IONIC_CMB_ENABLE)
-			qp->sq_cmb = req.sq_cmb;
-	}
+	if (udata && (req.sq_cmb & IONIC_CMB_ENABLE))
+		qp->sq_cmb = req.sq_cmb;
 
 	rc = ionic_qp_sq_init(dev, ctx, qp, &req.sq, &sq_buf,
 			      attr->cap.max_send_wr, attr->cap.max_send_sge,
@@ -2360,22 +2401,25 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 	if (rc)
 		goto err_sq;
 
-	if (qp->has_rq) {
-		/* for non-srq qps, rq qid is same as qpid */
-		qp->rq.qid = qp->qpid;
-		rc = ionic_rq_init(dev, ctx, &qp->rq, &req.rq, &rq_buf,
-				   attr->cap.max_recv_wr, attr->cap.max_recv_sge,
-				   req.rq_spec, udata);
-		if (rc)
-			goto err_rq;
-	} else {
+	if (qp->srq) {
 		rq_buf.tbl_buf = NULL;
 		rq_buf.tbl_limit = 0;
 		rq_buf.tbl_pages = 0;
 
 		if (udata)
 			rc = ionic_validate_qdesc_zero(&req.rq);
+	} else {
+		if (udata && (req.rq_cmb & IONIC_CMB_ENABLE))
+			qp->rq.cmb = req.rq_cmb;
+
+		/* for non-srq qps, rq qid is same as qpid */
+		qp->rq.qid = qp->qpid;
+		rc = ionic_rq_init(dev, ctx, &qp->rq, &req.rq, &rq_buf,
+				   attr->cap.max_recv_wr, attr->cap.max_recv_sge,
+				   req.rq_spec, udata);
 	}
+	if (rc)
+		goto err_rq;
 
 	rc = ionic_create_qp_cmd(dev, pd,
 				 to_ionic_vcq_cq(attr->send_cq, qp->udma_idx),
@@ -2421,35 +2465,9 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 			resp.sq_cmb = qp->sq_cmb;
 		}
 
-		if (qp->rq.cmb & IONIC_CMB_ENABLE) {
-			bool wc;
-
-			if ((qp->rq.cmb & (IONIC_CMB_WC | IONIC_CMB_UC)) ==
-				(IONIC_CMB_WC | IONIC_CMB_UC)) {
-				ibdev_dbg(&dev->ibdev,
-					  "Both rq.cmb flags IONIC_CMB_WC and IONIC_CMB_UC are set, using default driver mapping\n");
-				qp->rq.cmb &= ~(IONIC_CMB_WC | IONIC_CMB_UC);
-			}
-
-			if (qp->rq.cmb & IONIC_CMB_EXPDB)
-				wc = (qp->rq.cmb & (IONIC_CMB_WC | IONIC_CMB_UC))
-					== IONIC_CMB_WC;
-			else
-				wc = (qp->rq.cmb & (IONIC_CMB_WC | IONIC_CMB_UC))
-					!= IONIC_CMB_UC;
-
-			/* let userspace know the mapping */
-			if (wc)
-				qp->rq.cmb |= IONIC_CMB_WC;
-			else
-				qp->rq.cmb |= IONIC_CMB_UC;
+		if (!qp->srq && (qp->rq.cmb & IONIC_CMB_ENABLE)) {
+			ionic_rq_mmap_cmb(dev, ctx, &qp->rq, &resp.rq_cmb_offset);
 
-			qp->rq.mmap_cmb =
-			    ionic_mmap_entry_insert(ctx,
-						    qp->rq.q.size,
-						    PHYS_PFN(qp->rq.cmb_addr),
-						    wc ? IONIC_MMAP_WC : 0,
-						    &resp.rq_cmb_offset);
 			if (!qp->rq.mmap_cmb) {
 				rc = -ENOMEM;
 				goto err_mmap_rq;
@@ -2496,7 +2514,7 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 		qp->sq_cqid = cq->cqid;
 	}
 
-	if (qp->has_rq) {
+	if (!qp->srq) {
 		cq = to_ionic_vcq_cq(attr->recv_cq, qp->udma_idx);
 
 		attr->cap.max_recv_wr = qp->rq.q.mask;
@@ -2510,7 +2528,7 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 	return 0;
 
 err_resp:
-	if (udata && (qp->rq.cmb & IONIC_CMB_ENABLE))
+	if (udata && !qp->srq && (qp->rq.cmb & IONIC_CMB_ENABLE))
 		rdma_user_mmap_entry_remove(qp->rq.mmap_cmb);
 err_mmap_rq:
 	if (udata && (qp->sq_cmb & IONIC_CMB_ENABLE))
@@ -2518,9 +2536,10 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 err_mmap_sq:
 	ionic_destroy_qp_cmd(dev, qp->qpid);
 err_cmd:
-	ionic_pgtbl_unbuf(dev, &rq_buf);
-	if (qp->has_rq)
+	if (!qp->srq) {
+		ionic_pgtbl_unbuf(dev, &rq_buf);
 		ionic_rq_destroy(dev, ctx, &qp->rq);
+	}
 err_rq:
 	ionic_pgtbl_unbuf(dev, &sq_buf);
 	ionic_qp_sq_destroy(dev, ctx, qp);
@@ -2571,7 +2590,7 @@ void ionic_flush_qp(struct ionic_ibdev *dev, struct ionic_qp *qp)
 		spin_unlock_irqrestore(&cq->lock, irqflags);
 	}
 
-	if (qp->ibqp.recv_cq) {
+	if (qp->ibqp.recv_cq && !qp->srq) {
 		cq = to_ionic_vcq_cq(qp->ibqp.recv_cq, qp->udma_idx);
 
 		/* Hold the CQ lock and QP rq.lock to set up flush */
@@ -2647,7 +2666,7 @@ static void ionic_reset_qp(struct ionic_ibdev *dev, struct ionic_qp *qp)
 		spin_unlock(&qp->sq_lock);
 	}
 
-	if (qp->has_rq) {
+	if (!qp->srq) {
 		spin_lock(&qp->rq.lock);
 		qp->rq.flush = false;
 		qp->rq.q.prod = 0;
@@ -2775,7 +2794,7 @@ int ionic_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	if (qp->has_sq)
 		attr->cap.max_send_wr = qp->sq.mask;
 
-	if (qp->has_rq)
+	if (!qp->srq)
 		attr->cap.max_recv_wr = qp->rq.q.mask;
 
 	init_attr->event_handler = ibqp->event_handler;
@@ -2836,7 +2855,7 @@ int ionic_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 		spin_unlock_irqrestore(&cq->lock, irqflags);
 	}
 
-	if (qp->has_rq)
+	if (!qp->srq)
 		ionic_rq_destroy(dev, ctx, &qp->rq);
 
 	ionic_qp_sq_destroy(dev, ctx, qp);
@@ -2848,3 +2867,264 @@ int ionic_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 
 	return 0;
 }
+
+static int ionic_create_srq_cmd(struct ionic_ibdev *dev,
+				struct ionic_ctx *ctx,
+				struct ionic_srq *srq,
+				struct ionic_pd *pd,
+				struct ionic_tbl_buf *buf,
+				u8 udma_mask)
+{
+	const u16 flags = (srq->rq.cmb & IONIC_CMB_ENABLE) ? IONIC_SRQF_CMB : 0;
+	struct ionic_admin_create_srq_resp *resp_buf;
+	const u16 dbid = ionic_ctx_dbid(dev, ctx);
+	struct ionic_admin_wr wr = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(wr.work),
+		.wqe = {
+			.op = IONIC_V1_ADMIN_CREATE_SRQ,
+			.len = cpu_to_le16(IONIC_ADMIN_CREATE_SRQ_IN_V1_LEN),
+			.cmd.create_srq = {
+				.pd_id = cpu_to_le32(pd->pdid),
+				.depth_log2 = srq->rq.q.depth_log2,
+				.stride_log2 = srq->rq.q.stride_log2,
+				.page_size_log2 = buf->page_size_log2,
+				.map_count = cpu_to_le32(buf->tbl_pages),
+				.dma_addr = ionic_pgtbl_dma(buf, 0),
+				.dbid = cpu_to_le16(dbid),
+				.qid = cpu_to_le32(srq->rq.qid),
+				.low_wqes_limit = cpu_to_le16(srq->srq_limit),
+				.udma_mask = udma_mask,
+				.flags = cpu_to_le16(flags),
+			}
+		}
+	};
+	dma_addr_t resp_buf_dma;
+	int rc;
+
+	if (dev->lif_cfg.admin_opcodes <= IONIC_V1_ADMIN_CREATE_SRQ)
+		return -EOPNOTSUPP;
+
+	resp_buf = kzalloc_obj(*resp_buf);
+	if (!resp_buf)
+		return -ENOMEM;
+
+	resp_buf_dma = dma_map_single(dev->lif_cfg.hwdev, resp_buf,
+				      sizeof(*resp_buf),
+				      DMA_FROM_DEVICE);
+
+	rc = dma_mapping_error(dev->lif_cfg.hwdev, resp_buf_dma);
+	if (rc)
+		goto err_dma;
+
+	wr.wqe.cmd.create_srq.resp_dma_addr = cpu_to_le64(resp_buf_dma);
+	wr.wqe.cmd.create_srq.resp_buf_len = cpu_to_le32(IONIC_ADMIN_CREATE_SRQ_OUT_V1_LEN);
+
+	ionic_admin_post(dev, &wr);
+
+	rc = ionic_admin_wait(dev, &wr, 0);
+
+	dma_unmap_single(dev->lif_cfg.hwdev, resp_buf_dma, sizeof(*resp_buf),
+			 DMA_FROM_DEVICE);
+	if (rc)
+		goto err_dma;
+
+	if (be32_to_cpu(wr.cqe.status_length) < IONIC_ADMIN_CREATE_SRQ_OUT_V1_LEN) {
+		rc = -EOPNOTSUPP;
+		goto err_dma;
+	}
+
+	srq->rq.qid = le32_to_cpu(resp_buf->id);
+	srq->udma_idx = resp_buf->udma_idx;
+
+err_dma:
+	kfree(resp_buf);
+
+	return rc;
+}
+
+static int ionic_destroy_srq_cmd(struct ionic_ibdev *dev, u32 srqid)
+{
+	struct ionic_admin_wr wr = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(wr.work),
+		.wqe = {
+			.op = IONIC_V1_ADMIN_DESTROY_SRQ,
+			.len = cpu_to_le16(IONIC_ADMIN_DESTROY_SRQ_IN_V1_LEN),
+			.cmd.destroy_srq = {
+				.qid = cpu_to_le32(srqid),
+			},
+		}
+	};
+
+	if (dev->lif_cfg.admin_opcodes <= IONIC_V1_ADMIN_DESTROY_SRQ)
+		return -EOPNOTSUPP;
+
+	ionic_admin_post(dev, &wr);
+
+	return ionic_admin_wait(dev, &wr, IONIC_ADMIN_F_TEARDOWN);
+}
+
+static int ionic_modify_srq_cmd(struct ionic_ibdev *dev, u32 srqid,
+				u16 srq_limit)
+{
+	struct ionic_admin_wr wr = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(wr.work),
+		.wqe = {
+			.op = IONIC_V1_ADMIN_MODIFY_SRQ,
+			.len = cpu_to_le16(IONIC_ADMIN_MODIFY_SRQ_IN_V1_LEN),
+			.cmd.modify_srq = {
+				.qid = cpu_to_le32(srqid),
+				.low_wqes_limit = cpu_to_le16(srq_limit),
+			},
+		}
+	};
+
+	if (dev->lif_cfg.admin_opcodes <= IONIC_V1_ADMIN_MODIFY_SRQ)
+		return -EOPNOTSUPP;
+
+	ionic_admin_post(dev, &wr);
+
+	return ionic_admin_wait(dev, &wr, IONIC_ADMIN_F_TEARDOWN);
+}
+
+int ionic_create_srq(struct ib_srq *ibsrq, struct ib_srq_init_attr *attr,
+		     struct ib_udata *udata)
+{
+	struct ionic_ibdev *dev = to_ionic_ibdev(ibsrq->device);
+	struct ionic_pd *pd = to_ionic_pd(ibsrq->pd);
+	struct ionic_srq *srq = to_ionic_srq(ibsrq);
+	struct ionic_ctx *ctx =
+		rdma_udata_to_drv_context(udata, struct ionic_ctx, ibctx);
+	struct ionic_srq_resp resp = {};
+	struct ionic_srq_req req = {};
+	struct ionic_tbl_buf buf = {};
+	u8 udma_mask;
+	int rc;
+
+	if (!ctx)
+		return -EOPNOTSUPP;
+
+	if (attr->srq_type != IB_SRQT_BASIC)
+		return -EOPNOTSUPP;
+
+	if (attr->attr.max_sge > IONIC_MAX_SRQ_SGES)
+		return -EINVAL;
+
+	if (attr->attr.srq_limit >= IONIC_MAX_SRQ_LIMIT)
+		return -EINVAL;
+
+	udma_mask = BIT(dev->lif_cfg.udma_count) - 1;
+	if (udata) {
+		rc = ib_copy_validate_udata_in(udata, req, rsvd);
+		if (rc)
+			return rc;
+
+		udma_mask &= req.udma_mask;
+	}
+
+	if (!udma_mask)
+		return -EINVAL;
+
+	if (udata && (req.rq_cmb & IONIC_CMB_ENABLE))
+		srq->rq.cmb = req.rq_cmb;
+
+	rc = ionic_rq_init(dev, ctx, &srq->rq, &req.rq, &buf,
+			   attr->attr.max_wr, attr->attr.max_sge,
+			   req.rq_spec, udata);
+	if (rc)
+		return rc;
+
+	srq->srq_limit = attr->attr.srq_limit;
+
+	rc = ionic_create_srq_cmd(dev, ctx, srq, pd, &buf, udma_mask);
+	if (rc)
+		goto err_cmd;
+
+	ionic_queue_dbell_init(&srq->rq.q, srq->rq.qid);
+
+	if (udata) {
+		resp.srqid = srq->rq.qid;
+		resp.udma_idx = srq->udma_idx;
+
+		if (srq->rq.cmb & IONIC_CMB_ENABLE) {
+			ionic_rq_mmap_cmb(dev, ctx, &srq->rq, &resp.rq_cmb_offset);
+			if (!srq->rq.mmap_cmb) {
+				rc = -ENOMEM;
+				goto err_srq_cmd;
+			}
+
+			resp.rq_cmb = srq->rq.cmb;
+		}
+
+		rc = ib_respond_udata(udata, resp);
+		if (rc)
+			goto err_srq_cmd;
+	}
+
+	ionic_pgtbl_unbuf(dev, &buf);
+
+	attr->attr.max_wr = srq->rq.q.mask;
+
+	return 0;
+
+err_srq_cmd:
+	ionic_destroy_srq_cmd(dev, srq->rq.qid);
+err_cmd:
+	ionic_pgtbl_unbuf(dev, &buf);
+	ionic_rq_destroy(dev, ctx, &srq->rq);
+
+	return rc;
+}
+
+int ionic_destroy_srq(struct ib_srq *ibsrq, struct ib_udata *udata)
+{
+	struct ionic_ctx *ctx =
+		rdma_udata_to_drv_context(udata, struct ionic_ctx, ibctx);
+	struct ionic_ibdev *dev = to_ionic_ibdev(ibsrq->device);
+	struct ionic_srq *srq = to_ionic_srq(ibsrq);
+	int rc;
+
+	rc = ionic_destroy_srq_cmd(dev, srq->rq.qid);
+	if (rc)
+		return rc;
+
+	ionic_rq_destroy(dev, ctx, &srq->rq);
+
+	return 0;
+}
+
+int ionic_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *srq_attr)
+{
+	struct ionic_srq *srq = to_ionic_srq(ibsrq);
+
+	srq_attr->max_wr = srq->rq.q.mask;
+	srq_attr->max_sge =
+		ionic_v1_recv_wqe_max_sge(srq->rq.q.stride_log2, srq->rq.spec,
+					  srq->rq.cmb & IONIC_CMB_EXPDB);
+	srq_attr->srq_limit = srq->srq_limit;
+
+	return 0;
+}
+
+int ionic_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
+		     enum ib_srq_attr_mask attr_mask, struct ib_udata *udata)
+{
+	struct ionic_ibdev *dev = to_ionic_ibdev(ibsrq->device);
+	struct ionic_srq *srq = to_ionic_srq(ibsrq);
+	int rc;
+
+	if (attr_mask & IB_SRQ_MAX_WR)
+		return -EINVAL;
+
+	if (attr_mask & IB_SRQ_LIMIT) {
+		if (attr->srq_limit >= IONIC_MAX_SRQ_LIMIT)
+			return -EINVAL;
+
+		rc = ionic_modify_srq_cmd(dev, srq->rq.qid, attr->srq_limit);
+		if (rc)
+			return rc;
+
+		srq->srq_limit = attr->srq_limit;
+	}
+
+	return 0;
+}
diff --git a/drivers/infiniband/hw/ionic/ionic_datapath.c b/drivers/infiniband/hw/ionic/ionic_datapath.c
index 522c6f08c9fd..c5726c6bd5cb 100644
--- a/drivers/infiniband/hw/ionic/ionic_datapath.c
+++ b/drivers/infiniband/hw/ionic/ionic_datapath.c
@@ -526,6 +526,12 @@ static int ionic_poll_vcq_cq(struct ionic_ibdev *dev,
 
 		switch (type) {
 		case IONIC_V1_CQE_TYPE_RECV:
+			if (qp->srq) {
+				ibdev_dbg(&dev->ibdev,
+					  "srq recv cqe for qp %u\n", qid);
+				goto cq_next;
+			}
+
 			spin_lock(&qp->rq.lock);
 			rc = ionic_poll_recv(dev, cq, qp, cqe, wc + npolled);
 			spin_unlock(&qp->rq.lock);
@@ -1311,7 +1317,7 @@ static int ionic_post_recv_common(struct ionic_ibdev *dev,
 	if (!bad)
 		return -EINVAL;
 
-	if (!qp->has_rq) {
+	if (qp->srq) {
 		*bad = wr;
 		return -EINVAL;
 	}
diff --git a/drivers/infiniband/hw/ionic/ionic_fw.h b/drivers/infiniband/hw/ionic/ionic_fw.h
index 7a02e799de2b..a625149474e1 100644
--- a/drivers/infiniband/hw/ionic/ionic_fw.h
+++ b/drivers/infiniband/hw/ionic/ionic_fw.h
@@ -88,6 +88,10 @@ static inline int to_ionic_mr_flags(int access)
 	return flags;
 }
 
+enum ionic_srq_flags {
+	IONIC_SRQF_CMB			= BIT(0),
+};
+
 enum ionic_qp_flags {
 	/* bits that determine qp access */
 	IONIC_QPF_REMOTE_WRITE		= BIT(0),
@@ -857,6 +861,48 @@ struct ionic_admin_query_qp {
 static_assert(sizeof(struct ionic_admin_query_qp) ==
 	       IONIC_ADMIN_QUERY_QP_IN_V1_LEN);
 
+struct ionic_admin_create_srq {
+	__le64		dma_addr;
+	__le32		map_count;
+	__le32		pd_id;
+	__le32		qid;
+	__le16		dbid;
+	__le16		low_wqes_limit;
+	__le16		flags;
+	__u8		depth_log2;
+	__u8		stride_log2;
+	__u8		page_size_log2;
+	__u8		udma_mask;
+	__le32		resp_buf_len;
+	__le64		resp_dma_addr;
+} __packed;
+
+#define IONIC_ADMIN_CREATE_SRQ_IN_V1_LEN 42
+static_assert(sizeof(struct ionic_admin_create_srq) == IONIC_ADMIN_CREATE_SRQ_IN_V1_LEN);
+
+struct ionic_admin_create_srq_resp {
+	__le32          id;
+	__u8            udma_idx;
+} __packed;
+
+#define IONIC_ADMIN_CREATE_SRQ_OUT_V1_LEN 5
+static_assert(sizeof(struct ionic_admin_create_srq_resp) == IONIC_ADMIN_CREATE_SRQ_OUT_V1_LEN);
+
+struct ionic_admin_modify_srq {
+	__le32		qid;
+	__le16		low_wqes_limit;
+} __packed;
+
+#define IONIC_ADMIN_MODIFY_SRQ_IN_V1_LEN 6
+static_assert(sizeof(struct ionic_admin_modify_srq) == IONIC_ADMIN_MODIFY_SRQ_IN_V1_LEN);
+
+struct ionic_admin_destroy_srq {
+	__le32		qid;
+} __packed;
+
+#define IONIC_ADMIN_DESTROY_SRQ_IN_V1_LEN 4
+static_assert(sizeof(struct ionic_admin_destroy_srq) == IONIC_ADMIN_DESTROY_SRQ_IN_V1_LEN);
+
 #define ADMIN_WQE_STRIDE	64
 #define ADMIN_WQE_HDR_LEN	4
 
@@ -879,6 +925,9 @@ struct ionic_v1_admin_wqe {
 		struct ionic_admin_destroy_qp destroy_qp;
 		struct ionic_admin_mod_qp mod_qp;
 		struct ionic_admin_query_qp query_qp;
+		struct ionic_admin_create_srq create_srq;
+		struct ionic_admin_modify_srq modify_srq;
+		struct ionic_admin_destroy_srq destroy_srq;
 	} cmd;
 };
 
@@ -925,6 +974,10 @@ enum ionic_v1_admin_op {
 	IONIC_V1_ADMIN_DESTROY_AH,
 	IONIC_V1_ADMIN_QP_STATS_HDRS,
 	IONIC_V1_ADMIN_QP_STATS_VALS,
+	IONIC_V1_ADMIN_CREATE_SRQ = 26,
+	IONIC_V1_ADMIN_MODIFY_SRQ,
+	IONIC_V1_ADMIN_QUERY_SRQ,
+	IONIC_V1_ADMIN_DESTROY_SRQ,
 	IONIC_V1_ADMIN_OPCODES_MAX,
 };
 
diff --git a/drivers/infiniband/hw/ionic/ionic_ibdev.c b/drivers/infiniband/hw/ionic/ionic_ibdev.c
index cba7809ec3d9..3187f6297946 100644
--- a/drivers/infiniband/hw/ionic/ionic_ibdev.c
+++ b/drivers/infiniband/hw/ionic/ionic_ibdev.c
@@ -73,6 +73,11 @@ static int ionic_query_device(struct ib_device *ibdev,
 	attr->max_ah = dev->lif_cfg.nahs_per_lif;
 	attr->max_fast_reg_page_list_len = dev->lif_cfg.npts_per_lif / 2;
 	attr->max_pkeys = IONIC_PKEY_TBL_LEN;
+	if (dev->lif_cfg.srq_count && ionic_fw_has_qid_alloc(dev, IONIC_LIF_RDMA_ALLOC_QID_SRQ)) {
+		attr->max_srq = dev->lif_cfg.srq_count;
+		attr->max_srq_wr = IONIC_MAX_SRQ_DEPTH;
+		attr->max_srq_sge = IONIC_MAX_SRQ_SGES;
+	}
 
 	return 0;
 }
@@ -266,6 +271,15 @@ static const struct ib_device_ops ionic_dev_ops = {
 	INIT_RDMA_OBJ_SIZE(ib_mw, ionic_mr, ibmw),
 };
 
+static const struct ib_device_ops ionic_srq_ops = {
+	.create_srq = ionic_create_srq,
+	.modify_srq = ionic_modify_srq,
+	.query_srq = ionic_query_srq,
+	.destroy_srq = ionic_destroy_srq,
+
+	INIT_RDMA_OBJ_SIZE(ib_srq, ionic_srq, ibsrq),
+};
+
 static void ionic_init_resids(struct ionic_ibdev *dev)
 {
 	ionic_resid_init(&dev->inuse_cqid, dev->lif_cfg.cq_count);
@@ -354,6 +368,8 @@ static struct ionic_ibdev *ionic_create_ibdev(struct ionic_aux_dev *ionic_adev)
 		goto err_admin;
 
 	ib_set_device_ops(&dev->ibdev, &ionic_dev_ops);
+	if (dev->lif_cfg.srq_count && ionic_fw_has_qid_alloc(dev, IONIC_LIF_RDMA_ALLOC_QID_SRQ))
+		ib_set_device_ops(&dev->ibdev, &ionic_srq_ops);
 
 	ionic_stats_init(dev);
 
diff --git a/drivers/infiniband/hw/ionic/ionic_ibdev.h b/drivers/infiniband/hw/ionic/ionic_ibdev.h
index aa3b4122c5ec..3ee7416427fd 100644
--- a/drivers/infiniband/hw/ionic/ionic_ibdev.h
+++ b/drivers/infiniband/hw/ionic/ionic_ibdev.h
@@ -36,6 +36,10 @@
 #define IONIC_SQCMB_ORDER 5
 #define IONIC_RQCMB_ORDER 0
 
+#define IONIC_MAX_SRQ_SGES	2
+#define IONIC_MAX_SRQ_LIMIT	0xffff
+#define IONIC_MAX_SRQ_DEPTH	0xffff
+
 #define IONIC_META_LAST		((void *)1ul)
 #define IONIC_META_POSTED	((void *)2ul)
 
@@ -263,6 +267,13 @@ struct ionic_rq {
 	bool				flush;
 };
 
+struct ionic_srq {
+	struct ib_srq		ibsrq;
+	struct ionic_rq		rq;
+	u16			srq_limit;
+	u8			udma_idx;
+};
+
 struct ionic_qp {
 	struct ib_qp		ibqp;
 	enum ib_qp_state	state;
@@ -273,7 +284,6 @@ struct ionic_qp {
 	u8			udma_idx;
 	u8			has_ah:1;
 	u8			has_sq:1;
-	u8			has_rq:1;
 	u8			sig_all:1;
 
 	struct list_head	qp_list_counter;
@@ -311,6 +321,7 @@ struct ionic_qp {
 	int			dcqcn_profile;
 
 	struct ib_ud_header	*hdr;
+	struct ionic_srq	*srq;
 };
 
 struct ionic_ah {
@@ -405,6 +416,11 @@ static inline struct ionic_qp *to_ionic_qp(struct ib_qp *ibqp)
 	return container_of(ibqp, struct ionic_qp, ibqp);
 }
 
+static inline struct ionic_srq *to_ionic_srq(struct ib_srq *ibsrq)
+{
+	return container_of(ibsrq, struct ionic_srq, ibsrq);
+}
+
 static inline struct ionic_ah *to_ionic_ah(struct ib_ah *ibah)
 {
 	return container_of(ibah, struct ionic_ah, ibah);
@@ -513,6 +529,12 @@ int ionic_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr, int mask,
 int ionic_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr, int mask,
 		   struct ib_qp_init_attr *init_attr);
 int ionic_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata);
+int ionic_create_srq(struct ib_srq *ibsrq, struct ib_srq_init_attr *attr,
+		     struct ib_udata *udata);
+int ionic_destroy_srq(struct ib_srq *ibsrq, struct ib_udata *udata);
+int ionic_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *srq_attr);
+int ionic_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
+		     enum ib_srq_attr_mask attr_mask, struct ib_udata *udata);
 
 /* ionic_datapath.c */
 int ionic_post_send(struct ib_qp *ibqp, const struct ib_send_wr *wr,
diff --git a/drivers/infiniband/hw/ionic/ionic_lif_cfg.c b/drivers/infiniband/hw/ionic/ionic_lif_cfg.c
index c381bda4360d..66cee57442e7 100644
--- a/drivers/infiniband/hw/ionic/ionic_lif_cfg.c
+++ b/drivers/infiniband/hw/ionic/ionic_lif_cfg.c
@@ -75,6 +75,7 @@ void ionic_fill_lif_cfg(struct ionic_lif *lif, struct ionic_lif_cfg *cfg)
 	cfg->eq_count = lif->ionic->neqs_per_lif;
 	cfg->cq_count = le32_to_cpu(ident->rdma.cq_qtype.qid_count);
 	cfg->qp_count = le32_to_cpu(ident->rdma.sq_qtype.qid_count);
+	cfg->srq_count = le32_to_cpu(ident->rdma.srq_qtype.qid_count);
 	cfg->dbid_count = le32_to_cpu(lif->ionic->ident.dev.ndbpgs_per_lif);
 
 	cfg->aq_qtype = ident->rdma.aq_qtype.qtype;
diff --git a/drivers/infiniband/hw/ionic/ionic_lif_cfg.h b/drivers/infiniband/hw/ionic/ionic_lif_cfg.h
index 68aec06908ca..bc14fc0921da 100644
--- a/drivers/infiniband/hw/ionic/ionic_lif_cfg.h
+++ b/drivers/infiniband/hw/ionic/ionic_lif_cfg.h
@@ -38,6 +38,7 @@ struct ionic_lif_cfg {
 	int eq_count;
 	int cq_count;
 	int qp_count;
+	int srq_count;
 
 	u16 stats_type;
 	u8 aq_qtype;
diff --git a/include/uapi/rdma/ionic-abi.h b/include/uapi/rdma/ionic-abi.h
index 3d8d56922a93..ac48fcd19a4f 100644
--- a/include/uapi/rdma/ionic-abi.h
+++ b/include/uapi/rdma/ionic-abi.h
@@ -113,7 +113,7 @@ struct ionic_srq_req {
 };
 
 struct ionic_srq_resp {
-	__u32 qpid;
+	__u32 srqid;
 	__u8 rq_cmb;
 	__u8 udma_idx;
 	__u8 rsvd[2];
-- 
2.43.0

