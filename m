Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925BD3876B2
	for <linux-rdma@vger.kernel.org>; Sun, 26 Jul 2026 11:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785065578; cv=none; b=Hl5Uzz02DlV0hdOYTlestynOY2BZuUUI4VGJDfKyhpHqoGga5gwZds0Sau446E7BUC5j+w9mfSHjNfRDFnGLNvJ+WZqE33YrNDqASqRlzpCoH3PjMAiEzfB8fvOwVjTEO+DHlUZ2P8iBLv4kk3Wx7JozRI5BW7ITbUnKJZkWEhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785065578; c=relaxed/simple;
	bh=k8p26WkV8yppHusL3y+jBuuoZ4KH1m/7UvNpr9ifj8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bA7nKVbDr5wLhEYkEnLjQ0ABln2dMLnBKQqpmS/3uN+przEikrCncWmU2G1T79EAjVykglvh1BpoipP93FtyCjnVP6Ueu069Vh/DnKjPLuJxq6tRYIE3urByGC6fMHdcy4/VIqGwMsR0EN5TKLogB/+msW2LNZf6jV9C73FAjpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=k/bYnuPP; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="k/bYnuPP"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4798bea72f9so1106695f8f.1
        for <linux-rdma@vger.kernel.org>; Sun, 26 Jul 2026 04:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1785065575; x=1785670375; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oTKfzdoHRmbK0b3PUxeuF9crncxafNJvwFc9FNFZP5k=;
        b=k/bYnuPP48pir7rE37mlrhKAXwf28oqwMSy9lScuF+wAna59o00v29RFx6/4gLo4Pi
         7lNLPY/wBZQhMAaG9ZlPhayiC69e0EE45qFLmariUiT1N0Y6pmSBYAfi9XPTYQBplO3i
         CRICOgifSe+V6NWj8uo8yHcND5gRqN1GAzgK3moihv5eVd0NGS9g4p8xjkVjl7ZVWJPM
         tV0bv9zxEWOXIxzDKnI2hjRH/fBc1dI3Bzd+DW/8bv5Od+2qSTg8kPClpnJAtcQ3TRbI
         FnYQcSH0QnbyL7KY0tPxMo1DR8TceJrT9QFFmjU5dOp9fYUVE0z5zEoC8Qfv0VWiivBB
         Wr6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785065575; x=1785670375;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oTKfzdoHRmbK0b3PUxeuF9crncxafNJvwFc9FNFZP5k=;
        b=agp9lKdrQBFgiPS7E6Y2IkgYxxeYqorCFFYvb2fQTcVDPFhOiha8WWc5h4ebPncW0D
         DgbeASnRG7JCIdEGDdGlmE45RdK0s4i7kXUJNYfnEAf7vjEmQLF4yKTGuutxa9kjdHTJ
         h7e3UYMXEBSIf5GX6D7uvX2XU1p5uw/AcIYkgwB1PyZkubZGHyE3CCTj2HEfOKebS0je
         G8elUrCdctq/QEy4Nq2iO+K6tP9pdfBtW5dl9175X1tYZAhbMDbzTl05lWzHeEHgZADl
         lPgQ+rTiHRLyGWOKQ8ELCFAN70bl5V0o9MD3a1DomacKwJm7IVrhJjiIqwOvRdKDFA4q
         exNA==
X-Forwarded-Encrypted: i=1; AHgh+Rppr1ZANeUSAmYPKOYa5xDT22Mr4+aT/HqfHpHnfrBDX+vv3hAiG70nyYeDrxC4fHiWtFaMFtl54LfM@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/c+GkvKNkHx6iPLZehojBqXh8iO88qThsdSTl0Kli5Uqlq0wt
	XDS8jZtbxDIzND9VNceTyYjDqwMg7Bj/mE+w9evBB+tIHQR9icdJvz8j/PHPx25VWQ==
X-Gm-Gg: AR+sD12FGBty/YJ6N6TANpWd/G8WqcKM6ae01SEadpS+3ZFnt8wWMCEW8NbfJI3NiRn
	sfWpIK8SAetAG9MWYf9bWap+Y9pXVp+R8WaHPDBqupapb6GMzM65NprQJ1rBVvouVSbzkmgPtLD
	ACuoDCdb/F1Vxc2a8Rcme8Og9C9fULiIVhZgZm4FfQ3Jequuh2i7se7tOa0WsSINTdInhKEFRWs
	3gGXs3N58MHdKKjkL+dcIbMt2FVQ3O1cLqy0sqhnoz5VW0A0aHTsphmYS3GA6bivgLmvGktpIxv
	WzWU8pUOoufFkoOgWKkH4o3SBPEtVIWmrR9E2QBbIVSaN0Mv7r3J0gYSrAn0M/hOukt0mhcrzIo
	XKDVEPbB3kXGht0n1MHgc6epA+je3q8LO+1nFs9GcZCnlu/NKKBs3R32Y79Zy+VkXd4V+M1c6+J
	CSYzfjTlbX/Z9x8TgA0rWH/5F8+tWZxobF5zpG4e29aiit6CSrRtto/Q+805V5OjCysc4OTMhBD
	Tu8//ND4DBs9b/9ibW2rpuuY84oEEfWtGDkc+nlpQ==
