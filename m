Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BF1396B9A
	for <linux-rdma@vger.kernel.org>; Sun, 19 Jul 2026 10:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784458431; cv=none; b=i+sElJ7RwyOqs565z+FrY9ISPGnffxiSKJ7TYvQqFRHtD5XVT5ZiaSE2hFMYPnThhzYFigrIMyC6hOMig0Hyh1cXURivzjeQ50JtLF3HtFdFR8KT6LBwXgB/MBkr+CkMENvUsNqkj1hRWvQ1tvgnoYoKyqfdCQM+3VRDfkiLaQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784458431; c=relaxed/simple;
	bh=o6YIqEshj6myZ6eisq9eZWd8t50ZTZG9XsYkTI9G+RQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4qkyl8nSDiJV56oLbHT4skqYOhAR/KXZn3PkQ1dZUbI3QbnUU+c9RRq7zxlBmCijfNCGFvMeqp9uf8UrKdWDt5xbuj6ueqKK8xVSzJjVn1iyeX+/83r8SKbCtZ6AHQDmJ5aLG3mXrLYK3AZHHORPJ+vXx24IL595cyJ0POzyVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=IfcC6xLt; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="IfcC6xLt"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4921eed3fa2so71068875e9.0
        for <linux-rdma@vger.kernel.org>; Sun, 19 Jul 2026 03:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784458427; x=1785063227; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DOCIvHQcUURC426TdmWIVqFzZor35QO+zXIWNPhmEXE=;
        b=IfcC6xLtAwcE3RRJGTLRlOefYRRatTBnmYKWEyCj1Kw47wrLY7br5+s8+r6kIUsTBI
         nj+C0GiE928YbJHsi3aPjhUi4Y/2/+wXre1GpLQpVJbdaBFWx2/pzZX5GNr2vkMnLq0O
         EYBY6eyYgglN0InQSZA+TLgpLxbsnTc8zDA+lGvybcXsWidDr4qsH3qRR1pTG8a1pi1Z
         7eABjBU1Vm0F7UHf3dhjeh4gh5f0UPV4aeGh60oZnGAFuDn/DXOqNn0Y71iyxo0GKiwD
         QwVoqkuNXpb6ujBk25XTqe46w/Oxm9wJkz69O9DHdb99ZSwLyjlC5ISoLUaur9oDRYm1
         /tuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784458427; x=1785063227;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DOCIvHQcUURC426TdmWIVqFzZor35QO+zXIWNPhmEXE=;
        b=AuMyfMtwA/V54cT5dUG8W/Mx/gZ5gBpl7AxjpWz9EwhVAm4N2D2kemD22YOPdzOwbm
         f449JK6l13jR3GG6K9Jk0lbtZ6cz91IFxahNBcN7JaGcqB6jeNK3Y4WM4VgchywWeIfq
         ozJoornXvY6gmTdxJB1HAc8as2zYwueCy1SP4QanTXrw7WuKefkAQugQ/B7CIUan6/VS
         f18tMCeohmGHgBqMZZ7ra2PJkOFXRjeeYVn6WRDJ1pAgzB/6btK2fS0wMCz3Uc2QsVPV
         use1QMK0lQt7nYEx9VLrTf54SGqC5YbWUL2rXe1SZFxdU9gjF7PtLUumvDoC3vDwlgOS
         t6Ag==
X-Forwarded-Encrypted: i=1; AHgh+RrX0P/K47J9SY9HjRLgSPf1sZFJXuPc5xaS/tIjqE3tlpU1ivU0a3KmlbzdL0/4PjDQXWoSg3MX7+im@vger.kernel.org
X-Gm-Message-State: AOJu0YwCw7ep8XxvfaNE0bCn8o+i00xzQKj1psgYlU6iywt3XCKhBFPX
	lgrZmfQodPKhRBcqQ4xAemq/I2G+MrT2bVre42ww44tM+IU5O5ruR6pEM/tdBFSpUA==
