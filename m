Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com [209.85.222.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42023CDBDD
	for <linux-rdma@vger.kernel.org>; Mon, 29 Jun 2026 23:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782775549; cv=none; b=gYjTlBdOVx7r6khu5eAKhOygJVDqCI5orFaCUEbEGxpydXPf7ACfdrp/GrG5SX6BRWY1d6vqUZv1zKrYvezuw4r75qc+4WZkc9x2a+tmsODjMbqEZ5XH8ME3eH1D9BB40Q9iQWt7VEJUXmR5uyXbltkF2gGMfjuVgepwjIPFJ24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782775549; c=relaxed/simple;
	bh=6uGQn6FOpV8bZx5M6jXYGDVvtgmDx1Dn+yMI4TtUQ5k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A9xjwqL4Tj5dWGHceNVnVVC8Zb+yXVFiWlt6W7i7dDSXGiIe5X4q1wycHLeNwFh/vz2oGidKSpirtzdsIsjBwt+vou6vh+qwp69H6Uo3W5d6jxgEmG8ryVrrjUi8oBCdC78HQQ1LJqV0LdjUQbtDwRt4QFb+8eLIb6/FZuiZ5L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DKr1RYMU; arc=none smtp.client-ip=209.85.222.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DKr1RYMU"
Received: by mail-qk1-f202.google.com with SMTP id af79cd13be357-92e663c29f2so12116185a.0
        for <linux-rdma@vger.kernel.org>; Mon, 29 Jun 2026 16:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782775547; x=1783380347; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jIWEglJbB9SDK2/vQukpGWfdZYPMqvU57mtZMPfX5Ms=;
        b=DKr1RYMU5Tu+oesMMV4U1VL6p5nsX27nie9uo8Zx14EW+3p7LnI/2+EGSKb8N/KMPU
         WyvPgCeJxr1qY34k5U5Wpbxzj0w2PJvFzvd9NoSFrx4eK2T+rLgFz231538Sb9W19pfx
         tHU4eJJSLX3pCzUS32xuRNIhebv0+zTmHxupUSGKmkB2TfCrYGwMnUOod9A7db8Ju8Xf
         SjohDQQZGaJ0+qsmjFo07OLlSoDdubtFxpe/KDKuLJ7ZELw2bKGGF0S/Rjy3smbWCJj7
         1t9nQ8cAAergVe6GT3Pd3d3v5sksrreyXQwMeQGKMJHiBZZDJr7wEiE2WNdlQdKPyDL5
         7h7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782775547; x=1783380347;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jIWEglJbB9SDK2/vQukpGWfdZYPMqvU57mtZMPfX5Ms=;
        b=O7FPf7YnkIIbA0bnVP9cZW/1AEUc0qRi+WVyQ+PMce/RFqqiqA6qeyUB7vkDsNAUwT
         lkTKKm8bOXkSZWb3KdHeTS+w1CfQNOwaSHHmDy2xDoNKh4XkAmvDQTNmgAYYetJ1sXC/
         L7aHCbBVJXUuthnrVFq29pAbJEvGfRqEWPjEFuesC0gsQJpNftrkZA+j/8KrJ+vwSyuu
         QmOl10A4LAq5b/WVkKMcdlk9FEcUN58RThN9vedJAuXc1VSnU9LdM3kjOYM+NeMWccaV
         fW+jm7eKGx72qkDmD2U8PBU1gn/Z1VesGPtOmESGrcYWA97pGZgMHTXi1VMCQQY1N1Ud
         LN6w==
X-Gm-Message-State: AOJu0YzIk7agoDeq0ML7/TMhIWrVc7kY0hC1QwaYpxnxvNB6G2L0qcuk
	GbPykZuAtm7HDMLgwKNkFdz/my+qXEca+OmkJH1wIGk1cb93ZimEScq6wT3f0GjnkLxRADp8uez
	awGSIBE0+lw==
X-Received: from qkfw3.prod.google.com ([2002:ae9:e503:0:b0:92e:5c93:7d4])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a05:620a:3944:b0:92b:856f:3c14
 with SMTP id af79cd13be357-92e632a2137mr205712685a.11.1782775546425; Mon, 29
 Jun 2026 16:25:46 -0700 (PDT)
Date: Mon, 29 Jun 2026 23:25:30 +0000
In-Reply-To: <20260629232532.2057423-1-jmoroni@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260629232532.2057423-1-jmoroni@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260629232532.2057423-4-jmoroni@google.com>
Subject: [PATCH rdma-next v2 3/5] RDMA/irdma: Use ib_respond_empty_udata where applicable
From: Jacob Moroni <jmoroni@google.com>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, Jacob Moroni <jmoroni@google.com>
Content-Type: text/plain; charset="UTF-8"

Methods that do not provide any user response should use
the ib_respond_empty_udata() helper to ensure that user
response buffers are cleared.

Signed-off-by: Jacob Moroni <jmoroni@google.com>
---
 drivers/infiniband/hw/irdma/verbs.c | 51 ++++++++++++++++++++++++-----
 1 file changed, 43 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 074dfa46b35c..c1df9ca1b86b 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -455,6 +455,10 @@ static int irdma_dealloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
 	if (err)
 		return err;
 
+	err = ib_respond_empty_udata(udata);
+	if (err)
+		return err;
+
 	irdma_free_rsrc(iwdev->rf, iwdev->rf->allocated_pds, iwpd->sc_pd.pd_id);
 
 	return 0;
@@ -557,6 +561,10 @@ static int irdma_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 	if (err)
 		return err;
 
+	err = ib_respond_empty_udata(udata);
+	if (err)
+		return err;
+
 	iwqp->sc_qp.qp_uk.destroy_pending = true;
 
 	if (iwqp->iwarp_state >= IRDMA_QP_STATE_IDLE)
@@ -1626,14 +1634,14 @@ int irdma_modify_qp_roce(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 				uresp.push_offset = iwqp->sc_qp.push_offset;
 			}
 			ret = ib_respond_udata(udata, uresp);
-			if (ret) {
+			if (ret)
 				irdma_remove_push_mmap_entries(iwqp);
-				return ret;
-			}
+			return ret;
+
 		}
 	}
 