X-Received: by 2002:a05:6000:4b15:b0:47f:81c6:5a38 with SMTP id ffacd0b85a97d-47f9fc995a0mr6140837f8f.18.1785065574895;
        Sun, 26 Jul 2026 04:32:54 -0700 (PDT)
Received: from meshstor-pc ([185.87.42.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85bb57cfsm40533083f8f.11.2026.07.26.04.32.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 04:32:54 -0700 (PDT)
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
	stable@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-pci@vger.kernel.org,
	Thorsten Leemhuis <regressions@leemhuis.info>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v6 09/12] nvme-rdma: use ib_dma_map_sgtable_attrs()
Date: Sun, 26 Jul 2026 13:32:26 +0200
Message-ID: <20260726113229.2154269-10-mykola@meshstor.io>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260726113229.2154269-1-mykola@meshstor.io>
References: <20260726113229.2154269-1-mykola@meshstor.io>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ib_dma_map_sg() folds every mapping error into a zero return, losing
the DMA layer's error code.  Switch both scatterlist mappings to
ib_dma_map_sgtable_attrs(), which preserves it for the next patch to
act on.  No behavior change: failures are still reported as -EIO.

A local sg_table is needed: dma_map_sgtable() maps orig_nents
entries, and the embedded table's orig_nents is the allocated count,
not the count blk_rq_map_sg() produced.  rdma_rw_ctx_init() does the
same.

Assisted-by: Claude:claude-fable-5
Cc: stable@vger.kernel.org # v7.1
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/nvme/host/rdma.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 6909e3542794..63830334c73e 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1469,6 +1469,7 @@ static int nvme_rdma_dma_map_req(struct ib_device *ibdev, struct request *rq,
 		int *count, int *pi_count)
 {
 	struct nvme_rdma_request *req = blk_mq_rq_to_pdu(rq);
+	struct sg_table sgt;
 	int ret;
 
 	req->data_sgl.sg_table.sgl = (struct scatterlist *)(req + 1);
@@ -1480,12 +1481,16 @@ static int nvme_rdma_dma_map_req(struct ib_device *ibdev, struct request *rq,
 
 	req->data_sgl.nents = blk_rq_map_sg(rq, req->data_sgl.sg_table.sgl);
 
-	*count = ib_dma_map_sg(ibdev, req->data_sgl.sg_table.sgl,
-			       req->data_sgl.nents, rq_dma_dir(rq));
-	if (unlikely(*count <= 0)) {
+	sgt = (struct sg_table) {
+		.sgl		= req->data_sgl.sg_table.sgl,
+		.orig_nents	= req->data_sgl.nents,
+	};
+	ret = ib_dma_map_sgtable_attrs(ibdev, &sgt, rq_dma_dir(rq), 0);
+	if (unlikely(ret)) {
 		ret = -EIO;
 		goto out_free_table;
 	}
+	*count = sgt.nents;
 
 	if (blk_integrity_rq(rq)) {
 		req->metadata_sgl->sg_table.sgl =
@@ -1501,14 +1506,16 @@ static int nvme_rdma_dma_map_req(struct ib_device *ibdev, struct request *rq,
 
 		req->metadata_sgl->nents = blk_rq_map_integrity_sg(rq,
 				req->metadata_sgl->sg_table.sgl);
-		*pi_count = ib_dma_map_sg(ibdev,
-					  req->metadata_sgl->sg_table.sgl,
-					  req->metadata_sgl->nents,
-					  rq_dma_dir(rq));
-		if (unlikely(*pi_count <= 0)) {
+		sgt = (struct sg_table) {
+			.sgl		= req->metadata_sgl->sg_table.sgl,
+			.orig_nents	= req->metadata_sgl->nents,
+		};
+		ret = ib_dma_map_sgtable_attrs(ibdev, &sgt, rq_dma_dir(rq), 0);
+		if (unlikely(ret)) {
 			ret = -EIO;
 			goto out_free_pi_table;
 		}
+		*pi_count = sgt.nents;
 	}
 
 	return 0;
-- 
2.52.0

