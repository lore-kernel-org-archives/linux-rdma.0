Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795719232;
	b=z5EzsVS3MjCZ9+bqjb5hN8P1oFHcibh4MoEzN1aMQXbhOyBro99qKuflqahLWOVkXMxu
	 BFr7GCOUwMaOA1JiIiEDnDDyJSZJxo/Pph5W+y9ypwf0BTEwFXfySdzIWjURBrKScAp9C
	 WUp1rWDQyi/yrWAgAmJ8OMEuj2j/2XtNeFEKPLk2LPAATheiRH2pwMuTzPHuUrMn0EnDR
	 F5Y5Nuolb3YFUAKHgpoDAcFycwZjTI0vSvnSyzNruo3kJUJZzEb4fmIQZTDz9u+wZRdbt
	 L5yBupvU+ZPsooBqxc5rN2/xkkgG4onyTJRCMg3Rr41WXEgGtm/AOH21RYTn07QCupw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795719232;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=229nMf9ZvmF+Q4/uF15mLyWpts8NJTx8zSYRFTYPe40=;
	b=WMUsNkmlO4zoS7IlDxXAL2+klfYhqEvcUQDrDAnhvcCBm0K2RfQOKCGP5s5XEJLRBxnj
	 cH1sm/jJ9saimLVUwTwhdeOFN9fjTnVpLyPJKmHr9KsLUaGFjdz872ljvaQ/biB8KTzuJ
	 iU/tAxxl7F/xOBcMRWYqMLw7Wtdy68Mz0nDWr8MjVEcmNfxuWrMcTao+ykqKbJ1bHoLUT
	 UtjS3h5tYiMAFjX6uYDpsIhkIBBtERlfq6S1/7s1XcxTbUktCj+/FxUCjy67iPP7ZtOrX
	 av6424hi7v7jCwAedNaZtaw8SENcM+Ga+HGZwPXEXz04Jk0svqAHecuSfcIQwkj8kfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=DUsVtqHE;
	arc=none smtp.remote-ip=209.85.160.197
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD8C606A31C
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 18:53:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5BD8C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=DUsVtqHE
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-55d414ff1e9so134273111cf.3
        for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 10:53:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795719231; x=1796324031; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=229nMf9ZvmF+Q4/uF15mLyWpts8NJTx8zSYRFTYPe40=;
        b=DUsVtqHEdIRosgjlGaHpPAwZ1bbH/k7Jvxg4eGwa7QVbZx+sZFZjaOt0w9DpfX7W7I
         gUOiPGAL4y7hW3vkRkZvJ7YWr0WkqQIcNIRwMWVOCZsztsf8Pmkh/ddapYQyBYBdQQMw
         Ck2O+PMVK08cBKZ6x5pJmg6I/LppDGmCD/aKRaULNizHMB19pS6vz8jmIZ104uP65YB3
         CPWIuFFvrAG898pU18jGebQMplUlPQ9QjRzX0UMaM0Xez8OXa6UwQCvHFLsPRmPfE4Og
         H6hg3H4IZG+SBYp/YN5M/hqTHat208T5+5sot4jQb5vNQ41Xqm2a7qPOfpgPWBhFZZgR
         kL1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795719231; x=1796324031;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=229nMf9ZvmF+Q4/uF15mLyWpts8NJTx8zSYRFTYPe40=;
        b=EBtLOvEhTj2h664mJqIHrmAXj2bJ2woT3r+aS/nxggz7w7Xl843Y4HuVQ/cmUZ//oG
         uieIWv1h5fsByauR+VpLFIBP1Rx5x7LQYxMmzScXMhwwxda82Bx1VXvrGIkhsF0+QD0K
         f1IUcsowfnASYW99BKkC/lHfKfTPEL5CY/yR2zE8gnoxO5CkW+n03BoEGTCym/zJoIxL
         /YvZSOnfJfx59CIxMSYgcai/7u7EmDuabtE1DJIOWzuJnNr5yk3BLX7hEC01Xu5bYgow
         KBPgXlnzFPFT7tduwphj0Uim4ADFGASju7N3Ps3W9DPLwKhlvBJyBUsgQG7w170QJ5iQ
         YOcA==
X-Gm-Message-State: APuU4Z81my7PTxzzj5cWcY7yXrTu1auE4kqxm7nyjEHHHkvpdbTO4CV2
	Jt5EtUtSPRSgCZbcJQndas5cRbNWnFp9YyFU2gzzAF8qLirK2cZjjWlFg5sNcKE0S9Po2eoBEjP
	HZri84ArGDA==
X-Received: from qtbnn24-n2.prod.google.com ([2002:a05:622a:7918:20b0:535:31b7:1b4d])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a05:622a:a0d:b0:55d:32d3:758b
 with SMTP id d75a77b69052e-55d76aa2af2mr378446511cf.59.1795719231006; Thu, 26
 Nov 2026 10:53:51 -0800 (PST)
Date: Thu, 26 Nov 2026 18:53:43 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
Message-ID: <20261126185344.2784303-1-jmoroni@google.com>
Subject: [PATCH rdma-next 1/2] RDMA/irdma: Wait for all refs to drop when
 destroying RoCE QPs
From: Jacob Moroni <jmoroni@google.com>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, Jacob Moroni <jmoroni@google.com>
Content-Type: text/plain; charset="UTF-8"

Commit 6f52370970ac ("RDMA/irdma: Fix deadlock during netdev reset
with active connections") made QP destruction skip the refcount wait
if the device is being reset in order to fix a deadlock that could
occur for iWARP mode QPs due to refs still being held by the CM.

RoCE mode QPs are not subject to that issue and should still wait
for all of the references to be dropped. Otherwise, the QP could
be freed while the AEQ handler or disconnect work still holds a
reference, leading to a UAF. In RoCE mode, any remaining references
held by the AEQ handler/disconnect work are always transient so
the wait is bounded.

Fix this by restoring the original logic for RoCE QPs.

Fixes: 6f52370970ac ("RDMA/irdma: Fix deadlock during netdev reset with active connections")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
---
 drivers/infiniband/hw/irdma/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index e07b6b40dd99..29ccd19da032 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -592,7 +592,7 @@ static void _irdma_destroy_qp(struct ib_qp *ibqp)
 	}
 
 	irdma_qp_rem_ref(&iwqp->ibqp);
-	if (!iwdev->rf->reset)
+	if (!iwdev->rf->reset || iwdev->roce_mode)
 		wait_for_completion(&iwqp->free_qp);
 	irdma_free_lsmm_rsrc(iwqp);
 	irdma_cqp_qp_destroy_cmd(&iwdev->rf->sc_dev, &iwqp->sc_qp);
-- 
2.56.1.839.g22a8290db9-goog

