From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH rdma-core] Documentation: install udev.md
Date: Fri, 25 Aug 2017 08:18:53 +0200
Message-ID: <2a1f628e-bc6c-2654-5416-95e8911731f2@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

udev.md is referenced by rdma-hw,target and rdma-load-modules@.service
and needs to be installed.

Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
---
 Documentation/CMakeLists.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/CMakeLists.txt b/Documentation/CMakeLists.txt
index 6170b5f2..d6e08ded 100644
--- a/Documentation/CMakeLists.txt
+++ b/Documentation/CMakeLists.txt
@@ -5,6 +5,7 @@ install(FILES
   libibverbs.md
   librdmacm.md
   rxe.md
+  udev.md
   ../README.md
   ../MAINTAINERS
   DESTINATION "${CMAKE_INSTALL_DOCDIR}")
-- 
2.14.1.252.gf15771ee3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
