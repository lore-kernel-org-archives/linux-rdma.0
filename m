Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793283539;
	b=wyALvGLiYkphVWowwApd644JGkM1OdM60z7Qhk3peKCwW9pxGxFbL7F9rBiGhmXFhNww
	 e3WwrtmwpMB1NNo/+JQghedyhn+C2wPueXP5hcBnAuXucRssBQ1qNmunxRHOqB2gKi/zm
	 Hq/aQra+7rtC0rCaMchUJJeevnw3EMUtdQQcv7/JsrUYbYiJwN0TNEQmkRwUJJNNZMi5m
	 gKaQm4/ICcINtSdjc++0BenJxpKEI4dO7Djm0y1ubYOONhW98mQuheFfPwSY4JMGS5Sug
	 GZ5fzH8lvztBf+pD7KNaSoPxL+AlGG4emeAuqNQa3oVLRCK0lT+Uw+7qKQ7vHAarrow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793283539;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=RQT8Qk6/je1+s4Vl0c1s8qy8QFr9UsymjIcKMC4COqk=;
	b=jh9+tfntYLN4vegOa2IbEDiuPESaisnzTs2zi3PONLkyRZ7r3QvD6YY4WVHfRNK7aLJx
	 6J1NuN6y7fnoYEOKawC9VEmnhhX5+KUw9XupI4fMsML2jTQad73oPeRpf6IbtoQgFJXZ2
	 h5Lk7ONFlRt2Wquz1T0JdbRqSibUHThTtoJMR+6XaQOTz5IZ85vHAtSt+FWx/afjsGMYm
	 ypqTgEo4gUGdL5qL+LxTGLJLEJGb/36BZYEXuyzZ+2CuAZeHEGh4z3VLk8pSc8zxzEJDK
	 7r4vgYp+eslAnDPYpbz475bNlzUUIoXIJDcLsb41lhKomll/H3z6XkPR0RKuefSmSnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=JJlUgqKT;
	arc=none smtp.remote-ip=209.85.222.199
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F2460A3815
	for <linux-rdma@vger.kernel.org>; Thu, 29 Oct 2026 14:18:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 35F2460A3815
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=JJlUgqKT
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93f5844e383so339152285a.1
        for <linux-rdma@vger.kernel.org>; Thu, 29 Oct 2026 07:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793283538; x=1793888338; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RQT8Qk6/je1+s4Vl0c1s8qy8QFr9UsymjIcKMC4COqk=;
        b=JJlUgqKTNY0oNwEZ1L05O9oqCwIRRA8QzOoA1O1uJ9OE7AP8aCkhM9XDgA75VN7jc0
         8HT2lhaHJ04ZxCo3AVOqO/jY+R9RyaiE3LI0q9DHW+xeMcLoPzIw+CQwoOuYTjNFdXKM
         BdKcjsCJMNfkHV3WCxEAuO6cBstdJkzj/5aU6ig5qI1ZmqsvbDHAyVJ73hTk/4cXkV6u
         uTYP7GBKaLwbQYk6f+YO9Y5B7dpsGPaAnIVchI8GAi9+ALaoJ11xS23lLjPOQIC5eO08
         b8h6QXhYGk3xnpNDCYjJQ12ZHTLvuIDjQfcTaq222iRnEoSrCpaYGiRFQylJ8xw4lEtg
         wKNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793283538; x=1793888338;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RQT8Qk6/je1+s4Vl0c1s8qy8QFr9UsymjIcKMC4COqk=;
        b=FqABFVN3cO/KuTm1i0yRREP2/k3yEkNKMuZPEOvTs9uIAlcK47M7DAVAP92sBohnEv
         9ph2ts8igSE7ZcD+QKY59VjU7ACmIIURoY6aTD/85+sJiZcT2sYCY7X2awee6My8a3uC
         YUIeSFOuCVHkkFfTjZF9xqf6ZVDG8SgEp//SajvU/E+3OBSalMFzjL+5EXSKWzizQ+yi
         +qHBaQ+0iuhJR1AoKVqU3bFZPQKYJAZNNEb5nt929byBtUQgVwI2/EJtPWXsHTlws0KF
         SDwFSRpXkZCAT227mzGu0K+rpIF3c90yySgSs7Sn1euOPYRxczXbTJB2AlM++KmRjun7
         B/lA==
