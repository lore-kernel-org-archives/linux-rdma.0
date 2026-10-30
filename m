Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793384152;
	b=Cg1fJifHIRYE16LevckJVlQlNmW7X3pYE5b02qvwG4lBWCaPCvNvYR2YSGWgado+5khl
	 /P1X1ZdyTeQkEmYjSYQqMTM3LWA9JGcoYB/7CAHCGTE+b8gNXbx31kTs4N4OWP2HxBfV/
	 teNM/bgcZCiWA0MItz3P/FQJ2NWdCfQNIcYrnDRLpSUmfIz2DeiTYMOsR56YkYYexBpYW
	 U3i1WbL74WaJqY/vKYi4c5OsXRpmcYbLRYxDxEzNWOP1h4z9ry13Os5upbJijxylmrWbP
	 Bhc7qLiQs98U6uR9ITzEpxaolu1Si8qstqEsi9s3c/Zd9aSXZ1e01NKUcQsx1DPT5uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793384152;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vGjtMvqUjjQQlfnOmLLXETqY/y43eIZFaXdz4rybB2c=;
	b=LRWxETkfSWRtLHCIY1V1vuIgUwzGKcU5Q2IvUJXU7X513/ATzxnBk1KuJsPf0Bl+TzbE
	 kUrnXrUpF9eLebT0Mqh8lPVLa4UOWPLMZHyVzcEvTjf2lzacHAIQ5bjzmWGFYzYYQ3V+7
	 Ihkt6hKNLBzt2FFARxLVgExRZRuGK3ZsH/LEJyMrOSLYr4iO9uOaydghQfM0A32FRawh2
	 VtGEGytnGX3VPq7re/6ZUdJRY/FFSjsyC6HY8RqFNTHqSCKEn5yvL99PBAytGCnqQ02UJ
	 ljyo8PvfuBuBDhlVPMzSX57vqJ12eAjEgxVRRWN5HAvERv/qEgd3hAYgi7BWK4bxqlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=x6u.co;
	spf=pass smtp.mailfrom=x6u.co;
	dkim=pass header.d=x6u.co header.i=@x6u.co header.a=rsa-sha256 header.s=google header.b=Ev17nY1n;
	arc=none smtp.remote-ip=209.85.217.48
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F003960A260C
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 18:15:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F003960A260C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=x6u.co
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=x6u.co header.i=@x6u.co header.a=rsa-sha256 header.s=google header.b=Ev17nY1n
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-7cbbb7b90efso284555137.2
        for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 11:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=x6u.co; s=google; t=1793384150; x=1793988950; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vGjtMvqUjjQQlfnOmLLXETqY/y43eIZFaXdz4rybB2c=;
        b=Ev17nY1nSbYHLcnkKmDuJBUQHHUutmHSHwzgHAax5OWxJv/gD0r4tL1Jwvz2npFSmc
         6AcehClDklEaS5dya955/cd7Pt0HQhZpHjWh1tQZYRhrooxUlmdlADdrn1++Os/BWAcC
         MoWZHgVWhfNuIG7hYinayljpJHB2YidWvB5KHM+m4u57f8cgI6B9zs2VPJ4Vt0p4u94S
         NciqYrxB2u5YCIh/3VJib7kBJSunKAhgU/T7egIBj5o73iG3V582wILSncPeecF6L/OG
         twmZ3uz/6O7P93qUM/dKcLaQ40jviQprtEhaJZ909QIR9fAT4ZgtC3akBEI/b1u8s3aO
         ojHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793384150; x=1793988950;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vGjtMvqUjjQQlfnOmLLXETqY/y43eIZFaXdz4rybB2c=;
        b=Q8TDVO9bgBc76wmru5AwEMqMmCIlOGnw4fdEWZRiZq6sQb1/XkI3oTfcvEIDWEWEgY
         eck49N6ulT+M/vYfhSBmR7EFdvEtFiHmJ1V+c1/Olx8GzqyEnSxP4/FknT00nu3PsCcA
         R/9dmvC2DuYWzMG+Jde8vGOGPEmqAMRyYw4DclMXZSh03GodmhdGg6K+gd3fJVqYm7G7
         af4S4uItHrWzZB9VqKVus71vs+pDQM/oQgBzP3dJi+KgYDmrKVtAra//sMbN4fYxXRCe
         4yvbyq+ScjyrAQnKsXLkr5qH0Xjfir1eWX0zpRmqF9P0LuoBBqd9AykblQbicULQZKcG
         kVuQ==
