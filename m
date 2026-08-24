Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28DA2C11E6;
	Mon, 24 Aug 2026 00:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787531886; cv=none; b=Zwr/HloTto7uRTo8eQIbGgQ1MH2GRpHiFVG3beszJDicIvQcAxvRTTQNSKwWIgtoaLUAud4t8CYB8YC0XwwfBSoYR88uRLZkA6WfkRXLmxD7FEJbBf9Io3selLtaxr+5tZX7M93hYvlBk7EW3S6ezFmtDS09JgwvzGfeIX46UI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787531886; c=relaxed/simple;
	bh=oHKbdr+YVqUfQRcJO44x8cR2ZH2Cnq/2PLjwXMvS2OA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=thUOBbNhlIBba7SqV/aFlQ/WQfZN+wNdlT4JKnWcKVXB8jSHN4UhSz73YQECaOtAJcA6DrgCTYmzEu/YeviLmjv9rYOfJ8DX9Kzlaeq6VRloEXVmwaQpmZQEHW9BLRt6WfiB5DH4bQgMWf+aSXxu1Qv60QgKvL0rxZ4aMJa8KQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aTdLY5GV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aTdLY5GV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204281F00A3F;
	Mon, 24 Aug 2026 00:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787531884;
	bh=Unk7pPNQJNhR6lIZtNaKOpW8ct8P+AERduzq3KHeOpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aTdLY5GV0mX8UbdR/XVPzJaLVK70pLjvVPydxwb6kne22Mi/KE5XhjSSz+RLrK3dh
	 0SxT4hCuHi/741nAIe8nDoz4kQyK7d6D8vE64+/zBB5lekg9JOJZRg5VJ/7g6mCk9P
	 gb1PDb9N+sI5OFRsT8XCeug3HZY7DgnQ2SKgXd4bGnx/KbROg8dmAu+Rc2j+Dgx76+
	 mTg4QfQQP8CWv3Ax5rTK/SI+IkLjWowTK9c8AIyCdjPGjOUKm7UYpSCCGv32ivO+Ko
	 /KaFuFpnBzm12kZh5IbTRl7XeLsnMobcsEgv1vWPk8HOy1V1vfGU3KMXT6FwRTaZ2v
	 OM6cxWMZFX1xw==
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
Subject: [PATCH net v4 6/7] net/rds: acquire the fastpath locks in rds_conn_shutdown()
Date: Sun, 23 Aug 2026 17:37:58 -0700
Message-Id: <20260824003759.127353-7-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260824003759.127353-1-achender@kernel.org>
References: <20260824003759.127353-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Håkon Bugge <haakon.bugge@oracle.com>

rds_conn_shutdown() quiesces the transmit and receive-refill paths by
waiting for RDS_IN_XMIT and RDS_RECV_REFILL to be sampled clear, and
then runs the transport shutdown and rds_conn_path_reset().  Sampling
the bits clear is not the same as owning them: the moment after the
wait_event() returns, rds_send_xmit() can re-acquire RDS_IN_XMIT (or
rds_ib_recv_refill() can re-acquire RDS_RECV_REFILL) and run
concurrently with the teardown.

The sender does recheck the connection state after taking the lock,
but that recheck is a classic store-buffering pattern: teardown writes
the state and reads the bit while the sender writes the bit and reads
the state.  acquire_in_xmit() is only an acquire operation, so on
weakly ordered architectures both sides can miss each other's write,
and the transmit path then runs while the transport zeroes its rings
(e.g. rds_ib_ring_init()) and rds_send_path_reset() rewrites the
transmit state under it.

