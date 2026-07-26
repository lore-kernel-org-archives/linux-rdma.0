Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F00B34F474;
	Sun, 26 Jul 2026 23:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785107092; cv=none; b=eN75qxK1K6/JA61Ae9GtLC/WtC4ZwVMSAXB+a4CbdSSSCKt14LWiOeAi1lD2wnauIzSMUcw9OhJUGRE4GW8y3+UQjTzl5eoUHBqJgMdf076fg39FDyGWhkliDfl0Kyb69dRstrYUqoRy7/ieYbBfRpqg51Wps6+uZIfU1tjt4rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785107092; c=relaxed/simple;
	bh=kuq7Xdl561fDXUtJouMJKIyqyrJw3FuTjk0sW8MdMEc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FwPP+uKP6ITOdr4o7zAA4fv2z+awendFSuD+rmdKvsscY2TvuC5qXubHrpP2O/yRcxSGLfYjRDchnk+Uubx80yQnj9eADK54uIZpVRmtonbrWBFkB1cJTiY4g8vKawT7wG3+paZltQwID0tO55z5i9qrgmRsxwAz9ZvZEewV0pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I+lntu0y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I+lntu0y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915E41F00AC4;
	Sun, 26 Jul 2026 23:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785107091;
	bh=QhPUgi8fikExKcFNVtzQJeN5/u/j+eK6kQ28fU9sXlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I+lntu0y3oUCUt8canQoAxQW4lMQzKFeEnYjlK2QhaGC8yMlmbAVwJn3LIxxDI6EV
	 r1nliJDE9Pc0ce9r2iPTS/LBMMr4nHb1vCCpH4wM35Nq0OqTiUGIl5lMijSwcLnbgi
	 cKUT/gHuafMscxbgLGsx1H1gblgjCMxPoRmAH45SYj9hQrDNQoU/gVbsurgRB5oJob
	 2ffCOemhTftlB+AgWyfoUvdbVQFwSEFKm3CWdEm9KnkpEMLbObLwJM7wfGHlzxcC4r
	 LLGcMTjjURmczemJMBXRS+cleo7sMCUOcLEMjTSsw5PmL358khF8y4v+YspbG0P9bz
	 TdUf0X9c8RMKQ==
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
Subject: [PATCH net v3 1/3] net/rds: don't use unpin_user_pages_dirty_lock() from atomic context
Date: Sun, 26 Jul 2026 16:04:47 -0700
Message-Id: <20260726230449.2880446-2-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260726230449.2880446-1-achender@kernel.org>
References: <20260726230449.2880446-1-achender@kernel.org>
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
what memory the caller registers as an RDMA destination.  For a
file-backed page, set_page_dirty() from a tasklet can take
non-irq-safe filesystem locks (e.g. mapping->i_private_lock and
inode->i_lock in block_dirty_folio()) and deadlock against the task
it interrupted, and without the folio lock it races with truncation
clearing folio->mapping - the race set_page_dirty_lock() exists to
close.  The pre-pin_user_pages() version of this code dirtied pages
that way from the tasklet, so that bug is older than the sleeping
unpin.

The page dirtying therefore has to move to process context, not
merely avoid the folio lock.  When the final rds_message_put() runs
in atomic context and the message has an RDMA or atomic op whose
pages need dirtying, defer rds_message_purge() and the free to a
work item on rds_wq, from which unpin_user_pages_dirty_lock() is
safe.  Messages without such an op - everything on rds_tcp, and
RDMA writes, whose pages the remote side only reads - are freed
inline as before, as are final puts in process context (socket
close, connection teardown).  The unpin_user_pages_dirty_lock()
call sites themselves are unchanged; what changes is the context
they are guaranteed to run in.

rds_ib_exit() flushes rds_wq after all connections are shut down, so
a deferred free queued by the completion tasklets cannot call back
into the module through the op's MR after unload.  The deferred
purge can itself drop the final reference on the op's device, which
queues rds_ib_dev_free() back onto rds_wq - and flush_workqueue()
does not wait for work queued by the items it is flushing - so
rds_ib_exit() flushes twice.  rds_ib_dev_free() queues nothing
further on rds_wq, so two passes drain the chain completely.

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

 net/rds/ib.c      | 12 ++++++++++++
 net/rds/message.c | 34 ++++++++++++++++++++++++++++++++++
 net/rds/rdma.c    |  9 +++++++--
 net/rds/rds.h     |  6 ++++++
 4 files changed, 59 insertions(+), 2 deletions(-)

