Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18948386576
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 18:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784746744; cv=none; b=EMAEZES5EznOwiXR/9iYnUnY0ZWyUYBOEmM073YjWob+FMZxfngIDRUJgixUl/VYaZ6L0B4gpCZCUgvapaof5vz6PBQPL1SPmRRZDJw9FvgQQcMrs+Ua1CYSJ2jLdllaejTITdusx48RPfZfoOtYHMzUkLrDX76aEGoveAXs6VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784746744; c=relaxed/simple;
	bh=cRH7W6syefYxFA3VhhN4QvzFBoE55r52A/E6t9wrD1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EP6oGl7MjPhZlPAlmX9TNUexBbqp8WETwnR5WODW5jMHSNYFsCHfCYS3XmunmsGACQ9HsIl5Dkrb9uXOEsVBk9ehJddm4ho1kzRypiC0u1GQN4ktKk6KUDvIm3P+z616D4Q1t7wxa2/jcS3msZhXpHBLXgWbjb+ymvoQ+ke3VHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=PjXrY8sk; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="PjXrY8sk"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-49548aebcd8so39530855e9.3
        for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 11:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784746740; x=1785351540; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LNWXk+rlZiNRYyXRDGVV7qCvY4AZPHPO/XYCzCCpSWs=;
        b=PjXrY8skVYXsu0ZtujioERfZepLyP1Qucn4GVHfDugrdZIMyqzKP0f+V5fm7jWQZ8g
         HLp++x8eJH9DsAyezDkUmpzHkQbk1hTzyR61GBUpSIzsPgI/OZtI/CEsA9yOvmTioqYZ
         /CRuZt6aNksbCpDhZYuIJaeUJ6K4Hc0R5olcuxheTb+V6wG/OViRjutmcg2b9S/3QHmu
         jaDuIAFDCkHkdZOyesapOVYEojFY26oBMqu4Epv6nn02TbXBG9sD1+lkzyqkCT5tn6it
         O5xlT1JYU4URKGXBMXg+rB5D8kZ46hAbEO9K9OKJgAacrlFZytEkvLV7278vvyJrp4+T
         bmUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784746740; x=1785351540;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LNWXk+rlZiNRYyXRDGVV7qCvY4AZPHPO/XYCzCCpSWs=;
        b=qr2/bVeqaFfQYlWJX+uWbHy4w4tnTzW6XlXiOnPZm0zN5FDIctrpvymmgEstaGAAbO
         AK8Qj7C4EgWg1FJhlsd//7OoFY94LsbqxfH6zbL87CEDUlrucRZ/FUxYYrezGzDfdUSB
         rkPK9MxZUu3p9xvZExPYhEws+xyhTe5L/tPaUz9+INXjAOSfJ62r3wFgj4Zd7Dl1s58r
         VWzhM+hAXfSztNPRGkzikLmii74OHJUAly2sEQgX+MBOEgkqZxBMsdQQruMneFPLJll3
         h7UrIqogs3th3HcQwdnpEkecTrttD5XQeNHZNgPqLUXDRmpVIQPs/2uwBGljP5rm+xJP
         jEWA==
X-Forwarded-Encrypted: i=1; AHgh+RrpOK/im4d2TATd8FiztKo4lV+ctSdkHx+nbYTzCU0Fgyf/65D9PSuwTywbIZTJ1WKb39pHzjM7bAb3@vger.kernel.org
X-Gm-Message-State: AOJu0Ywl6FWE0uy2WA5Iqjt0wzSXEmIAczalP1WKz5dYIY1ykfDKV2W2
	p4MMFOcjMPM5+41erEDSiw643v4XBMXqIamuHWxsVy3GPW4KwoU66jPE7T2KCHeiTA==
X-Gm-Gg: AR+sD12wVhErgjB+GA4JnFlgogCQhIMOotDIo31aNZwb6VLcghqeqMqThgW+hkCpD1E
	295Xg0tE5r5mH04hF+ZKz4qi7kiwIhu+54odchf2a1FmiIhWMEIBxtScryUQwUylLMG6YOefNIJ
	5Pvkdd9cXuafQ3WH3RttAIcwD2a45a26HG6Vhl4CXEmHHQp0ZX9CPiIfoaC6u0CzfskXTEXdDI6
	jg4zdBq1V7xFl3wVeBdZAKQXb2ZuWzLLeT/y6w///+jCoBw43U1Cp7ClXnKNGO3WeoY2yHS5IcR
	fpwvf6WScbVXxdtqdjM5qJ+Ip0m3Ycf+Kcb1fh+h/8LG+6dEWHSmbU8zkA1EAh3hnRmmbvdTt/n
	gwf50QaHMORfCsi5HaqG8HlHUb0xaMx0/IbMYx0ui8atLkxiQJS8uZtN959yvA+PnIJ9KS3dCYF
	4TSPxASoLu3CqFxeA1yHsYEYtSS1Fw57d/gPH57d5w/GNTm0g=
X-Received: by 2002:a05:600c:3153:b0:493:e97c:216e with SMTP id 5b1f17b1804b1-4954a41382fmr294367705e9.39.1784746740281;
        Wed, 22 Jul 2026 11:59:00 -0700 (PDT)
Received: from ai-pc ([46.172.241.174])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-495730353d9sm13740055e9.12.2026.07.22.11.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 11:58:59 -0700 (PDT)
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
Subject: [PATCH v4 1/9] block: add BLK_STS_P2PDMA for unsupported peer-to-peer transfers
Date: Wed, 22 Jul 2026 20:58:33 +0200
Message-ID: <20260722185841.449934-2-mykola@meshstor.io>
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

