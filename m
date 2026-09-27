Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D7936EAA4;
	Sun, 27 Sep 2026 06:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790489691; cv=none; b=YWFAcbgAGptvp8G6HQDtpMD13SIuHGWE7H1lxPT7fCcxmPQ2i8cdvppKWWaNw7udR3eLRePinm8I00pxHgNA431cFABuXMFErvh6F3opickRV1AdwkIRP6Uao4Sxi3XZcrphe9fwKHpOrlZ3P22NQvoFXyFqbRc31Dwmxi61Poc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790489691; c=relaxed/simple;
	bh=comsLVPHsU5OxVKlp42KITkfSYQD10tWfxSzA7IN+jA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TbIhsOcWOWDQO9cJKg2QimAQLRaQarpWouf5o0xulJh/bshGoLHxQ/JUOwl6W/pycud2JGtpBCJv9utkrY77fgjHW06kKvQoD2wof3LOS+TinMcrbiChQP97AdL9dUPVrv9BvuBa6N5VIFVDwNvBAQFCZt6mNgN/r/x8cjhM/ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rb3KktVT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rb3KktVT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9727E1F0089A;
	Sun, 27 Sep 2026 06:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790489690;
	bh=vVlq7AGgtQA5d1zJnVEqfhJKEgf5MH3sJAfczGHhQLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rb3KktVTlx0cLWxyvq9wRyh+TliILLoa1V5rW+y5z5UdI+z59QUE+miRnLk0Q+vzl
	 TrudUVI+4tPJywWAOZ0mVUB2w6l0DAUr83nfCQNHjOV6Plh14+89X8BdWGPqqflrmd
	 WCSegFKEnK/+NiQjej3aLiZvqRDj8kq0/ZP7UFmdOHUNQTuKLjjtvWEoPK/Z5N5/X3
	 qvrQZfhtkXtmSA8W3FA1UygGj7t7hyDP0sFBjKNitJrRc1GnmW7r+pHZ2izALCrQYX
	 ZKZiDr/jpm/VR+Fh2t6C2g9Xwynk8LCtUfc/YPHrY01uFmMoGs+6OeyY1URPFz84Bc
	 t2TbanbNCc4GQ==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v7 01/12] net/rds: ib: don't enable interrupts in rds_ib_conn_free()
Date: Sat, 26 Sep 2026 23:14:37 -0700
Message-Id: <20260927061448.167862-2-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260927061448.167862-1-achender@kernel.org>
References: <20260927061448.167862-1-achender@kernel.org>
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
index 3ebe13d00953..74d384f0c323 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -1272,6 +1272,7 @@ void rds_ib_conn_free(void *arg)
 {
 	struct rds_ib_connection *ic = arg;
 	spinlock_t	*lock_ptr;
+	unsigned long flags;
 
 	rdsdebug("ic %p\n", ic);
 
@@ -1279,12 +1280,16 @@ void rds_ib_conn_free(void *arg)
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

