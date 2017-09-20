From: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH RESEND for-next] RDMA/hns: Delete the unnecessary initializing enum to zero
Date: Wed, 20 Sep 2017 11:45:26 +0800
Message-ID: <1505879126-98709-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lijun_nudt-9Onoh4P/yGk@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier_huwei-9Onoh4P/yGk@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

It deletes the unnecessary initializing enum to zero.

Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
This patch is based on the patchset as below:
[PATCH for-next 00/20] RDMA/hns: Add hip08 RoCE driver support,
the related link:
https://www.spinics.net/lists/linux-rdma/msg54098.html

This patch addresses the comment at Leon's suggestion.
https://www.spinics.net/lists/linux-rdma/msg54392.html
https://www.spinics.net/lists/linux-rdma/msg54400.html

---
Because the orignal patch is in the window: From 20:30 UTC Sept 14
and 20:30 UTC Sept 15, so we resend this patch. And Leon had given
Reviewed-by to it, the related link as below:

The original patch:
https://lkml.org/lkml/2017/9/14/677

And the link of Leon's Reviewed-by email:
https://lkml.org/lkml/2017/9/15/27
---
 drivers/infiniband/hw/hns/hns_roce_device.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index b45dba5..4f43c91 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -171,7 +171,7 @@ enum {
 };
 
 enum hns_roce_mtt_type {
-	MTT_TYPE_WQE = 0,
+	MTT_TYPE_WQE,
 	MTT_TYPE_CQE,
 };
 
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
