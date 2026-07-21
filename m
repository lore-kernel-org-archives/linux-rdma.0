Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A973BADB2
	for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 08:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784622379; cv=none; b=iBVyMNUVClzmQLt3Va+uQMVUgxsOdo6qk6exH3jOI4oMCdaJMsjHW6axo2NGtKuw8cB74OOODDAzBe5YTXydzRYX6V3p33oGVbYeoNSs0Jh9jNJH+4PGLUTnpjP9wwq/0YLQKdBhFQKgwDPDRg4uk+cmvFV8qk9H7witb7kZKqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784622379; c=relaxed/simple;
	bh=JkMHTvniZhqe2oXMPPAGLmNJZHBXlNQ+NTN1FpBLCHA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q9j5dq/zDvxWwoyGo1nPU540bmjp5mb9hJ2N9T/+Unaw+ukS4KfkeOaGNIjRKBZ+HZTXg4vqvCQetsVCB1Dpw2uecSXhUXTd9kbmc30S1nYQBW0IJyIQgiU0G04Nj74uu7tB0k4RL+eeRDQrXbeeeU4UAhhetToN62QdhO2Yaqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KNL0fGjb; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KNL0fGjb"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-38de840f2f0so7086585a91.0
        for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 01:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784622366; x=1785227166; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZJM3h7TT9K/6v0G9mwCxA2nXNujpb9Aox1csSxS/kdg=;
        b=KNL0fGjb84z7auuOxltmZg9EDucWbcvrdIYsYUKO1ZT3ar3a+BhSNWzcrBd8vsjGop
         EkC5clgZhNaZMv5Bv43Eo1eDIGFBQH6MeVPamuw1nqDsMgHJQ52aDFGHitUOPijS06Rz
         F4POrnrCtKzVWeJkIIeFC/B/PeUGVjJYiMuwBo2dbko4Thk5rmsIW46fPu0YXPVc8QFw
         eiwipCJKy8lRu78kWY9tinhqinn47HNbkKVPtC/Xttb0v+8dxdJdQZtzJ+gRyeVx5HSD
         s+S9u5w894LDsvGsOFbmcdj2B53ToGRhuCUMyuBu2HfKPxAy91LEAWXbWkSkttQMtaJD
         7gEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784622366; x=1785227166;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZJM3h7TT9K/6v0G9mwCxA2nXNujpb9Aox1csSxS/kdg=;
        b=BDwiT+En/+KeARzINWfKcamc4jNNo29VMw3DUnG2hGITVE4+YvmXSXlRTZ6td0nMGP
         uVira8CXxK9oVFeWAftDYq6aDQRb/6sTjumxPadGRVoccybDWdp2gyfJTWcOp15veUI9
         uBElIcO4zO3PHmz4l4OVUKSUJxB2it9+taWh8crBx9wNrC/DsQrXc/9fyFqLO7fQ/R6K
         DcpJIqLMXvss0Q+Tbe0pswuZOYWMJOJQd6pUaKAKWiTZobutzTsAW8wArAuO008SA+qz
         6iOgaSklyTpLJTqNGwqf12LBiIL+llw3RchUc6eUxwOcFRVh6Sdn79TwC3VEIVl22W72
         4TaQ==
X-Gm-Message-State: AOJu0YzmFt8d9RGCp8gx0HCwFCrtIJtYphVbzxyXzE+J43Jj4bb3pb90
	7dOtGu2pEqB8NZV1rptkc2UPxOi0KY2HOeTDdRBf9W+C0BahXD/rgqA=
