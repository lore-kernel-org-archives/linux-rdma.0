Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FD83A1686
	for <linux-rdma@vger.kernel.org>; Sun, 26 Jul 2026 11:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785065563; cv=none; b=NSArAJkmxtLakwH6spcKGYXlxCpVBZ6We6Os+GX++V0xO7QbyC+dwY81sKBw5GM2WeLKWR3nF6veXdhus+wIp+7i5/J+s6qkFHeiPxMHMP6jCNEBOae9Jj0n5YzUXg3I6Xq4r8XT/X674SAz7NPK/mmbd96eIN0p2SZ479ESWOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785065563; c=relaxed/simple;
	bh=UmHDQ8Avh88213YFsBTKp7WY9yAPzXpx6PsDprJSvWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=efjxY8FJ93XJAHDWPStX3NpON6bqGocsg3m7wOZXiX8y7XP7O448PMKeTYgPDcDb6UFqR34h7rxZBdyq37JUh/7vMnEwWknV9y6IzGxw873SY2K8Y0WKecfr3laQbGkto+LgaZKj56TGnu9S4Xae82DyjUsok9wXEfg5t0r04OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=NvQ8//bf; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="NvQ8//bf"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49557167508so18395345e9.1
        for <linux-rdma@vger.kernel.org>; Sun, 26 Jul 2026 04:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1785065559; x=1785670359; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V5hliKyCAPWFZqHS5mW2T1dJRPt4J/vTka7mcNCHq10=;
        b=NvQ8//bfQJuzp7j3yL6gGGLYRLnOCIWXp9Tvdo/+924SfpBfJNqUZbLQ/g52q/t3IP
         EIMETlmWs5z4+GPI7G9faNf0w/VzoWTgtPV003H4FOTYAkbA8/VncXQq+0VjYU0fx3EW
         W6k7VMG/U1W00FFP64RodffPkWcQX6C4WrqnPoTE7X48uA5BvZtLcjeyriHB4OvsZTug
         VDWon6KhNPTPrdv5OgErtQAFkMuTKEUU9G6gIIjPCbUKjLUqk0bzCqnnJCz4ScP85sbn
         nr+DIJD/zcANqYHkcoigNe/Jtl+6UY1MQ8B74D3cVc51Y96cXwxVP5uVswIDnDmV4/it
         FF6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785065559; x=1785670359;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=V5hliKyCAPWFZqHS5mW2T1dJRPt4J/vTka7mcNCHq10=;
        b=lCVscBxVw0yVxL/P56p9stsifk3doCoISz2aAWWtA/n0pRQdl5rPWvdVED/5R1CUjF
         MogTjnHjHhUp6PE9vPbmNZv0Rc9H03KGuziY4PJe4FowWAkDjonR/QiUGFWyuG+mb9OH
         UfvnDYl1I08VzDWu1HuVXTDAY/4WQiKJRcJYz8JhARl2fH9ogvmzga1iXESSPm7nkuKm
         R+H6WNF8N2dkl0UnJsaePqa3PwrQH5FIEkovS4lQyuXq5H0qyErMm39pcsXRbzV85rYw
         rnPKlyPo4qlQULN12x1JQYSGpoZf2w/vLfeQCCqWRzn+S2MdTPMwDjLra9ldJ4IpCXSy
         9jWg==
X-Forwarded-Encrypted: i=1; AHgh+RptuyfGATkTOlgKii3uxdjqaETmKTv0KBcbu0inCMpa+82fn4brutmsUGAAUqlhVxNRXzfItSIwRYCn@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4QQtTtIBscXAOFqR07fsia/cci3Ocrl9ORRtLaCXdNtkvVczo
	YVmKSEFnonwac2sI/EGFX8HSYrDxkL+aAbSL22F6yjdICi3qSoek0yGr6TKH+Tsu5g==
