From: Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>
Subject: [PATCH -next] infiniband: fix ipath_chip_init.c build errors
Date: Fri, 07 Oct 2011 13:59:41 -0700
Message-ID: <4E8F683D.9020604@xenotime.net>
References: <20111007174230.702f4a0bf1fe71dab5e10961@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111007174230.702f4a0bf1fe71dab5e10961-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Cc: linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Marciniszyn <infinipath-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>

Add <linux/stat.h> to fix build errors:

drivers/infiniband/hw/ipath/ipath_init_chip.c:54:1: error: 'S_IRUGO' undeclared here (not in a function)
drivers/infiniband/hw/ipath/ipath_init_chip.c:54:1: error: bit-field '<anonymous>' width not an integer constant
drivers/infiniband/hw/ipath/ipath_init_chip.c:67:1: error: 'S_IWUSR' undeclared here (not in a function)
drivers/infiniband/hw/ipath/ipath_init_chip.c:67:1: error: bit-field '<anonymous>' width not an integer constant

Signed-off-by: Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>
Cc:	Mike Marciniszyn <infinipath-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 drivers/infiniband/hw/ipath/ipath_init_chip.c |    1 +
 1 file changed, 1 insertion(+)

--- next-2011-1007.orig/drivers/infiniband/hw/ipath/ipath_init_chip.c
+++ next-2011-1007/drivers/infiniband/hw/ipath/ipath_init_chip.c
@@ -35,6 +35,7 @@
 #include <linux/netdevice.h>
 #include <linux/moduleparam.h>
 #include <linux/slab.h>
+#include <linux/stat.h>
 #include <linux/vmalloc.h>
 
 #include "ipath_kernel.h"
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
