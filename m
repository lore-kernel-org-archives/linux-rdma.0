From: Parav Pandit <pandit.parav@gmail.com>
Subject: [PATCH 4/7] devcg: Added rdma resource tracker object per task
Date: Tue,  8 Sep 2015 02:08:20 +0530
Message-ID: <1441658303-18081-5-git-send-email-pandit.parav@gmail.com>
References: <1441658303-18081-1-git-send-email-pandit.parav@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1441658303-18081-1-git-send-email-pandit.parav@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, dledford@redhat.com
Cc: corbet@lwn.net, james.l.morris@oracle.com, serge@hallyn.com, haggaie@mellanox.com, ogerlitz@mellanox.com, matanb@mellanox.com, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org, pandit.parav@gmail.com
List-Id: linux-rdma@vger.kernel.org

Added RDMA device resource tracking object per task.
Added comments to capture usage of task lock by device cgroup
for rdma.

Signed-off-by: Parav Pandit <pandit.parav@gmail.com>
---
 include/linux/sched.h | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ae21f15..a5f79b6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1334,6 +1334,8 @@ union rcu_special {
 };
 struct rcu_node;
 
+struct task_rdma_res_counter;
+
 enum perf_event_task_context {
 	perf_invalid_context = -1,
 	perf_hw_context = 0,
@@ -1637,6 +1639,14 @@ struct task_struct {
 	struct css_set __rcu *cgroups;
 	/* cg_list protected by css_set_lock and tsk->alloc_lock */
 	struct list_head cg_list;
+
+#ifdef CONFIG_CGROUP_RDMA_RESOURCE
+	/* RDMA resource accounting counters, allocated only
+	 * when RDMA resources are created by a task.
+	 */
+	struct task_rdma_res_counter *rdma_res_counter;
+#endif
+
 #endif
 #ifdef CONFIG_FUTEX
 	struct robust_list_head __user *robust_list;
@@ -2676,7 +2686,7 @@ static inline int thread_group_empty(struct task_struct *p)
  * Protects ->fs, ->files, ->mm, ->group_info, ->comm, keyring
  * subscriptions and synchronises with wait4().  Also used in procfs.  Also
  * pins the final release of task.io_context.  Also protects ->cpuset and
- * ->cgroup.subsys[]. And ->vfork_done.
+ * ->cgroup.subsys[]. Also projtects ->vfork_done and ->rdma_res_counter.
  *
  * Nests both inside and outside of read_lock(&tasklist_lock).
  * It must not be nested with write_lock_irq(&tasklist_lock),
-- 
1.8.3.1
