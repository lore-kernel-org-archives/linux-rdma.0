Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3758E3D5246;
	Thu,  6 Aug 2026 07:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786000850; cv=none; b=NFw7iXcn9wO4D8gyv70TKQJP9BNExFKg9trRhW5Hu/1tQYbu0NheJNAm4KDou4XH4ZtU1C5cikYnpn/d3XDipbSRmhW6L0UsOTXI1/q+NdqiwPkGsUzGr6XrDIfRTH/wm+QhqXVkTblWrxCtOuplybswstOH4BqUwTgLhAnSjcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786000850; c=relaxed/simple;
	bh=zdWonA961HGgl0KyJwVVGOHX4pEHyP41NDnt92H3Jc4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GMGjSKBuGTHP/9G4BTvNFMh0w8/+zSceC4Xq5tpCEUeaVLXj16Feq4sdjNiBO5qtHnBV4BX5QbqpBKlduJan+XDi7pPTI0EXaxBXhd+CUT/djue0CaiCmzqnsy7ZLCYowi7Ui/jzrPnc8SIBKsEamO59eSBx7Ruk6klRWCEDSg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fTCsvmqc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fTCsvmqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D8001F000E9;
	Thu,  6 Aug 2026 07:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786000848;
	bh=b0ZzrWefZ6fmgbgqmkHNTFGvvIQC0bUb9AC0KM2YLLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fTCsvmqcm7S1nCi4IOb/2VQfUdBXzzx4LKj1TFKG9/qJBlv/JK9JPc1oGyw6i95tS
	 Twszq5j7m1BhnDpWbhmBVRle1ZdOBT3hXaIsim2nrNDstHRRAUDzRyRi/jGPT951LL
	 yaE621xKoeWdGyBmat+Ah1GsI2KRsXvSbDXUKtpY1UmqrVdQpiPnV52FIFWBV1nQHB
	 LEbZr3c53t9JQO6FJxvToj5G/icEQIom3T8vDD4fNzwHAcTMWXQ2f6raM4zUV2U7v0
	 xe9RenIfeKkMXNJdA6mpONJ3RNgMKA1B9WlMmLh33xngTzUbGoNzUKimIWwGiCVxen
	 TSAvWOJMVbsTA==
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
Subject: [PATCH net-next 4/4] net/rds: acquire RDS_IN_XMIT in rds_tcp_reset_callbacks()
Date: Thu,  6 Aug 2026 00:20:45 -0700
Message-Id: <20260806072045.1092968-5-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260806072045.1092968-1-achender@kernel.org>
References: <20260806072045.1092968-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rds_tcp_reset_callbacks() quiesces the transmit path by setting the
path state to RDS_CONN_RESETTING and then waiting for RDS_IN_XMIT to
be sampled clear before swapping the underlying socket and calling
rds_send_path_reset().

As in rds_conn_shutdown(), sampling the bit clear is not the same as
owning it: rds_send_xmit() can re-acquire RDS_IN_XMIT right after the
wait_event() returns.  Its state recheck after taking the lock is a
store-buffering pattern (teardown writes the state and reads the bit,
the sender writes the bit and reads the state) and acquire_in_xmit()
is only an acquire operation, so on weakly ordered architectures both
sides can miss each other's write and the transmit path then runs
concurrently with rds_send_path_reset() rewriting cp_xmit_* state.

Take the lock instead, hold it across the socket swap and
rds_send_path_reset(), and release it with a wake-up at the end.  The
lock-ordering constraint documented above the wait still holds: the
lock is acquired before lock_sock(), so a sender inside tcp_sendmsg()
can never be waited on while we hold the socket lock.  The !osock
early path is unchanged: it does not quiesce today and the connection
has never been RDS_CONN_UP at that point, so there is no sender to
serialize against.

This extends the previous change ("net/rds: acquire
the fastpath locks in rds_conn_shutdown()") to the only other
rds_send_path_reset() call site, mirroring Oracle UEK's "rds: Make sure
transmit path and connection tear-down does not run concurrently".

Fixes: 335b48d980f6 ("RDS: TCP: Add/use rds_tcp_reset_callbacks to reset tcp socket safely")
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/tcp.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index b263634ac750d..042d3fdbdf7fe 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -128,6 +128,7 @@ void rds_tcp_reset_callbacks(struct socket *sock,
 {
 	struct rds_tcp_connection *tc = cp->cp_transport_data;
 	struct socket *osock = tc->t_sock;
+	bool in_xmit_held = false;
 
 	if (!osock)
 		goto newsock;
@@ -153,7 +154,14 @@ void rds_tcp_reset_callbacks(struct socket *sock,
 	 * cannot mark rds_conn_path_up() in the window before lock_sock()
 	 */
 	atomic_set(&cp->cp_state, RDS_CONN_RESETTING);
-	wait_event(cp->cp_waitq, !test_bit(RDS_IN_XMIT, &cp->cp_flags));
+	/* Acquire the send-path lock rather than waiting for it to be
+	 * released: a mere wait is racy, since rds_send_xmit() may take
+	 * the lock again right after we sample it clear and then run
+	 * concurrently with rds_send_path_reset() below.
+	 */
+	wait_event(cp->cp_waitq,
+		   !test_and_set_bit_lock(RDS_IN_XMIT, &cp->cp_flags));
+	in_xmit_held = true;
 	/* reset receive side state for rds_tcp_data_recv() for osock  */
 	cancel_delayed_work_sync(&cp->cp_send_w);
 	cancel_delayed_work_sync(&cp->cp_recv_w);
@@ -172,6 +180,11 @@ void rds_tcp_reset_callbacks(struct socket *sock,
 	lock_sock(sock->sk);
 	rds_tcp_set_callbacks(sock, cp);
 	release_sock(sock->sk);
+
+	if (in_xmit_held) {
+		clear_bit_unlock(RDS_IN_XMIT, &cp->cp_flags);
+		wake_up_all(&cp->cp_waitq);
+	}
 }
 
 /* Add tc to rds_tcp_tc_list and set tc->t_sock. See comments
-- 
2.25.1

