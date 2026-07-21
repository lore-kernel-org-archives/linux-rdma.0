Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC7C47044D
	for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 17:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655980; cv=none; b=GpboJCGkRDBwDp6chnj+13c70IQ2WnJUVXJCW/6bHqtBQSZOJsF6MxQ3WZAH3GgAkftwOymFuw8u4LmK6lzBSuzuhZhmLsqsirEH+Pj4Uk1k2hoB4rJ23L9Qhd5NMbVyMSd+sJQhyQins/4zc6fKQc2tcOXvkm5MpliR7OlkEbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655980; c=relaxed/simple;
	bh=8lwKlp75z1YvnrOncarPX7oWeDqy+5JbGTS5C7xvC9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQkwwHWdeN9hZjSbUASJjNJvWhXbeIliP0zLt6P36Pgj3l2g0u44RaDJQc+lPKhS0r+DGFLlxviCmMoZy45ntW4VXf4iX//4513FaGEFJBwusOSajoxSqW+OCTZOyWCT1i/FQaNGdcLOWDwX0+yEdINAJDY/Z8AlQiF3oCunhug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=rOLePR4m; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="rOLePR4m"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4956242332dso18874995e9.2
        for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 10:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784655974; x=1785260774; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8dj3uaA5KIKi+y4TtBPBIa/9LhAWdxcRprl1F1cYW18=;
        b=rOLePR4mOWPSi7QcH7lsd3oNwTyAWc05lQ0Y9ypNMaFsobQvfJ9SrHf+mCx+i4V1T4
         sslu0EyK1Qlljo45Y9aSF/N6PUPDkth/yTCz4ZAMPeXi7d+6EukfkgaJlSRuE48S452y
         mrlqd6qWBaH2gd6yn1BEyB1XffYKRkW1lCoSIpj7QOK3WhpwaTuv9y21S7q3/yob3o88
         qNmpdGl9eQ2iGA1NDQscmbP67+ZcSdoy8MIa4fbcN8Ry10fWXB7qNp9PgKoORQsqM8b+
         tAjlNbOd7/z3OMAHC9RfFCdjUzGP6T13fE0ZYMq0udf3QH528apkXkQ5FIRUZ+ebjPX3
         tqjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784655974; x=1785260774;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8dj3uaA5KIKi+y4TtBPBIa/9LhAWdxcRprl1F1cYW18=;
        b=Jq4dm7DnkiNQAkKAqiwxWRyoDEhZVq+smcg4k+FhduQwkHKgOhdpbMTZxyjabgJPKP
         AmFgzdgJMpsdbAxx9FDKg3aWi7CyYvN7WBeEdlgH0YJRb5nbzYc2hjsa/ei9gMUxdC34
         G9rw0IoN4bXwdxHaznG5R9BB7Wyqk4lFdHvJ650kut+809HDn/kdAwpaMSUrf/07Db/j
         ijNNa1/72M9beWgLVi4kewgwsLyqlJNaSG/a2HO02EqR3s9pmvPmxPUWJnTxEfVXR9bX
         8z9NLz+aA0N5+084nMN2LBjcZ6vtf2zIYSvH8pS95HhW2zc6tmDG4cTO/GBvofPWWSRg
         T9fQ==
X-Forwarded-Encrypted: i=1; AHgh+RrIUyOEHQc0qyRRUgzFZbVBUhyE+UyMVrIhLvxOrbuDacrKk7z3aabnOOH1tLU7bhqkJt+vMpchLF0l@vger.kernel.org
X-Gm-Message-State: AOJu0YxcM/h/CJaMvLpmNnsGPZ0aHeZ/cHdsPwJMeP6Sh3ONC7kGnbqi
	e2ZmjFzk+lk3sPvrL5iyGSaRuKxJRawYtK7KbsRYgetq3zznI0h8gbJHl3qyj1rTgg==
