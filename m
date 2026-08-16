Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D6A3921C1;
	Sun, 16 Aug 2026 00:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786839319; cv=none; b=OluotDreGfMkkia+0gfH+3Tuuw9L15FfjzFfLGykg+uycw5dCsp6mDPzoI8kOsIR/tmPZyHwboLWoezUHZbL+cxUNhgHysqPbbv2qumH5GRDxiaqa3z+1pfSssSHlddLQMpLVtOE1LloAunyXtPXiUWVA+cCcMqDPsSc9ymgJp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786839319; c=relaxed/simple;
	bh=gz0d+8dDSApLzIsZ975IgPebMo6yQn1VQFtOccgR21c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UXCDj1THrwvinBGPzyMryMefZyYJAwhQRj+ydShb0/PB8+LM+6eINl/zAcXPmte6utH9zADfEqCec+kOL52/pUy4u2G1qyrNEr//jKpfIO71xmU9upTnDQDeA4e6gdu52iYbNsv1DpYHo4TjVsR5YG5CsEvTM7+WG2NzhVrN65c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VhMQNX4M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VhMQNX4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48641F00A3A;
	Sun, 16 Aug 2026 00:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786839313;
	bh=PJHOAcPPvkGBsLwBazRTOjkDrsyp3MaGgDt1ent7xzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VhMQNX4M6jo6VIrwYnHHZp/2cJGZ8iiDrOC+C3KR7/uwrO3vP+/VXA/BRzVACXRg8
	 ySlDFgeQEHMXfaTT8F2Ue8KBkF4A40NmUntaIxKEzcK8Fu5BwrCOUJn052C3QR/jv4
	 7cVDw00iXZElUZlQe2Rsadq5Hrn9IT9B57EUyZzkdQqIIgkgArgEMV54N11WWbIqz2
	 /OMdTYzfudWk3PdKRMbY0IeX4Lr6hrqFRcCIikiQkvR1plYl7u4P+h3lVQl4Hv5Drg
	 qYtjCMZ8NsQDlMIO1BDl8EHmwjmRCZjO7UQWtLB+ds2J01580e7IPy89bqxRJXVQw3
	 jgCxqXhFaAwLA==
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
Subject: [PATCH net-next v2 3/5] net/rds: tcp: don't force RDS_CONN_RESETTING over a concurrent shutdown
Date: Sat, 15 Aug 2026 17:15:08 -0700
Message-Id: <20260816001510.73645-4-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260816001510.73645-1-achender@kernel.org>
References: <20260816001510.73645-1-achender@kernel.org>
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
other state so that the pending shutdown wins.  In that case the
accept path still installs the new socket, rds_connect_path_complete()
then fails its RESETTING -> UP transition and drops it: the raced
socket ends up torn down as it does today, but without disturbing
the shutdown's state machine along the way.

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
v2: new in this version, port of an Oracle UEK fix for the
accept-vs-shutdown state race that the following patches would
otherwise widen.
 net/rds/tcp.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index b263634ac750..d4877de68168 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -150,9 +150,19 @@ void rds_tcp_reset_callbacks(struct socket *sock,
 	 * end up deadlocking with tcp_sendmsg(), and the RDS_IN_XMIT
 	 * would not get set. As a result, we set c_state to
 	 * RDS_CONN_RESETTTING, to ensure that rds_tcp_state_change
-	 * cannot mark rds_conn_path_up() in the window before lock_sock()
+	 * cannot mark rds_conn_path_up() in the window before lock_sock().
+	 *
+	 * Only make that transition if the path is still connecting
+	 * (or already resetting from an earlier duel), so that a
+	 * concurrent shutdown's RDS_CONN_ERROR/RDS_CONN_DISCONNECTING
+	 * is not overwritten; a path in any other state is dropped
+	 * and its pending shutdown wins.
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

