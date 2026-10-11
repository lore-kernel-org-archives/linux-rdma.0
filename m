Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F19533A700
	for <linux-rdma@vger.kernel.org>; Sun, 11 Oct 2026 17:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791740932; cv=none; b=c/NyWkEEHY7OqEGWifopuRX3Pn/ZPwsvA3/XHc9BWS6hukjLvb4PswkKu3dN7ztGBGaGEHobcHk/pybKACU9j7SKloyS+kRXbhqiJzVfZBUQ+yNvpQt414k9uNKzhXAP8lOz01VzC3asdPOPg3UfYJxM1trB8sbhNFycuEPx0MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791740932; c=relaxed/simple;
	bh=hGNopC5q5uAVdNTtczdcI0MSFHjygXY4DDOanfognps=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Q+rdrRXcW498SwWiC7iHdyX8U54+tmpw6NncSODZ0WAVcNHUjwOOYzCAwl3AMLTd7BG63qGJ06ihU2eaVzu7h/Sao/k4vNzH65vGA0FFPiLxTXBMVy3+2fYpUYiSPAXm81NzWG0SxxCWO8GsgsOIdeWwN/SydZ98yO7r421e7hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BTC+anDg; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BTC+anDg"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a02718da81so8783435e9.1
        for <linux-rdma@vger.kernel.org>; Sun, 11 Oct 2026 10:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791740929; x=1792345729; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=upDrwNGB9JbvjpAZkj932h4EK026LhsRYnlCJhqIVww=;
        b=BTC+anDgCOQcuhrYdyhAbc93QryFZrzm367jTs+blWS89lmO2qXwzJuLRRddShVXuE
         PiK5S5LEH6plvgvDveO9sZKTerEAhsbn44LCc7w1PaKwqTT2uXdkg9PtdjXEcCtcc/6d
         qPqQoZeGNN/bVWUlJ9vNbCQhdFrb8f9khmqSBg/6UllrB8X4LK2A5FXhdIK131wowqQW
         w3gwVRK3Htu0QzKodoaiOgxiiLBFVWdj9S7Iq+T+juxPrimGJdv5V43MwJPXTbp6pqFs
         Asqa+d5cgeD1ohQN+2yWNJmuimHz5Nr0yOI8ye9ueMPDvFfrlNYKYZHFBt+Wq6HecVaK
         WW7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791740929; x=1792345729;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=upDrwNGB9JbvjpAZkj932h4EK026LhsRYnlCJhqIVww=;
        b=dQxx3+GTT4R6c0x/r5ftcNGoS55z/+bhGu7t6IbVBm4yd0cidlouNgqBAH7YEQE8P8
         cNNqYLcFgc4rxpS/9G7M4QNX+54Kwac+hH/v1McvBcIU/BeDacpVphaxmPgZ42lusX06
         ednmCPiWmFFgu7IAiFg+JIQL0rxAMv+VpElTfn9NGzSasewkzIBwvOXIDFV00LuaU5B7
         mMCrOKysO6m2BNBKdXYZptF5D80tisnmBD6ELzqhBAXMnKsKwdIhTmqevNIACugT1Ns+
         f4hY/SSJJrvtevlA/eso0gVP9Eajew3I4RvWoKi8Ic2MnBOBPTSwo5CmmhQpA5ymqF3w
         TYXw==
X-Gm-Message-State: AFq9FYIjIP8kjtjPu6ngOdCCev2nJa5HWJ1RyqbL0OuSaS6OT8jsHJEC
	ODInnlXqa6Ov4KymbqJWIhn/ra39NoDs1L1rc73R6jKiRt3eJXRVj9Sa