Oracle UEK fixed the same class of crashes - a 14-year tail of
BUG_ON()s in rds_ib_sub_signaled(), unexpected op-codes and NULL
dereferences in rds_ib_send_cqe_handler() during failover testing -
by making the teardown path *acquire* the fastpath bit locks instead
of testing them ("rds: Make sure transmit path and connection
tear-down does not run concurrently").  Ownership of a single word is
decided by RMW atomicity, so no cross-variable ordering is needed.

Do the same here: take both locks before calling the transport
shutdown, hold them across rds_conn_path_reset(), and release them
explicitly with a wake-up afterwards.  Both are released with
clear_bit_unlock(), so that the ring re-initialization done by the
transport shutdown and the transmit state rewritten by
rds_send_path_reset() are ordered before either bit is seen clear by
the next acquire_in_xmit() or acquire_refill().

The fastpath users of these bits - rds_send_xmit() and
rds_ib_recv_refill() - are trylock style and back off while teardown
owns the locks, so no new lock dependency is introduced for them.
rds_tcp_reset_callbacks() is different: since the previous patch it
acquires RDS_IN_XMIT as well, and it blocks doing so, so its wait now
spans the teardown instead of at most one send batch.  That waiter
runs from rds_tcp_accept_one() on the single-threaded krdsd workqueue
and holds rds_tcp_accept_lock and t_conn_path_lock while it waits, so
a duelling SYN accepted while its path is being torn down parks
accept processing for the duration of the teardown - for TCP bounded
by the (up to 5 s) drain loop in rds_tcp_conn_path_shutdown().  The
window is narrow: the accept-side state check has to pass before the
teardown moves the path to RDS_CONN_DISCONNECTING.

Because krdsd is a single global workqueue, everything else queued
there - accept processing for other connections and network
namespaces, and the flush_workqueue(rds_wq) in rds_tcp_listen_stop()
during namespace teardown - waits behind the parked accept worker for
that time.  It cannot deadlock: the teardown runs on the path's own
ordered workqueue and never waits on krdsd, so it always completes
the drain and releases the bit (on the allocation-failure fallback
where a path shares rds_wq, the two work items simply serialize).
Nor is the blocking wait itself new: rds_tcp_reset_callbacks() has
waited on RDS_IN_XMIT from the krdsd work item since
commit 335b48d980f6 ("RDS: TCP: Add/use rds_tcp_reset_callbacks to
reset tcp socket safely"); this patch stretches its worst case from
a sender's batch to the teardown's drain.  The alternative to parking
is the accept path racing the teardown, which is what these patches
close; making the teardown itself non-blocking is a separate item.

One observable side effect: the SENDING flag reported by rds-info has
always mirrored RDS_IN_XMIT, so it now also covers the window where
teardown owns the bit.

The comments that describe the old sample-based handshake or name
rds_send_xmit() as the only other holder of these bits - in
rds_send_xmit(), above rds_conn_path_reset(), in rds_ib_recv_refill()
and in rds_tcp_reset_callbacks() - are updated to match.

For anyone backporting this patch standalone: it depends on
"net/rds: clear cp_flags bits individually in rds_conn_path_reset()"
and "net/rds: acquire RDS_IN_XMIT in rds_tcp_reset_callbacks()"
earlier in this series.  Without the former, the blanket cp_flags
clear in rds_conn_path_reset() would drop both held bits in the middle
of the teardown; without the latter, rds_tcp_reset_callbacks() would
still sample t_sock without owning RDS_IN_XMIT.

Fixes: 0f4b1c7e89e6 ("rds: fix rds_send_xmit() serialization")
Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
[achender: reimplement for net-next shutdown path: acquire the existing
 RDS_IN_XMIT/RDS_RECV_REFILL bit locks in rds_conn_shutdown() and release
 after teardown; update comments and commit message]
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
    v4: changelog gains a note for stable backporters about the
    dependency on patches 3 and 5.  No code change since v3.
 net/rds/connection.c | 40 ++++++++++++++++++++++++++++++++--------
 net/rds/ib_recv.c    |  4 +++-
 net/rds/send.c       |  5 +++--
 net/rds/tcp.c        | 10 +++++++---
 4 files changed, 45 insertions(+), 14 deletions(-)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index 46ac72088f84..fbbac55a0e81 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -106,10 +106,12 @@ static struct rds_connection *rds_conn_lookup(struct net *net,
 }
 
 /*
- * This is called by transports as they're bringing down a connection.
- * It clears partial message state so that the transport can start sending
- * and receiving over this connection again in the future.  It is up to
- * the transport to have serialized this call with its send and recv.
+ * This is called by rds_conn_shutdown() once the transport has brought
+ * a path down.  It clears partial message state so that the transport
+ * can start sending and receiving over this path again in the future.
+ * The caller owns RDS_IN_XMIT and RDS_RECV_REFILL across this call,
+ * which is what serializes it against the send and receive-refill
+ * paths.
  */
 static void rds_conn_path_reset(struct rds_conn_path *cp)
 {
@@ -124,8 +126,9 @@ static void rds_conn_path_reset(struct rds_conn_path *cp)
 	/* Clear the bits the reset is responsible for individually: a
 	 * blanket cp_flags = 0 is a plain store that can clobber a
 	 * concurrent atomic read-modify-write on the same word.
-	 * RDS_IN_XMIT and RDS_RECV_REFILL belong to the caller,
-	 * rds_conn_shutdown(), and are left alone here.
+	 * RDS_IN_XMIT and RDS_RECV_REFILL are held as locks by the
+	 * caller, rds_conn_shutdown(), which releases them once the
+	 * teardown is complete.
 	 */
 	clear_bit(RDS_LL_SEND_FULL, &cp->cp_flags);
 	clear_bit(RDS_RECONNECT_PENDING, &cp->cp_flags);
@@ -414,14 +417,35 @@ void rds_conn_shutdown(struct rds_conn_path *cp)
 		}
 		mutex_unlock(&cp->cp_cm_lock);
 
+		/* Quiesce the transmit and receive-refill paths by
+		 * acquiring their bit locks, not merely waiting for
+		 * them to be released: with a plain wait, either path
+		 * can re-take its lock the instant after we sample it
+		 * clear and then run concurrently with the transport
+		 * shutdown and the path reset below.  Holding both
+		 * locks across the teardown makes that structurally
+		 * impossible.
+		 */
 		wait_event(cp->cp_waitq,
-			   !test_bit(RDS_IN_XMIT, &cp->cp_flags));
+			   !test_and_set_bit_lock(RDS_IN_XMIT, &cp->cp_flags));
 		wait_event(cp->cp_waitq,
-			   !test_bit(RDS_RECV_REFILL, &cp->cp_flags));
+			   !test_and_set_bit(RDS_RECV_REFILL, &cp->cp_flags));
 
 		conn->c_trans->conn_path_shutdown(cp);
 		rds_conn_path_reset(cp);
 
