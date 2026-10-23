Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.225.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792783516;
	b=t0ONOMWaHIkkIK48F6V7C5a+qee4H7VI+ZmJa/BmmKD3isZ46b3iygQosP8S3ypn0LXy
	 6/wFio2XoL0ceC1BkYy2NGTJFvtcCKlCANiHHAgZ6AdUZZSvEys7AKrs+ed5EUQNq30by
	 Rcxq4K045WMLXISb2PRwDlw1SJkPi0bP26AgpUUMqri7Becm+N+HX9G9i5dxxKuEmwQYj
	 SxLlko8b+4oKNxWEi9aqx3vA9z1OluJ0hfMy2lA8jZALs7uoJd5OCIixJILrEte9iJu6H
	 tfjCag9i/lBt8hca6AFFX29g0BPtMBvPGyxwR7BRtCfD7mdtDzPElCyxOO6ZjCDiuAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792783516;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=oGW63mO5SvhKxHF/FfNpWKu1NPhp9bwy3WqXJsLfK7o=;
	b=S+hCzHgZ1rFvvfDQC7tS1r5ofyjvCnSrngzE5QsovlJWWVJ8TqxyTcSnkLSKpRV3v4fa
	 nCmLOQfxKT4djll5nX9CHdIlylNJSV6OQg1/LIMsyGczNPX00vUM0Lpz44ieThyPPhsx/
	 5CXe8MmGcA5ReN8ER14ObxdMs6+sfIUgUYQxhHKIS567jtkJwsBM5jQU9QXo8ONLqWOub
	 8Jr0WsA7y9UwA1iDGy2caQpNEP7DFNkG5Fu6IIwuVDhKwtsuZaoTYCgzOzSxMDmGHntCX
	 eEXFTXUV1ogf/wDWYpAs6iIlbsO6fN2sa3thZrd6Mm/XEJqMomjTE0oJqqAQJI76ZeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=bCPSuJt8;
	arc=none smtp.remote-ip=74.125.225.139
Received: from mail-wm2-f11.google.com (mail-wm2-f11.google.com [74.125.225.139])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA0F606A31B
	for <linux-rdma@vger.kernel.org>; Fri, 23 Oct 2026 19:25:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BEA0F606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=bCPSuJt8
Received: by mail-wm2-f11.google.com with SMTP id 5b1f17b1804b1-49814d35686so804805e9.0
        for <linux-rdma@vger.kernel.org>; Fri, 23 Oct 2026 12:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792783514; x=1793388314; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=oGW63mO5SvhKxHF/FfNpWKu1NPhp9bwy3WqXJsLfK7o=;
        b=bCPSuJt8o7R3/iFQ8u1K/2H091zqiwd6etYriejb2OE3nLVFjN7PWBCbErrdJh5DpM
         IFXrUgAJKVOp3eKoI61FP3JV0HHGAJuzlqphz9IOxKVQ/DuREA7m09SWrG4sbkRqluzY
         M6QQw40fPN/UbFsN9ML1iQtqJFWo8HczLgWACvcdJLMD9F9BEjwxfkMMG6SR139fkCiT
         oFp6jIjph8Ipue0WkkTu8pmlcqEUv+urVWnWq0ByBYauJu0XMz8mh6mydZTbcZHIXH5e
         6586wBPdPkWNXUcUVkDeenf6nkyjMLs5mLqK0UbkKqovfvjcN7VF10Gbgetivimk5qZ+
         8dWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792783514; x=1793388314;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oGW63mO5SvhKxHF/FfNpWKu1NPhp9bwy3WqXJsLfK7o=;
        b=VTjY56aR/xghh5iTbmt9GPFLMywOhGJrfVt0dH+SZ2XvCuAZmf+kxJPmpWBnWZ0uE8
         qIQr4TDYOwRRVeDuqQTd1i0efQ5/lW/N9/vWJA06eX+eY/It+WPDWqXzcMfCR/YxR9Bk
         AIDb6HNe0XhX9MvOUoURHUnbGQ5qNXdyUZ9IbVKGQT165XtF/gXYAKLHc5BKC8LCXCbC
         YTAio9DIZ7thhh480rzT0LYjMK7/fN/lVjD2wCIAW2+3bCFVNyr9kO4EyWPLfYQCiDHF
         a9L5Qr0CRSBv2xG8GdY3ssjBPwe6yXJmxvr5oa5SXL4ETKqbFbmgf/8wYvwCP6VKoZCO
         87iw==
