From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH rdma-core 3/3] debian: Do not require valgrind on x32
Date: Thu, 16 Nov 2017 17:32:46 +0100
Message-ID: <20171116163246.29736-4-benjamin.drung@profitbricks.com>
References: <20171116163246.29736-1-benjamin.drung@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171116163246.29736-1-benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

valgrind fails to build on x32 and therefore is not available on that
architecture.

Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 debian/control | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/debian/control b/debian/control
index 0426fd2e..cddc9db5 100644
--- a/debian/control
+++ b/debian/control
@@ -15,7 +15,7 @@ Build-Depends: cmake (>= 2.8.11),
                ninja-build,
                pkg-config,
                python,
-               valgrind [!alpha !armel !hppa !m68k !powerpcspe !sh4 !sparc64]
+               valgrind [!alpha !armel !hppa !m68k !powerpcspe !sh4 !sparc64 !x32]
 Standards-Version: 4.1.1
 Vcs-Git: https://github.com/linux-rdma/rdma-core.git
 Vcs-Browser: https://github.com/linux-rdma/rdma-core
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