+		/* Release the two locks and wake any waiter (e.g.
+		 * rds_tcp_reset_callbacks()) that blocked on them while
+		 * we held them.  The unlock orders the transport's ring
+		 * re-initialization and the path reset above before
+		 * either bit is seen clear.  rds_conn_path_reset() leaves
+		 * both bits alone: ownership ends here, not inside the
+		 * reset.
+		 */
+		clear_bit_unlock(RDS_IN_XMIT, &cp->cp_flags);
+		clear_bit_unlock(RDS_RECV_REFILL, &cp->cp_flags);
+		wake_up_all(&cp->cp_waitq);
+
 		if (!rds_conn_path_transition(cp, RDS_CONN_DISCONNECTING,
 					      RDS_CONN_DOWN) &&
 		    !rds_conn_path_transition(cp, RDS_CONN_ERROR,
diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index a6983861eec7..bd6cb3ffaa57 100644
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -391,7 +391,9 @@ void rds_ib_recv_refill(struct rds_connection *conn, int prefill, gfp_t gfp)
 
 	/* the goal here is to just make sure that someone, somewhere
 	 * is posting buffers.  If we can't get the refill lock,
-	 * let them do their thing
+	 * let them do their thing.  The holder may also be
+	 * rds_conn_shutdown() tearing the path down, in which case
+	 * there is nothing to post.
 	 */
 	if (!acquire_refill(conn))
 		return;
diff --git a/net/rds/send.c b/net/rds/send.c
index 8aad185e4b1a..b90e0586f818 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -244,8 +244,9 @@ int rds_send_xmit(struct rds_conn_path *cp)
 	WRITE_ONCE(cp->cp_send_gen, send_gen);
 
 	/*
-	 * rds_conn_shutdown() sets the conn state and then tests RDS_IN_XMIT,
-	 * we do the opposite to avoid races.
+	 * rds_conn_shutdown() sets the conn state and then acquires
+	 * RDS_IN_XMIT; we take the lock first and then check the state,
+	 * so one of us is guaranteed to see the other's update.
 	 */
 	if (!rds_conn_path_up(cp)) {
 		release_in_xmit(cp);
diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index f4c83e368390..826e620b2dd1 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -144,8 +144,10 @@ void rds_tcp_reset_callbacks(struct socket *sock,
 	 * so we must quiesce any send threads before resetting
 	 * cp_transport_data.  Setting cp_state to something other
 	 * than RDS_CONN_UP stops new senders, and owning RDS_IN_XMIT
-	 * excludes any thread already inside rds_send_xmit() for the
-	 * whole socket swap and the rds_send_path_reset() below.
+	 * excludes any thread already inside rds_send_xmit() - or a
+	 * teardown in rds_conn_shutdown(), which holds the same lock
+	 * for the duration of the transport shutdown - for the whole
+	 * socket swap and the rds_send_path_reset() below.
 	 *
 	 * An incoming syn-ack at this point would end up marking the
 	 * conn as RDS_CONN_UP, and would again permit rds_send_xmit()
@@ -178,7 +180,9 @@ void rds_tcp_reset_callbacks(struct socket *sock,
 	/* Read t_sock only while owning RDS_IN_XMIT, never before the
 	 * wait: the teardown in rds_conn_shutdown() releases the old
 	 * socket and clears t_sock, so a pointer sampled earlier can
-	 * be stale by the time we wake up.
+	 * be stale by the time we wake up.  The teardown holds the
+	 * same lock while it does so, so what we read here cannot
+	 * change under us until we release it.
 	 */
 	osock = tc->t_sock;
 	if (!osock)
-- 
2.25.1

