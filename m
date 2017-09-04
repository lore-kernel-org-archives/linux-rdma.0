From: Colin King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH] RDMA/nes: do not leak uninitialized resp.reserved to userspace
Date: Mon,  4 Sep 2017 12:23:16 +0100
Message-ID: <20170904112316.23832-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

resp.reserved has not been initialized and so the copy_to_user (via
ib_copy_to_udata) is copying uninitialized data from the stack back
to user space which is a potential information leak. Fix this by
setting resp.reserved to zero.

Fixes: 3c2d774cad5b ("RDMA/nes: Add a driver for NetEffect RNICs")
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> [2.6.24+]
Signed-off-by: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_verbs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index f0dc5f4aa177..052c3822dfed 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -1666,6 +1666,7 @@ static struct ib_cq *nes_create_cq(struct ib_device *ibdev,
 		resp.cq_id = nescq->hw_cq.cq_number;
 		resp.cq_size = nescq->hw_cq.cq_size;
 		resp.mmap_db_index = 0;
+		resp.reserved = 0;
 		if (ib_copy_to_udata(udata, &resp, sizeof resp - sizeof resp.reserved)) {
 			nes_free_resource(nesadapter, nesadapter->allocated_cqs, cq_num);
 			kfree(nescq);
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
