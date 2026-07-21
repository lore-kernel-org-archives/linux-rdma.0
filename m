Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DE746F484
	for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 17:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655971; cv=none; b=sQuR0y1mR/3Do2S9bx+5bL9f6Zry4Urz5x9g5q+eY0yrU8rrigEakvnvp4GbLjaT4RKICRTB48xPdsOl8+LEsJX+p+z5A7cdhImdTvgSDFVZRuzkdCVBgCk3LNc8drARCiHnTWYejGoO6oHtffOObGNYFyQOwrxO4SAJvMmJQYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655971; c=relaxed/simple;
	bh=cD3SxDgYRV4P07YCyZ3D6dpRoOb3a5AG7H6z997kprs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N8F4knCl/n+/486pGJk6ozqIqgmicVcePqc2zQH/ETmM7yLdV7sqnTvGMaTu3+5RkbnZ+lgrFx7HyBGNEyUAAKQgacmX8X5V0nh7sUt76ZRlpcmM6DnsmXwqjTj73bOR9CDxb/CTlwD+cBg0W2lTBjYiz0eqnE29yYh6Hc5l/58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=oUIFIvsB; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="oUIFIvsB"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-47db714766aso3029107f8f.0
        for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 10:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784655968; x=1785260768; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dWf575YMSf1W7NtVvbE0zlmvwqtjFzi0s/WGa1kQOeI=;
        b=oUIFIvsBg3mo3dDAlk47n4w5O0Cc3AJoV0IGlW9f+z1B/kGJvyG4I1Hw/QZ/nXXX+J
         q2aKBdDgrtO83PofGhUhWOvDjbW4R+YOwoBc2m6Q00HU/SpzdYEhI6YXSFmhDUhJZq1R
         M81sjSglpEZAb0JgqlOhxVFbuUIBXFxLijbvsebJG064/AFroA80Beuzcf/IUzYYPywr
         RBE88+0gxMagu80LRIepOWdR9XNFVLs4RFEQmmTg2sOo+hZNkOnqpDrqCnvIzFsw/1OH
         Srns4yMDUT20apg9S8/QtMhSr2hXVCtkT6p07X62clOjHgznrh0X8w6x3bCc5unicf4w
         zwuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784655968; x=1785260768;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dWf575YMSf1W7NtVvbE0zlmvwqtjFzi0s/WGa1kQOeI=;
        b=qDEVvVQm6i5qtbIMtMddBMm8WrXdQu2ClDQYV02MP02uGJZzRbbbb3Zp0IeudkJWya
         W1Rjmt/OpD5JRh0E4iX0L2fNe0HfA5gosguIxFPKtoBdeMsHbhXDZTcAnDvZSI3Z4dTo
         /fM1eOGMDyKQXk8zene+3CPuuJfTgCHL5VcBiltbWVRvlEaOX/otyWCcumAuA5BdBQr3
         WGW2n6SERmAD2t0VyRsbs2fIuzvusK/6oPKurk8GTNlFKuN7Z3ab600hT7KkUr9poDlp
         Or1d8+5h4SWAWfXZc0SJ4F1Y7MdEo8KSslO8sxo9WQTGXk8jU+IR3Goot6i5R1w/Diaa
         I2hA==
X-Forwarded-Encrypted: i=1; AHgh+RrxzGKKcp1xkWEE1R6G7Cj2iXxD1JiSU+yIUXQzFg0k0xAq3mmeSH8BNPPM3xleAJszr0NuYK5kVa99@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8ZSFqiOh2qu3R2dT/jA1M6lFrHJJRNJyoVf1N0zUhUliqFJgA
	SpiwuEkcRUiv1ptLkNQcMkhiSqMkUFc1EvUMF9KhS+vq+t3Zbuk5RfY5dUKZ4t71xw==
