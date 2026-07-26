Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD763A7F68
	for <linux-rdma@vger.kernel.org>; Sun, 26 Jul 2026 11:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785065569; cv=none; b=PAGJLL+kun/TNIb6JZtdVTC9pzdztIucHgUDQrBu3k+V/8iI5obUPjLK8Od8I6AR8KAnKy9ivl7CLLYwdAL7zckFvp25E83oihn6LSPFo693LLXRbHJrYssdmfjbxmDzdLRdDikD0eWK+TjhAAP2g+A+t5nDHA4fR+CTv+pTuLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785065569; c=relaxed/simple;
	bh=B1aIegApdgScj51bEIGVKX+FENfztmE4q/fjJ31TwzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ANRG5QAyaMysyQBu3NQJ/4iHuabL6Hdo4vhyj2EVDsmNCJT5+pKhHQjq54RJl5SvWem9tDhm7Yu5KXqqi5bhZWLusmTeiOzTITToImoEsFrcyo3+hfw2IjaEBSu9/BvHlkhnD9UhcUbKRv/m6UAzpBirD9WZ2vrVPqEuwr6aPgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=DorYaqq6; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="DorYaqq6"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-4728c12ba97so1097672f8f.0
        for <linux-rdma@vger.kernel.org>; Sun, 26 Jul 2026 04:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1785065566; x=1785670366; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vP39KbYqkNNRmuPyaoPhdZlQ+sTmuJQGW6DJY4lSzaU=;
        b=DorYaqq60eepV9rkw2WLxOal0xhjSKbGs9hrRJ1XPVYOI9kOpk/Dm3PiGoGNaPW3gz
         vci0JAfUL9vlKjkzhHyl+zoF95mf5S/QQiLXoEYXrj8UhDCqVUkl8/U+9AOHBYsCWLJV
         BRcirt+Gy3X+vnTRZ0QeYEx1ycOYLro84nFCm/kSGJZd8AwXJNi4NJoOz2F+FTYwYvuA
         +qHQTnbqhWoTz8J73z+OypD6SF6GbcWkjKmN6mv95758cWif1C5M+6kcL6eTApr0P0NE
         mQITvxApZyeGMyWb4hUJkXstxw/jbbZh/3czgPLxD1d/u+e9y9PjxrCW9EHfAFQ/BH8Y
         oakA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785065566; x=1785670366;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vP39KbYqkNNRmuPyaoPhdZlQ+sTmuJQGW6DJY4lSzaU=;
        b=nPrq+DcZw7mLN3Iopof3sOTnQ3AcheBFngyBbj+IQSNfXRJuQZeeLDcciyGaIEiajD
         Eb7JES71+5/fsHYIDs2c12AttGjv4NdT3+hoCcq5uKtOZUtZNtSQ9sftNb79N0d6H6J4
         x/AxiqIH8ks4aRz66+czKn0QUM1HQXHlZe5+m78KSh9YwwCUHy/PDxnrweFw+ppwQadu
         8tWPzJ1PDf8tFC2IzDYqapIE5RKkh5U6Ab0188oF+UfVawV82RQ36w5tLjBIWh1w2lWP
         zgX38SeL7yd9Ty7MxAPFzdU0rlBXctqo04BQWjUlqdLM8O1Z1Hqob27UjW7239PnCQZl
         BMUw==
X-Forwarded-Encrypted: i=1; AHgh+Rq4U30MUwW8uwP97lF9rL13Jeeraa7rB2nFtBmgMs4g2uxJrjVsAanKr5HlxGsJX6LcalH4JKliwyJt@vger.kernel.org
X-Gm-Message-State: AOJu0YxoQbQq2uABAgMGCCWqQ16g8/IKIIVIanq60Isg2+MmxiUoXsOQ
	rjcJL6gEzDbh3O69lTi4CEwoh0U1DMRZRAffws+HufvULNEXQqkAMKKGZzbyJJaSUA==
X-Gm-Gg: AR+sD11CPG/73B7/awaM1TwClekogFunUZAkHTJYKUJn1J9SjH5VrS5Q40gVkOYloZc
	+MPXsG2I8Ef3cHmtQK3ff6PtH3MX3rJjB0OOVF/W6j83APXeNPFmTWCIU3BJ/Rkv+/ItPuTR4PQ
	rZjOWMP8ZZ3Z8zMvHeRifjue5Z+Ojykj+HKgnlNdftaUlqLnrniQZmGl24Due20OTEt4CGMccWM
	qJNqYGiK+e2XX9AI70dVAHbOCGYMFKL7QFdu+N/fKYbRXzcHUHGvHco5us3VahNhhJeDB7Pw1Fn
	wwYFbAE3X4+zW7B124IduS1f28EkPHZFinG+NvlHUvdSmVxMvbisTTSR4beAyXDyaxLhIp7vWBI
	OBdDaeRFoY+svWqNSeAJeLPYft30FVVlydYFCKkVF1kQiv26Hre3/JfsarBpeCQOKAwzHlLxq4Z
	TzZWp1XxRAKjZVh9BHTMa60kEjha3PPgEYofDj6epb0SL4zKjE/Wqz/AfwHvOzuQ0fEWhwtZqYx
	6IgQq/73x0K/qLtQ7E0/av7iRhZbWbJl5zgmpTKAw==
X-Received: by 2002:a05:6000:200f:b0:46e:c978:7ddc with SMTP id ffacd0b85a97d-47f9fe9bc91mr5809021f8f.24.1785065566081;
        Sun, 26 Jul 2026 04:32:46 -0700 (PDT)
Received: from meshstor-pc ([185.87.42.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85bb57cfsm40533083f8f.11.2026.07.26.04.32.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 04:32:45 -0700 (PDT)
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
	linux-pci@vger.kernel.org,
	Thorsten Leemhuis <regressions@leemhuis.info>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v6 05/12] md/raid1,raid10: factor out raid1_write_error() helper
Date: Sun, 26 Jul 2026 13:32:22 +0200
Message-ID: <20260726113229.2154269-6-mykola@meshstor.io>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260726113229.2154269-1-mykola@meshstor.io>
References: <20260726113229.2154269-1-mykola@meshstor.io>
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

