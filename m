Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148FD3B14B3
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 18:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784746757; cv=none; b=EpwV4/JlWKJvV50/B/deMjX4jTUKCrRU2zs6FudFrTYf65e3JKNmA8vJuxTdirovAhOqHUyMAa0XgYQaQa0/4YWD9mrTfMH+YaZszk45s633D7sqXqsk7eBfBtapslcXGC8NA33QKlkX/U4QsbW0GCcPULcbzw0AjWd8zLAm7fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784746757; c=relaxed/simple;
	bh=tb87IS5YwxWP0/pdiRmCvUCzVsNHu9wl18O2iixHy6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LDQBN76U3tLV/SzyRPc3AbsShtUXYslKhwEHdsiMLINlY1brZFdEEbscsbp0bDN4wjampUCwlxtTvhOd9e0dPEP+nZm54l+AEgY8NzbzicsftsTvtvbynVcNdUgi6wwMSKf0O8ryBAlinRO9RJIrBiR3kxvu2E3MMJRM8atc668=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=ke96zD1A; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="ke96zD1A"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4953de5be0aso49401045e9.0
        for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 11:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784746747; x=1785351547; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jvUC0Lia0it+LgLYsOXSPjeMnXEhLq3Hqn52LEDkVn4=;
        b=ke96zD1AV2KN7/+6dDmPKBnVJGHdbbiVVwXnekYtUt5RKh8NxsEXdLh4Uhrtj3OP+z
         Qa5Tjtwp+zgHtPjbmH3sLbPAuREYsRuyEi64W2NwBdnsmMmAk6WQ7+qwFI7D272BVQcX
         +4x7jTG20yYoO5cuGmCNe/+2tylFSiszgDYajx4OjtF9KyTRz0yLQqTUUYwHiHxpTAT4
         RWdrCIx2RSbWF6yp2I+Adi8w+y0/CWUUFbEkOqc4fXhCR1L3uydeMAZZiLN3IZS9fQv4
         qUxQzbQxifQSHcmfu3kGAYb1Sk1hGER4swGw2xx0wzQnRi+IYx0e3kS98iq0ytplswMF
         JBew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784746747; x=1785351547;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jvUC0Lia0it+LgLYsOXSPjeMnXEhLq3Hqn52LEDkVn4=;
        b=JCWoI48zqSWy2NLaDIvdhFQgC11fVi57A5Dp+52573TqFJVF7XZXMQCcilAGtN5nu7
         CKWv1SdgcQIBjqn11r7adk21QOoPe0rDG4cDyqtGHDRzLoVIOfdnQMVBlLzHvn8bN4eL
         8T9C4OQtTi+WQmIYGXbDSHm/TTwxDeyrVvwe2w0rn1wuIGJ+p6C2p7FkfKz+NedItavc
         b/1cYBufl7UVVJ2Jz/A4KrzXTWydGdY191IezQqH6yidP3fr1S2llPnbceKXZvwmHBJx
         frhDpYpxItqX7mCE46E4mSu3evJ9JMPRkLmHa7FnjnSODtZZVj488mEb8jpJMZ2O78R/
         aVMQ==
X-Forwarded-Encrypted: i=1; AHgh+RqIpvwri2i2/D55byvL0WVNSg383dBHi0wwbO58tUgxrc3bdIzW9AZgIF8AO+q8RRYJ0loCy6JOobcd@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+vIICwPU5QEgfq/dA4+mEzX0Wyt8W8vjzK8Kys5ME7crCwL82
	wg6vap90g1JYqx0hdoVfqsUuwxpTUiYOEttITwK48jP7HXC3/sGjh7rKXAG6CMOfbw==
X-Gm-Gg: AR+sD12WGJvLp2cSAfvSz7131vO/4Vk5CE3YdWbdxEVRgfZ+V7bPR65ocD2prp8V26/
	Skdp1gDDpyo0DhVcLB+jSlVCQVCiAvi1gxSsOKH4m2YKAZfF5kpIuV0ncczuYHJ4O22iopejh0P
	QHVtyJI7U5XarvpWCUQVCXYr29e2/EBpVsSS6edrrLCWSJEUvbB6Yq+DeFutC53uX3USwhWWdnh
	ESD8ShbyxCP/wbPncID7qwTVntxX6DTUjOZx4OcI8d4kTg2mU202bQT9vz323Pn0KnIsIuAQqBX
	JrvG6/bonGRVZV6jvcLOgn1h0wQPLJNnU7VOBSmxgjUgAqimW121jb4Ma3Gfvr8Zv+tDXiLGZ7G
	DBgomytDN3rrryh2z9jfGo4svTnnRfWfrCbzc1iYuPl6FLyOPmrIlYWcuF2TIJUzWMbZtgaXcO3
	xIqjg85RWeAG0hhPLSkkhBOP9vxwEjE/MDY3xVt9tYGxuv+Mg=
X-Received: by 2002:a05:600c:2049:b0:495:6397:14b1 with SMTP id 5b1f17b1804b1-495639714bfmr108525535e9.34.1784746746655;
        Wed, 22 Jul 2026 11:59:06 -0700 (PDT)
Received: from ai-pc ([46.172.241.174])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-495730353d9sm13740055e9.12.2026.07.22.11.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 11:59:06 -0700 (PDT)
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
Subject: [PATCH v4 4/9] md/raid1: don't use write-behind for P2PDMA bios
Date: Wed, 22 Jul 2026 20:58:36 +0200
Message-ID: <20260722185841.449934-5-mykola@meshstor.io>
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

