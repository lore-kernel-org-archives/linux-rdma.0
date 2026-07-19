Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E559391501
	for <linux-rdma@vger.kernel.org>; Sun, 19 Jul 2026 10:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784458421; cv=none; b=iJyTRPX+i66YEnQMV4lRFOlL1dwLndHZRvPt+AMA5vtA597T5ObRWBhm6+EA3X969BzmZfFYSD+aQvdJ2FVeIzZT1IBWW1CmPDNCYHhdlYpff4/2Omx1dSbORia5TPdy0+Vo+Dc+bETIHeik67LBxicOyILkT5XPrbb+ok63YHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784458421; c=relaxed/simple;
	bh=I0++bTZ6dP7SwW+DMBEsuDxoAUGip3+1I9WU1guq83I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sEdJbMjlKMTC0Cl3pdWdfW6BAmRuCiAyJPkuaBliXRYqxXSxPvjP5ReoPIrPyKkctKxuPUhsc632Vzv6VUs+KJOXGGn9PMW//t3+wBsn2gSh1OhtSOqRSYjPSZiVdmOCt/i1HgrspAiVF1Xog5Ul2+lGHdF0ZXZ0hCmmxB38u3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=M0TUPaja; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="M0TUPaja"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-493f75f7172so71571665e9.1
        for <linux-rdma@vger.kernel.org>; Sun, 19 Jul 2026 03:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784458417; x=1785063217; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hybfSCWaTjres2ZZlI9Lu6CV5Kqe33y6xILjvKI8G00=;
        b=M0TUPajadEG7LHHvuhNik2cKvB9QyqXj/5nvWQcAIOmHx8E0g1cZAfgZreCmzneDyg
         9G0AwF7BSiHMJ0P1gY+yGp+2omGaaVJmBDb7alJtSiX01mqMtsfHKohUBxRzuE9bqjSb
         eAgdCAZeHcTlIXJC40LXL5ewCCPIUePXGTVfjPh7Je+v2K1NrhQnC6Z8NVcAGLKcc0kK
         clSeAw1o6Vfo+lqbE5YRphPOpubboNdK0PhtyqGKJbL4dtXd2IQaVCrZRyt0gqB3CVEl
         p4ouF6AFBdyf05SEZNQT4H0s2Y2BwsfN0yIbIdZgX3AkuBE9jOCeHcqyZb1BZ9DDtqOT
         x/7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784458417; x=1785063217;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hybfSCWaTjres2ZZlI9Lu6CV5Kqe33y6xILjvKI8G00=;
        b=e5So3umfOT6k19HOIcLjFNCDym9BPZY7GGYfeljCu6CzgMs42mo0esJtgY/DW7SeKL
         q7KryETdXu7gTEi1cBzjWNlHmS/+lzcEbahOgbAjtg0q9eyr71qFVwnqAmssggO689e7
         onYVZ4d/LexH4zL3bVSPcAMTGIRuNVndwAQeDeeFCaLsl07AL1jDoHgdJEw5IxEeXpMC
         ltb4uLZEI4hnndq8oZLI8AdqOXEnRo/dszuiy9e6ac2eqgNmC15kC3279lQiGly6F+Ry
         /pOMhiUBJETb9gVgDjPUPBECfUmBXe4b2M8nK10B1//PzgUT4SMqvtPXRIuPrcjF0X1m
         rmYQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro4hfScVcedkYot//XOG1hsXis5dgUYtkLr5qih9VaqeAgSB3NWEdZlfKYrlUuHe0D2uiloSNhvXW0K@vger.kernel.org
X-Gm-Message-State: AOJu0Yx66Lz3qvLOx231CPvDZPugkhnZJk76NTgYeXDSp25PIKzueVyA
	2S30O40gIYempPmGC3WI6KpR4B3VkQD6tXeR835zJBKyYXo3XebVMDvQisMC/6jUYg==
