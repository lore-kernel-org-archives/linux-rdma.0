From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/ipoib: Restore MM behavior in case of tx_ring allocation failure
Date: Wed, 13 Dec 2017 12:25:19 +0200
Message-ID: <20171213102519.4929-1-yuval.shaia@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, ajaykumar.hotchandani-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

memalloc_noio_save modifies the behavior of MM, we must restore it after
we are done.

Fixes: d83187dda9b9 IB/IPoIB: Convert IPoIB to memalloc_noio_* calls

Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_cm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 87f4bd99cdf7..2c13123bfd69 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -1145,6 +1145,7 @@ static int ipoib_cm_tx_init(struct ipoib_cm_tx *p, u32 qpn,
 	noio_flag = memalloc_noio_save();
 	p->tx_ring = vzalloc(ipoib_sendq_size * sizeof(*p->tx_ring));
 	if (!p->tx_ring) {
+		memalloc_noio_restore(noio_flag);
 		ret = -ENOMEM;
 		goto err_tx;
 	}
-- 
2.14.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
