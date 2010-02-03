From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] compat-dapl-1.2: update Copyright file and include the 3
 license files in distribution
Date: Wed, 3 Feb 2010 14:14:54 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C983B2E3A41B@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Update Copyright file and include the 3 license files in distribution

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 COPYING      |   16 ++++------------
 Makefile.am  |    3 +++
 dapl.spec.in |    2 +-
 3 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/COPYING b/COPYING
index 2012c04..35ba319 100644
--- a/COPYING
+++ b/COPYING
@@ -1,7 +1,7 @@
 #
 # Copyright (c) 2002-2005, Network Appliance, Inc. All rights reserved.
 # Copyright (c) 2005 Voltaire Inc.  All rights reserved.
-# Copyright (c) 2005 Intel Corporation. All rights reserved.
+# Copyright (c) 2005-2010 Intel Corporation. All rights reserved.
 # Copyright (c) 2004-2005, Mellanox Technologies, Inc. All rights reserved. 
 # Copyright (c) 2003 Topspin Corporation.  All rights reserved. 
 # Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
@@ -9,19 +9,13 @@
 # This Software is licensed under one of the following licenses:
 #
 # 1) under the terms of the "Common Public License 1.0" a copy of which is
-#    in the file LICENSE.txt in the root directory. The license is also
-#    available from the Open Source Initiative, see
-#    http://www.opensource.org/licenses/cpl.php.
+#    in the file LICENSE.txt in the root directory. 
 #
 # 2) under the terms of the "The BSD License" a copy of which is in the file
-#    LICENSE2.txt in the root directory. The license is also available from
-#    the Open Source Initiative, see
-#    http://www.opensource.org/licenses/bsd-license.php.
+#    LICENSE2.txt in the root directory. 
 #
 # 3) under the terms of the "GNU General Public License (GPL) Version 2" a 
-#    copy of which is in the file LICENSE3.txt in the root directory. The 
-#    license is also available from the Open Source Initiative, see
-#    http://www.opensource.org/licenses/gpl-license.php.
+#    copy of which is in the file LICENSE3.txt in the root directory. 
 #
 # Licensee has the right to choose one of the above licenses.
 #
@@ -32,5 +26,3 @@
 # notice, one of the license notices in the documentation
 # and/or other materials provided with the distribution.
 #
-
-
diff --git a/Makefile.am b/Makefile.am
index 9c236e1..b353180 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -354,6 +354,9 @@ EXTRA_DIST = dat/common/dat_dictionary.h \
 	     dapl/udapl/libdaplcma.map \
              dapl/udapl/libdaplscm.map \
 	     dapl.spec.in \
+	     LICENSE.txt \
+	     LICENSE2.txt \
+	     LICENSE3.txt \
 	     $(man_MANS) \
 	     test/dapltest/include/dapl_bpool.h \
 	     test/dapltest/include/dapl_client_info.h \
diff --git a/dapl.spec.in b/dapl.spec.in
index 1045f46..fec23bf 100644
--- a/dapl.spec.in
+++ b/dapl.spec.in
@@ -117,7 +117,7 @@ fi
 %files
 %defattr(-,root,root,-)
 %{_libdir}/libda*.so.*
-%doc AUTHORS README ChangeLog
+%doc AUTHORS README COPYING ChangeLog LICENSE.txt LICENSE2.txt LICENSE3.txt
 
 %files devel
 %defattr(-,root,root,-)
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
