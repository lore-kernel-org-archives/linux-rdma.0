From: Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1] rdma_rxe: Ensure rdma_rxe init occurs at correct time
Date: Fri, 23 Sep 2016 09:32:11 -0600
Message-ID: <1474644731-27818-1-git-send-email-sbates@raithlin.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch is based off v4.8-rc6 with the recent rxe bugfix patchset
applied [1].

There is a problem when CONFIG_RDMA_RXE=y and CONFIG_IPV6=y. This
results in the rdma_rxe initialization occurring before the IPv6
services are ready. This patch delays the initialization of rdma_rxe
until after the IPv6 services are ready. This fix is based on one
proposed by Logan Gunthorpe on a much older code base [2].

[1] http://marc.info/?l=linux-rdma&m=147307739626544&w=2

[2] https://github.com/sbates130272/qemu-minimal/blob/rdma/patches/\
  0001-Changes-needed-to-use-rxe-compiled-into-the-kernel.patch

Changes since v0:
 Improved the commit message
 Added a Reviewed-by tag from Yonatan

Signed-off-by: Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
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
