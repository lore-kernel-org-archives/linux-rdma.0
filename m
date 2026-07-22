Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0563955C1
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 18:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784746750; cv=none; b=dXG+gH32uyvegf5qwmkjSDmQFXs6fbHbnBkNphQ7WmjCIpEjVGyJGJfXiyhbXuoRwJ12vhYvWnEtK5OnTvMH0i6Qi1BmeJ7mMb8ONUhN1JOLni4JTemCTcZTT5Sgk+MpkIHQOpxjc4c2BzzyouPZ+WDIySlTsMWkIiR1aiXPAsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784746750; c=relaxed/simple;
	bh=hrTCMMr70YntHE8rHfpC3UJfjfd1U5mS3A9u7ATI3Z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mfwt/TWIMwYEDSiLP8B+QZPBNC1ddas8Be2o+rU7ZI/LDtkLnCeu6YSmJGGW7B7YhftWD3tFxMDIZ+3if3+vewiUbtVD3yfsFcmojP30wDh1eCa6XwtuVKknY9edCaZmZTn6vkECCWwIJy4+hnvlAEVTpoBTplBAgowKiwi20WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=SCM4LtE0; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="SCM4LtE0"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4955aa106b1so34871125e9.0
        for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 11:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784746744; x=1785351544; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GLcS/ETJPdW48ntvSy2VqAomcBgiATmYTCUKJMNlgIw=;
        b=SCM4LtE0/HpN8EcuX55CGhXLzQF6CsoQYXwzal4P7HmkEvDIZZkJr5vC/kZovKCeL5
         PbzcFYqq0NevqxMdGWPlGgJNkm069JS2A0YXg+z/gRCj9mM8V8mTJ5g0OePRGhZahP2R
         WE1+kftU5H0VLSnCXfGtSkx5C5lJoWSsgahn9zwgXpEuuEgZuQwbsFRU9c/YuKlbGSmt
         ls30RVA7zLvvd4l2JiWbZKamN9xdgNZiryp5kbj9H5flxCjCwY1nLZRjB14Jy4PxFwTH
         wW+Mbb5hP/c+D2MkM3PGnESFAs905wfwpcYLmk/M1LL3WJLiy+rXXs9KPasSJz4m//Gf
         a2bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784746744; x=1785351544;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GLcS/ETJPdW48ntvSy2VqAomcBgiATmYTCUKJMNlgIw=;
        b=FRtg/F7zrApDU13YPIuPxkuqPpGgC6SaL3iuXmChIEjBEQvfmzqRrqCfZSqCQL2XWz
         apRV2wP3kMnfu1Q5btV1JY0CyYJHx7USjO+182Vzn+gNL59nV+fs+RU1IeGeq5TaipPH
         ASNd8CJ+pMOD8i0A+ecXnRBzeSZeeIvwp1W5syUomS1mrxKTcny25dU6M8KBadluut3+
         DWCcK/NsqtBBl3gvJm6O81f+Ms97bbhIEvg3UbmaohlNh62m5aivx8/PgPaMPxwnOviS
         oRhwSPWReXyTauF4sREPVwFpxMmYaRtRWtkhHiLI/SSidRg7VIMSuNwiX6SqxddUMA/j
         9iSw==
X-Forwarded-Encrypted: i=1; AHgh+Rq6xm1uLXNRFXtAEasEkWqm5k7db9GCSbjkcDJyVNLQF4B37EqvmyIIW4bQBZfsxvaHtBgZshDmF8qO@vger.kernel.org
X-Gm-Message-State: AOJu0YySZF35vhr49qRR+g3H+ysfRUhKy+lGhAlO9IHJ91HEqpbxPaTX
	dLlxi13YdTh+cRxRbMKc+vRI2n1zxySpZP5I0XGTaOZoHFOlXAcVrDN/aCCXeJ/BZg==
X-Gm-Gg: AR+sD11W4lJtVnip4XG/8sJU5Ag6NgJtA2dAONOjrd40MS9zYuINkyIOVniSbDZIJ63
	JFVoBMkv8ICUSU6VUiX3LgC+mI+YhNauwO4k3Hzu32m0zntU1T8nbW/FjbIUs+u8lwF78YoA3kq
	Kn0u7Jk1SWms7XNvzXZX9zisvxl8viImpuwTOrXzmpM0Zqe7hEwtBWWaTzLz4Vk7JVnNoC/zbdK
	Wg9O/9OcCS6Jy5r6risuKvaMvKJ2ODtXazC8GntHeCaCU5ttSjA6hkWtOBHUwz29VYOEqohyKFd
	40fIlLtC6uOk/l+VyRuxKOoKbNN3RVsFoz3uT0Ge1N25+FD1S1pgbe/vt8zd0/Z58+trheRosxi
	NXmCkGiJ9wz5gIOZ65kG8h1JcnsPiY3mI9zjbXNRPQakZYaaE4o4+VkcEiLWh5rYREWK+3zeZyJ
	JpP/UjfweDeKHQF0yuR0sdZG/6QjLopQKu+ElgD7tzw4HR1cU=
X-Received: by 2002:a05:600c:c84:b0:495:4811:d71c with SMTP id 5b1f17b1804b1-4954a3ed4bamr271393965e9.13.1784746744468;
        Wed, 22 Jul 2026 11:59:04 -0700 (PDT)
Received: from ai-pc ([46.172.241.174])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-495730353d9sm13740055e9.12.2026.07.22.11.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 11:59:03 -0700 (PDT)
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
Subject: [PATCH v4 3/9] md/raid1: serialize non-write-behind writes on CollisionCheck rdevs
Date: Wed, 22 Jul 2026 20:58:35 +0200
Message-ID: <20260722185841.449934-4-mykola@meshstor.io>
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

A write that skips write-behind (full behind queue, a waiting
reader, failed behind-bio allocation) races the in-flight behind
write it overlaps: nothing orders the two on the write-mostly
member, and if the older behind data lands last the member keeps
stale data for sectors already acknowledged as rewritten.

Serialize on CollisionCheck, which marks exactly the rdevs owning a
serial tree: serialize_policy rdevs plus write-mostly members when
write-behind arms serialization -- the case the MD_SERIALIZE_POLICY
test misses.  remove_serial() under the same condition.  This also
avoids the old gate's latent NULL deref for rdevs hot-added under
serialize_policy (they never get a serial tree).

Fixes: d0d2d8ba0494 ("md/raid1: introduce wait_for_serialization")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
---
 drivers/md/raid1.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index afe2ca96ad8c..997f79c05db7 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -564,7 +564,7 @@ static void raid1_end_write_request(struct bio *bio)
 				call_bio_endio(r1_bio);
 			}
 		}
-	} else if (test_bit(MD_SERIALIZE_POLICY, &rdev->mddev->flags))
+	} else if (test_bit(CollisionCheck, &rdev->flags))
 		remove_serial(rdev, lo, hi);
 	if (r1_bio->bios[mirror] == NULL)
 		rdev_dec_pending(rdev, conf->mddev);
@@ -1677,7 +1677,11 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 			mbio = bio_alloc_clone(rdev->bdev, bio, GFP_NOIO,
 					       &mddev->bio_set);
 
-			if (test_bit(MD_SERIALIZE_POLICY, &mddev->flags))
+			/*
+			 * CollisionCheck marks every rdev with a serial
+			 * tree; order against in-flight write-behind I/O.
+			 */
+			if (test_bit(CollisionCheck, &rdev->flags))
 				wait_for_serialization(rdev, r1_bio);
 		}
 
-- 
2.52.0

