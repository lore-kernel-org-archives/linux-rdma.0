From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 6/6] IB/mlx4: Fix WQE LSO segment calculation
Date: Thu,  2 Apr 2015 13:39:05 +0300
Message-ID: <1427971145-26943-7-git-send-email-ogerlitz@mellanox.com>
References: <1427971145-26943-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427971145-26943-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The current code decreases from the mss size (which is the gso_size
from the kernel skb) the size of the packet headers.

It shouldn't do that because the mss that comes from the stack
(e.g IPoIB) includes only the tcp payload without the headers.

The result is indication to the HW that each packet that the HW sends
is smaller than what it could be, and too many packets will be sent
for big messages.

An easy way to demonstrate one more aspect of the problem is by
configuring the ipoib mtu to be less than 2*hlen (2*56) and then
run app sending big TCP messages. This will tell the HW to send packets
with giant (negative value which under unsigned arithmetics becomes
a huge positive one) length and the QP moves to SQE state.

Fixes: b832be1e4007 ('IB/mlx4: Add IPoIB LSO support')
Reported-by: Matthew Finlay <matt-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index ed2bd67..fbde33a 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -2605,8 +2605,7 @@ static int build_lso_seg(struct mlx4_wqe_lso_seg *wqe, struct ib_send_wr *wr,
 
 	memcpy(wqe->header, wr->wr.ud.header, wr->wr.ud.hlen);
 
-	*lso_hdr_sz  = cpu_to_be32((wr->wr.ud.mss - wr->wr.ud.hlen) << 16 |
-				   wr->wr.ud.hlen);
+	*lso_hdr_sz  = cpu_to_be32(wr->wr.ud.mss << 16 | wr->wr.ud.hlen);
 	*lso_seg_len = halign;
 	return 0;
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
