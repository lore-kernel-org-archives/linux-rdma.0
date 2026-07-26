Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65413AD530
	for <linux-rdma@vger.kernel.org>; Sun, 26 Jul 2026 11:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785065580; cv=none; b=aKCPrvYazLbo95de4V3h52+ApDC26LOOrC1leKPnOtTQLpUmlPPkl9m3ENizATd1iPq4Mg0WhKuiUYPPvykqJTnihHR3HR8/TFXFEuqMpVcikUsvPknMffHFmn4FppHrv2q+v7yQIAwnVgU74A2jeflLuz8+Evhqxk709bArT4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785065580; c=relaxed/simple;
	bh=LIKGSwTHk/Z7QGi6uThgc0YT2/Kgyfzgt73cDAjhDoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HeHD55ZOE9dLdZ9c63KhQJIi17PvDMmLIFudggjs/OVJGkRQ/nvT/hhANHv6fTZurstwMT+z6TRdKmHdwEwclyZcLhctUPwBG+AzRcUUa1XThnXhZC0z7/1ViRk48TXDBh6UD7PrpEFw9risBZ51Bp+wCGnIxuRP/0r5fe822a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=RTFZPFX+; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="RTFZPFX+"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-493f75f7172so16093395e9.1
        for <linux-rdma@vger.kernel.org>; Sun, 26 Jul 2026 04:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1785065577; x=1785670377; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Mfmb4tl9yoRcxmAXx5l+qVXFh2lTgHh23cZW0hK9N7Y=;
        b=RTFZPFX+98O4Gcu8hFtTQjxFlyp6RzUmpHF9nglsxWl/xkyzeDTpSTXUdeJpxY94qQ
         0K8TC2lPejgZSSS8g9/2pwNihcSqOu6nCdcjXeO8CyBDvGDgztGS8F3kItccijxRdkr9
         Y89m8PQrMjIqPI7fR5dn+x2f647Da5gaUkVliawwlzH5+rLW+lNFKpfvt+dQFITEDEPx
         mUi9xggUVs0EDcunEYugFCDvquTkZwBRwnxOdWboJmMaqu3QVQpiPOHxwVCP0MFZXNbA
         f6bZH58P4D6cs/WFaUX/xTb56HkxYQ4Gs/sVWdDjl65iVRZ7eVGtT06pdiI8tY33dpMD
         imMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785065577; x=1785670377;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Mfmb4tl9yoRcxmAXx5l+qVXFh2lTgHh23cZW0hK9N7Y=;
        b=alH7V1aXyF/PwNKMrG4XWxUy2Ds3BWvL8KpuEzZLjccZ/pXlERtO+tlG+UL2DiaRG/
         muugIQZaz1KJYSEvKdulERREJtMlVIpd48TTSoLsiSykQXGIVZXXZ2o/3thmrTBXzMkx
         CefS2F7jrM2C14VdkttO0wZEERDqZGe5puWHRqoHCbZgSAgU3aPDBKCMhmeKIqAdfjBb
         uJvfQoiauNesf04mQsOJjGIZ9uzjNfyYOJoeEDg06vr9UwlT49NgWivxWEVooS+9aj81
         DOFjTcGOMNA9pUoL4oLyue8fjiiOPyrx7tkvlRqL2hGBnxrczr6QnPihftOA4L6U2DjS
         R8kg==
X-Forwarded-Encrypted: i=1; AHgh+RpFnar2JveXj4Xbm6ZeNahy/wR+Qodf/cM6XnNX5yZ1BeGE3NfZznpwFHZNa/JNQP3hTkIwj578paCZ@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7sEPzOcSgJy4ySIHcF/hzak8gtn89Culn38Yk9QNoIwDzvJ1I
	IS3Fwzxu7UnmdhJXuSXdjBILIVq5NV1jksdcN6S/92iD0T+psv20jEU+afQKXjTOyA==
