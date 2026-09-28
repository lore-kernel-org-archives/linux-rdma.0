Received: from mail-pz2-f42.google.com (mail-pz2-f42.google.com [74.125.228.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5E84E80C0
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 15:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790610852; cv=none; b=tQuGx66+wH4KmGF7oRWgdc0nys71XSfM0sCGba8PQJrXAaWnH2dbeRHmhw9cEh752ekK59U5UA+kf6hKIPuHSbF8rM/u0TAGJp4ropwnsbWg8+fnE3CMwfK9UyCiTs/5RD1XpsmMBKF0m/OqNplGRZFkEQmx9Voh2/zCeBSTbQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790610852; c=relaxed/simple;
	bh=tpRDS3QWQEz+EWPX/708eI/ejVeubEVNFCMjuV09I4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B3NFUVEB2iAYy/6Gbr4F4BNAB8vInPuOCKO5j7pV38HNF6SuhwM788Zs2zuWbv6/k5Gtl/A3ydkOm9JSSeBcqWW75mJUsLCRwhK4EgQjfg3WNgrzrwzPId5tn2r1dYYQfGvmLqBRsm3Uq68HOHYRcSYJkaYB6IIJPFIkZY13Yps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ibllbsM+; arc=none smtp.client-ip=74.125.228.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ibllbsM+"
Received: by mail-pz2-f42.google.com with SMTP id 41be03b00d2f7-cc797656e36so885993a12.3
        for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 08:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790610850; x=1791215650; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r2fwOkBrxfItcV7iU7YqqxJNyvpWradYv+am29lYRQI=;
        b=ibllbsM+vRpIIDgqD5yZhOk+MsIhbuZbpNTKeoahRODos+/uy1RBI63dP98D4Nm3X/
         TadlFDW93IHO2mkRnuyidyWmtmWaM7WD4dufV/toI2nQhZE/3TfzD83QVYC2/KKc0ORS
         tkt4w7C94QHZHfGl5lxplnu+PbC9jL3alRt/taqHF6EZ9gzGP+U29cfjc/PMi0fjasRv
         fvap/9TweqtF4GBMBN5qkUToPZ+7N5bODDcWKzS8BqodBk2vFy6ipMuJzP4ElGbNeoBa
         FEC8F2Q0e1rc0extEfFsu/EDPMjJY72XDFJisjysfwyjgphN2ryk6C8MipyHMJ6MT8SZ
         SUTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790610850; x=1791215650;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=r2fwOkBrxfItcV7iU7YqqxJNyvpWradYv+am29lYRQI=;
        b=QJkc6fEW+f1e/auOLP9rSuN9/ANXp2BK3KY994lA0o03T5esQKV+jTuleljegFd6Lx
         w/DNUdFmy2yjR70Y2H/S9HvsHeTspzxmY4QSs2FdZY2qMOnuZQrVaS3t1kCH9SJdQiGs
         Nn3rS8KRnvIDafVinWShC+4oDg2rqQShasm+3wj/QqZJ4vZ8m/MYQVf/pYnijBZCMm4V
         orNYEVAftik0N1zVRWdzrbsBFw0/5bUN0gc6UoUQbL+lOjWH/zpNLmEvWmbwhwVr+/BT
         l2L7kL22yHXOc7UWiFsyY6k9PsU5YYjvcJorE/kD0qvzfjtjBTcdnFZ5Bl0xmLP9/pmh
         q43g==
X-Forwarded-Encrypted: i=1; AKwUvBwzdqXBxxFxyaj39H8tCRI5IPYJac7J9rJ3J+Ytp8tQPVwPgJ7zhGtuTHRygd7fjkrrWJefkN3lJuse@vger.kernel.org
X-Gm-Message-State: AFq9FYJUw56J1D+JMoWVjKADCqeIiWMTuWLhEQLcUco0ss8/vMpn3Ryc
	anEZL1ki7m5dMfyfz02YKuPezpl8pF+suJ2mKWB7cZDHz2d2Rqhx0thp
X-Gm-Gg: AYBFou39om4+zyreWmD19NzK/EEBZNaTsqg4LVxy2dadtSguo9ua2klV/sX0ee+ol7F
	CfPYXIT0q1HvzBGNSGWow+ofgnE+ysSa3hr4QM1mrWZEAx11Fq2qd9wFpCQnidVS5javUQTHQwS
	1BxFVKOb/7sQSAaM2kECS1AW5iDejeqr2Ap4PGU7FIB8N7j9xrox/uif292fP6tv4ICBPpK5jqP
	QppqTP2ZsoBHmwmV4Ak26wPaWEJxoOdvkRzyzJ4+mlOxrh4i46njegThQ2kZ+P+8cW4MmjcF+0b
	cQdskDkMGDjoKDpDaBAS1NBkf4cubSWtGZvSvN0sGTqQjOZzBG16b8cWDAQcb4ItXbW5ofUafDA
	DSycAxAVRwfT05+BOmuPmNSx5jSgGaxxApPFkySMwSx16DvaitGEIR4052meJuuLBzBszSVWTRB
	x9+yF6SoZsbhcsnMS1qsXZ4xzasqBZfSkHUmvkdizSFEFR3Ko+ENiMvvZKani62A6q/SHx55p8G
	rm7ILzxAXmBvX56ol/sX8jR
X-Received: by 2002:a17:90b:1c83:b0:3a0:cde8:1dd6 with SMTP id 98e67ed59e1d1-3a0cde82a7amr4463595a91.6.1790610849810;
        Mon, 28 Sep 2026 08:54:09 -0700 (PDT)
Received: from localhost.localdomain ([43.224.245.233])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4986a1905sm44269a91.13.2026.09.28.08.54.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 08:54:09 -0700 (PDT)
From: Dongliang Qin <cccccccccccc777777@gmail.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: Dongliang Qin <cccccccccccc777777@gmail.com>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bob Pearson <rpearsonhpe@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH 4/4] RDMA/rxe: Do not force cleanup on pool timeout
Date: Mon, 28 Sep 2026 23:53:51 +0800
Message-ID: <20260928155351.3222978-5-cccccccccccc777777@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260928155351.3222978-1-cccccccccccc777777@gmail.com>
References: <20260928155351.3222978-1-cccccccccccc777777@gmail.com>
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
