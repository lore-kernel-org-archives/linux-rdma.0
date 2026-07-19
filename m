Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A17B391E7F
	for <linux-rdma@vger.kernel.org>; Sun, 19 Jul 2026 10:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784458422; cv=none; b=ppv2HYZNzg9LfFEAhv7NWUOSgyfQuIqLQOcikb3YuQ67r9srXg2G0WQOI/T4nl6JMOfsDjZiVOG1RPdB6vr2YiyVsOwBdXnKrvc8RvWQgXcX2yAWVOMxlE/M8PK32cZ/iAgmiw+3Boq/5diWpv6Y9iNrxu5/tNR/4pKUeyQWDW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784458422; c=relaxed/simple;
	bh=vO1jpq1MeVozqKW9Fk/0t1VAaeJE5a63mWcH5DQ3WaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdPryJZOUYsMDzykP2eAGeKnpZ+/9it5caxcovyhPmP4TLUKWDrwmUcocCT4H22fyJiSwwFALV3k2QIFs9LIml8ATFgjLhuqsflx54AWNCTNFs0jBAJuvFEYcI0MEfnQy1zecWs90dVW00X6ne1PTYBGrFu2jK3ptQDmH/0dkQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=TMywT7bt; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="TMywT7bt"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4954a9e8490so9148305e9.1
        for <linux-rdma@vger.kernel.org>; Sun, 19 Jul 2026 03:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784458418; x=1785063218; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FhGxTEOOON4RkKT9KdpeyXrdqn2SrMJKFWwPDsn11x4=;
        b=TMywT7btQU4u3spSyoWLDJ/468nq6xhx+jMZZrf3gwhl9IYxrBjulIblMspX9W3cL+
         c4qpDCm76ZfB8AfEzft9P0ancqXdpJ8tdP4WnwlgoHW4R+hRErCYJD4q7tAuc27A87bO
         SBvwhFhntnGnFMFENvJ+vCXn86i2W7mQoDeUJ1esqLo974aYVdfIEyQaqx8dU89GQCt3
         zH5lVyZ2yoOHv7X3HC8Oe9unYFTTurcnR4FirWfH/zRj+Ou0qpYioCXEaulEBDDUlM9X
         X+dBEEUhzK3xWTr056T3l561Ni0CAyWqQ0SZgmNwnDnZC5wZg/isXfeHhlLM0GfB6v/f
         ux9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784458418; x=1785063218;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FhGxTEOOON4RkKT9KdpeyXrdqn2SrMJKFWwPDsn11x4=;
        b=WsfRsDAGtPNKDUgd2XcCgNQx5mY01/M3LPyvtR99eQkmHbgY+a7/qmFbsYXJrqvZnn
         WXGxbh0So0BCCp3dnBT3GCug5uajdU54vS44pOiykln/cXKZ4cWFpRU4YZ7SvaqeVHL6
         BQNYvcEEzlL9OrkLVsBCjMdKyQq45uHJ2h7oxwcKhKzNRvc/Z6KTmjvbtztgCOPpQ++Q
         KEsZxxUYq1ASftMe5I6DqhHTWY1tO8W1aUv+sL6cXd3XIlGJX6/w9vkMP6X7FFe0FkY9
         ZciP3+TucEvn2Mc4NLt+pVLzaTQlSO+fWaSl4xHp4kMC5vnveue1Xq8+AD9KrLOx/u/z
         rWvQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr0MT0xZt4Bqdhs0IOWQ7M2i0RUApQ7pn8DGO+fqTCiA4vf/q2s28P1PV5CJLhJG1zichLHUZeSxdPL@vger.kernel.org
X-Gm-Message-State: AOJu0YxjJR1bbOhbqCV9pXpq5DyajxmWPz2MFcHEugY3OITiR+8/XOzH
	wj+74O6qD7BK3P74tPw044H7+pebrQQ/1p0BAjU0/vD5LLCMjUAh0R425l+I8wqFJw==
X-Gm-Gg: AfdE7cm3tKTGMA2v59ihFwJTS9N2ADHB4ZfaF9YO8LvIcqZfbEKSNPaz1NvS+eezyC3
	OCg4nsIpOFTO2pUCB640bCA6x+tVRSYmoTC3baNMLd0xcl+kaI0wo3eLUkvszjd8u1NjFT8Xodz
	AdOGuKtZezcwLq9vccJM2XcvN4ZThYRUTRzIdcT7d0Jf9N9QWD38pCyVbqoWOxfM4P0y1YwSi8g
	vKxFDRKvhLLMdmUx4AcgQWpRuMkJjj62MV/wZ/dzIFlmQN9MeAyglg9avds8ip26X0d56yp5iMd
	7HzKzmoF6AikggIN1On0FSFV5IWMCmCJkWtybvwavSaGD+1h0zehCHaSaXfsxKsLUfWlOK5Hzbb
	zwaWIxdwuR8FfdhprOhc+q6fRRT3vMNV1BbpCo9fmHkaRiXY5enMTTlcyMXmiIQ==
X-Received: by 2002:a05:600c:35d1:b0:495:3a52:71b1 with SMTP id 5b1f17b1804b1-4954aa1a34fmr92326745e9.5.1784458418163;
        Sun, 19 Jul 2026 03:53:38 -0700 (PDT)
Received: from mf-00-01.. ([194.220.239.180])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954a2a24b6sm197679575e9.3.2026.07.19.03.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 03:53:37 -0700 (PDT)
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
Subject: [PATCH v2 2/7] md: ensure REQ_NOMERGE is set on P2PDMA bios
Date: Sun, 19 Jul 2026 10:53:22 +0000
Message-ID: <20260719105327.864949-3-mykola@meshstor.io>
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

