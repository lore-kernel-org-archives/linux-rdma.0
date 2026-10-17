Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D0F371046;
	Sat, 17 Oct 2026 03:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792207402; cv=none; b=dribmtPcF4mIMMG4XNIVXJgirLnTleZ6px8FsmlXVnXG8ZNzYuQ/aWUlYxXq9m6zNd1n/FNQ0gFIz7QsxsM3Fx+sFrQFqhf6xzMOel/HSr56GfNhY7dhrAKel/pYGqKyKFE9DjxlZ8+9eH/y0mSqJ7gB5iXRLAKgM06vFAWh2EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792207402; c=relaxed/simple;
	bh=hzXgFuPifWckY9ekxb7BAa7n8RR9pmymQ+Io4K8EJ6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQnnD2Dz3coUgoWKz5r88y/dk5Bst2AOCBkYGQf9flDlbO7mX6vM2HOxP4pR6wmwDhEyytZ5UHnyToSYXCJj4iuaIy2n54gfIO9Xj0ZYN2dRq6MKNq86OgkMPqOQ1r7rf1UcFktap8FytgpnJOONSArE4Eq92Tru1MFRpzn/oa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sum1APRO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sum1APRO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7611A1F000C8;
	Sat, 17 Oct 2026 03:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792207400;
	bh=kBvng+c+tObNsvSH1u3T3u0ihG5rc3ji5f0o2qQSV60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sum1APROkkq/glbxMavLVlZ4JxGv/9hqdnkcI7ckg0bcENsiiRHZ+eGoCK1AsXY0Q
	 qdEDtOMdrqXz4iLakwkrEWW9R90rYB6Gy7XN8OdQRGKCA1hTfrB2nu4613tIUiePJG
	 OVFgZ/YFATYtJj6u/87o62Kd8UByYaWleyFEvhldK9j352zvK3vIRDI3E1ue5Dcb8M
	 CxpLfZglrifcCu/gOQSnI2gB6Ee4H4nH3Le2c8xu6UYEHz6sJS0p2A3cNsTP1rCftx
	 ovqlOesNZ8SHmBkb1NPPemnbrcLAQPv6xeUDV4oXAuoX33HkjNutJnj4sFEye3hjBD
	 yvEuLAPlrq0pw==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v10 01/13] net/rds: ib: don't enable interrupts in rds_ib_conn_free()
Date: Fri, 16 Oct 2026 20:23:07 -0700
Message-ID: <20261017032319.2563014-2-achender@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261017032319.2563014-1-achender@kernel.org>
References: <20261017032319.2563014-1-achender@kernel.org>
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
Reported-by: syzbot+c3741bb338b5c6d6a4aa@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c3741bb338b5c6d6a4aa
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
2.50.1

