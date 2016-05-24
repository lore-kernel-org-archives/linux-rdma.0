From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI 3/8] IB/core: Adding netlink based udata
Date: Tue, 24 May 2016 17:35:21 +0300
Message-ID: <1464100526-31730-4-git-send-email-leonro@mellanox.com>
References: <1464100526-31730-1-git-send-email-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464100526-31730-1-git-send-email-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The new ABI is based on netlink attributes. Currently, the netlink
implementation uses a skb in order to write data into. Adding an
ability to serialize netlink attributes straight to udata.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/Makefile    |  3 +-
 drivers/infiniband/core/uverbs.h    |  8 ++++
 drivers/infiniband/core/uverbs_nl.c | 92 +++++++++++++++++++++++++++++++++++++
 3 files changed, 102 insertions(+), 1 deletion(-)
 create mode 100644 drivers/infiniband/core/uverbs_nl.c

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index 26987d9..3d8a423 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -34,4 +34,5 @@ ib_umad-y :=			user_mad.o
 
 ib_ucm-y :=			ucm.o
 
-ib_uverbs-y :=			uverbs_main.o uverbs_cmd.o uverbs_marshall.o
+ib_uverbs-y :=			uverbs_main.o uverbs_cmd.o uverbs_marshall.o \
+				uverbs_nl.o
diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 612ccfd..a46cb29 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -84,6 +84,14 @@
  * released when the CQ is destroyed.
  */
 
+struct nlattr __user *ib_uverbs_nla_put(struct ib_udata *udata,
+					int attrtype, int attrlen,
+					const void *data);
+void ib_uverbs_nla_nest_end(struct ib_udata *udata,
+			    struct nlattr __user *nla);
+struct nlattr __user *ib_uverbs_nla_nest_start(struct ib_udata *udata,
+					       uint16_t type);
+
 struct ib_uverbs_device {
 	atomic_t				refcount;
 	int					num_comp_vectors;
diff --git a/drivers/infiniband/core/uverbs_nl.c b/drivers/infiniband/core/uverbs_nl.c
new file mode 100644
index 0000000..abf2d35
--- /dev/null
+++ b/drivers/infiniband/core/uverbs_nl.c
@@ -0,0 +1,92 @@
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
+#include <net/netlink.h>
+#include <rdma/ib_verbs.h>
+
+static struct nlattr __user *ib_uverbs_nla_reserve(struct ib_udata *udata,
+						   int attrtype, int attrlen)
+{
+	struct nlattr __user *nla;
+	unsigned int i;
+
+	if (nla_total_size(attrlen) > udata->outlen)
+		return ERR_PTR(-ENOSPC);
+
+	nla = (struct nlattr __user *)udata->outbuf;
+	udata->outbuf += nla_total_size(attrlen);
+	udata->outlen -= nla_total_size(attrlen);
+	put_user(attrtype, &nla->nla_type);
+	put_user(nla_attr_size(attrlen), &nla->nla_len);
+
+	/* TODO: optimize */
+	for (i = 0; i < nla_padlen(attrlen); i++)
+		put_user(0,
+			 (unsigned char __user *)nla + nla_attr_size(attrlen));
+
+	return nla;
+}
+
+struct nlattr __user *ib_uverbs_nla_put(struct ib_udata *udata,
+					int attrtype, int attrlen,
+					const void *data)
+{
+	struct nlattr __user *nla;
+	int ret;
+
+	nla = ib_uverbs_nla_reserve(udata, attrtype, attrlen);
+	if (IS_ERR(nla))
+		return nla;
+
+	ret = copy_to_user(nla_data(nla), data, attrlen);
+	if (ret) {
+		udata->outbuf -= nla_total_size(attrlen);
+		udata->outlen += nla_total_size(attrlen);
+		return ERR_PTR(ret);
+	}
+
+	return nla;
+}
+
+void ib_uverbs_nla_nest_end(struct ib_udata *udata,  struct nlattr __user *nla)
+{
+	put_user(udata->outbuf - (void __user *)nla, &nla->nla_len);
+}
+
+struct nlattr __user *ib_uverbs_nla_nest_start(struct ib_udata *udata,
+					       uint16_t type)
+{
+	struct nlattr __user *nla = ib_uverbs_nla_put(udata, type, 0, NULL);
+
+	return nla;
+}
+
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
