From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH krping 2/2] Update Makefile
Date: Wed, 11 Sep 2013 17:20:24 +0300
Message-ID: <1378909224-27399-3-git-send-email-ogerlitz@mellanox.com>
References: <1378909224-27399-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378909224-27399-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, alext-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Alex Tabachnik <alext-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

To allow standalone compilation with latest 3.x kernels

Signed-off-by: Alex Tabachnik <alext-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 Makefile |   33 +++------------------------------
 1 files changed, 3 insertions(+), 30 deletions(-)

diff --git a/Makefile b/Makefile
index abfaeb1..47fa0c0 100644
--- a/Makefile
+++ b/Makefile
@@ -1,42 +1,15 @@
-KSRC=/lib/modules/`uname -r`/source
+KSRC=/lib/modules/`uname -r`/build
 KOBJ=/lib/modules/`uname -r`/build
 
-#
-# Use this if you're building on a OFED system.  Make sure you
-# configure the ofa_kernel-1.3 tree with the options from 
-# /etc/infiniband/info
-#
-OFA=/usr/src/ofa_kernel
-#
-# Use this if you're building against a kernel.org kernel with
-# rdma support enabled.
-# 
-#OFA=$(KSRC)
-#OFA=$(KOBJ)
-
-#
-# Set ARCH to x86 for both i386 and x86_64
-#
-ARCH=x86
-EXTRA_CFLAGS += -DLINUX -D__KERNEL__ -DMODULE -O2 -pipe -Wall
-EXTRA_CFLAGS += -I$(OFA)/arch/$(ARCH)/include -I$(OFA)/include -I$(KOBJ)/include -I$(KOBJ)/include2 -I$(KSRC)/include -I.
-EXTRA_CFLAGS += $(shell [ -f $(KOBJ)/include/linux/modversions.h ] && \
-            echo "-DMODVERSIONS -DEXPORT_SYMTAB \
-                  -include $(KSRC)/include/linux/modversions.h")
-EXTRA_CFLAGS += $(shell [ -f $(KOBJ)/include/config/modversions.h ] && \
-            echo "-DMODVERSIONS -DEXPORT_SYMTAB \
-                  -include $(KSRC)/include/config/modversions.h")
 
 obj-m += rdma_krping.o
 rdma_krping-y			:= getopt.o krping.o
 
 default:
-	-cp -f $(OFA)/Module.markers `pwd`
-	-cp -f $(OFA)/Module.symvers `pwd`
-	make -C $(KSRC) O=$(KOBJ) SUBDIRS=$(shell pwd) LINUXINCLUDE='-I$(OFA)/include -Iinclude -include $(KOBJ)/include/linux/autoconf.h -include linux/autoconf.h' modules
+	make -C $(KSRC) M=`pwd` modules
 
 install:
-	make -C $(KSRC) O=$(KOBJ) SUBDIRS=$(shell pwd) modules_install
+	make -C $(KSRC) M=`pwd` modules_install
 	depmod -a
 
 clean:
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
