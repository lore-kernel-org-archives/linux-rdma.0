Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6098128507D;
	Mon, 24 Aug 2026 00:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787531884; cv=none; b=stRnxCsQAGFgUJ8FNdzYcO0ripOUyzRjza2BpeUL9wt/vhxBffknKS1zHtXmCirhDwBG/vIDx4qtu2ty8IMkhaJ3xoXWD9SNQn20QAYjB7zrNDWdjCb7bCr/UFRZU8pdembQtIlvmoxOcdSIHfyoBsk6N3C4Kh7KjU85p0JYEtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787531884; c=relaxed/simple;
	bh=FpibLW+PR70dHHufGTLZUzOTAwyuFzs1trk4PPGWvFc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=E1q0LuluUsAqvgFQwiz9ZvZFAiSOhfjoTCeA9WrtJsX6QTH9QW2Z9Q45JPc5bhm3Enhjok4uI5CwUrK6rxESEkeF5oSv+R5vjhxGVidqNnFV4D9xnFeSofenZPj2f0hntMzzv4SiDNrSK0mTlrhamr2W/VuNxx2/9WlqWcuYU4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yyi4WyKx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yyi4WyKx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0EA11F000E9;
	Mon, 24 Aug 2026 00:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787531883;
	bh=Zn2TS6K6DTawM5Ckkn7kFQJDovEZGGJDKS91DcDAzOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yyi4WyKxI1Covc5yTwS+ryB/8UAI4Bki2bx5dXVFtlnjq5OEJnZ65KutuSxTpuGKh
	 0f6rUMy8BDTL/SmL4ffrn2B9BJiegccKxqxFouSPQVJeKEAgHSsfSZJk6RfTigT75q
	 njIBSsNBbIoP1jxpJDxKlkpb8Qr7D+8TvQVAP6w8Bs0SS/mOsLmAkP7nJqc+qhSeuV
	 mQ3rsX8Q2DNkqHtKa1LQhs+p4qP5P+V9V2kj9HE/nlRV5fSVWUMq2hxXGlZY79R0u3
	 OcVUliEYSiNgcfqOeDB4hYVlv/rtDwIdENA21OD/0mlgciFKNLeMh7cBMK7rBNIuwe
	 E7qTcjqXAWyig==
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
Subject: [PATCH net v4 4/7] net/rds: tcp: don't force RDS_CONN_RESETTING over a concurrent shutdown
Date: Sun, 23 Aug 2026 17:37:56 -0700
Message-Id: <20260824003759.127353-5-achender@kernel.org>
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

From: Gerd Rausch <gerd.rausch@oracle.com>

rds_tcp_reset_callbacks() resolves a duelling SYN by storing
RDS_CONN_RESETTING into cp_state unconditionally.  Nothing serializes
that store against the shutdown path: rds_tcp_accept_one() checks
for RDS_CONN_CONNECTING or RDS_CONN_ERROR under t_conn_path_lock, but
neither rds_conn_path_drop(), which forces RDS_CONN_ERROR, nor
rds_conn_shutdown(), which moves the path to RDS_CONN_DISCONNECTING
under cp_cm_lock, takes that lock.  The store can therefore land on
top of a shutdown that is already in progress, or that gets queued
right after the accept-side check.

When it does, the shutdown worker's final DISCONNECTING -> DOWN
transition fails and the path goes through rds_conn_path_error() and
a second drop/shutdown cycle instead of a clean reconnect, tearing
down the socket the accept path has just installed.  Before commit
ad22d24be635 ("net/rds: No shortcut out of RDS_CONN_ERROR") a path
found in RDS_CONN_RESETTING even made rds_conn_shutdown() bail out
altogether.

Make the transition conditional: move CONNECTING -> RESETTING (or
stay in RESETTING from an earlier duel), and drop the path in any
other state.  The drop has side effects of its own: it replaces the
shutdown's RDS_CONN_DISCONNECTING (or RDS_CONN_ERROR) with
RDS_CONN_ERROR and queues one more cp_down_w run.  The difference is
that rds_conn_shutdown() accepts RDS_CONN_ERROR in its final
transition to RDS_CONN_DOWN, so the shutdown in flight completes
normally instead of through rds_conn_path_error(); the extra
down-work pass then finds the path already down and falls through to
the reconnect check, or catches a reconnect that has already started
and restarts it.  The accept path still installs the new socket,
rds_connect_path_complete() then fails its RESETTING -> UP transition
and drops it: the raced socket ends up torn down as it does today.

The state can change again between the failed transitions and the
drop.  That is inherent to rds_conn_path_drop(), which the socket
state-change callbacks also call unconditionally, and costs at most
one extra drop/reconnect cycle.

Based on Oracle UEK commit "net/rds: Don't force state
RDS_CONN_RESETTING" by Gerd Rausch.

Fixes: 9c79440e2c5e ("RDS: TCP: fix race windows in send-path quiescence by rds_tcp_accept_one()")
Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
[achender: port to net-next: use the two-argument
 rds_conn_path_transition()/rds_conn_path_drop() and rewrite the
 changelog for the upstream shutdown path]
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
    v4: no change since v3.
 net/rds/tcp.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index b263634ac750..ad14217867a4 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -150,9 +150,22 @@ void rds_tcp_reset_callbacks(struct socket *sock,
 	 * end up deadlocking with tcp_sendmsg(), and the RDS_IN_XMIT
 	 * would not get set. As a result, we set c_state to
 	 * RDS_CONN_RESETTTING, to ensure that rds_tcp_state_change
-	 * cannot mark rds_conn_path_up() in the window before lock_sock()
+	 * cannot mark rds_conn_path_up() in the window before lock_sock().
+	 *
+	 * Only make that transition if the path is still connecting
+	 * (or already resetting from an earlier duel).  A path in any
+	 * other state - typically RDS_CONN_DISCONNECTING or
+	 * RDS_CONN_ERROR with a shutdown in flight - is dropped
+	 * instead.  That still replaces its state, with RDS_CONN_ERROR,
+	 * and queues one more shutdown pass, but rds_conn_shutdown()
+	 * accepts RDS_CONN_ERROR in its final transition to
+	 * RDS_CONN_DOWN, so the shutdown in flight completes normally.
 	 */
-	atomic_set(&cp->cp_state, RDS_CONN_RESETTING);
+	if (!rds_conn_path_transition(cp, RDS_CONN_CONNECTING,
+				      RDS_CONN_RESETTING) &&
+	    !rds_conn_path_transition(cp, RDS_CONN_RESETTING,
+				      RDS_CONN_RESETTING))
+		rds_conn_path_drop(cp, 0);
 	wait_event(cp->cp_waitq, !test_bit(RDS_IN_XMIT, &cp->cp_flags));
 	/* reset receive side state for rds_tcp_data_recv() for osock  */
 	cancel_delayed_work_sync(&cp->cp_send_w);
-- 
2.25.1

