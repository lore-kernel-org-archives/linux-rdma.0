Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A81C4823AA
	for <linux-rdma@vger.kernel.org>; Thu, 23 Jul 2026 20:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784839394; cv=none; b=npO8qjWzSxEXpUkMyDiMA9SxgCZPZrR9jTlpb/K3/Qq0dleFldkZnxyOVboiaAHYUckdO0nmEZ2L2p3pHb/SoNO1Abbf0StYV3hWJU7m0VtVp1KU/N4jsv/70yPzoCpd0yFHD/UHgYUkS4TkikiYYSTmZNQYxXKeHzQBYualpF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784839394; c=relaxed/simple;
	bh=6JUXonkvhqCluPq91YNslI6Xc6PHhaJJ82TMx9QRo24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YfF0wdZ4gUVwP+E2niw4SB6k5TdUzrKhAfEgxi2Sls8Mar9W0FFUI76+4tkNhtKz/im6Ra0Yg5Zkn0x6kdPm+7cBZSKUVoGgX2rAWt0Ua7F7yUaf947nnUsbhWHx7m8rsxmp+TaVQmFuDbdQCpoUg0gSt4kcJP899iC7NxrYh3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=b9TCH004; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="b9TCH004"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-475417f010dso823606f8f.2
        for <linux-rdma@vger.kernel.org>; Thu, 23 Jul 2026 13:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784839387; x=1785444187; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=InzNp2nHOOp7QQLn15Ay7fcFkfBNFGx8C4/KxQQFD2c=;
        b=b9TCH004kM7Ijzlq2L+uYapxZbsJtgiPIoccs97iLOok/j4G0z9BoSi7OGTZzfNraM
         9nBbybkLeR3kaqz8qibH9iQR2/+3QMIg8k9UtqWVXdcUsUBX4RdymARurgQLc9PBz+tX
         cU1oMcOcw42w0OxGq4UZ131+iaLE2py0jzPsTM1peGRNz2HSGRqdZT2XUA1zms+v/aFP
         RSKb39m9qHn/9kGElrHMfdLkSFCt2vA+ObV319T3/Q3iv30jBdhCVHMR7mKE0DXcTuWe
         tR1+ya8cQ5UblTusXMB+XkhJKb/d+KQIXTWrnGw3X47bbkfgMA0AmX7SlpGUHEbpPpM4
         +F7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784839387; x=1785444187;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=InzNp2nHOOp7QQLn15Ay7fcFkfBNFGx8C4/KxQQFD2c=;
        b=b1c9U8vC6UEV1drVSHUHVpoNEC47X7dgCpOlanEDsw5K9UA3G+Y1Zdl3ouLyJhdUHq
         6AVMEraaLJMCSYQTELVclAGWlOo7pB9oSrWXXGru4kbEpyoZlOb//8CCgvOj+YGeti1S
         j/WTICwjJDMzrreufmWxwliRxnSK61yuw3MwGYlRBvbkryucWNK9ughyNSOPA3LNgTy0
         xX06iaWs5BHpL76vzZ5ZqZsBazCCk50J1s7gac0we3MzSjfM0y/Jfq/+YYJwh/4aGG+1
         2q9O/TQHwMBvOuExphkt/ViUM/vAHVEXD1wkwr43OE+F3mt+xANjJ8VhwyUV6C0dCHn/
         PEvw==
X-Forwarded-Encrypted: i=1; AHgh+RphioGtA3RG47H27EaG4bVa8Y8lvrKyBXQ1fZJSAQuA8AJzNN7Ayq4oghUfF1B91rIeuvxFECBMPZ8y@vger.kernel.org
X-Gm-Message-State: AOJu0YwHSgucdCWyUgxi7cr2LIDVY7DZuWbFF23ih2YSsmwCJkj5gHac
	ECQ7B1tISOY1cpxOWZVLWF7MjhXd2ICOCBLh3HQfIG9hcdo8gUOd6ZOjbqoQwcme6w==
