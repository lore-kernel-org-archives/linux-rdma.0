Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.65
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793093057;
	b=w40Z1GEaEEmYg2ooMyEXTSLtZGVKWo7Hx9vBUQESdUa/VeistFEHDqIPuE5gwkLJ7WfM
	 /Zjp1Hx2IUhIiBphedwfygrVYDauCuIw/UQY9d+Au6lk5jrdeHAoIhzrVWaOGVdXFp4p5
	 SK3v2XOENCOoOdCwp3deyhqf1yre8cHz8faDsiw0rbyTcLnbu7cYQFGCf1MZPGN7T1W7p
	 EpwUK95QjnrBwiOPMHzGU7owLfHR70GWlsVqdonq3qqSqB5bXjSnNZTq33LjCxeS6UOkX
	 73vVw9AciNZEgtVgF5mqbgsXenXtilO1wSeQ3+QrLOeoexZo4/SV+/LhRTyG8VUmmOw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793093057;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-EOPAttributedMessage:X-MS-PublicTrafficType:
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
	bh=GzVVeoF31WXW6yAzP6WqxpO/ICY9xU9i+BgJHmkxnEM=;
	b=B5Bwiu/CD27hScQfdRaFMySmrCqWuF5fnxghiTSUdcSuKkT+BEPb9lKNh9XVAdlXUEGA
	 G/bTy8V5luw5Qq2SrF3HqfKDBlEpPSdekZ9yqrhpDLTzb4RVWgiETFAlkTkFwcImQylya
	 DodBSt+iR1u5f31D9PKOCgbb4msLmetrsCi+nXoTwm6mmSdqrsmG2DzGqRNtMj6SakBK8
	 6YYl408SsTMjyWma0/Hmh01svyFwmiKVlArrnX5md+jRohrhuz4ydvkoUnNo6md62Cuxh
	 EqfqpXylGCsFGATvaIoqVqcrM2NqnvLDj6BYJ5dnGF6Hmn6ieQaxsbiJd2EQYFI9c9g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=tcER380f;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.65
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012065.outbound.protection.outlook.com [52.101.43.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9750606A31D;
	Tue, 27 Oct 2026 09:24:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B9750606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=tcER380f
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M2A9A9gC9B7tVNGq9TNAd0zunAG3cCwa8/n56InktvSHdydrQWnT+TPMEtkFNFAnpr4RA8U2ZdIkLkKmh9lgJfhbJTKtU++y2bj9EDSMS9HLizy2lx8yTBf68xn7ntiHSdFTEPJgHEre0DMZ+WfDsne4vhombJYpkbWZDKakRDeXHCkBhbAgc93yeGVS4OcKh/XCsCymk5BaEKdiRmbwk3NelP7Nown6nrMQIY0DD1dTr9YIYEQ/i3tZx4fngNZL7UAVkVKKo45uy6qTtjFqYxcgUOCuTq4qA8IiBDfu8Mod0yvgESMz+3VyOFpHo20CVZjv2G6dWJY2Lwhy2qh9EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GzVVeoF31WXW6yAzP6WqxpO/ICY9xU9i+BgJHmkxnEM=;
 b=W+QJr0830Ecy5SpV3L/WbEV748PN0dk3epIlb/sXmV0UOnHDvNk8jtLdkzgCE/928r90n3JVfMA4cdpvb0t5SOHreQk4fikBeiPbnup6kxhCEWwyJ60YddFnYlud7lntuQ0XhkaTyTLpRqvIosHrTt+iCbg1WCrkxV3UAEf73nshKE23ZrzJYg6vddiW/d6LBfwybzkPafBwdGS1TQLLg0QLXsnmOM2hUR2QXjfZAnzoaLvFFD94GtZQ4szCGFc8s88y+vZQTK95IKMaCUouU5XUf0E2EP3ih0SN2aAnv3943KeBwglRlMsOz2ZmFymWAm34e/Y5gu1ZuzAY7JHQCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GzVVeoF31WXW6yAzP6WqxpO/ICY9xU9i+BgJHmkxnEM=;
 b=tcER380fmQZEOQVAw7O7tZuVircatrl3RgndMW/frkKNYY02AeJ1qsnHTQ+tbSIB/FXf85oh7xgfK0etIM2c5K/CLHWcwRDFQnMNDmaS3/a70cJLNR0vBgg40jcBdgxkgCy5umkrJYUwqRsc1ZD/tWXRhYyBzCsnr1ztx0s/8Rw=
Received: from CYXPR02CA0065.namprd02.prod.outlook.com (2603:10b6:930:cd::9)
 by CH2PR12MB4198.namprd12.prod.outlook.com (2603:10b6:610:7e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 09:24:13 +0000
Received: from PH3PEPF00059618.namprd05.prod.outlook.com
 (2603:10b6:930:cd:cafe::83) by CYXPR02CA0065.outlook.office365.com
 (2603:10b6:930:cd::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.546.22 via Frontend Transport; Tue,
 27 Oct 2026 09:24:13 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 PH3PEPF00059618.mail.protection.outlook.com (10.167.243.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.4 via Frontend Transport; Tue, 27 Oct 2026 09:24:12 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Tue, 27 Oct
 2026 04:24:12 -0500
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Tue, 27 Oct
 2026 04:24:11 -0500
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.53 via Frontend
 Transport; Tue, 27 Oct 2026 04:24:09 -0500
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <allen.hubbe@amd.com>, <a.k@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Abhijit
 Gangurde" <abhijit.gangurde@amd.com>
Subject: [for-next 3/3] RDMA/ionic: key recv completions by producer index
Date: Tue, 27 Oct 2026 14:53:53 +0530
Message-ID: <20261027092353.1961552-3-abhijit.gangurde@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261027092353.1961552-1-abhijit.gangurde@amd.com>
References: <20261027092353.1961552-1-abhijit.gangurde@amd.com>
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
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PEPF00059618:EE_|CH2PR12MB4198:EE_
X-MS-Office365-Filtering-Correlation-Id: 6217236f-c3cb-4134-ac7e-08df340c101c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|23010399003|82310400026|1800799024|22082099003|18002099003|56012099006|11063799006|261021121427099003|10067099003|261021123027099003|261021135927099003|261022105027099003|261022075727099003|261009223027099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	9onHc6fLTTUSRN5vhAddnQoeSnuB/J1r91RgTpAThcT7Fj+3VaXoxIZdM3PqKmvE07AEy634dZcObiX3jZsNJoJ0pHcdkRsFk8nWX2k8qOhbMHMixBbByy87471/jvYBcoxTuE1NgY0okRRPDhDWeTSEjvMWen6K0kLZ17O14DiotC+Eyh5isNcssLDGwPly8EWXXbo9tlLh7jbGFB4qEU1i27+NwUwXuOCMHglbiNdTwlI6WkjaCTp2BlLdUzLvnmiJZ06iDfPYQxPg1Nh16BbMNbj/c2CewJLKDilkXdZ+wgjRhFswryUJUKtv49Z6xIVYVurWNrGxFY7BuHPyU43bbYYXOqG5Oap7F52TnKG7qJSBCgSaMZGTpnFvsjK3hASxwfFRhZUE63hQdIRjcEnUo89tDoFS0BWtNJuPdzIn48RjNaaagmaz/KjEMKJr97s9oMv/5YsF9yN+GaknHFs+LA97AVLIBwwKBQznXyijd9rW4IWcdv7V0eD/0TOsazKnWfG2CTczizQ8Mx+lVRpIQ3zKju/5Ca1Gye6poPiXga/A9Y/EDM2y6BSqOk66HnnZWWzM/N8HZvW6xCKgFCilin6pwlzJTqQGE+B1tfiDXSvnMy/255VVC3qxNPBWMYqsEzhaOXYS8MMVDB0sDabCYCffuTEzBqzPKOF3s9S/0tO7qPXXnocIXRDQJPE/EdMuJ6v/Z4+Dzp3aGocovA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(23010399003)(82310400026)(1800799024)(22082099003)(18002099003)(56012099006)(11063799006)(261021121427099003)(10067099003)(261021123027099003)(261021135927099003)(261022105027099003)(261022075727099003)(261009223027099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	keU16PEL7s780tlC9fMEU71qWn/o/HbCXK+OctwcyT8JW2745Qs+xos/0IpHLX/G/zHMm1kAXxOwsPmvWvTgUvV59vB7rR9OrCnjSkhHFWRhxzIiWPff0ZjkgJCmof3JVsCBotghRD+sM4jWy8+UnTwtG49wV/NCQuImuajQXd/IpqG7AD1hbHjosA511n/Fu4X/Q0TQIWx++jcbF0NUpB2jMHteDNJB4srQjUCTQN8CzPj4CBEDD2B+nn1qg9CcZ4+/ZIZ4MoBCKKe5AUhtfd49W+5By0q8Ejrn8IrEifI0SqXURC+WIdIvL+lMR1ekUaQiq8ykZN3yp037mtAuWxuGXKX9AgxkHsd2Bn34SzbNioreTWHtTCLR+4iKZPi4eitLoqfxR7xer3tPE43byFxMlHmX7Vk0rwsDPRsjEl8ukob7yENiqEhe/5XBzjO+
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 09:24:12.3827
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6217236f-c3cb-4134-ac7e-08df340c101c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH3PEPF00059618.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4198

The recv completion's wqe_idx is the RQ producer index. Store the
wr_id at that slot and write the same index into the posted WQE. A
posted flag on the slot rejects a completion for a recv that is not
outstanding.

Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
---
 .../infiniband/hw/ionic/ionic_controlpath.c   | 19 ++++-----------
 drivers/infiniband/hw/ionic/ionic_datapath.c  | 24 +++++++++----------
 drivers/infiniband/hw/ionic/ionic_ibdev.h     |  6 +----
 3 files changed, 18 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/hw/ionic/ionic_controlpath.c b/drivers/infiniband/hw/ionic/ionic_controlpath.c
index 1738635bacf4..8a0a1575a339 100644
--- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
+++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
@@ -2195,8 +2195,8 @@ static int ionic_rq_init(struct ionic_ibdev *dev, struct ionic_ctx *ctx,
 			 struct ionic_tbl_buf *buf, int max_wr, int max_sge,
 			 int rq_spec, struct ib_udata *udata)
 {
-	int rc = 0, i;
 	u32 wqe_size;
+	int rc = 0;
 
 	rc = -EINVAL;
 
@@ -2258,16 +2258,11 @@ static int ionic_rq_init(struct ionic_ibdev *dev, struct ionic_ctx *ctx,
 
 		ionic_queue_dbell_init(&rq->q, rq->qid);
 
-		rq->meta = kmalloc_objs(*rq->meta, (u32)rq->q.mask + 1);
+		rq->meta = kzalloc_objs(*rq->meta, (u32)rq->q.mask + 1);
 		if (!rq->meta) {
 			rc = -ENOMEM;
 			goto err_rq_meta;
 		}
-
-		for (i = 0; i < rq->q.mask; ++i)
-			rq->meta[i].next = &rq->meta[i + 1];
-		rq->meta[i].next = IONIC_META_LAST;
-		rq->meta_head = &rq->meta[0];
 	}
 
 	ionic_rq_init_cmb(dev, rq, udata);
@@ -2638,7 +2633,6 @@ static void ionic_reset_qp(struct ionic_ibdev *dev, struct ionic_qp *qp)
 {
 	unsigned long irqflags;
 	struct ionic_cq *cq;
-	int i;
 
 	local_irq_save(irqflags);
 
@@ -2673,12 +2667,9 @@ static void ionic_reset_qp(struct ionic_ibdev *dev, struct ionic_qp *qp)
 		qp->rq.flush = false;
 		qp->rq.q.prod = 0;
 		qp->rq.q.cons = 0;
-		if (qp->rq.meta) {
-			for (i = 0; i < qp->rq.q.mask; ++i)
-				qp->rq.meta[i].next = &qp->rq.meta[i + 1];
-			qp->rq.meta[i].next = IONIC_META_LAST;
-		}
-		qp->rq.meta_head = &qp->rq.meta[0];
+		if (qp->rq.meta)
+			memset(qp->rq.meta, 0,
+			       (qp->rq.q.mask + 1) * sizeof(*qp->rq.meta));
 		spin_unlock(&qp->rq.lock);
 	}
 
diff --git a/drivers/infiniband/hw/ionic/ionic_datapath.c b/drivers/infiniband/hw/ionic/ionic_datapath.c
index 422e53e21054..f1354dae089c 100644
--- a/drivers/infiniband/hw/ionic/ionic_datapath.c
+++ b/drivers/infiniband/hw/ionic/ionic_datapath.c
@@ -53,7 +53,7 @@ static int ionic_flush_recv(struct ionic_qp *qp, struct ib_wc *wc)
 
 	/* wqe_idx must indicate a request that is outstanding */
 	meta = &qp->rq.meta[wqe_idx];
-	if (unlikely(meta->next != IONIC_META_POSTED)) {
+	if (unlikely(!meta->posted)) {
 		ibdev_warn(qp->ibqp.device,
 			   "flush qp %u recv index %llu not posted\n",
 			   qp->qpid, (unsigned long long)wqe_idx);
@@ -68,8 +68,7 @@ static int ionic_flush_recv(struct ionic_qp *qp, struct ib_wc *wc)
 	wc->wr_id = meta->wrid;
 	wc->qp = &qp->ibqp;
 
-	meta->next = qp->rq.meta_head;
-	qp->rq.meta_head = meta;
+	meta->posted = false;
 
 	return 1;
 }
@@ -172,14 +171,13 @@ static int ionic_poll_recv(struct ionic_ibdev *dev, struct ionic_cq *cq,
 
 	/* wqe_idx must indicate a request that is outstanding */
 	meta = &qp->rq.meta[wqe_idx];
-	if (unlikely(meta->next != IONIC_META_POSTED)) {
+	if (unlikely(!meta->posted)) {
 		ibdev_warn(&dev->ibdev,
 			   "qp %u recv index %u not posted\n", qp->qpid, wqe_idx);
 		return -EIO;
 	}
 
-	meta->next = qp->rq.meta_head;
-	qp->rq.meta_head = meta;
+	meta->posted = false;
 
 	memset(wc, 0, sizeof(*wc));
 
@@ -1199,9 +1197,12 @@ static int ionic_prep_recv(struct ionic_qp *qp,
 	if (wqe->base.flags & cpu_to_be16(IONIC_V1_FLAG_FENCE))
 		return -EAGAIN;
 
-	meta = qp->rq.meta_head;
-	if (unlikely(meta == IONIC_META_LAST) ||
-	    unlikely(meta == IONIC_META_POSTED))
+	/*
+	 * The completion carries this producer index, so the wr_id
+	 * lives in the meta slot at the same index.
+	 */
+	meta = &qp->rq.meta[qp->rq.q.prod];
+	if (unlikely(meta->posted))
 		return -EIO;
 
 	ionic_prep_rq_wqe(qp, wqe);
@@ -1216,7 +1217,7 @@ static int ionic_prep_recv(struct ionic_qp *qp,
 
 	meta->wrid = wr->wr_id;
 
-	wqe->base.wqe_idx = cpu_to_le64(meta - qp->rq.meta);
+	wqe->base.wqe_idx = cpu_to_le64(qp->rq.q.prod);
 	wqe->base.num_sge_key = wr->num_sge;
 
 	/* total length for recv goes in base imm_data_key */
@@ -1224,8 +1225,7 @@ static int ionic_prep_recv(struct ionic_qp *qp,
 
 	ionic_queue_produce(&qp->rq.q);
 
-	qp->rq.meta_head = meta->next;
-	meta->next = IONIC_META_POSTED;
+	meta->posted = true;
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/ionic/ionic_ibdev.h b/drivers/infiniband/hw/ionic/ionic_ibdev.h
index cf4b85355f26..127b79cdfc45 100644
--- a/drivers/infiniband/hw/ionic/ionic_ibdev.h
+++ b/drivers/infiniband/hw/ionic/ionic_ibdev.h
@@ -40,9 +40,6 @@
 #define IONIC_MAX_SRQ_LIMIT	0xffff
 #define IONIC_MAX_SRQ_DEPTH	0xffff
 
-#define IONIC_META_LAST		((void *)1ul)
-#define IONIC_META_POSTED	((void *)2ul)
-
 #define IONIC_CQ_GRACE 100
 
 #define IONIC_ROCE_UDP_SPORT	28272
@@ -242,8 +239,8 @@ struct ionic_sq_meta {
 };
 
 struct ionic_rq_meta {
-	struct ionic_rq_meta	*next;
 	u64			wrid;
+	bool			posted;
 };
 
 struct ionic_rq {
@@ -257,7 +254,6 @@ struct ionic_rq {
 	struct rdma_user_mmap_entry	*mmap_cmb;
 
 	struct ionic_rq_meta		*meta;
-	struct ionic_rq_meta		*meta_head;
 	struct ib_umem			*umem;
 
 	int				spec;
-- 
2.43.0

