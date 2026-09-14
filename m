Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8EA735CB6A;
	Mon, 14 Sep 2026 03:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789357042; cv=none; b=fWqCxSk/yhnihkSLZCD98II0V2l7IETNgaNY8nj/0bmaUx5mQr74h+o4n9yFu6+mP0+zC2JPQq3nSslv7OOJdYZYqF0kXHlZpAjhpNR0t9YKIYbSLtPny204iJIHWinsVc+0k3HebtEvTmJjFPorMgC13vrsev1vkUuQmSmBDNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789357042; c=relaxed/simple;
	bh=gSsQOOiJe3/j0wayn0ReIxXBK2Ak2SiyGoHj6v8qA8k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=d0JvLEPBAEh90bFVNU3BZ27EhH2+n+Utq0lR4jIhuRO/Ynst6ks/IcKUPDYQtF/KqcOSuqeMZBMWHiJWD7iTmoFUUFMq25DctmITHR5deV4MmHJE7xlUjW/SOIpGNq+rGFlHmQZZhx2u35ICYR3GBSGTcd8OOcFcjS4enOJ6G+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iqNZS0VQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iqNZS0VQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7194F1F0089A;
	Mon, 14 Sep 2026 03:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789357040;
	bh=tcZuXBXQwtXF3u8Cmlrjt51cRW5uBncnuJVhgmx/9mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iqNZS0VQrDmFH1UPFuAZh0I7F+bx0Q7QX4Ld/8nqBizsV8UguN2rcgE9haIy6TN3H
	 XdZwtic0C3/aN5vQgncN6MSELApxZCQBrq+eK+l2Ep4IH2+Ttxfwx3BRU+MK2pJl/d
	 Sc+zI7Z+BDQirdGZZ03b9uk3ozeDK1VDnCxSYp0g3UsNiNiiiOvCrHJMURugv/brqP
	 z4ec//FSgi6IOAG4sDdPCXD8yzQJmTr3hjRvgnLAX1Rok1zH7qKsLsg7FJwiP5eb9O
	 1K52Q9a9Wfk2Zk0KG70F7llcKLHsA5/OO52fiF1YZ0sIAP+fM/9FWYAhe4b13ogDP2
	 e7ehujCTgIgSA==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	nicoyip.dev@gmail.com
Subject: [PATCH net-next v3 01/13] net/rds: ib: don't enable interrupts in rds_ib_conn_free()
Date: Sun, 13 Sep 2026 20:37:07 -0700
Message-Id: <20260914033719.138057-2-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260914033719.138057-1-achender@kernel.org>
References: <20260914033719.138057-1-achender@kernel.org>
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