X-Gm-Gg: AR+sD10v8oP57R+57kNjWhCdk1Y2xYK9hz/8qeS6OHCB7WTY0czUskfKPHAM2T6MYoo
	jj24IFt756ny8Wu8NzAtjAObcRLK4XjnAYIc9p9VZ3P1nwF2Ym9knZXdOGVc+wVMTiU7TnNlgWR
	R3P3YMNstTzE/lCvuKgNdXnVPjPMrqQ7E3/8nmxB+Ljki0rj6WNx0G/o1rS/s5OtvaSYLuUOt3j
	0IBXJIZz0w5Tw7aerLysIMiVIkbNAg0tYOMXQubkZkeWLY6EgzV+jwzY2FwHGR2RO27+L7HLXWD
	nVFhsb7od5D8n9yDF4cLvCRS/l0Vw5uG5rEUOO8B2ZC1/TFWyq64WDXxaUPGGxBER+nGW3paGrv
	RsWXnwq8IdSmhO/HIVnMxfqpRNU0jtTWQ2+vZSKNriUE22BxzPp0KmcamUk7SijpxilQDiy9lOK
	GuC7lOH3ESf4p18oPLo5CEmzW25/Zk8ZV+beKpK6H/EMDOvtmliVDOuXbNePDKzFOHBjay598dp
	1DLub/XTPmReGdXJXsW7vvfd1c2/ey6LDZHlsyi5w==
X-Received: by 2002:a05:600c:1d0d:b0:493:c8c6:4989 with SMTP id 5b1f17b1804b1-496b56bbc65mr64847835e9.6.1785065559344;
        Sun, 26 Jul 2026 04:32:39 -0700 (PDT)
Received: from meshstor-pc ([185.87.42.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85bb57cfsm40533083f8f.11.2026.07.26.04.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 04:32:38 -0700 (PDT)
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
Subject: [PATCH v6 02/12] md: ensure REQ_NOMERGE is set on P2PDMA bios
Date: Sun, 26 Jul 2026 13:32:19 +0200
Message-ID: <20260726113229.2154269-3-mykola@meshstor.io>
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

md_submit_bio() strips REQ_NOMERGE from every bio.  For P2PDMA bios
the flag is what keeps requests single-provider (see
__bio_add_page()): merging a P2PDMA bio with one over a different
pgmap, or over host memory, maps the merged request with the wrong
bus address.  Set the flag on P2PDMA bios -- bios built via
bio_iov_bvec_set() arrive without it -- and keep stripping it
otherwise.

Fixes: 02666132403a ("md: propagate BLK_FEAT_PCI_P2PDMA from member devices to RAID device")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/md/md.c | 10 ++++++++--
 drivers/md/md.h | 15 +++++++++++++++
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d1465bcd86c8..3770bdb4d4b2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -451,8 +451,14 @@ static void md_submit_bio(struct bio *bio)
 		return;
 	}
 
-	/* bio could be mergeable after passing to underlayer */
-	bio->bi_opf &= ~REQ_NOMERGE;
+	/*
+	 * A bio md split may merge again below md -- except P2PDMA bios,
+	 * which must stay single-provider (see __bio_add_page()).
+	 */
+	if (md_bio_is_p2pdma(bio))
+		bio->bi_opf |= REQ_NOMERGE;
+	else
+		bio->bi_opf &= ~REQ_NOMERGE;
 
 	md_handle_request(mddev, bio);
 }
diff --git a/drivers/md/md.h b/drivers/md/md.h
index d8daf0f75cbb..73df1a6eccd8 100644
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
@@ -22,6 +24,19 @@
 #include <trace/events/block.h>
 
 #define MaxSector (~(sector_t)0)
+
+/*
+ * P2P and host pages never mix within a bio, so the first bvec is
+ * representative.  Read bi_io_vec directly: bio_first_bvec_all()
+ * WARNs on the split clones md handles, and data-less bios have no
+ * bi_io_vec.  Not valid after the bio's iterator is consumed.
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
2.52.0

