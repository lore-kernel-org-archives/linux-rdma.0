Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794882525;
	b=oPhq7lat2huKZy/0WU4G4uezQy7Ke0YPw+EQ+dv57IVV1KXUtV07GsCRoS1SRxaQqYLS
	 wYBGI5ODmrcURkqLKcrIYrJKaCCG7JokGdCdr+wP8vorviswt+lAuewbVYkMt9YLqUvcj
	 u6GPi84HotsMZLUR46DWJGQflEEGXkfIS5aopw/ucQisBW7VpH5zfcQ/2HEm8bd6ZGinP
	 zEgoYsldQ0MKMR+RBmxZowxrYfyRHjZtDz3PB9WgAgC/v/8/NddLQSRNjg4pXLzJhVvKL
	 EWeIezGO8hI5JxA5iUe7ZnPU4rZw57AT1nzKJca0m3YSynRcP1pIFmphc/AJLOJyW8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794882525;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=m7e4fyf2Q5mCywaw7nen7QHcArrTjTdu8X+U3sZLG8E=;
	b=swnntYvAEYCP5CjikceVZsap/zvuWSZqy2694HsHDpG3tmSzuoQwqBDkdzs7CT3SmaEa
	 M/udRWjbcmhcSSYfsj+xrrsKwRc3oTgn4agZiiloQ9AO87u95M84N/fADk9PtPxK7orVK
	 5xUfBHJdpPQfhR9XZofeF92SPm+RmLxK+t/ywduD8zJceGCrvBFj7ehASor0ir7cwI5SV
	 Cc8bmOdOS3QHz8fG3rHDavJnB8kZrVGZXoysrFvr7TCmfSzQ9U+ncN6Xw1oDps26GJN9N
	 f21Y81uuxMBJrYfIj+trWWCwFf+ToImtQCwyxuylHCoHfvkFqxEFBxzjVHJDsw46JoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=iHWDBmMW;
	arc=none smtp.remote-ip=115.124.30.130
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E2B606A339;
	Tue, 17 Nov 2026 02:28:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4E2B606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=iHWDBmMW
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794882520; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=m7e4fyf2Q5mCywaw7nen7QHcArrTjTdu8X+U3sZLG8E=;
	b=iHWDBmMWqxtZUiXXN5MCDh32ysya6VqOcYP1g2stFhK7qQhD5l6rMzRsaKqLCxAUAwBWmk7PPKgw2uz84eyaYa7TSdqwsoIuscyXpFYYRJA6PTfuW2R4oh7WhA4fsxGUKgmrSBIAixmChN5gr3tPLQeAg0RVDuTq0ws3n/MTRTM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R221e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XEwnD1-_1794882519;
Received: from localhost(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0XEwnD1-_1794882519 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 17 Nov 2026 10:28:40 +0800
From: Cheng Xu <chengyou@linux.alibaba.com>
To: stable@vger.kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	leon@kernel.org,
	jgg@ziepe.ca,
	kaishen@linux.alibaba.com
Subject: [PATCH 6.6.y] RDMA/erdma: Use IRQ-safe XArray helpers for QP and CQ tables
Date: Tue, 17 Nov 2026 10:28:39 +0800
Message-ID: <20261117022839.23186-1-chengyou@linux.alibaba.com>
X-Mailer: git-send-email 2.54.0
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

[ Upstream commit 00baeade709fb66da647e8327e8398bb532e30f7 ]

Locked QP and CQ lookups from EQ interrupts can deadlock with
create-path XArray updates. If an interrupt arrives while the create
path holds the plain xa_lock, the lookup spins forever trying to
acquire the same lock.

Use IRQ-safe XArray helpers for all QP and CQ create-path updates,
including the GSI QP store and error paths. Initialize both arrays with
XA_FLAGS_LOCK_IRQ so sleeping allocations preserve interrupt state.

[ The GSI QP create path is not present in 6.6.y, so omit that hunk. ]

Fixes: 98df2aee1459 ("RDMA/erdma: Hold CQ references when processing EQ events")
Fixes: a52eeff32024 ("RDMA/erdma: Hold QP references for AE and CM processing")
Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
Link: https://patch.msgid.link/20260828030344.88021-1-chengyou@linux.alibaba.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
---
 drivers/infiniband/hw/erdma/erdma_main.c  |  4 ++--
 drivers/infiniband/hw/erdma/erdma_verbs.c | 16 ++++++++--------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_main.c b/drivers/infiniband/hw/erdma/erdma_main.c
index 0880c79a978c..6dc6c7f4fb2e 100644
--- a/drivers/infiniband/hw/erdma/erdma_main.c
+++ b/drivers/infiniband/hw/erdma/erdma_main.c
@@ -519,8 +519,8 @@ static int erdma_ib_device_add(struct pci_dev *pdev)
 	INIT_LIST_HEAD(&dev->cep_list);
 
 	spin_lock_init(&dev->lock);
-	xa_init_flags(&dev->qp_xa, XA_FLAGS_ALLOC1);
-	xa_init_flags(&dev->cq_xa, XA_FLAGS_ALLOC1);
+	xa_init_flags(&dev->qp_xa, XA_FLAGS_ALLOC1 | XA_FLAGS_LOCK_IRQ);
+	xa_init_flags(&dev->cq_xa, XA_FLAGS_ALLOC1 | XA_FLAGS_LOCK_IRQ);
 	dev->next_alloc_cqn = 1;
 	dev->next_alloc_qpn = 1;
 
diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.c b/drivers/infiniband/hw/erdma/erdma_verbs.c
index a9b2d0890570..94b3d4aea123 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -945,9 +945,9 @@ int erdma_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
 	kref_init(&qp->ref);
 	init_completion(&qp->safe_free);
 
-	ret = xa_alloc_cyclic(&dev->qp_xa, &qp->ibqp.qp_num, qp,
-			      XA_LIMIT(1, dev->attrs.max_qp - 1),
-			      &dev->next_alloc_qpn, GFP_KERNEL);
+	ret = xa_alloc_cyclic_irq(&dev->qp_xa, &qp->ibqp.qp_num, qp,
+				  XA_LIMIT(1, dev->attrs.max_qp - 1),
+				  &dev->next_alloc_qpn, GFP_KERNEL);
 	if (ret < 0) {
 		ret = -ENOMEM;
 		goto err_out;
@@ -1003,7 +1003,7 @@ int erdma_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
 	else
 		free_kernel_qp(qp);
 err_out_xa:
-	xa_erase(&dev->qp_xa, QP_ID(qp));
+	xa_erase_irq(&dev->qp_xa, QP_ID(qp));
 err_out:
 	return ret;
 }
@@ -1682,9 +1682,9 @@ int erdma_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	refcount_set(&cq->refcount, 1);
 	init_completion(&cq->free);
 
-	ret = xa_alloc_cyclic(&dev->cq_xa, &cq->cqn, cq,
-			      XA_LIMIT(1, dev->attrs.max_cq - 1),
-			      &dev->next_alloc_cqn, GFP_KERNEL);
+	ret = xa_alloc_cyclic_irq(&dev->cq_xa, &cq->cqn, cq,
+				  XA_LIMIT(1, dev->attrs.max_cq - 1),
+				  &dev->next_alloc_cqn, GFP_KERNEL);
 	if (ret < 0)
 		return ret;
 
@@ -1731,7 +1731,7 @@ int erdma_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	}
 
 err_out_xa:
-	xa_erase(&dev->cq_xa, cq->cqn);
+	xa_erase_irq(&dev->cq_xa, cq->cqn);
 
 	return ret;
 }
-- 
2.31.1

