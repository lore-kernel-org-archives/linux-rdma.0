From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V2 1/6] RDMA/core: Commonize RDMA IOCTL declarations location
Date: Wed, 24 Aug 2016 00:31:42 +0300
Message-ID: <1471987907-6336-2-git-send-email-leon@kernel.org>
References: <1471987907-6336-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471987907-6336-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch provides one common file (rdma_user_ioctl.h)
for all RDMA UAPI IOCTLs.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/uapi/rdma/Kbuild            |  1 +
 include/uapi/rdma/hfi/hfi1_user.h   |  2 +-
 include/uapi/rdma/ib_user_mad.h     |  4 +---
 include/uapi/rdma/rdma_user_ioctl.h | 43 +++++++++++++++++++++++++++++++++++++
 4 files changed, 46 insertions(+), 4 deletions(-)
 create mode 100644 include/uapi/rdma/rdma_user_ioctl.h

diff --git a/include/uapi/rdma/Kbuild b/include/uapi/rdma/Kbuild
index 4edb0f2..ac62908 100644
--- a/include/uapi/rdma/Kbuild
+++ b/include/uapi/rdma/Kbuild
@@ -1,5 +1,6 @@
 # UAPI Header export list
 header-y += ib_user_cm.h
+header-y += rdma_user_ioctl.h
 header-y += ib_user_mad.h
 header-y += ib_user_sa.h
 header-y += ib_user_verbs.h
diff --git a/include/uapi/rdma/hfi/hfi1_user.h b/include/uapi/rdma/hfi/hfi1_user.h
index d15e728..a404919 100644
--- a/include/uapi/rdma/hfi/hfi1_user.h
+++ b/include/uapi/rdma/hfi/hfi1_user.h
@@ -57,6 +57,7 @@
 #define _LINUX__HFI1_USER_H
 
 #include <linux/types.h>
+#include <rdma/rdma_user_ioctl.h>
 
 /*
  * This version number is given to the driver by the user code during
@@ -132,7 +133,6 @@
  * User IOCTLs can not go above 128 if they do then see common.h and change the
  * base for the snoop ioctl
  */
-#define IB_IOCTL_MAGIC 0x1b /* See Documentation/ioctl/ioctl-number.txt */
 
 /*
  * Make the ioctls occupy the last 0xf0-0xff portion of the IB range
diff --git a/include/uapi/rdma/ib_user_mad.h b/include/uapi/rdma/ib_user_mad.h
index 09f809f..9de7a2b 100644
--- a/include/uapi/rdma/ib_user_mad.h
+++ b/include/uapi/rdma/ib_user_mad.h
@@ -35,7 +35,7 @@
 #define IB_USER_MAD_H
 
 #include <linux/types.h>
-#include <linux/ioctl.h>
+#include <rdma/rdma_user_ioctl.h>
 
 /*
  * Increment this value if any changes that break userspace ABI
@@ -230,8 +230,6 @@ struct ib_user_mad_reg_req2 {
 	__u8	reserved[3];
 };
 
-#define IB_IOCTL_MAGIC		0x1b
-
 #define IB_USER_MAD_REGISTER_AGENT	_IOWR(IB_IOCTL_MAGIC, 1, \
 					      struct ib_user_mad_reg_req)
 
diff --git a/include/uapi/rdma/rdma_user_ioctl.h b/include/uapi/rdma/rdma_user_ioctl.h
new file mode 100644
index 0000000..ba1bcdd
--- /dev/null
+++ b/include/uapi/rdma/rdma_user_ioctl.h
@@ -0,0 +1,43 @@
+/*
+ * Copyright (c) 2016 Mellanox Technologies, LTD. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef RDMA_USER_IOCTL_H
+#define RDMA_USER_IOCTL_H
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+/* Documentation/ioctl/ioctl-number.txt */
+#define RDMA_IOCTL_MAGIC		0x1b
+#define IB_IOCTL_MAGIC			RDMA_IOCTL_MAGIC
+
+#endif /* RDMA_USER_IOCTL_H */
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
