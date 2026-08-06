Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE413D9551;
	Thu,  6 Aug 2026 07:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786000850; cv=none; b=h8FGv9cfDRyMXVYqJL5UyuivD45Ey6VFIIe34DhmQ6W4HrcOj7WU6UW46hhXyHsb+1V2axrQ8TvaadVzqO2bqLm4gSWhOu+3FIQw8UoMBeTqJeO1yQUlAIksAIQk4Olus31Jd5UmfhCqEIqXB4OPfl5QfTxhrPzOYBOZjhC/E9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786000850; c=relaxed/simple;
	bh=TJZXa1nHjlAZIMABcxtirr9frSVWpigVH9po9uqzmnw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mdN9QYin3/SPoU4fsHpNAUtYnqHKpV+scmFKGgeWXs1Fkl/0Vptnzor3EVqjN+zd0KUPgEORzpXHml10pbC0W7HCMwtyYi2xx+HWi7A56mSJOCguOF40O94vcTxeZ1CRmDwX/v3EpJNGdlgUH2q1uZFzM1RVV23CMLJjF77+re0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UBV9YFNs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UBV9YFNs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF6F1F00ACA;
	Thu,  6 Aug 2026 07:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786000848;
	bh=dzOe67zEUAR6jJhDnOHt3jGlFI/zWNLAswyCHjkT5Mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UBV9YFNsRc/l1Y+3rw64lpBXPsuMyBm0jVAOoy0aC0CnYDqUuvwJq9lJKdLVwrVVL
	 hDitftIRrhqFkJb/lyWjlZZojc/ufJDMUN5tpTngUTcIKQgft587fmo0oCpfgySoTb
	 wWoQAMQtmBlVw5nsmjUux0/yQGEgoSi8puQTPGHEfteSAylcG2hz0lCrHHjlDU4T1P
	 vNDA9ZWxPk+Lf9kkswA6fgMjyT9XtaGOxvWt+LyG7NAAqC9eGog8BHTKusXLMfLQdN
	 wzHAElNvBwcw03Ds2bZtgMC8aqkDjwZ6g4RpBvyowOxwgvXWK8ukKZA3RNXt/JDGbn
	 Rb9XvqjYYFthg==
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
Date: Thu,  6 Aug 2026 00:20:44 -0700
Message-Id: <20260806072045.1092968-4-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260806072045.1092968-1-achender@kernel.org>
References: <20260806072045.1092968-1-achender@kernel.org>
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
explicitly afterwards.  All other users of these bits are trylock
style (rds_send_xmit(), the IB send tasklet, rds_ib_recv_refill()),
so they back off while teardown owns the locks and no new lock
dependency is introduced.  The explicit release with a wake-up also
covers waiters such as rds_tcp_reset_callbacks() that would otherwise
miss the silent clear inside rds_conn_path_reset().

Fixes: 0f4b1c7e89e6 ("rds: fix rds_send_xmit() serialization")
Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
[achender: reimplement for net-next shutdown path: acquire the existing
 RDS_IN_XMIT/RDS_RECV_REFILL bit locks in rds_conn_shutdown() and release
  after teardown; update commit message]
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/connection.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index 7c8ab8e973e1b..406a071efdd3b 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -406,14 +406,32 @@ void rds_conn_shutdown(struct rds_conn_path *cp)
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
 
+		/* rds_conn_path_reset() already cleared cp_flags, but
+		 * release the two locks explicitly and wake any waiter
+		 * (e.g. rds_tcp_reset_callbacks()) that sampled the
+		 * locks while we held them.
+		 */
+		clear_bit_unlock(RDS_IN_XMIT, &cp->cp_flags);
+		clear_bit(RDS_RECV_REFILL, &cp->cp_flags);
+		wake_up_all(&cp->cp_waitq);
+
 		if (!rds_conn_path_transition(cp, RDS_CONN_DISCONNECTING,
 					      RDS_CONN_DOWN) &&
 		    !rds_conn_path_transition(cp, RDS_CONN_ERROR,
-- 
2.25.1

