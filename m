Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E252A332EBD;
	Sat, 19 Sep 2026 06:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789798312; cv=none; b=jGpMi+Z50JkKyB76jxAREzCakSuNOz8aQyNvbFaFrpL0GPIamWSpdTfgCE+FVcHEJ9wFa3V8Cg4sAsAfjQzTmbx9KiBm5qxXaxT78Gv1j1LpjYXdw0pf7Wjh7hv9JjOyAPfaFW8B3FRx6RJ/fjTkvwqHiS7PXWDSyDciGMxLFEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789798312; c=relaxed/simple;
	bh=gSsQOOiJe3/j0wayn0ReIxXBK2Ak2SiyGoHj6v8qA8k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=D3MgmAcyalqX71l3C0nEcX4Bn0kpeVL86nLUytxpInDKx11jmwshM+MPEmE7iNYwbZHzr5+oNx0Z+NQrfVlsFRFZLzaEglA8IbbnqNXLtx8QvwSewLQ8xUTsLSMZgqmRs/ig5VkSbeqFM261GtCHr0tsB5sAQx2LqnuxSVsoQiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FooGCTzv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FooGCTzv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8801F00899;
	Sat, 19 Sep 2026 06:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789798310;
	bh=tcZuXBXQwtXF3u8Cmlrjt51cRW5uBncnuJVhgmx/9mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FooGCTzvjsFsSlB1uHJn/NP1MlqsFx5SrSUOLk1qwz90xKXN5UjHVzgA9lko1gFr7
	 +oOcCDioMracXxV1PD8FezwpywwBk6NVcfxV+mGMjchW77lAFQPvSvDBIapZxArZkp
	 aKuu0if37Jb0ZcVPKcO4KL0yFd8YhABwVvLyjz/NDfPpbVjk8HxjkIdAHiDT6E4Yr+
	 kdVXoSa2ixDZ0xzlECZtm3UuZXn2qpz8vg1srDOHvTrc5owK/cbpROhqgerO/PQkOB
	 ZqODd0U9JFvyOjgWeeOKJBdTS7MPjP+hOXNMy9pYFIFfkc6Sw4OxXV8Ci3QNajDfVx
	 m356gx2HgXzsg==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	nicoyip.dev@gmail.com
Subject: [PATCH net-next v5 01/12] net/rds: ib: don't enable interrupts in rds_ib_conn_free()
Date: Fri, 18 Sep 2026 23:11:38 -0700
Message-Id: <20260919061149.250658-2-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260919061149.250658-1-achender@kernel.org>
References: <20260919061149.250658-1-achender@kernel.org>
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
index 4feb0edc360c..118e033229aa 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -1271,6 +1271,7 @@ void rds_ib_conn_free(void *arg)
 {
 	struct rds_ib_connection *ic = arg;
 	spinlock_t	*lock_ptr;
+	unsigned long flags;
 
 	rdsdebug("ic %p\n", ic);
 
@@ -1278,12 +1279,16 @@ void rds_ib_conn_free(void *arg)
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

