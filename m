From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH rdma-core 2/3] debian: Do not require valgrind if not available
Date: Tue, 14 Nov 2017 12:33:29 +0100
Message-ID: <20171114113330.2715-3-benjamin.drung@profitbricks.com>
References: <20171114113330.2715-1-benjamin.drung@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114113330.2715-1-benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

valgrind is not available for all architectures. Since valgrind is an
optional build dependency, do not require it for those architectures.
---
 debian/control | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/debian/control b/debian/control
index 5fee479c..c5f7a052 100644
--- a/debian/control
+++ b/debian/control
@@ -15,7 +15,7 @@ Build-Depends: cmake (>= 2.8.11),
                ninja-build,
                pkg-config,
                python,
-               valgrind
+               valgrind [!alpha !armel !hppa !m68k !powerpcspe !sh4 !sparc64]
 Standards-Version: 4.1.0
 Vcs-Git: https://github.com/linux-rdma/rdma-core.git
 Vcs-Browser: https://github.com/linux-rdma/rdma-core
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
