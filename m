Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA9E3659FB;
	Thu, 30 Jul 2026 04:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785384993; cv=none; b=Dj32Hw7F/DGOWhVS9kiXmgqYsWBwGtIZv1uxnC673Vbk0u4VB5oN7hY04FOY9cNh0N83SHAkHbXBHvGgMXN3wyOpsA51o8PSHhV/GjhspkMh2hKDnpqZX+NxOnH5SaXVvZEw/nUeslauRjF8gvkNRsEywfeMNwg3f/qtRNC9PUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785384993; c=relaxed/simple;
	bh=wp4wUooO5IK7N31VP1EoRHI2LC7GQURI/ix6g0eCIXA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LFq6wH3TpEuqBOpFAywyeUk2uU777x0RclVfvIRTbb4sGvve2GHF2TidtGdAEM6QcdwwNlwAzC0EJ0YyJbEMMHa+OhHKsDdh7+4Pvo33zv1PFYf6pAShvd8SIvTCG7HYvW9inQYYZWEyuBwW3qE5jCAxBwIjZQx0orxEIPHjeZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KmO3yGER; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KmO3yGER"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83AC31F00A3A;
	Thu, 30 Jul 2026 04:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785384991;
	bh=gtzDh9JwokVJ4q8GNTmUyoz7oAyNJEo/jiywaxCyO88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KmO3yGERMlJwSka34b1FrkPXvTQ+qoQLfjBEX85Luh655ESCQaBHZeEONqEOtrasC
	 sqFK05c4jdFXc4lXza+JoiMkNdm2k//DLOVtioS9IE++Wo//Ne0Uod7M3qeh6thHrR
	 FOMHzCpf3oY+M2RvAAf34C+szwfZgHIYDsg4GIFK7zy48Kktxf/Dvo8nFeLdFCgVq8
	 pqtcaW898pbCuEGjD7aKd2fIpA31U8FjJcxzNQItw4b6x9L0XmKBVPo5fbUhSQXy6C
	 5V9pZmDaqTZF3EcGM1OOQQsvgIxv+An1QMouXbbXvg5LEo0myRaWRpyIdnA2TUYV0b
	 HjxJFL5SN0mFQ==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	jhubbard@nvidia.com,
	leon@kernel.org
Subject: [PATCH net v4 1/4] net/rds: don't use unpin_user_pages_dirty_lock() from atomic context
Date: Wed, 29 Jul 2026 21:16:26 -0700
Message-Id: <20260730041629.3512480-2-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260730041629.3512480-1-achender@kernel.org>
References: <20260730041629.3512480-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rds_rdma_free_op() and rds_atomic_free_op() are reached from the IB
send completion path via

  rds_ib_tasklet_fn_send()
    rds_ib_send_cqe_handler()
      rds_message_put()
        rds_message_purge()
          rds_rdma_free_op() / rds_atomic_free_op()

which runs in tasklet (softirq) context.  Both functions unpin the
user pages of the op with unpin_user_pages_dirty_lock(), which uses
set_page_dirty_lock() and thus may take the folio lock and sleep.
Sleeping in softirq context is not allowed and can deadlock or crash.

Dirtying the pages with the non-sleeping set_page_dirty() instead
would just trade one bug for another, as pointed out during review:
the pinned range can be file-backed.  rds_pin_pages() pins with
FOLL_LONGTERM, which refuses fs-dax but takes the page-cache pages
of a MAP_SHARED file mapping just fine, and RDS does not restrict
what memory the caller registers as an RDMA destination.

For a file-backed page, set_page_dirty() from a tasklet can take
non-irq-safe filesystem locks (e.g. mapping->i_private_lock and
inode->i_lock in block_dirty_folio()) and deadlock against the task
it interrupted.  Without the folio lock, it races with truncation
clearing folio->mapping, which is the race set_page_dirty_lock()
exists to close.  The pre-pin_user_pages() version of this code
dirtied pages that way from the tasklet, so that bug is older than
the sleeping unpin.

The page dirtying therefore has to move to process context, not
merely avoid the folio lock.  When the final rds_message_put() runs
in atomic context, rds_rdma_free_op() and rds_atomic_free_op() now
leave the op's pages pinned and flag the op. Later, rds_message_put()
hands the message to a work item that unpins the flagged ops' pages
and frees the message from process context. Here,
unpin_user_pages_dirty_lock() is safe outside the atomic context.
Everything else keeps running in the caller's context exactly as
before: the rest of the purge - the zerocopy completion, the socket
put and the MR reference drops - as well as RDMA writes, whose pages
the remote side only reads and which unpin without dirtying,
everything on rds_tcp, and final puts that already happen in process
context (socket close, connection teardown).

