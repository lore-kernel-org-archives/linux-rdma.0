Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D6E4CA268
	for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 17:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655980; cv=none; b=A3nNQmXImkSQd4fdnAcvqF5W3q/VWWYL2vE4mOi7l5SjMxgfCn9E/8g7k7YY97qyFW8xnETmChO1hYBVo88v+X3CmbGSPhg8XtENnnYX0DNSxOo7u48YLoIilPBX91KvvTj/qN6OpdgYqwa+zaclXNdj0YFcVpYy502tK7XTtHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655980; c=relaxed/simple;
	bh=gyTrkaup4Ks5bfaG/FoabYF4rN440J0V60i2qS5Yijs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzoL7JYltfFw27HeavGwxZFUjUvbi71guwkI4zON/G6PzN/cgfOSiJuzscbId7RslFqKtoT298cNmAubgH2VXfm+3Og6SXRGEa/heHVLYKuUaEo5GI5k0iwi6uSuYSqVhnbUIgSta/mEpyXgdwITksqr59AAoAEbpV6GDQ6LxUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=NjrQ99bM; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="NjrQ99bM"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-47f707e5d75so1888042f8f.1
        for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 10:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784655977; x=1785260777; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AadYXUkLInAYH0JaK/HqdbVk2juyzp5yk+Dx6h3Mv+o=;
        b=NjrQ99bMf3IJfIqwLL+iZ4YUDFQ9yYv1rfZV+XAbFeUCMZ0Dj+3xjWKK/s4gkXyf8K
         WTHUNJ9WHftTSjNO/b98ZD11mOoHTLTBjrqjYzsHdoDjKM3qPTDWrdTU0NwowVa/n7J7
         s7QyXB/PaTTftO8jJM5CMRsIJ2gXZ05oUIYuGfkhyk2xc/TMKoUDw6vpPguIhLLrV6te
         z1h8Yg7MzK3HXxN/ixLzMyUq1SSH/0zxwoZ2hLjoUZUnFda6NZI6U5fRYt6tnA/AuyyJ
         R1IBNjyePCxdbZerUX8r+QpnfuorkoPJY82FOlOvi53qRrdY6Ac3qo59c68QijhUugqD
         2ouA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784655977; x=1785260777;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AadYXUkLInAYH0JaK/HqdbVk2juyzp5yk+Dx6h3Mv+o=;
        b=GX8LsPBMNB5dNFg28Cnu+1mLoFRD8t2S7jgTdI4stfTm5SF1rQR+O+q3rBE6DRYYgj
         jOkcGeNbxc3gJ8vZuUHLG/rjMk8k/M5crWqia4VfyYz37UIH2LOuyZ1DcYZEPat4NkCH
         IQq5HJV9U/4oKrmc+AAD3uBSBTehdS32HsC/FRBAmkO/jihcMdC9BWqi2VR3Jv+dHkDC
         TfHHYn/i03jlwnG2RUjNe8WRzvJvDCXWxLKDP0OTPU6h8nYw9v6Yu0+u+mTXODeRzGy3
         MeHRkD18ukIVIkLsMFEjN+TNbDN0lXW/jkLjGbaW5LICLlswOpGvID5GB2LU5OJMw8U7
         CSpw==
X-Forwarded-Encrypted: i=1; AHgh+Rp66HgU1Ie5tWvQ7JWSsAamgUvxwvAgwwoEK9S2fTakWRg2VVun0Vcedup7OK7u9VDs+TCwyRhnV/Yo@vger.kernel.org
X-Gm-Message-State: AOJu0YzscQkEKHGFO2YK97yz6jnzvrctoVFxUEBicTkuxucqyAeTxtJd
	fWIpqnpMTnAnR+a+fGQ1NDzFNWgmOb+P6HHQUx1kEHyRDrCCPbLnWwGakN+avTFw1Q==
X-Gm-Gg: AR+sD122dgJeW4EmFfY7qDJL3SJQppBU8udYSkLfKbmsbBcBgV9JizpY4j5p/Qu0hAo
	bSk+DfPzMCU9SBlX+QAYuM5oRzyyNu3NXMw8/yqFIEMWZr6nPyk62//ZdIOaooWsEr9HfxUhYvH
	/4G0cE8zkzN8jP/sO0UyPjnFKzHfkOx1NwKnjgvCD2iF/WEHffjjoINE1/JdLrMQn1wNy+0m/ki
	g00dqimJjYvEy9eQGaO+pwd6C8Ef5OlNBpydHOb3jZLh1lC1dAliO31gqXfbEe4rPYpjNngZG6z
	jo2yrkWsJ9RuBxjl0/6ca3/bWw5BNqR0HlcvFiMGBPdRiQTYVlCH9Z1OSAybbN+LO/BInuxKjya
	VMKPl49bIMVOknJ6r7XBzeXCKRYxFyYvCaJlvyba3XOMRc/nBSXlHWamo2PkRosJ7tUdAq1Y8NC
	hefC81QUBgk4c29qlJ6u3q6v53Zh0Dv3xNE6O/uvlffoERAs4=
X-Received: by 2002:a05:6000:1ace:b0:477:71ef:5d81 with SMTP id ffacd0b85a97d-47f62305373mr23603687f8f.6.1784655976544;
        Tue, 21 Jul 2026 10:46:16 -0700 (PDT)
Received: from ai-pc ([46.172.241.174])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63eddd27sm40860513f8f.28.2026.07.21.10.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 10:46:16 -0700 (PDT)
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
Subject: [PATCH v3 8/8] nvme-rdma: return BLK_STS_TARGET for unsupported P2P transfers
Date: Tue, 21 Jul 2026 19:45:02 +0200
Message-ID: <20260721174502.111503-9-mykola@meshstor.io>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260721174502.111503-1-mykola@meshstor.io>
References: <20260721174502.111503-1-mykola@meshstor.io>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ib_dma_map_sg() returns 0 on a P2P mapping failure, losing the DMA
layer's -EREMOTEIO, so nvme-rdma reports a path error.
Default multipath requeues the I/O forever, and without multipath
it burns nvme_max_retries requeues, then completes as retryable
BLK_STS_TRANSPORT.

Map the data and metadata scatterlists with
ib_dma_map_sgtable_attrs() and return BLK_STS_TARGET for -EREMOTEIO,
matching nvme-pci (commit 91fb2b6052f7 ("nvme-pci: convert to using
dma_map_sgtable()")).
Scatterlists stay: ib_map_mr_sg() consumes them, so blk_rq_dma_map
does not apply.

Start the request only after mapping succeeds so multipath
accounting is never taken for an unmapped request, and ratelimit
the map-failure message.

Fixes: 23528aa3320a ("nvme: enable PCI P2PDMA support for RDMA transport")
Cc: stable@vger.kernel.org # v7.1
Assisted-by: Claude:claude-fable-5
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
---
 drivers/nvme/host/rdma.c | 38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 6909e3542794..f8edb23552ad 100644
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
+		ret = BLK_STS_TARGET;
 	else
 		ret = BLK_STS_IOERR;
 	nvme_cleanup_cmd(rq);
-- 
2.52.0