X-Gm-Gg: AR+sD11+Sx5KQF0tlCeT0jyqVdBcH0MrkLQiyF6i6p9SHddZJml5JCLzh4WIPja+rh4
	KpRyIVOLpthAJ8FbhvinutE+CvyDtgZO1sWaBN6X5Uh25CQ32ksF4opRTt1QhMvDoz/aeWHfTyr
	DbWYKxennaNAkEFAHuFuztX/ZNSv+6mWx8ltGv/rvT9mhV7wjEhpeSuFlm3o5sATc1goVbVm8rQ
	DtezPykWK81VVQwFelZHn0VmTtgcEuSl//LlzL+p5DPxp9fKVR3LpI8tbpDtt/mEXxw4EhvJ99I
	7a78UMt2Uxo2TxdhFkWQStxuHhNYZCJElqe2eWBEnzfkUKGWXC6cPJS5seb6OHL8vTZvhx1m5Kj
	eF6mTJIgl7mYjyvWvbzNY+LGX9sVgJfrDt7Ymv5a5T+Y9ycxv0eCi5rktk4iSCXv78uSleEtcSv
	w7YduiNR7bMMeHVYg8CFO28bZVXTxU0XSTJpIo0zSDWAh0fRr7Wc1q2ZeS+qZZXFMGk/h7MTPBy
	Ug44SldkjRLXjxg6zX3iXgStdajp43Qkyml59E83w==
X-Received: by 2002:a05:600c:1906:b0:495:3a52:cd7e with SMTP id 5b1f17b1804b1-496b5700144mr69628875e9.25.1785065577098;
        Sun, 26 Jul 2026 04:32:57 -0700 (PDT)
Received: from meshstor-pc ([185.87.42.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85bb57cfsm40533083f8f.11.2026.07.26.04.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 04:32:56 -0700 (PDT)
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
Subject: [PATCH v6 10/12] nvme-rdma: return BLK_STS_P2PDMA for unsupported P2P transfers
Date: Sun, 26 Jul 2026 13:32:27 +0200
Message-ID: <20260726113229.2154269-11-mykola@meshstor.io>
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

A P2P transfer the PCIe topology cannot route fails DMA mapping
with -EREMOTEIO.  nvme-rdma folds every mapping error into -EIO, a
retryable host-path error: multipath requeues the I/O forever, a
single path burns its whole retry budget.

Propagate the real error code and return the unroutable case as the
non-retryable BLK_STS_P2PDMA.  As in nvme-pci, -ENOMEM now requeues
(BLK_STS_RESOURCE) and -EINVAL fails (BLK_STS_IOERR); -EIO stays a
retryable host-path error.

Start the request only after the mapping succeeds, as nvme-pci and
nvme-tcp do.  A hard status from ->queue_rq is completed by blk-mq
itself, skipping nvme_mpath_end_request(), so the multipath I/O
accounting leaks -- today for -EINVAL, and now for BLK_STS_P2PDMA.

Fixes: 23528aa3320a ("nvme: enable PCI P2PDMA support for RDMA transport")
Cc: stable@vger.kernel.org # v7.1: requires BLK_STS_P2PDMA and the ib_dma_map_sgtable_attrs() conversion
Assisted-by: Claude:claude-fable-5
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/nvme/host/rdma.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 63830334c73e..c38d949502b7 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1486,10 +1486,8 @@ static int nvme_rdma_dma_map_req(struct ib_device *ibdev, struct request *rq,
 		.orig_nents	= req->data_sgl.nents,
 	};
 	ret = ib_dma_map_sgtable_attrs(ibdev, &sgt, rq_dma_dir(rq), 0);
-	if (unlikely(ret)) {
-		ret = -EIO;
+	if (unlikely(ret))
 		goto out_free_table;
-	}
 	*count = sgt.nents;
 
 	if (blk_integrity_rq(rq)) {
@@ -1511,10 +1509,8 @@ static int nvme_rdma_dma_map_req(struct ib_device *ibdev, struct request *rq,
 			.orig_nents	= req->metadata_sgl->nents,
 		};
 		ret = ib_dma_map_sgtable_attrs(ibdev, &sgt, rq_dma_dir(rq), 0);
-		if (unlikely(ret)) {
-			ret = -EIO;
+		if (unlikely(ret))
 			goto out_free_pi_table;
-		}
 		*pi_count = sgt.nents;
 	}
 
@@ -2033,8 +2029,6 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
 	if (ret)
 		goto unmap_qe;
 
-	nvme_start_request(rq);
-
 	if (IS_ENABLED(CONFIG_BLK_DEV_INTEGRITY) &&
 	    queue->pi_support &&
 	    (c->common.opcode == nvme_cmd_write ||
@@ -2051,6 +2045,8 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
 		goto err;
 	}
 
+	nvme_start_request(rq);
+
 	sqe->cqe.done = nvme_rdma_send_done;
 
 	ib_dma_sync_single_for_device(dev, sqe->dma,
@@ -2070,6 +2066,9 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
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

