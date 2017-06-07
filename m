From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH rdma-core] util: Fix mmio_flush_writes for SPARC and S390x
Date: Wed, 7 Jun 2017 14:58:39 +0200
Message-ID: <88cef736-88c3-08d9-4042-fd73b2d4cb97@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Due to a missing #else, udma_barrier.h failed on sparc and s390x

Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
---
 util/udma_barrier.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/util/udma_barrier.h b/util/udma_barrier.h
index 9932a687..23acf233 100644
--- a/util/udma_barrier.h
+++ b/util/udma_barrier.h
@@ -192,6 +192,7 @@
 #define mmio_flush_writes() asm volatile("dsb st" ::: "memory");
 #elif defined(__sparc__) || defined(__s390x__)
 #define mmio_flush_writes() asm volatile("" ::: "memory")
+#else
 #error No architecture specific memory barrier defines found!
 #endif
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
