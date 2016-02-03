From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 25/54] staging/rdma/hfi1: Change send_schedule counter to a
 per cpu counter
Date: Wed, 03 Feb 2016 14:34:07 -0800
Message-ID: <20160203223403.5923.66018.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

A patch to fix fairness issues in QP scheduling requires
n_send_schedule counter to be converted to a per cpu counter to reduce
cache misses.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c  |    3 ++-
 drivers/staging/rdma/hfi1/hfi.h   |    4 +++-
 drivers/staging/rdma/hfi1/init.c  |    9 +++++++++
 drivers/staging/rdma/hfi1/ruc.c   |    2 +-
 drivers/staging/rdma/hfi1/verbs.h |    1 -
 5 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 6045c91..13b92a3 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -1609,7 +1609,8 @@ static u64 access_sw_send_schedule(const struct cntr_entry *entry,
 {
 	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
 
-	return dd->verbs_dev.n_send_schedule;
+	return read_write_cpu(dd, &dd->z_send_schedule, dd->send_schedule, vl,
+			      mode, data);
 }
 
 /* Software counters for the error status bits within MISC_ERR_STATUS */
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 571e7b1..112f790 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -898,10 +898,11 @@ struct hfi1_devdata {
 	/* reset value */
 	u64 z_int_counter;
 	u64 z_rcv_limit;
+	u64 z_send_schedule;
 	/* percpu int_counter */
 	u64 __percpu *int_counter;
 	u64 __percpu *rcv_limit;
-
+	u64 __percpu *send_schedule;
 	/* number of receive contexts in use by the driver */
 	u32 num_rcv_contexts;
 	/* number of pio send contexts in use by the driver */
@@ -1884,6 +1885,7 @@ static inline void hfi1_reset_cpu_counters(struct hfi1_devdata *dd)
 
 	dd->z_int_counter = get_all_cpu_total(dd->int_counter);
 	dd->z_rcv_limit = get_all_cpu_total(dd->rcv_limit);
+	dd->z_send_schedule = get_all_cpu_total(dd->send_schedule);
 
 	ppd = (struct hfi1_pportdata *)(dd + 1);
 	for (i = 0; i < dd->num_pports; i++, ppd++) {
diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index 629e92a..6ddf3c8 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -985,6 +985,7 @@ void hfi1_free_devdata(struct hfi1_devdata *dd)
 	free_percpu(dd->int_counter);
 	free_percpu(dd->rcv_limit);
 	hfi1_dev_affinity_free(dd);
+	free_percpu(dd->send_schedule);
 	ib_dealloc_device(&dd->verbs_dev.rdi.ibdev);
 }
 
@@ -1063,6 +1064,14 @@ struct hfi1_devdata *hfi1_alloc_devdata(struct pci_dev *pdev, size_t extra)
 		goto bail;
 	}
 
+	dd->send_schedule = alloc_percpu(u64);
+	if (!dd->send_schedule) {
+		ret = -ENOMEM;
+		hfi1_early_err(&pdev->dev,
+			       "Could not allocate per-cpu int_counter\n");
+		goto bail;
+	}
+
 	if (!hfi1_cpulist_count) {
 		u32 count = num_online_cpus();
 
diff --git a/drivers/staging/rdma/hfi1/ruc.c b/drivers/staging/rdma/hfi1/ruc.c
index 6379df5..ae28b85 100644
--- a/drivers/staging/rdma/hfi1/ruc.c
+++ b/drivers/staging/rdma/hfi1/ruc.c
@@ -875,7 +875,7 @@ void hfi1_do_send(struct rvt_qp *qp)
 		/* allow other tasks to run */
 		if (unlikely(time_after(jiffies, timeout))) {
 			cond_resched();
-			ps.ppd->dd->verbs_dev.n_send_schedule++;
+			this_cpu_inc(*ps.ppd->dd->send_schedule);
 			timeout = jiffies + SEND_RESCHED_TIMEOUT;
 		}
 	} while (make_req(qp));
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index 1571ae3..ac84dd7 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -270,7 +270,6 @@ struct hfi1_ibdev {
 	u64 n_piowait;
 	u64 n_txwait;
 	u64 n_kmem_wait;
-	u64 n_send_schedule;
 
 #ifdef CONFIG_DEBUG_FS
 	/* per HFI debugfs */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
