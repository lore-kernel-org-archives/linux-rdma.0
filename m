Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5F4137750;
	Thu, 30 Jul 2026 04:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785384994; cv=none; b=i4OCXHI1ydjD2nZAhZyUi7wZNzCktelQSNj398aUNQdaPuhmYatuUunUDqp29E39S4XDbZTPzF6SUfGZ1hDIB13+11LCVOV28ahDkFFUE6+mCOc5BttnYdaXk2hkYa1rZ+ZCHgxADHtxCEolbLzsMox2TQiHY7Bk4nMVt49InLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785384994; c=relaxed/simple;
	bh=07kdtlFw9wNOrIkEjgIIW9YLHtpDdVhFsic5/D2l3WM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SG83sb/L0YyxSWIeVfLJ05kGUQhfiWm+vIP9LADVx+stKR4+mGXtI5JG6PsF/oyahO3oppbx20yFfQqjF1yamtATXYJaho3SYRUO1sLR2GE4nThnWiACh0oJsi6aGsa+S+ZKcZddJO5iynWdxpjHThbPzcYejDL1YA761Vrk75w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NrcdRBdb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NrcdRBdb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B629C1F00A3F;
	Thu, 30 Jul 2026 04:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785384992;
	bh=L/qzXF83G8+UPn4o/vj1fxX+hHXX9UKlpgJ6xh48j6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NrcdRBdbAOO5VwCSwB+NhdZ5hPF1x9OUiT6oP68wQY5OMxU5PnOOq+71hbzhvp0ih
	 Od3kjitMxhZx8MjeymeDkZrAkOKUX/ysf3Ui+8C/Ae7Ug9nS2lBMzULHXZpYGDIO5k
	 v4tODjMznpCI3KmLuFvija4NT3yy/mI5MVA6pO6Ohms7C0zkeGTWeDAk/5ZS7MDZ8w
	 NDp/GVisoo7OwpfsWh2Pp3ZIVK70OxOtPi6gl+CjahIYBhhHOYX4lhv4vIuBypaLfa
	 /qMLm4G9fJBkz58kr8a0/M7o729UCelZwk0WBLju8CuqB64qlxIqjW0yUL32YSD+mB
	 t60PIPYUXtDtQ==
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
Subject: [PATCH net v4 3/4] net/rds: fix rds_message leak in the rds_send_xmit() drop path
Date: Wed, 29 Jul 2026 21:16:28 -0700
Message-Id: <20260730041629.3512480-4-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260730041629.3512480-1-achender@kernel.org>
References: <20260730041629.3512480-1-achender@kernel.org>
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

However, if RDS_MSG_ON_CONN has already been cleared, the message is
not added to to_be_dropped and the reference taken above is never
dropped: cp_xmit_rm has not been set at this point, so the loop simply
abandons rm and the rds_message (and everything it pins: pages, MRs,
notifiers) leaks after an RDMA error.

The only other places that clear RDS_MSG_ON_CONN are
rds_send_path_drop_acked() and rds_send_drop_to(), and both can run
while rds_send_xmit() has dropped cp_lock between moving the message
to cp_retrans and re-taking the lock in the never-retransmit check:
rds_send_path_drop_acked() can ack away a message that already sat on
cp_retrans - the RDS_MSG_RETRANSMITTED case above - and
rds_send_drop_to() runs on socket close.  Both unlink the message
under cp_lock and put their own reference, leaving the xmit-path
reference stranded.

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

