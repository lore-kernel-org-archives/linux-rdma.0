Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794255936;
	b=i3mQNOArhbDRBzYq5sVWjdS8Guye1xCPSgJbIRnstAhoEWF1RQLAt8tE00P8vL8K9AcO
	 pmluEFVQk5Ah6Hgv0P1VWCqRqEuMC2M9vpdGb0OmueN37N2ep8OmcWQK3JPDvZXoyNBc1
	 t5FOVtvFEwTH7RP8FEF5zMI+QXQqfplSnlXJomRf5e4703/MgpR02GMCYbeEdQEGHx+qO
	 TYU8ZYEl4cLOj5ZZACExo99sK1GqsP1Srna/ueozhup33zdKVIdO6eKPUvhHEhz30mmbx
	 ka8bfYKujLhmIFIlko8w2fRJsXs4efTGMn6yGC5PDIRHb4KZMn2ilhBaGDPYjO9InuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794255936;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=wEJhH5f25270Pxnj7Xperdx9sXc5/sUb3+oN4IYfXTI=;
	b=Gji5GDdofAga2cdtcvI0gna6RUQYhhIRwa4VN+vp9yMjDl68CMVHWGB3D4jPgJC8weF0
	 RqTGeAo8JUMEiveg/usxnhavhDjaeq/hrWr3SC1eQLe6VGX23KgnFHx7s3bmsq0CBXSxJ
	 kGg+yBPP+uN0UfyvtyIbrVmn0QTavW/54kk1PcuhkTxaElFJRvEKKdbYmee4+UzNl+ST/
	 PGdBgIj9QOotmy/s9LBHcKCKTsulEZ3NURY/c4t7Qj3HUof/K2Klku/smW7pvYICqytq7
	 x86AzCL8qobJvtNsHzFahJFmEhJMYFXgZ4ivzZYJh6P4Ip2LFMBsZly8J79RejVN18w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=VBKWmnME;
	arc=none smtp.remote-ip=209.85.160.197
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70FC606A321
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 20:25:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B70FC606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=VBKWmnME
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-5363fa3d3e4so27304211cf.0
        for <linux-rdma@vger.kernel.org>; Mon, 09 Nov 2026 12:25:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794255935; x=1794860735; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wEJhH5f25270Pxnj7Xperdx9sXc5/sUb3+oN4IYfXTI=;
        b=VBKWmnMEyPNb9hNd0F8O04huoSYJwG31GGlaQDb0cDxeQJvK0PQ8ygZ7bz5NPBCkdO
         IYw3MvGnMGhA9kqEF/hGUw2rblur7VOklWm/CbyHLtNzvaJIRwn8efTHRHwhTrel7Cf1
         UoJONvwvABmOahJ/BVe8Zi6UYDlSIOzOsu/xPHhezzhjeXEKew177v2VZOyoeBopDnGU
         WtF2g0EuY96YimRKHmGd946IwHBE0KjCclM8uxGz3SzylYjYBxFoLrDWoTISL78cVJ84
         OnR4urr1qXvgoba31AkYKM+n1f5FF4JbwoZ+djNdZKiJvcqDcY9Kfzz415/7eXhVuOAx
         HfHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794255935; x=1794860735;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wEJhH5f25270Pxnj7Xperdx9sXc5/sUb3+oN4IYfXTI=;
        b=jDcNdrtZ6HRGvW/txieLLq0pTaZsdEgKJGMdQXnLpx3Dzc/y99B8Kb3mPzCZ4u6Pau
         sTjvIHva5smG3BobIKMV3K6ZGWGtpl9PR17ioQ2tp0ms06CXD1KFtjlBEZf1xVfrFVwW
         2tnXKSvuudNGEj1OljFUtWaXK450ywFWElJjvYRjOHz9ks8tk2c6ToaEDwk1I5+FNQV5
         POw3IdmRYafeC7nvDMMC+U30lhMODMnRbjw+69RrQBudc91uGUk6PBwuEx/CxvzwfI8a
         BJCsHx/KUUzMKDQuWJvYeqxaUvlCa5BPWTpBIl8uHSj75AFs6Plw0Yu57GVE+f8MSsS7
         gmoQ==
