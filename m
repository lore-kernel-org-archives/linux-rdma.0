Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AF03F3279
	for <linux-rdma@vger.kernel.org>; Thu, 23 Jul 2026 20:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784839385; cv=none; b=Doe360oUFmlD/yDRBdvqVbIzW0enMLkfn4PTOYzRq1QS20rjXZgXJ4EizfkfdyCGYGOQlQsVrq1ayadz7RRSY4bWW0IeWOpiWtZc6Wohi0W4RvOn4yEAcdmUvmFbWzMfbKs2eliqqX3tCXYWXMBYpEITG/JzqVLN4mV6Dxxd5hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784839385; c=relaxed/simple;
	bh=cRH7W6syefYxFA3VhhN4QvzFBoE55r52A/E6t9wrD1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGsukG/w/eX8GVqz88F4B+cNPS0aj2a2N6W5u0zUcPmBptaFGjIaw9olLdwtpMRcbfXWP6aQ3sMZXzKK8iqTNANApp0wElu9OGFJ9GvIHaR8DlTZCmtpMNtMTvQ0i2atjbVoR4h9zLneKskfCrzkdB8QxGomLomJ1rSy4yZ7wdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=SesB9aK6; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="SesB9aK6"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-47f84023916so1008447f8f.3
        for <linux-rdma@vger.kernel.org>; Thu, 23 Jul 2026 13:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784839375; x=1785444175; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LNWXk+rlZiNRYyXRDGVV7qCvY4AZPHPO/XYCzCCpSWs=;
        b=SesB9aK6CHrwPAFEI1B193p8OPva428cDKaNqpizhHiUhewUqHwqrmjD/xRwufSFok
         C0QIDvLbdC9pPZ+CEdXlIOyILZKCt6tsMZk99YsEvzEVMMXsNcXjvcShGE7KV9h62HlJ
         oyLFTnuqUYUO/StJAprXzTVNjytYoEhdeRDI21Aw4klritgm4+4yPAYSIaUwQVxtIrAr
         U+vpIpCu+rXzhzxyPyWR2tBGmf/yyfgr1Pw3Vt60fpaT+bjvDrn5gmUldtn9AlpfwEOR
         YUhDPe/enCYSdSa5Bm/9KVvO/O4FfEjHycGze1EOP2z7Zz1ZeqgPV1ph5RSwUjsi9PbK
         eQQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784839375; x=1785444175;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LNWXk+rlZiNRYyXRDGVV7qCvY4AZPHPO/XYCzCCpSWs=;
        b=G2c/3Ceibc11rmqYSlsL9NsMBUQ08J8yHFPBHyyu59XKMK5+Uobrq89LFb1516uuDG
         FRCMzci0WyxcmuXvjkzEdei4y37x1Bz9cHe7cuhXOPVm+wtOjoKX+TNAvhcUvIgbUG9c
         LOZ22dsKmbSn3eyMtzxa/8tyzm7n9xYjBvCdqw6vWKT0McToVwGwRi+JYfovb7wiN5cJ
         toWtPOE99/UKggQmaFy0n5ALjx+BMZzYgfkrm+V/oxuOWK65sB+07iMTj8yUtfJkJnDr
         n2eFrPs01F8vbtIzMy+lGu1gPN8QqDuZheHNdG4fSNYAN+Vt6xaxY92kZPf6aw/JL+VA
         x3JQ==
X-Forwarded-Encrypted: i=1; AHgh+RqjbW/0QcfXbzJvMNN0HTt2IhBdHtP/Ycu4fWgrn0+aDDL+OATeRVx3PAhPNXsHxIIlIooi7K1LwYbv@vger.kernel.org
X-Gm-Message-State: AOJu0YzfOIHrNl3RJwRM06b5BX6PwuWIinwiMVr5BYWMNk4NAjTOWPDe
	SK64RgTSpsAMaFmnqwMLBNB2WO/Cud2fP/STShNC2Gce4doeGi391dbk1vLQ10Orkg==
X-Gm-Gg: AR+sD10aPxv5U1XqyL530voThw5h/E/cV6sZuWrrbkKb5SRMRj/dkCFG2PxFZ4HTlaU
	pKFWi4nMnYsuumqProgbHiaTPk7/JBSU38M9xUWN0lW8b9F8ybkWFPqa3MpX95zRoUvaLCuFotB
	XBNyf1fLwTGc4cqxpw+KELd9OkbBtk9nfBIenwCjzaDQYLIF5sg/ffv62VVUFnVyx96gmRC58dU
	vsuK5zv/7LgGK/rIqmlAFMnGA4NpCzeGvoNzOQwmNCE5k3FBm65aEYyUf5zbhuaIvIQCqPpOfRi
	KWoq9bHbJ8b4NEeiYX+ch83E5+gE3awvVw5ag0E1kUpjF3pl5VSL5qv7iBbzQjWCj2nKk4d4clg
	/+fLBsn+NHmhxJF/BKxv+r2aheYO+eKrlwu9yGoYVMmRxwYWQTmkSXJa4sIPoPFXlw8JguCCrRL
	u4f1VANj/PO/atFHwME0d/PM+tpBQwDxtzkuMhSGaR/lqebx+vtuwXtU+nFUUaIitpR1YuiWxGF
	BK+0FUdMsgRNKhYjwPwnmC/zzlizt6wqDFbd8UBpg==
X-Received: by 2002:a05:6000:240b:b0:47f:87f9:6d06 with SMTP id ffacd0b85a97d-47f8da5e25bmr5949800f8f.61.1784839375286;
        Thu, 23 Jul 2026 13:42:55 -0700 (PDT)
Received: from meshstor-pc ([185.87.42.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c52fc0sm18268192f8f.23.2026.07.23.13.42.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 13:42:54 -0700 (PDT)
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
	linux-pci@vger.kernel.org
Subject: [PATCH v5 01/10] block: add BLK_STS_P2PDMA for unsupported peer-to-peer transfers
Date: Thu, 23 Jul 2026 22:41:57 +0200
Message-ID: <20260723204206.76930-2-mykola@meshstor.io>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260723204206.76930-1-mykola@meshstor.io>
References: <20260723204206.76930-1-mykola@meshstor.io>
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

