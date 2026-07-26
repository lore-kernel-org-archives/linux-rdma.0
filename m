Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E2F386455
	for <linux-rdma@vger.kernel.org>; Sun, 26 Jul 2026 11:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785065561; cv=none; b=LQiNW6636xlcQU6soWymUoANJinxIXfpPxwA9syEkQv5QWIlKoZDeTIv60bv82E4uUmFlvuZch3zGO64uc4CdZePOrCxF5vjolJuTTnlsuX+45RENsEfXPJZ8AybK3RKClPY1OKyqjbo4cw0pRV9I91dGFGrgbuaVPniY+bOZWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785065561; c=relaxed/simple;
	bh=cRH7W6syefYxFA3VhhN4QvzFBoE55r52A/E6t9wrD1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mni1lB4Md/xLgUMKyS4jCHup3U05iF8ZpTpuW5dpnj1PzNJFLfjR/DdC4QugqJWWIoZdsSDtAqLzNmSNih1JEgTI952/TX5VNjHZGutEiftOg84xAM7ArkoMIgUQFanq/KyhEBQ90VdkEUknnBMo933KGp0yCcv6YVDr4SqGJ5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=iCUrjlGZ; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="iCUrjlGZ"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-47f3b39f2a1so1532492f8f.2
        for <linux-rdma@vger.kernel.org>; Sun, 26 Jul 2026 04:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1785065557; x=1785670357; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LNWXk+rlZiNRYyXRDGVV7qCvY4AZPHPO/XYCzCCpSWs=;
        b=iCUrjlGZRTnRycnm44bhvE6KESyl6CPlRBFaqy1scd6HtQ3mzTeRQmEcSph/Jwx2jb
         3Lx2khsCVyQO1x3j1jrd3SU8kGfPXuQIfa8JK1SRDdC5vxhNIV0FXnxksrxuhnq5aaSw
         VEgxUPzxsAsrZ5Oa/gdaa9zyewbGoh5VsTRdf3OOXpFOZ18Ftv143Z7aA70+ODdBOC42
         tkNuPZiZDXmzV9jTnoZc99lFxvF+yB6JjYrg7BG+hRpRot6neyOlAh0TaQN9aYVMc2gB
         vSig2bu8v9Kin9PFG3+hz06JjxjxuUWAfB3AWOn4pibSuUXWVUNPeG8F0iTMjtLW/6Rr
         DZXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785065557; x=1785670357;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LNWXk+rlZiNRYyXRDGVV7qCvY4AZPHPO/XYCzCCpSWs=;
        b=O1604G4JlXIVgAFuMMhIY47liTaA+EwnXtwkSgvZM55EJWgNECLutHJHFxVLX4Wc/3
         3L34uJtPX2kJcYK/a6Dpp4ibmMUD3WcDPzwQ+SOOGafZBRWULx9XagE0vjXXpwTgk1he
         t66iIIDEfZO3dYq+jYYCHjZBCajICLDDgQqaoCVledi4ozcP63hbSinIOcBXJrB6lrK3
         ayIWkLCkl5cH+726ojXazT9lFlg29cEqRaUhmouQIq++q5TByg02i1boHcLHViWG0xYj
         pNy6Il0DAK15p5LZAnzmiIqeN5h/4SLEHGBRKgDrYQ2EW7Ig4iug8rllG+q/WRsEmOn2
         paBg==
X-Forwarded-Encrypted: i=1; AHgh+RrQ9xwhA2L/SJ5AHoos8clv67HkYbxxhPz1zRz6SbYr4/KN/jx+TS0S/PRJgAFOcSqdlbzlAPaHrWnA@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6qRQMqwKXD+ZDb8GS1zeYsCEW7qVl2pqwASBAg2dzhAmQ/+wC
	35MJ/96BEZtVUNFYvt4r3CQIAaseJ8nb4v2E9bg39bEFAryrmH14rQQmGend82U5yA==
X-Gm-Gg: AR+sD11fswEiGIxJzHB4nOICXGw9yRmmoc4zCixOUUlp3OSIkO78Xi0J+WUgMrcaSI+
	9MSMho4u1kh/vgA85o0NAdhmoV17D0//WHV29ArCzvpvNGk0NEShqH16cu5El947fwddxLamH9d
	v4AaltFx/vUt9YzZyEzQOZBxgOSO/hfa3PkUqGDw3sG1n5VBgaQpZIV3R8vuBnQ/9yeofMviO3Y
	Ao+9o3RpjgcI3J4WkoekJA2mQBfFomBwdjXg5+kO08AUVvafMuumJSFlT9d5jBuWSiUZtIQWoBP
	lHamFmPrKV6eyKQav9lhWIzyXJK536y4EwK50HWoes5fAt5gCMbmTE6qT6fcCyDna8hy9sOLgRl
	r+ZZkZY01ahigH6vkRrxW0tBxZyo64f7UVg9Y2H+wcP1MpKKFlv1cUUKk26ZebNERyQXxC3mRYq
	1ZepEY2L9EY1XueHzp2dFZXc1LZiF1dirTgPQoxSds8po7DjlTbT7yPyPqUpEkPJMfYJd9C0HSh
	kiby/41PuCuzjWKbKCdwlmCAC90zEwH4XJGe2Jbj0X2R6Mq+XJS