X-Gm-Gg: AfdE7clM7nFSLBWOfuub67bMxwAE5K38GbB7RsQtlb67Up3DCxja64MFblcXro9omOU
	QjZ5qDsgNob9oylFGZYPbYphpwde7iv4oLTv+VbQXJGibbbkaLBW8UxaJVfNGMy0Mu+W3Avg6Il
	NrRH7nwkStpofdoL65LORCSI2gLRS5r1s/TOi2Ea9+nD3a/Phi+/gJ+06ISDCJleSPSxN5mtGOO
	veAZOjJPsKdi+tYjemrx1+aBcX7G4T+UwQpDt1Gx4x3poHbGVTd4UphBV8YjMHXs3095t942+TP
	MIuM0ZKoCKSvazrktxlW3zazaaOEWJWL/6TDKqJwWCRZYajRPj7VnnLL6q911bx26u488e5p00x
	D2gepA3/fjcOkFCznBHwGNePNqXt65wXDkeWDj45sewhvrTMQrmxyS+ATENeLfA==
X-Received: by 2002:a05:600c:e54a:10b0:490:5057:f5f7 with SMTP id 5b1f17b1804b1-4954a3ed516mr73355155e9.11.1784458416521;
        Sun, 19 Jul 2026 03:53:36 -0700 (PDT)
Received: from mf-00-01.. ([194.220.239.180])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954a2a24b6sm197679575e9.3.2026.07.19.03.53.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 03:53:35 -0700 (PDT)
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
Subject: [PATCH v2 1/7] blk-mq-dma: restore BLK_STS_TARGET for unsupported P2P transfers
Date: Sun, 19 Jul 2026 10:53:21 +0000
Message-ID: <20260719105327.864949-2-mykola@meshstor.io>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260719105327.864949-1-mykola@meshstor.io>
References: <20260719105327.864949-1-mykola@meshstor.io>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 91fb2b6052f7 ("nvme-pci: convert to using dma_map_sgtable()")
deliberately mapped unsupported P2PDMA transfers to BLK_STS_TARGET,
matching dma_map_sgtable()'s -EREMOTEIO: "When this happens, return
BLK_STS_TARGET so the request isn't retried." The conversion to
blk_rq_dma_map silently changed the status to BLK_STS_INVAL, which
regresses two consumers:

 - md/raid1 and raid10 ignore BLK_STS_INVAL leg failures
   (commit f7b24c7b41f2 ("md/raid1,raid10: don't fail devices for
   invalid IO errors"), where it means a request-shaped error that
   fails identically on every member).  Since commit 02666132403a
   ("md: propagate BLK_FEAT_PCI_P2PDMA from member devices to RAID device")
   P2PDMA bios reach md arrays: a peer-memory write to a member the
   peer cannot reach is counted as written, the master bio reports
   success, mirrors silently diverge, and on a topology where no
   member is reachable the write reports success with zero copies on
   stable storage.

 - the failure's classification flips: for direct NVMe consumers
   (nvme advertises BLK_FEAT_PCI_P2PDMA) the mapping failure has
   surfaced as EINVAL instead of the documented -EREMOTEIO since
   v6.17, and blk_path_error(BLK_STS_INVAL) is true, so a stacking
   consumer would treat it as a retryable path error (dm-mpath is
   the only in-tree blk_path_error() caller; P2P bios cannot
   currently reach it, but the classification is wrong on its face).

Restore BLK_STS_TARGET.  md then routes an unreachable leg through
its per-device error handling (badblocks, mirror
retry for reads); a later patch in this series teaches raid1/raid10
to handle mapping failures without the retry storms that machinery
was built around.

Fixes: 858299dc6160 ("block: add scatterlist-less DMA mapping helpers")
Fixes: 7ce3c1dd78fc ("nvme-pci: convert the data mapping to blk_rq_dma_map")
Cc: stable@vger.kernel.org # v6.17
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
---
 block/blk-mq-dma.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq-dma.c b/block/blk-mq-dma.c
index bfdb9ed70741..2eed06bfe791 100644
--- a/block/blk-mq-dma.c
+++ b/block/blk-mq-dma.c
@@ -190,7 +190,15 @@ static bool blk_dma_map_iter_start(struct request *req, struct device *dma_dev,
 	case PCI_P2PDMA_MAP_NONE:
 		break;
 	default:
-		iter->status = BLK_STS_INVAL;
+		/*
+		 * P2P transfers that the mapping layer cannot support
+		 * report BLK_STS_TARGET, matching dma_map_sgtable()'s
+		 * -EREMOTEIO and the pre-blk_rq_dma_map nvme behavior:
+		 * the failure is a property of this device pairing, so
+		 * it must not be retried on another path (blk_path_error)
+		 * nor be mistaken for an invalid request.
+		 */
+		iter->status = BLK_STS_TARGET;
 		return false;
 	}
 
-- 
2.43.0

