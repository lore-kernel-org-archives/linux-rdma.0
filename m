Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C543A5E78;
	Thu,  8 Oct 2026 03:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791429215; cv=none; b=e4ytTyqYKoTQHGKv+y8DzjwWjoA1uoezBgxD6sG+cfZIgNyPot8aaIsfYRxzqV8Qa8zc+q4VkAh646I4ZZzrvLNlOGe6u/YwD8ns1vyL9R32uNwC3UA2x/A6d18IAdFY3xbTQ7zDaMpw6iCDcUu0FCJvpXnGVkIZo6gl9KEOyag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791429215; c=relaxed/simple;
	bh=gjRkN5qnlxpQ9XjGtlQfPH0VDvsJCedDlZpsmFUax44=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JADKZJDyH+9DIOmU7njL2BhuEPqLzbLridO3GRAShIdueeqg1lQ8UhO20vztv+vbeBPKRcybDNKm8C0W8XnGNI2fgaYKtwjFgGJVCcsDEsqB5gaWWq13SU4Zdnlb+XVYl3fTgosQ5tuWZOJGubAkDotKrz9WvLxpnM6xS3aqHSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=APx4vwu1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="APx4vwu1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CFAB1F00893;
	Thu,  8 Oct 2026 03:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791429214;
	bh=rHpcinbcYaaeiadUswEo4BWdm3yOeziGxP4H7pIKtHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=APx4vwu1fQLSatHmVf0GbsWb5XCwQO68OqT21OthKgUz40WD+pp6Kw085NbTU32UR
	 5PVOo8oP93pShEDzLbS913/tDfWX8hg5OUmNHrDCP1jzTQ65X6E/7NhiQfPd1x61Z/
	 EAOoHjn2lFr2KGus4qffLUWbtvAPjJk5/vqorUykowsIGHMiqj8d3QpfOpSnVL/PrA
	 XeFJLFGMfsczXmMd7RSNziftKaMcNrcCqutRxT4Q5OGSz4IxKuXhT2IsoFemu52540
	 UO4/UmTNkFFErFBqQ+jAv19oyqMnWiLFoOYB9GkuK0rAizV97N5t4t44ANm19bl72+
	 y8zS5OGtPlDGw==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v9 01/13] net/rds: ib: don't enable interrupts in rds_ib_conn_free()
Date: Wed,  7 Oct 2026 20:13:21 -0700
Message-Id: <20261008031333.1142174-2-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261008031333.1142174-1-achender@kernel.org>
References: <20261008031333.1142174-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rds_ib_conn_free() unlinks the connection from its device or nodev
list under spin_lock_irq()/spin_unlock_irq().  It is not only called
from the rmmod path, though: __rds_conn_create() calls
trans->conn_free() to undo a lost creation race while it still holds
rds_conn_lock, taken with spin_lock_irqsave().  The unconditional
spin_unlock_irq() then re-enables interrupts with rds_conn_lock held
and leaves them enabled when the caller's spin_unlock_irqrestore()
runs, defeating the irqsave the caller relied on.

Use the irqsave/irqrestore pair, as rds_tcp_conn_free() and
rds_loop_conn_free() already do.

Fixes: 745cbccac3fe ("RDS: Rewrite connection cleanup, fixing oops on rmmod")
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/ib_cm.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index 3ed03ad32812..8b16bd7c40ce 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -1284,6 +1284,7 @@ void rds_ib_conn_free(void *arg)
 {
 	struct rds_ib_connection *ic = arg;
 	spinlock_t	*lock_ptr;
+	unsigned long flags;
 
 	rdsdebug("ic %p\n", ic);
 
@@ -1291,12 +1292,16 @@ void rds_ib_conn_free(void *arg)
 	 * Conn is either on a dev's list or on the nodev list.
 	 * A race with shutdown() or connect() would cause problems
 	 * (since rds_ibdev would change) but that should never happen.
+	 *
+	 * Callers may hold rds_conn_lock with interrupts disabled
+	 * (__rds_conn_create() undoing a lost creation race), so do not
+	 * re-enable interrupts unconditionally here.
 	 */
 	lock_ptr = ic->rds_ibdev ? &ic->rds_ibdev->spinlock : &ib_nodev_conns_lock;
 
-	spin_lock_irq(lock_ptr);
+	spin_lock_irqsave(lock_ptr, flags);
 	list_del(&ic->ib_node);
-	spin_unlock_irq(lock_ptr);
+	spin_unlock_irqrestore(lock_ptr, flags);
 
 	rds_ib_recv_free_caches(ic);
 
-- 
2.25.1