X-Gm-Message-State: AFq9FYKT3vooFqgPJvUSqcSFlvS7WlTdvXqAGwPfZ18WppLebqRY7DoE
	4+i13X5ICIE/0CH6zYWgWK1k1WWAxvypSCEa3oO20ng3oHoQIZTMicYRx8xSRmbxq5XuzjZAVHU
	IKl+hpToeyA==
X-Received: from qknpf22.prod.google.com ([2002:a05:620a:8596:b0:93f:18ba:bf7a])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a05:620a:410b:b0:93e:c5eb:2230
 with SMTP id af79cd13be357-94408a5b291mr844386785a.33.1793283537916; Thu, 29
 Oct 2026 07:18:57 -0700 (PDT)
Date: Thu, 29 Oct 2026 14:18:48 +0000
In-Reply-To: <20261029141849.1575012-1-jmoroni@google.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261029141849.1575012-1-jmoroni@google.com>
X-Mailer: git-send-email 2.56.0.313.g2479322e68-goog
Message-ID: <20261029141849.1575012-2-jmoroni@google.com>
Subject: [PATCH RESEND rdma-next 2/2] RDMA/irdma: Do not change mr->pd in
 driver during rereg_mr
From: Jacob Moroni <jmoroni@google.com>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, Jacob Moroni <jmoroni@google.com>
Content-Type: text/plain; charset="UTF-8"

Previously, IB_MR_REREG_PD would cause the driver to set
iwmr->ibmr.pd to the new PD before reregistering with HW because
irdma_hwreg_mr() retrieves the PD from there.

ib_uverbs_rereg_mr() only moves the PD usecnt from the old PD to
the new one and updates mr->pd itself after the driver's
rereg_user_mr() call succeeds.

So, if the rereg_user_mr() call fails, the MR is left pointing at
a PD that does not account for it while the old PD keeps the reference,
which means the old PD can never be deallocated, while the new PD can
be deallocated even though the MR still points at it.

Fix this by removing the PD update from the driver and just letting
the core handle it. This required plumbing the PD as an argument
through a few functions. This works because the core passes the
PD unconditionally and provides the current PD if IB_MR_REREG_PD is
not set.

Fixes: 5ac388db27c4 ("RDMA/irdma: Add support to re-register a memory region")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
---
 drivers/infiniband/hw/irdma/verbs.c | 34 ++++++++++++-----------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index fd1b1454f026..b4343181159d 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -3308,14 +3308,14 @@ static int irdma_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg,
  * irdma_hwreg_mr - send cqp command for memory registration
  * @iwdev: irdma device
  * @iwmr: irdma mr pointer