X-Gm-Gg: AR+sD119AT7cFLq6UxixwTWJ+mdlEYjHt8h/bruC8OcaTjES+MYXT0KiuxmV/Vc6Yem
	JJ5HKNZCttpMLF33+Ja/L0lSLuyD0db76nGxRKNQOXGCdY8gZVFRaxXgCxZgAJ3byF7EXOw74Sx
	rT2/MPeX5c6NDzIwgkaXpbskqJC+k55xo5cgOTr+/Uqt7/KTwJ/Bkij9EZWQurL56fT8dyU5kpJ
	wBaERgDSPf/J/zeI0B9nokIfEgfHbu4JuylZIgJNLAWMfCHXTBEmYF41k7OTyUOkYl9On3mbEnS
	vhzdv8NQhQ2uS8egLRcJfJP3TVwarWCd0NOTOpWmpmYr9jmiw5/t/K+4LFV4DWaTdbusrHJdPAE
	Io57iNHEsnKlCFuU1vO/OpvFU3qU3q3HVelLl1WFbL2+dvA1qTehPHCg1D2onflPf4jn8KD6syk
	3dbuPW6YPBm1Nms6WAKtygRq4kwbBAD29OEV2mgZjCIAPTiGQGUdNpWnc+Sr6a/XgsthfvMH3v1
	HaXU/MaTRqs2p1Zn71syBdxBbHApJGhXULW/OncMg==
X-Received: by 2002:a05:6000:611:b0:47f:25b1:e7b6 with SMTP id ffacd0b85a97d-47f8dc7a211mr5521629f8f.30.1784839386364;
        Thu, 23 Jul 2026 13:43:06 -0700 (PDT)
Received: from meshstor-pc ([185.87.42.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c52fc0sm18268192f8f.23.2026.07.23.13.43.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 13:43:05 -0700 (PDT)
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
Subject: [PATCH v5 06/10] md/raid1,raid10: keep REQ_NOMERGE on narrow_write_error() retry clones
Date: Thu, 23 Jul 2026 22:42:02 +0200
Message-ID: <20260723204206.76930-7-mykola@meshstor.io>
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

narrow_write_error() re-issues a failed write in badblock-granularity
chunks, cloning from the master bio and resetting bi_opf to a bare
REQ_OP_WRITE. For a P2PDMA bio that reset drops REQ_NOMERGE, which is
the only request-level protection against the member queue merging
P2PDMA segments across pgmaps or with host memory (see the preceding
md_submit_bio() fix): the retry path would quietly reopen the hole
the submission path closes. Restore the flag on P2PDMA retry clones.

Fixes: 02666132403a ("md: propagate BLK_FEAT_PCI_P2PDMA from member devices to RAID device")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/md/raid1.c  | 3 +++
 drivers/md/raid10.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f07edeac6e5a..19c4dec450de 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2561,6 +2561,9 @@ static void narrow_write_error(struct r1bio *r1_bio, int i)
 		}
 
 		wbio->bi_opf = REQ_OP_WRITE;
+		/* Keep P2PDMA retry bios unmergeable, like the original */
+		if (md_bio_is_p2pdma(wbio))
+			wbio->bi_opf |= REQ_NOMERGE;
 		wbio->bi_iter.bi_sector = r1_bio->sector;
 		wbio->bi_iter.bi_size = r1_bio->sectors << 9;
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 5b63175fb382..428bddddfe71 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2823,6 +2823,9 @@ static void narrow_write_error(struct r10bio *r10_bio, int i)
 		wbio->bi_iter.bi_sector = wsector +
 				   choose_data_offset(r10_bio, rdev);
 		wbio->bi_opf = REQ_OP_WRITE;
+		/* Keep P2PDMA retry bios unmergeable, like the original */
+		if (md_bio_is_p2pdma(wbio))
+			wbio->bi_opf |= REQ_NOMERGE;
 
 		if (submit_bio_wait(wbio) &&
 		    !rdev_set_badblocks(rdev, wsector, sectors, 0)) {
-- 
2.52.0

