Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013042.outbound.protection.outlook.com [40.107.201.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67913BFE4C;
	Wed, 30 Sep 2026 09:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790760140; cv=fail; b=B/iJA7PXyNftI2PTIx3OUlljGzDn9icc3HNyigEankWBE/cWY56uEIsEpU25Up0jFO/5rM+/xvIUH56w/N1aSR7pUlKvGtn/HcFEINglC0L01dfvmTynudFKmvWc9nlIM8MhIIgGiEu1i9QSGIMUn0Ljr+C2uIl2p5b/N61Fbao=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790760140; c=relaxed/simple;
	bh=lpS4eTSjMbU+uY8EZKO4o6UVyObCQEZ7xcx1uo1NY3w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U1bpsEoZZSsMhS3A2hg4Kl4SNMw4AyhQmg0MYqxCskgO4u35xveX5d7QG0RJ9h2u4lTWSmrTnCCNCZtgg9t4Kjq7eAV9YtxZYMUEJg8X/O2/f6YumuHkErtX0uG0YllbLbvDDmm+VxELwgJZO83xNYt1CSEkrPFKYOb/P1wpABE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2+WRkB86; arc=fail smtp.client-ip=40.107.201.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2+WRkB86"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PmKPbkT3tE8jpQTw4o73vnLPBnsftqfyrfYlJ7Nnaf+BpfHk8hQ7PXZ5M1DPbYbfzTcjoJiO56r7sL8pHkwcj8zkh9rYtlFy+lchPS4P/PagErXBbUvtrEzAs4J1+gdAtA1yuxL5Y8rMJ8jNsuLliT7BQQjvL37Pw+OpcC64Eji8a8NEQmPQMs/KmayyHeAJNuy1J7wxEQ7uWtRbVHPQTiNhAQOJGvFlZ94tz+gvpTyo8gkc3gKQVI2f/npauu1jZ7Yz0hJgqqqIcf7LfJkoPcq5LrT3oxuKoiOl1X+XhSXl9ndHFE6F8z5CqODi8yKOEbzfhZgIGT9fXZL1xrmWag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mCLtcCAQU2dlMh9QOei0MN/KtTcj55VDdgCe5XrFPrU=;
 b=x5H6Aw9Wcs25Coa8t5hJbZrccPa4N+RZOb8X+AHKQz/imDRh/bGyXCRPjoDc9m+HiO6wAI6A6DM4JHmaLWL0ASrMR2eeWuwyr2mhwmhyk+ganYhEdnfpkXXSiMAtdAyDb2S8dGCoXFDWVcOkSIZv4DrywkmQnvt4RBAuo4iS111oABZzdn3dN4Dy0NugBSPkUoqWtlX+syrSekdq2AyySEStfUidAVuAGAdHardV/wRp68Xwf/WKV5GSnoQQGU1U8TQFli52TTG9oNeaB/FCO0tEKJMjIbMCpgFdNfbSixcQSpbWO0wLGIsBKei7tBs9XWMgWYy+v0uEh8SByXVWyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mCLtcCAQU2dlMh9QOei0MN/KtTcj55VDdgCe5XrFPrU=;
 b=2+WRkB86viNv9hyImMzCSRlmj9hPNzDi84P6nRqRCKSPPfuaFFn6TVQ2+w2h+kYWNZCyL66TO7nt/wiuvfxGB/lEIbUTVvSWls0FKZfo7zXCnYCxjZNO9H7t+ToOUxy4A3YxXTbImPTgYuJYMFZPg91re3ksBmaTNnTr5MXbsoI=
Received: from SJ0PR05CA0186.namprd05.prod.outlook.com (2603:10b6:a03:330::11)
 by MN2PR12MB4062.namprd12.prod.outlook.com (2603:10b6:208:1d0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Wed, 30 Sep
 2026 09:22:12 +0000
Received: from MW1PEPF00016159.namprd21.prod.outlook.com
 (2603:10b6:a03:330:cafe::54) by SJ0PR05CA0186.outlook.office365.com
 (2603:10b6:a03:330::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.11 via Frontend Transport; Wed,
 30 Sep 2026 09:22:12 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 MW1PEPF00016159.mail.protection.outlook.com (10.167.249.84) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.3 via Frontend Transport; Wed, 30 Sep 2026 09:22:12 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 30 Sep
 2026 04:21:52 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 30 Sep
 2026 04:21:52 -0500
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Wed, 30 Sep 2026 04:21:48 -0500
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <brett.creeley@amd.com>,
	<andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <allen.hubbe@amd.com>, <a.k@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Abhijit Gangurde <abhijit.gangurde@amd.com>
Subject: [for-next v4 5/5] RDMA/ionic: implement SRQ event handling support
Date: Wed, 30 Sep 2026 14:51:11 +0530
Message-ID: <20260930092111.3176738-6-abhijit.gangurde@amd.com>
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
X-MS-TrafficTypeDiagnostic: MW1PEPF00016159:EE_|MN2PR12MB4062:EE_
X-MS-Office365-Filtering-Correlation-Id: eb5d1d2d-6de7-4441-b114-08df1ed44f49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|82310400026|36860700016|18002099003|22082099003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	WYDrBVDJmuKGrJJoLLU6v41qeZW1IQXbP6TKE7PYDw0wFeyyPhza7Bjp0lFPt0qjLcJ4QjHarBmHbF1t599b7DLItHox6tV6G6MwpyQiSkJ1nbZTNYTKxX4lVHIXJoXDzaUk63LjUlthNgnJzVA6Sl+aE0AP11EHnQg159Sw4kNoCIcybNVVvtQQuV+6tQ1l/NL8zIlPJY96pBLEEqjL49/1PM9Jjv2uCafcDdpy8fMdU+oMxbDpK6Ix/XddvINIFa1rSzolClqrJ3NPFcRD0j1a6LPG8e5ZOhg9VLjOO6Z6B7bUgtyKEeTCZOfw5giVYb5FgGslwscIez5oAAkGOlNw3XM0T1m/XfXkBxVrpWm3em0IZ8l7QT66QNbgJzAwYAaD4RkORTH+Wma/tyZp6O0rDlYkPat/Az80pffM1g5jm7IjDYj1tFig+C3Lejz0NRdfr+gr3W7GA3YrD6T1JI2isMWarR2miGKj7Q1fzMUVeTD9qaEr6mdvuacAPiokIWydKdF8M18T6MjPrMAU9gFAH9B/FjU9rsw1JPtJylkXVfJK23LHHAesPgMok11lYyEABxDFaL78Po97fbHW9HGpQ/z317djRNG5VaRscCM5nzFjgycm1icyXGyPSs4o7g2Pel9jmEXMhxWqXS/oN4/O4Ad9fMr5pq0FbqlWePOEwtFgcqoJyXguafIZOvUcIxnGG56zQB1zrk8PpAICvg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(82310400026)(36860700016)(18002099003)(22082099003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	WWAo6XnKmDIsDQX+BtXs/KqKrBVz+U79pa+4PoryUZv02iyRvnL98pa0pDW4JzslAYsbe7ZfUgjGsrIUs31MeJaXdOEfFhWeUJ7zkNpeEpbpMbM5mVufAyj9QLwUMmPbHO0iKDYMrndc7q5mMYyiGtsd0QZUx5UDmcPi4zhC6RqaTy+VGIh6ArIqjlvzsvTTOyH9s3Wupv02lAZki62VSNWoMy2UE4ZhkGnRl54jRfmKOSPabS2lNuol220sPrISeaJf0VkSFp44XQHVxzFg62IMvGDFN2TWIjL1PbR9v0W3R3HfJILDRLTHU/fPWNTqwrsOaLj5spD5lRrCucEDGLf9Mnrb+gB6i91MRYpACxZcbb4EQJm/408iOF1tEq2K7LCxLh/TWhZsLP/46yjfY5bk6bcu6AKFmpjgHUWNbkg9StaOKvr7KT68jRjA0XDz
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 09:22:12.0716
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eb5d1d2d-6de7-4441-b114-08df1ed44f49
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MW1PEPF00016159.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4062

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
index 3e7354361e40..18ad967812f5 100644
--- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
+++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
@@ -3058,6 +3058,13 @@ int ionic_create_srq(struct ib_srq *ibsrq, struct ib_srq_init_attr *attr,
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
@@ -3081,6 +3088,11 @@ int ionic_destroy_srq(struct ib_srq *ibsrq, struct ib_udata *udata)
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
index 8a43ae9451ec..b4d4544bb7ac 100644
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
 
 	xa_init_flags(&dev->qp_tbl, XA_FLAGS_LOCK_IRQ);
 	xa_init_flags(&dev->cq_tbl, XA_FLAGS_LOCK_IRQ);
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

