Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011019.outbound.protection.outlook.com [40.93.194.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54175476040;
	Fri, 25 Sep 2026 08:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790324930; cv=fail; b=AwRfSNiq6XjbAJQ6zC0haeTQmuZlwc/TdsOt5aogg9mbm8MpO0yiqmnu9cuWTl+V8yUj4mFirt48epQmbDY0xjsA0VJkzD/RyVVJrcZfIZ5CFn9jKVj7l6V8fcm93HgLZ7bPBC4blwMk1y3OX5syM0fA0ruSgo5CjI9u0lVit4I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790324930; c=relaxed/simple;
	bh=UNoJyqcU69d3CtbP20Dy3rhn7rIJr6oeKiR4Iv7nT08=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SSj6TVQvt19gnFlrMQERRyFDX65NpEmnX/ayRfOnC5pOEaI4JUQIQHrlVSuobMPdEAdUJwLH7dZKL1YYsPJH3HXlqCcRWEFPpMGvUIkjJrYCBzupX+jNYzqMG/OGJWEup401dpDAX5c0+v/lWnkBdbLiitlwdPKrXv1V+JbhdxY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4LFrT5aU; arc=fail smtp.client-ip=40.93.194.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4LFrT5aU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uUn0IhN42WVofYQj6FFVEjLJasLUQoBwKGbckaFBwXyU3LuUrSgnZ+ws2nyHtF57vSCawGiwG4hokbKAWm9aJNIh6JeRESH+8uyrsDpMjj/57+7/pPC7cGQ1ZHbu8tCg920I6r+YJhCd9+Zt7clwrA/EjB/vKL20B8y5i8Z7Zx5PmoGPdt0GeYkwPr12D6llvRcS505HPaAT8ytUWaquLdyX0wXkMLa8gLv84fcogihQYt4+QmlPZpAmrnlBYUrjyTu3pbcyquZZjccX6gIoMhxHtxovlXPU5dY9l58eLh7NhWZOTAneyvC50QVA3+kiBWz3p1u8egB5y36B5Pa6tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w1qMJISQAaHvtd20RN7Mmt4lZvRdaBki/hO9/ZV7Bzc=;
 b=bPYaJqwnUjFTAyq3f7+8zgPn+zl9DLznX2v/oGH+6xWaHmOzTYiWFV5bI23cRR/CGJkxAnlpcIm4SkWJpUs9t4o55srEVFrejPaxkZ6Z5tPm9PjHRfkGk3rZhuh6JOli6yiaFQER43fk9uEa2v+bXAZjL/2ilZWNdrCqvLnOgnwfAsJjUkQJgMbsKGyX6HFH1uuEzxh4O0rXiEsLhlLULluQTxh5KmdebGCClMUnvxdIF1feiTBZcalu6G7ycuUHIhgqGBExgHb7h1amasd+jdRroX8m+nDvwOfxxWm5MTNIZ5YqheDjaOG3chNgrFfVJC7mIfaUvuYh7YpqMEVKug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w1qMJISQAaHvtd20RN7Mmt4lZvRdaBki/hO9/ZV7Bzc=;
 b=4LFrT5aUx9BpdF/GzJkl2st2/9pJwMPSfz2EKPvOVM84Ahik5kNgzMRtjWtvbRvFGUa1jNNt9UwsEj7IJlGPLiTSjQKrGL+LiSAv3TZCOwed5pUymSFYS7dT09bUlKVIeCPILTN3PqBI/paHB3NUGYgNte9LA/8+5G4DaPkk5ao=
Received: from BN1PR13CA0004.namprd13.prod.outlook.com (2603:10b6:408:e2::9)
 by CY8PR12MB7562.namprd12.prod.outlook.com (2603:10b6:930:95::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Fri, 25 Sep
 2026 08:28:42 +0000
Received: from BN3PEPF0000B374.namprd21.prod.outlook.com
 (2603:10b6:408:e2:cafe::c) by BN1PR13CA0004.outlook.office365.com
 (2603:10b6:408:e2::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.18 via Frontend Transport; Fri,
 25 Sep 2026 08:28:41 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BN3PEPF0000B374.mail.protection.outlook.com (10.167.243.171) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.5 via Frontend Transport; Fri, 25 Sep 2026 08:28:41 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Fri, 25 Sep
 2026 03:28:39 -0500
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Fri, 25 Sep 2026 03:28:35 -0500
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <brett.creeley@amd.com>,
	<andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <allen.hubbe@amd.com>, <a.k@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Abhijit Gangurde <abhijit.gangurde@amd.com>
Subject: [for-next v3 3/5] RDMA/ionic: segregate rq related fields from ionic_qp into a new ionic_rq struct
Date: Fri, 25 Sep 2026 13:58:00 +0530
Message-ID: <20260925082802.2675902-4-abhijit.gangurde@amd.com>
X-Mailer: git-send-email 2.44.4
In-Reply-To: <20260925082802.2675902-1-abhijit.gangurde@amd.com>
References: <20260925082802.2675902-1-abhijit.gangurde@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B374:EE_|CY8PR12MB7562:EE_
X-MS-Office365-Filtering-Correlation-Id: 8dd55996-aec1-4a01-17c0-08df1adf019e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|82310400026|1800799024|36860700016|10067099003|22082099003|56012099006|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
	Uy/9FjKfOBWpQqBmuCDpUhRbQ9+UvnLPRQdW+uIiyX1nYBW2xq1uO70gsnz8XQmF1bR7isiWbxWkpBRjAijiK+2li+YuEcoC62KBK5sVv9V6woLmu1Ced632lJHdHoqQvzJ7tzUaqAgE9EiBo+7pUk1XlruOi1sQ1Zw7ECZkYGBYQ+NPK7sRaY0vA7JbjHYAmBDZV26kzGjS7lmAhu8R5AKKBZ9uGYRdUzIdoAXkFBXaoTEWDd01J81H9PnotQpMjAzEEWD79qm7bj+MJFgP4RhWfejtRnMng/ZTgOtgQrf1uedvXcH9Zqfju486+s0b9hCko2cANUO3wd2bZAUjQUFiYH7SS2Uz1BMjAxwxgRJSOYKXfyQlau4i3usjZ9f4lGlbCrAXGg/CxJBH0gWkBInM8G4OS6H8VVypNvaoGhyoT21t8whCZ6AE7HwFCqGnbgOm4w3xX8Vz/OFaUNnqRPoP9C2Ap/OBmhP2k+xvxrrMSB+jB2xqD0LlOrzZy0nWrvYjr+lYkvvfwzqkVo66AgLXPD7gVgVe7m7ZcKSKnG225eENiw/9lexIH2IGbzLYzvzVKbFeDQ+fmzEwE0t97nsmABbnJv83yg8ng8EeLh6zS8L5Quq3MNAibQAXiAyvqmmGHxAHRLqbFqU9wAWn+0k5ZOIOIDmrs9A1wdSDuzmKoEySt46rAKX9kjcLYKoGaHO3OCdbPDCxFWQ3Zr3CyQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(82310400026)(1800799024)(36860700016)(10067099003)(22082099003)(56012099006)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	cpR+Lxgig12yJe889x7lt5e+iSrXuPgMI+7sP9TkhX8f3cRPwpohht8XPVn3SZUoHyHOKQqcMgMr0fFdz8uCRlag+QUQUiD6v/KsJIXuYyg7btjl/e1Xtxk4Syl53vrtS/90DT41g9EpYNCfkJ9zdmB1SrMo5PWItSsYWBq2m68Sjs7G+oyM4nGeiBlGImg40pQ/TF+Z1by6Hzv01YUGz8+3aT7/5IvN8c4x/HNWFes291qZwHl4YdUKTpbIRcOoBjQ9c7k6kfPFkaB4d1YPSQ0g/Jw4T1DfKiKBh7i6bU7taERLtX9BDoQO4J9Ni5LnLBuUbgy9NAZf8G/3SxVrA0ySpAQlLsUxymHByjhFWdbt5e2OMno5Kt3SkVm2Z8IRUo0DN4+r/DOj1R1uG71aBbtiwGP66S9p9hlEtjuUjcPB+rc/EbyC0DR1Dtz/hphv
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2026 08:28:41.6670
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dd55996-aec1-4a01-17c0-08df1adf019e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B374.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7562

From: Amit Kumar <a.k@amd.com>

In preparation for SRQ support, segregate rq related fields from ionic_qp
into a new ionic_rq struct. This refactoring enables both non-SRQ and
future SRQ code to leverage the common rq init/destroy infrastructure
around ionic_qp_rq_init/_destroy with no functional changes.

Signed-off-by: Amit Kumar <a.k@amd.com>
Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
---
 .../infiniband/hw/ionic/ionic_controlpath.c   | 305 +++++++++---------
 drivers/infiniband/hw/ionic/ionic_datapath.c  |  90 +++---
 drivers/infiniband/hw/ionic/ionic_ibdev.h     |  40 ++-
 3 files changed, 220 insertions(+), 215 deletions(-)

diff --git a/drivers/infiniband/hw/ionic/ionic_controlpath.c b/drivers/infiniband/hw/ionic/ionic_controlpath.c
index a1a7dad96607..3739c1855a4b 100644
--- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
+++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
@@ -1465,8 +1465,8 @@ static int ionic_create_qp_cmd(struct ionic_ibdev *dev,
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
@@ -1505,8 +1505,8 @@ static int ionic_create_qp_cmd(struct ionic_ibdev *dev,
 
 	if (qp->has_rq) {
 		wr.wqe.cmd.create_qp.rq_cq_id = cpu_to_le32(recv_cq->cqid);
-		wr.wqe.cmd.create_qp.rq_depth_log2 = qp->rq.depth_log2;
-		wr.wqe.cmd.create_qp.rq_stride_log2 = qp->rq.stride_log2;
+		wr.wqe.cmd.create_qp.rq_depth_log2 = qp->rq.q.depth_log2;
+		wr.wqe.cmd.create_qp.rq_stride_log2 = qp->rq.q.stride_log2;
 		wr.wqe.cmd.create_qp.rq_page_size_log2 = rq_buf->page_size_log2;
 		wr.wqe.cmd.create_qp.rq_tbl_index_srq_id = cpu_to_le32(~0);
 		wr.wqe.cmd.create_qp.rq_map_count =
@@ -1528,8 +1528,8 @@ static int ionic_modify_qp_cmd(struct ionic_ibdev *dev,
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
@@ -1699,9 +1699,9 @@ static int ionic_query_qp_cmd(struct ionic_ibdev *dev,
 
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
@@ -2071,99 +2071,87 @@ static void ionic_qp_sq_destroy(struct ionic_ibdev *dev,
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
@@ -2177,105 +2165,102 @@ static int ionic_qp_rq_init(struct ionic_ibdev *dev, struct ionic_ctx *ctx,
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
@@ -2316,10 +2301,10 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 
 	INIT_LIST_HEAD(&qp->cq_poll_sq);
 	INIT_LIST_HEAD(&qp->cq_flush_sq);
-	INIT_LIST_HEAD(&qp->cq_flush_rq);
+	INIT_LIST_HEAD(&qp->rq.cq_flush);
 
 	spin_lock_init(&qp->sq_lock);
-	spin_lock_init(&qp->rq_lock);
+	spin_lock_init(&qp->rq.lock);
 
 	qp->has_sq = 1;
 	qp->has_rq = 1;
@@ -2363,7 +2348,7 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 
 	if (udata) {
 		if (req.rq_cmb & IONIC_CMB_ENABLE)
-			qp->rq_cmb = req.rq_cmb;
+			qp->rq.cmb = req.rq_cmb;
 
 		if (req.sq_cmb & IONIC_CMB_ENABLE)
 			qp->sq_cmb = req.sq_cmb;
@@ -2375,11 +2360,22 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
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
@@ -2425,41 +2421,41 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
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
 				goto err_mmap_rq;
 			}
 
-			resp.rq_cmb = qp->rq_cmb;
+			resp.rq_cmb = qp->rq.cmb;
 		}
 
 		rc = ib_respond_udata(udata, resp);
@@ -2503,19 +2499,19 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
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
 
 err_resp:
-	if (udata && (qp->rq_cmb & IONIC_CMB_ENABLE))
-		rdma_user_mmap_entry_remove(qp->mmap_rq_cmb);
+	if (udata && (qp->rq.cmb & IONIC_CMB_ENABLE))
+		rdma_user_mmap_entry_remove(qp->rq.mmap_cmb);
 err_mmap_rq:
 	if (udata && (qp->sq_cmb & IONIC_CMB_ENABLE))
 		rdma_user_mmap_entry_remove(qp->mmap_sq_cmb);
@@ -2523,7 +2519,8 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 	ionic_destroy_qp_cmd(dev, qp->qpid);
 err_cmd:
 	ionic_pgtbl_unbuf(dev, &rq_buf);
-	ionic_qp_rq_destroy(dev, ctx, qp);
+	if (qp->has_rq)
+		ionic_rq_destroy(dev, ctx, &qp->rq);
 err_rq:
 	ionic_pgtbl_unbuf(dev, &sq_buf);
 	ionic_qp_sq_destroy(dev, ctx, qp);
@@ -2577,15 +2574,15 @@ void ionic_flush_qp(struct ionic_ibdev *dev, struct ionic_qp *qp)
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
@@ -2651,17 +2648,17 @@ static void ionic_reset_qp(struct ionic_ibdev *dev, struct ionic_qp *qp)
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
@@ -2779,7 +2776,7 @@ int ionic_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		attr->cap.max_send_wr = qp->sq.mask;
 
 	if (qp->has_rq)
-		attr->cap.max_recv_wr = qp->rq.mask;
+		attr->cap.max_recv_wr = qp->rq.q.mask;
 
 	init_attr->event_handler = ibqp->event_handler;
 	init_attr->qp_context = ibqp->qp_context;
@@ -2835,11 +2832,13 @@ int ionic_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
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

