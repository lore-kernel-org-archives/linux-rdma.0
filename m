Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF4C224F3
	for <linux-rdma@vger.kernel.org>; Mon, 13 Jul 2026 17:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783962797; cv=none; b=c3gi26/qFRmODIRVpVxgIgy1VjJeG9b9WbKemcPKhMzrFAz3HuNQNiPJl0AyMiaAyWX7LVtxvyIwFLzdoYr8XiugxJl+aHVffXgEiWP1+Jzv1EbGHMRp9pBgE1FSSlBltQBHhImzwWa1Jj9kUR7CSQ1is7qP+H6y5IJe0k53tX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783962797; c=relaxed/simple;
	bh=VCZFJMZeHz+d+1F9x6G4rzGTLByaVwcRS6j1CoRyyu4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GFLZW0sj0H6ZcB934dR+e00MUeBuDenDBU4GrDYcAs3zH+enqH2tTxNbwHr+hff2E9aXoE1TkIMOpToDtsy6w9ZbdQoB/spSJJPgRJyq2oZ5NJo84OAmW04efK8HJ6ku7VPFLDmpQ+lSZONOpIr0ZyY/6cexobdAaewNgrFXJ2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lVp6LyQg; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lVp6LyQg"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-81eba807407so2689947b3.2
        for <linux-rdma@vger.kernel.org>; Mon, 13 Jul 2026 10:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783962795; x=1784567595; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NXkb1v1My3FmJfsaWu56NdJf2EQcKNQ6HdgRioikmAg=;
        b=lVp6LyQgSWaZDrP/sRrqte67Gldp0sNfbsth/UTIEYPzAZ3v7HUxPp4yeoY2NQ6RRg
         t1ZN/uIqaQ3n9z0ifiVYTD9UTfvgPwQePDdcyywatcOVuMyIWjbfb+q7Fsc5J0Y61L6P
         dS3+YNdPRuB4w6nv/w9JpbTzTLTawKuhXANBLmAf/sPLIumIATSnk2jGEq0WGDXW4NGQ
         QFB5VYIHmPYuMk1qDFQRwxpgT7qZoOeMjhvzM+8PTn6/Y1lV6QYnrK6D+/jHVh66ZVfz
         A2BlT6zDKM8Iik3f9BPXNHrM/XgHJ9hSum+FYiA47cM9WfZ74BrxaPxSnrjus9nJlbL5
         /QDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783962795; x=1784567595;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NXkb1v1My3FmJfsaWu56NdJf2EQcKNQ6HdgRioikmAg=;
        b=RgN6K5qMkai5cCraCaqjjBz07gg3u+FhbJ7om5WZoyY9vKfq2WW3v9ZdqTw1GXK9PO
         6LWmk3otuDDnPs7FaFer8afeNa8fB8v2ZGqFFeDYhsC5jMIjO/eacLvOZSGXLlmGCi/y
         jzYzaxbe8hIe7r9/UkRmYUomEOBe6CUGzS3UVhTSzi8GhpA3eZ39TF8inp+KULR0+7QN
         oxVoijp4I8hJ8n0V2vnhqPuf7Rp1e8HmsNp26KzBGqkB6+8cHJXtvnP/Iqe9pWrcf0bW
         K5aEHMhDvTxZ1xf3CJr5qgPbgM8qOvFfsi8Cqc3oR+etnrGGV7hMnxoxW4PyQA65cbLJ
         fphA==
X-Gm-Message-State: AOJu0YwyX8raz9t8W6Rtjda4VtRXvKyE/z3m9GiK0MbkpN2OOA9P5gMk
	owSz9fl0VmmgF9sjRwBkxfheFmtaAPkY8+vbUrCuwFJPn1648+d9MGRi0fXkVkp2b+KkC56agza
	+1arADSHXSQ==
X-Received: from yxak13-n1.prod.google.com ([2002:a53:c04d:0:10b0:664:7d1d:44])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a05:690e:4545:10b0:664:e430:cb7a
 with SMTP id 956f58d0204a3-667d7c3de06mr5222558d50.59.1783962795006; Mon, 13
 Jul 2026 10:13:15 -0700 (PDT)
