From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 06/17] IB/hfi1: Remove debug prints after allocation failure
Date: Thu,  3 Nov 2016 07:02:22 +0200
Message-ID: <1478149353-12125-7-git-send-email-leon@kernel.org>
References: <1478149353-12125-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478149353-12125-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The prints after [k|v][m|z|c]alloc() functions are not needed,
because in case of failure, allocator will print their internal
error prints anyway.

Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/pio.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi1/pio.c b/drivers/infiniband/hw/hfi1/pio.c
index 50a3a36..d15ffed 100644
--- a/drivers/infiniband/hw/hfi1/pio.c
+++ b/drivers/infiniband/hw/hfi1/pio.c
@@ -2053,7 +2053,6 @@ int init_credit_return(struct hfi1_devdata *dd)
 		sizeof(struct credit_return_base),
 		GFP_KERNEL);
 	if (!dd->cr_base) {
-		dd_dev_err(dd, "Unable to allocate credit return base\n");
 		ret = -ENOMEM;
 		goto done;
 	}
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
