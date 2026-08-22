Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7849230566D;
	Sat, 22 Aug 2026 05:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787376302; cv=none; b=ehW193+V977O4mKFE4En7+SP1rn/PDZhwKGc7EU0dx4kEt2y+jGMMyfiyKvR+xcvw1fmBX92qeIqeQUBTu5/Aa1HNTBa3qNmYOl6lpN38KqoV/YkX/4R9xAdwAkfM9u4wKFooC2BrU1nWJL3X4WE3485wyhZvIv5YzqZhwG6Zns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787376302; c=relaxed/simple;
	bh=mt2Xg+eBQiPmZxAcVQtN4fGlLb/Eh6ZY/lYKS5zx+v4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HuuIZskSuG6UBJbdIpCOuQYJi+fBOdEJb2vspATaTRicPs8OaTZkqfBA/aIj+B8OOJ4/gGJmgVHApfFEJ5jB3J3QUbaOzk0mFoDaAYeyVujT9VE4AJCNtCXs2d3q6Psco1GAyc8ChMA9UqyAeuWVKI1AJrGDtCm+rnIPyh7zu/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VOviTrjX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VOviTrjX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D597C1F00A3D;
	Sat, 22 Aug 2026 05:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787376301;
	bh=WrxZXYDQSCaaLdiFxe6P5cFFZC053cuH9qY49ZMD9N0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VOviTrjXK4KuuoGV769qBO0+BNcX4PRLs3w/wzc2uoglJlTQxu7wDBqZqxXB0gQ0C
	 mg97H8+/gpOB0A3LydTNSruYAokBaNe8KyMF0NAUAPP4mSObso5QL4+r5HcXmEekZf
	 Y/ao+a0oApZTxdCcAF5tok7YFfMZXUUYR9RkDDcnlShC13POiCqlxzbymhJ+zmSd+M
	 IgBB/lIkTS/FKir7VSMEvMcvCiotH7N0sjZpDcP6Y7x3nE53JjdBRpzOTf6oW0xXkt
	 r7fs62pFrpA3br96gOwohOMTY8vmlQyTrKbgTiQ0nlq4ZBK44h7VOIMSwQkcWSlXO2
	 nrut+hoxzl5LA==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	jhubbard@nvidia.com,
	woni9911@gmail.com,
	michal.kubiak@intel.com,
	leon@kernel.org
Subject: [PATCH net v3 1/5] net/rds: use wq_has_sleeper() in release_in_xmit()
Date: Fri, 21 Aug 2026 22:24:55 -0700
Message-Id: <20260822052459.88017-2-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260822052459.88017-1-achender@kernel.org>
References: <20260822052459.88017-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

release_in_xmit() clears RDS_IN_XMIT with clear_bit_unlock() and then
checks waitqueue_active() to decide whether anyone needs waking.
clear_bit_unlock() is only a release operation: it orders the
critical section before the bit clear, but does not order the
subsequent plain load of the wait queue head after it.  The waiter
side does the mirror image - it adds itself to the wait queue and
then tests the bit.  That is the classic store-buffering pattern: the
releasing CPU can read the wait queue as empty while the waiting CPU
still reads the bit as set, so the sleeper is never woken.

The waiters are rds_conn_shutdown() and rds_tcp_reset_callbacks(),
both in uninterruptible wait_event() with no timeout.  A lost wake-up
strands the shutdown worker on its single-threaded workqueue until
some other sender releases the bit again - and on a connection that
is being torn down precisely because it failed, there may never be
another sender.

The barrier used to be there: release_in_xmit() did clear_bit()
followed by smp_mb__after_atomic() until commit 1422f28826d2 ("rds:
introduce acquire/release ordering in acquire/release_in_xmit()")
folded both into clear_bit_unlock(), which strengthened the lock
hand-off but silently dropped the full barrier the wake-up check
depends on.  The refill counterpart, release_refill() in
net/rds/ib_recv.c, still carries its smp_mb__after_atomic() for
exactly this reason.

Use wq_has_sleeper(), which is waitqueue_active() preceded by the
required full barrier.

Fixes: 1422f28826d2 ("rds: introduce acquire/release ordering in acquire/release_in_xmit()")
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
v3: unchanged
v2: unchanged
 net/rds/send.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/rds/send.c b/net/rds/send.c
index 15a1b97f13e7..8aad185e4b1a 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -114,8 +114,13 @@ static void release_in_xmit(struct rds_conn_path *cp)
 	 * hot path and finding waiters is very rare.  We don't want to walk
 	 * the system-wide hashed waitqueue buckets in the fast path only to
 	 * almost never find waiters.
+	 *
+	 * wq_has_sleeper() supplies the full barrier that orders the wait
+	 * queue read after the bit clear; clear_bit_unlock() alone is only
+	 * a release and would let this check read a stale empty queue,
+	 * losing the wake-up.
 	 */
-	if (waitqueue_active(&cp->cp_waitq))
+	if (wq_has_sleeper(&cp->cp_waitq))
 		wake_up_all(&cp->cp_waitq);
 }
 
-- 
2.25.1

