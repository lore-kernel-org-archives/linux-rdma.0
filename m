Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012044.outbound.protection.outlook.com [40.107.209.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCEA51FCC2;
	Tue,  8 Sep 2026 09:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788858587; cv=fail; b=WPA6OqdGDa8SS1UWkrxHW0AUutS/nRzCaQRlPTDvnYIXb/C1GTdzhXjRyp/Hl+GLhAoDDbp2Bg/4fU++ME20Kk3tK5iGJczABDvQOn3Dq/tI408KWOm3YNHKmIDF1847ug0SN9VycGcLyEEhsHzzmecWTdq7/GaPRKfaVh1uDfc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788858587; c=relaxed/simple;
	bh=jJeF8ICc6z7Gsh7uw2aWjpIObGB28mVVEqr+P70hpwU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZjWBICot4r4l+iwcHxi/AF2hZ7O1TdlwRc1gtQCBWFDVO4bh9l0CYSTO/JhHFVKPwaysAZngrmZaaHw+bqUmhfmP4FuEEkQK/aP2nKkC/Q/kE/yB2iKnHFfa2T5Fz5wquXslndjlUVjiFmyPaHwWfIYp2VCWBf7stjY+BggWEzc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Z3qnQpxs; arc=fail smtp.client-ip=40.107.209.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Z3qnQpxs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pc5dlF3ht1PR8G7QVCSKhbX/Pn4L1a4cBKZQOtCVCUhQCq6EjuyC4leiJqPQeyLzwC69nY8rZBGfeET1fzh7I+oWEaBXpY7O4WK9YUo4p626MuClIQ6APgNNX7ohQHF7vsKsUtyXIXvUI+0lUACs6eGsN/m8d6yXMZsQCYSYwTVr1lqmBkFDVyvLsw+pI6QCUcDLj3F6Fg/yUKpwKG1GWDGcOhx+5KzcdTC8BI7+r8NaEwgPOy+s/rXHDIHgLu3o10ddJMOCOofY6ru3DRK2jD8RiAeNlfiT32S2yCW/yqIjZXJY69jeE9Jnb0i3EBKAFCBzSvvatyDzU04O4X812g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m05JoDdqvszSg0FhJ79lY5079/L1DHuISdqb4C5nupI=;
 b=yuUdnO9oLX5YNDS86RXGyHuifpfCTkEv0CxdwPTTb9zEMtz2EO99+zScuAKp5Vl/kcKBmlyAGxaeP8I2864pEnr/9+Rinpa9j8gKfjYjqXsGcRihTanhhK3MKSmKqr0v93Kq1FCtIwAM47YTTBrjImEGF58w4MoQk/XxVMsqN4eT9z8TOjQp6oKdFlz6iI3rJPJuo5rLbGMyRPUUA9XMly8EBtDoIlIRz1mvpAYHPPrn/G/BZk8YPTYBKSF2fFo/JYadfDE2AsgjOEK2vwO7wCS04YfRYi3/46xwGolfCrPc7TUSll7eQytUUqbRtSIMXPqdkiEQG1efVPkxOdEqww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m05JoDdqvszSg0FhJ79lY5079/L1DHuISdqb4C5nupI=;
 b=Z3qnQpxsv9jNUqZjltD+o1Slk0t6TleFouQ2Zp2sctZ6t3q3kMFMlAuPtBpEIv521owIB9rkoSK3aiEmnu8HJ4hh2mPxDEXqS43K5SN2YaSJw0C1ggWckGqEbAdPlIUgNLtL/1cPTkgVCfeuz/Ptzsj29io+36eyEtOi0PE88ck=
Received: from BN1PR13CA0014.namprd13.prod.outlook.com (2603:10b6:408:e2::19)
 by IA1PR12MB8223.namprd12.prod.outlook.com (2603:10b6:208:3f3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 09:09:37 +0000
Received: from BN1PEPF0000468C.namprd05.prod.outlook.com
 (2603:10b6:408:e2:cafe::8d) by BN1PR13CA0014.outlook.office365.com
 (2603:10b6:408:e2::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.6 via Frontend Transport; Tue, 8
 Sep 2026 09:09:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN1PEPF0000468C.mail.protection.outlook.com (10.167.243.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Tue, 8 Sep 2026 09:09:37 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 04:09:37 -0500
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.46 via Frontend
 Transport; Tue, 8 Sep 2026 04:09:33 -0500
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <brett.creeley@amd.com>,
	<andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <allen.hubbe@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Amit Kumar <a.k@amd.com>, Abhijit Gangurde
	<abhijit.gangurde@amd.com>
Subject: [for-next v1 5/5] RDMA/ionic: implement SRQ event handling support
Date: Tue, 8 Sep 2026 14:38:01 +0530
Message-ID: <20260908090802.152142-6-abhijit.gangurde@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260908090802.152142-1-abhijit.gangurde@amd.com>
References: <20260908090802.152142-1-abhijit.gangurde@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468C:EE_|IA1PR12MB8223:EE_
X-MS-Office365-Filtering-Correlation-Id: 700eb743-c315-4137-d223-08df0d88e886
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|7416014|376014|23010399003|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Afu3K6PIbSp4D16zh0ygOCdqTBz+MeAUw4nWJxpmnjlc3Edt79VLfuhKC095ZpA4I7sBpm7lKkbTJYJzuV3MOljv8OR5404oX4ysD9ATUgD8tXPb73Urs99r4hZzFzZx+l4OzNOXEhdnGekHKnOH8Wl/4VdVeCbCs8i12DyfJB7SC2sYBAfRAwhhAi0sYJCE7zmk7KkO2YqRq/2yqNYIJyb3SJd/kqMAIua7V7q4c1si1qRdKyXJa1YEU4jAf+B3o0UuWTKvWWXOKCXO5o05ktaOUUFOGI2fro48e9lx38jz6fBDtQICZoVomLpoiV57rL8a6QNMZbl0AA+zksw0A2KHtrVqFq630Pb08swCTPrAKozboszLOY2iWoRrrO+fyhZn2VG9zxx1W7QMVjfQwXePDqjSLNG43CTZ96bg6PP7y7p0HxTmyaAYO4Y73OGiDk1Phve8aWPxm5TXnmx8gcl/vUd1kIkGlrT8F8mbhAUePMifCHRVHswJc9b/xX8h7hkwuhiMVw2KIIZMB0r/QiVWu/UdOEBQl/Aznos2ffpl3dZvqohJjOVMhdSgjZyDcPmA+oB294XnArXpEnZYjvUfJ3JoQqDaXN5ivgp0HGZaljMkzVZJcH5mKQ6fYzenF4VDmtMK5QZrxmsZwqIdIHYxfeW8mekYXTFxQHum+o12PZYPCP9M9LoPlrPQMemtCbl1C8+KRi4PKveacKNSUw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(7416014)(376014)(23010399003)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Zd9Btj27ANmZzEXKQT/cZcsVCvw0nI7VrIfwwGbAFoGfUhjj7tUDyR3HHJ273O22l7+Rm7U6Sd957UibdcuLpoJX5iLkc+Y7ouz+UIcB9jgzgAdr7u5WFGb3G9bP1OrJ1k48y2gJTM02x2Jj0u8V4VkGvZkXckXum+tE/g9uXlVG2ZtKeyvWLTTrMiyCzAyG5b3L13DB2Nv09V5qWcMEIBF0QhzFxMOZlRF9FDQcNM5N5RcA/Es2m/aZcz21KQkY+1h1bx82FtIJFnrAYfbGpX6XtwkJQHgSeSiOSHUUKkQJSFLugNRvfiIqizq1KXKV/Gae9b+jgqjIqVVQ8g476KTUeTzYXarS4Pa9+sYqzXpW661gIL0orMCYtLHz2mj155L3vgY3310IqrX2CypIA4vbI22YwR7rexX/LKm2lC+NOKblimsCunqrgYkExx5E
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 09:09:37.7347
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 700eb743-c315-4137-d223-08df0d88e886
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468C.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8223

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
index cda48c36c047..4c76bc82e580 100644
--- a/drivers/infiniband/hw/ionic/ionic_admin.c
+++ b/drivers/infiniband/hw/ionic/ionic_admin.c
@@ -945,6 +945,49 @@ static void ionic_qp_event(struct ionic_ibdev *dev, u32 qpid, u8 code)
 	kref_put(&qp->qp_kref, ionic_qp_complete);
 }
 
+static void ionic_srq_event(struct ionic_ibdev *dev, u32 srqid, u8 code)
+{
+	struct ionic_srq *srq;
+	struct ib_event ibev;
+	unsigned long irqflags;
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
index 6979e0c5a25c..de1b8aa1815c 100644
--- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
+++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
@@ -3056,6 +3056,13 @@ int ionic_create_srq(struct ib_srq *ibsrq, struct ib_srq_init_attr *attr,
 			goto err_resp;
 	}
 
+	kref_init(&srq->kref);
+	init_completion(&srq->rel_comp);
+
+	rc = xa_insert_irq(&dev->srq_tbl, srq->rq.qid, srq, GFP_KERNEL);
+	if (rc)
+		goto err_resp;
+
 	ionic_pgtbl_unbuf(dev, &buf);
 	attr->attr.max_wr = srq->rq.q.mask;
 
@@ -3080,6 +3087,11 @@ int ionic_destroy_srq(struct ib_srq *ibsrq, struct ib_udata *udata)
 	struct ionic_srq *srq = to_ionic_srq(ibsrq);
 	int rc;
 
+	xa_erase_irq(&dev->srq_tbl, srq->rq.qid);
+
+	kref_put(&srq->kref, ionic_srq_complete);
+	wait_for_completion(&srq->rel_comp);
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
index 3187f6297946..b0206d34b6dc 100644
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
+	xa_init_flags(&dev->srq_tbl, GFP_ATOMIC);
 
 	ionic_init_resids(dev);
 
@@ -388,6 +391,7 @@ static struct ionic_ibdev *ionic_create_ibdev(struct ionic_aux_dev *ionic_adev)
 	ionic_destroy_resids(dev);
 	xa_destroy(&dev->qp_tbl);
 	xa_destroy(&dev->cq_tbl);
+	xa_destroy(&dev->srq_tbl);
 	ib_dealloc_device(&dev->ibdev);
 
 	return ERR_PTR(rc);
diff --git a/drivers/infiniband/hw/ionic/ionic_ibdev.h b/drivers/infiniband/hw/ionic/ionic_ibdev.h
index acc0382f2023..bab15b57d2bb 100644
--- a/drivers/infiniband/hw/ionic/ionic_ibdev.h
+++ b/drivers/infiniband/hw/ionic/ionic_ibdev.h
@@ -92,6 +92,7 @@ struct ionic_ibdev {
 
 	struct xarray		qp_tbl;
 	struct xarray		cq_tbl;
+	struct xarray		srq_tbl;
 
 	struct ionic_resid_bits	inuse_dbid;
 	struct ionic_resid_bits	inuse_pdid;
@@ -272,6 +273,8 @@ struct ionic_rq {
 struct ionic_srq {
 	struct ib_srq		ibsrq;
 	struct ionic_rq		rq;
+	struct kref		kref;
+	struct completion	rel_comp;
 	u16			srq_limit;
 	u8			udma_idx;
 };
@@ -469,6 +472,13 @@ static inline bool ionic_fw_has_qid_alloc(struct ionic_ibdev *dev,
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