-	return 0;
+	return ib_respond_empty_udata(udata);
 exit:
 	spin_unlock_irqrestore(&iwqp->lock, flags);
 
@@ -1872,13 +1880,12 @@ int irdma_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr, int attr_mask,
 		}
 
 		err = ib_respond_udata(udata, uresp);
-		if (err) {
+		if (err)
 			irdma_remove_push_mmap_entries(iwqp);
-			return err;
-		}
+		return err;
 	}
 
-	return 0;
+	return ib_respond_empty_udata(udata);
 exit:
 	spin_unlock_irqrestore(&iwqp->lock, flags);
 
@@ -1982,6 +1989,10 @@ static int irdma_destroy_srq(struct ib_srq *ibsrq, struct ib_udata *udata)
 	if (err)
 		return err;
 
+	err = ib_respond_empty_udata(udata);
+	if (err)
+		return err;
+
 	irdma_srq_wq_destroy(iwdev->rf, srq);
 	irdma_srq_free_rsrc(iwdev->rf, iwsrq);
 	return 0;
@@ -2007,6 +2018,10 @@ static int irdma_destroy_cq(struct ib_cq *ib_cq, struct ib_udata *udata)
 	if (err)
 		return err;
 
+	err = ib_respond_empty_udata(udata);
+	if (err)
+		return err;
+
 	spin_lock_irqsave(&iwcq->lock, flags);
 	if (!list_empty(&iwcq->cmpl_generated))
 		irdma_remove_cmpls_list(iwcq);
@@ -2052,6 +2067,10 @@ static int irdma_resize_cq(struct ib_cq *ibcq, unsigned int entries,
 	u8 cqe_size;
 	int ret;
 
+	ret = ib_respond_empty_udata(udata);
+	if (ret)
+		return ret;
+
 	iwdev = to_iwdev(ibcq->device);
 	rf = iwdev->rf;
 
@@ -2222,6 +2241,10 @@ static int irdma_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 	if (status)
 		return status;
 
+	status = ib_respond_empty_udata(udata);
+	if (status)
+		return status;
+
 	if (attr_mask & IB_SRQ_MAX_WR)
 		return -EINVAL;
 
@@ -3063,6 +3086,10 @@ static int irdma_alloc_mw(struct ib_mw *ibmw, struct ib_udata *udata)
 	if (err_code)
 		return err_code;
 
+	err_code = ib_respond_empty_udata(udata);
+	if (err_code)
+		return err_code;
+
 	stag = irdma_create_stag(iwdev);
 	if (!stag)
 		return -ENOMEM;
@@ -4006,6 +4033,10 @@ static int irdma_dereg_mr(struct ib_mr *ib_mr, struct ib_udata *udata)
 	if (ret)
 		return ret;
 
+	ret = ib_respond_empty_udata(udata);
+	if (ret)
+		return ret;
+
 	if (iwmr->type != IRDMA_MEMREG_TYPE_MEM) {
 		if (iwmr->region) {
 			struct irdma_ucontext *ucontext;
@@ -5381,6 +5412,10 @@ static int irdma_create_ah(struct ib_ah *ibah, struct rdma_ah_init_attr *attr,
 	if (err)
 		return err;
 
+	err = ib_respond_empty_udata(udata);
+	if (err)
+		return err;
+
 	err = irdma_setup_ah(ibah, attr);
 	if (err)
 		return err;
-- 
2.55.0.rc0.799.gd6f94ed593-goog

