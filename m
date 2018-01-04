From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH rdma-core 1/2] debian: Bump Standards-Version to 4.1.3
Date: Thu,  4 Jan 2018 15:27:50 +0100
Message-ID: <20180104142751.32705-1-benjamin.drung@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

No changes are needed to support the new Debian policy version. See
https://www.debian.org/doc/debian-policy/ for details.

Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 debian/control | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/debian/control b/debian/control
index 27d23791..2342b623 100644
--- a/debian/control
+++ b/debian/control
@@ -16,7 +16,7 @@ Build-Depends: cmake (>= 2.8.11),
                pkg-config,
                python,
                valgrind [!alpha !armel !hppa !m68k !powerpcspe !sh4 !sparc64 !x32]
-Standards-Version: 4.1.1
+Standards-Version: 4.1.3
 Vcs-Git: https://github.com/linux-rdma/rdma-core.git
 Vcs-Browser: https://github.com/linux-rdma/rdma-core
 Homepage: https://github.com/linux-rdma/rdma-core
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
