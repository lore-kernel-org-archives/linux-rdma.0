From: Sudip Mukherjee <sudipm.mukherjee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] staging: ipath: fix build failure
Date: Tue,  1 Sep 2015 18:31:38 +0530
Message-ID: <1441112498-22057-1-git-send-email-sudipm.mukherjee@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, Jim Davis <jim.epost-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sudip Mukherjee <sudipm.mukherjee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

building of ipath depends on infiniband. And if ipath is selected and
infiniband is not then build fails with:
ERROR: "ib_alloc_device" [drivers/staging/ipath/ib_ipath.ko] undefined!
ERROR: "ib_dealloc_device" [drivers/staging/ipath/ib_ipath.ko] undefined!
ERROR: "ib_dispatch_event" [drivers/staging/ipath/ib_ipath.ko] undefined!
ERROR: "ib_register_device" [drivers/staging/ipath/ib_ipath.ko] undefined!
ERROR: "ib_unregister_device" [drivers/staging/ipath/ib_ipath.ko] undefined!
ERROR: "ib_modify_qp_is_ok" [drivers/staging/ipath/ib_ipath.ko] undefined!
ERROR: "ib_wq" [drivers/staging/ipath/ib_ipath.ko] undefined!

Config at: https://lkml.org/lkml/2015/8/31/328

Reported-by: Jim Davis <jim.epost-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sudip Mukherjee <sudip-ofJRbWXBVFamYgehrs7/Lw@public.gmane.org>
---
 drivers/staging/ipath/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/ipath/Kconfig b/drivers/staging/ipath/Kconfig
index 041ce06..1edc21b 100644
--- a/drivers/staging/ipath/Kconfig
+++ b/drivers/staging/ipath/Kconfig
@@ -1,6 +1,7 @@
 config INFINIBAND_IPATH
 	tristate "QLogic HTX HCA support"
 	depends on 64BIT && NET && HT_IRQ
+	depends on INFINIBAND
 	---help---
 	This is a driver for the deprecated QLogic Hyper-Transport
 	IB host channel adapter (model QHT7140),
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
