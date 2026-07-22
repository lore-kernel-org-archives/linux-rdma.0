Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D76442B13
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 18:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784746767; cv=none; b=EnR76BKbpsbtraBk206qAs5oQEUXWB083yaPQCj79MAhr5WCFvewI0ef1UUGzZ34eSkAHGd8H29hltTy6C6R5ToXiWTIe8xd3+kkwBkrOOGAM6Cq1x1bS85Q2aCXhnAAvw8liYMtXgb5JEtV9IXZp+mEYbJ5Paec9DZdu2ThjJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784746767; c=relaxed/simple;
	bh=PFyLWHE9pTJ4175QPKDcNHyfOtGQRFYQNlkqnpPL1lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDsh/k6SyV0ythyKiIGfb/HBLFZrnee6kxTpZ0eG1a4Pp1tAQy6M8Z8CgjcPabZYWxXOc4Yxbvxgqm3irsRELHgW0pih6TLATPtYHMGDt2xoiNSpxHklhnp1ElXeybz5xmMAq3daJfEwpk4U+ejP08waAoFMlrsGvCnxxybWwUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=gFkA1PYc; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="gFkA1PYc"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-493f6de72faso45306285e9.0
        for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 11:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784746759; x=1785351559; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZyX4ma10pC/frHu+Y/NUZniwvhp9EvBkdSwrv0doV3k=;
        b=gFkA1PYcdgJBj7Vk0LpWIXQdy5xoIr7JDJ4V6i5w+Cvel3qWwN8RjqopjcOvvtLeMM
         uBqArxT30CfTjh0676/kjNn2ppFN731beeq9rT71vPCEeMveVlDaadsU54BS0g55Vd9i
         rAYDk044Y5AnWmYPGvtkJtk3GSJ8Yr8SRmpRQK1DkmZEcGTlkXrF5dLRlooBfwJI5eLH
         6fsDprOXAb51C2TyF8cYKU5NK5+jJi4SjQq5AYe0ragqMg7YykVIzzSw9P39yIym5uVr
         1aK+008mvyyLPI8ftiReDk5SFbPVFZ2UnJ09yY1ZYjvjB1rVitvOviOPkHiza7yzEJeV
         WKRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784746759; x=1785351559;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZyX4ma10pC/frHu+Y/NUZniwvhp9EvBkdSwrv0doV3k=;
        b=siPjYjpe4k2/OZvNxGqP8y9EsiUV9xUymERPQELkLQVLeoZqXw41spE1LoL8LKHGLb
         7pse0fV0qx/lRkYPu1TOYb0w1wq+GXfMr/6GMDn1UBXFVfuUrEjjjImX/tp8VCpcexa9
         RKO7RD4xVcXvzb5JNNL6eiJSJjye6Jqv4Q4hzESt/Qzu3jYPFi65aHN054KAF8HNtubA
         CCArfyOliZifOPEWmcy3REkyly2PhYknOCJ+dSiRZRwvtrzmmLC59LLffSrxm15NNIu8
         xId6kv7V17IsJJuglMBmsrnpaTdaTJncFaMjlwIv3r0QaX/tQAATB6Hd42OpAJv4MOEe
         A/wA==
X-Forwarded-Encrypted: i=1; AHgh+RrteTswecmKGlGuNenJrys199ybItTAFSbyC+oa9cyK3d22BuMzG+RdKKwyARVB10Xu612jIdVAJF8o@vger.kernel.org
X-Gm-Message-State: AOJu0YxEQIb/cBovZvj5cVZRgLPAoXg+YbFj/o0vpDCeiKZYWxi/X3xs
	W3SYBkOBaiBbwY+8stbsf4yM0aiI4cQHRRPjlMhpAZTGwFXm3iYOj8W2nAekA9efbw==
X-Gm-Gg: AR+sD11oQuo0/ssw2jRS39gUopVF/SWgMr2wELnvHhN3F1cebseNvDJuePeKf7aC7tG
	KAifHaJgjd2gJMOwWzVe8SB/6AMUIun6COBD12Gs6D1S9pe3l2L+7Hf1D/YPlNFYBw/ou3fhgy/
	wBHIw6FRWAmEEqL3eFZmRINkSxgBodkh7Bvoh86sgGohBVYEiegK0KClQ0gn0iGyfIthZhIT1Q+
	buv7khYeKsgkt6uQwQx2TJ2IAF0wGxtblo1upO6t6Ndh4C5H/WSQyzKONkOV6ViWsGKM3v8d8O8
	fj/EGE8FALN1HtHkzkqrqaiKk/xFonbtsPJbMRIm993R4LrCKh0zXRGFO+472pw3/hFqO8onQxb
	nTM4kNyLEiuIlVSHv7jdn3SXckoqb2zv4P8M+EGm6xBEBV0GBav3VzCk0adconhT6IpVKvwnrtO
	F6rrXbYid31eONpUR/YTE3E7UjE/KxMrc4GRpKZD0oFaEcQek=
X-Received: by 2002:a05:600c:6610:b0:492:6f5c:fd8c with SMTP id 5b1f17b1804b1-4956a511b49mr53704175e9.15.1784746758682;
        Wed, 22 Jul 2026 11:59:18 -0700 (PDT)
