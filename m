From: roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] RDMA/ocrdma: remove a unused-label warning
Date: Mon, 29 Sep 2014 14:59:43 +0800
Message-ID: <1411973983-7125-1-git-send-email-roy.qing.li@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

=46rom: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>=20

If disable IPV6, and the warning will happen:
    drivers/infiniband/hw/ocrdma/ocrdma_main.c:650:1: warning: label =E2=
=80=98err_notifier6=E2=80=99 defined but not used [-Wunused-label]

Signed-off-by: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_main.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infin=
iband/hw/ocrdma/ocrdma_main.c
index 256a06b..c108623 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -646,8 +646,10 @@ static int __init ocrdma_init_module(void)
 	return 0;
=20
 err_be_reg:
+#if IS_ENABLED(CONFIG_IPV6)
 	ocrdma_unregister_inet6addr_notifier();
 err_notifier6:
+#endif
 	ocrdma_unregister_inetaddr_notifier();
 	return status;
 }
--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
