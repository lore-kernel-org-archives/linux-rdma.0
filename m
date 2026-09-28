Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0082837E2E1
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 17:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790615919; cv=none; b=DjB6V1fW8e5Hf0QxM9ilWioU1jX9y9DSu9o6iL7/UDhVPQPz3jWsTzJpRO3OtLpQiXhHg+a6Tb+yYLctAiLlpdvdseAk5Z1tKGWPuXLy7izMKRMCVkA7DuOEuWZQj8goREEmpvD89d2sb18rqzYQ7QYeAAoIMI6iAyI5qwiWvQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790615919; c=relaxed/simple;
	bh=tpRDS3QWQEz+EWPX/708eI/ejVeubEVNFCMjuV09I4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sj7QXWHtDPpJfPREaZOFf61/DY6mejtKhfUBEUuhXWXOdIN8A4tmYxq0dBKBULYVtWDNbd3/9t8ZvTgCK7qeCwPCb3mPzozZusGEXIJZjl293UUOnqZE5TRGrFLCTEEDk1BFLVxox4+R4kHQWcYAvhb8kjFSGnIy7zhvl3ZkK64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i3nJ6bH/; arc=none smtp.client-ip=74.125.227.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i3nJ6bH/"
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-3a494638445so221048a91.1
        for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 10:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790615915; x=1791220715; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r2fwOkBrxfItcV7iU7YqqxJNyvpWradYv+am29lYRQI=;
        b=i3nJ6bH/6+SXD9eV+cHZybSoCH83UG6N5pbyqKj15RgHVyAjaBXzjiXSFWvJXRTPw+
         tR/iNHNfb4iCuRF0U645/YSfuN7xu44FI3J3GVVRSsxPGwHXcLYxPsCur+tOl5rU/GBE
         0IL8TtHu0XCN5lyAtCHalplWz4/PcrWo1RPU4maHVpOkWGCRHZci1buVHIQZPusLutmV
         /u32w7fiIYsuyBA7G2QKYmvmWNnnh8vE0SiX0+TJERP/HFICLOgGzEF7eTp7Ch5nJKKq
         tQBBvSNnEA70/Y3vT8Xu2OmMhgbMIyux6zwjUM0HRgnKXWVfU1keQ51C/cuT7ULb/lqV
         1BFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790615915; x=1791220715;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=r2fwOkBrxfItcV7iU7YqqxJNyvpWradYv+am29lYRQI=;
        b=XfLUSjDSsE6/K42ZM04jzTP+I2zhtjaKlj4j+bqPPzEoowSIpJQNbp4XQU4e4AQfaM
         LVTDLI7zESBKLessvFcoe343J6YHSorTiulOWphCiJtzgjuYMOobfp/hyPkRqY/QfQrG
         r6k6yM7n5MONbWMD9QBY2SlPy487aarf5sriI0OG48f5DeAQJQ059B4o7BZIsgYcPgZg
         SU0ngmqfyfsvfLS91fwMwBs1JbPepeqcp1qDfLwY9ePUvPLexUkmmSbRjwk7ccdGISpz
         TTmLDxLN1SwnHW7SHzsebC8+9g4JAdHrXeeke9avIji0wwOviznq8cbrUpStil/SPoSl
         AhMw==
X-Forwarded-Encrypted: i=1; AKwUvBxS9hJY1bEVPyBabnwjf3XIt2UPy3I0BpUf1xk4moabpzVuTIoMo3h/uzJ2CW1s+bdYDFhaEyo5eX2Q@vger.kernel.org
X-Gm-Message-State: AFq9FYI+AqBZrjX6x5tMdBPOn9g1JmCHd76EaGPnm9LhxNUYnwJIZcZD
	pBV3s7iVv4L8K0qvC1SmuZ/IEc9Uwwpksdigj6NpQdTLM+xwAsjZj4JV
