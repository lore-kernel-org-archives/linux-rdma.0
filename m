Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18842275AFD
	for <linux-rdma@vger.kernel.org>; Tue, 18 Aug 2026 16:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787070933; cv=none; b=NswVUNcg0z8T6iTRPyZ+GnOw/G/IHxsaONyj+UEDm6DEJrKuVyLIGeFrUoCSHdw3apW5utQA+8T7JcBokn7G5eXzAwTRqeXRZ+7Pk2WZ9HAz5h2u1i1ne2s0rDoJJRmvZyZLj0nnkIBjhj1KydpMtYcPZ1wtF8gC0BFHp7KUvRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787070933; c=relaxed/simple;
	bh=BvjZPzsmTtdcfM31lpAirAvn7r1tTrHVTkq8Nift3Vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQj0gwS4yCz/lXrBnDnxUyS1RKt+YXmUxTWg3FSVnSJVTnjOs9XU9XRxA2/R3R3TUw0YPV6sFBYu7Pui/AYzKuZBaD6skiohCjoXtFcxQd/kKv+rsmW0JmR7WAuvu3UDmFl5j/fCuGtyluFrffxgJapwxoWBgLcojXtnbWMIUjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FKPRXBeE; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FKPRXBeE"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-848743155bcso68429b3a.0
        for <linux-rdma@vger.kernel.org>; Tue, 18 Aug 2026 09:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787070931; x=1787675731; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FlvrqSjJb88EG2rPVhBx1VgGjmZj/R+UCbrV7qRmUoY=;
        b=FKPRXBeE3tol25pRI72NkZmmGEXVgHBwk0KUCuhJHd3B86t59wvM5F9e1XnqKWlAhC
         NzZHTC4PSig86JhG8mJ1q/Gj731eXPJCWuFn2HrQrTGDTS8mDfoP32/r1N0KKVDxdgSX
         Y7F4LsBNhU20pXrcckZ6N0Eg1hm2Z2p8DzDKu8sc1rs2i7En4cjeYFEw6EbP9w3eNf41
         KyOfmELngcmj+U4s+OE1CzlStSMOqbg3sYtluMjSWgoA7wUnUKKjSLbM/TwvdbNLrne7
         udAmb8Iua7SfwjhNKzgOWvnVcJ6fFIfianuJRqUSDR6livC1uFkvGnmyW2PEvQ3R/dQe
         /k+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787070931; x=1787675731;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FlvrqSjJb88EG2rPVhBx1VgGjmZj/R+UCbrV7qRmUoY=;
        b=WrbUIwjHn/p8mYMfKiLjTqMLwspkNC1BpFioOA7m5Iu5aGw4ZgAlnDoZ5qsZkCbUTi
         Yvd5GVm0nKfGd2xbVj7fFugkzMJzXlE154A/dG0xMckAlIibsY+yO69aU0xX79te8Voj
         74Zry/eyzDdrijFZaSpIUg8qyqxHV5YHu5LsBaC5fafTH74VhKtKl+T5Jh1XK/zOlFfG
         yq0jB5tehRxynnoZOLE8KNNZLcVedzMGwyeW955SR3snLo8Ixc8/FCGdXlbgTAofDjJo
         ZbmY1vnhX6gh4e+rOievtA82ORaRN0IlWMnJTLvPH66eH3fLx9NGpyCJv1AlO7Mq/ms3
         uUxw==
X-Forwarded-Encrypted: i=1; AHgh+RpNg/qpBaqH15ybmAaeAkok/hE0EFT3xS5h3rGvaHsyTnyZhMrT/qcICntfjevWb+XrUx63L/8Z857g@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4UPo/mCkQkoCVnjxY0t6WcTUHbVc1TW0rRTMeSQKilBA7/6dJ
	Y3ILmFv9inE3wVNbJ/NqNF27ZZsB3qBYHsOgm7uM3znUvkN7YsQKhEHW
