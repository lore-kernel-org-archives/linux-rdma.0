From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core 1/6] libqedr: chains
Date: Thu, 20 Oct 2016 12:49:07 +0300
Message-ID: <1476956952-17388-2-git-send-email-Ram.Amrani@cavium.com>
References: <1476956952-17388-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476956952-17388-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>

Introducing chains for managing user queues - SQ, RQ and CQ.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 providers/qedr/qelr_chain.c | 107 +++++++++++++++++++++++++++++
 providers/qedr/qelr_chain.h | 163 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 270 insertions(+)
 create mode 100644 providers/qedr/qelr_chain.c
 create mode 100644 providers/qedr/qelr_chain.h

diff --git a/providers/qedr/qelr_chain.c b/providers/qedr/qelr_chain.c
new file mode 100644
index 0000000..6101f74
--- /dev/null
+++ b/providers/qedr/qelr_chain.c
@@ -0,0 +1,107 @@
+/*
+ * Copyright (c) 2015-2016  QLogic Corporation
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
+ *        disclaimer in the documentation and /or other materials
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
+#include <sys/types.h>
+#include <sys/mman.h>
+#include <stdio.h>
+#include <string.h>
+#include <endian.h>
+#include <errno.h>
+
+#include "qelr.h"
+
+void *qelr_chain_get_last_elem(struct qelr_chain *p_chain)
+{
+	void			*p_virt_addr	= NULL;
+	uint32_t		size;
+
+	if (!p_chain->addr)
+		goto out;
+
+	size		= p_chain->elem_size * (p_chain->n_elems - 1);
+	p_virt_addr	= ((uint8_t *)p_chain->addr + size);
+out:
+	return p_virt_addr;
+}
+
+void qelr_chain_reset(struct qelr_chain *p_chain)
+{
+	p_chain->prod_idx	= 0;
+	p_chain->cons_idx	= 0;
+
+	p_chain->p_cons_elem	= p_chain->addr;
+	p_chain->p_prod_elem	= p_chain->addr;
+}
+
+#define QELR_ANON_FD		(-1)	/* MAP_ANONYMOUS => file desc.= -1  */
+#define QELR_ANON_OFFSET	(0)	/* MAP_ANONYMOUS => offset    = d/c */
+
+int qelr_chain_alloc(struct qelr_chain *chain, int chain_size, int page_size,
+		     uint16_t elem_size)
+{
+	int ret, a_chain_size;
+	void *addr;
+
+	/* alloc aligned page aligned chain */
+	a_chain_size = (chain_size + page_size - 1) & ~(page_size - 1);
+	addr = mmap(NULL, a_chain_size, PROT_READ | PROT_WRITE,
+			 MAP_PRIVATE | MAP_ANONYMOUS, QELR_ANON_FD,
+			 QELR_ANON_OFFSET);
+	if (chain->addr == MAP_FAILED)
+		return errno;
+
+	ret = ibv_dontfork_range(addr, a_chain_size);
+	if (ret) {
+		munmap(addr, a_chain_size);
+		return ret;
+	}
+
+	/* init chain */
+	memset(chain, 0, sizeof(*chain));
+	memset(chain->addr, 0, chain->size);
+	chain->addr = addr;
+	chain->size = a_chain_size;
+	chain->p_cons_elem = chain->addr;
+	chain->p_prod_elem = chain->addr;
+	chain->elem_size = elem_size;
+	chain->n_elems = chain->size / elem_size;
+
+	return 0;
+}
+
+void qelr_chain_free(struct qelr_chain *chain)
+{
+	if (chain->size) {
+		ibv_dofork_range(chain->addr, chain->size);
+		munmap(chain->addr, chain->size);
+	}
+}
diff --git a/providers/qedr/qelr_chain.h b/providers/qedr/qelr_chain.h
new file mode 100644
index 0000000..2ff5bf5
--- /dev/null
+++ b/providers/qedr/qelr_chain.h
@@ -0,0 +1,163 @@
+/*
+ * Copyright (c) 2015-2016  QLogic Corporation
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
+ *        disclaimer in the documentation and /or other materials
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
+#ifndef __QELR_CHAIN_H__
+#define __QELR_CHAIN_H__
+
+struct qelr_chain {
+	/* Address of first page of the chain */
+	void		*addr;
+
+	/* Point to next element to produce/consume */
+	void		*p_prod_elem;
+	void		*p_cons_elem;
+
+	uint32_t	prod_idx;
+	uint32_t	cons_idx;
+
+	uint32_t	n_elems;
+	uint32_t	size;
+	uint16_t	elem_size;
+};
+
+/* fast path functions are inline */
+
+static inline uint32_t qelr_chain_get_cons_idx_u32(struct qelr_chain *p_chain)
+{
+	return p_chain->cons_idx;
+}
+
+static inline void *qelr_chain_produce(struct qelr_chain *p_chain)
+{
+	void *p_ret = NULL;
+
+	p_chain->prod_idx++;
+
+	p_ret = p_chain->p_prod_elem;
+
+	if (p_chain->prod_idx % p_chain->n_elems == 0)
+		p_chain->p_prod_elem = p_chain->addr;
+	else
+		p_chain->p_prod_elem = (void *)(((uint8_t *)p_chain->p_prod_elem) +
+				       p_chain->elem_size);
+
+	return p_ret;
+}
+
+static inline void *qelr_chain_produce_n(struct qelr_chain *p_chain, int n)
+{
+	void *p_ret = NULL;
+	int n_wrap;
+
+	p_chain->prod_idx++;
+	p_ret = p_chain->p_prod_elem;
+
+	n_wrap = p_chain->prod_idx % p_chain->n_elems;
+	if (n_wrap < n)
+		p_chain->p_prod_elem = (void *)(((uint8_t *)p_chain->addr) +
+				       (p_chain->elem_size * n_wrap));
+	else
+		p_chain->p_prod_elem = (void *)(((uint8_t *)p_chain->p_prod_elem) +
+				       (p_chain->elem_size * n));
+
+	return p_ret;
+}
+
+static inline void *qelr_chain_consume(struct qelr_chain *p_chain)
+{
+	void *p_ret = NULL;
+
+	p_chain->cons_idx++;
+
+	p_ret = p_chain->p_cons_elem;
+
+	if (p_chain->cons_idx % p_chain->n_elems == 0)
+		p_chain->p_cons_elem = p_chain->addr;
+	else
+		p_chain->p_cons_elem	= (void *)
+					  (((uint8_t *)p_chain->p_cons_elem) +
+					   p_chain->elem_size);
+
+	return p_ret;
+}
+
+static inline void *qelr_chain_consume_n(struct qelr_chain *p_chain, int n)
+{
+	void *p_ret = NULL;
+	int n_wrap;
+
+	p_chain->cons_idx += n;
+	p_ret = p_chain->p_cons_elem;
+
+	n_wrap = p_chain->cons_idx % p_chain->n_elems;
+	if (n_wrap < n)
+		p_chain->p_cons_elem = (void *)(((uint8_t *)p_chain->addr) +
+				       (p_chain->elem_size * n_wrap));
+	else
+		p_chain->p_cons_elem = (void *)(((uint8_t *)p_chain->p_cons_elem) +
+				       (p_chain->elem_size * n));
+
+	return p_ret;
+}
+
+static inline uint32_t qelr_chain_get_elem_left_u32(struct qelr_chain *p_chain)
+{
+	uint32_t used;
+
+	used = (uint32_t)(((uint64_t)((uint64_t) ~0U) + 1 +
+			  (uint64_t)(p_chain->prod_idx)) -
+			  (uint64_t)p_chain->cons_idx);
+
+	return p_chain->n_elems - used;
+}
+
+static inline uint8_t qelr_chain_is_full(struct qelr_chain *p_chain)
+{
+	return qelr_chain_get_elem_left_u32(p_chain) == p_chain->n_elems;
+}
+
+static inline void qelr_chain_set_prod(
+		struct qelr_chain *p_chain,
+		uint32_t prod_idx,
+		void *p_prod_elem)
+{
+	p_chain->prod_idx = prod_idx;
+	p_chain->p_prod_elem = p_prod_elem;
+}
+
+void *qelr_chain_get_last_elem(struct qelr_chain *p_chain);
+void qelr_chain_reset(struct qelr_chain *p_chain);
+int qelr_chain_alloc(struct qelr_chain *chain, int chain_size, int page_size,
+		     uint16_t elem_size);
+void qelr_chain_free(struct qelr_chain *buf);
+
+#endif /* __QELR_CHAIN_H__ */
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
