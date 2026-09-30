Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013011.outbound.protection.outlook.com [40.93.196.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CDA4718E9;
	Wed, 30 Sep 2026 09:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790760165; cv=fail; b=ChACbItAbMo4hcOdA++HvDbRsvB6KkdmQtHM9vlUTE85tku57LrTvPFc40/yJ8jhK/o1X+F5QqIVN6Ywlu2/b0z+0+smFfdryrA6Kq6gbmxNNGMWFJOqt0nYlNO91bazUrmZ+4u1NGminKSPZKbTwzY+o+Lt8kmyWVmFDPMQm60=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790760165; c=relaxed/simple;
	bh=aT1BMpwFyHycE5kz4NbTrqr22caQbOUetHp4zOyF5Pc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JHhmjXPfgAMXHp7+ucPU3kbjMEnruhYfcruUyMrulpXA/+J4me3pPCR4HKJUunr78WSN4WSxaN0ZPYWQ1Hh+hzU9A+NH0+J5ZEfFuWxFndV/9OYFFwVBbmnX5RmzJRS5XIL41A5c+bsug0Vqx1rS1zmZ2BvSoWPYuHshDvZfv+g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bVSQ+Rig; arc=fail smtp.client-ip=40.93.196.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bVSQ+Rig"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eDvDOaof1CorJqYrHcWP5tYTXdjHiputJYYkf09/+bAP+i4gZG/y0E3EXBkSer4O7fFUPve8N2bovvdU7iB4jAZiCK43v+cQhYFgPFqd8YuxMCkXWfehmWjJeuikQMmGeG3DRsALkufYwKbgGM2mrTRSRoPgx0zQ+J2LGWJ7eSpmiDdAwYIMxoFfDcIN9mqw17xtx1Tw3CN/QNBuI4uXGtdBmcozw5VyqpWIfeqVxXu+YEvfDGjLpmzSNgFSNUbOabt2flfxl3MYMhpuc0BipaHnwhSLSKS6U+iVerf+Gmo3HkKjCWl9F5VKYB7CZKEHYVVtwuM0MHGydZOigTTcvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IzjThavRydUMcfkgOXRccyLo5/Wnq7I2wwJvojQkcd0=;
 b=Bl+FL9Qriu/tC9onKsiUuMafPONar4NR89YsPpT5+HMRMBr+CE5ZeuX0DbvTb8OzaWrSjAgNciAvFX+NHY3qYjmTpAiW1JJ4Ph2f28/mv2AElkuSOf2ZlGz18E0ZMbVS2BuGc/3MrfCUE2QkQnBJUCSqPpPYKi8OBC2l24WgDN22u+i6wPsweZmu4+FqQbYgqD/ybZ4HQZiLKWYf6cwXeTvd3wYHzAdLsCoXXhBTmZEaCeofMG4/QxMo5nHcXy+yRSruvywrRKSUxOmFz+ZMug5LK3RbOM7d80kUCFt32kTak9vZIINUZyYlzVhsskbfOYWJtSA187nJ0m5ogoYgWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IzjThavRydUMcfkgOXRccyLo5/Wnq7I2wwJvojQkcd0=;
 b=bVSQ+RigArDsjphfIaS9ppC/uC3NhkVmHZO7dr8d1+HGbmXNpA/ucPh84d5iHfxo1BhPhFPAnTTwa5LvRR2JytTNzrqQlH4G/xHuXl/yAN5RYTpbYnwn3WPEuVgsMvrUx4B/aLLhPay+kIiWbbnsRKmnXIwAbMdMmOrmaSixY3A=
Received: from CY5P220CA0001.NAMP220.PROD.OUTLOOK.COM (2603:10b6:930:ed::12)
 by CH1PR12MB9671.namprd12.prod.outlook.com (2603:10b6:610:2b0::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.25; Wed, 30 Sep
 2026 09:22:01 +0000
Received: from SN1PEPF000397B3.namprd05.prod.outlook.com
 (2603:10b6:930:ed:cafe::3a) by CY5P220CA0001.outlook.office365.com
 (2603:10b6:930:ed::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.16 via Frontend Transport; Wed,
 30 Sep 2026 09:22:01 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF000397B3.mail.protection.outlook.com (10.167.248.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 09:22:00 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 30 Sep
 2026 04:21:44 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 30 Sep
 2026 04:21:43 -0500
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Wed, 30 Sep 2026 04:21:39 -0500
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <brett.creeley@amd.com>,
	<andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <allen.hubbe@amd.com>, <a.k@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Abhijit Gangurde <abhijit.gangurde@amd.com>
Subject: [for-next v4 3/5] RDMA/ionic: segregate rq related fields from ionic_qp into a new ionic_rq struct
Date: Wed, 30 Sep 2026 14:51:09 +0530
Message-ID: <20260930092111.3176738-4-abhijit.gangurde@amd.com>
X-Mailer: git-send-email 2.44.4
In-Reply-To: <20260930092111.3176738-1-abhijit.gangurde@amd.com>
References: <20260930092111.3176738-1-abhijit.gangurde@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B3:EE_|CH1PR12MB9671:EE_
X-MS-Office365-Filtering-Correlation-Id: 5aafe802-d69a-4666-1226-08df1ed448a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|36860700016|82310400026|22082099003|18002099003|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	FniTx4QPLikm4wg0G9s0KJ8V7YRP9Cf1wgIB0l+NofQDD3z6fgFRzjWmTzJsUWR9E12P05lCPId6FZP8y8LWDd+BSx+RZRzOs7PD6MuW0MUo02D97Gk+Sf6V9+k4EYzFNuoGuFg2zg7glSEscv2IHk2zNc7Z+flLLeHilxqIBxBoiy9nx0NYVxDQNjhaHJ4dPMd5QHzZ3dNtk6Lyig2tLHXa7UskyLIFSB6v7z3GTjrFtWRkPEoIYCOJYjLZ+fgY94SFUIcH/HJmbcTIJiiP1wA/mlB+FqWNxLtO7L061+gjKS57Sp1WRg5gC4qgfbts+t/ojmsbPEnlkPu1yVy0vabPY1rJg4xxUslxSIgk3fVgh2EVWqVFE2Ki2/6K/XWLkL+PTzR5dl8ZCTTMHxIKR8VhrFrlDpjYovimuFVmTDXfF7OK81zE+GxGBUz5lkKzATsCVXw5H+qwIAg4Wr04NTJFf8Kldu0q0IkN2whhjq7YUGvAcFhvYzSnrdP/F24Jn6KLpJBIKl7/cQ4LnL485yid0u/vgdO65VkDoVRyQqxtUwUuFVatGULB8ar+NT9y4SdRO3HzIzxuUZZJv8uKrmAAwyJgEHxqJxBxAN/OjJ/GEFXs5fKAdysUHM8/+0FqUmNPkK0PJ/zoliCcQf0Ye8x0rxYK/fWZcn6/FYtfQPZj1RnXkOMipRixnDC7YlfGUL7KgZC6xQssP7g2vn9q8A==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(36860700016)(82310400026)(22082099003)(18002099003)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	QB+6N3iY4CIAVwHcZkkB3h0MC8V2gcx7WjE7ZpkMiwXQkmDUf07sM6iAxE3qeQeK52EiDayrcvdXVkcWwl9OHEi5HzxvHAH1+CWVWa7mPtGjTyJcB8Kc6znI7k7Rr0f2n7AEl4EfuPr4RdAxhhwvfnYfIsd/r/RalNmiNtu+x0601zW8K8Kz6tZBbiC5DIIHDdRiyjsv33YLxyG80c8kQ7W1vdJzyZay/coLDCgfQPjUyUFJk+duSMXy5ANvyYRWAiijcc/UKuT+7751KMF0Sqctsf0Fuj4/Op3ZmAlLZNjZpuITLXUm1Wiu/FGyBCxLmO2MZTlH9HdtCzWrKjy05NOL1LPy9kIe0M4CGkLfhWL5hAlQjeZDTJAqTgdEdEh9We4vJQrKRd4QSxGrNS9IBTiM0PSH1VBQPSw/SrULPLQbZ9SpxTERKU/SIiuZPO6S
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 09:22:00.9862
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5aafe802-d69a-4666-1226-08df1ed448a2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9671

From: Amit Kumar <a.k@amd.com>

In preparation for SRQ support, segregate rq related fields from ionic_qp
into a new ionic_rq struct. This refactoring enables both non-SRQ and
future SRQ code to leverage the common rq init/destroy infrastructure
around ionic_qp_rq_init/_destroy with no functional changes.

Signed-off-by: Amit Kumar <a.k@amd.com>
Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
---
 .../infiniband/hw/ionic/ionic_controlpath.c   | 301 +++++++++---------
 drivers/infiniband/hw/ionic/ionic_datapath.c  |  90 +++---
 drivers/infiniband/hw/ionic/ionic_ibdev.h     |  40 ++-
 3 files changed, 218 insertions(+), 213 deletions(-)

diff --git a/drivers/infiniband/hw/ionic/ionic_controlpath.c b/drivers/infiniband/hw/ionic/ionic_controlpath.c
index 4b83657fd384..f77a49f4231a 100644
--- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
+++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
@@ -1466,8 +1466,8 @@ static int ionic_create_qp_cmd(struct ionic_ibdev *dev,
 	const u16 dbid = ionic_obj_dbid(dev, pd->ibpd.uobject);
 	const u32 flags = to_ionic_qp_flags(0, 0,
 					    qp->sq_cmb & IONIC_CMB_ENABLE,
-					    qp->rq_cmb & IONIC_CMB_ENABLE,
-					    qp->sq_spec, qp->rq_spec,
+					    qp->rq.cmb & IONIC_CMB_ENABLE,
+					    qp->sq_spec, qp->rq.spec,
 					    pd->flags & IONIC_QPF_PRIVILEGED,
 					    pd_remote_privileged(&pd->ibpd));
 	struct ionic_admin_wr wr = {
@@ -1506,8 +1506,8 @@ static int ionic_create_qp_cmd(struct ionic_ibdev *dev,
 
 	if (qp->has_rq) {
 		wr.wqe.cmd.create_qp.rq_cq_id = cpu_to_le32(recv_cq->cqid);
-		wr.wqe.cmd.create_qp.rq_depth_log2 = qp->rq.depth_log2;
-		wr.wqe.cmd.create_qp.rq_stride_log2 = qp->rq.stride_log2;
+		wr.wqe.cmd.create_qp.rq_depth_log2 = qp->rq.q.depth_log2;
+		wr.wqe.cmd.create_qp.rq_stride_log2 = qp->rq.q.stride_log2;
 		wr.wqe.cmd.create_qp.rq_page_size_log2 = rq_buf->page_size_log2;
 		wr.wqe.cmd.create_qp.rq_tbl_index_srq_id = cpu_to_le32(~0);
 		wr.wqe.cmd.create_qp.rq_map_count =
@@ -1529,8 +1529,8 @@ static int ionic_modify_qp_cmd(struct ionic_ibdev *dev,
 	const u32 flags = to_ionic_qp_flags(attr->qp_access_flags,
 					    attr->en_sqd_async_notify,
 					    qp->sq_cmb & IONIC_CMB_ENABLE,
-					    qp->rq_cmb & IONIC_CMB_ENABLE,
-					    qp->sq_spec, qp->rq_spec,
+					    qp->rq.cmb & IONIC_CMB_ENABLE,
+					    qp->sq_spec, qp->rq.spec,
 					    pd->flags & IONIC_QPF_PRIVILEGED,
 					    pd_remote_privileged(qp->ibqp.pd));
 	const u8 state = to_ionic_qp_modify_state(attr->qp_state,
@@ -1700,9 +1700,9 @@ static int ionic_query_qp_cmd(struct ionic_ibdev *dev,
 
 	if (qp->has_rq) {
 		attr->cap.max_recv_sge =
-			ionic_v1_recv_wqe_max_sge(qp->rq.stride_log2,
-						  qp->rq_spec,
-						  qp->rq_cmb & IONIC_CMB_EXPDB);
+			ionic_v1_recv_wqe_max_sge(qp->rq.q.stride_log2,
+						  qp->rq.spec,
+						  qp->rq.cmb & IONIC_CMB_EXPDB);
 	}
 
 	query_sqbuf = kzalloc(PAGE_SIZE, GFP_KERNEL);
@@ -2072,99 +2072,87 @@ static void ionic_qp_sq_destroy(struct ionic_ibdev *dev,
 		ionic_queue_destroy(&qp->sq, dev->lif_cfg.hwdev);
 }
 
-static void ionic_qp_rq_init_cmb(struct ionic_ibdev *dev,
-				 struct ionic_qp *qp,
-				 struct ib_udata *udata)
+static void ionic_rq_init_cmb(struct ionic_ibdev *dev,
+			      struct ionic_rq *rq,
+			      struct ib_udata *udata)
 {
 	u8 expdb_stride_log2 = 0;
 	bool expdb;
 	int rc;
 
-	if (!(qp->rq_cmb & IONIC_CMB_ENABLE))
+	if (!(rq->cmb & IONIC_CMB_ENABLE))
 		goto not_in_cmb;
 
-	if (qp->rq_cmb & ~IONIC_CMB_SUPPORTED) {
-		if (qp->rq_cmb & IONIC_CMB_REQUIRE)
+	if (rq->cmb & ~IONIC_CMB_SUPPORTED) {
+		if (rq->cmb & IONIC_CMB_REQUIRE)
 			goto not_in_cmb;
 
-		qp->rq_cmb &= IONIC_CMB_SUPPORTED;
+		rq->cmb &= IONIC_CMB_SUPPORTED;
 	}
 
-	if ((qp->rq_cmb & IONIC_CMB_EXPDB) && !dev->lif_cfg.rq_expdb) {
-		if (qp->rq_cmb & IONIC_CMB_REQUIRE)
+	if ((rq->cmb & IONIC_CMB_EXPDB) && !dev->lif_cfg.rq_expdb) {
+		if (rq->cmb & IONIC_CMB_REQUIRE)
 			goto not_in_cmb;
 
-		qp->rq_cmb &= ~IONIC_CMB_EXPDB;
+		rq->cmb &= ~IONIC_CMB_EXPDB;
 	}
 
-	qp->rq_cmb_order = order_base_2(qp->rq.size / PAGE_SIZE);
+	rq->cmb_order = order_base_2(rq->q.size / PAGE_SIZE);
 
-	if (qp->rq_cmb_order >= IONIC_RQCMB_ORDER)
+	if (rq->cmb_order >= IONIC_RQCMB_ORDER)
 		goto not_in_cmb;
 
-	if (qp->rq_cmb & IONIC_CMB_EXPDB)
-		expdb_stride_log2 = qp->rq.stride_log2;
+	if (rq->cmb & IONIC_CMB_EXPDB)
+		expdb_stride_log2 = rq->q.stride_log2;
 
-	rc = ionic_get_cmb(dev->lif_cfg.lif, &qp->rq_cmb_pgid,
-			   &qp->rq_cmb_addr, qp->rq_cmb_order,
+	rc = ionic_get_cmb(dev->lif_cfg.lif, &rq->cmb_pgid,
+			   &rq->cmb_addr, rq->cmb_order,
 			   expdb_stride_log2, &expdb);
 	if (rc)
 		goto not_in_cmb;
 
-	if ((qp->rq_cmb & IONIC_CMB_EXPDB) && !expdb) {
-		if (qp->rq_cmb & IONIC_CMB_REQUIRE)
+	if ((rq->cmb & IONIC_CMB_EXPDB) && !expdb) {
+		if (rq->cmb & IONIC_CMB_REQUIRE)
 			goto err_map;
 
-		qp->rq_cmb &= ~IONIC_CMB_EXPDB;
+		rq->cmb &= ~IONIC_CMB_EXPDB;
 	}
 
 	return;
 
 err_map:
-	ionic_put_cmb(dev->lif_cfg.lif, qp->rq_cmb_pgid, qp->rq_cmb_order);
+	ionic_put_cmb(dev->lif_cfg.lif, rq->cmb_pgid, rq->cmb_order);
 not_in_cmb:
-	if (qp->rq_cmb & IONIC_CMB_REQUIRE)
+	if (rq->cmb & IONIC_CMB_REQUIRE)
 		ibdev_dbg(&dev->ibdev, "could not place rq in cmb as required\n");
 
-	qp->rq_cmb = 0;
-	qp->rq_cmb_order = IONIC_RES_INVALID;
-	qp->rq_cmb_pgid = 0;
-	qp->rq_cmb_addr = 0;
+	rq->cmb = 0;
+	rq->cmb_order = IONIC_RES_INVALID;
+	rq->cmb_pgid = 0;
+	rq->cmb_addr = 0;
 }
 
-static void ionic_qp_rq_destroy_cmb(struct ionic_ibdev *dev,
-				    struct ionic_ctx *ctx,
-				    struct ionic_qp *qp)
+static void ionic_rq_destroy_cmb(struct ionic_ibdev *dev,
+				 struct ionic_ctx *ctx,
+				 struct ionic_rq *rq)
 {
-	if (!(qp->rq_cmb & IONIC_CMB_ENABLE))
+	if (!(rq->cmb & IONIC_CMB_ENABLE))
 		return;
 
 	if (ctx)
-		rdma_user_mmap_entry_remove(qp->mmap_rq_cmb);
+		rdma_user_mmap_entry_remove(rq->mmap_cmb);
 
-	ionic_put_cmb(dev->lif_cfg.lif, qp->rq_cmb_pgid, qp->rq_cmb_order);
+	ionic_put_cmb(dev->lif_cfg.lif, rq->cmb_pgid, rq->cmb_order);
 }
 
-static int ionic_qp_rq_init(struct ionic_ibdev *dev, struct ionic_ctx *ctx,
-			    struct ionic_qp *qp, struct ionic_qdesc *rq,
-			    struct ionic_tbl_buf *buf, int max_wr, int max_sge,
-			    int rq_spec, struct ib_udata *udata)
+static int ionic_rq_init(struct ionic_ibdev *dev, struct ionic_ctx *ctx,
+			 struct ionic_rq *rq, struct ionic_qdesc *qdesc,
+			 struct ionic_tbl_buf *buf, int max_wr, int max_sge,
+			 int rq_spec, struct ib_udata *udata)
 {
 	int rc = 0, i;
 	u32 wqe_size;
 
-	if (!qp->has_rq) {
-		if (buf) {
-			buf->tbl_buf = NULL;
-			buf->tbl_limit = 0;
-			buf->tbl_pages = 0;
-		}
-		if (udata)
-			rc = ionic_validate_qdesc_zero(rq);
-
-		return rc;
-	}
-
 	rc = -EINVAL;
 
 	if (max_wr < 0 || max_wr > 0xffff)
@@ -2178,105 +2166,102 @@ static int ionic_qp_rq_init(struct ionic_ibdev *dev, struct ionic_ctx *ctx,
 		return rc;
 
 	if (udata) {
-		rc = ionic_validate_qdesc(rq);
+		rc = ionic_validate_qdesc(qdesc);
 		if (rc)
 			return rc;
 
-		qp->rq_spec = rq_spec;
+		rq->spec = rq_spec;
 
-		qp->rq.ptr = NULL;
-		qp->rq.size = rq->size;
-		qp->rq.mask = rq->mask;
-		qp->rq.depth_log2 = rq->depth_log2;
-		qp->rq.stride_log2 = rq->stride_log2;
+		rq->q.ptr = NULL;
+		rq->q.size = qdesc->size;
+		rq->q.mask = qdesc->mask;
+		rq->q.depth_log2 = qdesc->depth_log2;
+		rq->q.stride_log2 = qdesc->stride_log2;
 
-		qp->rq_meta = NULL;
+		rq->meta = NULL;
 
-		qp->rq_umem = ib_umem_get_va(&dev->ibdev, rq->addr, rq->size, 0);
-		if (IS_ERR(qp->rq_umem))
-			return PTR_ERR(qp->rq_umem);
+		rq->umem = ib_umem_get_va(&dev->ibdev, qdesc->addr, qdesc->size, 0);
+		if (IS_ERR(rq->umem))
+			return PTR_ERR(rq->umem);
 	} else {
-		qp->rq_umem = NULL;
+		rq->umem = NULL;
 
-		qp->rq_spec = ionic_v1_use_spec_sge(max_sge, rq_spec);
-		if (rq_spec && !qp->rq_spec)
+		rq->spec = ionic_v1_use_spec_sge(max_sge, rq_spec);
+		if (rq_spec && !rq->spec)
 			ibdev_dbg(&dev->ibdev,
 				  "init rq: max_sge %u disables spec\n",
 				  max_sge);
 
-		if (qp->rq_cmb & IONIC_CMB_EXPDB) {
+		if (rq->cmb & IONIC_CMB_EXPDB) {
 			wqe_size = ionic_v1_recv_wqe_min_size(max_sge,
-							      qp->rq_spec,
+							      rq->spec,
 							      true);
 
 			if (!ionic_expdb_wqe_size_supported(dev, wqe_size))
-				qp->rq_cmb &= ~IONIC_CMB_EXPDB;
+				rq->cmb &= ~IONIC_CMB_EXPDB;
 		}
 
-		if (!(qp->rq_cmb & IONIC_CMB_EXPDB))
+		if (!(rq->cmb & IONIC_CMB_EXPDB))
 			wqe_size = ionic_v1_recv_wqe_min_size(max_sge,
-							      qp->rq_spec,
+							      rq->spec,
 							      false);
 
-		rc = ionic_queue_init(&qp->rq, dev->lif_cfg.hwdev,
+		rc = ionic_queue_init(&rq->q, dev->lif_cfg.hwdev,
 				      max_wr, wqe_size);
 		if (rc)
 			return rc;
 
-		ionic_queue_dbell_init(&qp->rq, qp->qpid);
+		ionic_queue_dbell_init(&rq->q, rq->qid);
 
-		qp->rq_meta = kmalloc_objs(*qp->rq_meta, (u32)qp->rq.mask + 1);
-		if (!qp->rq_meta) {
+		rq->meta = kmalloc_objs(*rq->meta, (u32)rq->q.mask + 1);
+		if (!rq->meta) {
 			rc = -ENOMEM;
 			goto err_rq_meta;
 		}
 
-		for (i = 0; i < qp->rq.mask; ++i)
-			qp->rq_meta[i].next = &qp->rq_meta[i + 1];
-		qp->rq_meta[i].next = IONIC_META_LAST;
-		qp->rq_meta_head = &qp->rq_meta[0];
+		for (i = 0; i < rq->q.mask; ++i)
+			rq->meta[i].next = &rq->meta[i + 1];
+		rq->meta[i].next = IONIC_META_LAST;
+		rq->meta_head = &rq->meta[0];
 	}
 
-	ionic_qp_rq_init_cmb(dev, qp, udata);
+	ionic_rq_init_cmb(dev, rq, udata);
 
-	if (qp->rq_cmb & IONIC_CMB_ENABLE)
+	if (rq->cmb & IONIC_CMB_ENABLE)
 		rc = ionic_pgtbl_init(dev, buf, NULL,
-				      (u64)qp->rq_cmb_pgid << PAGE_SHIFT,
+				      (u64)rq->cmb_pgid << PAGE_SHIFT,
 				      1, PAGE_SIZE);
 	else
-		rc = ionic_pgtbl_init(dev, buf,
-				      qp->rq_umem, qp->rq.dma, 1, PAGE_SIZE);
+		rc = ionic_pgtbl_init(dev, buf, rq->umem,
+				      rq->q.dma, 1, PAGE_SIZE);
 	if (rc)
 		goto err_rq_tbl;
 
 	return 0;
 
 err_rq_tbl:
-	ionic_qp_rq_destroy_cmb(dev, ctx, qp);
-	kfree(qp->rq_meta);
+	ionic_rq_destroy_cmb(dev, ctx, rq);
+	kfree(rq->meta);
 err_rq_meta:
-	if (qp->rq_umem)
-		ib_umem_release(qp->rq_umem);
+	if (rq->umem)
+		ib_umem_release(rq->umem);
 	else
-		ionic_queue_destroy(&qp->rq, dev->lif_cfg.hwdev);
+		ionic_queue_destroy(&rq->q, dev->lif_cfg.hwdev);
 	return rc;
 }
 
-static void ionic_qp_rq_destroy(struct ionic_ibdev *dev,
-				struct ionic_ctx *ctx,
-				struct ionic_qp *qp)
+static void ionic_rq_destroy(struct ionic_ibdev *dev,
+			     struct ionic_ctx *ctx,
+			     struct ionic_rq *rq)
 {
-	if (!qp->has_rq)
-		return;
-
-	ionic_qp_rq_destroy_cmb(dev, ctx, qp);
+	ionic_rq_destroy_cmb(dev, ctx, rq);
 
-	kfree(qp->rq_meta);
+	kfree(rq->meta);
 
-	if (qp->rq_umem)
-		ib_umem_release(qp->rq_umem);
+	if (rq->umem)
+		ib_umem_release(rq->umem);
 	else
-		ionic_queue_destroy(&qp->rq, dev->lif_cfg.hwdev);
+		ionic_queue_destroy(&rq->q, dev->lif_cfg.hwdev);
 }
 
 int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
@@ -2317,10 +2302,10 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 
 	INIT_LIST_HEAD(&qp->cq_poll_sq);
 	INIT_LIST_HEAD(&qp->cq_flush_sq);
-	INIT_LIST_HEAD(&qp->cq_flush_rq);
+	INIT_LIST_HEAD(&qp->rq.cq_flush);
 
 	spin_lock_init(&qp->sq_lock);
-	spin_lock_init(&qp->rq_lock);
+	spin_lock_init(&qp->rq.lock);
 
 	qp->has_sq = 1;
 	qp->has_rq = 1;
@@ -2364,7 +2349,7 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 
 	if (udata) {
 		if (req.rq_cmb & IONIC_CMB_ENABLE)
-			qp->rq_cmb = req.rq_cmb;
+			qp->rq.cmb = req.rq_cmb;
 
 		if (req.sq_cmb & IONIC_CMB_ENABLE)
 			qp->sq_cmb = req.sq_cmb;
@@ -2376,11 +2361,22 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 	if (rc)
 		goto err_sq;
 
-	rc = ionic_qp_rq_init(dev, ctx, qp, &req.rq, &rq_buf,
-			      attr->cap.max_recv_wr, attr->cap.max_recv_sge,
-			      req.rq_spec, udata);
-	if (rc)
-		goto err_rq;
+	if (qp->has_rq) {
+		/* for non-srq qps, rq qid is same as qpid */
+		qp->rq.qid = qp->qpid;
+		rc = ionic_rq_init(dev, ctx, &qp->rq, &req.rq, &rq_buf,
+				   attr->cap.max_recv_wr, attr->cap.max_recv_sge,
+				   req.rq_spec, udata);
+		if (rc)
+			goto err_rq;
+	} else {
+		rq_buf.tbl_buf = NULL;
+		rq_buf.tbl_limit = 0;
+		rq_buf.tbl_pages = 0;
+
+		if (udata)
+			rc = ionic_validate_qdesc_zero(&req.rq);
+	}
 
 	rc = ionic_create_qp_cmd(dev, pd,
 				 to_ionic_vcq_cq(attr->send_cq, qp->udma_idx),
@@ -2426,41 +2422,41 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 			resp.sq_cmb = qp->sq_cmb;
 		}
 
-		if (qp->rq_cmb & IONIC_CMB_ENABLE) {
+		if (qp->rq.cmb & IONIC_CMB_ENABLE) {
 			bool wc;
 
-			if ((qp->rq_cmb & (IONIC_CMB_WC | IONIC_CMB_UC)) ==
+			if ((qp->rq.cmb & (IONIC_CMB_WC | IONIC_CMB_UC)) ==
 				(IONIC_CMB_WC | IONIC_CMB_UC)) {
 				ibdev_dbg(&dev->ibdev,
-					  "Both rq_cmb flags IONIC_CMB_WC and IONIC_CMB_UC are set, using default driver mapping\n");
-				qp->rq_cmb &= ~(IONIC_CMB_WC | IONIC_CMB_UC);
+					  "Both rq.cmb flags IONIC_CMB_WC and IONIC_CMB_UC are set, using default driver mapping\n");
+				qp->rq.cmb &= ~(IONIC_CMB_WC | IONIC_CMB_UC);
 			}
 
-			if (qp->rq_cmb & IONIC_CMB_EXPDB)
-				wc = (qp->rq_cmb & (IONIC_CMB_WC | IONIC_CMB_UC))
+			if (qp->rq.cmb & IONIC_CMB_EXPDB)
+				wc = (qp->rq.cmb & (IONIC_CMB_WC | IONIC_CMB_UC))
 					== IONIC_CMB_WC;
 			else
-				wc = (qp->rq_cmb & (IONIC_CMB_WC | IONIC_CMB_UC))
+				wc = (qp->rq.cmb & (IONIC_CMB_WC | IONIC_CMB_UC))
 					!= IONIC_CMB_UC;
 
 			/* let userspace know the mapping */
 			if (wc)
-				qp->rq_cmb |= IONIC_CMB_WC;
+				qp->rq.cmb |= IONIC_CMB_WC;
 			else
-				qp->rq_cmb |= IONIC_CMB_UC;
+				qp->rq.cmb |= IONIC_CMB_UC;
 
-			qp->mmap_rq_cmb =
+			qp->rq.mmap_cmb =
 			    ionic_mmap_entry_insert(ctx,
-						    qp->rq.size,
-						    PHYS_PFN(qp->rq_cmb_addr),
+						    qp->rq.q.size,
+						    PHYS_PFN(qp->rq.cmb_addr),
 						    wc ? IONIC_MMAP_WC : 0,
 						    &resp.rq_cmb_offset);
-			if (!qp->mmap_rq_cmb) {
+			if (!qp->rq.mmap_cmb) {
 				rc = -ENOMEM;
 				goto err_qp_cmd;
 			}
 
-			resp.rq_cmb = qp->rq_cmb;
+			resp.rq_cmb = qp->rq.cmb;
 		}
 
 		rc = ib_respond_udata(udata, resp);
@@ -2504,12 +2500,12 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 	if (qp->has_rq) {
 		cq = to_ionic_vcq_cq(attr->recv_cq, qp->udma_idx);
 
-		attr->cap.max_recv_wr = qp->rq.mask;
+		attr->cap.max_recv_wr = qp->rq.q.mask;
 		attr->cap.max_recv_sge =
-			ionic_v1_recv_wqe_max_sge(qp->rq.stride_log2,
-						  qp->rq_spec,
-						  qp->rq_cmb & IONIC_CMB_EXPDB);
-		qp->rq_cqid = cq->cqid;
+			ionic_v1_recv_wqe_max_sge(qp->rq.q.stride_log2,
+						  qp->rq.spec,
+						  qp->rq.cmb & IONIC_CMB_EXPDB);
+		qp->rq.cqid = cq->cqid;
 	}
 
 	return 0;
@@ -2518,7 +2514,8 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 	ionic_destroy_qp_cmd(dev, qp->qpid);
 err_cmd:
 	ionic_pgtbl_unbuf(dev, &rq_buf);
-	ionic_qp_rq_destroy(dev, ctx, qp);
+	if (qp->has_rq)
+		ionic_rq_destroy(dev, ctx, &qp->rq);
 err_rq:
 	ionic_pgtbl_unbuf(dev, &sq_buf);
 	ionic_qp_sq_destroy(dev, ctx, qp);
@@ -2572,15 +2569,15 @@ void ionic_flush_qp(struct ionic_ibdev *dev, struct ionic_qp *qp)
 	if (qp->ibqp.recv_cq) {
 		cq = to_ionic_vcq_cq(qp->ibqp.recv_cq, qp->udma_idx);
 
-		/* Hold the CQ lock and QP rq_lock to set up flush */
+		/* Hold the CQ lock and QP rq.lock to set up flush */
 		spin_lock_irqsave(&cq->lock, irqflags);
-		spin_lock(&qp->rq_lock);
-		qp->rq_flush = true;
-		if (!ionic_queue_empty(&qp->rq)) {
+		spin_lock(&qp->rq.lock);
+		qp->rq.flush = true;
+		if (!ionic_queue_empty(&qp->rq.q)) {
 			cq->flush = true;
-			list_move_tail(&qp->cq_flush_rq, &cq->flush_rq);
+			list_move_tail(&qp->rq.cq_flush, &cq->flush_rq);
 		}
-		spin_unlock(&qp->rq_lock);
+		spin_unlock(&qp->rq.lock);
 		spin_unlock_irqrestore(&cq->lock, irqflags);
 	}
 }
@@ -2646,17 +2643,17 @@ static void ionic_reset_qp(struct ionic_ibdev *dev, struct ionic_qp *qp)
 	}
 
 	if (qp->has_rq) {
-		spin_lock(&qp->rq_lock);
-		qp->rq_flush = false;
-		qp->rq.prod = 0;
-		qp->rq.cons = 0;
-		if (qp->rq_meta) {
-			for (i = 0; i < qp->rq.mask; ++i)
-				qp->rq_meta[i].next = &qp->rq_meta[i + 1];
-			qp->rq_meta[i].next = IONIC_META_LAST;
+		spin_lock(&qp->rq.lock);
+		qp->rq.flush = false;
+		qp->rq.q.prod = 0;
+		qp->rq.q.cons = 0;
+		if (qp->rq.meta) {
+			for (i = 0; i < qp->rq.q.mask; ++i)
+				qp->rq.meta[i].next = &qp->rq.meta[i + 1];
+			qp->rq.meta[i].next = IONIC_META_LAST;
 		}
-		qp->rq_meta_head = &qp->rq_meta[0];
-		spin_unlock(&qp->rq_lock);
+		qp->rq.meta_head = &qp->rq.meta[0];
+		spin_unlock(&qp->rq.lock);
 	}
 
 	local_irq_restore(irqflags);
@@ -2774,7 +2771,7 @@ int ionic_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		attr->cap.max_send_wr = qp->sq.mask;
 
 	if (qp->has_rq)
-		attr->cap.max_recv_wr = qp->rq.mask;
+		attr->cap.max_recv_wr = qp->rq.q.mask;
 
 	init_attr->event_handler = ibqp->event_handler;
 	init_attr->qp_context = ibqp->qp_context;
@@ -2830,11 +2827,13 @@ int ionic_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 		cq = to_ionic_vcq_cq(qp->ibqp.recv_cq, qp->udma_idx);
 		spin_lock_irqsave(&cq->lock, irqflags);
 		ionic_clean_cq(cq, qp->qpid);
-		list_del(&qp->cq_flush_rq);
+		list_del(&qp->rq.cq_flush);
 		spin_unlock_irqrestore(&cq->lock, irqflags);
 	}
 
-	ionic_qp_rq_destroy(dev, ctx, qp);
+	if (qp->has_rq)
+		ionic_rq_destroy(dev, ctx, &qp->rq);
+
 	ionic_qp_sq_destroy(dev, ctx, qp);
 	if (qp->has_ah) {
 		ionic_put_ahid(dev, qp->ahid);
diff --git a/drivers/infiniband/hw/ionic/ionic_datapath.c b/drivers/infiniband/hw/ionic/ionic_datapath.c
index 3e2300f7ea10..522c6f08c9fd 100644
--- a/drivers/infiniband/hw/ionic/ionic_datapath.c
+++ b/drivers/infiniband/hw/ionic/ionic_datapath.c
@@ -34,17 +34,17 @@ static int ionic_flush_recv(struct ionic_qp *qp, struct ib_wc *wc)
 	struct ionic_v1_wqe *wqe;
 	u64 wqe_idx;
 
-	if (!qp->rq_flush)
+	if (!qp->rq.flush)
 		return 0;
 
-	if (ionic_queue_empty(&qp->rq))
+	if (ionic_queue_empty(&qp->rq.q))
 		return 0;
 
-	wqe = ionic_queue_at_cons(&qp->rq);
+	wqe = ionic_queue_at_cons(&qp->rq.q);
 	wqe_idx = le64_to_cpu(wqe->base.wqe_idx);
 
 	/* wqe_idx must be a valid queue index */
-	if (unlikely(wqe_idx >> qp->rq.depth_log2)) {
+	if (unlikely(wqe_idx >> qp->rq.q.depth_log2)) {
 		ibdev_warn(qp->ibqp.device,
 			   "flush qp %u recv index %llu invalid\n",
 			   qp->qpid, (unsigned long long)wqe_idx);
@@ -52,7 +52,7 @@ static int ionic_flush_recv(struct ionic_qp *qp, struct ib_wc *wc)
 	}
 
 	/* wqe_idx must indicate a request that is outstanding */
-	meta = &qp->rq_meta[wqe_idx];
+	meta = &qp->rq.meta[wqe_idx];
 	if (unlikely(meta->next != IONIC_META_POSTED)) {
 		ibdev_warn(qp->ibqp.device,
 			   "flush qp %u recv index %llu not posted\n",
@@ -60,7 +60,7 @@ static int ionic_flush_recv(struct ionic_qp *qp, struct ib_wc *wc)
 		return -EIO;
 	}
 
-	ionic_queue_consume(&qp->rq);
+	ionic_queue_consume(&qp->rq.q);
 
 	memset(wc, 0, sizeof(*wc));
 
@@ -68,8 +68,8 @@ static int ionic_flush_recv(struct ionic_qp *qp, struct ib_wc *wc)
 	wc->wr_id = meta->wrid;
 	wc->qp = &qp->ibqp;
 
-	meta->next = qp->rq_meta_head;
-	qp->rq_meta_head = meta;
+	meta->next = qp->rq.meta_head;
+	qp->rq.meta_head = meta;
 
 	return 1;
 }
@@ -139,7 +139,7 @@ static int ionic_poll_recv(struct ionic_ibdev *dev, struct ionic_cq *cq,
 	u32 src_qpn, st_len;
 	u8 op;
 
-	if (cqe_qp->rq_flush)
+	if (cqe_qp->rq.flush)
 		return 0;
 
 	qp = cqe_qp;
@@ -148,38 +148,38 @@ static int ionic_poll_recv(struct ionic_ibdev *dev, struct ionic_cq *cq,
 
 	/* ignore wqe_idx in case of flush error */
 	if (ionic_v1_cqe_error(cqe) && st_len == IONIC_STS_WQE_FLUSHED_ERR) {
-		cqe_qp->rq_flush = true;
+		cqe_qp->rq.flush = true;
 		cq->flush = true;
-		list_move_tail(&qp->cq_flush_rq, &cq->flush_rq);
+		list_move_tail(&qp->rq.cq_flush, &cq->flush_rq);
 
 		/* posted recvs (if any) flushed by ionic_flush_recv */
 		return 0;
 	}
 
 	/* there had better be something in the recv queue to complete */
-	if (ionic_queue_empty(&qp->rq)) {
+	if (ionic_queue_empty(&qp->rq.q)) {
 		ibdev_warn(&dev->ibdev, "qp %u is empty\n", qp->qpid);
 		return -EIO;
 	}
 
 	wqe_idx = le64_to_cpu(cqe->recv.wqe_idx_timestamp) & IONIC_V1_CQE_WQE_IDX_MASK;
 	/* wqe_idx must be a valid queue index */
-	if (unlikely(wqe_idx >> qp->rq.depth_log2)) {
+	if (unlikely(wqe_idx >> qp->rq.q.depth_log2)) {
 		ibdev_warn(&dev->ibdev,
 			   "qp %u recv index %u invalid\n", qp->qpid, wqe_idx);
 		return -EIO;
 	}
 
 	/* wqe_idx must indicate a request that is outstanding */
-	meta = &qp->rq_meta[wqe_idx];
+	meta = &qp->rq.meta[wqe_idx];
 	if (unlikely(meta->next != IONIC_META_POSTED)) {
 		ibdev_warn(&dev->ibdev,
 			   "qp %u recv index %u not posted\n", qp->qpid, wqe_idx);
 		return -EIO;
 	}
 
-	meta->next = qp->rq_meta_head;
-	qp->rq_meta_head = meta;
+	meta->next = qp->rq.meta_head;
+	qp->rq.meta_head = meta;
 
 	memset(wc, 0, sizeof(*wc));
 
@@ -191,9 +191,9 @@ static int ionic_poll_recv(struct ionic_ibdev *dev, struct ionic_cq *cq,
 		wc->vendor_err = st_len;
 		wc->status = ionic_to_ib_status(st_len);
 
-		cqe_qp->rq_flush = true;
+		cqe_qp->rq.flush = true;
 		cq->flush = true;
-		list_move_tail(&qp->cq_flush_rq, &cq->flush_rq);
+		list_move_tail(&qp->rq.cq_flush, &cq->flush_rq);
 
 		ibdev_warn(&dev->ibdev,
 			   "qp %d recv cqe with error\n", qp->qpid);
@@ -255,7 +255,7 @@ static int ionic_poll_recv(struct ionic_ibdev *dev, struct ionic_cq *cq,
 	wc->port_num = 1;
 
 out:
-	ionic_queue_consume(&qp->rq);
+	ionic_queue_consume(&qp->rq.q);
 
 	return 1;
 }
@@ -526,9 +526,9 @@ static int ionic_poll_vcq_cq(struct ionic_ibdev *dev,
 
 		switch (type) {
 		case IONIC_V1_CQE_TYPE_RECV:
-			spin_lock(&qp->rq_lock);
+			spin_lock(&qp->rq.lock);
 			rc = ionic_poll_recv(dev, cq, qp, cqe, wc + npolled);
-			spin_unlock(&qp->rq_lock);
+			spin_unlock(&qp->rq.lock);
 
 			if (rc < 0)
 				goto out;
@@ -612,19 +612,19 @@ static int ionic_poll_vcq_cq(struct ionic_ibdev *dev,
 			cq->flush = true;
 	}
 
-	list_for_each_entry_safe(qp, qp_next, &cq->flush_rq, cq_flush_rq) {
+	list_for_each_entry_safe(qp, qp_next, &cq->flush_rq, rq.cq_flush) {
 		if (npolled == nwc)
 			goto out;
 
-		spin_lock(&qp->rq_lock);
+		spin_lock(&qp->rq.lock);
 		rc = ionic_flush_recv_many(qp, wc + npolled, nwc - npolled);
-		spin_unlock(&qp->rq_lock);
+		spin_unlock(&qp->rq.lock);
 
 		if (rc > 0)
 			npolled += rc;
 
 		if (npolled < nwc)
-			list_del_init(&qp->cq_flush_rq);
+			list_del_init(&qp->rq.cq_flush);
 		else
 			cq->flush = true;
 	}
@@ -881,7 +881,7 @@ static void ionic_prep_sq_wqe(struct ionic_qp *qp, void *wqe)
 
 static void ionic_prep_rq_wqe(struct ionic_qp *qp, void *wqe)
 {
-	memset(wqe, 0, 1u << qp->rq.stride_log2);
+	memset(wqe, 0, 1u << qp->rq.q.stride_log2);
 }
 
 static int ionic_prep_send(struct ionic_qp *qp,
@@ -1183,38 +1183,38 @@ static int ionic_prep_recv(struct ionic_qp *qp,
 	s64 signed_len;
 	u32 mval;
 
-	wqe = ionic_queue_at_prod(&qp->rq);
+	wqe = ionic_queue_at_prod(&qp->rq.q);
 
 	/* if wqe is owned by device, caller can try posting again soon */
 	if (wqe->base.flags & cpu_to_be16(IONIC_V1_FLAG_FENCE))
 		return -EAGAIN;
 
-	meta = qp->rq_meta_head;
+	meta = qp->rq.meta_head;
 	if (unlikely(meta == IONIC_META_LAST) ||
 	    unlikely(meta == IONIC_META_POSTED))
 		return -EIO;
 
 	ionic_prep_rq_wqe(qp, wqe);
 
-	mval = ionic_v1_recv_wqe_max_sge(qp->rq.stride_log2, qp->rq_spec,
+	mval = ionic_v1_recv_wqe_max_sge(qp->rq.q.stride_log2, qp->rq.spec,
 					 false);
 	signed_len = ionic_prep_pld(wqe, &wqe->recv.pld,
-				    qp->rq_spec, mval,
+				    qp->rq.spec, mval,
 				    wr->sg_list, wr->num_sge);
 	if (signed_len < 0)
 		return signed_len;
 
 	meta->wrid = wr->wr_id;
 
-	wqe->base.wqe_idx = cpu_to_le64(meta - qp->rq_meta);
+	wqe->base.wqe_idx = cpu_to_le64(meta - qp->rq.meta);
 	wqe->base.num_sge_key = wr->num_sge;
 
 	/* total length for recv goes in base imm_data_key */
 	wqe->base.imm_data_key = cpu_to_be32(signed_len);
 
-	ionic_queue_produce(&qp->rq);
+	ionic_queue_produce(&qp->rq.q);
 
-	qp->rq_meta_head = meta->next;
+	qp->rq.meta_head = meta->next;
 	meta->next = IONIC_META_POSTED;
 
 	return 0;
@@ -1321,10 +1321,10 @@ static int ionic_post_recv_common(struct ionic_ibdev *dev,
 		return -EINVAL;
 	}
 
-	spin_lock_irqsave(&qp->rq_lock, irqflags);
+	spin_lock_irqsave(&qp->rq.lock, irqflags);
 
 	while (wr) {
-		if (ionic_queue_full(&qp->rq)) {
+		if (ionic_queue_full(&qp->rq.q)) {
 			ibdev_dbg(&dev->ibdev, "queue full");
 			rc = -ENOMEM;
 			goto out;
@@ -1339,32 +1339,32 @@ static int ionic_post_recv_common(struct ionic_ibdev *dev,
 
 out:
 	if (!cq) {
-		spin_unlock_irqrestore(&qp->rq_lock, irqflags);
+		spin_unlock_irqrestore(&qp->rq.lock, irqflags);
 		goto out_unlocked;
 	}
-	spin_unlock_irqrestore(&qp->rq_lock, irqflags);
+	spin_unlock_irqrestore(&qp->rq.lock, irqflags);
 
 	spin_lock_irqsave(&cq->lock, irqflags);
-	spin_lock(&qp->rq_lock);
+	spin_lock(&qp->rq.lock);
 
-	if (likely(qp->rq.prod != qp->rq_old_prod)) {
+	if (likely(qp->rq.q.prod != qp->rq.old_prod)) {
 		/* ring cq doorbell just in time */
-		spend = (qp->rq.prod - qp->rq_old_prod) & qp->rq.mask;
+		spend = (qp->rq.q.prod - qp->rq.old_prod) & qp->rq.q.mask;
 		ionic_reserve_cq(dev, cq, spend);
 
-		qp->rq_old_prod = qp->rq.prod;
+		qp->rq.old_prod = qp->rq.q.prod;
 
 		ionic_dbell_ring(dev->lif_cfg.dbpage, dev->lif_cfg.rq_qtype,
-				 ionic_queue_dbell_val(&qp->rq));
+				 ionic_queue_dbell_val(&qp->rq.q));
 	}
 
-	if (qp->rq_flush) {
+	if (qp->rq.flush) {
 		notify = true;
 		cq->flush = true;
-		list_move_tail(&qp->cq_flush_rq, &cq->flush_rq);
+		list_move_tail(&qp->rq.cq_flush, &cq->flush_rq);
 	}
 
-	spin_unlock(&qp->rq_lock);
+	spin_unlock(&qp->rq.lock);
 	spin_unlock_irqrestore(&cq->lock, irqflags);
 
 	if (notify && vcq->ibcq.comp_handler)
diff --git a/drivers/infiniband/hw/ionic/ionic_ibdev.h b/drivers/infiniband/hw/ionic/ionic_ibdev.h
index 11374dd5a309..aa3b4122c5ec 100644
--- a/drivers/infiniband/hw/ionic/ionic_ibdev.h
+++ b/drivers/infiniband/hw/ionic/ionic_ibdev.h
@@ -241,6 +241,28 @@ struct ionic_rq_meta {
 	u64			wrid;
 };
 
+struct ionic_rq {
+	struct ionic_queue		q;
+	u32				qid;
+	u32				cqid;
+	struct list_head		cq_flush;
+	spinlock_t			lock; /* for posting and polling */
+
+	phys_addr_t			cmb_addr;
+	struct rdma_user_mmap_entry	*mmap_cmb;
+
+	struct ionic_rq_meta		*meta;
+	struct ionic_rq_meta		*meta_head;
+	struct ib_umem			*umem;
+
+	int				spec;
+	int				cmb_order;
+	u32				cmb_pgid;
+	u16				old_prod;
+	u8				cmb;
+	bool				flush;
+};
+
 struct ionic_qp {
 	struct ib_qp		ibqp;
 	enum ib_qp_state	state;
@@ -248,7 +270,6 @@ struct ionic_qp {
 	u32			qpid;
 	u32			ahid;
 	u32			sq_cqid;
-	u32			rq_cqid;
 	u8			udma_idx;
 	u8			has_ah:1;
 	u8			has_sq:1;
@@ -259,7 +280,6 @@ struct ionic_qp {
 
 	struct list_head	cq_poll_sq;
 	struct list_head	cq_flush_sq;
-	struct list_head	cq_flush_rq;
 	struct list_head	ibkill_flush_ent;
 
 	spinlock_t		sq_lock; /* for posting and polling */
@@ -274,14 +294,7 @@ struct ionic_qp {
 	bool			sq_flush;
 	bool			sq_flush_rcvd;
 
-	spinlock_t		rq_lock; /* for posting and polling */
-	struct ionic_queue	rq;
-	struct ionic_rq_meta	*rq_meta;
-	struct ionic_rq_meta	*rq_meta_head;
-	int			rq_spec;
-	u16			rq_old_prod;
-	u8			rq_cmb;
-	bool			rq_flush;
+	struct ionic_rq		rq;
 
 	struct kref		qp_kref;
 	struct completion	qp_rel_comp;
@@ -295,13 +308,6 @@ struct ionic_qp {
 
 	struct ib_umem		*sq_umem;
 
-	int			rq_cmb_order;
-	u32			rq_cmb_pgid;
-	phys_addr_t		rq_cmb_addr;
-	struct rdma_user_mmap_entry *mmap_rq_cmb;
-
-	struct ib_umem		*rq_umem;
-
 	int			dcqcn_profile;
 
 	struct ib_ud_header	*hdr;
-- 
2.43.0

