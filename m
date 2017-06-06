From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 4/5] IB/hns: Fix the bug with modifying the MAC address without removing the driver
Date: Tue, 6 Jun 2017 09:24:47 +0800
Message-ID: <1496712288-63434-5-git-send-email-oulijun@huawei.com>
References: <1496712288-63434-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1496712288-63434-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When modified the MAC address used hns_roce_mac function, we release and create
reserved qp again, It is not necessary to use spin_lock_bh and spin_unlock_bh in
handle_en_event, Otherwise, it will occur a error. This patch mainly fixes it.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index c3b41f9..d9777b6 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -125,8 +125,6 @@ static int handle_en_event(struct hns_roce_dev *hr_dev, u8 port,
 		return -ENODEV;
 	}
 
-	spin_lock_bh(&hr_dev->iboe.lock);
-
 	switch (event) {
 	case NETDEV_UP:
 	case NETDEV_CHANGE:
@@ -144,7 +142,6 @@ static int handle_en_event(struct hns_roce_dev *hr_dev, u8 port,
 		break;
 	}
 
-	spin_unlock_bh(&hr_dev->iboe.lock);
 	return 0;
 }
 
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