+ * @pd: protection domain to register the MR with
  * @access: access for MR
  */
 static int irdma_hwreg_mr(struct irdma_device *iwdev, struct irdma_mr *iwmr,
-			  u16 access)
+			  struct ib_pd *pd, u16 access)
 {
 	struct irdma_pbl *iwpbl = &iwmr->iwpbl;
 	struct irdma_reg_ns_stag_info *stag_info;
-	struct ib_pd *pd = iwmr->ibmr.pd;
 	struct irdma_pd *iwpd = to_iwpd(pd);
 	struct irdma_pble_alloc *palloc = &iwpbl->pble_alloc;
 	struct irdma_cqp_request *cqp_request;
@@ -3369,8 +3369,8 @@ static int irdma_hwreg_mr(struct irdma_device *iwdev, struct irdma_mr *iwmr,
 	return ret;
 }
 
-static int irdma_reg_user_mr_type_mem(struct irdma_mr *iwmr, int access,
-				      bool create_stag)
+static int irdma_reg_user_mr_type_mem(struct irdma_mr *iwmr, struct ib_pd *pd,
+				      int access, bool create_stag)
 {
 	struct irdma_device *iwdev = to_iwdev(iwmr->ibmr.device);
 	struct irdma_pbl *iwpbl = &iwmr->iwpbl;
@@ -3415,7 +3415,7 @@ static int irdma_reg_user_mr_type_mem(struct irdma_mr *iwmr, int access,
 		iwmr->ibmr.lkey = stag;
 	}
 
-	err = irdma_hwreg_mr(iwdev, iwmr, access);
+	err = irdma_hwreg_mr(iwdev, iwmr, pd, access);
 	if (err)
 		goto err_hwreg;
 
@@ -3646,7 +3646,7 @@ static struct ib_mr *irdma_reg_user_mr(struct ib_pd *pd, u64 start, u64 len,
 			goto error;
 		break;
 	case IRDMA_MEMREG_TYPE_MEM:
-		err = irdma_reg_user_mr_type_mem(iwmr, access, true);
+		err = irdma_reg_user_mr_type_mem(iwmr, pd, access, true);
 		if (err)
 			goto error;
 
@@ -3726,7 +3726,7 @@ static struct ib_mr *irdma_reg_user_mr_dmabuf(struct ib_pd *pd, u64 start,
 		goto err_release;
 	}
 
-	err = irdma_reg_user_mr_type_mem(iwmr, access, true);
+	err = irdma_reg_user_mr_type_mem(iwmr, pd, access, true);
 	if (err)
 		goto err_iwmr;
 
@@ -3794,6 +3794,7 @@ static int irdma_hwdereg_mr(struct ib_mr *ib_mr)
 /*
  * irdma_rereg_mr_trans - Re-register a user MR for a change translation.
  * @iwmr: ptr of iwmr
+ * @pd: protection domain to register the MR with
  * @start: virtual start address
  * @len: length of mr
  * @virt: virtual address
@@ -3801,11 +3802,10 @@ static int irdma_hwdereg_mr(struct ib_mr *ib_mr)
  * Re-register a user memory region when a change translation is requested.
  * Re-register a new region while reusing the stag from the original registration.
  */
-static int irdma_rereg_mr_trans(struct irdma_mr *iwmr, u64 start, u64 len,
-				u64 virt)
+static int irdma_rereg_mr_trans(struct irdma_mr *iwmr, struct ib_pd *pd,
+				u64 start, u64 len, u64 virt)
 {
 	struct irdma_pbl *iwpbl = &iwmr->iwpbl;
-	struct ib_pd *pd = iwmr->ibmr.pd;
 	struct ib_umem *region;
 	int err;
 
@@ -3815,11 +3815,10 @@ static int irdma_rereg_mr_trans(struct irdma_mr *iwmr, u64 start, u64 len,
 
 	iwmr->region = region;
 	iwmr->ibmr.iova = virt;
-	iwmr->ibmr.pd = pd;
 	iwmr->len = region->length;
 	iwpbl->user_base = virt;
 
-	err = irdma_reg_user_mr_type_mem(iwmr, iwmr->access, false);
+	err = irdma_reg_user_mr_type_mem(iwmr, pd, iwmr->access, false);
 	if (err)
 		goto err;
 
@@ -3883,11 +3882,6 @@ static struct ib_mr *irdma_rereg_user_mr(struct ib_mr *ib_mr, int flags,
 	if (flags & IB_MR_REREG_ACCESS)
 		iwmr->access = new_access;
 
-	if (flags & IB_MR_REREG_PD) {
-		iwmr->ibmr.pd = new_pd;
-		iwmr->ibmr.device = new_pd->device;
-	}
-
 	if (flags & IB_MR_REREG_TRANS) {
 		if (iwpbl->pbl_allocated) {
 			irdma_free_pble(iwdev->rf->pble_rsrc,
@@ -3900,9 +3894,9 @@ static struct ib_mr *irdma_rereg_user_mr(struct ib_mr *ib_mr, int flags,
 			iwmr->region = NULL;
 		}
 
-		ret = irdma_rereg_mr_trans(iwmr, start, len, virt);
+		ret = irdma_rereg_mr_trans(iwmr, new_pd, start, len, virt);
 	} else {
-		ret = irdma_hwreg_mr(iwdev, iwmr, iwmr->access);
+		ret = irdma_hwreg_mr(iwdev, iwmr, new_pd, iwmr->access);
 	}
 
 	return ret ? ERR_PTR(ret) : NULL;
@@ -3951,7 +3945,7 @@ struct ib_mr *irdma_reg_phys_mr(struct ib_pd *pd, u64 addr, u64 size, int access
 	iwmr->pgaddrmem[0] = addr;
 	iwmr->len = size;
 	iwmr->page_size = SZ_4K;
-	ret = irdma_hwreg_mr(iwdev, iwmr, access);
+	ret = irdma_hwreg_mr(iwdev, iwmr, pd, access);
 	if (ret) {
 		irdma_free_stag(iwdev, stag);
 		goto err;
-- 
2.56.0.313.g2479322e68-goog