Date: Mon, 13 Jul 2026 17:12:54 +0000
In-Reply-To: <20260713171257.3131493-1-jmoroni@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260713171257.3131493-1-jmoroni@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260713171257.3131493-4-jmoroni@google.com>
Subject: [PATCH rdma-next v4 3/6] RDMA/irdma: Use robust input copy helpers
From: Jacob Moroni <jmoroni@google.com>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, Jacob Moroni <jmoroni@google.com>
Content-Type: text/plain; charset="UTF-8"

Replace the use of ib_copy_from_udata() with
ib_copy_validate_udata_in() where applicable.

For each modified call site, the last argument of
ib_copy_validate_udata_in() was determined by taking
the last member of the ABI struct as per its original
definition (i.e., when it was first committed).

Some methods like irdma_create_cq required special care
because the last member of the current ABI def is beyond
that of the legacy i40iw's ABI def which we need to
remain compatible with. In some other cases like modify_qp,
the legacy i40iw provider never provided any udata at all
so the validation is only performed if inlen > 0.

irdma_create_qp is more challenging because the legacy ABI
was actually larger but the additional fields were never used,
and even worse, never initialized in the provider. This will
be handled in a followup commit.

Signed-off-by: Jacob Moroni <jmoroni@google.com>
---
 drivers/infiniband/hw/irdma/verbs.c | 79 +++++++++++++----------------
 1 file changed, 34 insertions(+), 45 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index c002dd6ead4..c236cec5302 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -1300,7 +1300,6 @@ static int irdma_wait_for_suspend(struct irdma_qp *iwqp)
 int irdma_modify_qp_roce(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 			 int attr_mask, struct ib_udata *udata)
 {
-#define IRDMA_MODIFY_QP_MIN_REQ_LEN offsetofend(struct irdma_modify_qp_req, rq_flush)
 #define IRDMA_MODIFY_QP_MIN_RESP_LEN offsetofend(struct irdma_modify_qp_resp, push_valid)
 	struct irdma_pd *iwpd = to_iwpd(ibqp->pd);
 	struct irdma_qp *iwqp = to_iwqp(ibqp);
@@ -1327,9 +1326,15 @@ int irdma_modify_qp_roce(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 
 	if (udata) {
 		/* udata inlen/outlen can be 0 when supporting legacy libi40iw */
-		if ((udata->inlen && udata->inlen < IRDMA_MODIFY_QP_MIN_REQ_LEN) ||
-		    (udata->outlen && udata->outlen < IRDMA_MODIFY_QP_MIN_RESP_LEN))
+		if (udata->outlen && udata->outlen < IRDMA_MODIFY_QP_MIN_RESP_LEN)
 			return -EINVAL;
+
+		/* For current irdma, validate against ABI def. */
+		if (udata->inlen) {
+			ret = ib_copy_validate_udata_in(udata, ureq, rsvd);
+			if (ret)
+				return ret;
+		}
 	}
 
 	if (attr_mask & ~IB_QP_ATTR_STANDARD_BITS)
@@ -1572,10 +1577,6 @@ int irdma_modify_qp_roce(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 				iwqp->ibqp_state = attr->qp_state;
 				spin_unlock_irqrestore(&iwqp->lock, flags);
 				if (udata && udata->inlen) {
-					if (ib_copy_from_udata(&ureq, udata,
-					    min(sizeof(ureq), udata->inlen)))
-						return -EINVAL;
-
 					irdma_flush_wqes(iwqp,
 					    (ureq.sq_flush ? IRDMA_FLUSH_SQ : 0) |
 					    (ureq.rq_flush ? IRDMA_FLUSH_RQ : 0) |
@@ -1665,7 +1666,6 @@ int irdma_modify_qp_roce(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 int irdma_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr, int attr_mask,
 		    struct ib_udata *udata)
 {
-#define IRDMA_MODIFY_QP_MIN_REQ_LEN offsetofend(struct irdma_modify_qp_req, rq_flush)
 #define IRDMA_MODIFY_QP_MIN_RESP_LEN offsetofend(struct irdma_modify_qp_resp, push_valid)
 	struct irdma_qp *iwqp = to_iwqp(ibqp);
 	struct irdma_device *iwdev = iwqp->iwdev;
@@ -1687,9 +1687,14 @@ int irdma_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr, int attr_mask,
 
 	if (udata) {
 		/* udata inlen/outlen can be 0 when supporting legacy libi40iw */
-		if ((udata->inlen && udata->inlen < IRDMA_MODIFY_QP_MIN_REQ_LEN) ||
-		    (udata->outlen && udata->outlen < IRDMA_MODIFY_QP_MIN_RESP_LEN))
+		if (udata->outlen && udata->outlen < IRDMA_MODIFY_QP_MIN_RESP_LEN)
 			return -EINVAL;
+
+		if (udata->inlen) {
+			err = ib_copy_validate_udata_in(udata, ureq, rsvd);
+			if (err)
+				return err;
+		}
 	}
 
 	if (attr_mask & ~IB_QP_ATTR_STANDARD_BITS)
@@ -1779,10 +1784,6 @@ int irdma_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr, int attr_mask,
 				iwqp->ibqp_state = attr->qp_state;
 				spin_unlock_irqrestore(&iwqp->lock, flags);
 				if (udata && udata->inlen) {
-					if (ib_copy_from_udata(&ureq, udata,
-					    min(sizeof(ureq), udata->inlen)))
-						return -EINVAL;
-
 					irdma_flush_wqes(iwqp,
 					    (ureq.sq_flush ? IRDMA_FLUSH_SQ : 0) |
 					    (ureq.rq_flush ? IRDMA_FLUSH_RQ : 0) |
@@ -2074,7 +2075,6 @@ static int irdma_destroy_cq(struct ib_cq *ib_cq, struct ib_udata *udata)
 static int irdma_resize_cq(struct ib_cq *ibcq, unsigned int entries,
 			   struct ib_udata *udata)
 {
-#define IRDMA_RESIZE_CQ_MIN_REQ_LEN offsetofend(struct irdma_resize_cq_req, user_cq_buffer)
 	struct irdma_cq *iwcq = to_iwcq(ibcq);
 	struct irdma_sc_dev *dev = iwcq->sc_cq.dev;
 	struct irdma_cqp_request *cqp_request;
@@ -2098,9 +2098,6 @@ static int irdma_resize_cq(struct ib_cq *ibcq, unsigned int entries,
 	    IRDMA_FEATURE_CQ_RESIZE))
 		return -EOPNOTSUPP;
 
-	if (udata && udata->inlen < IRDMA_RESIZE_CQ_MIN_REQ_LEN)
-		return -EINVAL;
-
 	if (entries > rf->max_cqe)
 		return -EINVAL;
 
@@ -2134,9 +2131,9 @@ static int irdma_resize_cq(struct ib_cq *ibcq, unsigned int entries,
 			rdma_udata_to_drv_context(udata, struct irdma_ucontext,
 						  ibucontext);
 
-		if (ib_copy_from_udata(&req, udata,
-				       min(sizeof(req), udata->inlen)))
-			return -EINVAL;
+		ret = ib_copy_validate_udata_in(udata, req, user_cq_buffer);
+		if (ret)
+			return ret;
 
 		spin_lock_irqsave(&ucontext->cq_reg_mem_list_lock, flags);
 		iwpbl_buf = irdma_get_pbl((unsigned long)req.user_cq_buffer,
@@ -2328,24 +2325,20 @@ static int irdma_setup_umode_srq(struct irdma_device *iwdev,
 				 struct irdma_srq_init_info *info,
 				 struct ib_udata *udata)
 {
-#define IRDMA_CREATE_SRQ_MIN_REQ_LEN \
-	offsetofend(struct irdma_create_srq_req, user_shadow_area)
 	struct irdma_create_srq_req req = {};
 	struct irdma_ucontext *ucontext;
 	struct irdma_srq_mr *srqmr;
 	struct irdma_pbl *iwpbl;
 	unsigned long flags;
+	int ret;
 
 	iwsrq->user_mode = true;
 	ucontext = rdma_udata_to_drv_context(udata, struct irdma_ucontext,
 					     ibucontext);
 
-	if (udata->inlen < IRDMA_CREATE_SRQ_MIN_REQ_LEN)
-		return -EINVAL;
-
-	if (ib_copy_from_udata(&req, udata,
-			       min(sizeof(req), udata->inlen)))
-		return -EFAULT;
+	ret = ib_copy_validate_udata_in(udata, req, user_shadow_area);
+	if (ret)
+		return ret;
 
 	spin_lock_irqsave(&ucontext->srq_reg_mem_list_lock, flags);
 	iwpbl = irdma_get_pbl((unsigned long)req.user_srq_buf,
@@ -2559,7 +2552,6 @@ static int irdma_create_cq(struct ib_cq *ibcq,
 			   const struct ib_cq_init_attr *attr,
 			   struct uverbs_attr_bundle *attrs)
 {
-#define IRDMA_CREATE_CQ_MIN_REQ_LEN offsetofend(struct irdma_create_cq_req, user_cq_buf)
 #define IRDMA_CREATE_CQ_MIN_RESP_LEN offsetofend(struct irdma_create_cq_resp, cq_size)
 	struct ib_udata *udata = &attrs->driver_udata;
 	struct ib_device *ibdev = ibcq->device;
@@ -2583,8 +2575,7 @@ static int irdma_create_cq(struct ib_cq *ibcq,
 	if (err_code)
 		return err_code;
 
-	if (udata && (udata->inlen < IRDMA_CREATE_CQ_MIN_REQ_LEN ||
-		      udata->outlen < IRDMA_CREATE_CQ_MIN_RESP_LEN))
+	if (udata && udata->outlen < IRDMA_CREATE_CQ_MIN_RESP_LEN)
 		return -EINVAL;
 
 	err_code = irdma_alloc_rsrc(rf, rf->allocated_cqs, rf->max_cq, &cq_num,
@@ -2626,11 +2617,14 @@ static int irdma_create_cq(struct ib_cq *ibcq,
 		ucontext =
 			rdma_udata_to_drv_context(udata, struct irdma_ucontext,
 						  ibucontext);
-		if (ib_copy_from_udata(&req, udata,
-				       min(sizeof(req), udata->inlen))) {
-			err_code = -EFAULT;
+		/* Even though the last member of struct irdma_create_cq_req
+		 * was always user_shadow_area, we need backwards compat with
+		 * the legacy i40iw struct i40iw_ucreate_cq which stopped
+		 * at user_cq_buffer.
+		 */
+		err_code = ib_copy_validate_udata_in(udata, req, user_cq_buf);
+		if (err_code)
 			goto cq_free_rsrc;
-		}
 
 		spin_lock_irqsave(&ucontext->cq_reg_mem_list_lock, flags);
 		iwcq->iwpbl = irdma_get_pbl((unsigned long)req.user_cq_buf,
@@ -3614,7 +3608,6 @@ static struct ib_mr *irdma_reg_user_mr(struct ib_pd *pd, u64 start, u64 len,
 				       struct ib_dmah *dmah,
 				       struct ib_udata *udata)
 {
-#define IRDMA_MEM_REG_MIN_REQ_LEN offsetofend(struct irdma_mem_reg_req, sq_pages)
 	struct irdma_device *iwdev = to_iwdev(pd->device);
 	struct irdma_mem_reg_req req = {};
 	struct ib_umem *region = NULL;
@@ -3624,6 +3617,10 @@ static struct ib_mr *irdma_reg_user_mr(struct ib_pd *pd, u64 start, u64 len,
 	if (dmah)
 		return ERR_PTR(-EOPNOTSUPP);
 
+	err = ib_copy_validate_udata_in(udata, req, sq_pages);
+	if (err)
+		return ERR_PTR(err);
+
 	err = ib_respond_empty_udata(udata);
 	if (err)
 		return ERR_PTR(err);
@@ -3631,9 +3628,6 @@ static struct ib_mr *irdma_reg_user_mr(struct ib_pd *pd, u64 start, u64 len,
 	if (len > iwdev->rf->sc_dev.hw_attrs.max_mr_size)
 		return ERR_PTR(-EINVAL);
 
-	if (udata->inlen < IRDMA_MEM_REG_MIN_REQ_LEN)
-		return ERR_PTR(-EINVAL);
-
 	region = ib_umem_get_va(pd->device, start, len, access);
 
 	if (IS_ERR(region)) {
@@ -3642,11 +3636,6 @@ static struct ib_mr *irdma_reg_user_mr(struct ib_pd *pd, u64 start, u64 len,
 		return (struct ib_mr *)region;
 	}
 
-	if (ib_copy_from_udata(&req, udata, min(sizeof(req), udata->inlen))) {
-		ib_umem_release(region);
-		return ERR_PTR(-EFAULT);
-	}
-
 	iwmr = irdma_alloc_iwmr(region, pd, virt, req.reg_type);
 	if (IS_ERR(iwmr)) {
 		ib_umem_release(region);
-- 
2.55.0.795.g602f6c329a-goog

