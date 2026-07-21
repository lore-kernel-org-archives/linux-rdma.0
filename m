Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7AA470424
	for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 17:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655976; cv=none; b=RGnrP+1wumtXwAgJ8ot0Jp4xSu7PwfgG9JtoRUix2T7vE9+JKBKNtLYVcXQfU8GhlcZZlCosSr89TO5enEOHPSeH75/wIMbA3sQe5iKvNLjeXiw0Yd1yXI40HhnhnArOXH293J7dTMqfl0ttiXu7e4etGdVwRk9oRSDOG/Ra7S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655976; c=relaxed/simple;
	bh=7tCnvUVxAg7gfBg1vhZ0oYTg4SOqF5x+kKhvNqafOrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VP37Of3QtHxupP42Y0lmXMVfSE4CjMmRn6oksFU8ksU7C9n7HBMM9xHjkuCepsgjy5WYNeJkYixircjvcKfqsLUWV7yN99dlx1OvcujF3j/Xo5ketU7eHxv+wJiwb7VpzN6zlWX29e+7RSVcFquL7Tlh6i3eJ7UHgbJpQIS4vLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=D62pSTFs; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="D62pSTFs"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-47f3b39f2a1so5945200f8f.2
        for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 10:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784655972; x=1785260772; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RI/ofRS9U+6ig5kLdN1LCndM4I9pFM5i9E2zRYc1mtk=;
        b=D62pSTFs7Im3Odtzxs7tM+9rPr5cT1fZr9f6DzFAlgVIGNAA1VY6CIW1WeJCKs7rMs
         NRwaLOyeE5y1uO5MeCgDfEjgJzQ+xCNDOc5fjvfn/6tYYtdZ2CWN49/+EvWKC5w8YY4D
         M0gfTF8GZ/kv7P1yOY+P3PT0olPJ9gjCCBXylV4k4TPeD0aP/zQYj46UYasw5FT1yJfg
         NKTxgungizusLj/huwqURpAa6qE2fyWLOu75vgKF9Mk9v5559vbDg8sLpj81ARz4oc0h
         o8xTpLg4zCjtAw7hW2SqpPMxtUNr9X1Lc8nxdjM6qcm/Uq0kYSvDpSutoUO1nJZ2iwY3
         EnQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784655972; x=1785260772;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RI/ofRS9U+6ig5kLdN1LCndM4I9pFM5i9E2zRYc1mtk=;
        b=pwW1k7TnJa8CHXi3kngqbibiMEKjDits9Vt5Z/hc3VppBoWfZok8KK1APawYL42kIO
         b5bD+praqMlEiyMffvtsttb1QqL8zd6F4nlZx+X2olPUfs1rixXmhFdSd7j7xqvgLVUU
         tB+YQk3PJ9oHq50u36pg0VUVG/vMr5Gki6xm7yoyWzc2JN/AgcmtYOCpAkN6F6ths8qA
         prRQHDLTeNeCKJtwCvBJofrRt5WHjTRlEORRUNPNlRaGIoEpAkL8WBJ11tkakGK7vNE2
         FNKhR/c42KAjK6NbfY28GV1owJROjUYnRiU5U0IjPam5EdrXQC0heJD2kV1RkIKcLKsL
         wMXQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp+/A5gGSb014sTHnnybaicVaX0kZ6hTa4X5XeDqA3w2iYmxG+I1TuzoMg1SeZ6KR5kkvZBe7xfgJz+@vger.kernel.org
X-Gm-Message-State: AOJu0Yzdf+e2Hqednvg+RCp4fKA5gc7mzEWDQCZVU/KXwhhgfPE27V30
	BMFM6SGhD/jmnG8741frLyOnMvzcW04p8nP7WXKehP5BkEwhzLRb/zzF7sks1vdDVg==
