Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E458B46F482;
	Thu, 17 Sep 2026 07:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789630801; cv=none; b=fZo7Fx1t2LJ6rf6cAwTuVYg3B637mH1NwZZD+F2WF0o/Cy5sxZduXYsmPwEjoSS6B7f9X137hr9Ac5jOfw+2r5mo1LxR/zS7Dmv04A8hSN0ROj/OScsArdQoWgdi/C7oc6lR+FLbTP47rLq5FmLerFfSp8Uu9AUt5X8mHyZ5bXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789630801; c=relaxed/simple;
	bh=gSsQOOiJe3/j0wayn0ReIxXBK2Ak2SiyGoHj6v8qA8k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=o+wWbMfjd6d1QheaqBRD+t5LdR3SuwS7W3JTObfYZhkFq4xvcwodMV0jOuPTvbuEE2M7sEMluAATVPWRQhK5K6lzj/QztFO7wiM91CcjsHkmny/2bZeT3b1mbmtIwkbicw1mZsICKTDudxW0n+b9F3Va8pAlaEAM/SCr8Wfw79w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YFMSuZzo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YFMSuZzo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D461F00898;
	Thu, 17 Sep 2026 07:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789630799;
	bh=tcZuXBXQwtXF3u8Cmlrjt51cRW5uBncnuJVhgmx/9mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YFMSuZzovcrReZGa5/7l9Lzq7ZNIRyDvMcLtUSGLjU0ud22t3sM3r/J2ojQj2a4HQ
	 e3328G3DJUzdCVwrp1Gdsq75o8qSHd++i5bF9nCVEnPbAqkT5uT3DC9XXjuVftFMXa
	 6qaENS25JpQwHnyeT1GAHVS8B2X8C06KKJ3OxanPhWdE3d9dFCeuZ24Y6Z6XkX/P0z
	 GRB9E1gKtXY/Ra5TY6Oz/9Ln1GlnXoyQqb+fdrIlWFONG4Fr9yjE4pWbjlyM2hjq7h
	 CaHum9bZU3E5OAkDP7ReBnTUPi7Zn0YMqFsYgOiroKIPZKOD9wmrkuR8Pg8oMYxPxc
	 081FmukH6zIIw==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	nicoyip.dev@gmail.com
Subject: [PATCH net-next v4 01/12] net/rds: ib: don't enable interrupts in rds_ib_conn_free()
Date: Thu, 17 Sep 2026 00:39:47 -0700
Message-Id: <20260917073958.174056-2-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260917073958.174056-1-achender@kernel.org>
References: <20260917073958.174056-1-achender@kernel.org>
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

