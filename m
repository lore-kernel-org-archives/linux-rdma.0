Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013024.outbound.protection.outlook.com [40.93.196.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2274756C4;
	Fri, 25 Sep 2026 08:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790324934; cv=fail; b=kSKOvuJvx6azB8YvHT+6oc4qla/K1gaAvjnh3LMziWDKw2P4ZGQenxEMGrOGGAbylVdDYApo6m4YOQYaiwb+79pv/47A+P0Oq1lAY5eqKsPDL7B+LzPqVCWKMijjsi1iGnx3RS36OwCbL/wND4fU2R1skICDlZiXTSUWS0KSO2Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790324934; c=relaxed/simple;
	bh=y6D7oN4wtzev0aF6Yj0eQ3hd872ASPrN/XrHsjYGbFk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HKtuPggZnj5SPR1+m7WHFU+b4P8aMmTlag2FaFTzRUEuwsEz5Dh+qY04LDFAPIbhPGdS9ZGCIzHjpqynIE/joY3tQiwH7YT5MfFC8Fuo/xoREE574P4oWwRtdUCKWdhaRolzfapNZDzpk6weYkitGssmibA7Eyi3yaiaoXTn72w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=w9gHakTI; arc=fail smtp.client-ip=40.93.196.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="w9gHakTI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NK4fCv8TTjnBSXiPzraL54OrWdbTlptEMWPAnxCmFiChb5NAPTfYs/e0+HcDLo3fq4n/9XqEO/WefzxKXCKADbfQAqb2loPwV3t6S6dc5KW3njF/cpwlLI47KzLXirLO5Vg4Gget6TqT3ZD7Hivwi6rxgKTXqTkIJLfsDSPu+8Y722ig1nxKT8foV51AlxEx3V81N27EZ9saoVLM8vDuZf10Kd3Xd4Wv2xfRXCPLDhPlWvBiY/FjhX9cRUicg/wcAj82A0/5MNXZp60d56Tg4c+HctgJVQ/sH80ItyH9jqIDw7PBg0wV0YehFsiVMXH8M2jYCfC1SyLYCJMV+gpSxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5dFK2G4b6HTj2YKfxYyKrIuR+uz4Ij3mnURblyQwzOE=;
 b=S1eGOH2f9AcTLMvyQ9+SEiaOX0CAAVhDfnJVmuggcZdI+ffhOpsQDKaKveE5Sy0JUfkxPQDdsq8KKkH0Q/s6/eq5DiZTHc0oyTDUqVkmD3+z5NhNZWi4gE98fwj7YP19yaKIK481v035HB4gvoZEpHYQl6c/1WJ9Y40CR8HfUCwWyo7fA+E1e3qr+MKTpndj9bairlbIFiugZQ7kWBxQ6nmAFI+01bb5X4eo+g1avYWbAODlI4qBDjI8sZuc5aRbgZlrKP1CbIpSOJZN2E1dbPLucUHanlOx7KEODWoimyHNqG6Xr0tPV2/wuRxdd0EcpgocRmZP8Cn3F8lknMAs+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5dFK2G4b6HTj2YKfxYyKrIuR+uz4Ij3mnURblyQwzOE=;
 b=w9gHakTIVniZ6pVaqFzz3e9R+y/LlzePSgL/QOCjWF7Z4AujlONGx+7o/nSuecOuEfWuRwGHoiaoErG35BRrpgG7Zio6PiDtB4LpavSA/tkBycit267MX2+rRxLpe31opxboyft+gCNmV/sXc64eCGSnGTll9bGYx+U4azATeM0=
Received: from BN9PR03CA0635.namprd03.prod.outlook.com (2603:10b6:408:13b::10)
 by DS2PR12MB9749.namprd12.prod.outlook.com (2603:10b6:8:2b9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Fri, 25 Sep
 2026 08:28:48 +0000
Received: from BN3PEPF00022BCB.namprd03.prod.outlook.com
 (2603:10b6:408:13b:cafe::11) by BN9PR03CA0635.outlook.office365.com
 (2603:10b6:408:13b::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.18 via Frontend Transport; Fri,
 25 Sep 2026 08:28:48 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF00022BCB.mail.protection.outlook.com (10.167.248.168) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Fri, 25 Sep 2026 08:28:48 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Fri, 25 Sep
 2026 03:28:48 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Fri, 25 Sep
 2026 03:28:47 -0500
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Fri, 25 Sep 2026 03:28:43 -0500
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <brett.creeley@amd.com>,
	<andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <allen.hubbe@amd.com>, <a.k@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Abhijit Gangurde <abhijit.gangurde@amd.com>
Subject: [for-next v3 5/5] RDMA/ionic: implement SRQ event handling support
Date: Fri, 25 Sep 2026 13:58:02 +0530
Message-ID: <20260925082802.2675902-6-abhijit.gangurde@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BCB:EE_|DS2PR12MB9749:EE_
X-MS-Office365-Filtering-Correlation-Id: 88222a5d-f71e-437a-5264-08df1adf05c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|1800799024|376014|36860700016|82310400026|56012099006|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	R1N68OKkKNGs6bGQzS2eHB36P1IpHCcxt8VEEQg8kC2ECH8k/GA8oHyZss8kzLx+jPuXqE1BFj/x6uVBL8gYtXkrsTHzf0IImPCPS0OhRgX+k+77c68BH1OC3fZ7y/XZGOikP6Mzd33O3EoGrwgwVuxMNtNt6/By+3CWVJCbNRXrPWBMmu0ll5JMNIG9l2ejo0AK8AlQearaj/4ACeqp56/nW5XSXpRP6CDVm0lrda5Z17tD3+BOG1LgJo4TWlWjqoNRDGB2w7rniehsjH1oIJwunRTAnelgdrq0Mk2x8sAoieuTvrPN5BLGkAydtrTUjbkEHzmPQt5vDC6XV7C4hmY+PePqBIcphon7FupGPwAWwLzX7P5szxwruzb9iadM6WxzbwqksRCeHESTxqtpOF4VO+/ChdvUGb8GT9PFkD88V7M5slite/G6tOKAtpjzRHKkp4YkYZPd2tEjkPn9OR4TwYhVhqXcbpw4KwTQekjwHDC3o/AEzJH3a+csFr5DyzFbpKWFlnrakE6NlhDyseqmrlsmuELVpbLSbKgbsc67rDTyl//P/4E/1wbgUzpfBvRnkaTH2IYj+ntnIbp29YOsZ/J98UCtBhE0JAMjY4RqHgyDKCaSsSS+s/r/Yaaz/gF5zLCYOhROO7mOaZsLl1U18BHD3/7iql2CDw/qZ/hPEbBhpY2k24C23AECR7jW1iwnHiJogMpIAcx8vFG+Tw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(1800799024)(376014)(36860700016)(82310400026)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	vWqrIoXSD5O2Yi6fYYzUxHvDDlPC276gKiX8sX2T68jRNkPd0v+s10agJm4QEJrVkSfBswzlGmgEkHhRqgFeX45ZjXXqJnqoxKcHiXPeGYTlhtK9FZ0Kwc6Q3l/P0HJAH5xvqGdFi+tvUZr2j7P6eTmzvAQyOpsMmSHVHvCc4Cj5Qcvjf+qmfWgn17klBCR657QKtqiAh75qmTD6EzpstWpwIyQT9sCpJxqLSq4hmmZNVrbgM95JVnD1r/ZlSrx143RIbGI+CwImwA9l5UlZPciGe9KSP8HnWDu/0fAb7Z4pno56HKgF6mmH3i3Q64VYFnjUiG6nt7tE/70Zq+nKnDKcW4ZdWR7NReAVZiqQaiHG9W0N3AbJVtfajVWpf4uHzs8zCSqphYjocE4LDNqanU2xi+raiSA6jsjsFeksZcqG1lKMS22Oo2mtpiFbe2UF
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2026 08:28:48.6262
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 88222a5d-f71e-437a-5264-08df1adf05c4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BCB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9749

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
index 93c01bd40d78..0ccd869ad8e6 100644
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
index fd15d9549ac0..bc0e2e255b8d 100644
--- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
+++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
@@ -3063,6 +3063,13 @@ int ionic_create_srq(struct ib_srq *ibsrq, struct ib_srq_init_attr *attr,
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
@@ -3086,6 +3093,11 @@ int ionic_destroy_srq(struct ib_srq *ibsrq, struct ib_udata *udata)
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
index a3991c34aece..1db67fcb9a53 100644
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

