From: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V2 2/3] RDMA/hns: Update the IRRL table chunk size in hip08
Date: Wed, 18 Oct 2017 17:32:45 +0800
Message-ID: <1508319166-116987-3-git-send-email-xavier.huwei@huawei.com>
References: <1508319166-116987-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1508319166-116987-1-git-send-email-xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lijun_nudt-9Onoh4P/yGk@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shaobohsu-9Onoh4P/yGk@public.gmane.org, shaoboxu-WVlzvzqoTvw@public.gmane.org, shaobo.xu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

As the increase of the IRRL specification in hip08, the IRRL table
chunk size needs to be updated.
This patch updates the IRRL table chunk size to 256k for hip08.

Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
Patch V2: Address comments by Leon:
	https://lkml.org/lkml/2017/10/1/2

Patch V1: Initial Submit
---
 drivers/infiniband/hw/hns/hns_roce_device.h |  2 ++
 drivers/infiniband/hw/hns/hns_roce_hem.c    | 29 +++++++++++++----------------
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c  |  1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v1.h  |  2 ++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  |  1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |  2 ++
 6 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 9353400..adf7a70 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -236,6 +236,7 @@ struct hns_roce_hem_table {
 	unsigned long	num_obj;
 	/*Single obj size */
 	unsigned long	obj_size;
+	unsigned long	table_chunk_size;
 	int		lowmem;
 	struct mutex	mutex;
 	struct hns_roce_hem **hem;
@@ -565,6 +566,7 @@ struct hns_roce_caps {
 	u32		cqe_ba_pg_sz;
 	u32		cqe_buf_pg_sz;
 	u32		cqe_hop_num;
+	u32		chunk_sz;	/* chunk size in non multihop mode*/
 };
 
 struct hns_roce_hw {
diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.c b/drivers/infiniband/hw/hns/hns_roce_hem.c
index 8388ae2..576eb3b 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -36,9 +36,6 @@
 #include "hns_roce_hem.h"
 #include "hns_roce_common.h"
 
-#define HNS_ROCE_HEM_ALLOC_SIZE		(1 << 17)
-#define HNS_ROCE_TABLE_CHUNK_SIZE	(1 << 17)
-
 #define DMA_ADDR_T_SHIFT		12
 #define BT_BA_SHIFT			32
 
@@ -296,7 +293,7 @@ static int hns_roce_set_hem(struct hns_roce_dev *hr_dev,
 
 	/* Find the HEM(Hardware Entry Memory) entry */
 	unsigned long i = (obj & (table->num_obj - 1)) /
-			  (HNS_ROCE_TABLE_CHUNK_SIZE / table->obj_size);
+			  (table->table_chunk_size / table->obj_size);
 
 	switch (table->type) {
 	case HEM_TYPE_QPC:
@@ -541,7 +538,7 @@ int hns_roce_table_get(struct hns_roce_dev *hr_dev,
 	if (hns_roce_check_whether_mhop(hr_dev, table->type))
 		return hns_roce_table_mhop_get(hr_dev, table, obj);
 
-	i = (obj & (table->num_obj - 1)) / (HNS_ROCE_TABLE_CHUNK_SIZE /
+	i = (obj & (table->num_obj - 1)) / (table->table_chunk_size /
 	     table->obj_size);
 
 	mutex_lock(&table->mutex);
@@ -552,8 +549,8 @@ int hns_roce_table_get(struct hns_roce_dev *hr_dev,
 	}
 
 	table->hem[i] = hns_roce_alloc_hem(hr_dev,
-				       HNS_ROCE_TABLE_CHUNK_SIZE >> PAGE_SHIFT,
-				       HNS_ROCE_HEM_ALLOC_SIZE,
+				       table->table_chunk_size >> PAGE_SHIFT,
+				       table->table_chunk_size,
 				       (table->lowmem ? GFP_KERNEL :
 					GFP_HIGHUSER) | __GFP_NOWARN);
 	if (!table->hem[i]) {
@@ -702,7 +699,7 @@ void hns_roce_table_put(struct hns_roce_dev *hr_dev,
 	}
 
 	i = (obj & (table->num_obj - 1)) /
-	    (HNS_ROCE_TABLE_CHUNK_SIZE / table->obj_size);
+	    (table->table_chunk_size / table->obj_size);
 
 	mutex_lock(&table->mutex);
 
@@ -739,8 +736,8 @@ void *hns_roce_table_find(struct hns_roce_dev *hr_dev,
 
 	if (!hns_roce_check_whether_mhop(hr_dev, table->type)) {
 		idx = (obj & (table->num_obj - 1)) * table->obj_size;
-		hem = table->hem[idx / HNS_ROCE_TABLE_CHUNK_SIZE];
-		dma_offset = offset = idx % HNS_ROCE_TABLE_CHUNK_SIZE;
+		hem = table->hem[idx / table->table_chunk_size];
+		dma_offset = offset = idx % table->table_chunk_size;
 	} else {
 		hns_roce_calc_hem_mhop(hr_dev, table, &mhop_obj, &mhop);
 		/* mtt mhop */
@@ -791,7 +788,7 @@ int hns_roce_table_get_range(struct hns_roce_dev *hr_dev,
 			     unsigned long start, unsigned long end)
 {
 	struct hns_roce_hem_mhop mhop;
-	unsigned long inc = HNS_ROCE_TABLE_CHUNK_SIZE / table->obj_size;
+	unsigned long inc = table->table_chunk_size / table->obj_size;
 	unsigned long i;
 	int ret;
 
@@ -822,7 +819,7 @@ void hns_roce_table_put_range(struct hns_roce_dev *hr_dev,
 			      unsigned long start, unsigned long end)
 {
 	struct hns_roce_hem_mhop mhop;
-	unsigned long inc = HNS_ROCE_TABLE_CHUNK_SIZE / table->obj_size;
+	unsigned long inc = table->table_chunk_size / table->obj_size;
 	unsigned long i;
 
 	if (hns_roce_check_whether_mhop(hr_dev, table->type)) {
@@ -830,8 +827,7 @@ void hns_roce_table_put_range(struct hns_roce_dev *hr_dev,
 		inc = mhop.bt_chunk_size / table->obj_size;
 	}
 
-	for (i = start; i <= end;
-		i += inc)
+	for (i = start; i <= end; i += inc)
 		hns_roce_table_put(hr_dev, table, i);
 }
 
@@ -845,7 +841,8 @@ int hns_roce_init_hem_table(struct hns_roce_dev *hr_dev,
 	unsigned long num_hem;
 
 	if (!hns_roce_check_whether_mhop(hr_dev, type)) {
-		obj_per_chunk = HNS_ROCE_TABLE_CHUNK_SIZE / obj_size;
+		table->table_chunk_size = hr_dev->caps.chunk_sz;
+		obj_per_chunk = table->table_chunk_size / obj_size;
 		num_hem = (nobj + obj_per_chunk - 1) / obj_per_chunk;
 
 		table->hem = kcalloc(num_hem, sizeof(*table->hem), GFP_KERNEL);
@@ -1027,7 +1024,7 @@ void hns_roce_cleanup_hem_table(struct hns_roce_dev *hr_dev,
 	for (i = 0; i < table->num_hem; ++i)
 		if (table->hem[i]) {
 			if (hr_dev->hw->clear_hem(hr_dev, table,
-			    i * HNS_ROCE_TABLE_CHUNK_SIZE / table->obj_size, 0))
+			    i * table->table_chunk_size / table->obj_size, 0))
 				dev_err(dev, "Clear HEM base address failed.\n");
 
 			hns_roce_free_hem(hr_dev, table->hem[i]);
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index 658e3a7..90b55f2 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -1514,6 +1514,7 @@ static int hns_roce_v1_profile(struct hns_roce_dev *hr_dev)
 	caps->reserved_mrws	= 1;
 	caps->reserved_uars	= 0;
 	caps->reserved_cqs	= 0;
+	caps->chunk_sz		= HNS_ROCE_V1_TABLE_CHUNK_SIZE;
 
 	for (i = 0; i < caps->num_ports; i++)
 		caps->pkey_table_len[i] = 1;
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.h b/drivers/infiniband/hw/hns/hns_roce_hw_v1.h
index eb83ff3..21a07ef 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.h
@@ -72,6 +72,8 @@
 #define HNS_ROCE_V1_CQE_ENTRY_SIZE			32
 #define HNS_ROCE_V1_PAGE_SIZE_SUPPORT			0xFFFFF000
 
+#define HNS_ROCE_V1_TABLE_CHUNK_SIZE			(1 << 17)
+
 #define HNS_ROCE_V1_EXT_RAQ_WF				8
 #define HNS_ROCE_V1_RAQ_ENTRY				64
 #define HNS_ROCE_V1_RAQ_DEPTH				32768
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index ff61f30..5039928 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -943,6 +943,7 @@ static int hns_roce_v2_profile(struct hns_roce_dev *hr_dev)
 	caps->cqe_ba_pg_sz	= 0;
 	caps->cqe_buf_pg_sz	= 0;
 	caps->cqe_hop_num	= HNS_ROCE_CQE_HOP_NUM;
+	caps->chunk_sz		= HNS_ROCE_V2_TABLE_CHUNK_SIZE;
 
 	caps->pkey_table_len[0] = 1;
 	caps->gid_table_len[0] = 2;
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index 4fc4acd..65ed3f8 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -78,6 +78,8 @@
 #define HNS_ROCE_CQE_HOP_NUM			1
 #define HNS_ROCE_PBL_HOP_NUM			2
 
+#define HNS_ROCE_V2_TABLE_CHUNK_SIZE		(1 << 18)
+
 #define HNS_ROCE_CMD_FLAG_IN_VALID_SHIFT	0
 #define HNS_ROCE_CMD_FLAG_OUT_VALID_SHIFT	1
 #define HNS_ROCE_CMD_FLAG_NEXT_SHIFT		2
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
