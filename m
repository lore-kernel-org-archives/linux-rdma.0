From: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH RFC rdma-core 1/3] util: Add common code for provider debug
Date: Tue, 17 Jan 2017 13:46:53 -0600
Message-ID: <1484682413-56580-1-git-send-email-tatyana.e.nikolova@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add common utility functions to print error and
debug information, which can be used by all
providers.

The debug information can be classified with
VERBS_PROVIDER_DBG_MASK and can be enabled and
promoted with VERBS_PROVIDER_DBG_LEVEL,
both mask and level are environmental variables.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 buildlib/rdma_functions.cmake |  2 +-
 util/CMakeLists.txt           |  8 ++++
 util/dbg.c                    | 83 +++++++++++++++++++++++++++++++++++++
 util/dbg.h                    | 95 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 187 insertions(+), 1 deletion(-)
 create mode 100644 util/dbg.c
 create mode 100644 util/dbg.h

diff --git a/buildlib/rdma_functions.cmake b/buildlib/rdma_functions.cmake
index fcd47a3..84e2841 100644
--- a/buildlib/rdma_functions.cmake
+++ b/buildlib/rdma_functions.cmake
@@ -6,7 +6,7 @@
 # Global list of pairs of (SHARED STATIC) libary target names
 set(RDMA_STATIC_LIBS "" CACHE INTERNAL "Doc" FORCE)
 
-set(COMMON_LIBS_PIC ccan_pic)
+set(COMMON_LIBS_PIC ccan_pic util_pic)
 set(COMMON_LIBS ccan)
 
 # Install a symlink during 'make install'
diff --git a/util/CMakeLists.txt b/util/CMakeLists.txt
index 1cda890..fb36103 100644
--- a/util/CMakeLists.txt
+++ b/util/CMakeLists.txt
@@ -1,3 +1,11 @@
 publish_internal_headers(util
   compiler.h
+  dbg.h
   )
