Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2553E022E
	for <linux-rdma@vger.kernel.org>; Sat, 18 Jul 2026 16:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784391993; cv=none; b=c0z+YJTRRLdd7EWbDfNoF8zRgYqN0pEt6trG9oef5Alpzy0ERQwSLlmxqm7ZG/SddVz1rLtaRdiWyH94P7UzeuwyOFqD9dvdNUb6qOtxPR56GXxf0Z9uvuSbmXxchrVGJ1t9+c+bUDlx8ONIhcd6zNcdNuVxacduYlgyEvdzeXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784391993; c=relaxed/simple;
	bh=JHE3cgZBQuIzT0YLZJnapzbT3KS4Yu6cNSzhz+WZwJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nn4Re1e7hRhuB3zqF2cpiIN7lHZfQUpBD/DGSlrzZ5u0E9IYRwG9IMh4Y70lhpkjLm7D8smeNG3s0dFn/FukXzVCVRqMuwv//jF7LDXziksq23Ml3E9lrzD1rzTRNx7TAfpUbYBnU7pM+fmxDSMKNlo0CecLVu9Tm3AT4JCchKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=Ik4jzfuI; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="Ik4jzfuI"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-49556f97a9dso606465e9.1
        for <linux-rdma@vger.kernel.org>; Sat, 18 Jul 2026 09:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784391989; x=1784996789; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dagmucy3ghWM9/yf2A3Q3PwS7L9VrlH2jBuQsiQB1xw=;
        b=Ik4jzfuI2OC3tJDIWdBrOtKEGBnKFGa+39d+vEvYcxV04LRRmwPN20ctAHgRVj1niX
         EiV9aIEQ2mLaPV372bAo0xSOF2QXE9Yszg2/FXVRQ4KAETSuVNx8L58Des6aBUOg05Vo
         EgyPY3X28/yAIy+cxvUNZEV9aGfsZkxJfExXiiKglWawDqmy+9x2UZrnRBjXq0YYNNeF
         BegFi4GAdcuB1Th51AELhSGM8lrtlT1f80vyMGCDMFn9hPnibOO+ErScPkZAQEibNwL1
         1cNgVx/jDGOTUZ3VleHvTVRtPLEfOkBUIJ3VVJxm2BqZSGEMLMq5jRYreAlT3xQthuuE
         3NmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784391989; x=1784996789;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dagmucy3ghWM9/yf2A3Q3PwS7L9VrlH2jBuQsiQB1xw=;
        b=gBUU1sF0odHi//wBYb5cqD6pmotE7Q/Zxd6VOPpoJDa8he/9KHEZB/7a6TGU9s6siT
         efxqF97OyT3Yln2f668aB6nT7zTSarEBuziLS+/Zm22WigNgO6G57oti+fPv6yNuJRjD
         M6G8MqQOLx8L/vctCxTq4wJK0PRsQ3Nzav3ZS9jPvhUGMaEj8VsNYcY2gVyQtq6eM7VE
         zyF5wTqZARcE+jEFLcUShyC2H5WjrsF4nc6uHEVOkIyDsQYebGpvBOGqQocmZtBavHnH
         bfFDOT+V68jIwzfRSo0B1SXEZlSP2X0rTucGCYYLy9SQbHz3BQGNBMUCY8yFEET1/yVF
         oPTw==
X-Forwarded-Encrypted: i=1; AHgh+RrYZgM7nG96OyWRrEiEYzMVEMkU2ZEP2F5WrxFPx32QkwoezZSppy2T2k4Pt1B1NjIzk+CtXGS5jSes@vger.kernel.org
X-Gm-Message-State: AOJu0Yzff8A/IEqY4rh8VNSnevZAfI26JPOAhWG2i4XqECgh3PrUOhCf
	xg9NaQ1rFvy7eIU6Y/xE8jy8RDz8oeQHYIO84z8sbelsGJo1gKtCGPrdkJwfy9afQA==
X-Gm-Gg: AfdE7cnVrqIAyK3apVFZkRWy/CLxlCBu3/oEDqM+q8PzpO51OFJi8P+Y6SP6uZRaIki
	DgQGIYtJimN3D/xYAnVMrWeAoPyEhNtajubNcb1tx6IhBVh65xOGXg6P6/K3RZwRxuctFp3bclL
	wLWKCiaXx01MAiHjlhgkxxN8jTVvhH9wyFgIqXNfL0+xjU4Kwx2mb7HjPU0BFXPt4F5qRQgVHIo
	BPiRhdeCF/3+TwvwgL4tGbz9dfmwar9PlxyIV4B/WMsPF9dWwRTKAnlf7FmPbWygyiiIRb1i/WI
	9Q4B1/eufdoriijB454Du8qXvQklVgqgblg/9z12cvjcvynHKG89oAHgApMuEzV0SQWnmm2R9uN
	bSZX0iWmoIbe2aLplCGH/1nlEPFBQBJaXW2flMu0bvxCjxqmpaGwoG1k5E9Zalg==
X-Received: by 2002:a05:600c:1549:b0:493:c601:3e23 with SMTP id 5b1f17b1804b1-4954a3d08c0mr76801375e9.5.1784391988987;
        Sat, 18 Jul 2026 09:26:28 -0700 (PDT)
