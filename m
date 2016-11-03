From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/8] libpvrdma: Add ring traversal
Date: Thu, 3 Nov 2016 16:44:31 -0700
Message-ID: <1478216677-6150-3-git-send-email-aditr@vmware.com>
References: <1478216677-6150-1-git-send-email-aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478216677-6150-1-git-send-email-aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

CQs and QPs use these structures to traverse the CQE/WQE rings.

Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 providers/pvrdma/pvrdma_ring.h | 136 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 136 insertions(+)
 create mode 100644 providers/pvrdma/pvrdma_ring.h

diff --git a/providers/pvrdma/pvrdma_ring.h b/providers/pvrdma/pvrdma_ring.h
new file mode 100644
index 0000000..e99a551
--- /dev/null
+++ b/providers/pvrdma/pvrdma_ring.h
@@ -0,0 +1,136 @@
+/*
+ * Copyright (c) 2012-2016 VMware, Inc.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of EITHER the GNU General Public License
+ * version 2 as published by the Free Software Foundation or the BSD
+ * 2-Clause License. This program is distributed in the hope that it
+ * will be useful, but WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED
+ * WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License version 2 for more details at
+ * http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program in the file COPYING. If not, write to the
+ * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
+ * Boston, MA 02110-1301, USA.
+ *
+ * The BSD 2-Clause License
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
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
+ * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
+ * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
+ * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
+ * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
+ * OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef __PVRDMA_RING_H__
+#define __PVRDMA_RING_H__
+
+#include <linux/types.h>
+
+#define PVRDMA_INVALID_IDX	-1	/* Invalid index. */
+#define atomic_read(_x)		*(_x)
+#define atomic_set(_x, _y)	(*(_x) = (_y))
+
+typedef uint32_t atomic_t;
+
+struct pvrdma_ring {
+	atomic_t prod_tail;	/* Producer tail. */
+	atomic_t cons_head;	/* Consumer head. */
+};
+
+struct pvrdma_ring_state {
+	struct pvrdma_ring tx;	/* Tx ring. */
+	struct pvrdma_ring rx;	/* Rx ring. */
+};
+
+static inline int pvrdma_idx_valid(__u32 idx, __u32 max_elems)
+{
+	/* Generates fewer instructions than a less-than. */
+	return (idx & ~((max_elems << 1) - 1)) == 0;
+}
+
+static inline __s32 pvrdma_idx(atomic_t *var, __u32 max_elems)
+{
+	const unsigned idx = atomic_read(var);
+
+	if (pvrdma_idx_valid(idx, max_elems))
+		return idx & (max_elems - 1);
+	return PVRDMA_INVALID_IDX;
+}
+
+static inline void pvrdma_idx_ring_inc(atomic_t *var, __u32 max_elems)
+{
+	__u32 idx = atomic_read(var) + 1;	/* Increment. */
+
+	idx &= (max_elems << 1) - 1;		/* Modulo size, flip gen. */
+	atomic_set(var, idx);
+}
+
+static inline __s32 pvrdma_idx_ring_has_space(const struct pvrdma_ring *r,
+					      __u32 max_elems, __u32 *out_tail)
+{
+	const __u32 tail = atomic_read(&r->prod_tail);
+	const __u32 head = atomic_read(&r->cons_head);
+
+	if (pvrdma_idx_valid(tail, max_elems) &&
+	    pvrdma_idx_valid(head, max_elems)) {
+		*out_tail = tail & (max_elems - 1);
+		return tail != (head ^ max_elems);
+	}
+	return PVRDMA_INVALID_IDX;
+}
+
+static inline __s32 pvrdma_idx_ring_has_data(const struct pvrdma_ring *r,
+					     __u32 max_elems, __u32 *out_head)
+{
+	const __u32 tail = atomic_read(&r->prod_tail);
+	const __u32 head = atomic_read(&r->cons_head);
+
+	if (pvrdma_idx_valid(tail, max_elems) &&
+	    pvrdma_idx_valid(head, max_elems)) {
+		*out_head = head & (max_elems - 1);
+		return tail != head;
+	}
+	return PVRDMA_INVALID_IDX;
+}
+
+static inline __s32 pvrdma_idx_ring_is_valid_idx(const struct pvrdma_ring *r,
+						 __u32 max_elems, __u32 *idx)
+{
+	const __u32 tail = atomic_read(&r->prod_tail);
+	const __u32 head = atomic_read(&r->cons_head);
+
+	if (pvrdma_idx_valid(tail, max_elems) &&
+	    pvrdma_idx_valid(head, max_elems) &&
+	    pvrdma_idx_valid(*idx, max_elems)) {
+		if (tail > head && (*idx < tail && *idx >= head))
+			return 1;
+		else if (head > tail && (*idx >= head || *idx < tail))
+			return 1;
+	}
+	return 0;
+}
+
+#endif /* __PVRDMA_RING_H__ */
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
