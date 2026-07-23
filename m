Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F3A47FB04
	for <linux-rdma@vger.kernel.org>; Thu, 23 Jul 2026 20:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784839392; cv=none; b=iSupHrFLP5Xso/PWYjD9nZOSuNve5rc/iCJfbiYEJODl6uVqQYJtTKD2d22w9H0MN0VDjBOtYOXTe14WdLPsUOPTwWrSJt/VfCf5Ey4N+gDEDqJSSkjEKILukJGFH8Gx62Ptgwsi9TWDVQCizfMPcxfwM+y8gQa6Mzz+9gVzaRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784839392; c=relaxed/simple;
	bh=tb87IS5YwxWP0/pdiRmCvUCzVsNHu9wl18O2iixHy6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tSkKl9HncegjD8cAlDjBnayXZdIU2KshZP1pklxWl3+PmC2VeqKJmKl1bYpduSGy6ftVvp2q5jrap9ruHoQ/v1shw08nGbOsrdLQGgvopT8z0wm2AhYFVEgMvOBto+bTbW7Z9hkPcG1fnYpUJyEP0LxmTBgMX8yOkCqJIGkPaO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=Pt9YwXgU; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="Pt9YwXgU"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-47640541585so693982f8f.1
        for <linux-rdma@vger.kernel.org>; Thu, 23 Jul 2026 13:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784839382; x=1785444182; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jvUC0Lia0it+LgLYsOXSPjeMnXEhLq3Hqn52LEDkVn4=;
        b=Pt9YwXgUB/n16uijEWINzVy9fytMeDArZSye7T8oKIibLMO23Fp79F6KTTDm4420OC
         K/c+vKpY0QebTMHsOxZFCUtSAFXNKXhWTwpsfnOA+iS6Y4gj4OfU37ft6goBgbz/WAyK
         khgeZ9l6ktaXAkg9fMXiilzowWyWyZpCPVceqH+Dp7XoKYKfneNV+HSAGQOA2+FgEkSb
         cKe21z/xgFbykL/dvmvMtEe/e4LwyNBlYR+uts3K0w0X0tkwkScWSfk1A9lpW/UMhScV
         kPxrYYImjXAs21aTfaVI+BwU3u4x1OTe1kV9QtHsAoWo/OGblM05ozxD7wQRl7bz+fIZ
         c35g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784839382; x=1785444182;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jvUC0Lia0it+LgLYsOXSPjeMnXEhLq3Hqn52LEDkVn4=;
        b=UJ+ggp4+bfO7p4YxIhkyhVnC+fPY3HehvXoQZ7adZn1/che7SG6Kh4Fe6RuwT2rDty
         McAyDno0N5zk92vNaTIqoqudCi9/lhqq2TS1Q3N30tJ0JAwrJBIejqlAvn1YlXlFGIbq
         gp//LQzEyGYZTOiucFxbqVey6F1x84vYnMRXwUK6b+kcewwfIrct3CwrzcWSLHyZi049
         i5TlMBWgM3E4012xrDEJ84af0C42VceOer1dIJxgMx1wi3BCJOaP6JM+tebFc5/sDTFA
         2AquBR7WSUoLbXy+S9bha3QolehccUAl7qc7V08vtywuBKTHp8HgFGO6B/BoBbV4F7j2
         2Nug==
X-Forwarded-Encrypted: i=1; AHgh+RrgBsiGP4ck1wEf0mkinW9qNbx6NqoN4FqByAxiRSmzZydVyVhG/w1+OK/L2LkIhFAU9pxK4ccZMupw@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4L+kf6JA089auRw+ielop6Sf3P96LhPSFS5J0/LfA/R8r+qKf
	2oPK16VSOdpydGST1RWbiYVeRnMZotVh2v79vYZBJoQzFqR+JdC3vZu/aCFPPsyYng==
X-Gm-Gg: AR+sD11GBJd5Mc3RJIAcYI7ky7oJTGVQuhjyQZyY0LHWkfBefz3clVck5EzyE3we2DT
	/CleDHw8hKC/ovJPnrFTPzLDAheW3a+nCpn15LO4GFHdag5jTMgd0drKWuxD9nF7d47fE+Qop5z
	ezjltdKMqVydLRX3weAuj/gKV+yaK+I2HfDmLd0ya4AJqom+qAP9ojbum4d8oLHE7UQObXB6pk6
	D91Zv9K9heRzRTYgrx9Z4mWJmtSk6kwO9t70SnxLfUvOBKOmCw015QCcq5eafcIMtE6YkElu6zY
	vdA0mFqHiEb/DdVPLF5ua5H1+JczJUIWwwrmn+vTBpcunlS5NPjn1Mw5bMmZQ1oMxUTWPIREa8S
	hY4S7E/6JFVjSrZWGFZONdUqmME1b3x3/0N/vS0CEdvDDDCVKjSuXSNNPY3OX+iDiEEvMegVI+z
	fvXeEuBrpOZnLwGkPuNn3GXe7pSI04fH8Y8/ZQbM9gwS6IX4WVeGa1aoCxw8KYYfkDt9RDWAkwB
	CO0HUWaEp2msg1xQaRPcMfjc475Bt/AuyRSMNhFlHjM/lKirDxn
X-Received: by 2002:a05:6000:4301:b0:47f:943a:a7f4 with SMTP id ffacd0b85a97d-47f943aa945mr2275162f8f.61.1784839381805;
        Thu, 23 Jul 2026 13:43:01 -0700 (PDT)
Received: from meshstor-pc ([185.87.42.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c52fc0sm18268192f8f.23.2026.07.23.13.42.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 13:43:01 -0700 (PDT)
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
Subject: [PATCH v5 04/10] md/raid1: don't use write-behind for P2PDMA bios
Date: Thu, 23 Jul 2026 22:42:00 +0200
Message-ID: <20260723204206.76930-5-mykola@meshstor.io>
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