X-Received: by 2002:a05:6000:4012:b0:47f:93e1:e7d0 with SMTP id ffacd0b85a97d-47f9fea2d2emr6157677f8f.36.1785065557128;
        Sun, 26 Jul 2026 04:32:37 -0700 (PDT)
Received: from meshstor-pc ([185.87.42.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85bb57cfsm40533083f8f.11.2026.07.26.04.32.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 04:32:36 -0700 (PDT)
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
Subject: [PATCH v6 01/12] block: add BLK_STS_P2PDMA for unsupported peer-to-peer transfers
Date: Sun, 26 Jul 2026 13:32:18 +0200
Message-ID: <20260726113229.2154269-2-mykola@meshstor.io>
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

From: Logan Gunthorpe <logang@deltatee.com>

blk_dma_map_iter_start() reports BLK_STS_INVAL when a P2PDMA transfer
is attempted between two devices whose PCIe topology cannot route it.
blk_path_error() treats INVAL as retryable, so multipath requeues the
I/O forever, and callers cannot tell it apart from an invalid request.
md also ignores it for member failures, so a mirror silently diverges.

Restoring the old BLK_STS_TARGET would stay ambiguous -- nvme maps
NS_NOT_READY, LBA_RANGE and CMD_INTERRUPTED to it too.  Add a dedicated
BLK_STS_P2PDMA, non-retryable in blk_path_error(), and return it from
blk_dma_map_iter_start().

Fixes: 858299dc6160 ("block: add scatterlist-less DMA mapping helpers")
Fixes: 7ce3c1dd78fc ("nvme-pci: convert the data mapping to blk_rq_dma_map")
Cc: stable@vger.kernel.org # v6.17
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
---
 block/blk-core.c          |  3 +++
 block/blk-mq-dma.c        |  3 ++-
 include/linux/blk_types.h | 10 ++++++++++
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 365641266c9e..83cb5464265f 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -177,6 +177,9 @@ static const struct {
 
 	/* Command duration limit device-side timeout */
 	ENT(DURATION_LIMIT,	-ETIME,		"duration limit exceeded"),
+
+	/* no PCIe P2PDMA route between initiator and target */
+	ENT(P2PDMA,		-EREMOTEIO,	"peer-to-peer transfer unroutable"),
 	ENT(INVAL,		-EINVAL,	"invalid"),
 
 	/* everything else not covered above: */
diff --git a/block/blk-mq-dma.c b/block/blk-mq-dma.c
index bfdb9ed70741..e88d6b3524e6 100644
--- a/block/blk-mq-dma.c
+++ b/block/blk-mq-dma.c
@@ -189,8 +189,9 @@ static bool blk_dma_map_iter_start(struct request *req, struct device *dma_dev,
 		 */
 	case PCI_P2PDMA_MAP_NONE:
 		break;
+	case PCI_P2PDMA_MAP_NOT_SUPPORTED:
 	default:
-		iter->status = BLK_STS_INVAL;
+		iter->status = BLK_STS_P2PDMA;
 		return false;
 	}
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 8808ee76e73c..c8de7809320a 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -165,6 +165,15 @@ typedef u16 blk_short_t;
  */
 #define BLK_STS_DURATION_LIMIT	((__force blk_status_t)17)
 
+/*
+ * BLK_STS_P2PDMA is returned when a peer-to-peer DMA transfer cannot be
+ * mapped (typically because there is no route between the initiator and the
+ * target that the platform's PCIe topology and ACS settings allow). This
+ * is a property of the initiator/target pair, not of the target device's
+ * health. This error should never be retried.
+ */
+#define BLK_STS_P2PDMA	((__force blk_status_t)18)
+
 /*
  * Invalid size or alignment.
  */
@@ -188,6 +197,7 @@ static inline bool blk_path_error(blk_status_t error)
 	case BLK_STS_NOTSUPP:
 	case BLK_STS_NOSPC:
 	case BLK_STS_TARGET:
+	case BLK_STS_P2PDMA:
 	case BLK_STS_RESV_CONFLICT:
 	case BLK_STS_MEDIUM:
 	case BLK_STS_PROTECTION:
-- 
2.52.0

