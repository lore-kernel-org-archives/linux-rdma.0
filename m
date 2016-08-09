From: ira.weiny@intel.com
Subject: [PATCH] IB/hfi1,IB/qib: Fix qp_stats sleep with rcu read lock held
Date: Tue,  9 Aug 2016 11:16:26 -0400
Message-ID: <1470755786-14054-1-git-send-email-ira.weiny@intel.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, Ira Weiny <ira.weiny@intel.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

The qp init function does a kzalloc() while holding the RCU
lock that encounters the following warning with a debug kernel
when a cat of the qp_stats is done:

[  231.723948] rcu_scheduler_active = 1, debug_locks = 0
[  231.731939] 3 locks held by cat/11355:
[  231.736492]  #0:  (debugfs_srcu){......}, at: [<ffffffff813001a5>] debugfs_use_file_start+0x5/0x90
[  231.746955]  #1:  (&p->lock){+.+.+.}, at: [<ffffffff81289a6c>] seq_read+0x4c/0x3c0
[  231.755873]  #2:  (rcu_read_lock){......}, at: [<ffffffffa0a0c535>] _qp_stats_seq_start+0x5/0xd0 [hfi1]
[  231.766862]

The init functions do an implicit next which requires the rcu read lock
before the kzalloc().

Fix for both drivers is to change the scope of the init function to only
do the allocation and the initialization of the just allocated iter.

The implict next is moved back into the respective start functions to fix
the issue.


Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
CC: <stable@vger.kernel.org> # 4.6.x-
---
 drivers/infiniband/hw/hfi1/debugfs.c    | 17 ++++++++++++-----
 drivers/infiniband/hw/hfi1/qp.c         |  4 ----
 drivers/infiniband/hw/qib/qib_debugfs.c | 16 ++++++++++++----
 drivers/infiniband/hw/qib/qib_qp.c      |  4 ----
 4 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/debugfs.c b/drivers/infiniband/hw/hfi1/debugfs.c
index dbab9d9cc288..c35bef8dd5aa 100644
--- a/drivers/infiniband/hw/hfi1/debugfs.c
+++ b/drivers/infiniband/hw/hfi1/debugfs.c
@@ -223,28 +223,35 @@ DEBUGFS_SEQ_FILE_OPEN(ctx_stats)
 DEBUGFS_FILE_OPS(ctx_stats);
 
 static void *_qp_stats_seq_start(struct seq_file *s, loff_t *pos)
-__acquires(RCU)
+	__acquires(RCU)
 {
 	struct qp_iter *iter;
 	loff_t n = *pos;
 
-	rcu_read_lock();
 	iter = qp_iter_init(s->private);
+
+	/* stop calls rcu_read_unlock */
+	rcu_read_lock();
+
 	if (!iter)
 		return NULL;
 
-	while (n--) {
+	if (qp_iter_next(iter)) {
+		kfree(iter);
+		return NULL;
+	}
+	while (n--)
 		if (qp_iter_next(iter)) {
 			kfree(iter);
 			return NULL;
 		}
-	}
 
 	return iter;
 }
 
 static void *_qp_stats_seq_next(struct seq_file *s, void *iter_ptr,
 				loff_t *pos)
+	__must_hold(RCU)
 {
 	struct qp_iter *iter = iter_ptr;
 
@@ -259,7 +266,7 @@ static void *_qp_stats_seq_next(struct seq_file *s, void *iter_ptr,
 }
 
 static void _qp_stats_seq_stop(struct seq_file *s, void *iter_ptr)
-__releases(RCU)
+	__releases(RCU)
 {
 	rcu_read_unlock();
 }
diff --git a/drivers/infiniband/hw/hfi1/qp.c b/drivers/infiniband/hw/hfi1/qp.c
index a5aa3517e7d5..4e4d8317c281 100644
--- a/drivers/infiniband/hw/hfi1/qp.c
+++ b/drivers/infiniband/hw/hfi1/qp.c
@@ -656,10 +656,6 @@ struct qp_iter *qp_iter_init(struct hfi1_ibdev *dev)
 
 	iter->dev = dev;
 	iter->specials = dev->rdi.ibdev.phys_port_cnt * 2;
-	if (qp_iter_next(iter)) {
-		kfree(iter);
-		return NULL;
-	}
 
 	return iter;
 }
diff --git a/drivers/infiniband/hw/qib/qib_debugfs.c b/drivers/infiniband/hw/qib/qib_debugfs.c
index 5e75b43c596b..07059c08c170 100644
--- a/drivers/infiniband/hw/qib/qib_debugfs.c
+++ b/drivers/infiniband/hw/qib/qib_debugfs.c
@@ -189,27 +189,34 @@ static int _ctx_stats_seq_show(struct seq_file *s, void *v)
 DEBUGFS_FILE(ctx_stats)
 
 static void *_qp_stats_seq_start(struct seq_file *s, loff_t *pos)
+	__acquires(RCU)
 {
 	struct qib_qp_iter *iter;
 	loff_t n = *pos;
 
-	rcu_read_lock();
 	iter = qib_qp_iter_init(s->private);
+
+	/* stop calls rcu_read_unlock */
+	rcu_read_lock();
+
 	if (!iter)
 		return NULL;
 
-	while (n--) {
+	if (qib_qp_iter_next(iter)) {
+		kfree(iter);
+		return NULL;
+	}
+	while (n--)
 		if (qib_qp_iter_next(iter)) {
 			kfree(iter);
 			return NULL;
 		}
-	}
-
 	return iter;
 }
 
 static void *_qp_stats_seq_next(struct seq_file *s, void *iter_ptr,
 				   loff_t *pos)
+	__must_hold(RCU)
 {
 	struct qib_qp_iter *iter = iter_ptr;
 
@@ -224,6 +231,7 @@ static void *_qp_stats_seq_next(struct seq_file *s, void *iter_ptr,
 }
 
 static void _qp_stats_seq_stop(struct seq_file *s, void *iter_ptr)
+	__releases(RCU)
 {
 	rcu_read_unlock();
 }
diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index 9cc0aae1d781..f9b8cd2354d1 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -573,10 +573,6 @@ struct qib_qp_iter *qib_qp_iter_init(struct qib_ibdev *dev)
 		return NULL;
 
 	iter->dev = dev;
-	if (qib_qp_iter_next(iter)) {
-		kfree(iter);
-		return NULL;
-	}
 
 	return iter;
 }
-- 
1.8.2
