Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22DD2D6E66;
	Sat, 11 Jul 2026 02:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783738282; cv=none; b=sQ1hNZ48EfElQUcjhStEtyx9IQzfttbHK4I08V5HIejM+Aj6UFuWDJt+V/xVGxC3Y/rJ7kb6F9X6NSOC33co203gA45933oIQ3cCQsGPhh9ZBkFuxJWNDFojmJzXBBkJdwiwk27CpwDVeDVeKSYvdfS8AsGuYHN1AvgtIfvrKWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783738282; c=relaxed/simple;
	bh=I0WR9mcCZfkWpnKLyYSGeHJOayh5zXyFcAasfbcm140=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kyhExOg83SPEcG7ALOSxvR4skBCQdySuNjgE2LH+zUwNatvkoCzzBmsjxQY7T8Evotqgwuv1ulj8l82PHLc+YJmOknd488w5Wzz/RYLDPBCkuWp32tbJSCh/hiKV7xzqH6v/wnei/xMZTIGYIXd/F9F1zwmL6tRlx2oQwIIBtWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Td/Q7BKy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Td/Q7BKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E031F00A3A;
	Sat, 11 Jul 2026 02:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783738280;
	bh=Esuz7zhCAZGqe+bNR0ZD1+tVMnDFoolklsUSF2CYBOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Td/Q7BKy8vjz2jkk3RVsTVPXZJMpBoIqXg8MchEtjeSbKrabBedGMqr17LDNDnnrW
	 mUhSVDWYPL/V/mi681N7TFWqpCejlRy3eWHDrU/9NaqphO4or5RPSsM1Ss1QcH4gej
	 n2oYuMWzR8kK72a8JOvtl2YlQ1y4Auu9WZnY1PUhrNhQ/dazrVVWHILVOpN7rkPMiU
	 0DuqegoYrpGMu4LVC0nes2qnlpDi9sq4K8SutiOHcGIRW/vDjX/zbO3HZJZfsX69E7
	 8nIgRpvfld1DZoJm15Al50SOV3rWGcXp9nG+/IAEsu1vG6RE7wBgQdL/QGnoF428Up
	 gCgv/+gUbnrdw==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net 3/3] net/rds: fix rds_message leak in the rds_send_xmit() drop path
Date: Fri, 10 Jul 2026 19:51:18 -0700
Message-Id: <20260711025118.2449428-4-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260711025118.2449428-1-achender@kernel.org>
References: <20260711025118.2449428-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sharath Srinivasan <sharath.srinivasan@oracle.com>

When rds_send_xmit() picks the next message off cp_send_queue it takes
its own reference with rds_message_addref().  If the message then hits
the never-retransmit check (RDS_MSG_FLUSH, or an RDMA op that was
already retransmitted), it is moved to the local to_be_dropped list and
that reference is dropped after the batch.

However, if RDS_MSG_ON_CONN has already been cleared - e.g. a racing
rds_send_drop_to() or rds_send_path_reset() took the message off the
connection lists - the message is not added to to_be_dropped and the
reference taken above is never dropped: cp_xmit_rm has not been set at
this point, so the loop simply abandons rm and the rds_message (and
everything it pins: pages, MRs, notifiers) leaks after an RDMA error.

Drop the reference directly in that case.

This mirrors Oracle UEK commit "net/rds: fix rds_message memleak in
rds_send_xmit".

Fixes: 2ad8099b58f2 ("RDS: rds_send_xmit() locking/irq fixes")
Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
Signed-off-by: Sharath Srinivasan <sharath.srinivasan@oracle.com>
[achender: port to net-next; update commit message]
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/send.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/rds/send.c b/net/rds/send.c
index 68be1bf0e0adf..ab3a8366c53bd 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -339,9 +339,17 @@ int rds_send_xmit(struct rds_conn_path *cp)
 			    (rm->rdma.op_active &&
 			    test_bit(RDS_MSG_RETRANSMITTED, &rm->m_flags))) {
 				spin_lock_irqsave(&cp->cp_lock, flags);
-				if (test_and_clear_bit(RDS_MSG_ON_CONN, &rm->m_flags))
+				if (test_and_clear_bit(RDS_MSG_ON_CONN, &rm->m_flags)) {
+					/* our ref is put after the batch */
 					list_move(&rm->m_conn_item, &to_be_dropped);
-				spin_unlock_irqrestore(&cp->cp_lock, flags);
+					spin_unlock_irqrestore(&cp->cp_lock, flags);
+				} else {
+					/* already off the conn list; drop
+					 * the ref taken above ourselves
+					 */
+					spin_unlock_irqrestore(&cp->cp_lock, flags);
+					rds_message_put(rm);
+				}
 				continue;
 			}
 
-- 
2.25.1