X-Gm-Gg: AfdE7cmQEeqdjCtW6Rf7eIeorl3Q9jKuj7AWU2BSyuZVppLzHXwYHJ3z1W481OM9BKh
	T+ReU59tREos+2LR5e5ECRL0RhrjcLG0s0Fz/yKqbd5PfzemVHYfEjGDDyyiS8rd8nv4z+co+1v
	smTPVHAki5BzLLnFAS4DzsVlOlflU6UIrkg5PVVMdbw7d5kKBbmidzw1kGypFWqOT9/GWkp5Iul
	ml0E0K1RoyBw0+ay5p9SLudI1Vfe80PbNCVU/724imkSNLC/YPXAo+d/R0CoHjVqY56lXwiEhhv
	89MsNNpVz4mYjA8tu6GI66p5z2Wk9XM1DXpKN3iNX42yzefywzsGBX88+1hPH5eGNElKgYXXfm1
	cyxEFiuO4eXHbUdBq9zFgGGSVjCf28UvVS75fHS/R2xrxGiZXSirzE4GJNY1UyABnnw1h1ltQ
X-Received: by 2002:a05:600c:3143:b0:493:faf3:3ea5 with SMTP id 5b1f17b1804b1-4954a3d0925mr109816675e9.4.1784458427000;
        Sun, 19 Jul 2026 03:53:47 -0700 (PDT)
Received: from mf-00-01.. ([194.220.239.180])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954a2a24b6sm197679575e9.3.2026.07.19.03.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 03:53:46 -0700 (PDT)
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
Subject: [PATCH v2 6/7] md/raid1,raid10: skip futile retries on P2PDMA mapping failures
Date: Sun, 19 Jul 2026 10:53:26 +0000
Message-ID: <20260719105327.864949-7-mykola@meshstor.io>
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

Since commit 02666132403a ("md: propagate BLK_FEAT_PCI_P2PDMA from
member devices to RAID device") raid1 and raid10 arrays accept P2PDMA
(peer device memory) bios, and a member that cannot DMA-map the
peer's pages fails its leg bio with BLK_STS_TARGET (from
blk_dma_map_iter_start()).  That mapping failure is a property of the
peer-device/member pairing, not of the medium: re-submitting the same
peer pages to the same member cannot succeed, and there is nothing on
the disk to repair.  Routing it through the stock error machinery
misfires on every path:

 - narrow_write_error() re-issues the failed write in badblock-sized
   chunks, serializing hundreds of guaranteed-to-fail synchronous bios
   through raid1d/raid10d per failed write (256 for a 1 MiB write on
   4K logical blocks, 2048 on 512e).

 - the write-error handler sets WantReplacement, so a hot spare is
   pulled in, rebuilt onto, and the healthy member is then evicted by
   spare_active() -- and if the spare is also unreachable from the
   peer, the cycle consumes the next spare.

 - fix_read_error() probes members with kernel pages, starting with
   the failing member itself.  That probe succeeds (the member is
   healthy for host memory), so the routine rewrites nothing, records
   nothing, and logs nothing -- but each invocation costs a full
   freeze_array() quiesce and a tick of the read-error budget.  The
   budget exists to evict members whose medium keeps producing
   corrected errors; its hourly decay is sized for sporadic medium
   errors, while mapping failures are deterministic and arrive at I/O
   rate.  On an asymmetric PCIe topology a mixed host/P2P read
   workload charges 20 errors to the unreachable leg within a second
   and kicks a perfectly healthy member.

 - On FailFast members both paths short-circuit into md_error(), so a
   single unroutable peer-memory I/O evicts a healthy mirror outright.

