Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012031.outbound.protection.outlook.com [52.101.48.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C497377007;
	Tue, 22 Sep 2026 09:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790071138; cv=fail; b=Yuu06fXKMVh4A77JLAb7fULG2yOEwalBckI2Y+xg2nGnYUeR+5+q3mYfU2MLgRFNr/ymqbnVzni0u/bfgF+KAXglyClFcd70IrhPebiWnlJY6NBPDjH/uTZm1wYeyXiKBwBSaqqBIgdLvRoF5VN/eu4GM2KknwxVisLctynu+y4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790071138; c=relaxed/simple;
	bh=M2IFZx89ClXbYYzX6czUuX31OQk6FbjQVk/MeYrdH9M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S0rjyAw5v4jJz9+qeWE2qq1eVqTUzAAgI11VBQYZ9iJzV6Rdk0GssSlARUVSF7JwRFn5eTGDJo6ccDAhxXXblvKELE+6LCYEZIl+3MGE8bTa6MnqU6E85thxjI7iArQCFF45BeviwW1XPYD11BhxEWf88eLYssXhBcFZ+O/B+dY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=S31N1koc; arc=fail smtp.client-ip=52.101.48.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="S31N1koc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J99uwQXqLSNsCdAx8A1qTwPQtw150t86fT2iDXwUq8h2iMlwN6oKkdQbWBlf/xllCibC2J4C6MpnXccH0OyL/mMm/m6F2+jp+Dt3klaghFM6fhXDaPyWRJndHHyAWEFROr2SL3yooe6x5qxqGvxHIgWswUplMfbeQfLifvEOpWKE5N8PhbGEb0IXMP9C3jyK2JEk1pELU6qTTyjL4qBiRkG2duEP+XWEcDe3gBUrovrTWVxGdZBGkiyczWeA5A818pcRW9MslE2/4PEqvJW87MezNuukzoEsFDbs4yH+lz0zhDV63C3YxLSvqTpzwzh6rF86iX+gjNopov1Myn44kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZreDbYYGNZStz1+9PNC/DQaAD2LUfjfoYjtdK/mon+w=;
 b=xZ1ZXCnMa8RymyXUats95V99UmgzmYmhm+99kQz3RMllB/mGI4Zb86oie0fW3nx8OcvFP6wgl96TgmJ4YRhPy9tWpnPi9dsTQtptUXHTci0CZmXuYR1yMS6B/fQ+u9klno54CipNeIK13a2arbII1ydMqDGq2SOPxOFHClACW3wHArTzB8GUjbTe+yS8tUuHDTpe0sUsQzUYAgkMmrGDfnxP13Ah6dRqlnZiyVQgS6NXOuQetVSn8nJ54EG+xMeqd+DeOYo38PigMAhnptF/bVIDDDdsJlEGcZJPyDgeupAxInS8s1sciFccUPcOdYQ1nohRdDBhQVcd0v7dBTRPTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZreDbYYGNZStz1+9PNC/DQaAD2LUfjfoYjtdK/mon+w=;
 b=S31N1kocC3AYJQ659IzARtbunvzU3ViW88r/p3DnWRmhfzGOM+cyPLVfuH4xRaPzdAGIZsvxeu4dKmPcZZQWewSUQnA5ukacHkQRNZsYRXqTbGZdx40qsr0T195WEFhHv9lvCCOxwTKteqVbe+0glf+aNDrSJAbXW2h3XbaZ17k=
Received: from BN0PR04CA0052.namprd04.prod.outlook.com (2603:10b6:408:e8::27)
 by PH7PR12MB8779.namprd12.prod.outlook.com (2603:10b6:510:26b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.14; Tue, 22 Sep
 2026 09:58:50 +0000
Received: from BN7PEPF0000009E.namprd04.prod.outlook.com
 (2603:10b6:408:e8:cafe::3f) by BN0PR04CA0052.outlook.office365.com
 (2603:10b6:408:e8::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.16 via Frontend Transport; Tue,
 22 Sep 2026 09:58:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN7PEPF0000009E.mail.protection.outlook.com (10.167.248.150) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Tue, 22 Sep 2026 09:58:50 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 22 Sep
 2026 04:58:49 -0500
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Tue, 22 Sep 2026 04:58:46 -0500
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <brett.creeley@amd.com>,
	<andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <allen.hubbe@amd.com>, <a.k@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Abhijit Gangurde <abhijit.gangurde@amd.com>
Subject: [for-next v2 2/5] RDMA/ionic: support firmware-assigned CQ IDs
Date: Tue, 22 Sep 2026 15:27:21 +0530
Message-ID: <20260922095724.3683011-3-abhijit.gangurde@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN7PEPF0000009E:EE_|PH7PR12MB8779:EE_
X-MS-Office365-Filtering-Correlation-Id: 81cb138a-756e-497b-322f-08df18901a3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700016|23010399003|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	0r0tJiL3OoHlI99YiBIEXAviWx+0EAJaF1QEAfRHKdOfzt33DHQ/l8cj9zmxp7diMpXS8omLPEsgOhTDVWZN9heTlHzSpyZDf0aPCFsUwbkd1oIHyp3DSbXYgIuwgh3tbd+cZ8mWeP+N5I/u6eN4j7GLj5gyhBm7AnksMNQF5CSj5ynyVkXF/1KH/RhZAk0Vzwx+uAjvsby6ZlV9fhRrOY+yfvCBcpOCxGZQIItX/3rxGu/FApRxulRZNcDL4l+6QsfFChlpa2tPEPiMPYR8oF7QgS4b0+veROGdI2GJ+Ia8MD0cPWtg7s5ZRsSHK2hF5W3ETF1kxfro06MRTxv3l14MyvRfQo8IVvL/7KFsNm4PooqNUHzJ/S/+8iSDX7ZnA0XaccaGCaYO7joLI/zJvaXfBzhmeSl1Beu0iWbH4YFhVQYGODNOCGTIKIBMagk6PYPgdM2r7bBZypSdPm4m5va663I1lhdiPxMeUdLbwlIAZ+k6gv9tssVRTj2aWqg7t3RzdNbXXfgEQr649cd+SC/4/VGG2ApI2i1ToJeU+ckjjRk1DsyKXiRZl9mfVTF9tN0E379KF9jGax3zzNagLCBcCknPt3K9xbFJoQQdkT+iCcqc5W465+r5vQmXb+gqodsDwtFPb70U5qei3upeSOwaYBpkW1JdDb8amrOFzILPE7/0pZql5WB9swW+h33lsbycBQeuBgMVxjea7TTpOw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700016)(23010399003)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	QC6FIcTDJ5HXQRi4dQ0Zqwpk/UmE/9O3xtT+HEL/Urh2VoTYQhOwMQQhxpI7vA6Ue9Bo/ft7ZsQHb+aWwDWSAd24TNXXBDzbMPuqDuqSKoosHXRlO7eOQT2uI1YJ5LDghfJu/Y4qmrriMH/HyP+CrfwzjUmxnQ1cTB8dcYOZukVNISHiuVHy5vShI/d0leFcDpL4ZUpVHGOgYqGtAsuwbHvGOSZnhsr6J37AI1oZ7MohCPhE8X2m3WficRFjY6gqSfT0MUgcHhq4cCZRystHeo+UTIWtDDlkFKnk4jko6avIKfcxsWijbVttbpfmbrviDJ83hhy6wg5OUjREf8mLDhLnt9iVgaY7avDERfUb7pwsbdj81tzBEcDug6LVZCLJBh1U5ubBdoEc2uq795Ex/Q5R9uNoPagwZgvo56Hk/yxMUL8ijGQXLARfL8BFZnPI
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 09:58:50.3912
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 81cb138a-756e-497b-322f-08df18901a3b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN7PEPF0000009E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8779

When the LIF advertises qid allocation for CQ, let firmware return
the completion queue ID instead of allocating it in the driver bitmap.

Split CQ create/destroy into distinct phases so cq_tbl is updated only
after the ID is known and removed before the destroy admin command
returns the ID to firmware, avoiding a race where a concurrent create
reusing the same cqid could have its xarray entry erased by a stale
destroy.

Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
---
 drivers/infiniband/hw/ionic/ionic_admin.c     |  70 ++++++++--
 .../infiniband/hw/ionic/ionic_controlpath.c   | 125 ++++++++++++++----
 drivers/infiniband/hw/ionic/ionic_fw.h        |  15 ++-
 drivers/infiniband/hw/ionic/ionic_ibdev.h     |  11 +-
 drivers/infiniband/hw/ionic/ionic_lif_cfg.c   |   1 +
 drivers/infiniband/hw/ionic/ionic_lif_cfg.h   |   1 +
 6 files changed, 183 insertions(+), 40 deletions(-)

diff --git a/drivers/infiniband/hw/ionic/ionic_admin.c b/drivers/infiniband/hw/ionic/ionic_admin.c
index 37e24450d129..bd31594b3690 100644
--- a/drivers/infiniband/hw/ionic/ionic_admin.c
+++ b/drivers/infiniband/hw/ionic/ionic_admin.c
@@ -489,6 +489,49 @@ static int ionic_rdma_queue_devcmd(struct ionic_ibdev *dev,
 	return ionic_rdma_devcmd(dev, &admin);
 }
 
+static int ionic_rdma_cq_devcmd(struct ionic_vcq *vcq,
+				struct ionic_queue *q,
+				u32 *qid, u32 cid, u16 opcode,
+				u8 udma_mask)
+{
+	struct ionic_ibdev *dev = to_ionic_ibdev(vcq->ibcq.device);
+	struct ionic_admin_ctx admin = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(admin.work),
+		.cmd.rdma_queue = {
+			.opcode = opcode,
+			.lif_index = cpu_to_le16(dev->lif_cfg.lif_index),
+			.qid_ver = cpu_to_le32(*qid),
+			.cid = cpu_to_le32(cid),
+			.dbid = cpu_to_le16(dev->lif_cfg.dbid),
+			.depth_log2 = q->depth_log2,
+			.stride_log2 = q->stride_log2,
+			.dma_addr = cpu_to_le64(q->dma),
+		},
+	};
+	int rc;
+
+	if (ionic_fw_has_qid_alloc(dev, IONIC_LIF_RDMA_ALLOC_QID_CQ)) {
+		struct ionic_admin_create_cq_resp resp_buf;
+
+		/* Indicates use of CQ create V2 response format. */
+		admin.cmd.rdma_queue.qid_ver = cpu_to_le32(IONIC_CREATE_CQ_CMD_V2_MAGIC);
+		admin.cmd.rdma_queue.udma_mask = udma_mask;
+
+		rc = ionic_rdma_devcmd(dev, &admin);
+		if (rc)
+			return rc;
+
+		memcpy(&resp_buf, admin.comp.comp.cmd_data, sizeof(resp_buf));
+		*qid = le32_to_cpu(resp_buf.id);
+	} else {
+		rc = ionic_rdma_devcmd(dev, &admin);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
 static void ionic_rdma_admincq_comp(struct ib_cq *ibcq, void *cq_context)
 {
 	struct ionic_aq *aq = cq_context;
@@ -533,12 +576,16 @@ static struct ionic_vcq *ionic_create_rdma_admincq(struct ionic_ibdev *dev,
 	cq = &vcq->cq[0];
 
 	rc = ionic_create_cq_common(vcq, &buf, &attr, NULL, NULL,
-				    NULL, NULL, 0);
+				    NULL, 0);
 	if (rc)
 		goto err_init;
 
-	rc = ionic_rdma_queue_devcmd(dev, &cq->q, cq->cqid, cq->eqid,
-				     IONIC_CMD_RDMA_CREATE_CQ);
+	rc = ionic_rdma_cq_devcmd(vcq, &cq->q, &cq->cqid, cq->eqid,
+				  IONIC_CMD_RDMA_CREATE_CQ, 0);
+	if (rc)
+		goto err_cmd;
+
+	rc = ionic_post_create_cq_cmd(cq, NULL, NULL);
 	if (rc)
 		goto err_cmd;
 
@@ -552,6 +599,14 @@ static struct ionic_vcq *ionic_create_rdma_admincq(struct ionic_ibdev *dev,
 	return ERR_PTR(rc);
 }
 
+static void ionic_destroy_rdma_admincq(struct ionic_ibdev *dev,
+				       struct ionic_vcq *vcq)
+{
+	ionic_pre_destroy_cq_cmd(dev, &vcq->cq[0]);
+	ionic_destroy_cq_common(dev, &vcq->cq[0]);
+	kfree(vcq);
+}
+
 static struct ionic_aq *__ionic_create_rdma_adminq(struct ionic_ibdev *dev,
 						   u32 aqid, u32 cqid)
 {
@@ -1153,8 +1208,7 @@ int ionic_create_rdma_admin(struct ionic_ibdev *dev)
 					      vcq->cq[0].cqid);
 		if (IS_ERR(aq)) {
 			/* Clean up the dangling CQ */
-			ionic_destroy_cq_common(dev, &vcq->cq[0]);
-			kfree(vcq);
+			ionic_destroy_rdma_admincq(dev, vcq);
 
 			rc = PTR_ERR(aq);
 
@@ -1207,10 +1261,8 @@ void ionic_destroy_rdma_admin(struct ionic_ibdev *dev)
 			cancel_work_sync(&aq->work);
 
 			__ionic_destroy_rdma_adminq(dev, aq);
-			if (vcq) {
-				ionic_destroy_cq_common(dev, &vcq->cq[0]);
-				kfree(vcq);
-			}
+			if (vcq)
+				ionic_destroy_rdma_admincq(dev, vcq);
 		}
 
 		kfree(dev->aq_vec);
diff --git a/drivers/infiniband/hw/ionic/ionic_controlpath.c b/drivers/infiniband/hw/ionic/ionic_controlpath.c
index 37f71fb43811..7a840ece8259 100644
--- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
+++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
@@ -79,12 +79,10 @@ int ionic_create_cq_common(struct ionic_vcq *vcq,
 			   struct ionic_ctx *ctx,
 			   struct ib_udata *udata,
 			   struct ionic_qdesc *req_cq,
-			   __u32 *resp_cqid,
 			   int udma_idx)
 {
 	struct ionic_ibdev *dev = to_ionic_ibdev(vcq->ibcq.device);
 	struct ionic_cq *cq = &vcq->cq[udma_idx];
-	void *entry;
 	int rc;
 
 	cq->vcq = vcq;
@@ -94,9 +92,11 @@ int ionic_create_cq_common(struct ionic_vcq *vcq,
 		goto err_args;
 	}
 
-	rc = ionic_get_cqid(dev, &cq->cqid, udma_idx);
-	if (rc)
-		goto err_args;
+	if (!ionic_fw_has_qid_alloc(dev, IONIC_LIF_RDMA_ALLOC_QID_CQ)) {
+		rc = ionic_get_cqid(dev, &cq->cqid, udma_idx);
+		if (rc)
+			goto err_args;
+	}
 
 	cq->eqid = ionic_get_eqid(dev, attr->comp_vector, udma_idx);
 
@@ -122,8 +122,6 @@ int ionic_create_cq_common(struct ionic_vcq *vcq,
 		cq->q.mask = req_cq->mask;
 		cq->q.depth_log2 = req_cq->depth_log2;
 		cq->q.stride_log2 = req_cq->stride_log2;
-
-		*resp_cqid = cq->cqid;
 	} else {
 		rc = ionic_queue_init(&cq->q, dev->lif_cfg.hwdev,
 				      attr->cqe + IONIC_CQ_GRACE,
@@ -131,7 +129,6 @@ int ionic_create_cq_common(struct ionic_vcq *vcq,
 		if (rc)
 			goto err_q_init;
 
-		ionic_queue_dbell_init(&cq->q, cq->cqid);
 		cq->color = true;
 		cq->credit = cq->q.mask;
 	}
@@ -143,20 +140,8 @@ int ionic_create_cq_common(struct ionic_vcq *vcq,
 	init_completion(&cq->cq_rel_comp);
 	kref_init(&cq->cq_kref);
 
-	entry = xa_store_irq(&dev->cq_tbl, cq->cqid, cq, GFP_KERNEL);
-	if (entry) {
-		if (!xa_is_err(entry))
-			rc = -EINVAL;
-		else
-			rc = xa_err(entry);
-
-		goto err_xa;
-	}
-
 	return 0;
 
-err_xa:
-	ionic_pgtbl_unbuf(dev, buf);
 err_pgtbl_init:
 	if (!udata)
 		ionic_queue_destroy(&cq->q, dev->lif_cfg.hwdev);
@@ -164,29 +149,52 @@ int ionic_create_cq_common(struct ionic_vcq *vcq,
 	if (cq->umem)
 		ib_umem_release(cq->umem);
 err_qdesc:
-	ionic_put_cqid(dev, cq->cqid);
+	if (!ionic_fw_has_qid_alloc(dev, IONIC_LIF_RDMA_ALLOC_QID_CQ))
+		ionic_put_cqid(dev, cq->cqid);
 err_args:
 	cq->vcq = NULL;
 
 	return rc;
 }
 
-void ionic_destroy_cq_common(struct ionic_ibdev *dev, struct ionic_cq *cq)
+int ionic_post_create_cq_cmd(struct ionic_cq *cq,
+			     struct ib_udata *udata,
+			     __u32 *resp_cqid)
+{
+	struct ionic_ibdev *dev = to_ionic_ibdev(cq->vcq->ibcq.device);
+
+	if (udata && resp_cqid)
+		*resp_cqid = cq->cqid;
+	else
+		ionic_queue_dbell_init(&cq->q, cq->cqid);
+
+	return xa_insert_irq(&dev->cq_tbl, cq->cqid, cq, GFP_KERNEL);
+}
+
+void ionic_pre_destroy_cq_cmd(struct ionic_ibdev *dev, struct ionic_cq *cq)
 {
 	if (!cq->vcq)
 		return;
 
-	xa_erase_irq(&dev->cq_tbl, cq->cqid);
+	if (!xa_erase_irq(&dev->cq_tbl, cq->cqid))
+		return;
 
 	kref_put(&cq->cq_kref, ionic_cq_complete);
 	wait_for_completion(&cq->cq_rel_comp);
+}
+
+void ionic_destroy_cq_common(struct ionic_ibdev *dev, struct ionic_cq *cq)
+{
+	if (!cq->vcq)
+		return;
 
 	if (cq->umem)
 		ib_umem_release(cq->umem);
 	else
 		ionic_queue_destroy(&cq->q, dev->lif_cfg.hwdev);
 
-	ionic_put_cqid(dev, cq->cqid);
+	if (!ionic_fw_has_qid_alloc(dev, IONIC_LIF_RDMA_ALLOC_QID_CQ))
+		ionic_put_cqid(dev, cq->cqid);
 
 	cq->vcq = NULL;
 }
@@ -1222,8 +1230,11 @@ int ionic_dealloc_mw(struct ib_mw *ibmw)
 static int ionic_create_cq_cmd(struct ionic_ibdev *dev,
 			       struct ionic_ctx *ctx,
 			       struct ionic_cq *cq,
-			       struct ionic_tbl_buf *buf)
+			       struct ionic_tbl_buf *buf,
+			       int udma_mask,
+			       int *out_udma_idx)
 {
+	struct ionic_admin_create_cq_resp *resp_buf;
 	const u16 dbid = ionic_ctx_dbid(dev, ctx);
 	struct ionic_admin_wr wr = {
 		.work = COMPLETION_INITIALIZER_ONSTACK(wr.work),
@@ -1243,13 +1254,57 @@ static int ionic_create_cq_cmd(struct ionic_ibdev *dev,
 			}
 		}
 	};
+	dma_addr_t resp_buf_dma;
+	int rc;
 
 	if (dev->lif_cfg.admin_opcodes <= IONIC_V1_ADMIN_CREATE_CQ)
 		return -EBADRQC;
 
+	if (!ionic_fw_has_qid_alloc(dev, IONIC_LIF_RDMA_ALLOC_QID_CQ)) {
+		ionic_admin_post(dev, &wr);
+		return ionic_admin_wait(dev, &wr, 0);
+	}
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
+	if (rc) {
+		rc = -ENOMEM;
+		goto err_dma;
+	}
+
+	wr.wqe.len = cpu_to_le16(IONIC_ADMIN_CREATE_CQ_IN_V2_LEN);
+	wr.wqe.cmd.create_cq.udma_mask = udma_mask;
+	wr.wqe.cmd.create_cq.resp_dma_addr = cpu_to_le64(resp_buf_dma);
+	wr.wqe.cmd.create_cq.resp_buf_len = cpu_to_le32(IONIC_ADMIN_CREATE_CQ_OUT_V1_LEN);
+
 	ionic_admin_post(dev, &wr);
+	rc = ionic_admin_wait(dev, &wr, 0);
 
-	return ionic_admin_wait(dev, &wr, 0);
+	dma_unmap_single(dev->lif_cfg.hwdev, resp_buf_dma, sizeof(*resp_buf),
+			 DMA_FROM_DEVICE);
+	if (rc)
+		goto err_dma;
+
+	if (be32_to_cpu(wr.cqe.status_length) < IONIC_ADMIN_CREATE_CQ_OUT_V1_LEN) {
+		rc = -EOPNOTSUPP;
+		goto err_dma;
+	}
+
+	cq->cqid = le32_to_cpu(resp_buf->id);
+	if (out_udma_idx)
+		*out_udma_idx = resp_buf->udma_idx;
+
+err_dma:
+	kfree(resp_buf);
+
+	return rc;
 }
 
 static int ionic_destroy_cq_cmd(struct ionic_ibdev *dev, u32 cqid)
@@ -1308,16 +1363,21 @@ int ionic_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 
 		rc = ionic_create_cq_common(vcq, &buf, attr, ctx, udata,
 					    &req.cq[udma_idx],
-					    &resp.cqid[udma_idx],
 					    udma_idx);
 		if (rc)
 			goto err_init;
 
-		rc = ionic_create_cq_cmd(dev, ctx, &vcq->cq[udma_idx], &buf);
+		rc = ionic_create_cq_cmd(dev, ctx, &vcq->cq[udma_idx], &buf,
+					 udma_idx, NULL);
 		if (rc)
 			goto err_cmd;
 
 		ionic_pgtbl_unbuf(dev, &buf);
+
+		rc = ionic_post_create_cq_cmd(&vcq->cq[udma_idx], udata,
+					      &resp.cqid[udma_idx]);
+		if (rc)
+			goto err_post;
 	}
 
 	vcq->ibcq.cqe = attr->cqe;
@@ -1337,6 +1397,8 @@ int ionic_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 		--udma_idx;
 		if (!(vcq->udma_mask & BIT(udma_idx)))
 			continue;
+		ionic_pre_destroy_cq_cmd(dev, &vcq->cq[udma_idx]);
+err_post:
 		ionic_destroy_cq_cmd(dev, vcq->cq[udma_idx].cqid);
 err_cmd:
 		ionic_pgtbl_unbuf(dev, &buf);
@@ -1364,6 +1426,13 @@ int ionic_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 		if (!(vcq->udma_mask & BIT(udma_idx)))
 			continue;
 
+		/*
+		 * Untrack the CQ before releasing its hardware ID below, so a
+		 * concurrent create that gets the same ID reused by firmware
+		 * cannot have its fresh XArray entry erased by this destroy.
+		 */
+		ionic_pre_destroy_cq_cmd(dev, &vcq->cq[udma_idx]);
+
 		rc_tmp = ionic_destroy_cq_cmd(dev, vcq->cq[udma_idx].cqid);
 		if (rc_tmp) {
 			if (!rc)
diff --git a/drivers/infiniband/hw/ionic/ionic_fw.h b/drivers/infiniband/hw/ionic/ionic_fw.h
index d0a5bce85ed8..7a02e799de2b 100644
--- a/drivers/infiniband/hw/ionic/ionic_fw.h
+++ b/drivers/infiniband/hw/ionic/ionic_fw.h
@@ -746,11 +746,22 @@ struct ionic_admin_create_cq {
 	__le32		map_count;
 	__le64		dma_addr;
 	__le16		dbid_flags;
+	__u8		udma_mask;
+	__le32		resp_buf_len;
+	__le64		resp_dma_addr;
 } __packed;
 
 #define IONIC_ADMIN_CREATE_CQ_IN_V1_LEN 34
-static_assert(sizeof(struct ionic_admin_create_cq) ==
-	       IONIC_ADMIN_CREATE_CQ_IN_V1_LEN);
+#define IONIC_ADMIN_CREATE_CQ_IN_V2_LEN 47
+static_assert(sizeof(struct ionic_admin_create_cq) == IONIC_ADMIN_CREATE_CQ_IN_V2_LEN);
+
+struct ionic_admin_create_cq_resp {
+	__le32		id;
+	__u8		udma_idx;
+} __packed;
+
+#define IONIC_ADMIN_CREATE_CQ_OUT_V1_LEN 5
+static_assert(sizeof(struct ionic_admin_create_cq_resp) == IONIC_ADMIN_CREATE_CQ_OUT_V1_LEN);
 
 struct ionic_admin_destroy_cq {
 	__le32		cq_id;
diff --git a/drivers/infiniband/hw/ionic/ionic_ibdev.h b/drivers/infiniband/hw/ionic/ionic_ibdev.h
index 32b6a8a45fa2..11374dd5a309 100644
--- a/drivers/infiniband/hw/ionic/ionic_ibdev.h
+++ b/drivers/infiniband/hw/ionic/ionic_ibdev.h
@@ -438,6 +438,12 @@ static inline void ionic_cq_complete(struct kref *kref)
 	complete(&cq->cq_rel_comp);
 }
 
+static inline bool ionic_fw_has_qid_alloc(struct ionic_ibdev *dev,
+					  enum ionic_lif_rdma_alloc_qid qtype)
+{
+	return dev->lif_cfg.alloc_qid_cap & qtype;
+}
+
 /* ionic_admin.c */
 extern struct workqueue_struct *ionic_evt_workq;
 void ionic_admin_post(struct ionic_ibdev *dev, struct ionic_admin_wr *wr);
@@ -457,8 +463,11 @@ int ionic_create_cq_common(struct ionic_vcq *vcq,
 			   struct ionic_ctx *ctx,
 			   struct ib_udata *udata,
 			   struct ionic_qdesc *req_cq,
-			   __u32 *resp_cqid,
 			   int udma_idx);
+int ionic_post_create_cq_cmd(struct ionic_cq *cq,
+			     struct ib_udata *udata,
+			     __u32 *resp_cqid);
+void ionic_pre_destroy_cq_cmd(struct ionic_ibdev *dev, struct ionic_cq *cq);
 void ionic_destroy_cq_common(struct ionic_ibdev *dev, struct ionic_cq *cq);
 void ionic_flush_qp(struct ionic_ibdev *dev, struct ionic_qp *qp);
 void ionic_notify_flush_cq(struct ionic_cq *cq);
diff --git a/drivers/infiniband/hw/ionic/ionic_lif_cfg.c b/drivers/infiniband/hw/ionic/ionic_lif_cfg.c
index 1e37bd09490f..c381bda4360d 100644
--- a/drivers/infiniband/hw/ionic/ionic_lif_cfg.c
+++ b/drivers/infiniband/hw/ionic/ionic_lif_cfg.c
@@ -93,6 +93,7 @@ void ionic_fill_lif_cfg(struct ionic_lif *lif, struct ionic_lif_cfg *cfg)
 	    !!(lif->qtype_info[IONIC_QTYPE_TXQ].features & IONIC_QIDENT_F_EXPDB);
 	cfg->rq_expdb =
 	    !!(lif->qtype_info[IONIC_QTYPE_RXQ].features & IONIC_QIDENT_F_EXPDB);
+	cfg->alloc_qid_cap = ident->rdma.alloc_qid_cap;
 }
 
 struct net_device *ionic_lif_netdev(struct ionic_lif *lif)
diff --git a/drivers/infiniband/hw/ionic/ionic_lif_cfg.h b/drivers/infiniband/hw/ionic/ionic_lif_cfg.h
index d7835ac27896..68aec06908ca 100644
--- a/drivers/infiniband/hw/ionic/ionic_lif_cfg.h
+++ b/drivers/infiniband/hw/ionic/ionic_lif_cfg.h
@@ -58,6 +58,7 @@ struct ionic_lif_cfg {
 	bool rq_expdb;
 	u8 expdb_mask;
 	u8 rcq_sign_bit;
+	u8 alloc_qid_cap;
 };
 
 void ionic_fill_lif_cfg(struct ionic_lif *lif, struct ionic_lif_cfg *cfg);
-- 
2.43.0

