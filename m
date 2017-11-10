From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 10/11] {topost} RDMA/hns: Unify the calculation for hem index in hip08
Date: Fri, 10 Nov 2017 16:55:52 +0800
Message-ID: <1510304153-91394-11-git-send-email-oulijun@huawei.com>
References: <1510304153-91394-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510304153-91394-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The calculation of hem index are different between hns_roce_table_get
and hns_roce_table_find. When the table chunk size of TRRL is not
divisible by object size, it will faile to find the trrl table.

This patch is to update the calculation of the hem index in the
hns_roce_table_find to the same as which in the hns_roce_table_get.

Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_hem.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.c b/drivers/infiniband/hw/hns/hns_roce_hem.c
index f1f8fa4..8b733a6 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -724,7 +724,8 @@ void *hns_roce_table_find(struct hns_roce_dev *hr_dev,
 	struct hns_roce_hem *hem;
 	struct page *page = NULL;
 	unsigned long mhop_obj = obj;
-	unsigned long idx;
+	unsigned long obj_per_chunk;
+	unsigned long idx_offset;
 	int offset, dma_offset;
 	int i, j;
 	u32 hem_idx = 0;
@@ -735,9 +736,10 @@ void *hns_roce_table_find(struct hns_roce_dev *hr_dev,
 	mutex_lock(&table->mutex);
 
 	if (!hns_roce_check_whether_mhop(hr_dev, table->type)) {
-		idx = (obj & (table->num_obj - 1)) * table->obj_size;
-		hem = table->hem[idx / table->table_chunk_size];
-		dma_offset = offset = idx % table->table_chunk_size;
+		obj_per_chunk = table->table_chunk_size / table->obj_size;
+		hem = table->hem[(obj & (table->num_obj - 1)) / obj_per_chunk];
+		idx_offset = (obj & (table->num_obj - 1)) % obj_per_chunk;
+		dma_offset = offset = idx_offset * table->obj_size;
 	} else {
 		hns_roce_calc_hem_mhop(hr_dev, table, &mhop_obj, &mhop);
 		/* mtt mhop */
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
