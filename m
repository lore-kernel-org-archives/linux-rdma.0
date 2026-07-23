Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A935D47FB11
	for <linux-rdma@vger.kernel.org>; Thu, 23 Jul 2026 20:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784839392; cv=none; b=XzXyZRnY5JUDts3CaKGj+Wjw7fvTDvYzmpF6AuYJp8gux1jHvXrV1ivOofZ8p2YcZwyCUHV9DnZ2DYnAUkYXmFy0fP1sWFae4zUYuYRa0USkjpoGEavF4r140EgH8Pca6B5tWQrhd2nEHr390HmDJVnG1FQEmS8KjjyKm0CXW/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784839392; c=relaxed/simple;
	bh=B1aIegApdgScj51bEIGVKX+FENfztmE4q/fjJ31TwzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NVEgNpgy9Qv7hpphVMlERz3osCaK/picDXkZT9GJ5WSCPw8Hcsi5IpAHjsZdng08NoxS4/+sZSQsk+W2jzTarEbaGBQUXYGmmqlgIWbDazjSVvqU1aVgtly4zSATTH/ri/9+GJ1ojiQ/+HX2jhzKPU4Gvwib5FAzpo2F+moS+60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=Vh+j2fYI; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="Vh+j2fYI"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-47f707e5d75so750868f8f.1
        for <linux-rdma@vger.kernel.org>; Thu, 23 Jul 2026 13:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784839384; x=1785444184; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vP39KbYqkNNRmuPyaoPhdZlQ+sTmuJQGW6DJY4lSzaU=;
        b=Vh+j2fYIAAlwbHOWPa/hK7YJWC5+OwIKFTcBSfP8hHCijIILORAWmxr+3P6EqtVgzQ
         oACyPP5VymPVgFWCa/QsQudx1SiPEkxSbl4CZCkvael5lKoYxr44301de+BaY1DHKx1Y
         6IPDD2uMr7JW+vQai4Y1xq+/OsXG253cfNngZ5segD6cZdlkvG7azAk6yykodkYdvWPK
         RtLLvBOhOAh2gPOF3sYAwcELt5tsgEx5JZqh1Vr2AzLiV8UubU30Mj1mWCQYdLN27sgK
         UmUfC/LqYccptvEscUmHWmKlPg5h8kr5V0GVmAssdlPsheM+DsAHMp5wdTObvg9HvfY9
         BMHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784839384; x=1785444184;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vP39KbYqkNNRmuPyaoPhdZlQ+sTmuJQGW6DJY4lSzaU=;
        b=lgmuT+UauavEuiqmMZXUElnrSTwRNR8UmLRN9d071IGz4hbeWlo3aslMKm+GxRU7kM
         Q59L5c7YLs7rrYmMgnI+py/MUqZDdjvjts+ECAt7n4/Fg93XEve+/xRFr4x4wZ8O/Of/
         NVInKmaWFYIJH0SheB10iiMn97UcftJmpknZCogv5QWw+dmM/mf46Mymt35+hfKGrGe8
         DsMlOXmwVmrCzi2nvC9kkPaqHlwOPA/jyNxlht5o2QoTTxvc1e+pCmRIQgcuAlLfsqwJ
         MYizXVi2GD81yKuBXIpjp+SoZblXN7tk/nc59YK1mFnFzSEsdPLX67TylEdrf0WEMaX3
         AhaA==
X-Forwarded-Encrypted: i=1; AHgh+RqUwQwUgXK977OusA3CdCW1PJBNEVOlMnieA8PsZZy7u3C9Mx68EpepGSyV68h17ExqR2v403j20hyq@vger.kernel.org
X-Gm-Message-State: AOJu0YxoVMG984SXMRmsvI3XfkgQlQeTaRIl3R54qcqTsqedJL0ec9I+
	CxI3bdOV2UYvJk3XS4Df8N+G77p64LlXK6SGyEeEq86MJClD+vsutTLzydpNEjLpPw==