Received: from ai-pc ([46.172.241.174])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-495730353d9sm13740055e9.12.2026.07.22.11.59.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 11:59:18 -0700 (PDT)
From: Mykola Marzhan <mykola@meshstor.io>
To: Jens Axboe <axboe@kernel.dk>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-nvme@lists.infradead.org
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Guoqing Jiang <guoqing.jiang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kiran Kumar Modukuri <kmodukuri@nvidia.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Shivaji Kant <shivajikant@google.com>,
	Pranjal Shrivastava <praan@google.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-pci@vger.kernel.org
Subject: [PATCH v4 9/9] nvme-rdma: return BLK_STS_P2PDMA for unsupported P2P transfers
Date: Wed, 22 Jul 2026 20:58:41 +0200
Message-ID: <20260722185841.449934-10-mykola@meshstor.io>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260722185841.449934-1-mykola@meshstor.io>
References: <20260722185841.449934-1-mykola@meshstor.io>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the PCIe topology cannot route a P2P transfer between two devices,
the DMA layer fails the mapping with -EREMOTEIO, but ib_dma_map_sg()
returns 0 and the error is lost. nvme-rdma then fails the I/O with a
retryable status, so multipath requeues it forever and a single path
wastes its whole retry budget on an I/O that can never succeed.

Map the data and metadata scatterlists with ib_dma_map_sgtable_attrs(),
which preserves the error, and translate -EREMOTEIO to the new
BLK_STS_P2PDMA status so the request fails fast instead of being
retried. While at it, call nvme_start_request() only after mapping
succeeds and ratelimit the map-failure message.

Fixes: 23528aa3320a ("nvme: enable PCI P2PDMA support for RDMA transport")
Cc: stable@vger.kernel.org # v7.1
Assisted-by: Claude:claude-fable-5
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
---
 drivers/nvme/host/rdma.c | 38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 6909e3542794..2f50509a7a61 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1469,6 +1469,7 @@ static int nvme_rdma_dma_map_req(struct ib_device *ibdev, struct request *rq,
 		int *count, int *pi_count)
 {
 	struct nvme_rdma_request *req = blk_mq_rq_to_pdu(rq);
+	struct sg_table sgt;
 	int ret;
 
 	req->data_sgl.sg_table.sgl = (struct scatterlist *)(req + 1);
@@ -1480,12 +1481,14 @@ static int nvme_rdma_dma_map_req(struct ib_device *ibdev, struct request *rq,
 
 	req->data_sgl.nents = blk_rq_map_sg(rq, req->data_sgl.sg_table.sgl);
 
-	*count = ib_dma_map_sg(ibdev, req->data_sgl.sg_table.sgl,
-			       req->data_sgl.nents, rq_dma_dir(rq));
-	if (unlikely(*count <= 0)) {
-		ret = -EIO;
+	sgt = (struct sg_table) {
+		.sgl		= req->data_sgl.sg_table.sgl,
+		.orig_nents	= req->data_sgl.nents,
+	};
+	ret = ib_dma_map_sgtable_attrs(ibdev, &sgt, rq_dma_dir(rq), 0);
+	if (unlikely(ret))
 		goto out_free_table;
-	}
+	*count = sgt.nents;
 
 	if (blk_integrity_rq(rq)) {
 		req->metadata_sgl->sg_table.sgl =
@@ -1501,14 +1504,14 @@ static int nvme_rdma_dma_map_req(struct ib_device *ibdev, struct request *rq,
 
 		req->metadata_sgl->nents = blk_rq_map_integrity_sg(rq,
 				req->metadata_sgl->sg_table.sgl);
-		*pi_count = ib_dma_map_sg(ibdev,
-					  req->metadata_sgl->sg_table.sgl,
-					  req->metadata_sgl->nents,
-					  rq_dma_dir(rq));
-		if (unlikely(*pi_count <= 0)) {
-			ret = -EIO;
+		sgt = (struct sg_table) {
+			.sgl		= req->metadata_sgl->sg_table.sgl,
+			.orig_nents	= req->metadata_sgl->nents,
+		};
+		ret = ib_dma_map_sgtable_attrs(ibdev, &sgt, rq_dma_dir(rq), 0);
+		if (unlikely(ret))
 			goto out_free_pi_table;
-		}
+		*pi_count = sgt.nents;
 	}
 
 	return 0;
@@ -2026,8 +2029,6 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
 	if (ret)
 		goto unmap_qe;
 
-	nvme_start_request(rq);
-
 	if (IS_ENABLED(CONFIG_BLK_DEV_INTEGRITY) &&
 	    queue->pi_support &&
 	    (c->common.opcode == nvme_cmd_write ||
@@ -2039,11 +2040,13 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 	err = nvme_rdma_map_data(queue, rq, c);
 	if (unlikely(err < 0)) {
-		dev_err(queue->ctrl->ctrl.device,
-			     "Failed to map data (%d)\n", err);
+		dev_err_ratelimited(queue->ctrl->ctrl.device,
+				    "Failed to map data (%d)\n", err);
 		goto err;
 	}
 
+	nvme_start_request(rq);
+
 	sqe->cqe.done = nvme_rdma_send_done;
 
 	ib_dma_sync_single_for_device(dev, sqe->dma,
@@ -2063,6 +2066,9 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
 		ret = nvme_host_path_error(rq);
 	else if (err == -ENOMEM || err == -EAGAIN)
 		ret = BLK_STS_RESOURCE;
+	/* Peer memory unreachable from this device: don't retry. */
+	else if (err == -EREMOTEIO)
+		ret = BLK_STS_P2PDMA;
 	else
 		ret = BLK_STS_IOERR;
 	nvme_cleanup_cmd(rq);
-- 
2.52.0

