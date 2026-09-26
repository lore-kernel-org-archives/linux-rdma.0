Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014CE40BCB6;
	Sat, 26 Sep 2026 11:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790420405; cv=none; b=VhJQ2GJAQ5076VmVEDtAPf/Ow2cWDmlh02HAxyCDfbhyNX4mExfZTa2cF1r/mdAPfyFps1KaP1/zaVXo05lMAEfs4Sg4U//PL0dmDy4fX6k3oVgT5WURvx1GOTGbf2TkosAOYryQD4dtSlRVNWaVuHCbCfDIZoQNS7kRbFcvKTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790420405; c=relaxed/simple;
	bh=9NA8ppecmhdGzSjOhauAYdGbCN0e30ZYJ5Nsf3NE1wA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Wzq09/0I46nEP0VR3VzZB4G37Lm9z2CUcN3qJNWaAZ91RbWLAOi5POTE8YXLMz8Hyg2c/FuluayjODANc8/ezOAS7gZnuBB87ILECYvMDrdK4yT/Ax763ehl7gDHy27gvFKEWLGVbn/gj9ePgWqI2o2aze6RbyggbqvjYNY2p3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=H3iCa4UD; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="H3iCa4UD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=6S
	A0ectOXjiEB3uZG1c3EL0I6hGX45Xh6KsnwaHP0og=; b=H3iCa4UD6BcUeToRGa
	Pe0MrtyZ6CX4OZ8Y/K+4N3v/apYKgUXz5PYuDWOdHNI8OiYCZknnH/VmOKc47Aan
	8hczFWqsh1bH0ySAevEYKNhyBPzNDQwUBr6EaTdhyigRay73el5C903zak8khOyD
	RKK9Xk6GBOlu7Kuh5pv5amzeM=
Received: from pc.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgA3aMKYpbdqAch1BQ--.47384S2;
	Sat, 26 Sep 2026 18:59:37 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Li RongQing <lirongqing@baidu.com>,
	Ira Weiny <iweiny@kernel.org>,
	Doug Ledford <dledford@redhat.com>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH] RDMA/mad: Reject receive completions shorter than GRH
Date: Sat, 26 Sep 2026 18:59:25 +0800
Message-Id: <20260926105927.3183294-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgA3aMKYpbdqAch1BQ--.47384S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Xr43GF4rtrWfZw4kXFykGrg_yoWkWwc_Cw
	1vqr97G3W5Canrtw1jkr45WFyqga1j9w1fua92qrnxJ34Fkwsruw1vvF9xur4DWw4DWFy3
	GrsrK3yfZw43GjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRRApnDUUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC8BkYUmq3pZkBogAA3h

ib_mad_recv_done() derives the OPA MAD length by subtracting the GRH
size from wc->byte_len without ensuring the receive completion covers
the GRH. If it is shorter, the subtraction wraps before the result is
stored in mad_len and an invalid length can be passed downstream.

Reject receive completions shorter than the GRH before inspecting the
MAD header or deriving the MAD length.

Fixes: 8e4349d13f33 ("IB/mad: Add final OPA MAD processing")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/infiniband/core/mad.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 3c91f00d09c6..8124e0b5a87d 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -2342,6 +2342,8 @@ static void ib_mad_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			    recv->header.mapping,
 			    mad_priv_dma_size(recv),
 			    DMA_FROM_DEVICE);
+	if (unlikely(wc->byte_len < sizeof(struct ib_grh)))
+		goto out;
 
 	/* Setup MAD receive work completion from "normal" work completion */
 	recv->header.wc = *wc;
-- 
2.34.1

