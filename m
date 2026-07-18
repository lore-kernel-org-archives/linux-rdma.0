Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E2A3CE084
	for <linux-rdma@vger.kernel.org>; Sat, 18 Jul 2026 16:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784391991; cv=none; b=WstzbgsDs62xTnNnG+ycYm6c3xACmTUKBYIxkMbPOnEQ07VPbXiYynOoKKlAwhpOT0Wbl7Yexe9RKRBvPljakTb5PdOQVZ8UtwoqwAuaAvBV4vqI8W8m16ZqHbEdoURtw6P2AWGFY7GYhjJbwxJ7j5sIfkE55/iwNGXyet8+ZJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784391991; c=relaxed/simple;
	bh=bc8MxzvbVIXgCq+hE70J7nSNv3Wiq2lrvNKvz8Yb5i4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QLvA6fNmSTiCY6kCQyVanegn/YKE85/a6q7FoBLitVWUOCEeWgxsRax2DNkN0EDvM8LYJNoK9gmfG/38L1hY5mMALwdQfPiHOzyEwvUOWGzU8ax9Xe/WZjYtunlw8FJZFXPAJvVrKYF7I7ByKjFcn37V2u578Hxw5vnoLVC17Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=murysiT0; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="murysiT0"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4954f5e8020so3782835e9.2
        for <linux-rdma@vger.kernel.org>; Sat, 18 Jul 2026 09:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784391984; x=1784996784; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CUxR31Xh85+TAm3j4nZpX4fvNBvJG7NmZg0i4br8yQ0=;
        b=murysiT0EDR3QJc8dX8UEXj7Qx7YqS5luH0QXYnY2LoVxmqXB/hDbwz0lDT6/bOMYY
         93zuVvzwfXfgn9G06TCyC/PW//Wya0zWw7DKa5gxIPyd+OOT7ul8Xosjv22ImWvth730
         70xJA+mdQ209vab47/Msu78SF9sXPHI1/YZ9Mt0wZMLAtc2d5p6sE7wg9FXRFWT7bb6X
         LzJVCw+yJZ9/ruXNJh6/96vHdWB3zWb+YKVwPqwrSSE89v7FVwnsywXJJGydbYlDTh/R
         +ZSMX7W0dYfO54nN7TOV3g6Jsf0udkt4L5Q0jRzxjR+ONr1vcKTJouI7LI6HQJHYQQi5
         92lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784391984; x=1784996784;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CUxR31Xh85+TAm3j4nZpX4fvNBvJG7NmZg0i4br8yQ0=;
        b=DggDLQ3Df99I2XtsI6ZzIGF23duqCkcz2zNuYabe+X8KpBCELsIMwvjF7b/1ZG2uxt
         +Md7pEyjJVM5lj+s6TsBuGkywq9ud0OMjt0OEhHPp+RdAO7OR8XRKz8D1zRFqqSIiA0P
         on5DaV1Q35ivavWf1xW1LvHCNNWTYOMoEk6tqW8rDdFKB/glOMjPL9Ghc6eE4ACUOla2
         PsDqqXuyrq2T0msh7gcxuHnhTJj9UVjdOH3uqvvjCft2Hghe3sFd3N9KIQR5Kiw0VI1U
         0YU2HVD5HYH9qtNT97tOjILTwLz7+cww3bLiloaB1R4niM25xknV4AvbT2OztKfoisuE
         ZP8A==
X-Forwarded-Encrypted: i=1; AHgh+Rr3q0EsMM74eWjiLIwJVK2xij9bFseMsCj1TPbmGSOvzmVd0jJbTJrr3fbO7RUEKu5jAvCacRXO/XT4@vger.kernel.org
X-Gm-Message-State: AOJu0YxvJu0rWDQXbssg3A0egPqzWpXDNZaJeqmEgdQ93E6hLytidCS9
	DCTMkVmM0lDDLpI4+hGivYleaG415Bm7zYCz1POEvEwHzDfCkNp65IQ6zdusJQ8C0Q==
X-Gm-Gg: AfdE7cldtd/uZb7ZAOgBg9rcOfNwmQMqvnWgjRLjSsLyZzerXBHBI/vPxnAEVGromUT
	keMLJrTS46TMoQ9XZyrueeZmzaXbPpKhxZvbILzfSsbHcm7IF8V0MWiAnD23/CwkX6dpLcjlYal
	sJk+S1ZykBwRIrB/UhhjlKddICvC7iRNgolex2W22SeqYktCXSQYsMylBjctkjiP1jp1HcAIJ8t
	OVot1ineNVppmMi2b81guq2sCG/nUvNo81ll35ePIvVrWIkuDlUWLt69FKqxGIWtblD2t0t1TRz
	B7PXHG+FxR4eXwnk7AvC1LQNW2Id0WAKdVxD3mqXZ9TkQ4ONj58zTWrHL/OWr6FUf7GYtaRnCFz
	fXuNMDvjltDcevO96twSDBZxWS3LLzKXyX2mzG9PMXy/0Fqz740cujzvSQ4cn2A==
X-Received: by 2002:a05:600c:1914:b0:492:7101:3d88 with SMTP id 5b1f17b1804b1-4954a402e03mr75887675e9.24.1784391983856;
        Sat, 18 Jul 2026 09:26:23 -0700 (PDT)
Received: from mf-00-01.. ([194.220.239.180])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954a2eddb8sm266444085e9.14.2026.07.18.09.26.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2026 09:26:23 -0700 (PDT)
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
Subject: [PATCH 4/6] md/raid1,raid10: keep REQ_NOMERGE on narrow_write_error() retry clones
Date: Sat, 18 Jul 2026 16:25:45 +0000
Message-ID: <20260718162547.448892-5-mykola@meshstor.io>
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
---
 drivers/md/raid1.c  | 3 +++
 drivers/md/raid10.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 57f64e890102..a30032321191 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2565,6 +2565,9 @@ static void narrow_write_error(struct r1bio *r1_bio, int i)
 		}
 
 		wbio->bi_opf = REQ_OP_WRITE;
+		/* Keep P2PDMA retry bios unmergeable, like the original */
+		if (md_bio_is_p2pdma(wbio))
+			wbio->bi_opf |= REQ_NOMERGE;
 		wbio->bi_iter.bi_sector = r1_bio->sector;
 		wbio->bi_iter.bi_size = r1_bio->sectors << 9;
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0a3cfdd3f5df..f7ef903a3d4e 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2831,6 +2831,9 @@ static void narrow_write_error(struct r10bio *r10_bio, int i)
 		wbio->bi_iter.bi_sector = wsector +
 				   choose_data_offset(r10_bio, rdev);
 		wbio->bi_opf = REQ_OP_WRITE;
+		/* Keep P2PDMA retry bios unmergeable, like the original */
+		if (md_bio_is_p2pdma(wbio))
+			wbio->bi_opf |= REQ_NOMERGE;
 
 		if (submit_bio_wait(wbio) &&
 		    !rdev_set_badblocks(rdev, wsector, sectors, 0)) {
-- 
2.43.0