X-Gm-Gg: AYBFou01YD9Ux/5d7Be1mqNBbem0EWjlQ7Ngs+4KF8QSvV9By+EGjsPBTy5n2PYsA21
	Y2kU5Aknv1V+x2RDHoVu9fY4haAYJFz/5NliT4fVExRXnGYUoBhdh/9rp80X8eCo1IIbgOSBqpS
	bCft8eSf1E4Bdh1ePa7CNULIBCithst/L6x0yfQz4CRz+XwY71Vt167bDbIsaTA/7d7sSFfmLVL
	9lWh+BEiY17dc8+Ng1gI/ge6FO1q3em5CDjaVmrxqq9c8ggug+VQXo2s7nBAWcEXX5ncstEPMMw
	WN+bQ44D+fn7J0Z2Vw2aVE10uTe4XdAi7uX4ZyYyooAhPr/flCDiF9ZspXTUpams1UU3agTTauc
	4udRVlpzlbC0XKOBqOz25v7+sblYAlqDRLuS0YL/a6D2MLzgxOfSxJ5eLriQuQBXf0bthIUul+F
	tT8W+5N7Xu/LI8yVebA1gTq8+IiNCAtt40dV5DrmnTGq9IWDG8ZefsPtOWnA7JmmlKDE+D7T+TO
	CgMo3VPum0dtKyrZigOOUIO
X-Received: by 2002:a17:90b:1c89:b0:3a0:ace4:d2b4 with SMTP id 98e67ed59e1d1-3a0ace4d752mr7661768a91.23.1790615914640;
        Mon, 28 Sep 2026 10:18:34 -0700 (PDT)
Received: from localhost.localdomain ([43.224.245.233])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4986bb8f6sm189139a91.0.2026.09.28.10.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 10:18:34 -0700 (PDT)
From: Dongliang Qin <cccccccccccc777777@gmail.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: Dongliang Qin <cccccccccccc777777@gmail.com>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bob Pearson <rpearsonhpe@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 4/4] RDMA/rxe: Do not force cleanup on pool timeout
Date: Tue, 29 Sep 2026 01:17:56 +0800
Message-ID: <20260928171756.3254016-5-cccccccccccc777777@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260928171756.3254016-1-cccccccccccc777777@gmail.com>
References: <20260928171756.3254016-1-cccccccccccc777777@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The sleepable pool cleanup path waits up to 50 seconds for the last
reference and then continues cleanup anyway. If a reference is still
held, that turns a lifetime bug into a use-after-free.

Wait for completion instead. A stuck object is easier to diagnose than
a stale pointer; the existing non-sleepable path is unchanged.

Fixes: 215d0a755e1b ("RDMA/rxe: Stop lookup of partially built objects")

Cc: stable@vger.kernel.org
Signed-off-by: Dongliang Qin <cccccccccccc777777@gmail.com>
---
 drivers/infiniband/sw/rxe/rxe_pool.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_pool.c b/drivers/infiniband/sw/rxe/rxe_pool.c
index d9cb682fd71f8..d5ff5d453f5f8 100644
--- a/drivers/infiniband/sw/rxe/rxe_pool.c
+++ b/drivers/infiniband/sw/rxe/rxe_pool.c
@@ -178,7 +178,7 @@ int __rxe_cleanup(struct rxe_pool_elem *elem, bool sleepable)
 {
 	struct rxe_pool *pool = elem->pool;
 	struct xarray *xa = &pool->xa;
-	int ret, err = 0;
+	int err = 0;
 	void *xa_ret;
 
 	if (sleepable)
@@ -201,17 +201,7 @@ int __rxe_cleanup(struct rxe_pool_elem *elem, bool sleepable)
 	 * return to rdma-core
 	 */
 	if (sleepable) {
-		if (!completion_done(&elem->complete)) {
-			ret = wait_for_completion_timeout(&elem->complete,
-					msecs_to_jiffies(50000));
-
-			/* Shouldn't happen. There are still references to
-			 * the object but, rather than deadlock, free the
-			 * object or pass back to rdma-core.
-			 */
-			if (WARN_ON(!ret))
-				err = -ETIMEDOUT;
-		}
+		wait_for_completion(&elem->complete);
 	} else {
 		unsigned long until = jiffies + RXE_POOL_TIMEOUT;
 
-- 
2.43.0