Deferring only the unpin means the work item touches nothing but the
pinned pages and the rds module's own memory: it cannot call back
into a transport module, so it changes nothing about the transports'
shutdown and unload ordering.  rds_exit() drains any pending unpin
work via destroy_workqueue(rds_wq) before the module goes away.

The Oracle UEK kernel avoids the sleeping unpin by calling
set_page_dirty() directly from the tasklet, which is subject to the
file-backed page problem above, so this deliberately does not follow
UEK here.

Fixes: 0d4597c8c5ab ("net/rds: Track user mapped pages through special API")
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
v1:
 - Initial port of uek net/rds: Avoid unpin_user_pages_dirty_lock()
   in tasklets
v2:
 - Addressed Sashiko complaints for file backed memory potentially
   causing deadlocks in an atomic context
 - Defer the final message purge to a work item instead of changing
   how the pages are dirtied; unpin_user_pages_dirty_lock() call
   sites are unchanged.
 - Author/SOB change from Gerd to Allison as this is no longer a
   UEK port
v3:
 - Addressed Sashiko complaints for deferred purges that may be
   requeued after the first flush
 - Flush rds_wq a second time in rds_ib_exit(): the deferred purge
   can drop the final reference on the op's device, which queues
   rds_ib_dev_free() back onto rds_wq, and flush_workqueue() does
   not wait for work queued by the items it is flushing. So the
   device free could still run after module unload.
   rds_ib_dev_free() queues nothing further on rds_wq, so two
   passes drain the chain completely.
v4:
 - Addressed Sashiko complaints for async purge ops racing with module
   unload.
 - Defer only the page unpin to the work item, not the whole message
   purge: rds_rdma_free_op()/rds_atomic_free_op() leave the pages
   pinned and flag the op when dirtying is not safe in the caller's
   context, and rds_message_put() queues a worker that finishes the
   unpin and frees the message.  The MR and socket references are
   dropped in the caller's context exactly as before this patch, so
   the deferred work cannot call back into a transport module and
   the rds_ib_exit() workqueue flushes are no longer needed.

 net/rds/message.c | 26 +++++++++++++++++++++++++
 net/rds/rdma.c    | 49 ++++++++++++++++++++++++++++++++++++-----------
 net/rds/rds.h     | 10 ++++++++++
 3 files changed, 74 insertions(+), 11 deletions(-)

diff --git a/net/rds/message.c b/net/rds/message.c
index 7feb0eb6537db..f25f2592586f7 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -182,6 +182,19 @@ static void rds_message_purge(struct rds_message *rm)
 		kref_put(&rm->atomic.op_rdma_mr->r_kref, __rds_put_mr_final);
 }
 
+static void rds_message_unpin_worker(struct work_struct *work)
+{
+	struct rds_message *rm = container_of(work, struct rds_message,
+					      m_unpin_work);
+
+	if (rm->rdma.op_unpin_deferred)
+		rds_rdma_op_unpin_pages(&rm->rdma);
+	if (rm->atomic.op_unpin_deferred)
+		rds_atomic_op_unpin_page(&rm->atomic);
+
+	kfree(rm);
+}
+
 void rds_message_put(struct rds_message *rm)
 {
 	rdsdebug("put rm %p ref %d\n", rm, refcount_read(&rm->m_refcount));
@@ -189,8 +202,21 @@ void rds_message_put(struct rds_message *rm)
 	if (refcount_dec_and_test(&rm->m_refcount)) {
 		BUG_ON(!list_empty(&rm->m_sock_item));
 		BUG_ON(!list_empty(&rm->m_conn_item));
+
 		rds_message_purge(rm);
 
+		/* A final put in atomic context cannot dirty the ops'
+		 * user pages on unpin, so rds_rdma_free_op() and
+		 * rds_atomic_free_op() deferred it.  Finish the unpin,
+		 * and the free, from process context.
+		 */
+		if (rm->rdma.op_unpin_deferred ||
+		    rm->atomic.op_unpin_deferred) {
+			INIT_WORK(&rm->m_unpin_work, rds_message_unpin_worker);
+			queue_work(rds_wq, &rm->m_unpin_work);
+			return;
+		}
+
 		kfree(rm);
 	}
 }
diff --git a/net/rds/rdma.c b/net/rds/rdma.c
index 61fb6e45281bf..f360a7b3b5fe7 100644
--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -483,22 +483,36 @@ void rds_rdma_unuse(struct rds_sock *rs, u32 r_key, int force)
 		kref_put(&mr->r_kref, __rds_put_mr_final);
 }
 