X-Gm-Gg: AR+sD10e9X81lDoUW1qwpbO7jqaFkvt3C5BH41kaWmI2u7M7UHlXcBj8CIvr0o8d0ex
	k3E8H71mhDz+gSxkGXocUym2XQlruRWhD1ucEeFv1wBR/0p9/bgigRD5z6evR98iNEB+/o9NMP8
	3I2pbajkU5Q2BPN/tiufAHWnrIiZE9aRXYgArIPd11kzrAeYw6nomEr6HXrWzOLQi8Srvpwpbal
	dxMgbBq+QCZ0TSF35+uTnV2ohgiLw8dI3SBnq0inFVtwSq7Ihrfw2D0Ibs/ZEFxQu6eMjwxlBbs
	VVYfBuZjuZ0NXhZFXuSRIfti/vIGxclhNne4+lsLV7Srfwy8JncXQJz8xRnI/MEyYvLXpYsBblw
	u9OU4pTiI7mZQt6NRL/bboLkvm0b/v8VKvsDWHt2Kuckc6+0cWV03NkZyd4HPgp9vrwr6oya5V4
	CoZ9an/HEw7B4L2jj7Tk5neRHQGWvtP0NIPWXZ7bAuSSr9eP1iVq36uPUEKxaH9qLcRqFN/JUf0
	z7gXco2KqzvPtDvDhiw8HV5X+6PKHqC
X-Received: by 2002:a05:6a00:1c9e:b0:845:ba94:a56 with SMTP id d2e1a72fcca58-84fddfbf1cbmr37206428b3a.5.1787070931166;
        Tue, 18 Aug 2026 09:35:31 -0700 (PDT)
Received: from localhost.localdomain ([240a:4282:4801:1b98:2558:3176:8229:fc85])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc13bf235fcsm2378298a12.9.2026.08.18.09.35.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 18 Aug 2026 09:35:30 -0700 (PDT)
From: Liu Zhenlong <dragonliu2018@gmail.com>
To: "Md . Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Liu Zhenlong <dragonliu2018@gmail.com>,
	Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH v2] RDMA/rtrs-clt: use find_next_zero_bit() for permit allocation
Date: Wed, 19 Aug 2026 00:35:13 +0800
Message-ID: <20260818163513.53875-1-dragonliu2018@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816165935.90523-1-dragonliu2018@gmail.com>
References: <20260816165935.90523-1-dragonliu2018@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__rtrs_get_permit() scans permits_map with find_first_zero_bit() and
claims the bit with test_and_set_bit_lock(), restarting from bit 0 on a
lost race.  Use find_next_zero_bit() to resume from the last position so
a lost race does not rescan the already-set low bits; on reaching the
end, wrap to the beginning to exhaust the map.

Compile-tested: arm64 defconfig + INFINIBAND_RTRS_CLIENT=m, rtrs-clt.o
Reviewed-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Liu Zhenlong <dragonliu2018@gmail.com>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index d34d7e5f34d6..a1df90243c41 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -70,19 +70,24 @@ __rtrs_get_permit(struct rtrs_clt_sess *clt, enum rtrs_clt_con_type con_type)
 {
 	size_t max_depth = clt->queue_depth;
 	struct rtrs_permit *permit;
-	int bit;
+	unsigned long bit = 0;
 
 	/*
-	 * Adapted from null_blk get_tag(). Callers from different cpus may
-	 * grab the same bit, since find_first_zero_bit is not atomic.
-	 * But then the test_and_set_bit_lock will fail for all the
-	 * callers but one, so that they will loop again.
-	 * This way an explicit spinlock is not required.
+	 * Callers from different CPUs may grab the same bit, since the bitmap
+	 * scan is not atomic. But then the test_and_set_bit_lock() will fail
+	 * for all the callers but one, so that they loop again. This way an
+	 * explicit spinlock is not required. find_next_zero_bit() resumes
+	 * from the last position so that a lost race does not rescan the
+	 * already-set low bits; if it reaches the end, wrap to the beginning
+	 * to exhaust the map and still find a permit freed below the cursor.
 	 */
 	do {
-		bit = find_first_zero_bit(clt->permits_map, max_depth);
-		if (bit >= max_depth)
-			return NULL;
+		bit = find_next_zero_bit(clt->permits_map, max_depth, bit);
+		if (bit >= max_depth) {
+			bit = find_first_zero_bit(clt->permits_map, max_depth);
+			if (bit >= max_depth)
+				return NULL;
+		}
 	} while (test_and_set_bit_lock(bit, clt->permits_map));
 
 	permit = get_permit(clt, bit);
-- 
2.55.0

