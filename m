Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3F83D890C
	for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 20:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792182573; cv=none; b=llI9ONZVzIHvGpQK4OtlNnvgGemtyTEB2iPcyq+73y33582n/4xFgjQYtVknED1VrTpuHMdWN5Eam23cF59aJwN7VJwAak/sV9VbJaxzFY6zANH8DX0i8hYiLrS81I9zekYp7nXy0YaMxxcQQQfcCgDEEIe0Tw5Wom/Xbm3iLMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792182573; c=relaxed/simple;
	bh=xgEStLslfQPMjZnooRLRK8S4BMeTa/0LAVDhtTaaehs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UzpPD5EBJx8FyrfD4YBz+TKpueXLboeu5d0jkk/xilPwbAxj2E/OvXef5N6oLU1XM59/qs5/3gkvbytWG1i8sldUhE0YEWDZB1OaxLRpM9RIEDJHVzB2ytyh+vxLKwu0uczNOuQT2qpGC2kABJ/Bfc95P3Yrb6AOIGIRnM1wHiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co; spf=pass smtp.mailfrom=x6u.co; dkim=pass (2048-bit key) header.d=x6u.co header.i=@x6u.co header.b=AiCQ88TD; arc=none smtp.client-ip=209.85.221.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=x6u.co
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=x6u.co header.i=@x6u.co header.b="AiCQ88TD"
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-5e4d95e3e55so105771e0c.2
        for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 13:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=x6u.co; s=google; t=1792182570; x=1792787370; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qgw1gJm850N72xDilEGxgT4UaYfpe5IwHe5ARqnjdes=;
        b=AiCQ88TDpPGE+ysMmAM842D/I4EujGrE85UufOYAvZ1xnjSV0Qdd92r5lUukW7QQvX
         FpsIotpjc3mTsranLVKHaXTCZIAC+6GZSSzOfvSzqRoGQu8wclcrPzy3v8nTtMIu0Tpn
         vPJ2eB2hzMs74ZhG+6YX7smcSaBauk+CXMZ/WJuOzdzSJK1F8kKAKAORgYCI3UJ1tgCN
         AoVMQedSO2paggHiLsOte+KEmvm/aDE5UjzxdhADM9HjGWmy4HQuNQy6EZQZyzvC2Snt
         //FTrEcrQm0fOi3W8UUtsJokgCnsFaZ5NjHfsswmZ4uAnKm7ekyT4lHPJ+L2KaDbuCr4
         4RVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792182570; x=1792787370;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qgw1gJm850N72xDilEGxgT4UaYfpe5IwHe5ARqnjdes=;
        b=m26z731X1Hfo8zGNCBHA/cC1KLYxNN65pYaXcHJtsJm3CIi5QD3UGhFZWcbWgiDUI6
         jAAHgkJXKoaPBVh90uISMCL4eGr3C1iAJDGInHrc1ov8/65zh9u/7SGH9diWvmSy3cT8
         /KMMirRiKxnzWgvGABLLD+SH9MyZwsg4EnYYOiNuBuKbm6y188jnpzPwB6KSgLBtop+l
         HKh5ZqOlFAFPsjbR+WZc/4LskE/ZWgik1ZohE3Vuss44XCI337sGZKbXAw0XFj0Hp2Af
         khq25ubrPj2SktGfgCXZNA3ng/Yk24Sug6F5Yv/Wv0FLtCct62qu+V750BfXcCjNedpX
         x2fg==
X-Gm-Message-State: AFq9FYLLqU3xporB8lBuQv4ckXlNlTvsxgiwzDAdTDK2kpB4ZRtSa3r6
	ACmAxfqvSezMvnsjSUecr8Qbd9us1nmFGIczpwQttgttXKu6LoCwH+3XnVNDblFJnFQs
X-Gm-Gg: AYBFou2k5qtzlEzHp1oYUa44BT36301aO7AfSK9Eo4X0fS+Zt9wkVeF9wI63tKs2REn
	FC6H5s8aRWukEcAcn0tQ9mA43UYQf4NFe7UgJlpcHkhJCZF8t5A8cpFz82cO6rCWC2gFwqhGOvw
	S2hQmQdRAXghmWDNnC1SH+FLOYobp1ezSUoSy4/iuE68TEdddPlSxV/DeVCpxjlkt5H60N+OFKX
	PCvsl5B4kT+Y3ECAmYRhiqcz+52eqaB0rLbEXWWFEdmc1Pu17bKMjlXDIRDWig8vIW8SWzzg7JM
	XyDR4ZxkU9H3PLFI7JHLSTKM0lI53YBbYzxdGWjzge909XQpaQvkH0vZtIZnxSuZNSfSa00E9sZ
	yODYTx8UEjyV0QfQogXntLMHCMpBlF/TmQboMPjxDktdiXYr8oGypfl5g0OO/kldxUw+voI5Pug
	iZ6QgXqVXB+BB7hl9otEVvVvjLkPXU3HqFXpfczHVh806yofQReI9HJV3iftYssf4TWxtN6Dobu
	2RivPnTuwEx+Yq6yL9OiNtTtUvZRb1LxR8QRaFUOfTeGP+ZHXxqPm2YUUBxC9e/P1zm12bxOWR+
	nBj3wk+XFw==
X-Received: by 2002:a05:6102:5488:b0:7cc:2086:34cc with SMTP id ada2fe7eead31-7cc369c0cd8mr206230137.16.1792182569588;
        Fri, 16 Oct 2026 13:29:29 -0700 (PDT)
