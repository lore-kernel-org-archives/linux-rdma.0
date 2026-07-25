Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659DC383312;
	Sat, 25 Jul 2026 08:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784968185; cv=none; b=K/T1dVFR+wf/YrxoWNQKFi8jQu6ey4Prie179I4qhbXMqFfIKWdieem9TVykbtS+CsT+EDyX0ynH3Q3Mcw7o+KaHvtNPUEEsWBZqZKVwB8yZjQTays5YU2bTt4TFXZ3nrajmJQNhRjfWG3vIYJiYr9/PInkFjL9YdAjILL9v0sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784968185; c=relaxed/simple;
	bh=sWjKFPqZOPRx7N5vuKDD2kQi+m0V4oe7hra0rmnrmKk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hdyPSRSoj8NIYHsM7WmRsosZcaR/sXd7Jj3fSNYvDWBrMc38OK8pBVtS9CLbLfuU1668RUOVCGituvR+XiaYZJW9BDJvVf7cc5LRBlbaB7KQ+XSWFASJ7qb4hSank01U3hlFVkZWAJtdDH2ryrLy2EyYgV+UHUJFOn3TPuG8VPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Az8FgJDA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Az8FgJDA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E71F1F00A3E;
	Sat, 25 Jul 2026 08:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784968182;
	bh=KCcxZ1cVQ9qu1f5fHmanpmMJ3S40qoLeBMxgO+DvK4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Az8FgJDAhZEdJSpC9iLKXI4WF/2xVxI932FyAI3kI5vT8E4vNrFp8daXIu97+spXG
	 vcvR/fzRbpqs7UjLDGuGojMP6weE1fQOH+xDG5kCdPb0ivYA9qt2t5O2yRfhufxW3h
	 zYU1CF/Ce52zyMg8T+2AS7xDsinUWESz6yp0v2PLZ3vWYc6Uw4BM6VGQObSY0uAE4V
	 Nt89TLKjwFZUWchTt6rS+KRkAFhUhT9ftrn/kHTAcLtvU1GCa/U9zS+oYzMJAc95+r
	 JubnyTO1F8JP+vcNCC6rFjyJ7cg8hokkbuCgUfq1HXQQmsrDEYEkd6v8apjhR5IadI
	 6LZSIz5cUsJWQ==
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
Subject: [PATCH net-next 3/3] net/rds: fix rds_message leak in the rds_send_xmit() drop path
Date: Sat, 25 Jul 2026 01:29:39 -0700
Message-Id: <20260725082939.2546624-4-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260725082939.2546624-1-achender@kernel.org>
References: <20260725082939.2546624-1-achender@kernel.org>
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

