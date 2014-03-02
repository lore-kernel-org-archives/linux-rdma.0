From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC 03/20] IB/core: Add umem function to read data from user-space
Date: Sun,  2 Mar 2014 12:49:21 +0200
Message-ID: <1393757378-16412-4-git-send-email-haggaie@mellanox.com>
References: <1393757378-16412-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393757378-16412-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In some drivers there's a need to read data from a user space area that
was pinned using ib_umem, when running from a different process context.

The ib_umem_copy_from function allows reading data from the physical pages
pinned in the ib_umem struct.

Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/umem.c | 25 +++++++++++++++++++++++++
 include/rdma/ib_umem.h         |  2 ++
 2 files changed, 27 insertions(+)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index ab14b33..138442a 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -287,3 +287,28 @@ int ib_umem_page_count(struct ib_umem *umem)
 	return n;
 }
 EXPORT_SYMBOL(ib_umem_page_count);
+
+/*
+ * Copy from the given ib_umem's pages to the given buffer.
+ *
+ * umem - the umem to copy from
+ * start - offset to start copying from
+ * dst - destination buffer
+ * length - buffer length
+ *
+ * Returns the number of copied bytes, or an error code.
+ */
+int ib_umem_copy_from(struct ib_umem *umem, size_t start, void *dst,
+		      size_t length)
+{
+	size_t end = start + length;
+
+	if (start > umem->length || end > umem->length || end < start) {
+		pr_err("ib_umem_copy_from not in range.");
+		return -EINVAL;
+	}
+
+	return sg_pcopy_to_buffer(umem->sg_head.sgl, umem->nmap, dst, length,
+			start + ib_umem_offset(umem));
+}
+EXPORT_SYMBOL(ib_umem_copy_from);
diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index 0e120f4..6af91b3 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -83,6 +83,8 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
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