Received: from mf-00-01.. ([194.220.239.180])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954a2eddb8sm266444085e9.14.2026.07.18.09.26.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2026 09:26:28 -0700 (PDT)
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
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
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
Subject: [PATCH 6/6] nvme-rdma: return BLK_STS_TARGET for unsupported P2P transfers
Date: Sat, 18 Jul 2026 16:25:47 +0000
Message-ID: <20260718162547.448892-7-mykola@meshstor.io>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260718162547.448892-1-mykola@meshstor.io>
References: <20260718162547.448892-1-mykola@meshstor.io>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit 23528aa3320a ("nvme: enable PCI P2PDMA support for RDMA
transport") nvme-rdma accepts P2PDMA bios, but a mapping failure for
peer memory the HCA cannot reach is misreported as a path error:
ib_dma_map_sg() returns 0, discarding the -EREMOTEIO that
dma_map_sgtable() documents for exactly this case, and the driver
converts it to -EIO -> nvme_host_path_error().

Under the default multipath configuration (the multipath head node
advertises BLK_FEAT_PCI_P2PDMA since commit fb0eeeed91f3
("nvme-multipath: enable PCI P2PDMA for multipath devices")) the
path-error status makes nvme_failover_req() requeue the bios with a
fresh retry budget each cycle, and since the mapping failure is a
deterministic property of the peer/device pairing the I/O simply
never completes: a hot requeue livelock, and a stacked md mirror
hangs instead of failing over to its other leg.  With
nvme_core.multipath=N the request burns nvme_max_retries requeues --
nothing ever reaching the wire -- and completes as
BLK_STS_TRANSPORT, which blk_path_error() classifies as retryable
and md/raid1,raid10 treat as a genuine device error: retry storms on
writes, read-error-budget eviction of a healthy member on reads (see
the preceding md patches, whose mapping-failure handling keys on
BLK_STS_TARGET).

Map the data scatterlist with ib_dma_map_sgtable_attrs() so the DMA
layer's error code is preserved, and translate -EREMOTEIO to
BLK_STS_TARGET: the classification nvme-pci established in commit
91fb2b6052f7 ("nvme-pci: convert to using dma_map_sgtable()") and
the preceding blk-mq-dma patch restores (the blk_rq_dma_map
conversion had changed it to BLK_STS_INVAL).  The failure is a
property of the peer/device pairing, so it must not be retried on
this or another path.  Start the request only after mapping
succeeds, as nvme-pci does: a mapping failure now errors out of
queue_rq on a not-yet-started request, so nvme_mpath_start_request()
accounting is never taken and cannot leak on the direct blk-mq
completion (this also closes the same latent leak for the existing
BLK_STS_IOERR returns).  A mapping -ENOMEM now takes the existing
BLK_STS_RESOURCE branch instead of masquerading as a path error, and
a DMA-layer -EINVAL completes as BLK_STS_IOERR instead of a path
error; generic -EIO keeps today's host-path-error behavior, and
virt-DMA devices are unaffected.  The metadata scatterlist keeps
ib_dma_map_sg(): integrity buffers are host memory and cannot
produce -EREMOTEIO.  Ratelimit the map-failure message -- with an md
mirror steering peer-memory I/O around an unreachable leg it fires
per redirected I/O, not per rare event.

Fixes: 23528aa3320a ("nvme: enable PCI P2PDMA support for RDMA transport")
Cc: stable@vger.kernel.org # v7.1
Assisted-by: Claude:claude-fable-5
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
---
 drivers/nvme/host/rdma.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 6909e3542794..b8642cd2fb79 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1469,6 +1469,7 @@ static int nvme_rdma_dma_map_req(struct ib_device *ibdev, struct request *rq,
 		int *count, int *pi_count)
 {
 	struct nvme_rdma_request *req = blk_mq_rq_to_pdu(rq);
+	struct sg_table sgt;
 	int ret;
 
 	req->data_sgl.sg_table.sgl = (struct scatterlist *)(req + 1);
@@ -1480,12 +1481,12 @@ static int nvme_rdma_dma_map_req(struct ib_device *ibdev, struct request *rq,
 
 	req->data_sgl.nents = blk_rq_map_sg(rq, req->data_sgl.sg_table.sgl);
 
-	*count = ib_dma_map_sg(ibdev, req->data_sgl.sg_table.sgl,
-			       req->data_sgl.nents, rq_dma_dir(rq));
-	if (unlikely(*count <= 0)) {
-		ret = -EIO;
+	sgt.sgl = req->data_sgl.sg_table.sgl;
+	sgt.orig_nents = req->data_sgl.nents;
+	ret = ib_dma_map_sgtable_attrs(ibdev, &sgt, rq_dma_dir(rq), 0);
+	if (unlikely(ret))
 		goto out_free_table;
-	}
+	*count = sgt.nents;
 
 	if (blk_integrity_rq(rq)) {
 		req->metadata_sgl->sg_table.sgl =
@@ -2026,8 +2027,6 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
 	if (ret)
 		goto unmap_qe;
 
-	nvme_start_request(rq);
-
 	if (IS_ENABLED(CONFIG_BLK_DEV_INTEGRITY) &&
 	    queue->pi_support &&
 	    (c->common.opcode == nvme_cmd_write ||
@@ -2039,11 +2038,13 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
 
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
@@ -2063,6 +2064,13 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
 		ret = nvme_host_path_error(rq);
 	else if (err == -ENOMEM || err == -EAGAIN)
 		ret = BLK_STS_RESOURCE;
+	/*
+	 * The DMA layer refused to map peer memory to this device: a
+	 * property of the pairing, not a path failure.  Match nvme-pci
+	 * and do not retry (see blk_path_error()).
+	 */
+	else if (err == -EREMOTEIO)
+		ret = BLK_STS_TARGET;
 	else
 		ret = BLK_STS_IOERR;
 	nvme_cleanup_cmd(rq);
-- 
2.43.0

