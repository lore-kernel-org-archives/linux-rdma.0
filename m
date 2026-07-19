Received: from mail-wr2-f0.google.com (mail-wr2-f0.google.com [74.125.225.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF5A392C25
	for <linux-rdma@vger.kernel.org>; Sun, 19 Jul 2026 10:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784458425; cv=none; b=PxcnbhTQZJdHcc59zHCeaMyQcndcrSAbqWOdQPwbLOlgIMWzq0RZr1G9pZwZxc2N3XVRpjQ/QeNLP8y92uhs2DKi6IBF16usmo12lgE0+dfYvIB0gvcRdmFuYwSIkvw15ROcpi5y+tclltsJ30aqR2SQNKX5a1FrVPP8VdyPSnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784458425; c=relaxed/simple;
	bh=x41+O7RfOQE1nIXUFKbgkPW7MiFw2TutvahKq8Yq6SE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tnjtAmwOUcrO67N1zrQ+tnCBhOFxF/ZErsC1ooW95fs09KCG4ftEuzcZmdUpbifKp9kXWQUnkch/NavuhqbVSfHqvk635RXwZSwWlbZPuPr52Nad2Ga4XqKE01NdB6Y/eN3DvwzJKb2DWG+nEYQfyG9vsTw9Rywk1flI2PG7NII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=bUSiwg81; arc=none smtp.client-ip=74.125.225.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="bUSiwg81"
Received: by mail-wr2-f0.google.com with SMTP id ffacd0b85a97d-47f6c54e841so379535f8f.0
        for <linux-rdma@vger.kernel.org>; Sun, 19 Jul 2026 03:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784458422; x=1785063222; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=khPWV7pl2ttOdMmwNwArwe3lfR4e9+Vyg5lRTCmC9jU=;
        b=bUSiwg81KAOfM22LDx9gw+t50bGUmYodReq+fQquhtG/JsihiqGkf/3EopbJmmw7cJ
         q/lqm3v6njEwm3qFRJ8NjUlQ9XMuzATBbXRkO6YvPaHFlE0bOzoHa+/GR2h3q2xfddUr
         P/2HsgsnCiGmy0cgLTi1clx2QHR+DB4pxXz7RQ9rVmiDcV4N4dxGYXTF2CHTJF5D0CO0
         tYZl4gZPuyXa1wtkj+pryj/f+9fev7qAubOycWs8WaIngEbzUL+Fxb1nexVnaBrRTYyZ
         mAGJj1JwFLzIFeALKINsW08EogotFPypaBgplE8TBfb5WdRxpoke/wHSsrKKG0Jkbbog
         E/6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784458422; x=1785063222;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=khPWV7pl2ttOdMmwNwArwe3lfR4e9+Vyg5lRTCmC9jU=;
        b=eKDluOFK7CjqEChn8jBDnMKfChjxFszVyQl2kqi+c5FTbORZlTDVCjGihvNxQ7TXQp
         7qxhqycTw2N+BEQV0GY8mFd3hv5qrai9+OLdgAZ5Yj6F+uwZJpsz9UVytIYhQ4+VInEn
         AVoqsn456oi3LHFMaQIsbEgLEgrZdo5nqBIQN/kPf3KUKZU4JUurBPsy7rHdy5d9cr0p
         EnAwdn1bBIwKlKn3QeA9Q24NRRWMwvIVlcJ3VnrTUuRR6eVhwKbjYvtLHF0tKAhb2ZJh
         y+kzQBO6v1T2BbnrAa1JXB4q5pIpF4UrtzFJgV2V7QV3bNOaAartFu6YDCl+nJdhKQ4N
         QA4Q==
X-Forwarded-Encrypted: i=1; AHgh+RpLsMi/GqKHsTEgSxBhuQCfFR3j8ELtElv5AudrPq2TolHE8JC8HP/CWjQB4mbqbNWcGR1Tn6yMFbDm@vger.kernel.org
X-Gm-Message-State: AOJu0YwD8qG4kInvA6Wi+yrD4rqFYCY9TsEaa/4S6KPHMMcBQyryl+kU
	rwbs+RIqoXjiPWinDpU84ujzvW3QMQ965UhO0V0UgIhBCCqNXQ7aNPWqMWdzKj+VvA==
X-Gm-Gg: AfdE7cmZd8zhS2ZlFMO/HbBpTxf1TFflQmzWkUGoV/yNcX2drNOwaan6EqxC1ko7CMs
	7iaMZDBsAt60FGebfyrfNh3k9gbOvwYJW/CZgr3RPY52AgW7YXU+aAhqly9QalGK0QEP3iR76QS
	kFmxZAg/omQ+c8IYsUFzseQC+5OPCEU7slrGPJGoQ+TdckZt+9eNRY8LYnf+c047XY/7Gyo4LQ2
	K2jZNvTTAN8oAXDW2FG1yGeAEdXFAQOtdkyvo9KQj5CBNuzACLNSCOlxjPMTVGsZUA8wbQBP3jk
	STmG/Ls3BdHY0+kcqiIJX1rWWhLH9EHPscD6feZ7mj2fldU1ts3azqIWanAcWskv+2UYk7+dIKy
	PrsHJZSGOe6BgsTNGvXmxF/QtF2sW7Rzncp12bvW3ZmNCK6a1MIi9k+6oKs/JsQ==
X-Received: by 2002:a05:600c:6dc9:b0:490:688b:f9f8 with SMTP id 5b1f17b1804b1-4954a5151e5mr80660155e9.27.1784458421726;
        Sun, 19 Jul 2026 03:53:41 -0700 (PDT)
Received: from mf-00-01.. ([194.220.239.180])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954a2a24b6sm197679575e9.3.2026.07.19.03.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 03:53:41 -0700 (PDT)
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
Subject: [PATCH v2 4/7] md/raid1: don't use write-behind for P2PDMA bios
Date: Sun, 19 Jul 2026 10:53:24 +0000
Message-ID: <20260719105327.864949-5-mykola@meshstor.io>
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
---
 drivers/md/raid1.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 8172df882f26..914fb86452c0 100644
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
2.43.0

