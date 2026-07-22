Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898CF39A812
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 18:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784746766; cv=none; b=ogk6E59iwT/qiHmEQGpiqW/GzIZbomGzQZ8afsgpgMknF5RZCwch/mbf55KXnV1yKCG8IxTpeBLFdCKPsvVty+kcOPn5uVYBEdgmuMRFa/zcC/gXIW6HZ2vu1Oagwt5uF6Fi6tGQSiC3yINiKNMa8JX9lTGgS4UCvdk7UU0wFIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784746766; c=relaxed/simple;
	bh=txEBr1MoU1y1mkJ/HHXFbnluQk+VRueyunkBGuSqgtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b3gASgNWvy7BoWlrdy9x9q7Zt+n4CC2D7qpslZcBD3HVoU86q6ovWhCI4aBiLO4TKol3c+rDQ0XTNYllxk/KXV2VBULZqFX48zbovojGR9R4Dkfy35b0/gHxMn93yXuN5gfgtGdrMNURzvQx96n3o88C+9g1QJt1ml2KPcaT/ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=H1wkgX05; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="H1wkgX05"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-495437bb891so54356965e9.1
        for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 11:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784746754; x=1785351554; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XGlz7sxVhffzS6r4ROT44BH0oh58kUxNrwba0cAE+h4=;
        b=H1wkgX05RHJTUWYprRsuGf3VDGrnWdopU+EKgLmswxyGXuyAtX/JXr2Yuh5N2t/JOX
         Yh0EiRSzmOI3gHd3cQSaQLV4wPbLXSMrUo6vOhcssWWslM3ZDyZ1hGSA0kl7iRZpHciE
         +It5bRwc0temO8hUL1zEx9DO8Xq9U/LuG2bJFf1g3aI1PvTOOmamJeDG6WDSK9qarsa1
         4X43Tmrn6PTMlZ6pRckVGJ+DyfLyU9DVNtTgFFMEZ3ol3K5RJAtTOxOV8K8PxW8kXID+
         KARFNKDueTbGrLuXCiQl+vHl4HwyLNw8FyO8YBJRE8cY03Jz0ixbLwVZsByBskLVGcAN
         Pf5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784746754; x=1785351554;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XGlz7sxVhffzS6r4ROT44BH0oh58kUxNrwba0cAE+h4=;
        b=KtI/1X1ruKmIXPi/7kpdpP77LEPnbGDdSVvL5CD9OLMhS2h1kgz2MqOvBBP5JQY1rB
         U3CjuO4V0P66V770Gutf+OV2BCDg9ORZ2ETTFWfl2fxak0JRmxU87BY5A8aXBiRKUEPV
         /CP+o0iMvdRepo2KqW2ri3B9/z8x08SZaPocZ8E37S/iAXHKvDqfziaADCD6geU8JNV7
         MSzWG1C2NLBaddBCzkD4RjpecFH4t/Sb00iyzMbTz9+2kuTVt+jLl/E5AK7PN2pmbcbk
         mwPLuufjDnzowaJ3RJ+r5KlGcUA11CqtQYdxkWdmBzUBmNh44oc5eIAEFmTeysi3BQTg
         gV2Q==
X-Forwarded-Encrypted: i=1; AHgh+Rrpocw6/OVRDnY/Utgl9cDVB16lrGz1igG+nVRyH4ffig5188KGDkzJmmaKdGk1uXjHnTfTX8NhunT7@vger.kernel.org
X-Gm-Message-State: AOJu0Ywrb3M8NJA9C6bRYkC1Ak2TxGJ6W4wD0jnFB2Ot6B1UPRnB6mtg
	7/bLtGkpz25B9nAkSWzsIFLaUWwcggJlm9THYxMKxabSD2tKMKu67TSTf6JVs07j3Q==