Received: from worldpeace10.c.googlers.com.com (119.20.221.35.bc.googleusercontent.com. [35.221.20.119])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ea9b5201b1sm2588281e0c.12.2026.10.16.13.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 13:29:29 -0700 (PDT)
From: David Hu <dhu@x6u.co>
To: Mustafa Ismail <mustafa.ismail@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	David Hu <xuehaohu@google.com>
Subject: [PATCH rdma-next v3 1/6] RDMA/irdma: Plumb uverbs_attr_bundle for QP, SRQ
Date: Fri, 16 Oct 2026 20:29:04 +0000
Message-ID: <20261016202909.1289496-2-dhu@x6u.co>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261016202909.1289496-1-dhu@x6u.co>
References: <20261016202909.1289496-1-dhu@x6u.co>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Hu <xuehaohu@google.com>

In preparation to support modern UVERBS ioctl attributes (such
as UVERBS_ATTR_UMEM for CoCo DMA bounce buffers), we pass down
`uverbs_attr_bundle` for inner QP, SRQ routines. Since standard
uAPIs provide `ib_udata`, we derive it via the helper macro,
`rdma_udata_to_uverbs_attr_bundle`. `irdma_create_cq()` supports
`uverbs_attr_bundle` already, therefore, this patch fills the gap for QP
and SRQ.

QP, SRQ uAPI will now have `ib_udata`, and CQ uAPI has `uverbs_attr_bundle`
as a top level input. However, we think it is a future project to unify
them.

Signed-off-by: David Hu <xuehaohu@google.com>
---
 drivers/infiniband/hw/irdma/verbs.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 71d7ae7baa47..10c790fdfc57 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -637,13 +637,15 @@ static void irdma_setup_virt_qp(struct irdma_device *iwdev,
  * @iwqp: qp ptr (user or kernel)
  * @info: initialize info to return
  * @init_attr: Initial QP create attributes
+ * @attrs: uverbs attribute bundle
  */
 static int irdma_setup_umode_qp(struct irdma_ucontext *ucontext,
 				struct irdma_create_qp_req *req,
 				struct irdma_device *iwdev,
 				struct irdma_qp *iwqp,
 				struct irdma_qp_init_info *info,
-				struct ib_qp_init_attr *init_attr)
+				struct ib_qp_init_attr *init_attr,
+				struct uverbs_attr_bundle *attrs)
 {
 	struct irdma_qp_uk_init_info *ukinfo = &info->qp_uk_init_info;
 	unsigned long flags;
@@ -981,10 +983,14 @@ static int irdma_create_qp(struct ib_qp *ibqp,
 	struct irdma_qp_init_info init_info = {};
 	struct irdma_qp_host_ctx_info *ctx_info;
 	struct irdma_create_qp_req ureq = {};
+	struct uverbs_attr_bundle *attrs = NULL;
 	struct irdma_srq *iwsrq;
 	bool srq_valid = false;
 	u32 srq_id = 0;
 
+	if (udata)
+		attrs = rdma_udata_to_uverbs_attr_bundle(udata);
+
 	if (init_attr->srq) {
 		iwsrq = to_iwsrq(init_attr->srq);
 		srq_valid = true;
@@ -1071,7 +1077,7 @@ static int irdma_create_qp(struct ib_qp *ibqp,
 
 		init_info.qp_uk_init_info.abi_ver = iwpd->sc_pd.abi_ver;
 		err_code = irdma_setup_umode_qp(ucontext, &ureq, iwdev, iwqp,
-						&init_info, init_attr);
+						&init_info, init_attr, attrs);
 	} else {
 		INIT_DELAYED_WORK(&iwqp->dwork_flush, irdma_flush_worker);
 		init_info.qp_uk_init_info.abi_ver = IRDMA_ABI_VER;
@@ -2337,7 +2343,8 @@ static int irdma_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 static int irdma_setup_umode_srq(struct irdma_device *iwdev,
 				 struct irdma_srq *iwsrq,
 				 struct irdma_srq_init_info *info,
-				 struct ib_udata *udata)
+				 struct ib_udata *udata,
+				 struct uverbs_attr_bundle *attrs)
 {
 	struct irdma_create_srq_req req = {};
 	struct irdma_ucontext *ucontext;
@@ -2420,6 +2427,7 @@ static int irdma_create_srq(struct ib_srq *ibsrq,
 	struct ib_srq_attr *attr = &initattrs->attr;
 	struct irdma_pd *iwpd = to_iwpd(ibsrq->pd);
 	struct irdma_srq *iwsrq = to_iwsrq(ibsrq);
+	struct uverbs_attr_bundle *attrs = NULL;
 	struct irdma_srq_uk_init_info *ukinfo;
 	struct irdma_cqp_request *cqp_request;
 	struct irdma_srq_init_info info = {};
@@ -2430,6 +2438,9 @@ static int irdma_create_srq(struct ib_srq *ibsrq,
 	u32 depth;
 	u8 shift;
 
+	if (udata)
+		attrs = rdma_udata_to_uverbs_attr_bundle(udata);
+
 	uk_attrs = &rf->sc_dev.hw_attrs.uk_attrs;
 	ukinfo = &info.srq_uk_init_info;
 
@@ -2470,7 +2481,7 @@ static int irdma_create_srq(struct ib_srq *ibsrq,
 	attr->max_wr = iwsrq->max_wr;
 
 	if (udata)
-		err_code = irdma_setup_umode_srq(iwdev, iwsrq, &info, udata);
+		err_code = irdma_setup_umode_srq(iwdev, iwsrq, &info, udata, attrs);
 	else
 		err_code = irdma_setup_kmode_srq(iwdev, iwsrq, &info, depth,
 						 shift);
-- 
2.56.0.176.g3575e65682-goog

