From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH rdma-core] debian: Do not require valgrind on ia64
Date: Fri, 19 Jan 2018 12:45:23 +0100
Message-ID: <20180119114523.4864-1-benjamin.drung@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

valgrind was not ported to ia64, and thus rdma-core shouldn't
build-depend on it.

Closes: #887511
Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 debian/control | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/debian/control b/debian/control
index de79cb30..c3b1aadc 100644
--- a/debian/control
+++ b/debian/control
@@ -15,7 +15,7 @@ Build-Depends: cmake (>= 2.8.11),
                ninja-build,
                pkg-config,
                python,
-               valgrind [!alpha !armel !hppa !m68k !powerpcspe !sh4 !sparc64 !x32]
+               valgrind [!alpha !armel !hppa !ia64 !m68k !powerpcspe !sh4 !sparc64 !x32]
 Standards-Version: 4.1.3
 Vcs-Git: https://github.com/linux-rdma/rdma-core.git
 Vcs-Browser: https://github.com/linux-rdma/rdma-core
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