X-Gm-Gg: AfdE7cnqb1ING/bHyDGwoGb4wZamUhh+S9ueB5FPEKCf8eHpOQXlLth6IzNL9Dk79oI
	xwjGlOdL4wh85P5XSUbUG1aiCs3hKk8s+mRoLs1dwEPwsz/vIQxgIi5UcQgVpX4A2RFGOnFGIlg
	xNmLxAK4w/5mXqLfBIqXsbgNsXns6q5tR++ZL0HN30yVaVaIbLjopCtlwAjTccQ/3CG/U2rACRm
	eKGIGueZiDoQpSDBCa6KzrSubmR/ofCiwNAXTnu7hYgh55u6CTh2khqFNroxXW7gzJ7i1+vDkYu
	03jxXJXd+QXSAH2BUyLEKXaFZ4p782hTmnFMvC8tuuBNqP1mugaUQbEiCVhdwjG/MUORqLU3AjD
	ZFYD0m4lSThdwGxSItDrYzfi//x5qTbEP/Jq0l7Vt8hwX0Lfh/R/KqBEEON2t45GJZWhUoRyv7A
	x46l8ymwxJ7Y1KrrUT/A5blReCp8S4rPHH87gZtOk3EFMrv40=
X-Received: by 2002:a05:600c:1914:b0:495:4598:6e13 with SMTP id 5b1f17b1804b1-4954a3f5271mr199481405e9.17.1784655974444;
        Tue, 21 Jul 2026 10:46:14 -0700 (PDT)
Received: from ai-pc ([46.172.241.174])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63eddd27sm40860513f8f.28.2026.07.21.10.46.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 10:46:13 -0700 (PDT)
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
Subject: [PATCH v3 7/8] md/raid10: skip futile retries on P2PDMA mapping failures
Date: Tue, 21 Jul 2026 19:45:01 +0200
Message-ID: <20260721174502.111503-8-mykola@meshstor.io>
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

Same handling as the preceding raid1 commit: flag P2PDMA master
bios with R10BIO_P2PDMA at submission; on a BLK_STS_TARGET leg
failure retry writes once as a whole range, don't set
WantReplacement, block the leg for reads without charging the
read-error budget, don't trip FailFast.

Replacement legs keep the stock fail-on-write-error policy:
badblocks are never recorded on a replacement, so failing it is
the only outcome that cannot leave a silent hole in a rebuild.

