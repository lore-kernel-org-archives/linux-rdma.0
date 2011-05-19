From: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH] infiniband, qib: convert old cpumask api into new one.
Date: Thu, 19 May 2011 10:07:05 +0900
Message-ID: <4DD46D39.3060408@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org, ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Adapt new APIs. we plan to remove old one later and plan to
change current->cpus_allowed implementation.

No functional change.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_file_ops.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
index de7d17d..dd9e1a2 100644
--- a/drivers/infiniband/hw/qib/qib_file_ops.c
+++ b/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -1527,6 +1527,7 @@ done_chk_sdma:
 		struct qib_filedata *fd = fp->private_data;
 		const struct qib_ctxtdata *rcd = fd->rcd;
 		const struct qib_devdata *dd = rcd->dd;
+		unsigned int weight;

 		if (dd->flags & QIB_HAS_SEND_DMA) {
 			fd->pq = qib_user_sdma_queue_create(&dd->pcidev->dev,
@@ -1545,8 +1546,8 @@ done_chk_sdma:
 		 * it just means that sooner or later we don't recommend
 		 * a cpu, and let the scheduler do it's best.
 		 */
-		if (!ret && cpus_weight(current->cpus_allowed) >=
-		    qib_cpulist_count) {
+		weight = cpumask_weight(tsk_cpus_allowed(current));
+		if (!ret && weight >= qib_cpulist_count) {
 			int cpu;
 			cpu = find_first_zero_bit(qib_cpulist,
 						  qib_cpulist_count);
@@ -1554,13 +1555,13 @@ done_chk_sdma:
 				__set_bit(cpu, qib_cpulist);
 				fd->rec_cpu_num = cpu;
 			}
-		} else if (cpus_weight(current->cpus_allowed) == 1 &&
-			test_bit(first_cpu(current->cpus_allowed),
+		} else if (weight == 1 &&
+			test_bit(cpumask_first(tsk_cpus_allowed(current)),
 				 qib_cpulist))
 			qib_devinfo(dd->pcidev, "%s PID %u affinity "
 				    "set to cpu %d; already allocated\n",
 				    current->comm, current->pid,
-				    first_cpu(current->cpus_allowed));
+				    cpumask_first(tsk_cpus_allowed(current)));
 	}

 	mutex_unlock(&qib_mutex);
-- 
1.7.3.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