X-Gm-Gg: AR+sD10qXbxUFAJTICvzzUCbNaSgXdLYAqMKQ4whgBpX1K1/UgmczGIWildUCY+Jxcf
	VLZCqm6gnpa1mi/WLR7H7pBs5J3EjhqLl/lUuaa/k74HItxXXcOQyBms+xfkM3PLa86HAvMGxwH
	FZQ+8xha6cXCpOnsbXW5LBVtry2jfFRo0ajDEMolUUQaRoKgZsDS0ODZv2wGmRF+WeP+otz8GZt
	5VKCTmz3sQQVh1bEfxQVL7Nd84D0lGiEWgx0vYJX8SiZH4QThzt7c5K1nmvLbmZ7i3GK/iPOGZu
	lQg9iMqXs6mbZapb2ynvRc7iiVNL4iQJXStse88YetpuNL7/RX9JYpxLGJ9B5jZDMRudUamg2qc
	rFK2NTjsTDy1LiYnwztqJyXI+U4De+XmyCMnXEeB0a7yzyt0wnH+UwFSOxw6mqu+tCGyOSuyzT1
	90Br3PnEC3XH4PqclLsdvyCBpaxn9UwFd4ryMp+61EFsfDu0Y=
X-Received: by 2002:a05:6000:41e1:b0:47f:6d9a:d7a6 with SMTP id ffacd0b85a97d-47f6d9ad948mr17562857f8f.25.1784655972302;
        Tue, 21 Jul 2026 10:46:12 -0700 (PDT)
Received: from ai-pc ([46.172.241.174])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63eddd27sm40860513f8f.28.2026.07.21.10.46.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 10:46:11 -0700 (PDT)
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
Subject: [PATCH v3 6/8] md/raid1: skip futile retries on P2PDMA mapping failures
Date: Tue, 21 Jul 2026 19:45:00 +0200
Message-ID: <20260721174502.111503-7-mykola@meshstor.io>
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

A member that cannot DMA-map peer memory fails the leg bio with
BLK_STS_TARGET.  The failure is a property of the peer/member
pairing -- retrying the same pages against the same member cannot
succeed, and there is nothing on the medium to repair -- but the
error machinery treats it as a medium error: narrow_write_error()
grinds through hundreds of doomed chunk retries per write,
WantReplacement burns a spare and evicts the healthy member,
fix_read_error()'s host-page probe "succeeds" so mixed host/P2P
reads charge the read-error budget until a healthy member is
kicked (~1s in testing), and FailFast evicts on the first
unroutable I/O.