X-Forwarded-Encrypted: i=1; AKwUvBxa8DWthFJx2qP2aAEwN4ImwyR1HLZqTKuAABqhVUdWrm73Iw7JCaatRlEBVkrNGb2ErqMbmeYGXsju@vger.kernel.org
X-Gm-Message-State: AFq9FYIVouloqS6oO3orPT9D4dj3dWbR0uC1Uygx1qA5VFTsMQm1SiQQ
	P5CKWDH/rtcHQWtXBPYwzGNAa58LMjHK3Spw4WAuPKNWb3zYHkZcX9uk/R8ve14lehr1ZKfrJUf
	axhHLHQ==
X-Gm-Gg: AYBFou1cyHijhYxKjq6Xw5RDNdo1CJDmAB8Z2oKpOZagukplZ7uC1BFX6Wwr+h9CmYs
	pHsNtdKssoMN0iEGlrIT64yztkYhojkuWAaa14iAGB8H4aJYI6eJ1lUDzr3VhtGE8OEZPGvVgIK
	pODH/9z3KQYDJrdKJGYxyNct3FLRAUK9udR/724YKEdX37ICyRYj7RLS9gqqNCUXbAHUpcRKhoZ
	6K8RWKJ9so2C4aHwzRm7uVDfTDoPKzcS4Wk5Q9pJEwTMa1rtuJxTIKZhNHIUUvkDukG5pnC6g5h
	dMVR37pisicNogIB+zgikIAo8mEiy9MUXruRL5TcXaPNlnLmD9+LHgq+I0UFUhuWDIbWFoKGidf
	Px+vRxjy4/y63P3X7YGufkHq96XewCFaevo6P51rfAqU3cdFIxoLkOYbGFreMF/KvCM2ELntc6g
	XYO6ZNxcSW/n2HiGfTVpJNaorti0Z++SOjiMUhuzAu49MEMbIOmaAwB6iNDcafyVALUHOKdyR2O
	5V6GzkKea3QQM9Fo7t7Vz7n7HZTQNUPn0AoSZMxywer9hY4bfcZstvvToDVYV5pWp5rp5z2u68R
	/MEAoyt5rycpJ1NUbvqh8+7LWR1hhajWhRz4YHFVjCz8fqa3MMgQqd2/effvnhDOuC0BtH6tNSV
	O8h8aQ0yG+I+PXSepXhozhOhRNCNEqtnM0yDegW9bus/xyemQb5Y/DOme9LTbgpz1
X-Received: by 2002:a05:6102:5811:b0:7cc:2c29:54f0 with SMTP id ada2fe7eead31-7d072238fbamr1525259137.4.1793384149876;
        Fri, 30 Oct 2026 11:15:49 -0700 (PDT)
Received: from worldpeace10.c.googlers.com.com (109.243.150.34.bc.googleusercontent.com. [34.150.243.109])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7d07754c1c6sm3077931137.3.2026.10.30.11.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 11:15:49 -0700 (PDT)
From: David Hu <dhu@x6u.co>
To: Mustafa Ismail <mustafa.ismail@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jacob Moroni <jmoroni@google.com>,
	intel-wired-lan@lists.osuosl.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	David Hu <xuehaohu@google.com>
Subject: [PATCH rdma-next v4 4/6] RDMA/irdma: Split CQ setup to umode and kmode
Date: Fri, 30 Oct 2026 18:15:10 +0000
Message-ID: <20261030181512.2056056-5-dhu@x6u.co>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
In-Reply-To: <20261030181512.2056056-1-dhu@x6u.co>
References: <20261030181512.2056056-1-dhu@x6u.co>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Hu <xuehaohu@google.com>

Add user mode cq callback `irdma_create_user_cq()` to separate out user
mode creation logic from kernel mode cq.

Original common setup logic is broken into shared helper routines, so
duplicate code can be avoided. Core creation logic is preserved to be
identical to original routine, however.

Signed-off-by: David Hu <xuehaohu@google.com>
---
 drivers/infiniband/hw/irdma/verbs.c | 416 +++++++++++++++++-----------
 1 file changed, 252 insertions(+), 164 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 578c2d4b4d3c..9f4905fdb791 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -2624,41 +2624,198 @@ static inline int cq_validate_flags(u32 flags, u8 hw_rev)
 	return flags & ~IB_UVERBS_CQ_FLAGS_TIMESTAMP_COMPLETION ? -EOPNOTSUPP : 0;
 }
 