X-Gm-Gg: AR+sD13SssIPV/M0Qo2VR3cRlnQhkxw7vxaTtnvKggYe4yKdgBDCmG160KOXquCDNPp
	27T3Bp9nZqHrqxuAlU/G5g2zKIEKfqB/Xu8EhFjMGMYLAQanq6U1cEIvBj+qIvgiJHTs7reiC+8
	9BE4p79YzQWO/g9HMxQdo44KFLaImifsUtGrD7RlqKMRyeIauGYcsV8aHB3GZT5NQj3h8f/MkS1
	kMCGyYEA1YbmY/NUC9p5k5PE2PbvTOWJYy3+GIVSoYPwtFooLIRTVon/4jxgFpgXG3xtE6qvkf7
	G0Gl1drq14WO7QDaM362/l07sV+k9bbDh5STL+CJHHc0fO5u2Dj6MXAdOtEohIPQItoI3D09mUG
	jRN16W4pZTf2Bh51eMoWOmiLUF6NPaFexO0kCu7BIWeiFhoiFrD+iqHjawd+UU0M0xzRUtx86Go
	p7CooZY06A2J1B8TbkWd5WsQp6kSMOMMYkWrE+y3U9yP4knC+2BUiKA27CJ8P6/Asnkg7tC5auV
	6jMUH4q9VtZk7NgBEItOF0G8alHWaw/U0PNRdXFWg==
X-Received: by 2002:a05:6000:1ac5:b0:47f:28e2:d4c4 with SMTP id ffacd0b85a97d-47f8da6e5bcmr6028034f8f.2.1784839384106;
        Thu, 23 Jul 2026 13:43:04 -0700 (PDT)
Received: from meshstor-pc ([185.87.42.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c52fc0sm18268192f8f.23.2026.07.23.13.43.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 13:43:03 -0700 (PDT)
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
Subject: [PATCH v5 05/10] md/raid1,raid10: factor out raid1_write_error() helper
Date: Thu, 23 Jul 2026 22:42:01 +0200
Message-ID: <20260723204206.76930-6-mykola@meshstor.io>
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

From: Logan Gunthorpe <logang@deltatee.com>

Factor out a common raid1_write_error() helper from raid1.c and
raid10.c.

This will help reduce code duplication in subsequent patches.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
---
 drivers/md/raid1-10.c | 13 +++++++++++++
 drivers/md/raid1.c    | 13 ++-----------
 drivers/md/raid10.c   | 10 +---------
 3 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index 56a56a4da4f8..cee21452e066 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -303,3 +303,16 @@ static inline bool raid1_should_handle_error(struct bio *bio)
 	return !(bio->bi_opf & (REQ_RAHEAD | REQ_NOWAIT)) &&
 		bio->bi_status != BLK_STS_INVAL;
 }
+
+static inline void raid1_write_error(struct mddev *mddev, struct md_rdev *rdev,
+				     struct bio *bio, bool allow_failfast)
+{
+	set_bit(WriteErrorSeen, &rdev->flags);
+
+	if (!test_and_set_bit(WantReplacement, &rdev->flags))
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+
+	if (allow_failfast && test_bit(FailFast, &rdev->flags) &&
+	    (bio->bi_opf & MD_FAILFAST))
+		md_error(mddev, rdev);
+}
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7d769b6460ca..f07edeac6e5a 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -483,17 +483,8 @@ static void raid1_end_write_request(struct bio *bio)
 	 * 'one mirror IO has finished' event handler:
 	 */
 	if (bio->bi_status && !ignore_error) {
-		set_bit(WriteErrorSeen,	&rdev->flags);
-		if (!test_and_set_bit(WantReplacement, &rdev->flags))
-			set_bit(MD_RECOVERY_NEEDED, &
-				conf->mddev->recovery);
-
-		if (test_bit(FailFast, &rdev->flags) &&
-		    (bio->bi_opf & MD_FAILFAST) &&
-		    /* We never try FailFast to WriteMostly devices */
-		    !test_bit(WriteMostly, &rdev->flags)) {
-			md_error(r1_bio->mddev, rdev);
-		}
+		raid1_write_error(conf->mddev, rdev, bio,
+				  !test_bit(WriteMostly, &rdev->flags));
 
 		/*
 		 * When the device is faulty, it is not necessary to
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0a3cfdd3f5df..5b63175fb382 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -482,16 +482,8 @@ static void raid10_end_write_request(struct bio *bio)
 			 */
 			md_error(rdev->mddev, rdev);
 		else {
-			set_bit(WriteErrorSeen,	&rdev->flags);
-			if (!test_and_set_bit(WantReplacement, &rdev->flags))
-				set_bit(MD_RECOVERY_NEEDED,
-					&rdev->mddev->recovery);
-
 			dec_rdev = 0;
-			if (test_bit(FailFast, &rdev->flags) &&
-			    (bio->bi_opf & MD_FAILFAST)) {
-				md_error(rdev->mddev, rdev);
-			}
+			raid1_write_error(rdev->mddev, rdev, bio, true);
 
 			/*
 			 * When the device is faulty, it is not necessary to
-- 
2.52.0

