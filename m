From: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core] debian: Update Copyright file
Date: Mon, 3 Apr 2017 13:13:30 +0300
Message-ID: <20170403101330.11174-1-talatb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 debian/copyright | 42 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 4 deletions(-)

diff --git a/debian/copyright b/debian/copyright
index 576ab2b..a1a8c3d 100644
--- a/debian/copyright
+++ b/debian/copyright
@@ -13,14 +13,35 @@ Copyright: 2015-2016, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
            2016-2017, Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
 License: GPL-2
 
-Files: buildlib/cbuild
-Copyright: 2015-2016, Obsidian Research Corp.
+Files: CMakeLists.txt
+Copyright: 2015-2017, Obsidian Research Corporation.
 License: GPL-2 or BSD
 
-Files: buildlib/fixup-include/*
+Files: buildlib/*
+Copyright: 2015-2017, Obsidian Research Corporation.
+License: GPL-2 or BSD
+
+Files: buildlib/fixup-include/rdma-vmw_pvrdma-abi.h
+Copyright: 2012-2016 VMware, Inc.
+License: GPL-2 or BSD
+
+Files: buildlib/fixup-include/stdatomic.h
+Copyright: 2011 Ed Schouten <ed-HZy0K5TPuP5AfugRpC6u6w@public.gmane.org>
+                David Chisnall <theraven-HZy0K5TPuP5AfugRpC6u6w@public.gmane.org>
+License: BSD-2-clause
+
+Files: buildlib/fixup-include/rdma-rdma_user_rxe.h
 Copyright: 2016, Mellanox Technologies Ltd.
 License: GPL-2 or BSD
 
+Files: buildlib/relpath
+Copyright: 2017 Mellanox Technologies, Inc.
+License: GPL-2 or BSD
+
+Files: buildlib/sparse-include/*
+Copyright: 2017 Obsidian Research Corporation.
+License: GPL-2 or BSD
+
 Files: ccan/*
 Copyright: unspecified
 License: CC0 and BSD-MIT
@@ -64,7 +85,12 @@ Files: libibumad/*
 Copyright: 2004-2008, Voltaire Inc.
 License: GPL-2 or BSD
 
-Files: libibumad/tests/*
+Files: libibumad/tests/umad_compile_test.c
+Copyright: 2017 Mellanox Technologies LTD.
+License: GPL-2 or BSD
+
+Files: libibumad/tests/umad_reg2_compat.c
+  libibumad/tests/umad_register2.c
 Copyright: 2014, Intel Corporation.
 License: GPL-2 or BSD
 
@@ -355,6 +381,10 @@ Copyright: 2009, System Fabric Works, Inc.
            2005, PathScale, Inc.
 License: GPL-2 or BSD
 
+Files: providers/vmw_pvrdma/*
+Copyright: 2012-2016 VMware, Inc.
+License: GPL-2 or BSD
+
 Files: rdma-ndd/*
 Copyright: 2016, Intel Corporation.
 License: GPL-2 or BSD
@@ -384,6 +414,10 @@ Files: srp_daemon/srp_daemon.sh.in
 Copyright: 2006, Mellanox Technologies.
 License: GPL-2 or BSD
 
+Files: util/udma_barrier.h
+Copyright: 2005 Topspin Communications.
+License: GPL-2 or BSD
+
 License: BSD
  OpenIB.org BSD license (MIT variant)
  Redistribution and use in source and binary forms, with or
-- 
2.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