X-Gm-Message-State: APuU4Z+OTu5hXg7PAbpRCn0EpXlqQTpGe8wWnGSsEIVYy0cbhEpAUshA
	KViDPSGDhMNL0BLeFKRSy/Cd2P74fEHjBAmXU4twznov7jRL6ssTDOJSYB2RzbGDCqWNS29+bye
	01yGoOtsZxg==
X-Received: from qtrr6-n1.prod.google.com ([2002:a05:622a:a986:10b0:536:1017:cb3b])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a05:622a:488:b0:536:4cce:67df
 with SMTP id d75a77b69052e-5552ab5d6e8mr7043301cf.54.1794255934213; Mon, 09
 Nov 2026 12:25:34 -0800 (PST)
Date: Mon,  9 Nov 2026 20:25:24 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261109202525.2937295-1-jmoroni@google.com>
Subject: [PATCH rdma-next 1/2] RDMA/irdma: Fix potential UAF during SRQ limit
 AE handling
From: Jacob Moroni <jmoroni@google.com>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, Jacob Moroni <jmoroni@google.com>
Content-Type: text/plain; charset="UTF-8"

Previously, the raw SRQ pointer was used for the AE cookie
without any mechanism to ensure that the SRQ object was valid
and remained valid while processing the AE.

This could lead to a UAF if the SRQ happens to get destroyed
before the AE handler has a chance to process the AE (and any
other AEs in the queue in front of it...). It also means that
a bogus cookie from HW could cause a wild dereference.

Fix this by using xarray to perform a lookup based on the SRQ
ID, along with reference counting to ensure that the object
remains alive until the AE handler is done with it.

Fixes: 563e1feb5f6e ("RDMA/irdma: Add SRQ support")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
---
 drivers/infiniband/hw/irdma/ctrl.c  |  7 ++++---
 drivers/infiniband/hw/irdma/hw.c    | 19 ++++++++++++++++---
 drivers/infiniband/hw/irdma/main.h  |  2 ++
 drivers/infiniband/hw/irdma/utils.c | 10 ++++++++++
 drivers/infiniband/hw/irdma/verbs.c | 10 ++++++++++
 drivers/infiniband/hw/irdma/verbs.h |  1 +
 6 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/ctrl.c b/drivers/infiniband/hw/irdma/ctrl.c
index 1c2ad5773b9f..709fb5985acf 100644
--- a/drivers/infiniband/hw/irdma/ctrl.c
+++ b/drivers/infiniband/hw/irdma/ctrl.c
@@ -514,7 +514,8 @@ static int irdma_sc_srq_create(struct irdma_sc_srq *srq, u64 scratch,
 		      FIELD_PREP(IRDMA_CQPSQ_SRQ_SRQ_LIMIT, srq->srq_limit) |
 		      FIELD_PREP(IRDMA_CQPSQ_SRQ_RQSIZE, srq->hw_srq_size) |
 		      FIELD_PREP(IRDMA_CQPSQ_SRQ_RQ_WQE_SIZE, srq->srq_uk.wqe_size));
