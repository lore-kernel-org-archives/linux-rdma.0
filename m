Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10483E3D8F;
	Sun, 26 Jul 2026 23:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785107093; cv=none; b=bZB0dGGuNL8BDQLcHZxbrRDrLdR3h5eEiWWNYV1eotNxnAb4L1ZAWjLg2ShHvnzpOcPmQ6vuXKOH22aezCPU0FSI1oeufpWem1O5rMrZyLKOFKO6gM4a65k9CuDunD2dbI083Tc/hmRqPCJVWZe9wXXqjBwsVVqtF1nEQJjfAg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785107093; c=relaxed/simple;
	bh=sWjKFPqZOPRx7N5vuKDD2kQi+m0V4oe7hra0rmnrmKk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ake7rJvEx7G3znl9N+aWQTZMB5KYQ4Jv775UFLwNQCqkYuGGGBwEFYxEK11wz/UgilD9IfsmLgbZL1dkKAFqrAsZBDeDvTrOupumokeIpKX+UGtimlRMitTqTqiQf1J0Oj/oEiLZKLmJ94u6fTVa4euLA/4bxTHATvmu2ygHhbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aeNXj3jv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aeNXj3jv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4D31F00ACF;
	Sun, 26 Jul 2026 23:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785107092;
	bh=KCcxZ1cVQ9qu1f5fHmanpmMJ3S40qoLeBMxgO+DvK4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aeNXj3jv9f+AzBx/7XcriKuc8/sopAN1OD/1n99tBzqPepzDc+SjfHq7YlfirDWaG
	 k8ytOiR3zMZAGcpgsfMymEz8WLGPJjtyX3Bn3D2DY2717mCPyckeZh9n0w177F4u1M
	 L4DBdXFT43dnKrKhcaZAhPbDYNpGQ7FH6za1KjOYHiDVdNKlkasGNQdCzCkE/lwkW1
	 bwD3G8yp6/Q6P4inz0HuVchTnNvZ/Z7lVVuAuv1P4j4aByqOeA67Nz0HN4Liqv6UOc
	 xWPseRcurPuyJDjIe87BtpY8riOGz8p3pXRxSAPxlX6EDzau+PSspMhFFYr9xMiOMB
	 5AdPAgytY/GHQ==
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
Subject: [PATCH net v3 3/3] net/rds: fix rds_message leak in the rds_send_xmit() drop path
Date: Sun, 26 Jul 2026 16:04:49 -0700
Message-Id: <20260726230449.2880446-4-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260726230449.2880446-1-achender@kernel.org>
References: <20260726230449.2880446-1-achender@kernel.org>
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
[achender: port to net-next; update commit message, checkpatch nits]
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/send.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/rds/send.c b/net/rds/send.c
index 68be1bf0e0adf..7e48f64dfaa67 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -339,9 +339,21 @@ int rds_send_xmit(struct rds_conn_path *cp)
 			    (rm->rdma.op_active &&
 			    test_bit(RDS_MSG_RETRANSMITTED, &rm->m_flags))) {
 				spin_lock_irqsave(&cp->cp_lock, flags);
-				if (test_and_clear_bit(RDS_MSG_ON_CONN, &rm->m_flags))
-					list_move(&rm->m_conn_item, &to_be_dropped);
-				spin_unlock_irqrestore(&cp->cp_lock, flags);
+				if (test_and_clear_bit(RDS_MSG_ON_CONN,
+						       &rm->m_flags)) {
+					/* our ref is put after the batch */
+					list_move(&rm->m_conn_item,
+						  &to_be_dropped);
+					spin_unlock_irqrestore(&cp->cp_lock,
+							       flags);
+				} else {
+					/* already off the conn list; drop
+					 * the ref taken above ourselves
+					 */
+					spin_unlock_irqrestore(&cp->cp_lock,
+							       flags);
+					rds_message_put(rm);
+				}
 				continue;
 			}
 
-- 
2.25.1

