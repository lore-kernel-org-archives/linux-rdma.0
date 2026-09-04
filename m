Received: from mail-wr2-f9.google.com (mail-wr2-f9.google.com [74.125.225.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234DE33ADAF
	for <linux-rdma@vger.kernel.org>; Fri,  4 Sep 2026 20:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788552227; cv=none; b=PRymhgVk/Lqlw/EkOkvNzLUC1uDkBf71A2dL00+Z4UWnf5yFIDCFPTJj0EmLw0d/vhD/jI5uxjcPRfdFDnNuD4Af1k6qfeeRP+FE/LltRnKKXLpWVwGtGKyYIlOmKWHar1LoH/KZG2VmUzfCIJSllDDRGas9Wn1IjErYX7YLJls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788552227; c=relaxed/simple;
	bh=vmLc0QU+7tEqTAWdMzWFy6dCmHlNO9qldr5uF86+PMw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WS05eVMok16z/QDAAOOflCHdqLD5T0beSi65nIyvCKFZ/ZsP/FiipujVIpyn1FzwpM2H/ri4UaMQqwHiBkygUfDU6aY6Tjrjo/p1TTKw0RaAnb46UC0GGaWRnxXS2iYIAe6rije5ZG1JFLsx5cdOhLgDrb3OH/tUHwm94vGAgAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JXkF5btR; arc=none smtp.client-ip=74.125.225.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JXkF5btR"
Received: by mail-wr2-f9.google.com with SMTP id ffacd0b85a97d-4843169420fso320030f8f.1
        for <linux-rdma@vger.kernel.org>; Fri, 04 Sep 2026 13:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788552220; x=1789157020; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3UTb+wha3en9T7ds19Z5GD7eJbXn6Ymtux42hGN1TZs=;
        b=JXkF5btRjLVeBkun5UWWZ/sB4imYW/MqmMiEabig3BelE+mXsbsUUY0xs6KJ8mH4nK
         bK1uwlCD3G/9qGfC+ozlr46ZGGCUy5XLApTPh71d/m0Rlb6TROhsTWBkPIFLYWnxeQpz
         up2ZjGbIneuzNoeqNAJpYATV8dnt6VspNUnWL1opUjp2ur2zOpHzEnQjgNaeJJ/NV2KX
         Ko0T6thZcLn9z7a2T0GR2DvVmpepI2SiXUB2VxAg7f9jJqjzchPS+PXrTaC5E+3lPot8
         QSK5b4ugBMOFAhAijP7c0q182jVm29oN2GSE0PDEyc4xF4GctS0gu3w35SL4+Inq5k52
         fnsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788552220; x=1789157020;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3UTb+wha3en9T7ds19Z5GD7eJbXn6Ymtux42hGN1TZs=;
        b=OCeJTAXqKOWtmBjCd1yeYQfjH8m2m2PdTr41MHyHxOX4YQ33baOu83aaKQbRj+XxDt
         EKraZigF0qnYGxk4XWPfm1Cur1OviGVC4LszpKWdoPijrCAAuzccLl8OT7NDbGjDlCzZ
         ZP76S8EcGjAuvcenq2feaobK6ePGT24qcVGXEaYDQA/Df2c94KHQHhydUmu7h4L6kxQq
         nqjoAHwJq3En2mFOtyNu8RH0DrjNk/B7z7NA3ohKC3yi/7dxac7PpsVlPq0ZKqSna/WJ
         aWwdv4/x7EjoFmLbWBxWxHgl231HP2mvaNlH6wkf0qCmrYiGo1Mg5We3C507uFwFMPaZ
         dcIA==
X-Forwarded-Encrypted: i=1; AKwUvBxz4N5nsqRpr96CwIxr65fOGf1OGSAjzaq8h5zVESbQva2Zz1YOTzPbhTJfH3fPj2s5su6Wad0NKi+B@vger.kernel.org
X-Gm-Message-State: AFuF++mvAXv6NB17cvWqLOuYakzVWGtiFqRzCpNKzmYLRlR259Kymnzb
	XvpSAmbvKJX0fzA+rgZ4qpHUUjK1yjYrxs2Ko1WbwF1rfJ6y8AhcgcqR
X-Gm-Gg: AYBFou2WtJ6ASkUDNtgqy8dKnoxM6nAVZP3jbsnjskDwSnCEOIPNuXXkvwIccWJqILo
	9uWOgevsa9kkADuabSgO/VN9baUq14eEyzCyTrbPAotWY/6zddYTp2+Vw3hQ1AgC37RUV0DRfgA
	JgK5Um+8OAfIGSXd0JElnE8ebkHLbXOtkPEKVbMfAeupldwsoMe8xlGFL2pTo3VLQs0y8om284V
	N6xyUOeFNG5lvlTCeJzQlMNbdMrHN++at2rNwQFL+tTIjsZb6qgmwJmymL8+e9RnSu1tIdO1w1t
	0DIcmKK9DeQHQdU84JDsbjJstlYy1wskwiWeeNa001TaNMJcktSIXnpnNRJHReyoTrhzXBopTBX
	K0HTpVYPDAIxhxpcDLwNjCN/fQ3ZY6WJyb5HWtQImf85iJHOZeZqCyIymZQI23nlkUiI1TdIfHU
	HnxTz8nxh9c9RQzfnI9AjXccToCI2XmG8hHeH+hKRLTfOKfMuYT2tmlbipUmtwGhUNipbJRDkeE
	pLZbU5mdkht6L3qBFIXwiteRDw=
X-Received: by 2002:a05:6000:610:b0:485:82bf:8728 with SMTP id ffacd0b85a97d-48586e32b7amr11331315f8f.0.1788552219337;
        Fri, 04 Sep 2026 13:03:39 -0700 (PDT)
Received: from serhat-ubuntu.home ([212.253.216.238])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485885c5bbdsm7868460f8f.36.2026.09.04.13.03.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 13:03:38 -0700 (PDT)
From: Serhat Kumral <serhatkumral1@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: Sagi Grimberg <sagi@grimberg.me>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Serhat Kumral <serhatkumral1@gmail.com>
Subject: [PATCH v2] RDMA/srpt: Clamp the CQ size request to max_cqe
Date: Fri,  4 Sep 2026 23:02:40 +0300
Message-ID: <20260904200240.48976-1-serhatkumral1@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

srpt_create_ch_ib() asks ib_cq_pool_get() for ch->rq_size + sq_size
completion queue entries. rq_size is bounded by max_qp_wr, but sq_size
comes from the per-port srp_sq_size configfs attribute, which is only
validated against MAX_SRPT_SRQ_SIZE (65535) and never compared with
dev->attrs.max_cqe. The largest configuration srpt accepts therefore
asks for 128 + 65535 = 65663 entries, while rxe caps max_cqe at 32767
and cxgb4 and ionic are in the same range.

Such a request cannot be met, and ib_cq_pool_get() does not reject it.
It clamps every CQ it creates to max_cqe, so no CQ it adds to the pool
can ever fit the request, and it keeps allocating batches until the
allocation fails. A single SRP login against such a target exhausts
memory:

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

Before commit c804af2c1d31 ("IB/srpt: use new shared CQ mechanism") the
same request went to ib_alloc_cq_any(), which rejected it with -EINVAL.

The existing backoff, which halves sq_size when queue pair creation
fails, only runs after ib_cq_pool_get() has returned, so shrink sq_size
before asking for the CQ. rq_size never exceeds MAX_SRPT_RQ_SIZE (128),
far below the max_cqe any device reports in practice, so the
subtraction does not underflow. With the clamp the same login proceeds
exactly like a correctly sized target.

Fixes: c804af2c1d31 ("IB/srpt: use new shared CQ mechanism")
Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
---
Changes since v1:
- Move the fix from the RDMA core to ib_srpt, as requested by Leon
  Romanovsky.
- Clamp sq_size before the CQ request instead of rejecting oversized
  requests in ib_cq_pool_get().

v1: https://lore.kernel.org/linux-rdma/20260831171354.72140-1-serhatkumral1@gmail.com/

 drivers/infiniband/ulp/srpt/ib_srpt.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 7197d95f2216..58064a4c606b 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1867,6 +1867,13 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 	if (!qp_init)
 		goto out;
 
+	/* The send and receive queues share a single CQ. */
+	if (ch->rq_size + sq_size > attrs->max_cqe) {
+		sq_size = attrs->max_cqe - ch->rq_size;
+		pr_debug("reduced sq_size to %u because max_cqe is %u\n",
+			 sq_size, attrs->max_cqe);
+	}
+
 retry:
 	ch->cq = ib_cq_pool_get(sdev->device, ch->rq_size + sq_size, -1,
 				 IB_POLL_WORKQUEUE);

base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
-- 
2.53.0

