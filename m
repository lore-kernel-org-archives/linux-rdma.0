Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2799B21CFE0;
	Sat, 11 Jul 2026 02:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783738281; cv=none; b=oWZE79bern69mWt1u85EcQJ9gni1O/arm0QBc/ccx9cRIY7MQXLMGqQ1Y+QafGyYcZKB0t08fmL2wNbKj7LA59RDsVwlXNNOJLu5gSbjqd0Jfm+hZ+qcTwfDveGgqQFaI0kpK4P8dKUHJKJjHxWwuzXSmzBl69DFCGpwdJI+Ql8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783738281; c=relaxed/simple;
	bh=ZA48Y6HGqpL0RDnhC1KrUI3PvvSkcYWXkZjI/aDpMsA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PGqjIj49nqB2yS89ThAN8aPI+gpMDoISCD3uF8lz3SmCwac67LN9l9k0LD1flaDNYXlPF47IEoN5Za/3nZQlHj84tvaiXE2TnUk7PRRMXV/MP2GJ4wQJf92slEYukfRU0Q4RPyC0Omtx3MrYkSAH7fP09ZJsvvdAPCDafGB1SIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FBqaY8/S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FBqaY8/S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DC661F00A3F;
	Sat, 11 Jul 2026 02:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783738279;
	bh=wjApoo0/PDCucDME3t/BTZ8GpfnoW7uI8esTbnRqYAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FBqaY8/SayauOw/j3irouIteFCbFMFXKP7aunaqVtTzdEhrt8o3YT6Gu+dcFXhvJu
	 /KGACxPVpJn/a09POXey37QrDVRnccaw8frS2f33IYGUYUBcm2PHFYrV+0R0co2a2C
	 Ch+s1z296/8NzX/UlMQgi+iJM/+6cvJi7joopzlwquSP/Wr2TZDamIA9/SeP77g0Gf
	 9ozhvijsi7xe202vetkcB9bFO97VGfX8AlLy8feOUuxkvARXd4hZOLoDYqGT2pWLKt
	 qVQ3sWujdQ/Zy3S/zWjc3bQz7CfUgr8dYip12HlKA51CjhvupCwbFVcKV9AxrDrUbR
	 IIJFHGETMP6gg==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net 1/3] net/rds: don't use unpin_user_pages_dirty_lock() from atomic context
Date: Fri, 10 Jul 2026 19:51:16 -0700
Message-Id: <20260711025118.2449428-2-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260711025118.2449428-1-achender@kernel.org>
References: <20260711025118.2449428-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gerd Rausch <gerd.rausch@oracle.com>

rds_rdma_free_op() and rds_atomic_free_op() are reached from the IB
send completion path via

  rds_ib_tasklet_fn_send()
    rds_ib_send_cqe_handler()
      rds_message_put()
        rds_message_purge()
          rds_rdma_free_op() / rds_atomic_free_op()

which runs in tasklet (softirq) context.  Both functions unpin the
user pages of the op with unpin_user_pages_dirty_lock(), which uses
set_page_dirty_lock() and thus may call lock_page() and sleep.
Sleeping in softirq context is not allowed and can deadlock or crash.

Dirty the pages with set_page_dirty() and release them with
unpin_user_page() instead, the same way this code handled the pages
before the conversion to the pin_user_pages API.

This mirrors Oracle UEK commit "net/rds: Avoid
unpin_user_pages_dirty_lock() in tasklets".

Fixes: 0d4597c8c5ab ("net/rds: Track user mapped pages through special API")
Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
[achender: port to net-next; omit UEK's WARN_ON_ONCE(!page->mapping &&
 irqs_disabled()) debug check; update commit message]
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/rdma.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/rds/rdma.c b/net/rds/rdma.c
index 61fb6e45281bf..201cbe38fa893 100644
--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -495,9 +495,13 @@ void rds_rdma_free_op(struct rm_rdma_op *ro)
 
 			/* Mark page dirty if it was possibly modified, which
 			 * is the case for a RDMA_READ which copies from remote
-			 * to local memory
+			 * to local memory.  This can be called from the IB
+			 * send completion tasklet, so the sleeping _lock
+			 * variant must not be used here.
 			 */
-			unpin_user_pages_dirty_lock(&page, 1, !ro->op_write);
+			if (!ro->op_write)
+				set_page_dirty(page);
+			unpin_user_page(page);
 		}
 	}
 
@@ -513,8 +517,12 @@ void rds_atomic_free_op(struct rm_atomic_op *ao)
 
 	/* Mark page dirty if it was possibly modified, which
 	 * is the case for a RDMA_READ which copies from remote
-	 * to local memory */
-	unpin_user_pages_dirty_lock(&page, 1, true);
+	 * to local memory.  This can be called from the IB send
+	 * completion tasklet, so the sleeping _lock variant must
+	 * not be used here.
+	 */
+	set_page_dirty(page);
+	unpin_user_page(page);
 
 	kfree(ao->op_notifier);
 	ao->op_notifier = NULL;
-- 
2.25.1

