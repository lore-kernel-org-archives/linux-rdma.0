From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 11/11] libbnxtre: Add versioning support
Date: Sat, 28 Jan 2017 17:13:42 -0500
Message-ID: <1485641622-30015-12-git-send-email-devesh.sharma@broadcom.com>
References: <1485641622-30015-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485641622-30015-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch adds a new header file to maintain
the version of library code. Each time a new
patch series is applied, this file would be
updated. Currently, the macros declared in this
header are not referred anywhere in the code. however,
those can be used during RPM file generation.

Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 providers/bnxtre/version.h | 53 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)
 create mode 100644 providers/bnxtre/version.h

diff --git a/providers/bnxtre/version.h b/providers/bnxtre/version.h
new file mode 100644
index 0000000..415ef41
--- /dev/null
+++ b/providers/bnxtre/version.h
@@ -0,0 +1,53 @@
+/*
+ * Broadcom NetXtreme-E User Space RoCE driver
+ *
+ * Copyright (c) 2015-2016, Broadcom. All rights reserved.  The term
+ * Broadcom refers to Broadcom Limited and/or its subsidiaries.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * BSD license below:
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS''
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
+ * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
+ * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS
+ * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
+ * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
+ * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
+ * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
+ * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ * Description: current release version information
+ */
+
+#ifndef __BNXT_RE_VERSION_H__
+#define __BNXT_RE_VERSION_H__
+
+#define	MAJOR_VERSION		"1"
+#define	MINOR_VERSION		"0"
+#define	SUB_MINOR_VERSION	"0"
+
+#define	LIBBNXT_RE_VERSION(a, b, c)	a"."b"."c
+
+#define LIBBNXT_RE_REL_VERSION	LIBBNXT_RE_VERSION(MAJOR_VERSION,\
+						   MINOR_VERSION,\
+						   SUB_MINOR_VERSION)
+#define LIBBNXT_RE_BUILD_VERSION	1.0.0
+
+#endif	/* __BNXT_RE_VERSION_H__ */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
