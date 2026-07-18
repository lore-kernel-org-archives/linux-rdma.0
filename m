Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F097D3DCDAD
	for <linux-rdma@vger.kernel.org>; Sat, 18 Jul 2026 16:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784391983; cv=none; b=tU/26WEnisemuyxBaS/gLV+4xaWHWXZDhNNR2D9nPa4LhzC9BV13hUBg4Prr5RXdQCjficYv9H60LqL+C9b2DiMmHuSDjOIRAccYe29A+mTcmQojre2AKAhvBblEZ0kE3nlWyTTyyZZTpEBccBoI8FVrJPpJcsEkAR+0w6wmYD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784391983; c=relaxed/simple;
	bh=vO1jpq1MeVozqKW9Fk/0t1VAaeJE5a63mWcH5DQ3WaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UCRZQjRJLDAia7A85It3bYT0ZAy+Jbh/7nENcBFSfmwwzrjtGig05wuTMVJO6++mtPwaVPSIW0tLeY4hOegjp2ACqxjZSRM8eV3Vreaa8htANJoS7G6m52X6gabBPyyAy7rz0CojjPyg5f5YNGBpM7TwYWnU2Ymdn94xXT8tgSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=dGEd0KGF; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="dGEd0KGF"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4955158f26aso3486525e9.3
        for <linux-rdma@vger.kernel.org>; Sat, 18 Jul 2026 09:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784391978; x=1784996778; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FhGxTEOOON4RkKT9KdpeyXrdqn2SrMJKFWwPDsn11x4=;
        b=dGEd0KGFycs70IRTPaRO3yl067VneJhz8nAfq496d1UdH5tmzBiE4NqoHRmlD1vqEe
         LxkfOCoJnl8dzncWTJUCWZvf3EshSpqQZiiEEwGXXu6MzrxBm8UbAvBF8xDjzq+83oif
         JCyq4Kmx5xPM/4PAsQjWPOZoJss+XttXYI7ZGodnqpvbYgJBbwG+GxH7jjeo6qCdQvA2
         nR0RX4tJ4bopIsNJyNeBOl66rQOGEhN6O4Lfpd58TXGvYmMSsGgJw0061VsLEyLvBgCg
         KPhhnYTjSFu9367sE0oElHT+efoL2NEBI4HcbUz6njWBcacHaWuSjQj8eWCRCWM0Ngpt
         2LaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784391978; x=1784996778;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FhGxTEOOON4RkKT9KdpeyXrdqn2SrMJKFWwPDsn11x4=;
        b=q2l7Nh0LRfLn01h0VIkF6K+y+Zin4JkeHYGRWfLi7+nR2bt13zudEFWoRLs9Lxv2Ix
         QVE+oaGMBRvhpj6BDLZF+zyB0Aimtinq3qEokE7/zICJT7+QidhixjsUYRaseQXdbBcz
         BiufnooTj8y/6Tn7L2521LjnxSMVQvgJNloWAjN6yolo7zntA19FdGWPvDu6poN4uS1Y
         n/klU7uw/uP7kQ+KM8mIU/0RAS1vbsboGcDu4Pdp2RAUO6nZEY6Es2ie4WYxU0ZCm6Bl
         hXwleJyfmC811L1Gi/U7CgUL2MpPBFaE5eD5R82J/9Krup+Ct9m8/WbrHTc7WIY6j/gO
         SZxg==
X-Forwarded-Encrypted: i=1; AHgh+RoFAy1unoOSHqm9fSBjTJeoAx3EVarXiGhMdsGqRUubR/pfCKZWBYhi301vSxVRjETlLYaJhRIdIBsQ@vger.kernel.org
X-Gm-Message-State: AOJu0YyL9rJEQfcNur3CdNDOanfu8MyHOvNxXbVRtljTwFmrXbLVrQxL
	hdkM/JXwcgYAD26AQbeVZ8GeCjMquuLvvUExv99+vHZ9tuPqd2KKGTIEs3M36JU5nA==
X-Gm-Gg: AfdE7cn00YJqMZa2/uKU5eHyri2sBTWL1Gpx2GZbSQbLrZ+IbUTLPjlTf+KVYw9vKjH
	4766E9QS0LcugROWm/UA2GvSWof7mZd2LD8LJjruBtfkkffCLLBgcRnPB5vvfgNhIaENUMV4ME+
	+L0/cJK6CE9GhrfmvXbp5br1FRi8G2ZM2HYGZMLQBp0SJoXvNT+PmyTMSSf3KvjSZYka87rxnSW
	PKINF3tZm5VseSxwcjNCKsFKE5aLjxeCrg5dB4P4uimMYmPy1JIbnrFFg4UnVz1UlzuKxiYeFiU
	bkdxXqC4AjQJP9eFZJ6x75hJ6LxqNLtuKROQ1GGLfUMp7vC6rLGpYHKQixeQ+vRdz6Hq7CqW4pH
	tTdMd2iZLSaDX5Kp2ITH7MaxfoPLlKKn1YHznJPqyu3tV0ajDwmiXVJnn6ePoxQ==
