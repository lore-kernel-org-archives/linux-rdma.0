Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012063.outbound.protection.outlook.com [52.101.53.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5388E52FE3A;
	Tue, 22 Sep 2026 09:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790071160; cv=fail; b=oZsQdwl04l0yd+0sgRw6nJfpTpb9QBxFYxt4/DHbUKAxAce7DcC+nIDfR2PrzrsYsMPJLL0QvuzZC+7/0usgFXaA5pc6mO9GbOz5HXyJRZxENnYBQXLzt9C9oR39gkpK7KOChuiqwpI9bIHhfKXaRd23CWoHnxBEqfj9KApE9Vo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790071160; c=relaxed/simple;
	bh=7+3b/3vz5Ph7yUbYTmoqLjc5ybiyzoIonYy9kpyDP90=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WCNC7Pgq2k8eOyr4Hy7uTuSNx0NnhCKc6diRv9tP3D59faFwTQRWDtJDaQKwb9nt/DF5qCUPpKrX+4ZiRd5kpuv9LFfW9nABxahtZ0xrsFYykZdrzOk69wTjfI4rUAbc/kOJvjfZ+7VeEt3p80Yglt+umG6xLvicAhj2W1RmziY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZGVZHsfX; arc=fail smtp.client-ip=52.101.53.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZGVZHsfX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gwy1cdIgreu1Sgloyk18aKRTcgg9OMwWQvcXdW3wlEnYAFUzWKMX1RxMFkpB2F+NbtDfcoeNDhuH4nZx/V0/IPb/DjrN75nOTACWj39dofqUVVfcALfT6G3BK3LHK+5UwDLLBT/RHWrUoB18UQU35YHLIHwFWboBAyfwiLvRkUf/+b/75L5tLtvHN4P5nl20WVSMx8HlPqeM1fZx48+HKNv3maxPQvwg8ClBZzrLENUr4/2SttQnBe5YpMWOXQleTlcYZbjzynMJOxGgErSpvfOytXX6SiBaw3OVdS4/qmOS08pffdTxXst/e+xdpsHL0nVPGv9++jHWlMSViam2Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TENzdZL6Uq0dSc5Sz4tYvL0Fz/X0ANBKuFxvEG9BQQA=;
 b=huJQ3Le0o/HYgOg0uJW9RWIfsM4wE4GodnQXurx/vwY/4Vin+bVMW3nQ0St3uLEvMRlTR1CwZ6ropvvzCIfYuSNo3vp5rp/aSEJuSVV7nHeDxQnBkT0U+c1RXZeAMAgDqSiRe4kYETFpuvuhodclfwEqH8OYpx7pfnWNOyV0IfWRMXJoGp91VGWJGeQLJqlkDQmtx1j4ZMNkMOAxMd5M8XqZamA5R5EeGt+B9aYKHbyR7WBRuyWO+LbRydGuKUulbX2W2D6mKyHGDllT5iJq72Oay5H/Lz57pt0VkUnXW95GKGxzTmAKs6uD3QRhy3KBhx93WyhbTxk2zQCVxIUcUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TENzdZL6Uq0dSc5Sz4tYvL0Fz/X0ANBKuFxvEG9BQQA=;
 b=ZGVZHsfXXWnXFIiMh/stQao4WVh17toE/KBieoHmlwTtk8CUW3aZnctFchTKE8WFHWOQwqPTssQJ/G4gDYmSQ8g7UtmG2dsRSrN3WcASu1sKYzoHipsvShoXyPz3dUWZzrDfksGfOaqQJMB8ib+Qm3iCuGYwOv9FDoELe6iTADA=
Received: from BY1P220CA0007.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:59d::13)
 by CH3PR12MB9729.namprd12.prod.outlook.com (2603:10b6:610:253::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Tue, 22 Sep
 2026 09:59:14 +0000
Received: from BY1PEPF0001AE19.namprd04.prod.outlook.com
 (2603:10b6:a03:59d:cafe::20) by BY1P220CA0007.outlook.office365.com
 (2603:10b6:a03:59d::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.13 via Frontend Transport; Tue,
 22 Sep 2026 09:59:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BY1PEPF0001AE19.mail.protection.outlook.com (10.167.242.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Tue, 22 Sep 2026 09:59:13 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 22 Sep
 2026 04:59:12 -0500
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Tue, 22 Sep 2026 04:59:09 -0500
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <brett.creeley@amd.com>,
	<andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <allen.hubbe@amd.com>, <a.k@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Abhijit Gangurde <abhijit.gangurde@amd.com>
Subject: [for-next v2 5/5] RDMA/ionic: implement SRQ event handling support
Date: Tue, 22 Sep 2026 15:27:24 +0530
Message-ID: <20260922095724.3683011-6-abhijit.gangurde@amd.com>
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
X-MS-TrafficTypeDiagnostic: BY1PEPF0001AE19:EE_|CH3PR12MB9729:EE_
X-MS-Office365-Filtering-Correlation-Id: f166ce84-841d-4f38-826c-08df1890282e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|23010399003|36860700016|11063799006|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	7gOTUuEd+ASgVhgY6unMDnkVluvi4PvtEfnz5auTYXnRiTtHyMI5ybmswLVDt9yQggkiFVZXdi5dKx8gXYKhjxFdaU0jtcvRuO3smpautH+JbORfcrJfupTWK1SOIe2FStNIGOxcN9j+I6MFwNqa55BBTRVf0VY8kzUAOpv0ovz4nTyAJu1sJCjaOd4ULxGlJ+vemJ5tz1SyVbXJ8lb8+feFVfwLGeCWiGTCiPFSpbwAC29b/fvt0A6aTtBEtVKaa9J051gkjNYWJ944Lvwy3o7Q1flNMXJKHuIw2WCTeOW1gbI6XJV6XrxZPb/dnwHCDqfrHOEqOGd/9OWJmHTXxykQ8Ar2h98pnLZc7exQPZlcWOQlcuRIxky9Bc1GDM7YyH8qZRWnt7HHCiM8uZOQ3+I5bNVaZSkOSyfFGmty71klB4CgEND/8Lqtc+QW6ary8T8V9F1b3+S5T6VAK4JEAEi9oYTyvOmusFTnNPOoXJ2oacEut0UxLRPt11gAiLPHR8oUcXAwdyLR1mzjP5rGNsK5BzWaqJpBJZ/V26dc1l7wFOTxjxvrWhjkc7WVHI20D2sypyyO9nBNa0qA6ZafPpsp/hwMdu2xw9JsL/yIKDRTBczpl7VxpLOE16Fwy2JDeb4eeqiuMNOV1UwB17C4qIYGvOdQ76kI2XKVGxVtvAHAC/8K0XEunVTSyE7VrYQA481k2No80GG1unuwMRqQEw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(23010399003)(36860700016)(11063799006)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ijOOHOteOM89jDIEVjWZCr7mxY55VrL6wNp5yv555Q3PencNmwShd1A0fzNn9MiP2mLNWduSzFMaX3oaffuJB+c58Eu1HQ3CtTu29ChdFAxeeNUubA9LpJoN8Mcm8eZn5Zfz7yGZUqkXbM2cvwBy0Avmf3U2UmnwSve6znlfFNQMhXXPFIOfrbKTCuvw7r1z6kxA8NyGbG38XFo/HTPoWnHgVRG7/U4YwZ9Moz3q45nNMY2N2JhmmHvL4sk6wNHrQay0lOJddc7ft7L/MN5sV+y2Mu0KSQKU2DnrnYQj2Vw9P+olM6qM+FhfM8/o+BRyy0MI+bwsxufxu2nLLdCh34i3lDsypv9QzQ58oXAZayUOeGar0+PKxBTzAr//qTayrDTbiksL1F1xFgm1VOUPuwIUVLJZSUzbmTX04C2NRhA8rMOZHU6KBMYpfCPPu9Xf
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 09:59:13.7140
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f166ce84-841d-4f38-826c-08df1890282e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0001AE19.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9729

From: Amit Kumar <a.k@amd.com>

Introduce SRQ event types and associated events. Report these events
through the SRQ event handler during event processing.

Signed-off-by: Amit Kumar <a.k@amd.com>
Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
---
 drivers/infiniband/hw/ionic/ionic_admin.c     | 47 +++++++++++++++++++
 .../infiniband/hw/ionic/ionic_controlpath.c   | 12 +++++
 drivers/infiniband/hw/ionic/ionic_fw.h        |  6 ++-
 drivers/infiniband/hw/ionic/ionic_ibdev.c     |  4 ++
 drivers/infiniband/hw/ionic/ionic_ibdev.h     | 10 ++++
 5 files changed, 78 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/ionic/ionic_admin.c b/drivers/infiniband/hw/ionic/ionic_admin.c
index bd31594b3690..9b5514c145fb 100644
--- a/drivers/infiniband/hw/ionic/ionic_admin.c
+++ b/drivers/infiniband/hw/ionic/ionic_admin.c
@@ -945,6 +945,49 @@ static void ionic_qp_event(struct ionic_ibdev *dev, u32 qpid, u8 code)
 	kref_put(&qp->qp_kref, ionic_qp_complete);
 }
 
+static void ionic_srq_event(struct ionic_ibdev *dev, u32 srqid, u8 code)
+{
+	unsigned long irqflags;
+	struct ionic_srq *srq;
+	struct ib_event ibev;
+
+	xa_lock_irqsave(&dev->srq_tbl, irqflags);
+	srq = xa_load(&dev->srq_tbl, srqid);
+	if (srq)
+		kref_get(&srq->kref);
+	xa_unlock_irqrestore(&dev->srq_tbl, irqflags);
+
+	if (!srq) {
+		ibdev_dbg(&dev->ibdev,
+			  "missing srqid %#x code %u\n", srqid, code);
+		return;
+	}
+
+	ibev.device = &dev->ibdev;
+	ibev.element.srq = &srq->ibsrq;
+
+	switch (code) {
+	case IONIC_V1_EQE_SRQ_LIMIT_REACHED:
+		ibev.event = IB_EVENT_SRQ_LIMIT_REACHED;
+		break;
+
+	case IONIC_V1_EQE_SRQ_ERR:
+		ibev.event = IB_EVENT_SRQ_ERR;
+		break;
+
+	default:
+		ibdev_dbg(&dev->ibdev,
+			  "unrecognized srqid %#x code %u\n", srqid, code);
+		goto out;
+	}
+
+	if (srq->ibsrq.event_handler)
+		srq->ibsrq.event_handler(&ibev, srq->ibsrq.srq_context);
+
+out:
+	kref_put(&srq->kref, ionic_srq_complete);
+}
+
 static u16 ionic_poll_eq(struct ionic_eq *eq, u16 budget)
 {
 	struct ionic_ibdev *dev = eq->dev;
@@ -978,6 +1021,10 @@ static u16 ionic_poll_eq(struct ionic_eq *eq, u16 budget)
 			ionic_qp_event(dev, qid, code);
 			break;
 
+		case IONIC_V1_EQE_TYPE_SRQ:
+			ionic_srq_event(dev, qid, code);
+			break;
+
 		default:
 			ibdev_dbg(&dev->ibdev,
 				  "unknown event %#x type %u\n", evt, type);
diff --git a/drivers/infiniband/hw/ionic/ionic_controlpath.c b/drivers/infiniband/hw/ionic/ionic_controlpath.c
index ec9e1188f556..953c0db0d92e 100644
--- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
+++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
@@ -3060,6 +3060,13 @@ int ionic_create_srq(struct ib_srq *ibsrq, struct ib_srq_init_attr *attr,
 			goto err_srq_cmd;
 	}
 
+	kref_init(&srq->kref);
+	init_completion(&srq->rel_comp);
+
+	rc = xa_insert_irq(&dev->srq_tbl, srq->rq.qid, srq, GFP_KERNEL);
+	if (rc)
+		goto err_srq_cmd;
+
 	ionic_pgtbl_unbuf(dev, &buf);
 
 	attr->attr.max_wr = srq->rq.q.mask;
@@ -3083,6 +3090,11 @@ int ionic_destroy_srq(struct ib_srq *ibsrq, struct ib_udata *udata)
 	struct ionic_srq *srq = to_ionic_srq(ibsrq);
 	int rc;
 
+	if (xa_erase_irq(&dev->srq_tbl, srq->rq.qid)) {
+		kref_put(&srq->kref, ionic_srq_complete);
+		wait_for_completion(&srq->rel_comp);
+	}
+
 	rc = ionic_destroy_srq_cmd(dev, srq->rq.qid);
 	if (rc)
 		return rc;
diff --git a/drivers/infiniband/hw/ionic/ionic_fw.h b/drivers/infiniband/hw/ionic/ionic_fw.h
index a625149474e1..426add364898 100644
--- a/drivers/infiniband/hw/ionic/ionic_fw.h
+++ b/drivers/infiniband/hw/ionic/ionic_fw.h
@@ -1013,7 +1013,7 @@ enum ionic_v1_eqe_evt_bits {
 	/* cq error events */
 	IONIC_V1_EQE_CQ_ERR		= 8,
 
-	/* qp and srq events */
+	/* qp events */
 	IONIC_V1_EQE_TYPE_QP		= 1,
 	/* qp normal events */
 	IONIC_V1_EQE_SRQ_LEVEL		= 0,
@@ -1024,6 +1024,10 @@ enum ionic_v1_eqe_evt_bits {
 	IONIC_V1_EQE_QP_ERR		= 8,
 	IONIC_V1_EQE_QP_ERR_REQUEST	= 9,
 	IONIC_V1_EQE_QP_ERR_ACCESS	= 10,
+	/* srq events */
+	IONIC_V1_EQE_TYPE_SRQ		= 2,
+	IONIC_V1_EQE_SRQ_LIMIT_REACHED	= 0,
+	IONIC_V1_EQE_SRQ_ERR		= 1,
 };
 
 enum ionic_tfp_csum_profiles {
diff --git a/drivers/infiniband/hw/ionic/ionic_ibdev.c b/drivers/infiniband/hw/ionic/ionic_ibdev.c
index 3187f6297946..b45d128a5b51 100644
--- a/drivers/infiniband/hw/ionic/ionic_ibdev.c
+++ b/drivers/infiniband/hw/ionic/ionic_ibdev.c
@@ -318,6 +318,8 @@ static void ionic_destroy_ibdev(struct ionic_ibdev *dev)
 	xa_destroy(&dev->qp_tbl);
 	WARN_ON(!xa_empty(&dev->cq_tbl));
 	xa_destroy(&dev->cq_tbl);
+	WARN_ON(!xa_empty(&dev->srq_tbl));
+	xa_destroy(&dev->srq_tbl);
 	ib_dealloc_device(&dev->ibdev);
 }
 
@@ -336,6 +338,7 @@ static struct ionic_ibdev *ionic_create_ibdev(struct ionic_aux_dev *ionic_adev)
 
 	xa_init_flags(&dev->qp_tbl, GFP_ATOMIC);
 	xa_init_flags(&dev->cq_tbl, GFP_ATOMIC);
+	xa_init_flags(&dev->srq_tbl, XA_FLAGS_LOCK_IRQ);
 
 	ionic_init_resids(dev);
 
@@ -388,6 +391,7 @@ static struct ionic_ibdev *ionic_create_ibdev(struct ionic_aux_dev *ionic_adev)
 	ionic_destroy_resids(dev);
 	xa_destroy(&dev->qp_tbl);
 	xa_destroy(&dev->cq_tbl);
+	xa_destroy(&dev->srq_tbl);
 	ib_dealloc_device(&dev->ibdev);
 
 	return ERR_PTR(rc);
diff --git a/drivers/infiniband/hw/ionic/ionic_ibdev.h b/drivers/infiniband/hw/ionic/ionic_ibdev.h
index 3ee7416427fd..f8d580dd4d95 100644
--- a/drivers/infiniband/hw/ionic/ionic_ibdev.h
+++ b/drivers/infiniband/hw/ionic/ionic_ibdev.h
@@ -92,6 +92,7 @@ struct ionic_ibdev {
 
 	struct xarray		qp_tbl;
 	struct xarray		cq_tbl;
+	struct xarray		srq_tbl;
 
 	struct ionic_resid_bits	inuse_dbid;
 	struct ionic_resid_bits	inuse_pdid;
@@ -270,6 +271,8 @@ struct ionic_rq {
 struct ionic_srq {
 	struct ib_srq		ibsrq;
 	struct ionic_rq		rq;
+	struct kref		kref;
+	struct completion	rel_comp;
 	u16			srq_limit;
 	u8			udma_idx;
 };
@@ -466,6 +469,13 @@ static inline bool ionic_fw_has_qid_alloc(struct ionic_ibdev *dev,
 	return dev->lif_cfg.alloc_qid_cap & qtype;
 }
 
+static inline void ionic_srq_complete(struct kref *kref)
+{
+	struct ionic_srq *srq = container_of(kref, struct ionic_srq, kref);
+
+	complete(&srq->rel_comp);
+}
+
 /* ionic_admin.c */
 extern struct workqueue_struct *ionic_evt_workq;
 void ionic_admin_post(struct ionic_ibdev *dev, struct ionic_admin_wr *wr);
-- 
2.43.0