X-Gm-Gg: AR+sD10NmfA9/P/gNN4EEb9O8GJ8CjL+T2IwDzXOBWyuNCJQUVlx5zt+WRJdKLxQ505
	VLJy1K2JoncZEd29AD8CcC9AcHm/dB2xZNXYXVTfNBjH4p6m1oss2Z0bWLTd81ko39UNIrj2y8o
	hkZE+lhUS7mGoEu8vW+lpOtv1YnnfbNK0QT1wMiiGvpyD83Kxaidxtn3sIumU+KspgtFO3b/oac
	aex2VhpZyWla9KWquJBENgp21xZC8SE2aDwOgLTRv7u9pp+LQqtGmMmNfWvxt1qunCVc7/4x9dF
	cfIkjXWH6PNeQ5AxXSCDp/JKVFLwnzT6ASwyleIOBZa9a+JcllbfFR1vr0Z/fwEgpGY6CPjAE46
	fvLRAvkKOpjgCN7bSaorzslZjWcJ9DwpoJsvqTTBOvdo7T0Ikxw/G/t8rF1vbT9Q/ndEzPAs0w/
	rvKCHTNoxXadgEetCTaRM1SgQUP4CcbB111LrQvEJdb1T0vwE=
X-Received: by 2002:a05:6000:2903:b0:47f:7864:1b7b with SMTP id ffacd0b85a97d-47f840c596amr727053f8f.24.1784655967970;
        Tue, 21 Jul 2026 10:46:07 -0700 (PDT)
Received: from ai-pc ([46.172.241.174])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63eddd27sm40860513f8f.28.2026.07.21.10.46.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 10:46:07 -0700 (PDT)
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
Subject: [PATCH v3 4/8] md/raid1: don't use write-behind for P2PDMA bios
Date: Tue, 21 Jul 2026 19:44:58 +0200
Message-ID: <20260721174502.111503-5-mykola@meshstor.io>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260721174502.111503-1-mykola@meshstor.io>
References: <20260721174502.111503-1-mykola@meshstor.io>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

alloc_behind_master_bio() copies the bio's data with bio_copy_data(),
a CPU copy. P2PDMA pages are peer device (BAR) memory; generic code
must not assume CPU load/store access to them is safe or fast on
every architecture, and bouncing peer memory through the CPU defeats
the point of a peer-to-peer transfer.

Skip write-behind for P2PDMA bios: they are written directly to all
members, including write-mostly ones.  Ordering against write-behind
I/O in flight to overlapping sectors is preserved: the non-behind
clone path serializes on CollisionCheck rdevs (see the preceding
fix), which covers these bios like any other write that bypasses
write-behind.

Fixes: 02666132403a ("md: propagate BLK_FEAT_PCI_P2PDMA from member devices to RAID device")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/md/raid1.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 997f79c05db7..7d769b6460ca 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1523,6 +1523,7 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 	bool write_behind = false;
 	bool nowait = bio->bi_opf & REQ_NOWAIT;
 	bool is_discard = op_is_discard(bio->bi_opf);
+	bool is_p2pdma = md_bio_is_p2pdma(bio);
 	sector_t sector = bio->bi_iter.bi_sector;
 
 	if (mddev_is_clustered(mddev) &&
@@ -1575,9 +1576,12 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 		/*
 		 * The write-behind io is only attempted on drives marked as
 		 * write-mostly, which means we could allocate write behind
-		 * bio later.
+		 * bio later. P2PDMA bios are excluded: write-behind copies
+		 * the data with bio_copy_data(), a CPU copy that cannot be
+		 * assumed safe or fast on P2PDMA (device BAR) pages.
 		 */
-		if (!is_discard && rdev && test_bit(WriteMostly, &rdev->flags))
+		if (!is_discard && !is_p2pdma && rdev &&
+		    test_bit(WriteMostly, &rdev->flags))
 			write_behind = true;
 
 		r1_bio->bios[i] = NULL;
-- 
2.52.0

