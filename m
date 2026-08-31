Received: from mail-wm2-f11.google.com (mail-wm2-f11.google.com [74.125.225.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8A94A49A5
	for <linux-rdma@vger.kernel.org>; Mon, 31 Aug 2026 17:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788196462; cv=none; b=cpqJFJfG37ui33xnPzUnL3olIPOPi0adyhy6H5ZRiFnflOCqDDOeQvBDFpAp6o5x/pbVqxRWyvMUlrEVatx13dCewVpoBAbkOAPTfXWUmLRAdO8+jdhcA6Z2w0R1xcbDdFzfwIfkJBLcUCITGsK+Bd02cFTGcEZSgARsEru/nyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788196462; c=relaxed/simple;
	bh=Rur/BHGTdJxyhCxiUGPHKMXcK+P8Dcu44u3Yj+AleE4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UHCfdH3ExVRjCLrTnzxtkUrrCYu2alzAN65ND278bSZSPGOcO/6s1AKWHHCxHODSZvHc18dwkeIiHlYCvoCpcfEH4ykTgTbXgMZ0TGxr2qchcUf/57rqxM3zIQJD9qc7eDo8NXPu71wt7CHeKjtaJDAeB9nKkh4xlFEtsUBur4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EZS39+MW; arc=none smtp.client-ip=74.125.225.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EZS39+MW"
Received: by mail-wm2-f11.google.com with SMTP id 5b1f17b1804b1-49ccea58fe3so10209175e9.1
        for <linux-rdma@vger.kernel.org>; Mon, 31 Aug 2026 10:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788196459; x=1788801259; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DJlEpwegCedIufc0NXaQ8IywGIFVcGZVq/Vh3GQUlEA=;
        b=EZS39+MWy0NnoQjK/rlgLNlstzdZqkvYvhRUneklJi5yoDpOK3k6oaEPQChdtNhf/q
         tEK/E5zRZMY/qIOh/iuLlO6Ust7vCTCFCO/5aGuv5oFfcvJ+kwS1aFohwwmRYcku0lYs
         BObUOtqDMZGPk66FC2VsP473T2H1VK173TwmFm7Ctck5dNM3iId4JWtusdxerGr2CxLL
         LcLNGMJVPWZ672j39KjJtulwvnqxEbq5tIa3Upx1tfxqRxjKK+I5kv+L7Av9ks3bxEPl
         9JSQaPr88aRIHfgXGf9C3GIO1bMlutGKG9C8HMFnhwZu9D8ma3MsdBHcrC+Ja34CB4sw
         iiIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788196459; x=1788801259;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DJlEpwegCedIufc0NXaQ8IywGIFVcGZVq/Vh3GQUlEA=;
        b=iC0sFwCp0DRp83s6SQrz1GSI2YUjvBKIkefi4qhl9CT2KPPUiln9dB/xPdE1oWi28x
         SiVJQMPM45Zfnkbsq8PDIFNaDxDyWhUhKnKfSUS9ABUUO5dR5+/acFpBkXJCLL6Ea1P5
         thS9EwsHGaZyB+A1khk+7xgH/K2qYPrP8F+lxKxI3UPgGDOs/NEWfkoCip3nVQcEJLHO
         gNSQKxoDXYotpHvCZf3AJ7VeUH0TxDyty7kheC/IfMzlc+zINfKTEDT+8XkaLcD/BzRy
         PTpUYYD3C2fBpJU5pGFUUyTvKdZXUqX+HYfMqG0dJNE9rHbyMotd4NM/Sj8RrGcuVyTc
         Q4YA==
X-Gm-Message-State: AFuF++nb5fr2GGE/fNZJrytaSFtSngrgr2YutwJrsfqFIlNQYjcIE0Ur
	L/AcFYIYMe5M+s7OLfGO+8dXR3RqXgqwOgqn6MfKcbTWMd4aX0+PC4vo
X-Gm-Gg: AYBFou3xSyQ+w9cYdl3KiGPJI6uD9K2x4ZTaJhRW5BQKcj3uT0e9EvhzvORPHqJaI6H
	Yg5fTjVdr1ysi2FCFf3mSQyftH7X6UFPt7RruA50UHvdBIQObVTjVlcXzlyEx2Zpf9iNOeLON8m
	6YBJzs6nllKOhGbHgmgavaUORAGFLLls/xJK73phBXCXKjEaVmLoRtJh3YhWpz2DaiD2OMrPBo9
	2sE8jORHiF50MRjWOFSvD2rdzzx95SrVZBYzKdiMHapLq8oS4RoVD2Wn53SIKbfgtfbDAOj5MQa
	oGcJrKNinHSdwsruQT5wcHKKfUGvz6QlUMys2J+8X54qkn+2CtLdw+Y1t63lp8fJA/LEJCMNvQR
	RMjc4+yAsd4FpcXlDMhleYvbAnpM6+xOCBJNQwfBRtR6Mwn6ZhTQ/vhO4ozW/DClC9ltUsKD5No
	4nlh76hp4v1QMNpFVOMLkMzY34k6Nizq7t0VnrigxCyYhQEoM6JQSeT2eoSvQ4hxR85GguRGYpJ
	RTi
X-Received: by 2002:a05:6000:4910:b0:482:a8b1:aa6d with SMTP id ffacd0b85a97d-482f79c1923mr43129255f8f.10.1788196459060;
        Mon, 31 Aug 2026 10:14:19 -0700 (PDT)
Received: from serhat-ubuntu.home ([212.253.216.238])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482fbab3f16sm26357256f8f.1.2026.08.31.10.14.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 10:14:18 -0700 (PDT)
From: Serhat Kumral <serhatkumral1@gmail.com>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Serhat Kumral <serhatkumral1@gmail.com>
Subject: [PATCH] RDMA/core: Reject CQE counts above max_cqe in ib_cq_pool_get()
Date: Mon, 31 Aug 2026 20:13:54 +0300
Message-ID: <20260831171354.72140-1-serhatkumral1@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ib_cq_pool_get() does not validate nr_cqe against the device limit,
while ib_alloc_cqs() caps the size passed to ib_alloc_cq() at
dev->attrs.max_cqe:

	nr_cqes = min(dev->attrs.max_cqe, max(nr_cqes, IB_MAX_SHARED_CQ_SZ));

If nr_cqe is larger than max_cqe, ib_alloc_cqs() cannot ask the device
for that many entries. A device that reports the size it was asked for
therefore returns a CQ smaller than nr_cqe, and the fit test skips
every CQ in the pool:

	if (cq->cqe_used + nr_cqe > cq->cqe)
		continue;

'found' remains NULL and each iteration calls ib_alloc_cqs() again,
adding another batch of CQs to dev->cq_pools[]. The CQs stay in the
pool, so each walk under cq_pools_lock gets longer. The loop ends only
when an allocation fails, i.e. once the device or the system has run
out of resources.

ib_srpt can reach this path when a privileged user configures
srp_sq_size through configfs. ib_srpt accepts values up to 65535 and
requests ch->rq_size + sq_size CQEs while establishing a connection. If
that sum exceeds max_cqe, a valid connection request from a remote
initiator can trigger the allocation loop.

Reproduced with ib_srpt over rxe, which reports max_cqe = 32767, after
setting srp_sq_size to 65535. In a 1 GB guest, a login attempt
requesting 65663 CQEs caused 115 allocation rounds in 185 ms, followed
by:

  Out of memory and no killable processes...
  Kernel panic - not syncing: System is deadlocked on memory
  Workqueue: ib_cm cm_work_handler
  Call Trace:
   __vmalloc_node_range_noprof
   vmalloc_user_noprof
   rxe_queue_init
   rxe_cq_from_init
   rxe_create_cq
   __ib_alloc_cq
   ib_cq_pool_get
   srpt_cm_req_recv.cold
   srpt_rdma_cm_req_recv
   cma_cm_event_handler
   cma_ib_req_handler
   cm_process_work
   cm_work_handler

Reject oversized requests before entering the allocation loop. With the
check in place, the same test allocates no CQs and ib_srpt rejects the
login:

  ib_srpt failed to create CQ cqe= 65663 ret= -EINVAL

Requests for max_cqe entries or fewer behave as before.

Fixes: c7ff819aefea ("RDMA/core: Introduce shared CQ pool API")
Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
---
 drivers/infiniband/core/cq.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
index 12304c9a9403..1205e9b28897 100644
--- a/drivers/infiniband/core/cq.c
+++ b/drivers/infiniband/core/cq.c
@@ -449,6 +449,13 @@ struct ib_cq *ib_cq_pool_get(struct ib_device *dev, unsigned int nr_cqe,
 		return ERR_PTR(-EINVAL);
 	}
 
+	/*
+	 * ib_alloc_cqs() caps CQ size at max_cqe, so a larger request would
+	 * keep allocating CQs that never fit until allocation fails.
+	 */
+	if (nr_cqe > dev->attrs.max_cqe)
+		return ERR_PTR(-EINVAL);
+
 	num_comp_vectors =
 		min_t(unsigned int, dev->num_comp_vectors, num_online_cpus());
 	/* Project the affinty to the device completion vector range */

base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
-- 
2.53.0

