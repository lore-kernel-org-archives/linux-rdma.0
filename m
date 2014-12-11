From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v3 04/17] IB/core: Add umem function to read data from user-space
Date: Thu, 11 Dec 2014 17:04:13 +0200
Message-ID: <1418310266-9584-5-git-send-email-haggaie@mellanox.com>
References: <1418310266-9584-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418310266-9584-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In some drivers there's a need to read data from a user space area that
was pinned using ib_umem, when running from a different process context.

The ib_umem_copy_from function allows reading data from the physical pages
pinned in the ib_umem struct.

Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/umem.c | 34 ++++++++++++++++++++++++++++++++++
 include/rdma/ib_umem.h         |  2 ++
 2 files changed, 36 insertions(+)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index e0f883292374..6f152628e0d2 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -292,3 +292,37 @@ int ib_umem_page_count(struct ib_umem *umem)
 	return n;
 }
 EXPORT_SYMBOL(ib_umem_page_count);
+
+/*
+ * Copy from the given ib_umem's pages to the given buffer.
+ *
+ * umem - the umem to copy from
+ * offset - offset to start copying from
+ * dst - destination buffer
+ * length - buffer length
+ *
+ * Returns 0 on success, or an error code.
+ */
+int ib_umem_copy_from(void *dst, struct ib_umem *umem, size_t offset,
+		      size_t length)
+{
+	size_t end = offset + length;
+	int ret;
+
+	if (offset > umem->length || length > umem->length - offset) {
+		pr_err("ib_umem_copy_from not in range. offset: %zd umem length: %zd end: %zd\n",
+		       offset, umem->length, end);
+		return -EINVAL;
+	}
+
+	ret = sg_pcopy_to_buffer(umem->sg_head.sgl, umem->nmap, dst, length,
+				 offset + ib_umem_offset(umem));
+
+	if (ret < 0)
+		return ret;
+	else if (ret != length)
+		return -EINVAL;
+	else
+		return 0;
+}
+EXPORT_SYMBOL(ib_umem_copy_from);
diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index 7ed6d4ff58dc..45bb04bc88cd 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -84,6 +84,8 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 			    size_t size, int access, int dmasync);
 void ib_umem_release(struct ib_umem *umem);
 int ib_umem_page_count(struct ib_umem *umem);
+int ib_umem_copy_from(void *dst, struct ib_umem *umem, size_t offset,
+		      size_t length);
 
 #else /* CONFIG_INFINIBAND_USER_MEM */
 
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