X-Gm-Gg: AR+sD11j8qP2IrPPrzQYcI8qit4tc59aFW5IvejfLEgSgB7+/Dnh8wqpHZfmOqwPh9R
	fviszFWB7OBgDBJIv7qWhhp60OXJq7KZl3EwRQIyjOZ5Q5DWUw0cqaqB4WxT2ZRY3xNWNZKQ4cD
	+XMUTDxB+notk+pP6SKKoMfOLdIe7CpvlLqJhk15JL+PILQY80+44TmMziJ6la+PnSS3mONfMyJ
	fCixyGTgaOe7et9gcXyRuahGyCyBuwHP2eebUhbBsTWjfRAfnLVbYhLqIQztytDotqUBW/oxB/p
	egd46tqaboUKW8mwZdPywRqJ2Rp9tAyBhkmWRLOqNSG52zJAYxZX/TqdJFFf9VGqh+EXKCpirUR
	oCxyk3MJgbuVQDWCPo2Er77Qx0uuZ+O2T1ueeg9dycwkd34jqDTnPfceubDxDVxGep73nlISxGr
	RPR2vvfY5jsLxpBwKW1+RW4XGuA9YxvSDKWUm46zsKgKxOmnf62+RVnGu//80VkMfrlzyf6JMr8
	Sv4GMjbP1YS9rS6me26UCENqVfhwjabeEti+2mu
X-Received: by 2002:a17:90b:3d90:b0:38e:7d77:2fbb with SMTP id 98e67ed59e1d1-38e7d77308dmr8036694a91.32.1784622366306;
        Tue, 21 Jul 2026 01:26:06 -0700 (PDT)
Received: from localhost.localdomain ([14.5.152.27])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e92300651sm1079283a91.4.2026.07.21.01.26.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 21 Jul 2026 01:26:05 -0700 (PDT)
From: Myeonghun Pak <mhun512@gmail.com>
To: Cheng Xu <chengyou@linux.alibaba.com>,
	Kai Shen <kaishen@linux.alibaba.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Myeonghun Pak <mhun512@gmail.com>,
	Ijae Kim <ae878000@gmail.com>
Subject: [PATCH] RDMA/erdma: Fix CEQ tasklet use-after-free on removal
Date: Tue, 21 Jul 2026 17:25:45 +0900
Message-ID: <20260721082545.47395-1-mhun512@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Each CEQ interrupt handler only schedules eqc->tasklet. The tasklet calls
erdma_ceq_completion_handler(), which reads the DMA-coherent EQ ring
through get_next_valid_eqe() and updates eq->dbrec through notify_eq().

erdma_ceqs_uninit() frees each CEQ IRQ and then destroys its EQ.
free_irq() prevents another hard IRQ and waits for an in-flight handler,
but it does not drain a tasklet that the handler already scheduled. The
tasklet can therefore access eq->qbuf or eq->dbrec after
erdma_eq_destroy() frees them.

Clearing ceq_cb->ready does not synchronize with a tasklet that already
passed the check at the start of erdma_ceq_completion_handler().

Kill the tasklet after free_irq(), when no handler can schedule it again,
and before erdma_ceq_uninit_one() releases the EQ buffers.

Fixes: f2a0a630b953 ("RDMA/erdma: Add event queue implementation")
Cc: stable@vger.kernel.org
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
---
Found by static analysis only; not tested on ERDMA hardware. Testing on
hardware, particularly device removal while CEQ interrupts are active,
would be appreciated.

 drivers/infiniband/hw/erdma/erdma_eq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/erdma/erdma_eq.c b/drivers/infiniband/hw/erdma/erdma_eq.c
index d5b9d19882b2..a8784e07acd6 100644
--- a/drivers/infiniband/hw/erdma/erdma_eq.c
+++ b/drivers/infiniband/hw/erdma/erdma_eq.c
@@ -220,6 +220,7 @@ static void erdma_free_ceq_irq(struct erdma_dev *dev, u16 ceqn)
 
 	irq_set_affinity_hint(eqc->irq.msix_vector, NULL);
 	free_irq(eqc->irq.msix_vector, eqc);
+	tasklet_kill(&eqc->tasklet);
 }
 
 static int create_eq_cmd(struct erdma_dev *dev, u32 eqn, struct erdma_eq *eq)
-- 
2.47.1