X-Gm-Gg: AYBFou1pV6p/ne5JHj8JO5gO8u9Vfe45udQSOHGIaUFiCgiJmBIcq/7fbftVo6d7bgC
	N5ULCh7SRFFJ99nvjbGpxd4G/6wseVjONAyaPt7vQRH+nbpNGeo7rmlwKV9So40EqYSm8f7mIK8
	leCnCeIXCmNUE0ErNV5bK+ImyAUgQ0GKUHDroicXAc5Odl44/OR+nsgUHJh5qs+kvT/xd5uHkBA
	NhFiA0oXJO0aLWyUAi8fjsiPk2e8t78ZxU4H6DmBT8NTPtgTAYT5kBzE2kF6aYMv1ILh/sfux8g
	Gk8z71YGhi065YAU3NWeVsQe8NEfDIgQnwECnBscdMZg4DYJ+gTCDxK+e4Zxn0rxoGk//zWaa/O
	sl9WMFZfm9BSmDatWTl2P4RWgBoLOwfGtMlYiBk//zpoL3w49mZ8W3ygVKNmbFjTH8wlAMLBd1u
	wN6f+CGJ+4OIAziF8bpuRfW1P3Y5/bK7T6x2G232iNgJdRq3lr+zD+O2f09ltwqd9OKtSbbNVgl
	3ctb5CrErDU8aiPAyi8SZVilGWSSMKSpn2Tn2LjSOmhnk9Io13HrtkHTZeGkJoha2Q6
X-Received: by 2002:a05:600c:3b0a:b0:4a1:779c:dc8e with SMTP id 5b1f17b1804b1-4a18e4a01b7mr144162915e9.10.1791740928517;
        Sun, 11 Oct 2026 10:48:48 -0700 (PDT)
Received: from Raghu007.. (sgyl-44-b2-v4wan-174108-cust110.vm6.cable.virginm.net. [80.1.81.111])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18beabbd0sm262519065e9.12.2026.10.11.10.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 10:48:48 -0700 (PDT)
From: Palla Raghunath <raghunathpalla.0209@gmail.com>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shuah Khan <shuah@kernel.org>,
	Brigham Campbell <me@brighamcampbell.com>,
	linux-kernel-mentees@lists.linux.dev,
	raghunathpalla.0209@gmail.com,
	syzbot+ae549381b4daac2895b1@syzkaller.appspotmail.com
Subject: [PATCH v2] RDMA/cma: wait for addr_handler() to finish in rdma_destroy_id()
Date: Sun, 11 Oct 2026 18:48:46 +0100
Message-Id: <20261011174846.59186-1-raghunathpalla.0209@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

syzbot hit a use-after-free of id_priv in addr_handler(). The bad read
is in debug_mutex_unlock(), from the last mutex_unlock() of
handler_mutex, and the memory was freed by ucma_close() ->
rdma_destroy_id().

addr_handler() moves the state from RDMA_CM_ADDR_QUERY to
RDMA_CM_ADDR_RESOLVED (or RDMA_CM_ADDR_BOUND on error) under
handler_mutex. If rdma_destroy_id() runs at that point, it waits on
handler_mutex. When addr_handler() unlocks, the destroying task can take
the mutex before mutex_unlock() has returned. It then sees a state other
than RDMA_CM_ADDR_QUERY, so cma_cancel_operation() skips
rdma_addr_cancel(), and _destroy_id() frees id_priv. mutex_unlock() in
the work then touches the freed lock:

  ib_addr work                         close()
  addr_handler()
    mutex_lock(handler_mutex)
    ADDR_QUERY -> ADDR_RESOLVED
    ...                                rdma_destroy_id()
                                         mutex_lock(handler_mutex)
    mutex_unlock(handler_mutex)
      owner cleared                      gets the mutex
                                         state != ADDR_QUERY, no cancel
                                         kfree(id_priv)
      debug_mutex_unlock(lock)  <- use-after-free

Documentation/locking/mutex-design.rst says mutex_unlock() may still
touch the mutex after another task has acquired it, so handler_mutex
can't be what keeps id_priv alive here. The comment in
cma_cancel_operation() assumes it can. Before commit 722c7b2bfead
("RDMA/{cma, core}: Avoid callback on rdma_addr_cancel()"),
addr_handler() held a reference on id_priv until after mutex_unlock(),
which covered this.

