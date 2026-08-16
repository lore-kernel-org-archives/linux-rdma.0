Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770343A2E39
	for <linux-rdma@vger.kernel.org>; Sun, 16 Aug 2026 17:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786899605; cv=none; b=GBILOYUpStga0QZqJpds9XWVvXXx/PTPo/FLRdtvoSxRXbSqCESbGaA5rJ6G8Cd86WXxz+/jELbb71vx5DGBWqrnQWzIzBOMLkHZO3myR10FW+pgfawCE+Jsp2ewlql8C+p6+lS8cEQ/FdzDokgKxxv2xURX7pZxMVN2ZWghuBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786899605; c=relaxed/simple;
	bh=Cf1L0TSCjenT1W+tNxNkfUMwJYdG+o8nYga8DrBBhk8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=K81Hb9Oro8sEJLiUA2iFJ4JDyhMcPnQwoJrAuzJ64lchEBT8yJEBiTiOVMeh6rHqRPgf05OFi7KLaRC9TAH2xLeCD6liYMNQkqfW3CA8h0Bzsgur72QohCzqhGVsyzARyQZb2weEjb2yP+Rm2bA5S0k5hOVXVFHuN6VJVaA4Yc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a9lVMXLH; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a9lVMXLH"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-38dcbade417so2614508a91.1
        for <linux-rdma@vger.kernel.org>; Sun, 16 Aug 2026 10:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786899604; x=1787504404; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bnrji67FLS0+3KHmX8HTFOo33nEr+usZlyNhp+PZ+bc=;
        b=a9lVMXLHaiaRwHrPKDkEUVMIc9W+yCp6/qedWwOTvLnVEsjsQjO7+K8BJq5jGPq8Hf
         xYGblae1LllOAkHZn13ZcadqVUiiIaMU3P3bCFUW6rC7LeoY+LwlEUrVuzVVxgsJy5Qz
         nrf6aAKVA4bJiIHArPB+n41UUov8FNBr/mwGm/0QHn3ziOO2G+uVxC+DmyCzpd3UoOSp
         zFRfU/m3On/5UDrAAgHBwTr/R3X2GFd8HSjxBnsSaiogMTKiAE6Neo6BU02lr0py/wkB
         2yT2hKxBQDwFp2KL32pF9epSmcJCdOENpFzHCDzZvX3rGQdGgZr9HKQDogWtDPQeC6XO
         /AFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786899604; x=1787504404;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bnrji67FLS0+3KHmX8HTFOo33nEr+usZlyNhp+PZ+bc=;
        b=cCWL8TDI+sxlzSN5MdNe8UuiqvUTvQHHAYtq5nJcm2aHpf+e7WDJlN/Cq3PgYs3F3m
         H4IEXLS76mQBMJN9xrwUb/uZcuIm+gkl3eIb+2exKzB47t/uWISNwuvn+0/1UgIAZZ2p
         f6bb5ZItMSu5z5P6mp18QLo7VEy4u9eztEM05ypJoDLUs/JLX145e3crNyd8GimglBGV
         mOUq+2rzH/8E540RaYzt/UxLddRU2IgJbGw3waVJ+SRa9MVyCctakQSvlUkvy/IBwm2A
         ZPzzvTEJb0FMsxrJk/pQT6fbXazTz6FG5MHxbvrDgTCEQ6Zjajo/K8qFbtlQ98cnOv2K
         ZC7A==
X-Forwarded-Encrypted: i=1; AHgh+RpgaJ6uhgwmiQwZG3iZPKauhSm9RJuvygkWGskkoQYdckTH+Ry19eEqhH0gfE9IF4qSb9eKpk3cdPER@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8Iz80pa/zV6V2KnU8QGU56/L7i1q9Gm8KN8FmKIhnzTK1LUN5
	Hy4H43QEhynYxj/GIjMxFOQQynrJixKViaUvyAsJV00DjMH/WQAc1pLz
