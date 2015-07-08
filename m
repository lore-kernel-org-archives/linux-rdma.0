From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] IB/core: Destroy multcast_idr on moudle exit
Date: Wed,  8 Jul 2015 17:21:15 +0200
Message-ID: <1436368875-31014-1-git-send-email-jthumshirn@suse.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Destroy multcast_idr on moudle exit, reclaiming the allocated memory.

This was detected by the following semantic patch (written by Luis Rodriguez
<mcgrof-IBi9RG/b67k@public.gmane.org>)
<SmPL>
@ defines_module_init @
declarer name module_init, module_exit;
declarer name DEFINE_IDR;
identifier init;
@@

module_init(init);

@ defines_module_exit @
identifier exit;
@@

module_exit(exit);

@ declares_idr depends on defines_module_init && defines_module_exit @
identifier idr;
@@

DEFINE_IDR(idr);

@ on_exit_calls_destroy depends on declares_idr && defines_module_exit @
identifier declares_idr.idr, defines_module_exit.exit;
@@

exit(void)
{
 ...
 idr_destroy(&idr);
 ...
}

@ missing_module_idr_destroy depends on declares_idr && defines_module_exit && !on_exit_calls_destroy @
identifier declares_idr.idr, defines_module_exit.exit;
@@

exit(void)
{
 ...
 +idr_destroy(&idr);
}
 
</SmPL>

Signed-off-by: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
---
 drivers/infiniband/core/ucma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index ad45469..fb50598 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -1616,6 +1616,7 @@ static void __exit ucma_cleanup(void)
 	device_remove_file(ucma_misc.this_device, &dev_attr_abi_version);
 	misc_deregister(&ucma_misc);
 	idr_destroy(&ctx_idr);
+	idr_destroy(&multicast_idr);
 }
 
 module_init(ucma_init);
-- 
2.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