So in rdma_destroy_id(), call rdma_addr_cancel() before taking
handler_mutex if a resolve was ever started on this id. The req stays on
req_list until the callback returns, so rdma_addr_cancel() finds it and
cancel_delayed_work_sync() waits until addr_handler() is really done.
This doesn't deadlock with the work itself. When addr_handler() destroys
the id because the event handler returned non-zero, it uses
destroy_id_handler_unlock(), not rdma_destroy_id(). Event handlers also
run with handler_mutex held, so they can't call rdma_destroy_id() on
their own id anyway.

After that cancel, clear used_resolve_ip and make cma_cancel_operation()
check it, so the request isn't canceled a second time on the way out.
Every id with an addr request outstanding has used_resolve_ip set, so
the device removal path still cancels as before. The loopback and AF_IB
resolves also use RDMA_CM_ADDR_QUERY, but they never queue an addr
request, so there was nothing for rdma_addr_cancel() to do for them.

There's no reproducer from syzbot, so I made the window bigger with a
debug-only mdelay(1000) after the mutex_unlock() in addr_handler(),
followed by a read of handler_mutex.magic. A small test program creates
an id, resolves an address on an rxe device and closes the fd while the
work sits in that delay. Without this patch KASAN reports the same
slab-use-after-free as syzbot (1048 bytes into a kmalloc-2k object,
freed by ucma_close()). With it the test runs clean, and close() just
waits for the work to finish.

Fixes: 722c7b2bfead ("RDMA/{cma, core}: Avoid callback on rdma_addr_cancel()")
Reported-by: syzbot+ae549381b4daac2895b1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ae549381b4daac2895b1
Signed-off-by: Palla Raghunath <raghunathpalla.0209@gmail.com>
---
v2:
- Don't call rdma_addr_cancel() twice on the same id: clear
  used_resolve_ip after the early cancel in rdma_destroy_id() and check it
  in cma_cancel_operation() (Leon)
- v1: https://lore.kernel.org/all/20261004112613.18171-1-raghunathpalla.0209@gmail.com/

 drivers/infiniband/core/cma.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 337a49d1acf7..72138f40dd78 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1968,12 +1968,14 @@ static void cma_cancel_operation(struct rdma_id_private *id_priv,
 		/*
 		 * We can avoid doing the rdma_addr_cancel() based on state,
 		 * only RDMA_CM_ADDR_QUERY has a work that could still execute.
-		 * Notice that the addr_handler work could still be exiting
-		 * outside this state, however due to the interaction with the
-		 * handler_mutex the work is guaranteed not to touch id_priv
-		 * during exit.
+		 * The addr_handler work can still be finishing its
+		 * mutex_unlock() after it has left this state.
+		 * rdma_destroy_id() waits for that before it takes
+		 * handler_mutex, and clears used_resolve_ip so the request
+		 * isn't canceled twice.
 		 */
-		rdma_addr_cancel(&id_priv->id.route.addr.dev_addr);
+		if (id_priv->used_resolve_ip)
+			rdma_addr_cancel(&id_priv->id.route.addr.dev_addr);
 		break;
 	case RDMA_CM_ROUTE_QUERY:
 		cma_cancel_route(id_priv);
@@ -2121,6 +2123,20 @@ void rdma_destroy_id(struct rdma_cm_id *id)
 	struct rdma_id_private *id_priv =
 		container_of(id, struct rdma_id_private, id);
 
+	/*
+	 * addr_handler() can still be in mutex_unlock(&handler_mutex) after
+	 * it has moved the state on from RDMA_CM_ADDR_QUERY, and
+	 * mutex_unlock() may touch the mutex even after we have taken it.
+	 * Wait for the work to finish before we free id_priv. The req stays
+	 * on req_list until the callback returns, so rdma_addr_cancel() will
+	 * find it. Nothing can issue a new request now, so clear
+	 * used_resolve_ip and let cma_cancel_operation() skip its cancel.
+	 */
+	if (id_priv->used_resolve_ip) {
+		rdma_addr_cancel(&id->route.addr.dev_addr);
+		id_priv->used_resolve_ip = 0;
+	}
+
 	mutex_lock(&id_priv->handler_mutex);
 	destroy_id_handler_unlock(id_priv);
 }
-- 
2.34.1

