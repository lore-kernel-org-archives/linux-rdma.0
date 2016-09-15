From: Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] rdma_rxe: Ensure rdma_rxe module init occurs at correct time
Date: Thu, 15 Sep 2016 15:45:36 -0600
Message-ID: <1473975936-9970-1-git-send-email-sbates@raithlin.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When the Soft-RoCE module is built into the kernel there is a
initialization issue when CONFIG_IPV6 is selected. Use late_initcall
to ensure the rxe module is loaded later. This fix is based on one
proposed by Logan Gunthorpe on a much older code base [1].

[1] https://github.com/sbates130272/qemu-minimal/blob/rdma/patches/\
  0001-Changes-needed-to-use-rxe-compiled-into-the-kernel.patch

Signed-off-by: Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
index 08e09d9..97bc74a 100644
--- a/drivers/infiniband/sw/rxe/rxe.c
+++ b/drivers/infiniband/sw/rxe/rxe.c
@@ -392,5 +392,5 @@ static void __exit rxe_module_exit(void)
 	pr_info("rxe: unloaded\n");
 }
 
-module_init(rxe_module_init);
+late_initcall(rxe_module_init);
 module_exit(rxe_module_exit);
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