-void rds_rdma_free_op(struct rm_rdma_op *ro)
+void rds_rdma_op_unpin_pages(struct rm_rdma_op *ro)
 {
 	unsigned int i;
 
+	for (i = 0; i < ro->op_nents; i++) {
+		struct page *page = sg_page(&ro->op_sg[i]);
+
+		/* Mark page dirty if it was possibly modified, which
+		 * is the case for a RDMA_READ which copies from remote
+		 * to local memory
+		 */
+		unpin_user_pages_dirty_lock(&page, 1, !ro->op_write);
+	}
+}
+
+void rds_rdma_free_op(struct rm_rdma_op *ro)
+{
 	if (ro->op_odp_mr) {
 		kref_put(&ro->op_odp_mr->r_kref, __rds_put_mr_final);
+	} else if (in_task() || ro->op_write) {
+		/* An RDMA write's pages are only read by the remote
+		 * side; unpinning without dirtying does not sleep.
+		 */
+		rds_rdma_op_unpin_pages(ro);
 	} else {
-		for (i = 0; i < ro->op_nents; i++) {
-			struct page *page = sg_page(&ro->op_sg[i]);
-
-			/* Mark page dirty if it was possibly modified, which
-			 * is the case for a RDMA_READ which copies from remote
-			 * to local memory
-			 */
-			unpin_user_pages_dirty_lock(&page, 1, !ro->op_write);
-		}
+		/* Dirtying the pages on unpin can sleep; leave them
+		 * pinned and have rds_message_put() finish the unpin
+		 * from process context.
+		 */
+		ro->op_unpin_deferred = 1;
 	}
 
 	kfree(ro->op_notifier);
@@ -507,7 +521,7 @@ void rds_rdma_free_op(struct rm_rdma_op *ro)
 	ro->op_odp_mr = NULL;
 }
 
-void rds_atomic_free_op(struct rm_atomic_op *ao)
+void rds_atomic_op_unpin_page(struct rm_atomic_op *ao)
 {
 	struct page *page = sg_page(ao->op_sg);
 
@@ -515,6 +529,19 @@ void rds_atomic_free_op(struct rm_atomic_op *ao)
 	 * is the case for a RDMA_READ which copies from remote
 	 * to local memory */
 	unpin_user_pages_dirty_lock(&page, 1, true);
+}
+
+void rds_atomic_free_op(struct rm_atomic_op *ao)
+{
+	if (in_task()) {
+		rds_atomic_op_unpin_page(ao);
+	} else {
+		/* Dirtying the page on unpin can sleep; leave it
+		 * pinned and have rds_message_put() finish the unpin
+		 * from process context.
+		 */
+		ao->op_unpin_deferred = 1;
+	}
 
 	kfree(ao->op_notifier);
 	ao->op_notifier = NULL;
diff --git a/net/rds/rds.h b/net/rds/rds.h
index 6e0790e4b5703..14bff7440b796 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -445,6 +445,12 @@ struct rds_message {
 
 	void			*m_final_op;
 
+	/* Unpins the ops' user pages and frees the message from
+	 * process context when the final put happens in atomic
+	 * context: dirtying the pages on unpin can sleep.
+	 */
+	struct work_struct	m_unpin_work;
+
 	struct {
 		struct rm_atomic_op {
 			int			op_type;
@@ -468,6 +474,7 @@ struct rds_message {
 			unsigned int		op_mapped:1;
 			unsigned int		op_silent:1;
 			unsigned int		op_active:1;
+			unsigned int		op_unpin_deferred:1;
 			struct scatterlist	*op_sg;
 			struct rds_notifier	*op_notifier;
 
@@ -483,6 +490,7 @@ struct rds_message {
 			unsigned int		op_mapped:1;
 			unsigned int		op_silent:1;
 			unsigned int		op_active:1;
+			unsigned int		op_unpin_deferred:1;
 			unsigned int		op_bytes;
 			unsigned int		op_nents;
 			unsigned int		op_count;
@@ -972,6 +980,8 @@ int rds_cmsg_rdma_map(struct rds_sock *rs, struct rds_message *rm,
 			  struct cmsghdr *cmsg);
 void rds_rdma_free_op(struct rm_rdma_op *ro);
 void rds_atomic_free_op(struct rm_atomic_op *ao);
+void rds_rdma_op_unpin_pages(struct rm_rdma_op *ro);
+void rds_atomic_op_unpin_page(struct rm_atomic_op *ao);
 void rds_rdma_send_complete(struct rds_message *rm, int wc_status);
 void rds_atomic_send_complete(struct rds_message *rm, int wc_status);
 int rds_cmsg_atomic(struct rds_sock *rs, struct rds_message *rm,
-- 
2.25.1

