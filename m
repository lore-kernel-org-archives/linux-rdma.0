From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 libibverbs 5/8] Add helper functions to work with the extended WC
Date: Wed, 24 Feb 2016 11:42:01 +0200
Message-ID: <1456306924-31298-6-git-send-email-yishaih@mellanox.com>
References: <1456306924-31298-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456306924-31298-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add bunch of functions that may help application and drivers
to work with the extended WC. (i.e. ibv_wc_ex)

It includes:
- ibv_wc_ex_get_offsetof_xx functions to get an offset of a specific
  field.
- ibv_wc_ex_getxx functions to get the data of a specific field.

- ibv_wc_ex_get_size - function to get ibv_wc_ex size.

Those functions uses the CQ's WC creation flags and rely
on the order of the fields as described in verbs.h.

To implement the above functions this patch uses the
__builtin_popcountll functionality to calculate how many
bits are set in a given u64.

As on some compilers popcountll doesn't exist the patch adds
ibv_popcount64 with the required implementation and use
it all around.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 Makefile.am                   |   3 +-
 include/infiniband/compiler.h |  91 +++++++++++++++++++++++++++++++++++
 include/infiniband/verbs.h    | 108 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 201 insertions(+), 1 deletion(-)
 create mode 100644 include/infiniband/compiler.h

diff --git a/Makefile.am b/Makefile.am
index 4698ecb..a916acb 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -44,7 +44,8 @@ libibverbsincludedir = $(includedir)/infiniband
 
 libibverbsinclude_HEADERS = include/infiniband/arch.h include/infiniband/driver.h \
     include/infiniband/kern-abi.h include/infiniband/opcode.h include/infiniband/verbs.h \
-    include/infiniband/sa-kern-abi.h include/infiniband/sa.h include/infiniband/marshall.h
+    include/infiniband/sa-kern-abi.h include/infiniband/sa.h include/infiniband/marshall.h \
+    include/infiniband/compiler.h
 
 man_MANS = man/ibv_asyncwatch.1 man/ibv_devices.1 man/ibv_devinfo.1	\
     man/ibv_rc_pingpong.1 man/ibv_uc_pingpong.1 man/ibv_ud_pingpong.1	\
diff --git a/include/infiniband/compiler.h b/include/infiniband/compiler.h
new file mode 100644
index 0000000..5d54fbe
--- /dev/null
+++ b/include/infiniband/compiler.h
@@ -0,0 +1,91 @@
+/*
+ * Copyright (c) 2016 Mellanox, Ltd.  All rights reserved.
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
+#ifndef INFINIBAND_COMPILER_H
+#define INFINIBAND_COMPILER_H
+
+#if (__GNUC__ > 3 || (__GNUC__ == 3 && __GNUC_MINOR__ >= 4))
+#define ibv_popcount64		__builtin_popcountll
+#endif
+
+#ifndef __has_builtin
+#define __has_builtin(x) 0 /* Compatibility with non-clang compilers. */
+#endif
+
+#if __has_builtin(__builtin_popcountll) && !defined(ibv_popcount64)
+#define ibv_popcount64		__builtin_popcountll
+#endif
+
+#ifndef ibv_popcount64
+/* From FreeBSD:
+ * Copyright (C) 1995, 1996, 1997, and 1998 WIDE Project.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ * 3. Neither the name of the project nor the names of its contributors
+ *    may be used to endorse or promote products derived from this software
+ *    without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE PROJECT AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE PROJECT OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+ /* Population count of how many bits are set */
+static inline int ibv_popcount64(uint64_t _x)
+{
+	_x = (_x & 0x5555555555555555) + ((_x & 0xaaaaaaaaaaaaaaaa) >> 1);
+	_x = (_x & 0x3333333333333333) + ((_x & 0xcccccccccccccccc) >> 2);
+	_x = (_x + (_x >> 4)) & 0x0f0f0f0f0f0f0f0f;
+	_x = (_x + (_x >> 8));
+	_x = (_x + (_x >> 16));
+	_x = (_x + (_x >> 32)) & 0x000000ff;
+	return _x;
+}
+#endif
+
+#endif
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 232b0df..67a2cb1 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -41,6 +41,7 @@
 #include <stddef.h>
 #include <errno.h>
 #include <string.h>
+#include <infiniband/compiler.h>
 
 #ifdef __cplusplus
 #  define BEGIN_C_DECLS extern "C" {
@@ -466,6 +467,113 @@ struct ibv_wc_ex {
 	uint8_t			buffer[0];
 };
 
