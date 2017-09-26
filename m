From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 10/12] IB/hfi1: Remove unused hfi1_cpulist variables
Date: Tue, 26 Sep 2017 07:01:02 -0700
Message-ID: <20170926140101.15601.26108.stgit@scvm10.sc.intel.com>
References: <20170926135843.15601.95865.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170926135843.15601.95865.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Following variables: hfi1_cpulist and hfi1_cpulist_count
are unused. Remove them.

Reviewed-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/hfi.h  |    2 --
 drivers/infiniband/hw/hfi1/init.c |   16 ----------------
 2 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index fc1ee8d..1e1140e 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1371,8 +1371,6 @@ struct hfi1_filedata {
 extern struct list_head hfi1_dev_list;
 extern spinlock_t hfi1_devs_lock;
 struct hfi1_devdata *hfi1_lookup(int unit);
-extern u32 hfi1_cpulist_count;
-extern unsigned long *hfi1_cpulist;
 
 static inline unsigned long uctxt_offset(struct hfi1_ctxtdata *uctxt)
 {
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 3e686d2..04a383b 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -123,8 +123,6 @@
 static inline u64 encode_rcv_header_entry_size(u16 size);
 
 static struct idr hfi1_unit_table;
-u32 hfi1_cpulist_count;
-unsigned long *hfi1_cpulist;
 
 static int hfi1_create_kctxt(struct hfi1_devdata *dd,
 			     struct hfi1_pportdata *ppd)
@@ -1287,18 +1285,6 @@ struct hfi1_devdata *hfi1_alloc_devdata(struct pci_dev *pdev, size_t extra)
 		goto bail;
 	}
 
-	if (!hfi1_cpulist_count) {
-		u32 count = num_online_cpus();
-
-		hfi1_cpulist = kcalloc(BITS_TO_LONGS(count), sizeof(long),
-				       GFP_KERNEL);
-		if (hfi1_cpulist)
-			hfi1_cpulist_count = count;
-		else
-			hfi1_early_err(
-			&pdev->dev,
-			"Could not alloc cpulist info, cpu affinity might be wrong\n");
-	}
 	kobject_init(&dd->kobj, &hfi1_devdata_type);
 	return dd;
 
@@ -1471,8 +1457,6 @@ static void __exit hfi1_mod_cleanup(void)
 	node_affinity_destroy();
 	hfi1_wss_exit();
 	hfi1_dbg_exit();
-	hfi1_cpulist_count = 0;
-	kfree(hfi1_cpulist);
 
 	idr_destroy(&hfi1_unit_table);
 	dispose_firmware();	/* asymmetric with obtain_firmware() */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