-	set_64bit_val(wqe, 8, (uintptr_t)srq);
+	set_64bit_val(wqe, 8,
+		      FIELD_PREP(IRDMA_CQPSQ_SRQ_SRQCTX, srq->srq_uk.srq_id));
 	set_64bit_val(wqe, 16,
 		      FIELD_PREP(IRDMA_CQPSQ_SRQ_PD_ID, srq->pd->pd_id));
 	set_64bit_val(wqe, 32,
@@ -632,7 +633,8 @@ static int irdma_sc_srq_destroy(struct irdma_sc_srq *srq, u64 scratch,
 	if (!wqe)
 		return -ENOMEM;
 
-	set_64bit_val(wqe, 8, (uintptr_t)srq);
+	set_64bit_val(wqe, 8,
+		      FIELD_PREP(IRDMA_CQPSQ_SRQ_SRQCTX, srq->srq_uk.srq_id));
 
 	hdr = srq->srq_uk.srq_id |
 	      FIELD_PREP(IRDMA_CQPSQ_OPCODE, IRDMA_CQP_OP_DESTROY_SRQ) |
@@ -4730,7 +4732,6 @@ int irdma_sc_get_next_aeqe(struct irdma_sc_aeq *aeq,
 	switch (info->ae_id) {
 	case IRDMA_AE_SRQ_LIMIT:
 		info->srq = true;
-		/* [63:6] from CMPL_CTXT, [5:0] from WQDESCIDX. */
 		info->compl_ctx = compl_ctx;
 		ae_src = IRDMA_AE_SOURCE_RSVD;
 		break;
diff --git a/drivers/infiniband/hw/irdma/hw.c b/drivers/infiniband/hw/irdma/hw.c
index fbb8fb47d0d1..3d755cca243f 100644
--- a/drivers/infiniband/hw/irdma/hw.c
+++ b/drivers/infiniband/hw/irdma/hw.c
@@ -285,8 +285,9 @@ static void irdma_process_aeq(struct irdma_pci_f *rf)
 	struct irdma_sc_qp *qp = NULL;
 	struct irdma_qp_host_ctx_info *ctx_info = NULL;
 	struct irdma_device *iwdev = rf->iwdev;
-	struct irdma_sc_srq *srq;
+	struct irdma_srq *iwsrq;
 	unsigned long flags;
+	u32 srq_id;
 
 	u32 aeqcnt = 0;
 
@@ -437,8 +438,19 @@ static void irdma_process_aeq(struct irdma_pci_f *rf)
 			irdma_cq_rem_ref(&iwcq->ibcq);
 			break;
 		case IRDMA_AE_SRQ_LIMIT:
-			srq = (struct irdma_sc_srq *)(uintptr_t)info->compl_ctx;
-			irdma_srq_event(srq);
+			srq_id = FIELD_GET(IRDMA_CQPSQ_SRQ_SRQCTX,
+					   info->compl_ctx);
+			xa_lock_irqsave(&rf->srq_xa, flags);
+			iwsrq = xa_load(&rf->srq_xa, srq_id);
+			if (!iwsrq) {
+				xa_unlock_irqrestore(&rf->srq_xa, flags);
+				continue;
+			}
+			refcount_inc(&iwsrq->refcnt);
+			xa_unlock_irqrestore(&rf->srq_xa, flags);
+
+			irdma_srq_event(&iwsrq->sc_srq);
+			irdma_srq_rem_ref(iwsrq);
 			break;
 		case IRDMA_AE_SRQ_CATASTROPHIC_ERROR:
 			break;
@@ -2119,6 +2131,7 @@ static void irdma_set_hw_rsrc(struct irdma_pci_f *rf)
 	spin_lock_init(&rf->arp_lock);
 	spin_lock_init(&rf->qptable_lock);
 	spin_lock_init(&rf->cqtable_lock);
+	xa_init_flags(&rf->srq_xa, XA_FLAGS_LOCK_IRQ);
 	spin_lock_init(&rf->qh_list_lock);
 }
 
diff --git a/drivers/infiniband/hw/irdma/main.h b/drivers/infiniband/hw/irdma/main.h
index 8c17a201c1fd..813d0eb33ec8 100644
--- a/drivers/infiniband/hw/irdma/main.h
+++ b/drivers/infiniband/hw/irdma/main.h
@@ -324,6 +324,7 @@ struct irdma_pci_f {
 	spinlock_t cqtable_lock; /*protect CQ table access*/
 	struct irdma_qp **qp_table;
 	struct irdma_cq **cq_table;
+	struct xarray srq_xa; /* SRQ ID to struct irdma_srq */
 	spinlock_t qh_list_lock; /* protect mc_qht_list */
 	struct mc_table_list mc_qht_list;
 	struct irdma_msix_vector *iw_msixtbl;
@@ -526,6 +527,7 @@ void irdma_cq_add_ref(struct ib_cq *ibcq);
 void irdma_cq_rem_ref(struct ib_cq *ibcq);
 void irdma_cq_wq_destroy(struct irdma_pci_f *rf, struct irdma_sc_cq *cq);
 void irdma_srq_event(struct irdma_sc_srq *srq);
+void irdma_srq_rem_ref(struct irdma_srq *iwsrq);
 void irdma_srq_wq_destroy(struct irdma_pci_f *rf, struct irdma_sc_srq *srq);
 void irdma_cleanup_pending_cqp_op(struct irdma_pci_f *rf);
 int irdma_get_timeout_threshold(struct irdma_sc_dev *dev);
diff --git a/drivers/infiniband/hw/irdma/utils.c b/drivers/infiniband/hw/irdma/utils.c
index 1e5694a4fd91..f4bc08ae0553 100644
--- a/drivers/infiniband/hw/irdma/utils.c
+++ b/drivers/infiniband/hw/irdma/utils.c
@@ -834,6 +834,16 @@ void irdma_cq_rem_ref(struct ib_cq *ibcq)
 	complete(&iwcq->free_cq);
 }
 
+/**
+ * irdma_srq_rem_ref() - drop a reference to an SRQ
+ * @iwsrq: SRQ
+ */
+void irdma_srq_rem_ref(struct irdma_srq *iwsrq)
+{
+	if (refcount_dec_and_test(&iwsrq->refcnt))
+		complete(&iwsrq->free_srq);
+}
+
 struct ib_device *to_ibdev(struct irdma_sc_dev *dev)
 {
 	return &(container_of(dev, struct irdma_pci_f, sc_dev))->iwdev->ibdev;
diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 72de5738ae47..e07b6b40dd99 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -2114,6 +2114,10 @@ static int irdma_destroy_srq(struct ib_srq *ibsrq, struct ib_udata *udata)
 	if (ret)
 		return ret;
 
+	xa_erase_irq(&iwdev->rf->srq_xa, iwsrq->srq_num);
+	irdma_srq_rem_ref(iwsrq);
+	wait_for_completion(&iwsrq->free_srq);
+
 	irdma_srq_wq_destroy(iwdev->rf, srq);
 	irdma_srq_free_rsrc(iwdev->rf, iwsrq);
 	return 0;
@@ -2575,6 +2579,7 @@ static int irdma_create_srq(struct ib_srq *ibsrq,
 		return -EINVAL;
 
 	refcount_set(&iwsrq->refcnt, 1);
+	init_completion(&iwsrq->free_srq);
 	spin_lock_init(&iwsrq->lock);
 	err_code = irdma_alloc_rsrc(rf, rf->allocated_srqs, rf->max_srq,
 				    &iwsrq->srq_num, &rf->next_srq);
@@ -2643,6 +2648,11 @@ static int irdma_create_srq(struct ib_srq *ibsrq,
 			goto srq_destroy;
 	}
 
+	err_code = xa_insert_irq(&rf->srq_xa, iwsrq->srq_num, iwsrq,
+				 GFP_KERNEL);
+	if (err_code)
+		goto srq_destroy;
+
 	return 0;
 
 srq_destroy:
diff --git a/drivers/infiniband/hw/irdma/verbs.h b/drivers/infiniband/hw/irdma/verbs.h
index a1651641eb71..6f696a9cf107 100644
--- a/drivers/infiniband/hw/irdma/verbs.h
+++ b/drivers/infiniband/hw/irdma/verbs.h
@@ -129,6 +129,7 @@ struct irdma_srq {
 	struct irdma_dma_mem kmem;
 	u64 *srq_wrid_mem;
 	refcount_t refcnt;
+	struct completion free_srq;
 	spinlock_t lock; /* for poll srq */
 	struct irdma_pbl *iwpbl;
 	struct irdma_sge *sg_list;
-- 
2.56.0.542.g3ef89b7020-goog

