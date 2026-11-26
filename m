Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795719237;
	b=i9JdR4OjQ4nBjJzToe1nt7gEDJvcEoMZUivl4ppwz/2m9JLM8gcDiw57mgfWahoD3A6f
	 MZZ3PCC37shbwfMwesqX2zniCGDUv8IOANvsuEs8WsMmEbJWPhdiOP2YisR68XEnFHtiO
	 dcEUss9/0uoeZvOh+ZfFi5XBnAUcygZVCsnVxHP5SGVXWN29Jzm7FmwKHQ5RMYVdhiR15
	 6/alRrxcWIDONFs1eziG2L49kldOAG+8qOSfa6nSYLi0xioTSBT0xFi7DJCuKwcZNND8H
	 GWTNwKwcX95oMYDMzX6XLzYKJjTS4d/BK+VUcxfDaqvMPuSsBWMrskPBZTFs9IUqgeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795719237;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=xx54c/YrKUGoOzZzBwsQKcCC5vdStUmPtFn8xMOsAMc=;
	b=BdNLMKPWhIZAS1u1azIVHMkZ/vpBWipjNCBJNY0ESVVYdW9DMarjg5pvVQvQxGljQpMX
	 QDGnvM/Do7sFVWA6ebPydNBjG5ILKQT7B8Jf3OkMsnL9KvN6VCBYF2mLVOMNo4Dyek35V
	 sjSgZIleA2AdcTnXa8cpKvYaTkJDLQD1R94DLoCvXl+H+rLANa+5ZRsgO7w0CyT+TKnxc
	 rxLOiVbcKEg8Mq1e2zdZA5ecqyuMsoJ0NcbQlVXcMFb08UaLjK6IiCSIT+ILGiW+irNos
	 TDiBQKry9T+Qh5Drgjkpfzwhh5dGzmBjx/kVXRLlAKlN4gIeDg4L3P5npmWTkbgX89Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=M3Kw4uIZ;
	arc=none smtp.remote-ip=74.125.224.72
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com [74.125.224.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69B1606A323
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 18:53:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A69B1606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=M3Kw4uIZ
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-677deb12bceso10938379d50.0
        for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 10:53:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795719236; x=1796324036; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xx54c/YrKUGoOzZzBwsQKcCC5vdStUmPtFn8xMOsAMc=;
        b=M3Kw4uIZdjNxPbGJPbB+Jike/X7MWfqb2FbHDug8/l1t8BA9EivcpwQl4EqHJFx2wY
         6sSAx2HFEdNC2zDJl8oShJyDq83bqH5ZiJF0ctjK0SSSmFbVWdu1U9tBSdV/7exi9SrD
         A+cr9ZUQdLoGo6HFv3zOJ6B7Wga20BVPxYnbvtmY9/srKaG4siOdAOMzQNKXHV1AyGXS
         6GLhNTUe9/79yiIBy2z0wPCzazOdrFKRxWEouyoM5GVRK9zgH7bPvHwIx7kR+5o8QDuX
         nd8kiYWMTqbeZy38GQmzjWJxM1Z2w/1GZs4v2XTDYSnrR4hi5B8Bj0Imm++12OCDBo2R
         wYvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795719236; x=1796324036;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xx54c/YrKUGoOzZzBwsQKcCC5vdStUmPtFn8xMOsAMc=;
        b=doxlIYEedHPjuB+BBPbAPo5MiL4cNrre9MZQwD9Rf3NjHMFLYtmdEmBnkztno5GvgS
         +ySuwLB4JFvZM6nBUolMsvm7dTBNZG06oW9fQ7uRFFtlEIr1zcbRPJ/BWw5YgVtnlbu0
         9zNSaznhT7AMOdr3oKoRpMD7ZKOu+WIqhTrlQ0yeqOm2Xvn3Q571oFJheuP1EtRh/o4x
         x5jSVXf/5N+V6s0HowUipKjJ14mFwMBbENXKCqiXz85ruHj6h6q9n/xd9mDkbjaSS5zf
         VAQgaR7JifH5tmLcrfvBHrDu6VCgN37YhAOVzf5+DN18ToLJvAYR2ecpiVTz3Nk3zVO3
         x/Dw==
X-Gm-Message-State: APuU4Z96FMTFfLqWtdUGKHAy6KbAaWeWTMp3tMZnP5MTPQd+qLAMjYpw
	/VhX7tqitsNApzQpsY4+XS/MZTjV2uTPVzkMCQJQkawHkr+QDDntCuPavmW1g/L5rpHho88qyTK
	dNLMrlIYItQ==
X-Received: from yxoo15.prod.google.com ([2002:a05:690e:24cf:b0:67d:aba9:9204])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a05:690e:12c7:b0:67d:bff8:c405
 with SMTP id 956f58d0204a3-67df42b57d5mr8132876d50.5.1795719235398; Thu, 26
 Nov 2026 10:53:55 -0800 (PST)
Date: Thu, 26 Nov 2026 18:53:44 +0000
In-Reply-To: <20261126185344.2784303-1-jmoroni@google.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261126185344.2784303-1-jmoroni@google.com>
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
Message-ID: <20261126185344.2784303-2-jmoroni@google.com>
Subject: [PATCH rdma-next 2/2] RDMA/irdma: Scrub software flush completions on
 QP destroy
From: Jacob Moroni <jmoroni@google.com>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, Owen Gentry <owengentry@google.com>, 
	Jacob Moroni <jmoroni@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Owen Gentry <owengentry@google.com>

When a kernel QP transitions to error state, irdma_flush_worker() can
append software-generated flush completions. During QP teardown,
irdma scrubs HW CQEs but leaves SW CQEs intact, causing subsequent
CQ polling to dereference the freed QP.

In addition, _irdma_destroy_qp() calls irdma_modify_qp_to_err() before
cancelling iwqp->dwork_flush with cancel_delayed_work_sync(), which
needlessly arms the flush work during teardown and leaves a window where
concurrent paths can re-schedule dwork_flush after CQEs are scrubbed and
before the QP is freed.

Disable and drain iwqp->dwork_flush via disable_delayed_work_sync()
before calling irdma_modify_qp_to_err(), and free matching SW CQEs from
iwcq->cmpl_generated in irdma_clean_cqes().

Fixes: 81091d7696ae ("RDMA/irdma: Add SW mechanism to generate completions on error")
Signed-off-by: Owen Gentry <owengentry@google.com>
Signed-off-by: Jacob Moroni <jmoroni@google.com>
---
 drivers/infiniband/hw/irdma/verbs.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 29ccd19da032..04ebba436eea 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -514,10 +514,17 @@ static struct irdma_pbl *irdma_get_pbl(unsigned long va,
 static void irdma_clean_cqes(struct irdma_qp *iwqp, struct irdma_cq *iwcq)
 {
 	struct irdma_cq_uk *ukcq = &iwcq->sc_cq.cq_uk;
+	struct irdma_cmpl_gen *cmpl, *tmp;
 	unsigned long flags;
 
 	spin_lock_irqsave(&iwcq->lock, flags);
 	irdma_uk_clean_cq(&iwqp->sc_qp.qp_uk, ukcq);
+	list_for_each_entry_safe(cmpl, tmp, &iwcq->cmpl_generated, list) {
+		if (cmpl->cpi.qp_handle != &iwqp->sc_qp.qp_uk)
+			continue;
+		list_del(&cmpl->list);
+		kfree(cmpl);
+	}
 	spin_unlock_irqrestore(&iwcq->lock, flags);
 }
 
@@ -577,12 +584,12 @@ static void _irdma_destroy_qp(struct ib_qp *ibqp)
 
 	iwqp->sc_qp.qp_uk.destroy_pending = true;
 
+	if (!iwqp->user_mode)
+		disable_delayed_work_sync(&iwqp->dwork_flush);
+
 	if (iwqp->iwarp_state >= IRDMA_QP_STATE_IDLE)
 		irdma_modify_qp_to_err(&iwqp->sc_qp);
 
-	if (!iwqp->user_mode)
-		cancel_delayed_work_sync(&iwqp->dwork_flush);
-
 	if (!iwqp->user_mode) {
 		if (iwqp->iwscq) {
 			irdma_clean_cqes(iwqp, iwqp->iwscq);
-- 
2.56.1.839.g22a8290db9-goog

