Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793281989;
	b=S9OrqxxNth8UsOV5UKqHJlFCbo0twhkDQzfqKHu2AAnrx7Vyvq2Ri54ujNlwp7A+hbpB
	 jd3p7Cuii6YCENSf74O4tUxvL/l3auJm9w0FxRvZXXruQjRULTOELZMuRzyAd2hj8fuNb
	 w9kB0vF4mY9jKQH280XekfujRDGIXVhjYADL9e13OLdRfNhf0Ipr76b2Tcto2T9xDzyMs
	 2UwYfwh3wrEdB8jaErI6Epw5UlIisVhUJdPxjH7M34/umjtKkvok4jVgKjX6c5o9YZTAK
	 BmtldS4kHeTQL0J+ujsBcl8HGiSSppcDXY/Sv19Aaol058EiwkoBAl1RPO11I5Nf1Xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793281989;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=RQT8Qk6/je1+s4Vl0c1s8qy8QFr9UsymjIcKMC4COqk=;
	b=YM4eQFHJs02HYVoo6GF73D0UqFGS/R5IPOaUq3rgbM7GV296zA40z/IIvuGaIQ/9tTWb
	 ucAIcDJ66aMDfCbx8zOw9MBfj24BvZdxjruuhS8HrSf6EsMycrgWEqEBNp6CnicCjQoQU
	 DjTK8CoTZXCxa82flRj0NfIC1ouLZ3GDjElmtfPlXvLbVecMUqj/ffwqZHXWGrcTC6r4S
	 WaOjDxXcStEFo+2DdVWq9BaACcnYN3mw3FwLt2mcqRr66WoBnh+mfJZp59VZDXBjt038Z
	 IVdKpPo3OT8zgeQ5aLF6BULw2HguBprU+sjSefcaITqbrPkZkIl65zs8js5MjLNVmlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=p8Hdd0sa;
	arc=none smtp.remote-ip=209.85.160.200
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D634460A262E
	for <linux-rdma@vger.kernel.org>; Thu, 29 Oct 2026 13:53:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D634460A262E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=p8Hdd0sa
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-5358515b4easo49244981cf.0
        for <linux-rdma@vger.kernel.org>; Thu, 29 Oct 2026 06:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793281988; x=1793886788; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RQT8Qk6/je1+s4Vl0c1s8qy8QFr9UsymjIcKMC4COqk=;
        b=p8Hdd0saL5M7OVWriu9VSjyE50jFws5f05QyCrazHIZ/kxsKhMJ90e42PKCadBK9SW
         0CRXzkg4Cwt14e+mysbGnTXHXjt+I0veTHvW9UxeiH3Cs0Vk+Vz0yW3BMFt2tPxK4N78
         zNBByBGRevoJfsHRQK0tFwcIfsKDhLTPnK2ExlDCzd0yUOhzNHCB/xwJqxENbOT622/u
         ps6DmV/+Z47aA5XupRTqrYOYj4QchHhVKdNV6Oo3s8sPZ/Jj/uPfyxLxhtFpJWBNq0T8
         MdK0f/JWRAwk7/43EV6J+32vMurptBZAik7jAPUcZyk0Cjd+Ef6YjitzIDaE5Jr0oraD
         PqCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793281988; x=1793886788;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RQT8Qk6/je1+s4Vl0c1s8qy8QFr9UsymjIcKMC4COqk=;
        b=p1gr280rtlMc/8LM6lqcJVuRr1jjjaelb8AQD+VAlGPKzpbIditHI8ssDHZyeeFM0G
         4uJ4NqCIgHuftq8yBJP1uTAFzMoPKCaaEK3/vJZ2jOwdtf608mmTmXix2eOoxOd1LTHL
         WbkKZKGkz6s/UkVdEuzKrcrsReXnW2yFYIFcA85eAa1+//E0xJzlpXFCh7onyqBZISLa
         78QydQuUxOtjIki7Vp9nLzM3YjjL9gFIKoZWAbYIdK8CW8AwQ1LOGbzgRgvGB5T0UNlu
         QQoYRwoAIGwLzObkopl/xeA5KFXIsNeU3MpJEDrcUweawLedMbZkyk0xkW9hdRNYkWZL
         Op9A==
X-Gm-Message-State: AFq9FYK3bGYNhebk+kSnAaJ7jXj8HF+aa5jVk4DXBuIT6nFZxVBTqWbC
	IdIET0qgFUhKot18CuRPW2hpYVtWNLcQCcbMTLHvapVp5MJUy/SHgcc6p609LqcARZ33EeRAD7Q
	QxYAVdjOkxg==
X-Received: from qvnw16.prod.google.com ([2002:a0c:f710:0:b0:91b:e0cd:408])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:ac8:598c:0:b0:536:9980:9a66
 with SMTP id d75a77b69052e-53fcc5cb41dmr87354381cf.41.1793281987504; Thu, 29
 Oct 2026 06:53:07 -0700 (PDT)
Date: Thu, 29 Oct 2026 13:53:06 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.313.g2479322e68-goog
Message-ID: <20261029135306.1372393-1-jmoroni@google.com>
Subject: [PATCH rdma-next 3/3] RDMA/irdma: Do not change mr->pd in driver
 during rereg_mr
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

