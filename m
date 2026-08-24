Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1FD23AE87;
	Mon, 24 Aug 2026 00:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787531883; cv=none; b=Elyt5qIILklgEbXPYRDLUXXwjESGHxt8oKqNqlNq4pDD/6mYWb9WE3mQ0BOfOsEMjt2pA+lp+77j9D6a2dUAW4eEBL9UMX9VrUxtYkmT6gYKLWLobrcx+CxY3oPLK2AigF5oPkbN+Qk/5k/2jHpj511r0PC7husmpNa+IlPrkX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787531883; c=relaxed/simple;
	bh=sx+CVfrSxT4XlRzbnqDwTcS5d6UL74YkmqE0L+VInFs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dvDa0W5aUfApZ5uhDID8TFFCjc4njHY56nlGrL/C4Y15NZux7mHgbLQgFg3KAVSUoI8RQr3LZvp6JN987hyk8I+vfB4MkYM9YZPB/fe2NHQSh568Em3DJm5aPOCvv0bSD9clLSjTSB3pr0mJ1uMjS5GY2i1wQpK7QYtiOYxDRdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ll2iRx+f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ll2iRx+f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 679061F00A3D;
	Mon, 24 Aug 2026 00:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787531881;
	bh=7Q3L5mjUL8rSwwNJD7sm+3P795RHSTUyAKbFuMuWal4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ll2iRx+f3OosiDl6hhxxDiEnJNY9NjNHGubJ1P9fiT4j0n+peBEokq4lDBLlq6dyv
	 GVbLw1t5kb33WpMrDfxHicwGduoXaIC2p68RZF3ksjQhg5s/X9r+MAte6wx9eCtjzX
	 wAelA58eYoifyc+OXCoAhEiUTV4mITXzLz+yb+NfpGMv8nOuNDgmehdPS5Vx9mLZhx
	 I+Rwc1EiebLw29zvZJi8CIaCSx86aTJBoPVNE7YKlrmsWjkFsCGySTjgtGTQt6s/wZ
	 sTHXwBL/emrDG0vPWh8v9mLbFi7cBlZy35X5opJ0XCJbCdiLqdQczu+OQh69o1VvQS
	 83tleb+lLTPsA==
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
Subject: [PATCH net v4 2/7] net/rds: use clear_bit_unlock() in release_refill()
Date: Sun, 23 Aug 2026 17:37:54 -0700
Message-Id: <20260824003759.127353-3-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260824003759.127353-1-achender@kernel.org>
References: <20260824003759.127353-1-achender@kernel.org>
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
clear, which a later patch in this series arranges: on a weakly
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
sleepers.  This mirrors what patch 1 does for RDS_IN_XMIT in
release_in_xmit().

The acquire side, both the fast-path acquire_refill() and the teardown,
uses test_and_set_bit(), a full-barrier RMW, so it already pairs with
the release.

Fixes: 73ce4317bf98 ("RDS: make sure we post recv buffers")
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
    New in v4.  Completes the release-side pairing for the second
    bit lock that patch 6 acquires; raised while re-reviewing patch 6.
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