Flag P2PDMA master bios with a new R1BIO_P2PDMA state bit at
submission.  On a BLK_STS_TARGET leg failure for a flagged bio:
retry writes once as a single whole range, recording one bad range
if that also fails (TARGET can be a transient device condition,
e.g. NVME_SC_NS_NOT_READY, so the retry is not skipped outright);
don't set WantReplacement; mark failed read legs IO_BLOCKED without
charging the read-error budget; and don't treat the failure as
FailFast evidence -- the request never reached the wire -- as
commit f7b24c7b41f2 ("md/raid1,raid10: don't fail devices for
invalid IO errors") did for BLK_STS_INVAL.

Fixes: 02666132403a ("md: propagate BLK_FEAT_PCI_P2PDMA from member devices to RAID device")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
---
 drivers/md/raid1.c | 54 ++++++++++++++++++++++++++++++++++------------
 drivers/md/raid1.h |  2 ++
 2 files changed, 42 insertions(+), 14 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 16b7465c233a..6334032c4bb8 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -483,16 +483,22 @@ static void raid1_end_write_request(struct bio *bio)
 	 * 'one mirror IO has finished' event handler:
 	 */
 	if (bio->bi_status && !ignore_error) {
-		set_bit(WriteErrorSeen,	&rdev->flags);
-		if (!test_and_set_bit(WantReplacement, &rdev->flags))
-			set_bit(MD_RECOVERY_NEEDED, &
-				conf->mddev->recovery);
+		/* Peer/member pairing failure, not member health. */
+		bool p2pdma_unmappable = bio->bi_status == BLK_STS_TARGET &&
+			test_bit(R1BIO_P2PDMA, &r1_bio->state);
 
-		if (test_bit(FailFast, &rdev->flags) &&
-		    (bio->bi_opf & MD_FAILFAST) &&
-		    /* We never try FailFast to WriteMostly devices */
-		    !test_bit(WriteMostly, &rdev->flags)) {
-			md_error(r1_bio->mddev, rdev);
+		set_bit(WriteErrorSeen,	&rdev->flags);
+		if (!p2pdma_unmappable) {
+			if (!test_and_set_bit(WantReplacement, &rdev->flags))
+				set_bit(MD_RECOVERY_NEEDED,
+					&conf->mddev->recovery);
+
+			if (test_bit(FailFast, &rdev->flags) &&
+			    (bio->bi_opf & MD_FAILFAST) &&
+			    /* We never try FailFast to WriteMostly devices */
+			    !test_bit(WriteMostly, &rdev->flags)) {
+				md_error(r1_bio->mddev, rdev);
+			}
 		}
 
 		/*
@@ -1378,6 +1384,8 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	else
 		init_r1bio(r1_bio, mddev, bio);
 	r1_bio->sectors = max_read_sectors;
+	if (md_bio_is_p2pdma(bio))
+		set_bit(R1BIO_P2PDMA, &r1_bio->state);
 
 	/*
 	 * make_request() can abort the operation when read-ahead is being
@@ -1557,6 +1565,8 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 
 	r1_bio = alloc_r1bio(mddev, bio);
 	r1_bio->sectors = max_sectors;
+	if (md_bio_is_p2pdma(bio))
+		set_bit(R1BIO_P2PDMA, &r1_bio->state);
 
 	/* first select target devices under rcu_lock and
 	 * inc refcount on their rdev.  Record them by setting
@@ -2522,7 +2532,7 @@ static void fix_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 	}
 }
 
-static void narrow_write_error(struct r1bio *r1_bio, int i)
+static void narrow_write_error(struct r1bio *r1_bio, int i, bool coarse)
 {
 	struct mddev *mddev = r1_bio->mddev;
 	struct r1conf *conf = mddev->private;
@@ -2536,6 +2546,9 @@ static void narrow_write_error(struct r1bio *r1_bio, int i)
 	 * It is conceivable that the bio doesn't exactly align with
 	 * blocks.  We must handle this somehow.
 	 *
+	 * With 'coarse', retry the whole range as one bio: P2PDMA
+	 * mapping failures fail every block identically.
+	 *
 	 * We currently own a reference on the rdev.
 	 */
 
@@ -2550,9 +2563,12 @@ static void narrow_write_error(struct r1bio *r1_bio, int i)
 		block_sectors = roundup(1 << rdev->badblocks.shift, lbs);
 
 	sector = r1_bio->sector;
-	sectors = ((sector + block_sectors)
-		   & ~(sector_t)(block_sectors - 1))
-		- sector;
+	if (coarse)
+		sectors = sect_to_write;
+	else
+		sectors = ((sector + block_sectors)
+			   & ~(sector_t)(block_sectors - 1))
+			- sector;
 
 	while (sect_to_write) {
 		struct bio *wbio;
@@ -2633,8 +2649,12 @@ static void handle_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
 			 * narrow down and record precise write
 			 * errors.
 			 */
+			bool coarse = r1_bio->bios[m]->bi_status ==
+					BLK_STS_TARGET &&
+				test_bit(R1BIO_P2PDMA, &r1_bio->state);
+
 			fail = true;
-			narrow_write_error(r1_bio, m);
+			narrow_write_error(r1_bio, m, coarse);
 			rdev_dec_pending(conf->mirrors[m].rdev,
 					 conf->mddev);
 		}
@@ -2661,6 +2681,9 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 {
 	struct md_rdev *rdev = conf->mirrors[r1_bio->read_disk].rdev;
 	struct bio *bio = r1_bio->bios[r1_bio->read_disk];
+	/* evaluate before the bio_put() below */
+	bool p2pdma_error = bio->bi_status == BLK_STS_TARGET &&
+		test_bit(R1BIO_P2PDMA, &r1_bio->state);
 	struct mddev *mddev = conf->mddev;
 	sector_t sector;
 
@@ -2680,6 +2703,9 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 	 */
 	if (mddev->ro) {
 		r1_bio->bios[r1_bio->read_disk] = IO_BLOCKED;
+	} else if (p2pdma_error) {
+		/* Peer can't reach this member: just redirect the read. */
+		r1_bio->bios[r1_bio->read_disk] = IO_BLOCKED;
 	} else if (test_bit(FailFast, &rdev->flags)) {
 		md_error(mddev, rdev);
 	} else {
diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
index c98d43a7ae99..61b788a99d14 100644
--- a/drivers/md/raid1.h
+++ b/drivers/md/raid1.h
@@ -184,6 +184,8 @@ enum r1bio_state {
 	R1BIO_MadeGood,
 	R1BIO_WriteError,
 	R1BIO_FailFast,
+/* the master bio carries PCI P2PDMA (peer device memory) pages */
+	R1BIO_P2PDMA,
 };
 
 static inline int sector_to_idx(sector_t sector)
-- 
2.52.0