X-Received: by 2002:a05:600c:c84:b0:495:4689:1e98 with SMTP id 5b1f17b1804b1-4954a3ed426mr78278195e9.10.1784391978225;
        Sat, 18 Jul 2026 09:26:18 -0700 (PDT)
Received: from mf-00-01.. ([194.220.239.180])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954a2eddb8sm266444085e9.14.2026.07.18.09.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2026 09:26:17 -0700 (PDT)
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
Subject: [PATCH 2/6] md: ensure REQ_NOMERGE is set on P2PDMA bios
Date: Sat, 18 Jul 2026 16:25:43 +0000
Message-ID: <20260718162547.448892-3-mykola@meshstor.io>
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

md_submit_bio() unconditionally strips REQ_NOMERGE before passing the
bio to the personality, an optimization from commit 9c573de3283a ("MD:
make bio mergeable"): a bio that md has split may become mergeable
again below md.

For PCI P2PDMA bios the flag is load-bearing, not a hint. The block
layer sets REQ_NOMERGE on P2PDMA bios (__bio_add_page(), and the
extraction path of bio_iov_iter_get_pages()) because the DMA mapping
type of a request is resolved once, from its first segment
(blk_dma_map_iter_start()), and request-level merging is prevented
only by REQ_NOMERGE. Stripping it allows the member queue to merge a
P2PDMA bio with a bio carrying pages of a different pgmap, or host
memory, mapping the merged segments with the wrong bus address:
silent data corruption on the member.

Set the flag for P2PDMA bios instead of merely preserving it. No
in-tree path currently submits P2PDMA pages through the bvec-iter
path (bio_iov_bvec_set()), which skips the flagging -- but nothing
structural prevents one, so setting rather than preserving hardens
md against that gap at the cost of one branch. Everything else keeps
the original optimization of clearing the flag. This covers every
personality that advertises BLK_FEAT_PCI_P2PDMA (raid0, raid1,
raid10), which is why the fix lives in the shared md_submit_bio()
path.

Fixes: 02666132403a ("md: propagate BLK_FEAT_PCI_P2PDMA from member devices to RAID device")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
---
 drivers/md/md.c | 14 ++++++++++++--
 drivers/md/md.h | 18 ++++++++++++++++++
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d1465bcd86c8..3ae4fd4ef381 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -451,8 +451,18 @@ static void md_submit_bio(struct bio *bio)
 		return;
 	}
 
-	/* bio could be mergeable after passing to underlayer */
-	bio->bi_opf &= ~REQ_NOMERGE;
+	/*
+	 * A bio md split could be mergeable again below md, but for P2PDMA
+	 * bios REQ_NOMERGE is load-bearing: the DMA mapping type of a
+	 * request is resolved once, from its first segment, so requests
+	 * must stay single-provider (see __bio_add_page()). Set the flag
+	 * rather than merely preserve it -- bios built through the
+	 * bvec-iter path arrive without it.
+	 */
+	if (md_bio_is_p2pdma(bio))
+		bio->bi_opf |= REQ_NOMERGE;
+	else
+		bio->bi_opf &= ~REQ_NOMERGE;
 
 	md_handle_request(mddev, bio);
 }
diff --git a/drivers/md/md.h b/drivers/md/md.h
index d8daf0f75cbb..140e2b3670d8 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -11,8 +11,10 @@
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
 #include <linux/badblocks.h>
+#include <linux/bio.h>
 #include <linux/kobject.h>
 #include <linux/list.h>
+#include <linux/memremap.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
 #include <linux/timer.h>
@@ -22,6 +24,22 @@
 #include <trace/events/block.h>
 
 #define MaxSector (~(sector_t)0)
+
+/*
+ * Check if the bio carries PCI P2PDMA (peer device memory) pages. Read
+ * bi_io_vec directly rather than using bio_first_bvec_all(), which WARNs
+ * on cloned bios: md routinely handles split clones, which have
+ * bi_vcnt == 0 but a valid bi_io_vec shared with the parent. P2PDMA and
+ * host pages must not be mixed within one bio, so the first bvec is
+ * representative. Only valid before the bio's iterator is consumed:
+ * bio_has_data() is false at completion time.
+ */
+static inline bool md_bio_is_p2pdma(struct bio *bio)
+{
+	return bio_has_data(bio) && bio->bi_io_vec &&
+	       is_pci_p2pdma_page(bio->bi_io_vec->bv_page);
+}
+
 /*
  * Number of guaranteed raid bios in case of extreme VM load:
  */
-- 
2.43.0

