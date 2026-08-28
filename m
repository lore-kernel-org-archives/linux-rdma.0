Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424763AAF67;
	Fri, 28 Aug 2026 22:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787956765; cv=none; b=jxdpPlk2Uw6kvKnXEEpOotiLAZUOur1kBLES4uVsnMyRkEfmoy9xh0IO5YojrhspiwDIQdsfC7y7g9QKOekM4EhRk/LRsdn1z1SA34rxOaDbEWWwPZi/OWFHFvANiG9InhqAD2C4eZAgnee176dIqdSCGVR8rRb8SOSwPMnhl44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787956765; c=relaxed/simple;
	bh=pDnZ7QlfUEGEaAmxb5ukbxsu0YjO288EoMW+xU3b/gg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VI1sDWwBnNnmK87PwRkNG0Z59XK609rMMR91SLgFdm3c/adNWW9eIowYNgF+JS7z2m4jfuOMKQynvkyfoWc0LOqEJsGv0NA+ohfdIY+cyqUoLQMPiBeZoIoYv6K2B4PYC30sFpKuVsDwNpIxamDc0XUiXeqJnr4r2PUTb4CxxWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NInhxC6V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NInhxC6V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703831F00AC4;
	Fri, 28 Aug 2026 22:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787956763;
	bh=Ern6DPQtVePoth9/xenxikY0JUOIAZHKA2pYbOQ+I/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NInhxC6VWshxmO+1acne8T7Pn3+8N5YuRsK1wVpURUYNuiQNgRFVFBQpziBxbCE87
	 ca7GICfRNcH5oNIq15T5jVKBbWYMtDgdo9W62B8Y7HALhO5FTbGLpE9ECPmY2o9VTA
	 T3aD0hY6TIdJG66LzUDJ58+SD9Fb07lFqY8uBVZ1MbzyjY+eJRPz0pOIIql4reP60p
	 RR0R7DV/+o0Lo12GrczEaRfQpuFd1V5kg8Opq+qC3F8Vn0mtT5I8l1uEQOjLCdXwO4
	 fvgbqVz7Dqa2RyfrxsRPrJwXOM9ZssgMvcZtDf4YTsPmtcF0lOXb/VwrZOxv7f/MIm
	 0Yh2kCgYWD8Xg==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	jhubbard@nvidia.com,
	woni9911@gmail.com,
	michal.kubiak@intel.com,
	leon@kernel.org
Subject: [PATCH net v5 2/7] net/rds: use clear_bit_unlock() in release_refill()
Date: Fri, 28 Aug 2026 15:39:16 -0700
Message-Id: <20260828223921.202913-3-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260828223921.202913-1-achender@kernel.org>
References: <20260828223921.202913-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

release_refill() drops the RDS_RECV_REFILL bit with a plain
clear_bit().  clear_bit() has no ordering semantics, and the
smp_mb__after_atomic() that follows it sits on the wrong side for a
lock release: it orders the clear against the waitqueue_active() load
below it, but does nothing to order the refill critical section's ring
and descriptor stores before the clear itself.

That matters once connection teardown owns RDS_RECV_REFILL as a lock
across the transport shutdown and path reset, rather than sampling it
clear, which "net/rds: acquire the fastpath locks in
rds_conn_shutdown()" later in this series arranges: on a weakly
ordered architecture the teardown can win the bit and start the
shutdown and reset while some of the refill's stores are not yet
visible to it.  The same gap existed under the sample-based scheme - a
waiter that saw the bit clear had no guarantee it also observed the
refill's stores - but taking the bit as a lock makes the missing
release pairing load-bearing.

Switch to clear_bit_unlock(), which orders the critical section before
the release, and replace the open-coded barrier-plus-waitqueue_active()
with wq_has_sleeper(), whose internal full barrier keeps the
store-buffering guarantee between clearing the bit and checking for
sleepers.  This mirrors what "net/rds: use wq_has_sleeper() in
release_in_xmit()" does for RDS_IN_XMIT.

The fast-path acquire side, acquire_refill(), uses test_and_set_bit(),
a full-barrier RMW that pairs with this release.  The teardown at this
point in the series still samples the bit, so on its own this change
is release-side hardening; the shutdown-conversion patch named above
makes the teardown acquire the bit with the same RMW, completing the
pairing at the end of the series.

Fixes: 73ce4317bf98 ("RDS: make sure we post recv buffers")
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
    v5: changelog now names the companion and dependent patches by
    subject and describes the teardown's acquire side as of the end
    of the series.  No code change.
 net/rds/ib_recv.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index 357128d34a54..a6983861eec7 100644
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -363,15 +363,14 @@ static int acquire_refill(struct rds_connection *conn)
 
 static void release_refill(struct rds_connection *conn)
 {
-	clear_bit(RDS_RECV_REFILL, &conn->c_flags);
-	smp_mb__after_atomic();
+	clear_bit_unlock(RDS_RECV_REFILL, &conn->c_flags);
 
 	/* We don't use wait_on_bit()/wake_up_bit() because our waking is in a
 	 * hot path and finding waiters is very rare.  We don't want to walk
 	 * the system-wide hashed waitqueue buckets in the fast path only to
 	 * almost never find waiters.
 	 */
-	if (waitqueue_active(&conn->c_waitq))
+	if (wq_has_sleeper(&conn->c_waitq))
 		wake_up_all(&conn->c_waitq);
 }
 
-- 
2.25.1

