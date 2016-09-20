From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 05/16] ibcm: Actually use the version script when linking
Date: Tue, 20 Sep 2016 16:10:14 -0600
Message-ID: <1474409425-15769-6-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474409425-15769-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474409425-15769-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

There is a typo in the Makefile.am that resulted in the version
script being ignored.

This changes the symbol names in the shlib, eg
    50: 0000000000001620   530 FUNC    GLOBAL DEFAULT   11 ib_cm_open_device
becomes
    46: 00000000000015f0   530 FUNC    GLOBAL DEFAULT   12 ib_cm_open_device@@IBCM_1.0

Binaries linked to the old library will continue to work with the new one.

Binaries linked to the new library will print a dynamic linker warning when
using the old library:

  ./a.out: /usr/lib/x86_64-linux-gnu/libibcm.so.1: no version information available (required by ./a.out)

But apparently continue to work.

Drepper (https://www.akkadia.org/drepper/symbol-versioning) seems to indicate
that going forward if we do decide to rev a symbol version then resolution for
binaries linked to the old library will continue to prefer the IBCM_1.0
symbol.  This makes sense as it is the basic mechanism used to introduce
symbol versions in the first place.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibcm/Makefile.am | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libibcm/Makefile.am b/libibcm/Makefile.am
index e4be9f887b1c..ff0b1ded12a3 100644
--- a/libibcm/Makefile.am
+++ b/libibcm/Makefile.am
@@ -8,9 +8,9 @@ AM_CFLAGS = -g -Wall
 src_libibcm_la_CFLAGS = $(AM_CFLAGS)
 
 if HAVE_LD_VERSION_SCRIPT
-    ibcm_version_script = -Wl,--version-script=$(srcdir)/src/libibcm.map
+    libibcm_version_script = -Wl,--version-script=$(srcdir)/src/libibcm.map
 else
-    ibcm_version_script =
+    libibcm_version_script =
 endif
 
 src_libibcm_la_SOURCES = src/cm.c
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