Track P2PDMA masters with a new r1bio/r10bio state bit, set at
submission where bio_has_data() is still meaningful; a leg's mapping
failure is then "BLK_STS_TARGET and the master carries P2PDMA pages",
cheap to test on every completion path.  Handle it explicitly:

 - Writes: probe the whole range with one retry and record one bad
   range if it also fails.  BLK_STS_TARGET is also produced for
   device conditions that narrow_write_error()'s retry loop recovers
   from (e.g. NVME_SC_NS_NOT_READY and NVME_SC_CMD_INTERRUPTED via
   nvme_error_status()), and md cannot tell the two apart from
   bi_status alone, so it must not skip the retry outright.  A single
   whole-range probe observes the outcome instead of predicting it.
   WriteErrorSeen is still set (it gates the write-path badblocks
   consult), but WantReplacement is not: replacing a member cannot
   fix a topology property, and spending a spare on it destroys
   redundancy management for real failures.

 - Reads: mark the leg IO_BLOCKED so read_balance() picks another
   mirror, and skip the freeze/fix cycle and the budget charge.  The
   same TARGET ambiguity exists here, but a redirected read leaves
   nothing to fence, and fix_read_error()'s host-page probe fails
   the same way under e.g. NVME_SC_NS_NOT_READY -- charging the
   budget would evict a healthy member for a firmware activation
   window.  A genuinely failing member is still evicted via host
   reads, writes and BLK_STS_MEDIUM errors.  If no mirror can serve
   the read the master bio fails with EIO as before (md completes
   masters by Uptodate state, as for any failed mirror I/O), now
   without kicking healthy members on the way.

 - FailFast: a mapping failure is rejected at map time and never
   reaches the wire, so it is no evidence of device unreliability;
   don't let it trigger the FailFast md_error() -- the same reasoning
   commit f7b24c7b41f2 ("md/raid1,raid10: don't fail devices for
   invalid IO errors") applied to BLK_STS_INVAL.

raid10 replacement legs keep their stock policy: badblocks are never
recorded on a replacement, so failing it is the only outcome that
cannot leave a silent hole in a rebuilding replacement.

This belongs in the same release as the BLK_STS_TARGET restoration:
with that fix alone, an unroutable leg costs the retry storms and
the healthy-member evictions above.

Measured on QEMU q35 rigs (one CMB provider, two NVMe members),
8KiB peer-memory I/O, reads x90 under concurrent host reads:

  scenario       stock error machinery     with this patch
  asym reads     90/90 ok, healthy far     90/90 ok, no eviction,
                 leg kicked after ~20      no budget charge
  unreach reads  all EIO, one healthy      all EIO, no members
                 member kicked             kicked
  p2p TARGET     16 chunk retries from     1 whole-range probe,
  write          raid1d, then badblocks    same badblocks, master ok

A transient TARGET recovers through the single probe with no
badblocks recorded, and a mapping failure no longer trips FailFast
eviction while a genuine I/O error still does -- both verified on
the same rig.

Fixes: 02666132403a ("md: propagate BLK_FEAT_PCI_P2PDMA from member devices to RAID device")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
---
 drivers/md/raid1.c  | 56 +++++++++++++++++++++++++++++++-----
 drivers/md/raid1.h  |  2 ++
 drivers/md/raid10.c | 69 ++++++++++++++++++++++++++++++++++++++-------
 drivers/md/raid10.h |  2 ++
 4 files changed, 112 insertions(+), 17 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f562b6bd438b..61f635463475 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -483,12 +483,22 @@ static void raid1_end_write_request(struct bio *bio)
 	 * 'one mirror IO has finished' event handler:
 	 */
 	if (bio->bi_status && !ignore_error) {
+		/*
+		 * A P2PDMA mapping failure reflects the peer/member
+		 * pairing, not member health: don't pull in a spare
+		 * or trip FailFast for it.
+		 */
+		bool p2pdma_unmappable = bio->bi_status == BLK_STS_TARGET &&
+			test_bit(R1BIO_P2PDMA, &r1_bio->state);
+
 		set_bit(WriteErrorSeen,	&rdev->flags);
-		if (!test_and_set_bit(WantReplacement, &rdev->flags))
+		if (!p2pdma_unmappable &&
+		    !test_and_set_bit(WantReplacement, &rdev->flags))
 			set_bit(MD_RECOVERY_NEEDED, &
 				conf->mddev->recovery);
 
-		if (test_bit(FailFast, &rdev->flags) &&
+		if (!p2pdma_unmappable &&
+		    test_bit(FailFast, &rdev->flags) &&
 		    (bio->bi_opf & MD_FAILFAST) &&
 		    /* We never try FailFast to WriteMostly devices */
 		    !test_bit(WriteMostly, &rdev->flags)) {
@@ -1378,6 +1388,8 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	else
 		init_r1bio(r1_bio, mddev, bio);
 	r1_bio->sectors = max_read_sectors;
+	if (md_bio_is_p2pdma(bio))
+		set_bit(R1BIO_P2PDMA, &r1_bio->state);
 
 	/*
 	 * make_request() can abort the operation when read-ahead is being
@@ -1557,6 +1569,8 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 
 	r1_bio = alloc_r1bio(mddev, bio);
 	r1_bio->sectors = max_sectors;
+	if (md_bio_is_p2pdma(bio))
+		set_bit(R1BIO_P2PDMA, &r1_bio->state);
 
 	/* first select target devices under rcu_lock and
 	 * inc refcount on their rdev.  Record them by setting
@@ -2525,7 +2539,7 @@ static void fix_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 	}
 }
 
-static void narrow_write_error(struct r1bio *r1_bio, int i)
+static void narrow_write_error(struct r1bio *r1_bio, int i, bool coarse)
 {
 	struct mddev *mddev = r1_bio->mddev;
 	struct r1conf *conf = mddev->private;
@@ -2539,6 +2553,11 @@ static void narrow_write_error(struct r1bio *r1_bio, int i)
 	 * It is conceivable that the bio doesn't exactly align with
 	 * blocks.  We must handle this somehow.
 	 *
+	 * With 'coarse', retry the whole range as one bio and record
+	 * one bad range if it fails: for P2PDMA mapping failures,
+	 * which fail every block identically, while the single retry
+	 * still lets a cleared transient error recover.
+	 *
 	 * We currently own a reference on the rdev.
 	 */
 
@@ -2553,9 +2572,12 @@ static void narrow_write_error(struct r1bio *r1_bio, int i)
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
@@ -2636,8 +2658,18 @@ static void handle_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
 			 * narrow down and record precise write
 			 * errors.
 			 */
+			bool coarse = r1_bio->bios[m]->bi_status ==
+					BLK_STS_TARGET &&
+				test_bit(R1BIO_P2PDMA, &r1_bio->state);
+
 			fail = true;
-			narrow_write_error(r1_bio, m);
+			/*
+			 * A P2PDMA mapping failure fails the whole range
+			 * identically: probe it once (coarse) instead of
+			 * narrowing block by block. A transient TARGET
+			 * recovers via the probe with nothing recorded.
+			 */
+			narrow_write_error(r1_bio, m, coarse);
 			rdev_dec_pending(conf->mirrors[m].rdev,
 					 conf->mddev);
 		}
@@ -2664,6 +2696,9 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 {
 	struct md_rdev *rdev = conf->mirrors[r1_bio->read_disk].rdev;
 	struct bio *bio = r1_bio->bios[r1_bio->read_disk];
+	/* evaluate before the bio_put() below */
+	bool p2pdma_error = bio->bi_status == BLK_STS_TARGET &&
+		test_bit(R1BIO_P2PDMA, &r1_bio->state);
 	struct mddev *mddev = conf->mddev;
 	sector_t sector;
 
@@ -2683,6 +2718,13 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 	 */
 	if (mddev->ro) {
 		r1_bio->bios[r1_bio->read_disk] = IO_BLOCKED;
+	} else if (p2pdma_error) {
+		/*
+		 * The peer cannot reach this member; nothing on the
+		 * medium to fix. Skip the read-error budget and
+		 * FailFast, just keep this leg out of the retry.
+		 */
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
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index f7ef903a3d4e..144d07b6029c 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -482,13 +482,24 @@ static void raid10_end_write_request(struct bio *bio)
 			 */
 			md_error(rdev->mddev, rdev);
 		else {
+			/*
+			 * A P2PDMA mapping failure reflects the
+			 * peer/member pairing, not member health: don't
+			 * pull in a spare or trip FailFast for it.
+			 */
+			bool p2pdma_unmappable =
+				bio->bi_status == BLK_STS_TARGET &&
+				test_bit(R10BIO_P2PDMA, &r10_bio->state);
+
 			set_bit(WriteErrorSeen,	&rdev->flags);
-			if (!test_and_set_bit(WantReplacement, &rdev->flags))
+			if (!p2pdma_unmappable &&
+			    !test_and_set_bit(WantReplacement, &rdev->flags))
 				set_bit(MD_RECOVERY_NEEDED,
 					&rdev->mddev->recovery);
 
 			dec_rdev = 0;
-			if (test_bit(FailFast, &rdev->flags) &&
+			if (!p2pdma_unmappable &&
+			    test_bit(FailFast, &rdev->flags) &&
 			    (bio->bi_opf & MD_FAILFAST)) {
 				md_error(rdev->mddev, rdev);
 			}
@@ -1170,6 +1181,9 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	 */
 	gfp_t gfp = err_path ? (GFP_NOIO | __GFP_HIGH) : GFP_NOIO;
 
+	if (md_bio_is_p2pdma(bio))
+		set_bit(R10BIO_P2PDMA, &r10_bio->state);
+
 	if (slot >= 0 && r10_bio->devs[slot].rdev) {
 		/*
 		 * This is an error retry, but we cannot
@@ -1357,6 +1371,9 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 	sector_t sectors;
 	int max_sectors;
 
+	if (md_bio_is_p2pdma(bio))
+		set_bit(R10BIO_P2PDMA, &r10_bio->state);
+
 	if ((mddev_is_clustered(mddev) &&
 	     mddev->cluster_ops->area_resyncing(mddev, WRITE,
 						bio->bi_iter.bi_sector,
@@ -2786,7 +2803,7 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 	}
 }
 
-static void narrow_write_error(struct r10bio *r10_bio, int i)
+static void narrow_write_error(struct r10bio *r10_bio, int i, bool coarse)
 {
 	struct bio *bio = r10_bio->master_bio;
 	struct mddev *mddev = r10_bio->mddev;
@@ -2800,6 +2817,11 @@ static void narrow_write_error(struct r10bio *r10_bio, int i)
 	 * It is conceivable that the bio doesn't exactly align with
 	 * blocks.  We must handle this.
 	 *
+	 * With 'coarse', retry the whole range as one bio and record
+	 * one bad range if it fails: for P2PDMA mapping failures,
+	 * which fail every block identically, while the single retry
+	 * still lets a cleared transient error recover.
+	 *
 	 * We currently own a reference to the rdev.
 	 */
 
@@ -2814,9 +2836,12 @@ static void narrow_write_error(struct r10bio *r10_bio, int i)
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
@@ -2856,6 +2881,7 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 {
 	int slot = r10_bio->read_slot;
 	struct bio *bio;
+	bool p2pdma_error;
 	struct r10conf *conf = mddev->private;
 	struct md_rdev *rdev = r10_bio->devs[slot].rdev;
 
@@ -2868,17 +2894,28 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
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
+		/*
+		 * The peer cannot reach this member; nothing on the
+		 * medium to fix. Skip the read-error budget and
+		 * FailFast, just keep this leg out of the retry.
+		 */
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
@@ -2947,8 +2984,20 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
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
+				/*
+				 * A P2PDMA mapping failure fails the whole
+				 * range identically: probe it once (coarse)
+				 * instead of narrowing block by block.  A
+				 * transient TARGET recovers via the probe
+				 * with nothing recorded.
+				 */
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
2.43.0

