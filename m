Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C4D336881
	for <linux-rdma@vger.kernel.org>; Thu, 26 Mar 2026 05:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774502882; cv=none; b=rQ3xFQneSEhBy5eHZVOUhp4VnoG95D7duh9NR96ZYfHr6Hdgl7ZcZCwES5b7r2bzDW6Cu9tre1xq/WoqORztsKF5Nfw2DxmO3zOT8ymdACy+iXLOMEBmyjMOM+TorktrUZaSbNjM1Zlfi8FF+xfoF/Vc8CxHTPZIoKdXB8wJ8Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774502882; c=relaxed/simple;
	bh=vOugK/UGStc9vWP014r+ntxeLyH6tPL9uJSBpftfvc8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OHW0mL38rUjJPLzIcsKTST/v7U19nqaVXd5/F83P2KHFKmb4cG5jCilB5MKsQQOV/otwePuDPtLkP7I5R7l024HgIdxVWUqctoZeMkVZ8dJYEU2Jb+912RvvNnTQu29p72TJt/zQJf5xnCFJc8AdsFZwQ1XBR0IwUOWNKsU6b24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FXhsiOm1; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FXhsiOm1"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774502879;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C9ZHnHo1G6bze3faxNdFTxzxyXUP7Ia3siUZnvSVGmU=;
	b=FXhsiOm1oxhCLByjnSI553SoiPntgG6/+ZTxE3NadoTCjkWN3Xb0OekFKOpbWvBW0x2V1W
	qKc0Lp9yB/ZAQ91uHdoQIa1T+kucoC08hZ6ZyeePvSQJCHO7E0iAwc1g653eatOseCrmJ8
	/Z4TF9YIZW2T/abaY+piLBMR47h4ntY=
From: Zhu Yanjun <yanjun.zhu@linux.dev>
To: jgg@ziepe.ca,
	leon@kernel.org,
	zyjzyj2000@gmail.com,
	linux-rdma@vger.kernel.org,
	yanjun.zhu@linux.dev,
	mie@igel.co.jp
Subject: [PATCH 1/2] RDMA/umem: Change for rdma devices has not dma device
Date: Wed, 25 Mar 2026 22:27:38 -0700
Message-ID: <20260326052739.3778-2-yanjun.zhu@linux.dev>
In-Reply-To: <20260326052739.3778-1-yanjun.zhu@linux.dev>
References: <20260326052739.3778-1-yanjun.zhu@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Current implementation requires a dma device for RDMA driver to use
dma-buf memory space as RDMA buffer.

Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
---
 drivers/infiniband/core/umem_dmabuf.c | 35 ++++++++++++++++++++++++++-
 include/rdma/ib_umem.h                |  1 +
 2 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/umem_dmabuf.c b/drivers/infiniband/core/umem_dmabuf.c
index d30f24b90bca..65c5f09f380f 100644
--- a/drivers/infiniband/core/umem_dmabuf.c
+++ b/drivers/infiniband/core/umem_dmabuf.c
@@ -142,6 +142,8 @@ ib_umem_dmabuf_get_with_dma_device(struct ib_device *device,
 		goto out_release_dmabuf;
 	}
 
+	umem_dmabuf->dmabuf = dmabuf;
+
 	umem = &umem_dmabuf->umem;
 	umem->ibdev = device;
 	umem->length = size;
@@ -152,6 +154,24 @@ ib_umem_dmabuf_get_with_dma_device(struct ib_device *device,
 	if (!ib_umem_num_pages(umem))
 		goto out_free_umem;
 
+	/* Software RDMA drivers has not dma device. Just get dmabuf from fd */
+	if (!device->dma_device) {
+		struct sg_table *sgt;
+
+		dma_resv_lock(dmabuf->resv, NULL);
+		sgt = dmabuf->ops->map_dma_buf(NULL, DMA_BIDIRECTIONAL);
+		dma_resv_unlock(dmabuf->resv);
+		if (IS_ERR(sgt)) {
+			ret = ERR_CAST(sgt);
+			goto out_free_umem;
+		}
+		umem_dmabuf->sgt = sgt;
+		goto done;
+	}
+
+	if (unlikely(!ops || !ops->move_notify))
+		goto out_free_umem;
+
 	umem_dmabuf->attach = dma_buf_dynamic_attach(
 					dmabuf,
 					dma_device,
@@ -161,6 +181,7 @@ ib_umem_dmabuf_get_with_dma_device(struct ib_device *device,
 		ret = ERR_CAST(umem_dmabuf->attach);
 		goto out_free_umem;
 	}
+done:
 	return umem_dmabuf;
 
 out_free_umem:
@@ -260,11 +281,23 @@ EXPORT_SYMBOL(ib_umem_dmabuf_revoke);
 
 void ib_umem_dmabuf_release(struct ib_umem_dmabuf *umem_dmabuf)
 {
-	struct dma_buf *dmabuf = umem_dmabuf->attach->dmabuf;
+	struct dma_buf *dmabuf = umem_dmabuf->dmabuf;
+
+	if (!umem_dmabuf->attach) {
+		if (umem_dmabuf->sgt) {
+			dma_resv_lock(dmabuf->resv, NULL);
+			dmabuf->ops->unmap_dma_buf(NULL, umem_dmabuf->sgt,
+							DMA_BIDIRECTIONAL);
+			dma_resv_unlock(dmabuf->resv);
+		}
+		goto free_dmabuf;
+	}
 
 	ib_umem_dmabuf_revoke(umem_dmabuf);
 
 	dma_buf_detach(dmabuf, umem_dmabuf->attach);
+
+free_dmabuf:
 	dma_buf_put(dmabuf);
 	kfree(umem_dmabuf);
 }
diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index 0a8e092c0ea8..6eb5760d5ca3 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -31,6 +31,7 @@ struct ib_umem {
 struct ib_umem_dmabuf {
 	struct ib_umem umem;
 	struct dma_buf_attachment *attach;
+	struct dma_buf *dmabuf;
 	struct sg_table *sgt;
 	struct scatterlist *first_sg;
 	struct scatterlist *last_sg;
-- 
2.53.0

