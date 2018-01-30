From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 4/4] RDMA/hns: Remove repeated option for free mtt table
Date: Tue, 30 Jan 2018 20:20:45 +0800
Message-ID: <1517314845-126094-5-git-send-email-oulijun@huawei.com>
References: <1517314845-126094-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1517314845-126094-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

if inits mtpt table fail and  goto the err_unmap_mtt label,
it is not clean the mtt table. This patch fixs it.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index 830243e..eb9a69f 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -636,7 +636,6 @@ static int hns_roce_init_hem(struct hns_roce_dev *hr_dev)
 	hns_roce_cleanup_hem_table(hr_dev, &hr_dev->mr_table.mtpt_table);
 
 err_unmap_mtt:
-	hns_roce_cleanup_hem_table(hr_dev, &hr_dev->mr_table.mtt_table);
 	if (hns_roce_check_whether_mhop(hr_dev, HEM_TYPE_CQE))
 		hns_roce_cleanup_hem_table(hr_dev,
 					   &hr_dev->mr_table.mtt_cqe_table);
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
