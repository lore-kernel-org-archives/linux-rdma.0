Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E274F405A;
	Tue, 22 Sep 2026 16:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790095402; cv=none; b=eV9mq9UJE19qEExUhRKp+YUpSZ7aqASuFaTuo9OJMFBEpbaNiJrh9Vnf58KM4Yb34W/BIi7BPUkEaSXx+X/oi7uIOSBKMQcR4kPwB4tO4ZVgt2NqmToXki9Dd4Gd5opewlH7eDZZPQfoxpNcCvS6ScEtxmhpjh1UUCcBP54K/fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790095402; c=relaxed/simple;
	bh=4QmZWJAzwFEjnuV6EbDaLCnPfU1NzTQQtZjeo9J9tq0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mOahQZw9UqKbnPcfOTCffOzRoGT7ERpU/JVgrfuD725URkJ1Ho0kk1e0bI7os5+GRj2Q4x14cB6re7Nw+z63Alr29It2mn7nzuS8ztjs3aDF261T30jqQvjiNjPRMwrpsDgecKd2kZlljy/GDR/xfLTrMkrMtncZnBJm3FB24z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IkpcrDHt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IkpcrDHt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C93D1F00893;
	Tue, 22 Sep 2026 16:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790095399;
	bh=sorSo2zs/QZfjiBULji5OHCqjBdVi+uOeq02XJ7WQ8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IkpcrDHtdfCF+hhe1XyLXh0Rr5PvCQ7gNZOXg13wbb90Ku6c2jCihuTbBbPvSqZ80
	 i8nZ3EQk4FvhjkPFCYQmSKZEkznUypQXNGNeaHDaKoqR8uMR+GvsbGBnnarsKVK2By
	 eM2BWieJcnaGsTVOMKRYU7ZovLTvNQH5PrEwcRlGmyxJ7zKIqAUPrrmcvCTpW9X7Tk
	 4ynRv2KkN0XwqSK/Ohy9vQkK8hs3+z2Js6BoT94HujROCSNzPXP2/ZnIs5DaQHOKdk
	 qQHY6bTxpX5+r6sa17tkjCYBPFd2VY0AuRxWNQr8ibsk8AuLFH3y7VkWtaEzlBxibp
	 Klqjo3jaWl8VA==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v6 01/12] net/rds: ib: don't enable interrupts in rds_ib_conn_free()
Date: Tue, 22 Sep 2026 09:43:07 -0700
Message-Id: <20260922164318.447049-2-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260922164318.447049-1-achender@kernel.org>
References: <20260922164318.447049-1-achender@kernel.org>
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

