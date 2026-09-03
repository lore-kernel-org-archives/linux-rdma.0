Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11020125.outbound.protection.outlook.com [52.101.85.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9E74FDE55
	for <linux-rdma@vger.kernel.org>; Thu,  3 Sep 2026 17:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.125
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788458193; cv=fail; b=YZH0Zsmu7dX3fob5kWDV9PzpF2XxsMG+4h5tH+Ko0bBJzI96YmUEUY6qgdg5a1fHGvtW6UB3UAORE6hP6u4nyDDPPWwAeC3BTpiP12Gf3zdTlDPYFffewTgZ94lw1n8qurJzKJAIwXrMlX2ZRllBy/f/dPAeqzf2iUHQ3dThmBo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788458193; c=relaxed/simple;
	bh=xyDMrQhDBGIxERd7X0ScGlAf9OxUnCZEYP82fv9Rk7o=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tXW6DWF4gfFp9E2sDwdc+vUSAeplWDkiZ7D8sonDlz7VZ0QCA+8qacGlVPxdxtoV5O+XHHc/FS70NQsenHZmCgdHI7jCiwU/4hvZeUsPECIRzO+DlS9oZEl1vez/oscYJrMSl81AS2JmmbBljyfptMQyoo0xefcixlB6jfhJDno=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com; spf=pass smtp.mailfrom=cornelisnetworks.com; dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b=V/nOjGKr; arc=fail smtp.client-ip=52.101.85.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b="V/nOjGKr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JSEUFXSK5S6vQWe+m6RUM21XZ36Xy6lgFkfgmeFjEae63vfFIBhw+ZeI6ieIqNE0yJgux4OZjJ7S636Ph+g0jxCBCvBS7otk1OAJylwkJdcoElGSWy5uFVkVgqYPcwpqSV6afazqj6ufOt/gsydameyzNIfxm5QY+sTtIi1/FX1h3VVO5vnBcEptPp+F+rQsKg4oDaa3pNfbGx4F/JtUbOZmRBMZWFMgWiDtHCFIiAmk2GJvGqyc51lBhsmafQj4Xj3XMUMKK5OZvowCGd9AG7TwTHxOKQvPvwjQaD8dbL/EDbNq1yB+CH1+0y8UgXuEy9KBsgdruFR4No6Aetq/yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=van1UOpeF14kaaNdJsZSzklFi24tWxCAXHczZQFvXJ4=;
 b=S1Xu1+gRVSCTsGeDxZ+DRYnHd9hfFun/4Nt0uYkrbr4N3gTWltSmdw0rp7OPllJAp8Y0pFwrK11EBW1uvLAlnOaT0ssEGZHlZn0YcZ+3gFb1tidrIjMUrN/FOLy1hHOIdbT8pER1XpV58aETRyr71sY0YXUIKAwvsodEs1ms8/5lsn/anlngXSlNBOWoDjG+1hJ9lH0Df4EXWRs4+vgeJnTCG1HDg5YIriz/X49vqIuiO6p2uVfxB/8I9ivpiTcmQ+SCQ8eqYNLFKdAwOCLUkAgqkiBCsqsSKNnVL9i68UDFlBQOAcEa2I72v/QLImd5AxY+LIDE9C73zWHOe0e/9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 208.255.156.42) smtp.rcpttodomain=kernel.org
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass (p=none sp=none pct=100)
 action=none header.from=cornelisnetworks.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=van1UOpeF14kaaNdJsZSzklFi24tWxCAXHczZQFvXJ4=;
 b=V/nOjGKruO5KBoWZss8EEdcsxEUozmHHLJBV0oJfnGjHGaadJGaAiGEIyJr1a/6mLC4dZ9X6hQxyQJUx+qHzkoiFdYLgSXiz/fWaxys/RElkKYXdHS0YgGYtASmlfOm3zlPLJj0R1hoO8tN9d/TbCpwu25nL9zSGAx3JkzzNa7OjZDbMoqpY8uM1xznnFwN212T1kFSD84OagfYATCJ0b8jI3rhcnuXke155l9vmA6g2mCpaNjSs9eJ/kAw+VzOwvB7vkfoyD38DvdEEbQatx++/WOzUkkU57r6qmR/RKaqGZ9ygRjqCm8iWZM0nls8f692oRx248xQgDKrdtFmz4A==