+static inline size_t ibv_wc_ex_get_offsetof64(uint64_t cq_creation_wc_flags,
+					      enum ibv_wc_flags_ex flag)
+{
+	return ibv_popcount64(cq_creation_wc_flags &
+			      IBV_WC_EX_WITH_64BIT_FIELDS &
+			      (flag - 1)) * sizeof(uint64_t);
+}
+
+static inline size_t ibv_wc_ex_get_offsetof32(uint64_t cq_creation_wc_flags,
+					      enum ibv_wc_flags_ex flag)
+{
+	return ibv_popcount64(cq_creation_wc_flags &
+			      (IBV_WC_EX_WITH_64BIT_FIELDS)) *
+		sizeof(uint64_t) +
+		ibv_popcount64(cq_creation_wc_flags &
+			       IBV_WC_EX_WITH_32BIT_FIELDS &
+			       (flag - 1)) * sizeof(uint32_t);
+}
+
+static inline size_t ibv_wc_ex_get_offsetof16(uint64_t cq_creation_wc_flags,
+					      enum ibv_wc_flags_ex flag)
+{
+	return ibv_popcount64(cq_creation_wc_flags &
+			      (IBV_WC_EX_WITH_64BIT_FIELDS)) *
+		sizeof(uint64_t) +
+		ibv_popcount64(cq_creation_wc_flags &
+			       (IBV_WC_EX_WITH_32BIT_FIELDS)) *
+		sizeof(uint32_t) +
+		ibv_popcount64(cq_creation_wc_flags &
+			       IBV_WC_EX_WITH_16BIT_FIELDS &
+			       (flag - 1)) * sizeof(uint16_t);
+}
+
+static inline size_t ibv_wc_ex_get_offsetof8(uint64_t cq_creation_wc_flags,
+					     enum ibv_wc_flags_ex flag)
+{
+	return ibv_popcount64(cq_creation_wc_flags &
+			      (IBV_WC_EX_WITH_64BIT_FIELDS)) *
+		sizeof(uint64_t) +
+		ibv_popcount64(cq_creation_wc_flags &
+			       (IBV_WC_EX_WITH_32BIT_FIELDS)) *
+		sizeof(uint32_t) +
+		ibv_popcount64(cq_creation_wc_flags &
+			       (IBV_WC_EX_WITH_16BIT_FIELDS)) *
+		sizeof(uint16_t) +
+		ibv_popcount64(cq_creation_wc_flags &
+			       IBV_WC_EX_WITH_8BIT_FIELDS &
+			       (flag - 1)) * sizeof(uint8_t);
+}
+
+static inline uint64_t ibv_wc_ex_get64(const struct ibv_wc_ex *wc_ex,
+				       uint64_t cq_creation_wc_flags,
+				       enum ibv_wc_flags_ex flag)
+{
+	uint64_t *pdata = (uint64_t *)(wc_ex->buffer +
+				       ibv_wc_ex_get_offsetof64(cq_creation_wc_flags,
+								flag));
+
+	return *pdata;
+}
+
+static inline uint32_t ibv_wc_ex_get32(const struct ibv_wc_ex *wc_ex,
+				       uint64_t cq_creation_wc_flags,
+				       enum ibv_wc_flags_ex flag)
+{
+	uint32_t *pdata = (uint32_t *)(wc_ex->buffer +
+				       ibv_wc_ex_get_offsetof32(cq_creation_wc_flags,
+								flag));
+
+	return *pdata;
+}
+
+static inline uint16_t ibv_wc_ex_get16(const struct ibv_wc_ex *wc_ex,
+				       uint64_t cq_creation_wc_flags,
+				       enum ibv_wc_flags_ex flag)
+{
+	uint16_t *pdata = (uint16_t *)(wc_ex->buffer +
+				       ibv_wc_ex_get_offsetof16(cq_creation_wc_flags,
+								flag));
+
+	return *pdata;
+}
+
+static inline uint8_t ibv_wc_ex_get8(const struct ibv_wc_ex *wc_ex,
+				     uint64_t cq_creation_wc_flags,
+				     enum ibv_wc_flags_ex flag)
+{
+	uint8_t *pdata = (uint8_t *)(wc_ex->buffer +
+				     ibv_wc_ex_get_offsetof8(cq_creation_wc_flags,
+							     flag));
+
+	return *pdata;
+}
+
+static inline size_t ibv_wc_ex_get_size(uint64_t flags)
+{
+	return ((ibv_popcount64(flags & IBV_WC_EX_WITH_64BIT_FIELDS) *
+		 sizeof(uint64_t) +
+		 ibv_popcount64(flags & IBV_WC_EX_WITH_32BIT_FIELDS) *
+		 sizeof(uint32_t) +
+		 ibv_popcount64(flags & IBV_WC_EX_WITH_16BIT_FIELDS) *
+		 sizeof(uint16_t) +
+		 ibv_popcount64(flags & IBV_WC_EX_WITH_8BIT_FIELDS) *
+		 sizeof(uint8_t) + (sizeof(uint64_t) - 1)) &
+		~(sizeof(uint64_t) - 1)) + sizeof(struct ibv_wc_ex);
+}
+
 enum ibv_access_flags {
 	IBV_ACCESS_LOCAL_WRITE		= 1,
 	IBV_ACCESS_REMOTE_WRITE		= (1<<1),
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