Fixes: 02666132403a ("md: propagate BLK_FEAT_PCI_P2PDMA from member devices to RAID device")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
---
 drivers/md/raid10.c | 63 ++++++++++++++++++++++++++++++++++-----------
 drivers/md/raid10.h |  2 ++
 2 files changed, 50 insertions(+), 15 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index f7ef903a3d4e..4c3da50250a5 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -482,15 +482,23 @@ static void raid10_end_write_request(struct bio *bio)
 			 */
 			md_error(rdev->mddev, rdev);
 		else {
-			set_bit(WriteErrorSeen,	&rdev->flags);
-			if (!test_and_set_bit(WantReplacement, &rdev->flags))
-				set_bit(MD_RECOVERY_NEEDED,
-					&rdev->mddev->recovery);
+			/* Peer/member pairing failure, not member health. */
+			bool p2pdma_unmappable =
+				bio->bi_status == BLK_STS_TARGET &&
+				test_bit(R10BIO_P2PDMA, &r10_bio->state);
 
+			set_bit(WriteErrorSeen,	&rdev->flags);
 			dec_rdev = 0;
-			if (test_bit(FailFast, &rdev->flags) &&
-			    (bio->bi_opf & MD_FAILFAST)) {
-				md_error(rdev->mddev, rdev);
+			if (!p2pdma_unmappable) {
+				if (!test_and_set_bit(WantReplacement,
+						      &rdev->flags))
+					set_bit(MD_RECOVERY_NEEDED,
+						&rdev->mddev->recovery);
+
+				if (test_bit(FailFast, &rdev->flags) &&
+				    (bio->bi_opf & MD_FAILFAST)) {
+					md_error(rdev->mddev, rdev);
+				}
 			}
 
 			/*
@@ -1170,6 +1178,9 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	 */
 	gfp_t gfp = err_path ? (GFP_NOIO | __GFP_HIGH) : GFP_NOIO;
 
+	if (md_bio_is_p2pdma(bio))
+		set_bit(R10BIO_P2PDMA, &r10_bio->state);
+
 	if (slot >= 0 && r10_bio->devs[slot].rdev) {
 		/*
 		 * This is an error retry, but we cannot
@@ -1357,6 +1368,9 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 	sector_t sectors;
 	int max_sectors;
 
+	if (md_bio_is_p2pdma(bio))
+		set_bit(R10BIO_P2PDMA, &r10_bio->state);
+
 	if ((mddev_is_clustered(mddev) &&
 	     mddev->cluster_ops->area_resyncing(mddev, WRITE,
 						bio->bi_iter.bi_sector,
@@ -2786,7 +2800,7 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 	}
 }
 
-static void narrow_write_error(struct r10bio *r10_bio, int i)
+static void narrow_write_error(struct r10bio *r10_bio, int i, bool coarse)
 {
 	struct bio *bio = r10_bio->master_bio;
 	struct mddev *mddev = r10_bio->mddev;
@@ -2800,6 +2814,9 @@ static void narrow_write_error(struct r10bio *r10_bio, int i)
 	 * It is conceivable that the bio doesn't exactly align with
 	 * blocks.  We must handle this.
 	 *
+	 * With 'coarse', retry the whole range as one bio: P2PDMA
+	 * mapping failures fail every block identically.
+	 *
 	 * We currently own a reference to the rdev.
 	 */
 
@@ -2814,9 +2831,12 @@ static void narrow_write_error(struct r10bio *r10_bio, int i)
 		block_sectors = roundup(1 << rdev->badblocks.shift, lbs);
 
 	sector = r10_bio->sector;
-	sectors = ((r10_bio->sector + block_sectors)
-		   & ~(sector_t)(block_sectors - 1))
-		- sector;
+	if (coarse)
+		sectors = sect_to_write;
+	else
+		sectors = ((r10_bio->sector + block_sectors)
+			   & ~(sector_t)(block_sectors - 1))
+			- sector;
 
 	while (sect_to_write) {
 		struct bio *wbio;
@@ -2856,6 +2876,7 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 {
 	int slot = r10_bio->read_slot;
 	struct bio *bio;
+	bool p2pdma_error;
 	struct r10conf *conf = mddev->private;
 	struct md_rdev *rdev = r10_bio->devs[slot].rdev;
 
@@ -2868,17 +2889,24 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 	 * frozen.
 	 */
 	bio = r10_bio->devs[slot].bio;
+	/* evaluate before the bio_put() below */
+	p2pdma_error = bio->bi_status == BLK_STS_TARGET &&
+		test_bit(R10BIO_P2PDMA, &r10_bio->state);
 	bio_put(bio);
 	r10_bio->devs[slot].bio = NULL;
 
 	if (mddev->ro)
 		r10_bio->devs[slot].bio = IO_BLOCKED;
-	else if (!test_bit(FailFast, &rdev->flags)) {
+	else if (p2pdma_error) {
+		/* Peer can't reach this member: just redirect the read. */
+		r10_bio->devs[slot].bio = IO_BLOCKED;
+	} else if (test_bit(FailFast, &rdev->flags)) {
+		md_error(mddev, rdev);
+	} else {
 		freeze_array(conf, 1);
 		fix_read_error(conf, mddev, r10_bio);
 		unfreeze_array(conf);
-	} else
-		md_error(mddev, rdev);
+	}
 
 	rdev_dec_pending(rdev, mddev);
 	r10_bio->state = 0;
@@ -2947,8 +2975,13 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 					r10_bio->sectors, 0);
 				rdev_dec_pending(rdev, conf->mddev);
 			} else if (bio != NULL && bio->bi_status) {
+				bool coarse = bio->bi_status ==
+						BLK_STS_TARGET &&
+					test_bit(R10BIO_P2PDMA,
+						 &r10_bio->state);
+
 				fail = true;
-				narrow_write_error(r10_bio, m);
+				narrow_write_error(r10_bio, m, coarse);
 				rdev_dec_pending(rdev, conf->mddev);
 			}
 			bio = r10_bio->devs[m].repl_bio;
diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
index ec79d87fb92f..a2e1554f77db 100644
--- a/drivers/md/raid10.h
+++ b/drivers/md/raid10.h
@@ -174,6 +174,8 @@ enum r10bio_state {
 	R10BIO_Previous,
 /* failfast devices did receive failfast requests. */
 	R10BIO_FailFast,
+/* the master bio carries PCI P2PDMA (peer device memory) pages */
+	R10BIO_P2PDMA,
 	R10BIO_Discard,
 };
 #endif
-- 
2.52.0

