From: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 9/9] RDMA/hns: Replace usleep_range with udelay when checking command status
Date: Thu, 28 Sep 2017 12:57:34 +0800
Message-ID: <1506574654-56699-10-git-send-email-xavier.huwei@huawei.com>
References: <1506574654-56699-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1506574654-56699-1-git-send-email-xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lijun_nudt-9Onoh4P/yGk@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-WVlzvzqoTvw@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shaobohsu-9Onoh4P/yGk@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

It replaces usleep_range with udelay to avoid using usleep_range function
in spin_lock_bh spin region, because it probably cause calltrace.

BUG: scheduling while atomic: insmod/1428/0x00000002
Modules linked in: hns-roce-hw-v2(+) hns_roce rdma_ucm rdma_cm iw_cm ib_uverbs ib_cm ib_core
CPU: 0 PID: 1428 Comm: insmod Not tainted 4.12.0-rc1-00677-g252e8fd-dirty #43
Hardware name: (null) (DT)
Call trace:
[<ffff000008089d20>] dump_backtrace+0x0/0x274
[<ffff00000808a068>] show_stack+0x20/0x28
[<ffff00000844ea58>] dump_stack+0x94/0xb4
[<ffff0000080f975c>] __schedule_bug+0x68/0x84
[<ffff000008a988d4>] __schedule+0x5fc/0x70c
[<ffff000008a98a24>] schedule+0x40/0xa4
[<ffff000008a9c6f0>] schedule_hrtimeout_range_clock+0x98/0xfc
[<ffff000008a9c788>] schedule_hrtimeout_range+0x34/0x40
[<ffff000008a9c098>] usleep_range+0x6c/0x80
[<ffff000000b9ae68>] hns_roce_cmd_send+0xe4/0x264 [hns-roce-hw-v2]
[<ffff000000b9b748>] hns_roce_cmd_query_hw_info+0x40/0x60 [hns-roce-hw-v2]
[<ffff000000b9b790>] hns_roce_v2_profile+0x28/0x668 [hns-roce-hw-v2]
[<ffff000000b6b1f4>] hns_roce_init+0x6c/0x948 [hns-roce-hw-v2]

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 90ef5c6..915d1d5 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -589,7 +589,7 @@ int hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
 		do {
 			if (hns_roce_cmq_csq_done(hr_dev))
 				break;
-			usleep_range(1000, 2000);
+			udelay(1);
 			timeout++;
 		} while (timeout < priv->cmq.tx_timeout);
 	}
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
