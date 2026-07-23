Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD20456E01
	for <linux-rdma@vger.kernel.org>; Thu, 23 Jul 2026 20:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784839385; cv=none; b=Ek6Xzbun7mAKpDh0LT8aRTgi6Fn0iR4G/dnaBEU8c1POceep2GDD6MG58CuZzsQT4h6CsJyre4t7wMNq4jX7Vc1grnhnEPiZpMe8CfqVyN5eV7GiB73LczQl9+ZLeiNR6LOTz4r+2faGzbKQhW+t3EFkvYAE3eWs7YW/NCcfFDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784839385; c=relaxed/simple;
	bh=UmHDQ8Avh88213YFsBTKp7WY9yAPzXpx6PsDprJSvWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TTdbO0giG7L6uB8MaGq9Ev+dAr4fwzwE42FGsA8jOB64qUf3hRUdjU15gpMpPi+QRXDuDkY5YLDQ6U16fWmRnfLLM6ZeNIcrDzcqxc175GznsyADDGuahBZ01jKJEXcFP8SM68V5fDLNJxtOEbxK0Aq9MBcfxL5j6yKWGk2k2NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=C1ciT6M8; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="C1ciT6M8"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-47f92e3c14bso740486f8f.0
        for <linux-rdma@vger.kernel.org>; Thu, 23 Jul 2026 13:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784839377; x=1785444177; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V5hliKyCAPWFZqHS5mW2T1dJRPt4J/vTka7mcNCHq10=;
        b=C1ciT6M83/HGZQhgGwKFZG1M8g06jwXG8b8SpyZRp6tX/vwlKnhVAXGgDf1qHqNpqQ
         bqjGUOBgB0Y3+3Ng/7CsHYOhB59s/nnFmWKDWObGXB0f7cHQyNK/08IVOvMpodeTywav
         7p7H2AZ1G51wZrkcapsGj8Bjr8x/1tftZhYVsDbAHMsO2AtTRNrRmgZGmaCu3ebPJBnw
         NFFMuCNvwAb4ba+Z8zafhO/h3+NMMxHT2nWdbdeedj8Pj9Wv/rUwglTmi3U3NzvNvF+0
         E4Zw3lU+0sid2q6loyN+AZ9oAivVppyVhIDO3ZmHa2tfeGd21EXa8mgwJRpOhASeK1x1
         GUcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784839377; x=1785444177;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=V5hliKyCAPWFZqHS5mW2T1dJRPt4J/vTka7mcNCHq10=;
        b=K16euM8dzd1cRD1krH6miR4SXg4if+MEJvKERWyHExMvoPR2MLidBmyb+VB+EIQRJb
         d4cdlYAcIA89Cs6UhEvPJBDGq7l7MU1Iis/5x4b2GziHobmz+hpKG6v5ezAJvQM6pNe6
         l1xYkpwgO/CAcJvBg6A3nlco1UuwZ//XY6ioOiIS0Cgs+bH+FJyovvJfK731SXXq9N5U
         93LeccXbJ9fXYbxaKVPrpleoSZFqTCjt72xcZaoNZ4Y9oVBBoWBZxdagFfTWgUlYgWXh
         h8JC9tCvb09hTUtKaeTJDabqKr4t8NFinTstzSForE8DRy6jF+AHVcRR2mamOKSO4Hzf
         Y1cw==
X-Forwarded-Encrypted: i=1; AHgh+Rr8LOnwmmq+t6B5UDFbRAeeIP0Co3MAs5HKnQKnDw36iz/UEDRIp+S1bRqEewQNwwFk4W3ScXJ0XBXE@vger.kernel.org
X-Gm-Message-State: AOJu0YykfH3VOoLgS31X3S3HOSu2fONFd7EXapUk7tnisHfuQWF/JJh9
	iFZ7XNAl8BXv2t0DaqfYigJqx3GQ/JZNCA0itFLHUOYPmhV2t9Bt/Vc5xIa5gZHJIA==
X-Gm-Gg: AR+sD13yiGciIb6LBH2rhYPYDkpppb4WIXNkr1GP9LhuJ6KcEwsIxiz96NWlFqr41Q4
	Rr7y3cMKZad/bx+AIywt29WWg9WXqtuiHyLXyN9rwxguRAaKtSO0QbZQluqVB8zCoEb4sb9peTG
	D+MYsoicMOJ20oOQS9bY0IKhmpu9hagEP/e3XYedAPmFH/YI+0JIdnOyEO5YCX4yn798B8CCeii
	OxqzsGTdSf0H7XWGNE2kAj4zi1radVPoDlBb6tc/02agraa8UdHglm5BnuuEVwEUkm+Bh0W0eNg
	SZCIFsgj/W3hVbB4FvNqKZujJHBGyY+C22So1dZp0QkKWG4TulxRD+qUxz5NEbk72l2rVESCeEf
	1SPz5QHSf9V7q98kQbWrwkGf4EtQ747R1IVtAYnT1PRER3BWO/9rKsrjEezoQ1MTL00leB8vhSX
	Kf2lW3lqnl32fSptw3OJaQcNDXL+fdGjIX3hzdO6ugt3bhDIWnyaEZtZE14/FCK3wiugbadJxwZ
	rAT++uOtT3V9Dm3P/g1qZ5hA415Vc0dezsarIuwXw==
X-Received: by 2002:a05:6000:603:b0:47f:5a97:2a63 with SMTP id ffacd0b85a97d-47f8d6177bcmr6091080f8f.9.1784839377410;
        Thu, 23 Jul 2026 13:42:57 -0700 (PDT)
Received: from meshstor-pc ([185.87.42.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c52fc0sm18268192f8f.23.2026.07.23.13.42.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 13:42:56 -0700 (PDT)
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
Subject: [PATCH v5 02/10] md: ensure REQ_NOMERGE is set on P2PDMA bios
Date: Thu, 23 Jul 2026 22:41:58 +0200
Message-ID: <20260723204206.76930-3-mykola@meshstor.io>
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

