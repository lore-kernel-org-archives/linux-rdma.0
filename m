From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 04/17] IB/core: Add umem function to read data from user-space
Date: Tue, 11 Nov 2014 18:36:10 +0200
Message-ID: <1415723783-2138-5-git-send-email-haggaie@mellanox.com>
References: <1415723783-2138-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415723783-2138-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In some drivers there's a need to read data from a user space area that
was pinned using ib_umem, when running from a different process context.

The ib_umem_copy_from function allows reading data from the physical pages
pinned in the ib_umem struct.

Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/umem.c | 26 ++++++++++++++++++++++++++
 include/rdma/ib_umem.h         |  2 ++
 2 files changed, 28 insertions(+)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index e0f883292374..77bec75963e7 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -292,3 +292,29 @@ int ib_umem_page_count(struct ib_umem *umem)
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
+ * Returns the number of copied bytes, or an error code.
+ */
+int ib_umem_copy_from(struct ib_umem *umem, size_t offset, void *dst,
+		      size_t length)
+{
+	size_t end = offset + length;
+
+	if (offset > umem->length || end > umem->length || end < offset) {
+		pr_err("ib_umem_copy_from not in range. offset: %zd umem length: %zd end: %zd\n",
+		       offset, umem->length, end);
+		return -EINVAL;
+	}
+
+	return sg_pcopy_to_buffer(umem->sg_head.sgl, umem->nmap, dst, length,
+			offset + ib_umem_offset(umem));
+}
+EXPORT_SYMBOL(ib_umem_copy_from);
diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index 7ed6d4ff58dc..ee897724cbf8 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -84,6 +84,8 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 			    size_t size, int access, int dmasync);
 void ib_umem_release(struct ib_umem *umem);
 int ib_umem_page_count(struct ib_umem *umem);
+int ib_umem_copy_from(struct ib_umem *umem, size_t start, void *dst,
+		      size_t length);
 
 #else /* CONFIG_INFINIBAND_USER_MEM */
 
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
