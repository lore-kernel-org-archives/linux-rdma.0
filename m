From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 06/26] lib/dma-noop: Only build dma_noop_ops for m32r and s390
Date: Thu, 12 Jan 2017 11:06:58 -0800
Message-ID: <20170112190718.6728-7-bart.vanassche@sandisk.com>
References: <20170112190718.6728-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170112190718.6728-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Christian Borntraeger <borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Joerg Roedel <jroedel-l3A5Bk7waGM@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Michael S . Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This was suggested by Christoph Hellwig.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christian Borntraeger <borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Cc: Joerg Roedel <jroedel-l3A5Bk7waGM@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 arch/m32r/Kconfig | 1 +
 arch/s390/Kconfig | 1 +
 lib/Kconfig       | 5 +++++
 lib/Makefile      | 2 +-
 4 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index d227a6988d6b..95474460b367 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -18,6 +18,7 @@ config M32R
 	select MODULES_USE_ELF_RELA
 	select HAVE_DEBUG_STACKOVERFLOW
 	select CPU_NO_EFFICIENT_FFS
+	select DMA_NOOP_OPS
 
 config SBUS
 	bool
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index c6722112527d..38ad42358c41 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -137,6 +137,7 @@ config S390
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DMA_API_DEBUG
 	select HAVE_DMA_CONTIGUOUS
+	select DMA_NOOP_OPS
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_DYNAMIC_FTRACE_WITH_REGS
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
diff --git a/lib/Kconfig b/lib/Kconfig
index 260a80e313b9..b6baf0609e8b 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -395,6 +395,11 @@ config HAS_DMA
 	depends on !NO_DMA
 	default y
 
+config DMA_NOOP_OPS
+	bool
+	depends on HAS_DMA && (!64BIT || ARCH_DMA_ADDR_T_64BIT)
+	default n
+
 config CHECK_SIGNATURE
 	bool
 
diff --git a/lib/Makefile b/lib/Makefile
index bc4073a8cd08..ada06d5652e8 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -26,7 +26,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
-lib-$(CONFIG_HAS_DMA) += dma-noop.o
+lib-$(CONFIG_DMA_NOOP_OPS) += dma-noop.o
 
 lib-y	+= kobject.o klist.o
 obj-y	+= lockref.o
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
