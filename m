Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92744E4C4E;
	Tue, 22 Sep 2026 08:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790067254; cv=none; b=uYqIRkLU4FEAB7xTu4kfqjbKUeK1LsDmH9uVxRoxuzn0MLoEaPdYJ5O1//Y3Yxqx1q8HJWb/uHInIXgUtiuWEGbu5eXmix5+GzwZI/Mbd+bstRHm66iFiaKu3ugXo4zlJiNVBNDYTdT8OlSk+J4o6T+unCeQ42Whu7pKUI6UU5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790067254; c=relaxed/simple;
	bh=4QmZWJAzwFEjnuV6EbDaLCnPfU1NzTQQtZjeo9J9tq0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WcLm4Nf5WKTnbZ633f9iEGVECUBVFC/b4WJS5XfPBQ8+tVQPPHPojQZbczmlzv7wbpA1O5yhE87C3mCWzqMdXwJ+uU4HvzMNW25bzvb1ngzA1GfDeBLSSmtV8kpktj7s0RpDitJ1+hun1GK7vf+b1u8wZD3uMRE+hSbUB+D7s0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OCqaHnMq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OCqaHnMq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CECDB1F0089B;
	Tue, 22 Sep 2026 08:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790067252;
	bh=sorSo2zs/QZfjiBULji5OHCqjBdVi+uOeq02XJ7WQ8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OCqaHnMqivFwQTVBHW9eCWR1mPDF8ro5ISzRwPFDDHLbLXA2fqqSlyUT8P70AaAoO
	 TWok/6uAkZDfZ2FWGXWQ6y3+4fBj62iXW/ZEThapOHdroxn0FVIziBqcQnDeC4+/jP
	 xCnhTgb8Q1e1ACVKNeK6OpjeNzRNlCrsj/WPH0L7qUuYQlbJYGTXLOcfXHOE4vLnUu
	 k/uyA2dS8s4cfAAaURm20eFLwoRf9jcadjA6PVumCNPmFKnCjjFxmQEd2PSzSP75wA
	 t6NHE/jWmU4nfWi1aoZLNOpSOL6OkfhJmDt6PWWdi6PQBjdz6F1+Y0vkFIF1e8dFj7
	 FCtwb3NixmWcw==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v6 01/12] net/rds: ib: don't enable interrupts in rds_ib_conn_free()
Date: Tue, 22 Sep 2026 01:53:59 -0700
Message-Id: <20260922085410.391323-2-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260922085410.391323-1-achender@kernel.org>
References: <20260922085410.391323-1-achender@kernel.org>
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
index 6e3110a04ae6..53147793d44b 100644
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

