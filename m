Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3157B3A8749
	for <linux-rdma@vger.kernel.org>; Sun, 26 Jul 2026 11:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785065572; cv=none; b=khaEMpkNGeY2yYC2xK6cQu72qEMSi6w9Y6qofxJJBnrnsN2n+qsa/KPaaf27DpsxazecOtSV4mEENBW2a3MdaG/U20B+RJXy5c1v5Hrw50UbYkMJq260AjHBo9BEoQVbwAj+meYBHeR3Rs+PtuBqQqjmt3iU4By9yBGff0he8cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785065572; c=relaxed/simple;
	bh=6JUXonkvhqCluPq91YNslI6Xc6PHhaJJ82TMx9QRo24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VgT7ILNCSOxuc644vdUpiq6MtU8PkhQ+Eo0Tthp5uL7IkioT5P1G7WJYiYhrt453GRBdS0P/ySjz+ZAbCjx35XfkcqGqSVeclwH5QxfHyNPgBvTsiGcYuYvhxV6f9pit5nV3DztJ1MkacwiEm+HtZuPq/gTnRXTXGJoQeG6O+Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=UcKddbKk; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="UcKddbKk"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-47c6e9a694bso1042007f8f.1
        for <linux-rdma@vger.kernel.org>; Sun, 26 Jul 2026 04:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1785065568; x=1785670368; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=InzNp2nHOOp7QQLn15Ay7fcFkfBNFGx8C4/KxQQFD2c=;
        b=UcKddbKk+nkVTNd4kHsgAnXK+qu3602GkP3rsgzCLowWckJGUHML6/5jd1eQHErJv/
         SJV+xgbmbhpJbF8pxkBMpmdz2mxqUp0d4gfJZNyeNO7HSLV70Jjh5s1OLtjELA5Q7OTS
         MVclHgcL8qyU6s23t6NETabRZJorB2CdYaWL3S+6K7d4LmiAxn66bJpQnM8dXIK7/ajL
         gvdcMDsVQFpihPUj4XHQWDuGNp13dHMxHde4/ZduK5ji3SfPQlBZDpthP9tVlpaf6qBY
         85MD9Io6JiJ/UlyNC7ELTED36z2Gxwu+Z2WqzbBzPzYyEgzQAPzvoi4Kx3GWDZfXSLKS
         9TDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785065568; x=1785670368;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=InzNp2nHOOp7QQLn15Ay7fcFkfBNFGx8C4/KxQQFD2c=;
        b=I7dp6djYG8B5qXgNfqr9hNDS9xRylsF6otpjAcele5tTyurKqulfRM4Z42XxQng+vP
         hEdyIAExVO+drjY0i++Wph0lXN3Xd1fRduJ7FMZrilOcMM1BbjoUq9GNQ9t0ohndex3M
         ld7DR9JE4XDCAD8Xc6Gb5p55/Tpg5JsOrkahDPv20e1NBfneGy6TM0nZ/eNXEejs0yko
         0fa6fvLWhtSXVp6t8EjPjzDr7QmBTn+SZl1cYEVI3FDuuFiJHTjjMlMWtKO/vuK3MzwN
         iVmXyywlPPOELKbTBYZMnj9Q0CjrQvEMldpcZ1VxpMUOgTUxerqsjoCPTPSBR5YGck0J
         +Zmg==
X-Forwarded-Encrypted: i=1; AHgh+RqVf5pp9s0lt9YzDeALvNAnS3zFI8jTDYEe2HepX7dgRjIZlj+WlZ5Wuhtzmfce0smV0bFOjZNSjO5F@vger.kernel.org
X-Gm-Message-State: AOJu0Yzxb04VqJeCW2Tw/lAhUAVD5onsxEgvb/k6li+Fo2C/wsUzriDX
	ly4qtErqHleH3fGazu8imyo2Lb2bR3otazIc8rk65tfSwrCUCittMLbbGrwWOkn/sA==
X-Gm-Gg: AR+sD125va/Bwp9UmM1QtcJLFrwPYewLNO27C369/Uc9ZCQtyU4pXXEulmevq68/O8p
	lwwaOkJl9BA58c0hyyO9GDSNHHpFdIlwhfZYLaUzOMtyD5k6sRfdKOujNPp5lf6FVSfqIp0WIiK
	jCuigJ8KVVk6UAB8ek4B+ot+fnDndHDrbH53vu3eq15kizZp3CmWwAKaKRdvCpGISGtnhY0RLLs
	r8a6jUz/25jHgrOY9HeGe7OAxwelfZBKxlKTSZ0FMvMFKUS4dyA5+wtnNlq+Yc7DejjN04jiiyQ
	b0EDH/nM7I8b1GP8G28rGArlfTkOIyOh5t7xVnCN3lv6quOQ1e+5gEd67rZpzIcla37C435mjO4
	7XWnjm0JTTBBWKOy3TgSbGz0oPejuyFkPGqow2fdVYMoN9QW/kB4ZhVQlmxKRPUX8Dmj3IxJnZ7
	Dup5MaDma4lh5kCjqphyzsx1FER173Q5auH3DKByWOvY3ECplmj05MyS63bXxAlf4hA/iAGxZ3I
	BILDGDKboASqlpIu4s86Q8CKJtqykP9lXUZuMVH4bltay7Stxo71r8vyvH9loNKxyg3R/Vkgkv8
	KkiivpLB1xC2CNJwj+x/RQAG7awgAKzu5wI=
X-Received: by 2002:a5d:5d09:0:b0:472:7dce:d8c7 with SMTP id ffacd0b85a97d-47f9fe9e8bbmr5988536f8f.36.1785065568316;
        Sun, 26 Jul 2026 04:32:48 -0700 (PDT)
Received: from meshstor-pc ([185.87.42.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85bb57cfsm40533083f8f.11.2026.07.26.04.32.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 04:32:47 -0700 (PDT)
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
Subject: [PATCH v6 06/12] md/raid1,raid10: keep REQ_NOMERGE on narrow_write_error() retry clones
Date: Sun, 26 Jul 2026 13:32:23 +0200
Message-ID: <20260726113229.2154269-7-mykola@meshstor.io>
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