X-Gm-Gg: AR+sD11z5tSoGnlIVrbEwwHH1VCuxYciPktnOswL6EJhTiiDHESly3mTZiBbNygVG/w
	pK/jdCk2vZrVSyUkw1zsvTw2kvudFs3Zpef4fjqxaimxydPOc4hHhd/2ypAQYvMQ2DnL4N+5zHZ
	p/avl4ypIatLYrC3xX/H2/nSRLzGcOBQw84HMqB5HW2WLSKSHEowcFUU9iArxxgg5M89hEvqZ+N
	4ZqTPTB6RKidrKhra+6QyLpCbHv65UaijtMZWGMx1o1yb302gwlKqk+BFfjfFN3m/EI/H66Fnhi
	1SSKNhDAPSFu4BovVvHwCsTc0vRRUa1s38wFJpfy0iS4cAk/jCaGTbwG8IPJGTKg3vanGqXk07+
	7PdXAHk4wGz/wMDlfqIJGb1rgdT8qKp+sP3PJW+wwZkR33ZYPDhAwqGYmR5mqD0LrM7orUCiW5+
	zzLQ5++HsMvaWSqI23UjhIPbOk7d/eCc/vPPJV6n/Fn+p3zfc=
X-Received: by 2002:a05:600c:1d23:b0:495:7016:b875 with SMTP id 5b1f17b1804b1-4957016c17dmr25808785e9.13.1784746753845;
        Wed, 22 Jul 2026 11:59:13 -0700 (PDT)
Received: from ai-pc ([46.172.241.174])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-495730353d9sm13740055e9.12.2026.07.22.11.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 11:59:13 -0700 (PDT)
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
Subject: [PATCH v4 7/9] md/raid1,raid10: skip futile retries on P2PDMA mapping failures
Date: Wed, 22 Jul 2026 20:58:39 +0200
Message-ID: <20260722185841.449934-8-mykola@meshstor.io>
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

From: Logan Gunthorpe <logang@deltatee.com>

BLK_STS_P2PDMA reflects the peer/member pairing, not member health:
retrying the same pages on the same member cannot succeed.  Keep
WriteErrorSeen so the range stays fenced, but skip WantReplacement and
FailFast eviction, as commit f7b24c7b41f2 ("md/raid1,raid10: don't fail
devices for invalid IO errors") did for BLK_STS_INVAL.

The failure is whole-range and deterministic, so narrow_write_error()'s
block-by-block submit_bio_wait() retries are pointless.  Record the
whole range as a bad block in the completion handler instead.

Fixes: 02666132403a ("md: propagate BLK_FEAT_PCI_P2PDMA from member devices to RAID device")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Co-developed-by: Mykola Marzhan <mykola@meshstor.io>
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
---
 drivers/md/raid1-10.c |  3 +++
 drivers/md/raid1.c    | 12 +++++++++---
 drivers/md/raid10.c   |  8 +++++++-
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index cee21452e066..89daf8558251 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -309,6 +309,9 @@ static inline void raid1_write_error(struct mddev *mddev, struct md_rdev *rdev,
 {
 	set_bit(WriteErrorSeen, &rdev->flags);
 
+	if (bio->bi_status == BLK_STS_P2PDMA)
+		return;
+
 	if (!test_and_set_bit(WantReplacement, &rdev->flags))
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 19c4dec450de..917d694ef401 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2624,10 +2624,16 @@ static void handle_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
 			 * narrow down and record precise write
 			 * errors.
 			 */
+			struct md_rdev *rdev = conf->mirrors[m].rdev;
+
 			fail = true;
-			narrow_write_error(r1_bio, m);
-			rdev_dec_pending(conf->mirrors[m].rdev,
-					 conf->mddev);
+			/* Mapping failures are whole-range and deterministic */
+			if (r1_bio->bios[m]->bi_status == BLK_STS_P2PDMA)
+				rdev_set_badblocks(rdev, r1_bio->sector,
+						   r1_bio->sectors, 0);
+			else
+				narrow_write_error(r1_bio, m);
+			rdev_dec_pending(rdev, conf->mddev);
 		}
 	if (fail) {
 		spin_lock_irq(&conf->device_lock);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 428bddddfe71..9045a3f02dae 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2940,7 +2940,13 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 				rdev_dec_pending(rdev, conf->mddev);
 			} else if (bio != NULL && bio->bi_status) {
 				fail = true;
-				narrow_write_error(r10_bio, m);
+				/* Mapping failures are whole-range and deterministic */
+				if (bio->bi_status == BLK_STS_P2PDMA)
+					rdev_set_badblocks(rdev,
+							   r10_bio->devs[m].addr,
+							   r10_bio->sectors, 0);
+				else
+					narrow_write_error(r10_bio, m);
 				rdev_dec_pending(rdev, conf->mddev);
 			}
 			bio = r10_bio->devs[m].repl_bio;
-- 
2.52.0

