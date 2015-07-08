From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] IB/core: Destroy ocrdma_dev_id IDR on module exit
Date: Wed,  8 Jul 2015 17:23:00 +0200
Message-ID: <1436368980-31088-1-git-send-email-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Selvin Xavier <selvin.xavier@avagotech.com>, Devesh Sharma <devesh.sharma@avagotech.com>, Mitesh Ahuja <mitesh.ahuja@avagotech.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-rdma@vger.kernel.org

Destroy ocrdma_dev_id IDR on module exit, reclaiming the allocated memory.

This was detected by the following semantic patch (written by Luis Rodriguez
<mcgrof@suse.com>)
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

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/infiniband/hw/ocrdma/ocrdma_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 8a1398b..d98a707 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -696,6 +696,7 @@ static void __exit ocrdma_exit_module(void)
 	ocrdma_unregister_inet6addr_notifier();
 	ocrdma_unregister_inetaddr_notifier();
 	ocrdma_rem_debugfs();
+	idr_destroy(&ocrdma_dev_id);
 }
 
 module_init(ocrdma_init_module);
-- 
2.4.3
