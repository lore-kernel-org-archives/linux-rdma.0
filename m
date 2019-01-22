From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next 10/19] rdma: Properly mark RDMAtool license
Date: Tue, 22 Jan 2019 20:31:16 +0200
Message-ID: <20190122183125.15920-11-leon@kernel.org>
References: <20190122183125.15920-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190122183125.15920-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

RDMA subsystem is dual-licensed with "GPL-2.0 OR Linux-OpenIB" proper
license and Mellanox submission are supposed to have this type of license.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/Makefile | 2 +-
 rdma/dev.c    | 7 +------
 rdma/link.c   | 7 +------
 rdma/rdma.c   | 7 +------
 rdma/rdma.h   | 7 +------
 rdma/res.c    | 7 +------
 rdma/utils.c  | 7 +------
 7 files changed, 7 insertions(+), 37 deletions(-)

diff --git a/rdma/Makefile b/rdma/Makefile
index ad7f4177..6a424234 100644
--- a/rdma/Makefile
+++ b/rdma/Makefile
@@ -1,4 +1,4 @@
-# SPDX-License-Identifier: GPL-2.0
+# SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 include ../config.mk
 
 TARGETS :=
diff --git a/rdma/dev.c b/rdma/dev.c
index 60ff4b31..954e0015 100644
--- a/rdma/dev.c
+++ b/rdma/dev.c
@@ -1,11 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 /*
  * dev.c	RDMA tool
- *
- *              This program is free software; you can redistribute it and/or
- *              modify it under the terms of the GNU General Public License
- *              as published by the Free Software Foundation; either version
- *              2 of the License, or (at your option) any later version.
- *
  * Authors:     Leon Romanovsky <leonro@mellanox.com>
  */
 
diff --git a/rdma/link.c b/rdma/link.c
index c064be62..89e81b84 100644
--- a/rdma/link.c
+++ b/rdma/link.c
@@ -1,11 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 /*
  * link.c	RDMA tool
- *
- *              This program is free software; you can redistribute it and/or
- *              modify it under the terms of the GNU General Public License
- *              as published by the Free Software Foundation; either version
- *              2 of the License, or (at your option) any later version.
- *
  * Authors:     Leon Romanovsky <leonro@mellanox.com>
  */
 
diff --git a/rdma/rdma.c b/rdma/rdma.c
index 010e9837..676e03c2 100644
--- a/rdma/rdma.c
+++ b/rdma/rdma.c
@@ -1,11 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 /*
  * rdma.c	RDMA tool
- *
- *              This program is free software; you can redistribute it and/or
- *              modify it under the terms of the GNU General Public License
- *              as published by the Free Software Foundation; either version
- *              2 of the License, or (at your option) any later version.
- *
  * Authors:     Leon Romanovsky <leonro@mellanox.com>
  */
 
diff --git a/rdma/rdma.h b/rdma/rdma.h
index 547bb574..d2559e7c 100644
--- a/rdma/rdma.h
+++ b/rdma/rdma.h
@@ -1,11 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
 /*
  * rdma.c	RDMA tool
- *
- *              This program is free software; you can redistribute it and/or
- *              modify it under the terms of the GNU General Public License
- *              as published by the Free Software Foundation; either version
- *              2 of the License, or (at your option) any later version.
- *
  * Authors:     Leon Romanovsky <leonro@mellanox.com>
  */
 #ifndef _RDMA_TOOL_H_
diff --git a/rdma/res.c b/rdma/res.c
index 6d4da38c..f621afa8 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -1,11 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 /*
  * res.c	RDMA tool
- *
- *              This program is free software; you can redistribute it and/or
- *              modify it under the terms of the GNU General Public License
- *              as published by the Free Software Foundation; either version
- *              2 of the License, or (at your option) any later version.
- *
  * Authors:     Leon Romanovsky <leonro@mellanox.com>
  */
 
diff --git a/rdma/utils.c b/rdma/utils.c
index 069d44fe..bce052d5 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -1,11 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 /*
  * utils.c	RDMA tool
- *
- *              This program is free software; you can redistribute it and/or
- *              modify it under the terms of the GNU General Public License
- *              as published by the Free Software Foundation; either version
- *              2 of the License, or (at your option) any later version.
- *
  * Authors:     Leon Romanovsky <leonro@mellanox.com>
  */
 
-- 
2.19.1
