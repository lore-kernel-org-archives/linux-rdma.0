Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9173C2192F4
	for <linux-rdma@vger.kernel.org>; Wed, 17 Jun 2026 16:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781714417; cv=none; b=GHHlQB1A1r5aFwYx1z94RnJmpuN0O24ampQWdOg5Pm1rIU7Bs2tMTJsNOkm49mTFZb5Zzu8EZm1Mx+mjijVyEldFniRT4U2sQ2oJRrJKqsFFLvM0lre12ArTI2ONodOr3vp8FQIqK0rGXxHuVBdhY5zFjGHAY4POYtdkVwiD4RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781714417; c=relaxed/simple;
	bh=ND/3R3FflrteRpfZ11GZNAwVRBulAFLOPxtSxNOsfkM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ehnnFPYoNMw639wzIB015jnb6GZBaoDCvOG9i086DLUbeU4nlgS45W4H0+e2/V16jZ++1t2VcRwlU68iRKfUiohAM0lcwo1kX6b0uWuxThaqr/p4RjYqAChwYlq/3qIzXUzgmZlsir12bQFw2R/c5fxJEBs8rpdyUnq8vZMc13A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j9MVj3f7; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j9MVj3f7"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-7ff705a4289so307337b3.2
        for <linux-rdma@vger.kernel.org>; Wed, 17 Jun 2026 09:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781714415; x=1782319215; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5svaNNp7cKnsud3bHF5lflk5qficdk4WzHew0OsUOC0=;
        b=j9MVj3f7BY4VsHBYyynF6iPK9hMzicCUaM9/4yP/YtYHDK5iUNhqxB4vfod64kcFj3
         +TEzPfFe/P1Dwm0Ag8JVH43Zy8Ip6viv8A9Vwn9kmvQdPz9g+frO5i0NJDbrfoaF9zLl
         rHNnDk+2LkkzTGOtSbJe1k5QaEfbCm76sS0VeJ6jTujXnVlPiCYpxvNF/fk1JlETi2K5
         C2OUaXG1p/eB7azcVdcdmMJPnaT9zi/sYRUyGvH/JK9SZuNq8rtUTx4rmwRcC2VQLLQy
         mAbxsCu0TjtXZYv1l5aCKulAOdst+MoB2r13exVEl3uqZ4P7vGXnS7dqvJUNoI0sJ/yL
         u/OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781714415; x=1782319215;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5svaNNp7cKnsud3bHF5lflk5qficdk4WzHew0OsUOC0=;
        b=GsJBfj8Y1t0c7zr8QThrwD3x/ZnHs8/qZScIXo+wqPtJ1JS7oNuBdxCiiVLqRUsoxx
         WnMknCc0cdzsy14CkaAZNhcaiSNLWTokMT1uxhMnkYBSY+V3Kif5cMXjIhmq4Y1KYx5a
         bKsQL24gJ7+iTEOyxbguRDfo6bJ/IDsI3c41zcUoBwAVYXVo7iUc1Hw5qfbQ2JpYBWXu
         LKvXdbwG+/zhOJ5VyHBOTDpADB/RL/uzaO2aexVICRfh4Q+bYMReSzOd6rJS6ykHaOtt
         jKsLqZv29csSOAdRXqaoS6iH+nzXFHS97eHsflaaEOX0YC5CDRpyGMSUYCkzdQRLev9U
         p1Tg==
X-Gm-Message-State: AOJu0Yxfb91HVJ7yQcDfTEC+VYDVBeUb+cbXnHAcFqonIP56UxViy5qs
	6vtdtmQtEjGDKzY7Jq67m5XxWXVtuFLPpQCE/24RbYV1UDPMSeXqqYIWTJpqqea1vw/sPBpOX8W
	mCrpYClkROQ==
X-Received: from ywbni25.prod.google.com ([2002:a05:690c:8d19:b0:7fe:abec:8fcb])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a05:690c:f01:b0:7dc:313d:afec
 with SMTP id 00721157ae682-7fe5c244953mr52082497b3.22.1781714415383; Wed, 17
 Jun 2026 09:40:15 -0700 (PDT)
Date: Wed, 17 Jun 2026 16:40:13 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.1189.g8c84645362-goog
Message-ID: <20260617164013.280790-1-jmoroni@google.com>
Subject: [PATCH rdma-next] RDMA/irdma: Prevent user-triggered null deref on QP create
From: Jacob Moroni <jmoroni@google.com>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, Jacob Moroni <jmoroni@google.com>
Content-Type: text/plain; charset="UTF-8"

Previously, the user QP creation path would only attempt to
populate iwqp->iwpbl if the user-provided req.user_wqe_bufs
field was non-zero. The problem is that iwqp->iwpbl is
unconditionally dereferenced later on in irdma_setup_virt_qp.

While there was a check for iwqp->iwpbl != NULL, this check
would only occur if req.user_wqe_bufs was non-zero. The end
result is that a user could send a zero user_wqe_bufs value
and trigger a null ptr deref.

Fix this by unconditionally calling irdma_get_pbl and bailing
if it fails, similar to the CQ and SRQ paths.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
---
 drivers/infiniband/hw/irdma/verbs.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 4c0ea7c9b9..4124e4d732 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -638,17 +638,16 @@ static int irdma_setup_umode_qp(struct ib_udata *udata,
 
 	iwqp->ctx_info.qp_compl_ctx = req.user_compl_ctx;
 	iwqp->user_mode = 1;
-	if (req.user_wqe_bufs) {
-		spin_lock_irqsave(&ucontext->qp_reg_mem_list_lock, flags);
-		iwqp->iwpbl = irdma_get_pbl((unsigned long)req.user_wqe_bufs,
-					    &ucontext->qp_reg_mem_list);
-		spin_unlock_irqrestore(&ucontext->qp_reg_mem_list_lock, flags);
-
-		if (!iwqp->iwpbl) {
-			ret = -ENODATA;
-			ibdev_dbg(&iwdev->ibdev, "VERBS: no pbl info\n");
-			return ret;
-		}
+
+	spin_lock_irqsave(&ucontext->qp_reg_mem_list_lock, flags);
+	iwqp->iwpbl = irdma_get_pbl((unsigned long)req.user_wqe_bufs,
+				    &ucontext->qp_reg_mem_list);
+	spin_unlock_irqrestore(&ucontext->qp_reg_mem_list_lock, flags);
+
+	if (!iwqp->iwpbl) {
+		ret = -ENODATA;
+		ibdev_dbg(&iwdev->ibdev, "VERBS: no pbl info\n");
+		return ret;
 	}
 
 	if (!ucontext->use_raw_attrs) {
-- 
2.54.0.1189.g8c84645362-goog