-/**
- * irdma_create_cq - create cq
- * @ibcq: CQ allocated
- * @attr: attributes for cq
- * @attrs: uverbs attribute bundle
- */
-static int irdma_create_cq(struct ib_cq *ibcq,
-			   const struct ib_cq_init_attr *attr,
-			   struct uverbs_attr_bundle *attrs)
+static int __irdma_create_cq(struct irdma_device *iwdev,
+			     struct irdma_cq *iwcq,
+			     struct irdma_cq_init_info *info,
+			     struct ib_udata *udata)
 {
-#define IRDMA_CREATE_CQ_MIN_RESP_LEN offsetofend(struct irdma_create_cq_resp, cq_size)
-	struct ib_udata *udata = &attrs->driver_udata;
-	struct ib_device *ibdev = ibcq->device;
-	struct irdma_device *iwdev = to_iwdev(ibdev);
 	struct irdma_pci_f *rf = iwdev->rf;
-	struct irdma_cq *iwcq = to_iwcq(ibcq);
-	u32 cq_num = 0;
-	struct irdma_sc_cq *cq;
-	struct irdma_sc_dev *dev = &rf->sc_dev;
-	struct irdma_cq_init_info info = {};
 	struct irdma_cqp_request *cqp_request;
+	struct irdma_sc_cq *cq = &iwcq->sc_cq;
 	struct cqp_cmds_info *cqp_info;
-	struct irdma_cq_uk_init_info *ukinfo = &info.cq_uk_init_info;
-	unsigned long flags;
 	int err_code;
+
+	info->shadow_read_threshold = min(info->cq_uk_init_info.cq_size / 2,
+					  (u32)IRDMA_MAX_CQ_READ_THRESH);
+
+	if (irdma_sc_cq_init(cq, info)) {
+		ibdev_dbg(&iwdev->ibdev, "VERBS: init cq fail\n");
+		err_code = -EPROTO;
+		goto cq_free_rsrc;
+	}
+
+	cqp_request = irdma_alloc_and_get_cqp_request(&rf->cqp, true);
+	if (!cqp_request) {
+		err_code = -ENOMEM;
+		goto cq_free_rsrc;
+	}
+
+	cqp_info = &cqp_request->info;
+	cqp_info->cqp_cmd = IRDMA_OP_CQ_CREATE;
+	cqp_info->post_sq = 1;
+	cqp_info->in.u.cq_create.cq = cq;
+	cqp_info->in.u.cq_create.check_overflow = true;
+	cqp_info->in.u.cq_create.scratch = (uintptr_t)cqp_request;
+	err_code = irdma_handle_cqp_op(rf, cqp_request);
+	irdma_put_cqp_request(&rf->cqp, cqp_request);
+	if (err_code)
+		goto cq_free_rsrc;
+
+	if (udata) {
+		struct irdma_create_cq_resp resp = {};
+
+		resp.cq_id = info->cq_uk_init_info.cq_id;
+		resp.cq_size = info->cq_uk_init_info.cq_size;
+		err_code = ib_respond_udata(udata, resp);
+		if (err_code)
+			goto cq_destroy;
+	}
+
+	init_completion(&iwcq->free_cq);
+
+	/* Populate table entry after CQ is fully created. */
+	smp_store_release(&rf->cq_table[iwcq->cq_num], iwcq);
+
+	return 0;
+cq_destroy:
+	irdma_cq_wq_destroy(rf, cq);
+cq_free_rsrc:
+	irdma_cq_free_rsrc(rf, iwcq);
+
+	return err_code;
+}
+
+static int irdma_setup_kmode_cq(struct irdma_device *iwdev,
+				struct irdma_cq *iwcq,
+				struct irdma_cq_init_info *info,
+				const struct ib_cq_init_attr *attr)
+{
+	struct irdma_cq_uk_init_info *ukinfo = &info->cq_uk_init_info;
+	struct irdma_pci_f *rf = iwdev->rf;
+	struct irdma_sc_dev *dev = &rf->sc_dev;
 	int entries = attr->cqe;
 	bool cqe_64byte_ena;
 	u8 cqe_size;
+	int rsize;
 
-	err_code = cq_validate_flags(attr->flags, dev->hw_attrs.uk_attrs.hw_rev);
+	cqe_64byte_ena = dev->hw_attrs.uk_attrs.feature_flags & IRDMA_FEATURE_64_BYTE_CQE ?
+			 true : false;
+	cqe_size = cqe_64byte_ena ? 64 : 32;
+
+	entries += 2;
+	if (!cqe_64byte_ena && dev->hw_attrs.uk_attrs.hw_rev >= IRDMA_GEN_2)
+		entries *= 2;
+
+	if (entries & 1)
+		entries += 1; /* cq size must be an even number */
+
+	if (entries * cqe_size == IRDMA_HW_PAGE_SIZE)
+		entries += 2;
+
+	ukinfo->cq_size = entries;
+
+	if (cqe_64byte_ena)
+		rsize = ukinfo->cq_size * sizeof(struct irdma_extended_cqe);
+	else
+		rsize = ukinfo->cq_size * sizeof(struct irdma_cqe);
+	iwcq->kmem.size = ALIGN(round_up(rsize, 256), 256);
+	iwcq->kmem.va = dma_alloc_coherent(dev->hw->device,
+					   iwcq->kmem.size,
+					   &iwcq->kmem.pa, GFP_KERNEL);
+	if (!iwcq->kmem.va)
+		return -ENOMEM;
+
+	iwcq->kmem_shadow.size = ALIGN(IRDMA_SHADOW_AREA_SIZE << 3, 64);
+	iwcq->kmem_shadow.va = dma_alloc_coherent(dev->hw->device,
+						  iwcq->kmem_shadow.size,
+						  &iwcq->kmem_shadow.pa,
+						  GFP_KERNEL);
+	if (!iwcq->kmem_shadow.va)
+		return -ENOMEM;
+
+	info->shadow_area_pa = iwcq->kmem_shadow.pa;
+	ukinfo->shadow_area = iwcq->kmem_shadow.va;
+	ukinfo->cq_base = iwcq->kmem.va;
+	info->cq_base_pa = iwcq->kmem.pa;
+
+	return 0;
+}
+
+static int irdma_setup_umode_cq(struct irdma_device *iwdev,
+				struct irdma_cq *iwcq,
+				struct irdma_cq_init_info *info,
+				struct uverbs_attr_bundle *attrs)
+{
+	struct ib_udata *udata = &attrs->driver_udata;
+	struct irdma_create_cq_req req = {};
+	struct irdma_pci_f *rf = iwdev->rf;
+	struct irdma_ucontext *ucontext;
+	struct irdma_cq_mr *cqmr_shadow;
+	struct irdma_cq_mr *cqmr;
+	unsigned long flags;
+	int err_code;
+
+	iwcq->user_mode = true;
+	ucontext = rdma_udata_to_drv_context(udata, struct irdma_ucontext,
+					     ibucontext);
+	/* Even though the last member of struct irdma_create_cq_req
+	 * was always user_shadow_area, we need backwards compat with
+	 * the legacy i40iw struct i40iw_ucreate_cq which stopped
+	 * at user_cq_buffer.
+	 */
+	err_code = ib_copy_validate_udata_in(udata, req, user_cq_buf);
 	if (err_code)
 		return err_code;
 
-	if (udata && udata->outlen < IRDMA_CREATE_CQ_MIN_RESP_LEN)
-		return -EINVAL;
+	spin_lock_irqsave(&ucontext->cq_reg_mem_list_lock, flags);
+	iwcq->iwpbl = irdma_get_pbl((unsigned long)req.user_cq_buf,
+				    &ucontext->cq_reg_mem_list);
+	spin_unlock_irqrestore(&ucontext->cq_reg_mem_list_lock, flags);
+	if (!iwcq->iwpbl)
+		return -EPROTO;
+
+	cqmr = &iwcq->iwpbl->cq_mr;
+
+	if (rf->sc_dev.hw_attrs.uk_attrs.feature_flags &
+	    IRDMA_FEATURE_CQ_RESIZE) {
+		spin_lock_irqsave(&ucontext->cq_reg_mem_list_lock, flags);
+		iwcq->iwpbl_shadow =
+			irdma_get_pbl((unsigned long)req.user_shadow_area,
+				      &ucontext->cq_reg_mem_list);
+		spin_unlock_irqrestore(&ucontext->cq_reg_mem_list_lock, flags);
+
+		if (!iwcq->iwpbl_shadow)
+			return -EPROTO;
+
+		cqmr_shadow = &iwcq->iwpbl_shadow->cq_mr;
+		info->shadow_area_pa = cqmr_shadow->cq_pbl.addr;
+	} else {
+		info->shadow_area_pa = cqmr->shadow;
+	}
+	if (iwcq->iwpbl->pbl_allocated) {
+		info->virtual_map = true;
+		info->pbl_chunk_size = 1;
+		info->first_pm_pbl_idx = cqmr->cq_pbl.idx;
+	} else {
+		info->cq_base_pa = cqmr->cq_pbl.addr;
+	}
+
+	return 0;
+}
+
+static int irdma_alloc_cq(struct irdma_device *iwdev,
+			  struct irdma_cq *iwcq,
+			  const struct ib_cq_init_attr *attr,
+			  struct irdma_cq_init_info *info)
+{
+	struct irdma_cq_uk_init_info *ukinfo = &info->cq_uk_init_info;
+	struct irdma_pci_f *rf = iwdev->rf;
+	struct irdma_sc_dev *dev = &rf->sc_dev;
+	int entries = attr->cqe;
+	struct irdma_sc_cq *cq;
+	bool cqe_64byte_ena;
+	u32 cq_num = 0;
+	int err_code;
 
 	err_code = irdma_alloc_rsrc(rf, rf->allocated_cqs, rf->max_cq, &cq_num,
 				    &rf->next_cq);
@@ -2674,169 +2831,99 @@ static int irdma_create_cq(struct ib_cq *ibcq,
 	iwcq->cq_num = cq_num;
 	iwcq->iwpbl = NULL;
 	iwcq->iwpbl_shadow = NULL;
-	info.dev = dev;
+	info->dev = dev;
 	ukinfo->cq_size = max(entries, 4);
 	ukinfo->cq_id = cq_num;
 	cqe_64byte_ena = dev->hw_attrs.uk_attrs.feature_flags & IRDMA_FEATURE_64_BYTE_CQE ?
 			 true : false;
-	cqe_size = cqe_64byte_ena ? 64 : 32;
 	ukinfo->avoid_mem_cflct = cqe_64byte_ena;
-	iwcq->ibcq.cqe = info.cq_uk_init_info.cq_size;
+	iwcq->ibcq.cqe = ukinfo->cq_size;
 	if (attr->comp_vector < rf->ceqs_count)
-		info.ceq_id = attr->comp_vector;
-	info.ceq_id_valid = true;
-	info.ceqe_mask = 1;
-	info.type = IRDMA_CQ_TYPE_IWARP;
-	info.vsi = &iwdev->vsi;
-
-	if (udata) {
-		struct irdma_ucontext *ucontext;
-		struct irdma_create_cq_req req = {};
-		struct irdma_cq_mr *cqmr;
-		struct irdma_cq_mr *cqmr_shadow;
-
-		iwcq->user_mode = true;
-		ucontext =
-			rdma_udata_to_drv_context(udata, struct irdma_ucontext,
-						  ibucontext);
-		/* Even though the last member of struct irdma_create_cq_req
-		 * was always user_shadow_area, we need backwards compat with
-		 * the legacy i40iw struct i40iw_ucreate_cq which stopped
-		 * at user_cq_buffer.
-		 */
-		err_code = ib_copy_validate_udata_in(udata, req, user_cq_buf);
-		if (err_code)
-			goto cq_free_rsrc;
-
-		spin_lock_irqsave(&ucontext->cq_reg_mem_list_lock, flags);
-		iwcq->iwpbl = irdma_get_pbl((unsigned long)req.user_cq_buf,
-					    &ucontext->cq_reg_mem_list);
-		spin_unlock_irqrestore(&ucontext->cq_reg_mem_list_lock, flags);
-		if (!iwcq->iwpbl) {
-			err_code = -EPROTO;
-			goto cq_free_rsrc;
-		}
+		info->ceq_id = attr->comp_vector;
+	info->ceq_id_valid = true;
+	info->ceqe_mask = 1;
+	info->type = IRDMA_CQ_TYPE_IWARP;
+	info->vsi = &iwdev->vsi;
 
-		cqmr = &iwcq->iwpbl->cq_mr;
-
-		if (rf->sc_dev.hw_attrs.uk_attrs.feature_flags &
-		    IRDMA_FEATURE_CQ_RESIZE) {
-			spin_lock_irqsave(&ucontext->cq_reg_mem_list_lock, flags);
-			iwcq->iwpbl_shadow = irdma_get_pbl(
-					(unsigned long)req.user_shadow_area,
-					&ucontext->cq_reg_mem_list);
-			spin_unlock_irqrestore(&ucontext->cq_reg_mem_list_lock, flags);
+	return 0;
+}
 
-			if (!iwcq->iwpbl_shadow) {
-				err_code = -EPROTO;
-				goto cq_free_rsrc;
-			}
-			cqmr_shadow = &iwcq->iwpbl_shadow->cq_mr;
-			info.shadow_area_pa = cqmr_shadow->cq_pbl.addr;
-		} else {
-			info.shadow_area_pa = cqmr->shadow;
-		}
-		if (iwcq->iwpbl->pbl_allocated) {
-			info.virtual_map = true;
-			info.pbl_chunk_size = 1;
-			info.first_pm_pbl_idx = cqmr->cq_pbl.idx;
-		} else {
-			info.cq_base_pa = cqmr->cq_pbl.addr;
-		}
-	} else {
-		/* Kmode allocations */
-		int rsize;
+/**
+ * irdma_create_user_cq - create user cq
+ * @ibcq: CQ allocated
+ * @attr: attributes for cq
+ * @attrs: uverbs attribute bundle
+ */
+static int irdma_create_user_cq(struct ib_cq *ibcq,
+				const struct ib_cq_init_attr *attr,
+				struct uverbs_attr_bundle *attrs)
+{
+#define IRDMA_CREATE_CQ_MIN_RESP_LEN offsetofend(struct irdma_create_cq_resp, cq_size)
+	struct ib_udata *udata = &attrs->driver_udata;
+	struct ib_device *ibdev = ibcq->device;
+	struct irdma_device *iwdev = to_iwdev(ibdev);
+	struct irdma_pci_f *rf = iwdev->rf;
+	struct irdma_cq *iwcq = to_iwcq(ibcq);
+	struct irdma_sc_dev *dev = &rf->sc_dev;
+	struct irdma_cq_init_info info = {};
+	int err_code;
 
-		if (entries < 1 || entries > rf->max_cqe) {
-			err_code = -EINVAL;
-			goto cq_free_rsrc;
-		}
+	err_code = cq_validate_flags(attr->flags, dev->hw_attrs.uk_attrs.hw_rev);
+	if (err_code)
+		return err_code;
 
-		entries += 2;
-		if (!cqe_64byte_ena && dev->hw_attrs.uk_attrs.hw_rev >= IRDMA_GEN_2)
-			entries *= 2;
+	if (udata->outlen < IRDMA_CREATE_CQ_MIN_RESP_LEN)
+		return -EINVAL;
 
-		if (entries & 1)
-			entries += 1; /* cq size must be an even number */
+	err_code = irdma_alloc_cq(iwdev, iwcq, attr, &info);
+	if (err_code)
+		return err_code;
 
-		if (entries * cqe_size == IRDMA_HW_PAGE_SIZE)
-			entries += 2;
+	err_code = irdma_setup_umode_cq(iwdev, iwcq, &info, attrs);
+	if (err_code)
+		goto cq_free_rsrc;
 
-		ukinfo->cq_size = entries;
+	return __irdma_create_cq(iwdev, iwcq, &info, udata);
+cq_free_rsrc:
+	irdma_cq_free_rsrc(rf, iwcq);
 
-		if (cqe_64byte_ena)
-			rsize = info.cq_uk_init_info.cq_size * sizeof(struct irdma_extended_cqe);
-		else
-			rsize = info.cq_uk_init_info.cq_size * sizeof(struct irdma_cqe);
-		iwcq->kmem.size = ALIGN(round_up(rsize, 256), 256);
-		iwcq->kmem.va = dma_alloc_coherent(dev->hw->device,
-						   iwcq->kmem.size,
-						   &iwcq->kmem.pa, GFP_KERNEL);
-		if (!iwcq->kmem.va) {
-			err_code = -ENOMEM;
-			goto cq_free_rsrc;
-		}
+	return err_code;
+}
 
-		iwcq->kmem_shadow.size = ALIGN(IRDMA_SHADOW_AREA_SIZE << 3,
-					       64);
-		iwcq->kmem_shadow.va = dma_alloc_coherent(dev->hw->device,
-							  iwcq->kmem_shadow.size,
-							  &iwcq->kmem_shadow.pa,
-							  GFP_KERNEL);
-		if (!iwcq->kmem_shadow.va) {
-			err_code = -ENOMEM;
-			goto cq_free_rsrc;
-		}
-		info.shadow_area_pa = iwcq->kmem_shadow.pa;
-		ukinfo->shadow_area = iwcq->kmem_shadow.va;
-		ukinfo->cq_base = iwcq->kmem.va;
-		info.cq_base_pa = iwcq->kmem.pa;
-	}
+/**
+ * irdma_create_cq - create kmode cq
+ * @ibcq: CQ allocated
+ * @attr: attributes for cq
+ * @attrs: uverbs attribute bundle
+ */
+static int irdma_create_cq(struct ib_cq *ibcq,
+			   const struct ib_cq_init_attr *attr,
+			   struct uverbs_attr_bundle *attrs)
+{
+	struct ib_device *ibdev = ibcq->device;
+	struct irdma_device *iwdev = to_iwdev(ibdev);
+	struct irdma_pci_f *rf = iwdev->rf;
+	struct irdma_cq *iwcq = to_iwcq(ibcq);
+	struct irdma_sc_dev *dev = &rf->sc_dev;
+	struct irdma_cq_init_info info = {};
+	int err_code;
 
-	info.shadow_read_threshold = min(info.cq_uk_init_info.cq_size / 2,
-					 (u32)IRDMA_MAX_CQ_READ_THRESH);
+	err_code = cq_validate_flags(attr->flags, dev->hw_attrs.uk_attrs.hw_rev);
+	if (err_code)
+		return err_code;
 
-	if (irdma_sc_cq_init(cq, &info)) {
-		ibdev_dbg(&iwdev->ibdev, "VERBS: init cq fail\n");
-		err_code = -EPROTO;
-		goto cq_free_rsrc;
-	}
+	if (attr->cqe > rf->max_cqe)
+		return -EINVAL;
 
-	cqp_request = irdma_alloc_and_get_cqp_request(&rf->cqp, true);
-	if (!cqp_request) {
-		err_code = -ENOMEM;
-		goto cq_free_rsrc;
-	}
+	err_code = irdma_alloc_cq(iwdev, iwcq, attr, &info);
+	if (err_code)
+		return err_code;
 
-	cqp_info = &cqp_request->info;
-	cqp_info->cqp_cmd = IRDMA_OP_CQ_CREATE;
-	cqp_info->post_sq = 1;
-	cqp_info->in.u.cq_create.cq = cq;
-	cqp_info->in.u.cq_create.check_overflow = true;
-	cqp_info->in.u.cq_create.scratch = (uintptr_t)cqp_request;
-	err_code = irdma_handle_cqp_op(rf, cqp_request);
-	irdma_put_cqp_request(&rf->cqp, cqp_request);
+	err_code = irdma_setup_kmode_cq(iwdev, iwcq, &info, attr);
 	if (err_code)
 		goto cq_free_rsrc;
 
-	if (udata) {
-		struct irdma_create_cq_resp resp = {};
-
-		resp.cq_id = info.cq_uk_init_info.cq_id;
-		resp.cq_size = info.cq_uk_init_info.cq_size;
-		err_code = ib_respond_udata(udata, resp);
-		if (err_code)
-			goto cq_destroy;
-	}
-
-	init_completion(&iwcq->free_cq);
-
-	/* Populate table entry after CQ is fully created. */
-	smp_store_release(&rf->cq_table[cq_num], iwcq);
-
-	return 0;
-cq_destroy:
-	irdma_cq_wq_destroy(rf, cq);
+	return __irdma_create_cq(iwdev, iwcq, &info, NULL);
 cq_free_rsrc:
 	irdma_cq_free_rsrc(rf, iwcq);
 
@@ -5643,6 +5730,7 @@ static const struct ib_device_ops irdma_dev_ops = {
 	.alloc_pd = irdma_alloc_pd,
 	.alloc_ucontext = irdma_alloc_ucontext,
 	.create_cq = irdma_create_cq,
+	.create_user_cq = irdma_create_user_cq,
 	.create_qp = irdma_create_qp,
 	.dealloc_driver = irdma_ib_dealloc_device,
 	.dealloc_mw = irdma_dealloc_mw,
-- 
2.56.0.317.g454f8302e1-goog