X-Gm-Gg: AR+sD10kCkQubIrVJDC2fWaBCGDmuB188sKW33ahT+Cx0wOQdp+UNQSut9JMkQZCcEA
	29bGObNQulniG9TKQ+49hA9Uxxk63HVavimPYCz4ZcYaG1G7heUl/oYDs8bRZ41e+leMA0pUyhf
	zPZ71q3s7v2dO/xEzD1UUYfmaqzXRFS3LpN4vmnboiwQZ8/dgLDWnJ0k0CVWAv7354cqkFES/sx
	MbP8xkz2Qul09qvYIg71BVyTWPNsP+wohkO7+MMHRmBU0DZL33OQqxi3dUoM+TAqcDo/jRbXUgi
	Fki0hYa5QQtgUqqvwL9IH7xSSMh9uKPUjTAZXpsRkvepKLpzIEBXcMGWWUKHYwbcM26DBkQIgtG
	UwqBxrGGydnowYy/I3wUzOeaCK9HMv2mqF83U37HI9ynuDGQRaN8AMApVmK55Coh8D8xUwI/k2D
	cKtU15DBrtpAoZ1UblSPs/ugmQDOUQ5cmcrXnOuAnTwQqP8meTzjzsAwUyFvSNe1xGGSwL7jznO
	rRDO+eIyD70inTNXSN2/Ft5mAfiZmlz
X-Received: by 2002:a17:90b:1b45:b0:380:71eb:4014 with SMTP id 98e67ed59e1d1-3933b944a7cmr19106351a91.15.1786899603542;
        Sun, 16 Aug 2026 10:00:03 -0700 (PDT)
Received: from localhost.localdomain ([240a:4280:4800:1470:95d0:2f3e:656d:65de])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39531e62a7bsm1938648a91.6.2026.08.16.09.59.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 16 Aug 2026 10:00:02 -0700 (PDT)
From: Liu Zhenlong <dragonliu2018@gmail.com>
To: haris.iqbal@ionos.com,
	jinpu.wang@ionos.com
Cc: Liu Zhenlong <dragonliu2018@gmail.com>,
	jgg@ziepe.ca,
	leon@kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] RDMA/rtrs-clt: use find_next_zero_bit() for permit allocation
Date: Mon, 17 Aug 2026 00:59:16 +0800
Message-ID: <20260816165935.90523-1-dragonliu2018@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__rtrs_get_permit() allocates a free permit from a bitmap under lockless
contention: it scans with find_first_zero_bit() and claims the bit with
test_and_set_bit_lock(), restarting the whole scan when it loses the
race.  Each retry rewinds to bit 0 and re-walks every already-set low
bit before reaching the free region again.

Under high queue depth - the RTRS/RNBD data path - the low part of
permits_map is densely set, so a lost race wastes a scan proportional
to the number of in-use permits on every retry.

Use find_next_zero_bit(), resuming from the last position, so a lost
race continues scanning from where it left off instead of from the
beginning.  When the scan reaches the end, wrap to the beginning to
exhaust the map, so a permit freed below the cursor is still found
and NULL is returned only when the map is actually full, matching the
original behavior.  The scan remains non-atomic, so the
test_and_set_bit_lock() retry is still required and the race
handling is unchanged.

A userspace model of the bitmap-allocation algorithm (not the kernel
find_*_bit primitives) quantifies the mechanism: with qdepth=512 and 14
threads holding ~98% of the bits set, a lost race in the baseline
re-scans the densely-set low region, traversing ~1.3k bit-positions per
allocation, while the patched version resumes and traverses ~260.  The
benefit is contention- and density-dependent: under low contention
(sparse map) the two are equivalent, and the wrap adds a small amount
of code over the single-scan baseline.

End-to-end RNBD/fio throughput was not measured (no RDMA hardware
available); the model isolates the allocation mechanism, not the full
IO path.

Compile-tested: arm64 defconfig + INFINIBAND_RTRS_CLIENT=m, rtrs-clt.o
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

