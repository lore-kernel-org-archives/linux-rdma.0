Received: from mail-dy2-f42.google.com (mail-dy2-f42.google.com [74.125.229.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85089353A66
	for <linux-rdma@vger.kernel.org>; Sun, 27 Sep 2026 06:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790490998; cv=none; b=ut7WG6VaKFTv18OlnGl6Tv22p36iTDIaJQGiKseTY2vClq4EsFut4n/npxz1jqnyG72SaVkKllQEenwq3tEjlKxqf4xSlWpPljdm9EI99KV3JWgqWQqoIsApv7+kDGOvZf96tsQfE70aEaI700Wb8II9LziHR7v3NxbuSlim9mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790490998; c=relaxed/simple;
	bh=wHQdLfMMd82uicydTDyrDjeBvqpPgK25O3f2d1+2qK4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jWX2swpO5WujWgAa0ukrPhfLPBkeDbN0XEN/dEZgVV+gNfQXoGzNilNVqNOAcZ55niNg7M0Ut80gss/uE5E98dnwCYadtZplEiutUYMYDIl812xroXZfXA28k+37WApgp0hPi8bZsqd0vGifZg2YIKTRRUu1a6SMMva0+m9IL/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mhXSM44g; arc=none smtp.client-ip=74.125.229.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mhXSM44g"
Received: by mail-dy2-f42.google.com with SMTP id 5a478bee46e88-342c9532343so85324eec.0
        for <linux-rdma@vger.kernel.org>; Sat, 26 Sep 2026 23:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790490996; x=1791095796; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=iv9eqmZTsPYq8IkzTlxVg3AoSoWr/86gQvKT1wTesaU=;
        b=mhXSM44gXIaTlG1EH6MlohpI2K43fIzKNMhLNCvGTGXvvdDQJwTAxnzQ4npeYeYBH6
         P4IIwbuln7p5yGLbsLkKUveu+Dt4tp7XJDSit5ScuA4D3Ns1o9HQoD4fWpBH+Y1ov96I
         nK+pJOKRAtiZbERf8WMbKWuiUL8Kq2Ln3oD4UL8NzjNerIko9JBKVW4rT8LOOxTdSE/l
         b0OxExWhhsTS7jj37Yplh592cRtnB2u36lGmoy7KnF/zX76U3ZNBloR+aKbtjTV62ziF
         m1MKYahkTjXREnh0gqT4pctTEVppo3BT78AqiOlUepG2D/2kBymG+NSZcqyX80aDEv3z
         Bt/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790490996; x=1791095796;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iv9eqmZTsPYq8IkzTlxVg3AoSoWr/86gQvKT1wTesaU=;
        b=CIBTUMa0jfoHjDIZRcBUFhjCMq5z8L/mG26kgzQFKsXHrUxcYQIv+y1eUtILPjT1t8
         G1h/2dKWfK+IqfSndaBAU+QhVvpiCRA5y3JztahZm2BfUNVsfgEqi8t8NOkVv8Gy2ez4
         V+uNi+2PCtO7GrY5OuWIUQvVza2jBtm5cIM/yrfHuMoNybsu7Z27dl9xGRT0XtjryTRJ
         Bthdab5BuTxyK5j461Wq09St/CahReC1CDaTLUP0GsmPG++7kR7idQ+IM8f5KkjRK6zi
         lNVLzoSjuFei9wQKxSRbam6zfMgHd920+BYB2Nju6cfjFNivs8QNrLM/fdCGGDppTak3
         QBYg==
X-Gm-Message-State: AFq9FYKYW+guTNjxW7GLkvKMyTKbMi79PZNZoWYyWXVX10ERsZvO+txP
	0CoPW2BMpx8CnMRHGEWpZREVuMXM30at0SKGgku2FXDj9VA55ep5UOFh
X-Gm-Gg: AYBFou0KUJKlQi0zl+XcpClQI4DVeY2uGKMAhNiOqJi1BQoZennUz6YxgtAWn2JHurz
	JAsgbBU1svvBqyrcbpybGgJavWDyXFlXTZGEZAjsCict9cQa5hJT6EIRHc1R6bckMpA4GNyzycB
	BmZj47aCpuG79ljjJZKOHAvKGPN4xsnIttwpzsMIbz541tga1ZSm3pseUwriw/6psPY2otO+IrE
	i9a0xZ8XqsuZRxEZmmQdgz0JY9Bflpc21Oi86xoQ/9tCQE00rv5Hbo/ivhFURSuoxmph3o3q9wN
	XOorik3xO0VS81UeKegEb9uqzRSSkIgbwxxbLFy8ZG7cP9eLugRnpu08VAX3bw//7xww4bgcCWF
	zowUsBu52CCftAJ2p2aL9oFkJAzlVwDjgvHOiH5m0iU5kd7dJd2o5R/7ijXJ0esizoEdVW5q/Qt
	AJ3YeAtA6uSDyEKB7Bovo/yBXgrGax1lenY182azQb1ee/V4QuyAkx+/T8k3MtRfXEOcjlmdnud
	az41+XeQeZDd8ypf6jn6HJZUa88FxB+H0PfpsGDJWYbdxAJAHd6exBRBoYMMcy2P3CNBg==
X-Received: by 2002:a05:7300:de0b:b0:341:f4d6:d9a5 with SMTP id 5a478bee46e88-3427169be76mr8420545eec.1.1790490995482;
        Sat, 26 Sep 2026 23:36:35 -0700 (PDT)
Received: from localhost.localdomain (95.169.12.199.16clouds.com. [95.169.12.199])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-341447576b9sm22047516eec.15.2026.09.26.23.36.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 23:36:34 -0700 (PDT)
From: Chengfeng Ye <nicoyip.dev@gmail.com>
To: "D. Wythe" <alibuda@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Ursula Braun <ubraun@linux.ibm.com>,
	Karsten Graul <kgraul@linux.ibm.com>
Cc: linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH net] net/smc: Serialize early link group cleanup with termination
Date: Sun, 27 Sep 2026 14:36:07 +0800
Message-ID: <20260927063607.3691520-1-nicoyip.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smc_lgr_cleanup_early() calls __smc_lgr_terminate() without checking or
setting lgr->freeing. A concurrent smc_lgr_terminate_sched() can claim
freeing and queue terminate_work before early cleanup takes lgr_lock.
Early cleanup still enters __smc_lgr_terminate(), where both callers can
observe lgr->terminating clear before either sets it. Both then tear down
the same link group, causing use-after-free and duplicate resource release.

KASAN reported:

  BUG: KASAN: use-after-free in __smc_lgr_terminate+0x393/0x3a0
  Write of size 1 at addr ffff8880bf2c0300 by task poc/106
  Call Trace:
   __smc_lgr_terminate+0x393/0x3a0
   __smc_connect+0x2e3d/0x4930
   smc_connect+0x42c/0x580
   __sys_connect+0xfc/0x130
   __x64_sys_connect+0x6d/0xb0

Claim lgr->freeing under lgr_lock in early cleanup, as the other teardown
paths already do, and leave cleanup to the existing owner when it is set.
This also prevents early cleanup from racing with the delayed free worker
or removing a group from a device teardown's private list.

Keep a link group reference across smc_conn_free() and early cleanup in
smc_conn_abort(). Once the connection is unregistered, a termination worker
can finish without taking its socket lock. The extra reference keeps the
group alive until early cleanup has checked teardown ownership.

Fixes: f9aab6f2ce57 ("net/smc: immediate freeing in smc_lgr_cleanup_early()")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
---
 net/smc/af_smc.c   | 8 ++++++--
 net/smc/smc_core.c | 5 +++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index e9f93b3ab435..97b0a0b51066 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1011,12 +1011,16 @@ static void smc_conn_abort(struct smc_sock *smc, int local_first)
 	struct smc_link_group *lgr = conn->lgr;
 	bool lgr_valid = false;
 
-	if (smc_conn_lgr_valid(conn))
+	if (local_first && smc_conn_lgr_valid(conn)) {
 		lgr_valid = true;
+		smc_lgr_hold(lgr);
+	}
 
 	smc_conn_free(conn);
-	if (local_first && lgr_valid)
+	if (lgr_valid) {
 		smc_lgr_cleanup_early(lgr);
+		smc_lgr_put(lgr);
+	}
 }
 
 /* check if there is a rdma device available for this connection. */
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 9974149659c2..b166a379753c 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -688,6 +688,11 @@ void smc_lgr_cleanup_early(struct smc_link_group *lgr)
 
 	smc_lgr_list_head(lgr, &lgr_lock);
 	spin_lock_bh(lgr_lock);
+	if (lgr->freeing) {
+		spin_unlock_bh(lgr_lock);
+		return;
+	}
+	lgr->freeing = 1;
 	/* do not use this link group for new connections */
 	if (!list_empty(&lgr->list))
 		list_del_init(&lgr->list);
-- 
2.43.0

