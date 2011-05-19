From: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH] infiniband, ipath: convert old cpumask api into new one
Date: Thu, 19 May 2011 10:04:42 +0900
Message-ID: <4DD46CAA.9030609@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, infinipath-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Adapt new api. we plan to remove old one later. Almost change are
trivial. but there is one real fix. following code is unsafe.

	int ncpus = num_online_cpus()
	for (i = 0; i < ncpus; i++) {
		..
	}

because 1) we don't guarantee last bit of online cpus is equal
to num_online_cpus(). some arch assign sparse cpu number.
2) cpu hotplugging may change cpu_online_mask at same time.
we need to pin it by get_online_cpus().

Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ralph Campbell <infinipath-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
---
 drivers/infiniband/hw/ipath/ipath_file_ops.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_file_ops.c b/drivers/infiniband/hw/ipath/ipath_file_ops.c
index bdf4422..aab5d89 100644
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c
+++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c
@@ -40,6 +40,7 @@
 #include <linux/highmem.h>
 #include <linux/io.h>
 #include <linux/jiffies.h>
+#include <linux/cpu.h>
 #include <asm/pgtable.h>

 #include "ipath_kernel.h"
@@ -1684,17 +1685,19 @@ static int find_best_unit(struct file *fp,
 	 * information.  There may be some issues with dual core numbering
 	 * as well.  This needs more work prior to release.
 	 */
-	if (!cpumask_empty(&current->cpus_allowed) &&
-	    !cpumask_full(&current->cpus_allowed)) {
+	if (!cpumask_empty(tsk_cpus_allowed(current)) &&
+	    !cpumask_full(tsk_cpus_allowed(current))) {
 		int ncpus = num_online_cpus(), curcpu = -1, nset = 0;
-		for (i = 0; i < ncpus; i++)
-			if (cpumask_test_cpu(i, &current->cpus_allowed)) {
+		get_online_cpus();
+		for_each_online_cpu(i)
+			if (cpumask_test_cpu(i, tsk_cpus_allowed(current))) {
 				ipath_cdbg(PROC, "%s[%u] affinity set for "
 					   "cpu %d/%d\n", current->comm,
 					   current->pid, i, ncpus);
 				curcpu = i;
 				nset++;
 			}
+		put_online_cpus();
 		if (curcpu != -1 && nset != ncpus) {
 			if (npresent) {
 				prefunit = curcpu / (ncpus / npresent);
-- 
1.7.3.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
