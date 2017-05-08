From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next] IB/netlink: Remove export of ibnl_chk_listeners function
Date: Mon,  8 May 2017 15:13:43 +0300
Message-ID: <20170508121343.3213-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The ibnl_chk_listeners() function is called in the code
located at the same module, hence no need to be exported.

Remove EXPORT_SYMBOL from it.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/netlink.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
index 10469b0088b5..ebd16885cfce 100644
--- a/drivers/infiniband/core/netlink.c
+++ b/drivers/infiniband/core/netlink.c
@@ -55,7 +55,6 @@ int ibnl_chk_listeners(unsigned int group)
 		return -1;
 	return 0;
 }
-EXPORT_SYMBOL(ibnl_chk_listeners);

 int ibnl_add_client(int index, int nops,
 		    const struct ibnl_client_cbs cb_table[])
--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
