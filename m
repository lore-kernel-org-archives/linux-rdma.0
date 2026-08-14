Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4053806C4;
	Fri, 14 Aug 2026 01:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786671313; cv=none; b=lSbMi0xFqamhVhRvecMYaX5RhOzoISouaoiJQGdcLozo010E8ACaaH/bzsrTfHmie6s5CQu5FAvHYsr6EHz4cxqvBBzbJtt14+Ynx+MGP9NoM7bdYvcrS4bfLv4A5M/iuw+C/wR8McA20RIGhni++hC2CaeBIOFXh2rr20g/fhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786671313; c=relaxed/simple;
	bh=0dzVVxiMYNTaoCIaOtyCdzqla2qFhZKzUxQmUA3epQg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m+0s6TNMmwIa6IuvKksuyGtKCUhx5Af0VqgBPqpxzAHLuOk9Tw41RdkqZyJdtKKpnk4Bnk1TzdTO100puSx5Lti9+JMc+/ct6eB7V7HLqK7gPQCQXf/qeYZxnKpkStvM4vJ4OgWnNR9doyX/scBjbASZs6G4rbCfJwGWHtuhuW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hdrFi+WX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hdrFi+WX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 835571F00ACF;
	Fri, 14 Aug 2026 01:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786671305;
	bh=zlwUOetvfhcVwpY4fhluszuL4ALuR1wuIhgYs6jjaBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hdrFi+WXdWCd8rGTLqIak9Amg6EtLh7mIZgZCJSQU75ITQUKqB8sm100m4sfy+WCj
	 xHdR+by4geGN5qbDrohmlKuoETG/9X1QUoEBoD8O04J/TMJwmBAB81rWtUXsT0+E5L
	 Ea0kIzvchUvJtpPGFdWCQxTZV23pRBfSAiCJMBHWFa6Fa2HjJwqBbiNPonW5jNF+UU
	 nXnuiBbtAXELUyKcA4FczrzkoimCZs/FSkQSaE7GP5asmEOyYWElyQxcuQArxdTH0j
	 f3gx3V/jAqpiSFdLJm4aE4/epA59siHcd79ExDJ/eat58wtRhF7IxpkR2ksx1iA34h
	 iIFPhM7Kg4bJg==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	jhubbard@nvidia.com,
	leon@kernel.org
Subject: [PATCH net-next 3/4] net/rds: acquire the fastpath locks in rds_conn_shutdown()
Date: Thu, 13 Aug 2026 18:35:00 -0700
Message-Id: <20260814013501.43760-4-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260814013501.43760-1-achender@kernel.org>
References: <20260814013501.43760-1-achender@kernel.org>
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
explicitly with a wake-up afterwards.  The fastpath users of these
bits - rds_send_xmit() and rds_ib_recv_refill() - are trylock style
and back off while teardown owns the locks, so no new lock dependency
is introduced for them.  rds_tcp_reset_callbacks() is different: it
blocks waiting for RDS_IN_XMIT, so its wait now spans the teardown
instead of at most one send batch; it also still only samples the
bit, which the next patch converts to an acquisition as well.

One observable side effect: the SENDING flag reported by rds-info has
always mirrored RDS_IN_XMIT, so it now also covers the window where
teardown owns the bit.

The comment in rds_send_xmit() describing the old sample-based
handshake is updated to match.

Fixes: 0f4b1c7e89e6 ("rds: fix rds_send_xmit() serialization")
Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
[achender: reimplement for net-next shutdown path: acquire the existing
 RDS_IN_XMIT/RDS_RECV_REFILL bit locks in rds_conn_shutdown() and release
 after teardown; update comments and commit message]
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
Previously patch 3/4 of "net/rds: Bug fix ports, part 2".
v2: rds_conn_path_reset() no longer touches the lock bits, so lock
ownership now spans the whole teardown and ends at the explicit
release here; correct the changelog inventory of the bits' users
(rds_tcp_reset_callbacks() blocks, the IB send path never takes the
bit); update the stale protocol comment in rds_send_xmit().
v1: https://lore.kernel.org/netdev/20260806072045.1092968-4-achender@kernel.org/
 net/rds/connection.c | 26 ++++++++++++++++++++++----
 net/rds/send.c       |  5 +++--
 2 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index ddd7e2291eea..a10b667c06c8 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -124,8 +124,8 @@ static void rds_conn_path_reset(struct rds_conn_path *cp)
 	/* Clear the bits the reset is responsible for individually: a
 	 * blanket cp_flags = 0 is a plain store that can clobber a
 	 * concurrent atomic read-modify-write on the same word.
-	 * RDS_IN_XMIT and RDS_RECV_REFILL are already clear here - the
-	 * caller waited for both before tearing the transport down.
+	 * RDS_IN_XMIT and RDS_RECV_REFILL are owned by the caller,
+	 * which releases them once the teardown is complete.
 	 */
 	clear_bit(RDS_LL_SEND_FULL, &cp->cp_flags);
 	clear_bit(RDS_RECONNECT_PENDING, &cp->cp_flags);
@@ -414,14 +414,32 @@ void rds_conn_shutdown(struct rds_conn_path *cp)
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
+		 * we held them.  rds_conn_path_reset() leaves both bits
+		 * alone: ownership ends here, not inside the reset.
+		 */
+		clear_bit_unlock(RDS_IN_XMIT, &cp->cp_flags);
+		clear_bit(RDS_RECV_REFILL, &cp->cp_flags);
+		wake_up_all(&cp->cp_waitq);
+
 		if (!rds_conn_path_transition(cp, RDS_CONN_DISCONNECTING,
 					      RDS_CONN_DOWN) &&
 		    !rds_conn_path_transition(cp, RDS_CONN_ERROR,
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
-- 
2.25.1