X-Gm-Message-State: AFq9FYKK2GCwhd9ARg3HYqt2efxn5r/hxHThqgTO4K2SLgvdr+wUVjes
	o6+PUS/dleZkfTriAnBnzY+rTyf0+U0ZzPKqc6HB0DXUbz34fm+fwZBy8ZYWDL5D
X-Gm-Gg: AYBFou2WOSah5zUTjqdBNfV6u52qiZbabFKcFwM8LP2T2ehWyzZWi9oZqaK/sFysnbn
	a2esBWHQG9Skc79A4PZ144c5vaJtk3oHwrX7zsb56nZeufEfun6XjykLK2rM4Tu7cpNx9CVv2Rh
	2pnvQsGC7xMDjgUNSU02ccAcuzfUg3lI3bZtCZm6ccHygaiMxvKon5iEn5TiGfLBMi8wcdtMjwM
	NihkiCJPpoSfCYI16dM4DcmXQchCqXuTk5OObE1j60P60N29HQyuvuLj0Z/nhQufJykDXFLRID6
	BJAk6Hrr4K4RJY5GTg2hZCtl2hpQL1O0Ak8rr1/6q88Aox+h1KMYzTEB5/P7XQ9EOrkUlwqr6BB
	Rfodk2jF/EsSjKRky8ov3WBg4KGo8SS5V4Gw/hzW8N/RMxm7yhfgKyxPpQIQT9KskaaxFscXfqz
	nOggtlvcgN0w3Zu4moB+CWTdrFrR2MHP51nZProbYHC32yejeygCOaIFKmToNYyevRSXbXmRwSW
	SVhMVD2nLJ7BAryq46GS/Uv+L+OYY1CrcnrSGfk1zuipAnV4SqfLsi2BjXvbECQLXGYZ0o=
X-Received: by 2002:a05:600c:1389:b0:4a1:c6f5:2450 with SMTP id 5b1f17b1804b1-4a211cac456mr52662775e9.17.1792783513937;
        Fri, 23 Oct 2026 12:25:13 -0700 (PDT)
Received: from serhat-ubuntu.home ([212.253.207.33])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a0aa097sm3720225e9.3.2026.10.23.12.25.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 12:25:13 -0700 (PDT)
From: Serhat Kumral <serhatkumral1@gmail.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Serhat Kumral <serhatkumral1@gmail.com>
Subject: [PATCH] RDMA/mthca: Fix off-by-one in mthca_map_user_db()
Date: Fri, 23 Oct 2026 22:23:48 +0300
Message-ID: <20261023192348.11070-1-serhatkumral1@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

db_tab->page[] has uarc_size / MTHCA_ICM_PAGE_SIZE elements, so valid
doorbell indices are in the range [0, uarc_size / 8 - 1]. Allowing
index == uarc_size / 8 results in an out-of-bounds access at
db_tab->page[npages]. Use '>=' instead of '>' in the bounds check.

Fixes: 56483ec1b702 ("[PATCH] IB uverbs: add mthca user doorbell record support")
Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
---
 drivers/infiniband/hw/mthca/mthca_memfree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_memfree.c b/drivers/infiniband/hw/mthca/mthca_memfree.c
index 9c5eb03f354d..39d82dc73807 100644
--- a/drivers/infiniband/hw/mthca/mthca_memfree.c
+++ b/drivers/infiniband/hw/mthca/mthca_memfree.c
@@ -453,7 +453,7 @@ int mthca_map_user_db(struct mthca_dev *dev, struct mthca_uar *uar,
 	if (!mthca_is_memfree(dev))
 		return 0;
 
-	if (index < 0 || index > dev->uar_table.uarc_size / 8)
+	if (index < 0 || index >= dev->uar_table.uarc_size / 8)
 		return -EINVAL;
 
 	mutex_lock(&db_tab->mutex);
-- 
2.53.0