Received: from PH8PR05CA0004.namprd05.prod.outlook.com (2603:10b6:510:2cc::23)
 by CY2PR01MB071609.prod.exchangelabs.com (2603:10b6:930:110::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Thu, 3 Sep
 2026 17:56:25 +0000
Received: from CY4PEPF0000EDD4.namprd03.prod.outlook.com
 (2603:10b6:510:2cc:cafe::4) by PH8PR05CA0004.outlook.office365.com
 (2603:10b6:510:2cc::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.11 via Frontend Transport; Thu, 3
 Sep 2026 17:56:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 208.255.156.42)
 smtp.mailfrom=cornelisnetworks.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=cornelisnetworks.com;
Received-SPF: Pass (protection.outlook.com: domain of cornelisnetworks.com
 designates 208.255.156.42 as permitted sender)
 receiver=protection.outlook.com; client-ip=208.255.156.42;
 helo=cn-mailer-00.localdomain; pr=C
Received: from cn-mailer-00.localdomain (208.255.156.42) by
 CY4PEPF0000EDD4.mail.protection.outlook.com (10.167.241.200) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Thu, 3 Sep 2026 17:56:24 +0000
Received: from awdrv-04.localdomain (unknown [10.228.212.218])
	by cn-mailer-00.localdomain (Postfix) with ESMTPS id AD62D1FA26E;
	Thu,  3 Sep 2026 13:56:23 -0400 (EDT)
Received: from [10.228.212.218] (localhost [IPv6:::1])
	by awdrv-04.localdomain (Postfix) with ESMTP id A862218129B23;
	Thu,  3 Sep 2026 13:56:23 -0400 (EDT)
Subject: [PATCH v5 for-next 23/24] RDMA/hfi2: Modernize mmap to use
 rdma_user_mmap_entry infrastructure
From: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
To: jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org
Date: Thu, 03 Sep 2026 13:56:23 -0400
Message-ID: <178845818365.2825126.5778335924102181775.stgit@awdrv-04>
In-Reply-To: <178845806706.2825126.2210865708266527909.stgit@awdrv-04>
References: <178845806706.2825126.2210865708266527909.stgit@awdrv-04>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD4:EE_|CY2PR01MB071609:EE_
X-MS-Office365-Filtering-Correlation-Id: a041f6ea-c8a2-46b5-c03c-08df09e4ab80
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|376014|82310400026|23010399003|3023799007|10067099003|56012099006|55112099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	MaekNZfHDz0evjANbYR31sluT4puscr6PcFBCUJ7zF896bvG1aP1+5mD2VatnViXgQ9QMkxF1xd/92bbVvZLB2LpvfP5g+KZYqdhwBBYNevLQh3yy0BTVwL/dmVOGLcLoH7Y24iUgtbgZY5a5TUAb1sFuIhMNkCkEz9uUhMTdtXenFe/AhlyMUvgbO7EwSEU9csZNgXSMGwQ7s0t06dno5vOitw0XIWAiexORBYEl6bzZLCBUgnhZjryW8NLAbiv7YCSvecF6SsWpbiY3HsAa4VsU558dc+LAHOc/q/h1/hgz14VJ4VtJMA/FzqOdzft68sL/2CoZwwOBwguNlkjo7GLZKQ4e8BxBaSkO7g2/1bKSMwxtTGn1Gfkxe8rGEd/BtjYcsKh1cX3o7q01NhgbRO9wB4P4LI4wfQ8/r8rkRTJEQYUqocW+wJEVczF04+4v8YEqCW2835kZ+GW4oT3n/VRkqi1uOeV7VL6ek0tirUxWTv1Jj5oQGluj58hRkeTALb/c3N9ekuAuwO+mXtf1eCo1aN74yr6pKIv4it7CrANq4D7AdaebkwZRLq/Zi9BtgQ+Xs8iWqiKIOaKdbaKmxTObcEC1dInhsvANsSwWu18OHCG9ilSbeMNfAaK4t2n6sH6ZY15bR2/jkli/f25Bl3QYtyfppgKQBLnEh47tEZzGEzRpmGYsnUyFIiPc3ju8DP8YKKCaYYcoHVkKNYbcA==
X-Forefront-Antispam-Report:
	CIP:208.255.156.42;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:cn-mailer-00.localdomain;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(376014)(82310400026)(23010399003)(3023799007)(10067099003)(56012099006)(55112099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	hxEKHsceNXBoG1TzoyPvWblWcyU8JX2u6nOr64CQnZ9W4QVfR/XrBZqkvreWpnqvcFodg5MyfMlJkOJBpZ3an1XW7gbv8nxv8cqDnR6pEd/qvwSvy/xGw+XHEbL5YqJDI1xRXUfGYlgB8r0CBgQRUkP6e7LdJSaLRF4XcGWm8/qx+YaFazhPR3QUxv6JVKEjaOzqDKGPZZ7ul2Ka+XAaU8NsNM+XsCb26SgBolv0TAQKyKXr1aOW7tzQ1lwCN4Jde+3Gs9pwRX26AilI92Y+z9z0xbAS6hxVgiVSV6ZX2uUMPk7Be/OXyhe5B0u9wo6FGP3R5QZo9bMQnKtmISaIUbh+sC2TmYZrvRC7ZZynVQc2Qrmz+nfaW1NqoplmcCmDXP5dn3VWOPfuLjZ+fBP9FdPeGRUYSsf0fgIgJMBIVgkShyT+65ygfN9fhUH+Vx9l
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 17:56:24.2858
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a041f6ea-c8a2-46b5-c03c-08df09e4ab80
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a;Ip=[208.255.156.42];Helo=[cn-mailer-00.localdomain]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY2PR01MB071609

New RDMA drivers are required to use the rdma_user_mmap_entry API
instead of encoding buffer types directly into vm_pgoff tokens. Add
the mmap_entries array to hfi2_filedata to track per-context mmap
entry pointers for cleanup on context teardown. Export rvt_mmap()
from rdmavt so hfi2 can call it as a fallback for CQ/QP/SRQ mmaps
managed by rdmavt's pending_mmaps list. Also remove the dead
hfi1_tid_info struct from the hfi2 ABI header.

Assisted-by: LLM
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
---
  Changes since v2:
  - rdmavt/cq.c: add synchronize_rcu() before vfree(old_u_wc) and
    vfree(old_k_wc) in rvt_resize_cq() to close free-while-mapped race.
  - rdmavt/srq.c: add synchronize_rcu() before vfree(owq) and
    kvfree(okwq) in rvt_modify_srq() to close free-while-mapped race.
---
 drivers/infiniband/hw/hfi2/hfi2.h   |    6 ++++++
 drivers/infiniband/sw/rdmavt/cq.c   |    9 +++++----
 drivers/infiniband/sw/rdmavt/mmap.c |    7 +++----
 drivers/infiniband/sw/rdmavt/srq.c  |   20 +++++++++-----------
 include/uapi/rdma/hfi2-abi.h        |   11 -----------
 5 files changed, 23 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/hw/hfi2/hfi2.h b/drivers/infiniband/hw/hfi2/hfi2.h
index 8ac895c29612..0939c45e51f3 100644
--- a/drivers/infiniband/hw/hfi2/hfi2.h
+++ b/drivers/infiniband/hw/hfi2/hfi2.h
@@ -1284,6 +1284,12 @@ struct chip_params {
 	u32 csr_err_mask_reg;
 	u32 csr_err_clear_reg;
 
+	/*
+	 * Chip-variant operation callbacks. Function pointers are used here
+	 * to abstract differences between chip variants (e.g. JKR and future
+	 * generations). Each variant populates its own chip_params instance
+	 * with the appropriate implementations at driver init time.
+	 */
 	void (*hfi2_setextled)(struct hfi2_pportdata *ppd, u32 on);
 	void (*start_led_override)(struct hfi2_pportdata *ppd,
 				   unsigned int timeon, unsigned int timeoff);
diff --git a/drivers/infiniband/sw/rdmavt/cq.c b/drivers/infiniband/sw/rdmavt/cq.c
index 45404611c9ce..be0293434f27 100644
--- a/drivers/infiniband/sw/rdmavt/cq.c
+++ b/drivers/infiniband/sw/rdmavt/cq.c
@@ -318,7 +318,7 @@ int rvt_req_notify_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags notify_flags)
 	if (notify_flags & IB_CQ_REPORT_MISSED_EVENTS) {
 		if (cq->queue) {
 			if (RDMA_READ_UAPI_ATOMIC(cq->queue->head) !=
-				RDMA_READ_UAPI_ATOMIC(cq->queue->tail))
+			    RDMA_READ_UAPI_ATOMIC(cq->queue->tail))
 				ret = 1;
 		} else {
 			if (cq->kqueue->head != cq->kqueue->tail)
@@ -426,6 +426,7 @@ int rvt_resize_cq(struct ib_cq *ibcq, unsigned int cqe, struct ib_udata *udata)
 	}
 	spin_unlock_irq(&cq->lock);
 
+	synchronize_rcu();
 	if (u_wc)
 		vfree(old_u_wc);
 	else
@@ -518,9 +519,9 @@ int rvt_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *entry)
  */
 int rvt_driver_cq_init(void)
 {
-	comp_vector_wq = alloc_workqueue("%s",
-					 WQ_HIGHPRI | WQ_CPU_INTENSIVE | WQ_PERCPU,
-					 0, "rdmavt_cq");
+	comp_vector_wq =
+		alloc_workqueue("%s", WQ_HIGHPRI | WQ_CPU_INTENSIVE | WQ_PERCPU,
+				0, "rdmavt_cq");
 	if (!comp_vector_wq)
 		return -ENOMEM;
 
diff --git a/drivers/infiniband/sw/rdmavt/mmap.c b/drivers/infiniband/sw/rdmavt/mmap.c
index 473f464f33fa..f0bd096f457c 100644
--- a/drivers/infiniband/sw/rdmavt/mmap.c
+++ b/drivers/infiniband/sw/rdmavt/mmap.c
@@ -32,8 +32,7 @@ void rvt_mmap_init(struct rvt_dev_info *rdi)
  */
 void rvt_release_mmap_info(struct kref *ref)
 {
-	struct rvt_mmap_info *ip =
-		container_of(ref, struct rvt_mmap_info, ref);
+	struct rvt_mmap_info *ip = container_of(ref, struct rvt_mmap_info, ref);
 	struct rvt_dev_info *rdi = ib_to_rvt(ip->context->device);
 
 	spin_lock_irq(&rdi->pending_lock);
@@ -91,8 +90,7 @@ int rvt_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 	 * CQ, QP, or SRQ is soon followed by a call to mmap().
 	 */
 	spin_lock_irq(&rdi->pending_lock);
-	list_for_each_entry_safe(ip, pp, &rdi->pending_mmaps,
-				 pending_mmaps) {
+	list_for_each_entry_safe(ip, pp, &rdi->pending_mmaps, pending_mmaps) {
 		/* Only the creator is allowed to mmap the object */
 		if (context != ip->context || (__u64)offset != ip->offset)
 			continue;
@@ -115,6 +113,7 @@ int rvt_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 done:
 	return ret;
 }
+EXPORT_SYMBOL(rvt_mmap);
 
 /**
  * rvt_create_mmap_info - allocate information for hfi1_mmap
diff --git a/drivers/infiniband/sw/rdmavt/srq.c b/drivers/infiniband/sw/rdmavt/srq.c
index d022aa56c5bf..e9ebe4035572 100644
--- a/drivers/infiniband/sw/rdmavt/srq.c
+++ b/drivers/infiniband/sw/rdmavt/srq.c
@@ -53,10 +53,9 @@ int rvt_create_srq(struct ib_srq *ibsrq, struct ib_srq_init_attr *srq_init_attr,
 	 */
 	srq->rq.size = srq_init_attr->attr.max_wr + 1;
 	srq->rq.max_sge = srq_init_attr->attr.max_sge;
-	sz = sizeof(struct ib_sge) * srq->rq.max_sge +
-		sizeof(struct rvt_rwqe);
-	if (rvt_alloc_rq(&srq->rq, srq->rq.size * sz,
-			 dev->dparms.node, udata)) {
+	sz = sizeof(struct ib_sge) * srq->rq.max_sge + sizeof(struct rvt_rwqe);
+	if (rvt_alloc_rq(&srq->rq, srq->rq.size * sz, dev->dparms.node,
+			 udata)) {
 		ret = -ENOMEM;
 		goto bail_srq;
 	}
@@ -122,8 +121,7 @@ int rvt_create_srq(struct ib_srq *ibsrq, struct ib_srq_init_attr *srq_init_attr,
  * Return: 0 on success
  */
 int rvt_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
-		   enum ib_srq_attr_mask attr_mask,
-		   struct ib_udata *udata)
+		   enum ib_srq_attr_mask attr_mask, struct ib_udata *udata)
 {
 	struct rvt_srq *srq = ibsrq_to_rvtsrq(ibsrq);
 	struct rvt_dev_info *dev = ib_to_rvt(ibsrq->device);
@@ -139,14 +137,13 @@ int rvt_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 
 		/* Check that the requested sizes are below the limits. */
 		if ((attr->max_wr > dev->dparms.props.max_srq_wr) ||
-		    ((attr_mask & IB_SRQ_LIMIT) ?
-		     attr->srq_limit : srq->limit) > attr->max_wr)
+		    ((attr_mask & IB_SRQ_LIMIT) ? attr->srq_limit :
+						  srq->limit) > attr->max_wr)
 			return -EINVAL;
 		sz = sizeof(struct rvt_rwqe) +
-			srq->rq.max_sge * sizeof(struct ib_sge);
+		     srq->rq.max_sge * sizeof(struct ib_sge);
 		size = attr->max_wr + 1;
-		if (rvt_alloc_rq(&tmp_rq, size * sz, dev->dparms.node,
-				 udata))
+		if (rvt_alloc_rq(&tmp_rq, size * sz, dev->dparms.node, udata))
 			return -ENOMEM;
 		/* Check that we can write the offset to mmap. */
 		if (udata && udata->inlen >= sizeof(__u64)) {
@@ -220,6 +217,7 @@ int rvt_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 			srq->limit = attr->srq_limit;
 		spin_unlock_irq(&srq->rq.kwq->c_lock);
 
+		synchronize_rcu();
 		vfree(owq);
 		kvfree(okwq);
 
diff --git a/include/uapi/rdma/hfi2-abi.h b/include/uapi/rdma/hfi2-abi.h
index 7b7ca198b539..5b5b619bf1a8 100644
--- a/include/uapi/rdma/hfi2-abi.h
+++ b/include/uapi/rdma/hfi2-abi.h
@@ -248,17 +248,6 @@ struct hfi2_ctxt_info {
 	__u16 sdma_ring_size; /* number of entries in SDMA request ring */
 };
 
-struct hfi1_tid_info {
-	/* virtual address of first page in transfer */
-	__aligned_u64 vaddr;
-	/* pointer to tid array. this array is big enough */
-	__aligned_u64 tidlist;
-	/* number of tids programmed by this request */
-	__u32 tidcnt;
-	/* length of transfer buffer programmed by this request */
-	__u32 length;
-};
-
 #define HFI2_TID_UPDATE_FLAGS_MEMINFO_MASK 0xfUL
 #define HFI2_TID_UPDATE_FLAGS_RESERVED_MASK \
 	(~(__u64)(HFI2_TID_UPDATE_FLAGS_MEMINFO_MASK))


