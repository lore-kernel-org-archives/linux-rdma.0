From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 06/16] iwpm: Update autotools enough to build
Date: Tue, 20 Sep 2016 16:10:15 -0600
Message-ID: <1474409425-15769-7-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474409425-15769-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474409425-15769-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

auto* drift has rendered it unbuildable on modern distros.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 iwpmd/NEWS         |  0
 iwpmd/autogen.sh   | 10 +---------
 iwpmd/configure.ac |  2 +-
 3 files changed, 2 insertions(+), 10 deletions(-)
 create mode 100644 iwpmd/NEWS

diff --git a/iwpmd/NEWS b/iwpmd/NEWS
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/iwpmd/autogen.sh b/iwpmd/autogen.sh
index 4827884ba1f1..6abb4f8446bd 100755
--- a/iwpmd/autogen.sh
+++ b/iwpmd/autogen.sh
@@ -1,11 +1,3 @@
 #! /bin/sh
 
-# create config dir if not exist
-test -d config || mkdir config
-
-set -x
-aclocal -I config
-libtoolize --force --copy
-autoheader
-automake --foreign --add-missing --copy
-autoconf
+autoreconf -ifv -I config
diff --git a/iwpmd/configure.ac b/iwpmd/configure.ac
index 989452a6295c..5d5388ba2ed9 100644
--- a/iwpmd/configure.ac
+++ b/iwpmd/configure.ac
@@ -7,7 +7,7 @@ AC_CONFIG_SRCDIR([src/iwarp_pm_server.c])
 AC_CONFIG_HEADERS([config.h])
 AC_CONFIG_AUX_DIR(config)
 AC_CONFIG_MACRO_DIR([m4])
-AM_INIT_AUTOMAKE(-Wall -Werror)
+AM_INIT_AUTOMAKE([-Wall -Werror subdir-objects])
 
 # Checks for programs.
 AC_PROG_CC
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
