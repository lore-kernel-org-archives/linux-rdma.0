From: Nicolas Morey-Chaisemartin <nicolas-PVCUbA2IIkVH1sytvemUSjhD77mM7E+b@public.gmane.org>
Subject: [PATCH rdma-core] util: fix bad argument passed to s390_mmio_write
Date: Fri, 4 Aug 2017 11:18:37 +0200
Message-ID: <7e93dac1-6b15-6ca0-efba-6c05b92afe17@morey-chaisemartin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
---
 util/mmio.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/util/mmio.h b/util/mmio.h
index be22fb76..101af9dd 100644
--- a/util/mmio.h
+++ b/util/mmio.h
@@ -208,7 +208,7 @@ __le64 mmio_read64_le(const void *addr);
 #ifdef __s390x__
 static inline void mmio_memcpy_x64(void *dest, const void *src, size_t bytecnt)
 {
-	s390_mmio_write(addr, src, bytecnt);
+	s390_mmio_write(dest, src, bytecnt);
 }
 #else
 
-- 
2.14.0.rc1.4.gab083fa77

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
