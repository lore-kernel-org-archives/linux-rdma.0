Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53A735028D;
	Sat,  3 Oct 2026 16:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791045137; cv=none; b=OMWNGqFOZowAVBehf5Sy+tx0U1YuNfdzqkgPQOUWQr5sba1nZ1xV2OhtMMPknIpMEJK5p+5+q0NBbuZ9CbTVMbEefDJdX0igLy+LlwcMlaJw9qr7TIZnhZcCTTO2/JvvQ7Y01DLJDmvx04P39qCA5zlLTKOSl9ddUxFKzjgPK54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791045137; c=relaxed/simple;
	bh=gjRkN5qnlxpQ9XjGtlQfPH0VDvsJCedDlZpsmFUax44=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WCOmgS9RNHO6HMGACs9M6gZBiRxK0xJg1qntM1jS5s/0EZ91W6QQh5LtdBDv/IjvN6qQI2m9+Bv9Mdu9ZTIUtEeVOzz+yI5fMXVSXTDXshchMxuqyZWRdx6qMuqHVKwSbxR0x6X4mh+qJu/NfFxV0TDXSGAgmKPhBZQg6KoR8QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pz9EDJeb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pz9EDJeb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BEC21F0089C;
	Sat,  3 Oct 2026 16:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045136;
	bh=rHpcinbcYaaeiadUswEo4BWdm3yOeziGxP4H7pIKtHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pz9EDJeb4p50JVmOpH9F9WFcYOR3jLjPHPzrU7MKgHigAwExHiFkpuKMpGNJJsKc0
	 qcahKgbg4qabNW0YS0oNNkimTk/ckDvImudHqznIaWOMNRelSD3lxWbemp/KX6O1OS
	 0I+yQywsyXxFyIQ+3RhzpvQLgjoDlUrHP9+tEXegMxtnXQa+thtxgfuv3wkY1tY04V
	 mAlXheOguBL0D5o9fKcpFbbr6W8vsQSKagJctOWh/86SUp9/3Iz0nzeTIgI4oi7rJG
	 qxHER61E3ILbJEgLWeye+4eGqPreWvU3riK/7g363UUIAn9iUStBi92wRG5Rv9jaRk
	 f8nu+nxW/E90A==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v8 01/13] net/rds: ib: don't enable interrupts in rds_ib_conn_free()
Date: Sat,  3 Oct 2026 09:32:03 -0700
Message-Id: <20261003163215.250253-2-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261003163215.250253-1-achender@kernel.org>
References: <20261003163215.250253-1-achender@kernel.org>
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

