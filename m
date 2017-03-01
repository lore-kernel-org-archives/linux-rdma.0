From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 04/20] IB/hfi1: NULL pointer dereference when freeing
 rhashtable
Date: Wed, 01 Mar 2017 10:21:50 -0800
Message-ID: <20170301182146.29989.17605.stgit@scvm10.sc.intel.com>
References: <20170301181719.29989.31238.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170301181719.29989.31238.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

A NULL pointer dereference occurs when the driver
is unloaded, and the SDMA rhashtable is freed if
the rhashtable_init() function has not been called.
Prevent this by changing sdma_rht to be a pointer
to a dynamically allocated hash table. The NULL-ness
of the pointer serves as an indication that the hash
table was initialized and that it needs to be
destroyed.

Fixes: 0cb2aa690c7e ("IB/hfi1: Add sysfs interface for affinity setup")
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/hfi.h  |    2 +-
 drivers/infiniband/hw/hfi1/sdma.c |   38 ++++++++++++++++++++++++++-----------
 2 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 0808e3c..b69ab47 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1167,7 +1167,7 @@ struct hfi1_devdata {
 	bool eprom_available;	/* true if EPROM is available for this device */
 	bool aspm_supported;	/* Does HW support ASPM */
 	bool aspm_enabled;	/* ASPM state: enabled/disabled */
-	struct rhashtable sdma_rht;
+	struct rhashtable *sdma_rht;
 
 	struct kobject kobj;
 };
diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index 1d81cac..9bee28d 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -868,7 +868,7 @@ struct sdma_engine *sdma_select_user_engine(struct hfi1_devdata *dd,
 
 	cpu_id = smp_processor_id();
 	rcu_read_lock();
-	rht_node = rhashtable_lookup_fast(&dd->sdma_rht, &cpu_id,
+	rht_node = rhashtable_lookup_fast(dd->sdma_rht, &cpu_id,
 					  sdma_rht_params);
 
 	if (rht_node && rht_node->map[vl]) {
@@ -962,7 +962,7 @@ ssize_t sdma_set_cpu_to_sde_map(struct sdma_engine *sde, const char *buf,
 			continue;
 		}
 
-		rht_node = rhashtable_lookup_fast(&dd->sdma_rht, &cpu,
+		rht_node = rhashtable_lookup_fast(dd->sdma_rht, &cpu,
 						  sdma_rht_params);
 		if (!rht_node) {
 			rht_node = kzalloc(sizeof(*rht_node), GFP_KERNEL);
@@ -982,7 +982,7 @@ ssize_t sdma_set_cpu_to_sde_map(struct sdma_engine *sde, const char *buf,
 			rht_node->map[vl]->ctr = 1;
 			rht_node->map[vl]->sde[0] = sde;
 
-			ret = rhashtable_insert_fast(&dd->sdma_rht,
+			ret = rhashtable_insert_fast(dd->sdma_rht,
 						     &rht_node->node,
 						     sdma_rht_params);
 			if (ret) {
@@ -1025,7 +1025,7 @@ ssize_t sdma_set_cpu_to_sde_map(struct sdma_engine *sde, const char *buf,
 		if (cpumask_test_cpu(cpu, mask))
 			continue;
 
-		rht_node = rhashtable_lookup_fast(&dd->sdma_rht, &cpu,
+		rht_node = rhashtable_lookup_fast(dd->sdma_rht, &cpu,
 						  sdma_rht_params);
 		if (rht_node) {
 			bool empty = true;
@@ -1049,7 +1049,7 @@ ssize_t sdma_set_cpu_to_sde_map(struct sdma_engine *sde, const char *buf,
 			}
 
 			if (empty) {
-				ret = rhashtable_remove_fast(&dd->sdma_rht,
+				ret = rhashtable_remove_fast(dd->sdma_rht,
 							     &rht_node->node,
 							     sdma_rht_params);
 				WARN_ON(ret);
@@ -1108,7 +1108,7 @@ void sdma_seqfile_dump_cpu_list(struct seq_file *s,
 	struct sdma_rht_node *rht_node;
 	int i, j;
 
-	rht_node = rhashtable_lookup_fast(&dd->sdma_rht, &cpuid,
+	rht_node = rhashtable_lookup_fast(dd->sdma_rht, &cpuid,
 					  sdma_rht_params);
 	if (!rht_node)
 		return;
@@ -1322,6 +1322,12 @@ static void sdma_clean(struct hfi1_devdata *dd, size_t num_engines)
 	synchronize_rcu();
 	kfree(dd->per_sdma);
 	dd->per_sdma = NULL;
+
+	if (dd->sdma_rht) {
+		rhashtable_free_and_destroy(dd->sdma_rht, sdma_rht_free, NULL);
+		kfree(dd->sdma_rht);
+		dd->sdma_rht = NULL;
+	}
 }
 
 /**
@@ -1341,12 +1347,14 @@ int sdma_init(struct hfi1_devdata *dd, u8 port)
 {
 	unsigned this_idx;
 	struct sdma_engine *sde;
+	struct rhashtable *tmp_sdma_rht;
 	u16 descq_cnt;
 	void *curr_head;
 	struct hfi1_pportdata *ppd = dd->pport + port;
 	u32 per_sdma_credits;
 	uint idle_cnt = sdma_idle_cnt;
 	size_t num_engines = dd->chip_sdma_engines;
+	int ret = -ENOMEM;
 
 	if (!HFI1_CAP_IS_KSET(SDMA)) {
 		HFI1_CAP_CLEAR(SDMA_AHG);
@@ -1378,7 +1386,7 @@ int sdma_init(struct hfi1_devdata *dd, u8 port)
 	/* alloc memory for array of send engines */
 	dd->per_sdma = kcalloc(num_engines, sizeof(*dd->per_sdma), GFP_KERNEL);
 	if (!dd->per_sdma)
-		return -ENOMEM;
+		return ret;
 
 	idle_cnt = ns_to_cclock(dd, idle_cnt);
 	if (!sdma_desct_intr)
@@ -1507,18 +1515,27 @@ int sdma_init(struct hfi1_devdata *dd, u8 port)
 	dd->flags |= HFI1_HAS_SEND_DMA;
 	dd->flags |= idle_cnt ? HFI1_HAS_SDMA_TIMEOUT : 0;
 	dd->num_sdma = num_engines;
-	if (sdma_map_init(dd, port, ppd->vls_operational, NULL))
+	ret = sdma_map_init(dd, port, ppd->vls_operational, NULL);
+	if (ret < 0)
+		goto bail;
+
+	tmp_sdma_rht = kzalloc(sizeof(*tmp_sdma_rht), GFP_KERNEL);
+	if (!tmp_sdma_rht) {
+		ret = -ENOMEM;
 		goto bail;
+	}
 
-	if (rhashtable_init(&dd->sdma_rht, &sdma_rht_params))
+	ret = rhashtable_init(tmp_sdma_rht, &sdma_rht_params);
+	if (ret < 0)
 		goto bail;
+	dd->sdma_rht = tmp_sdma_rht;
 
 	dd_dev_info(dd, "SDMA num_sdma: %u\n", dd->num_sdma);
 	return 0;
 
 bail:
 	sdma_clean(dd, num_engines);
-	return -ENOMEM;
+	return ret;
 }
 
 /**
@@ -1604,7 +1621,6 @@ void sdma_exit(struct hfi1_devdata *dd)
 		sdma_finalput(&sde->state);
 	}
 	sdma_clean(dd, dd->num_sdma);
-	rhashtable_free_and_destroy(&dd->sdma_rht, sdma_rht_free, NULL);
 }
 
 /*

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