+
+set(C_FILES
+  dbg.c
+  )
+
+add_library(util_pic ${C_FILES})
+set_property(TARGET util_pic PROPERTY POSITION_INDEPENDENT_CODE TRUE)
diff --git a/util/dbg.c b/util/dbg.c
new file mode 100644
index 0000000..8e97b35
--- /dev/null
+++ b/util/dbg.c
@@ -0,0 +1,83 @@
+/*******************************************************************************
+*
+* Copyright (c) 2012 Mellanox Technologies, Inc.  All rights reserved.
+* Copyright (c) 2015-2016 QLogic Corporation.  All rights reserved.
+* Copyright (c) 2017 Intel Corporation.  All rights reserved.
+*
+* This software is available to you under a choice of one of two
+* licenses.  You may choose to be licensed under the terms of the GNU
+* General Public License (GPL) Version 2, available from the file
+* COPYING in the main directory of this source tree, or the
+* OpenFabrics.org BSD license below:
+*
+*   Redistribution and use in source and binary forms, with or
+*   without modification, are permitted provided that the following
+*   conditions are met:
+*
+*    - Redistributions of source code must retain the above
+*	copyright notice, this list of conditions and the following
+*	disclaimer.
+*
+*    - Redistributions in binary form must reproduce the above
+*	copyright notice, this list of conditions and the following
+*	disclaimer in the documentation and/or other materials
+*	provided with the distribution.
+*
+* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+* BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+* ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+* CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+* SOFTWARE.
+*
+*******************************************************************************/
+
+#include "dbg.h"
+
+uint64_t rdma_dbg_mask;
+uint32_t rdma_dbg_level;
+
+void setup_debug(void)
+{
+	char *env;
+
+	env = getenv(VERBS_PROVIDER_DBG_MASK);
+	if (env)
+		rdma_dbg_mask = strtoull(env, NULL, 0);
+
+	env = getenv(VERBS_PROVIDER_DBG_LEVEL);
+	if (env)
+		rdma_dbg_level = strtoul(env, NULL, 0);
+
+	if (!rdma_dbg_level && rdma_dbg_mask)
+		rdma_dbg_level = VERBS_DBG_LEVEL_VERBOSE;
+
+	if (rdma_dbg_level && !rdma_dbg_mask)
+		rdma_dbg_mask = VERBS_DBG_MASK_ALL;
+}
+
+FILE *open_debug_file(void)
+{
+	FILE *dbg_fp;
+	char *env;
+
+	env = getenv(VERBS_PROVIDER_DBG_FILE);
+	if (!env)
+		return NULL;
+
+	dbg_fp = fopen(env, "aw+");
+	if (!dbg_fp) {
+		PRINT_ERR("Unable to open debug file %s, using stderr\n", env);
+		return NULL;
+	}
+
+	return dbg_fp;
+}
+
+void close_debug_file(FILE *dbg_fp)
+{
+	if (dbg_fp != stderr)
+		fclose(dbg_fp);
+}
diff --git a/util/dbg.h b/util/dbg.h
new file mode 100644
index 0000000..e9e66bf
--- /dev/null
+++ b/util/dbg.h
@@ -0,0 +1,95 @@
+/*******************************************************************************
+*
+* Copyright (c) 2012 Mellanox Technologies, Inc.  All rights reserved.
+* Copyright (c) 2015-2016 QLogic Corporation.  All rights reserved.
+* Copyright (c) 2017 Intel Corporation.  All rights reserved.
+*
+* This software is available to you under a choice of one of two
+* licenses.  You may choose to be licensed under the terms of the GNU
+* General Public License (GPL) Version 2, available from the file
+* COPYING in the main directory of this source tree, or the
+* OpenFabrics.org BSD license below:
+*
+*   Redistribution and use in source and binary forms, with or
+*   without modification, are permitted provided that the following
+*   conditions are met:
+*
+*    - Redistributions of source code must retain the above
+*	copyright notice, this list of conditions and the following
+*	disclaimer.
+*
+*    - Redistributions in binary form must reproduce the above
+*	copyright notice, this list of conditions and the following
+*	disclaimer in the documentation and/or other materials
+*	provided with the distribution.
+*
+* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+* BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+* ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+* CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+* SOFTWARE.
+*
+*******************************************************************************/
+
+#ifndef UTIL_DBG_H
+#define UTIL_DBG_H
+
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <stddef.h>
+
+#define VERBS_PROVIDER_DBG_MASK  "VERBS_PROVIDER_DBG_MASK"
+#define VERBS_PROVIDER_DBG_LEVEL "VERBS_PROVIDER_DBG_LEVEL"
+#define VERBS_PROVIDER_DBG_FILE  "VERBS_PROVIDER_DBG_FILE"
+
+#define VERBS_DBG_MASK_QP      0x1
+#define VERBS_DBG_MASK_CQ      0x2
+#define VERBS_DBG_MASK_QP_SEND 0x4
+#define VERBS_DBG_MASK_QP_RECV 0x8
+#define VERBS_DBG_MASK_MR      0x10
+#define VERBS_DBG_MASK_PD      0x20
+#define VERBS_DBG_MASK_CONTIG  0x40
+#define VERBS_DBG_MASK_ALL     0xFFFFFFFF
+
+/* a debug level enables all lower levels */
+#define VERBS_DBG_LEVEL_ERR     0x1
+#define VERBS_DBG_LEVEL_WARN    0x2
+#define VERBS_DBG_LEVEL_INFO    0x3
+#define VERBS_DBG_LEVEL_VERBOSE 0xF
+
+extern uint64_t rdma_dbg_mask;
+extern uint32_t rdma_dbg_level;
+
+#define PRINT_ERR(fmt, ...)								\
+do {											\
+	fprintf(stderr, "[%s:%d]" fmt, __func__, __LINE__, ##__VA_ARGS__);		\
+} while (0)
+
+#define PRINT_DBG(dbg_mask, dbg_level, fmt, ...)					\
+do {											\
+	if ((rdma_dbg_mask & dbg_mask) && (rdma_dbg_level >= dbg_level))		\
+		fprintf(stderr, "[%s:%d]" fmt, __func__, __LINE__, ##__VA_ARGS__);	\
+} while (0)
+
+#define LOG_DBG(dbg_fp, dbg_mask, dbg_level, fmt, ...)					\
+do {											\
+	if ((rdma_dbg_mask & dbg_mask) && (rdma_dbg_level >= dbg_level))		\
+		fprintf(dbg_fp, "[%s:%d]" fmt, __func__, __LINE__, ##__VA_ARGS__);	\
+} while (0)
+
+#define LOG_DBG_FLUSH(dbg_fp, dbg_mask, dbg_level, fmt, ...)				\
+do {											\
+		LOG_DBG(dbg_fp, dbg_mask, dbg_level, fmt, ##__VA_ARGS__);		\
+		if (dbg_fp != stderr)							\
+			fflush(dbg_fp);							\
+} while (0)
+
+void setup_debug(void);
+FILE *open_debug_file(void);
+void close_debug_file(FILE *);
+
+#endif
-- 
1.8.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