diff --git a/net/rds/ib.c b/net/rds/ib.c
index 8f9cf491984f1..ad2f038bd1ac4 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -541,6 +541,18 @@ void rds_ib_exit(void)
 #endif
 	rds_ib_unregister_client();
 	rds_ib_destroy_nodev_conns();
+
+	/* The completion tasklets may have deferred message frees to
+	 * rds_wq, and those can call back into this module through the
+	 * op's MR.  Drain them before the module goes away.  A deferred
+	 * purge can drop the final reference on the op's device, which
+	 * queues rds_ib_dev_free() back onto rds_wq, and
+	 * flush_workqueue() does not wait for work queued by the items
+	 * it is flushing.  Flush a second time for those.
+	 */
+	flush_workqueue(rds_wq);
+	flush_workqueue(rds_wq);
+
 	rds_ib_sysctl_exit();
 	rds_ib_recv_exit();
 	rds_trans_unregister(&rds_ib_transport);
diff --git a/net/rds/message.c b/net/rds/message.c
index 7feb0eb6537db..2f654acad29b9 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -182,6 +182,29 @@ static void rds_message_purge(struct rds_message *rm)
 		kref_put(&rm->atomic.op_rdma_mr->r_kref, __rds_put_mr_final);
 }
 
+static void rds_message_purge_worker(struct work_struct *work)
+{
+	struct rds_message *rm = container_of(work, struct rds_message,
+					      m_purge_work);
+
+	rds_message_purge(rm);
+
+	kfree(rm);
+}
+
+/* Purging a message with an RDMA or atomic op whose pages were possibly
+ * written by the remote side must dirty those pages, which can sleep
+ * (and the pages may be file-backed, so dirtying them under a non-irq-safe
+ * filesystem lock must not happen from atomic context at all).
+ */
+static bool rds_message_dirties_pages(struct rds_message *rm)
+{
+	if (rm->rdma.op_active && rm->rdma.op_nents && !rm->rdma.op_write &&
+	    !rm->rdma.op_odp_mr)
+		return true;
+	return rm->atomic.op_active;
+}
+
 void rds_message_put(struct rds_message *rm)
 {
 	rdsdebug("put rm %p ref %d\n", rm, refcount_read(&rm->m_refcount));
@@ -189,6 +212,17 @@ void rds_message_put(struct rds_message *rm)
 	if (refcount_dec_and_test(&rm->m_refcount)) {
 		BUG_ON(!list_empty(&rm->m_sock_item));
 		BUG_ON(!list_empty(&rm->m_conn_item));
+
+		/* The final put may come from the IB send completion
+		 * tasklet; page dirtying must be deferred to process
+		 * context then.
+		 */
+		if (!in_task() && rds_message_dirties_pages(rm)) {
+			INIT_WORK(&rm->m_purge_work, rds_message_purge_worker);
+			queue_work(rds_wq, &rm->m_purge_work);
+			return;
+		}
+
 		rds_message_purge(rm);
 
 		kfree(rm);
diff --git a/net/rds/rdma.c b/net/rds/rdma.c
index 61fb6e45281bf..a4f65e51c6881 100644
--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -495,7 +495,9 @@ void rds_rdma_free_op(struct rm_rdma_op *ro)
 
 			/* Mark page dirty if it was possibly modified, which
 			 * is the case for a RDMA_READ which copies from remote
-			 * to local memory
+			 * to local memory.  Dirtying the page can sleep, so
+			 * rds_message_put() defers the purge of such ops to
+			 * process context.
 			 */
 			unpin_user_pages_dirty_lock(&page, 1, !ro->op_write);
 		}
@@ -513,7 +515,10 @@ void rds_atomic_free_op(struct rm_atomic_op *ao)
 
 	/* Mark page dirty if it was possibly modified, which
 	 * is the case for a RDMA_READ which copies from remote
-	 * to local memory */
+	 * to local memory.  Dirtying the page can sleep, so
+	 * rds_message_put() defers the purge of such ops to
+	 * process context.
+	 */
 	unpin_user_pages_dirty_lock(&page, 1, true);
 
 	kfree(ao->op_notifier);
diff --git a/net/rds/rds.h b/net/rds/rds.h
index 6e0790e4b5703..982f3e406773f 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -445,6 +445,12 @@ struct rds_message {
 
 	void			*m_final_op;
 
+	/* Frees the message from process context when the final put
+	 * happens in atomic context but purging needs to dirty user
+	 * pages, which can sleep.
+	 */
+	struct work_struct	m_purge_work;
+
 	struct {
 		struct rm_atomic_op {
 			int			op_type;
-- 
2.25.1

