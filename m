From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RFC rdma-core 2/5] verbs: Introduce parent domain and its related verbs
Date: Sun, 12 Nov 2017 23:41:40 +0200
Message-ID: <1510522903-6838-3-git-send-email-yishaih@mellanox.com>
References: <1510522903-6838-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510522903-6838-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch introduces the ibv_parent_domain user space object and its
related create and destroy verbs.

This object may include few verbs domains as of protection domain (i.e.
ibv_pd), thread domain (i.e. ibv_td) and in the future some others as of
loopback domain etc.

The main purpose of introducing it, is to enable an application setting
the required domains in one object and pass them all at once upon
resource creation.

To prevent the need to change/extend current verbs APIs this parent
object is defined as ibv_pd outside the libraries so that verbs that
already get a PD can now get this object without any change.

It's the responsibility of the driver to wrap it internally as already
done today for other objects (e.g. QP, SRQ) and have some indication
whether the given ibv_pd is some legacy object or this is the new parent
object which includes some other domains.

This with the ibv_td object that was introduced in the previous patch
will enable driver that will implement them to share hardware resources
and drop locks for verbs objects that will be created with a parent
domain with same thread domain.

Extra details appeared in the man page which is part of this patch.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/man/ibv_alloc_parent_domain.3 | 73 ++++++++++++++++++++++++++++++++
 libibverbs/verbs.h                       | 40 +++++++++++++++++
 2 files changed, 113 insertions(+)
 create mode 100644 libibverbs/man/ibv_alloc_parent_domain.3

diff --git a/libibverbs/man/ibv_alloc_parent_domain.3 b/libibverbs/man/ibv_alloc_parent_domain.3
new file mode 100644
index 0000000..45287f8
--- /dev/null
+++ b/libibverbs/man/ibv_alloc_parent_domain.3
@@ -0,0 +1,73 @@
+.\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
+.\"
+.TH IBV_ALLOC_PARENT_DOMAIN 3 2017-11-06 libibverbs "Libibverbs Programmer's Manual"
+.SH "NAME"
+ibv_alloc_parent_domain(), ibv_dealloc_parent_domain() \- allocate and deallocate the parent domain object
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/verbs.h>
+.sp
+.BI "struct ibv_pd *ibv_alloc_parent_domain(struct ibv_context "*context" ", struct ibv_domain_init_attr " "*attr");
+.sp
+.BI "int ibv_dealloc_parent_domain(struct ibv_pd " "*pd");
+.fi
+.SH "DESCRIPTION"
+.B ibv_alloc_parent_domain()
+allocates a parent domain object for the RDMA device context
+.I context\fR.
+.sp
+The parent domain object is a collection of specific domain objects of different types, e.g. protection domain and thread domain.
+.sp
+A parent domain can be used as input parameter interchangeable where protection domain (ibv_pd) is currently used.
+Note that
+.I struct ibv_pd
+acts as handle for legacy protection domain and the new parent domain.
+.sp
+The
+.I attr
+argument specifies the following:
+.PP
+.nf
+struct ibv_parent_domain_init_attr {
+.in +8
+struct ibv_pd *pd; /* referance to a protection domain, or NULL */
+struct ibv_td *td; /* referance to a thread domain, or NULL */
+uint32_t comp_mask;
+.in -8
+};
+.fi
+.PP
+.sp
+Creating a parent domain object has to include at least one specific type domain object:
+.I pd\fR,
+.I td\fR,
+or both.
+.sp
+When creating a QP, SRQ, WQ, the legacy or new ibv_pd can be used, depending on the scope of domains required to be covered. When using the parent domain, it must include a reference to a protection domain else the verbs object creation will fail.
+.sp
+When creating a CQ, only the parent domain object will be a valid input. The protection domain value is disregarded in the CQ creation.
+.sp
+.B ibv_dealloc_parent_domain()
+will deallocate the parent domain
+.I pd\fR.
+All resources created with the
+.I pd
+should be destroyed prior to deallocating the
+.I pd\fR.
+.SH "RETURN VALUE"
+.B ibv_alloc_parent_domain()
+returns a pointer to the allocated struct
+.I ibv_pd
+object, or NULL if the request fails (and sets errno to indicates the failure reason).
+.sp
+.B ibv_dealloc_parent_domain()
+returns 0 on success, or the value of errno on failure (which indicates the failure reason).
+.SH "SEE ALSO"
+.BR ibv_alloc_parent_domain (3),
+.BR ibv_alloc_pd (3),
+.BR ibv_alloc_td (3),
+.SH "AUTHORS"
+.TP
+Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index c6c536f..db88705 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -1620,6 +1620,12 @@ struct ibv_cq_init_attr_ex {
 	uint32_t		flags;
 };
 
+struct ibv_parent_domain_init_attr {
+	struct ibv_pd *pd; /* referance to a protection domain object, or NULL */
+	struct ibv_td *td; /* referance to a thread domain object, or NULL */
+	uint32_t comp_mask;
+};
+
 enum ibv_values_mask {
 	IBV_VALUES_MASK_RAW_CLOCK	= 1 << 0,
 	IBV_VALUES_MASK_RESERVED	= 1 << 1
@@ -1641,6 +1647,9 @@ enum verbs_context_mask {
 
 struct verbs_context {
 	/*  "grows up" - new fields go here */
+	int (*dealloc_parent_domain)(struct ibv_pd *domain);
+	struct ibv_pd *(*alloc_parent_domain)(struct ibv_context *context,
+					       struct ibv_parent_domain_init_attr *attr);
 	int (*dealloc_td)(struct ibv_td *td);
 	struct ibv_td *(*alloc_td)(struct ibv_context *context);
 	int (*post_srq_ops)(struct ibv_srq *srq,
@@ -2212,6 +2221,37 @@ static inline int ibv_dealloc_td(struct ibv_td *td)
 }
 
 /**
+ * ibv_alloc_parent_domain - Allocate a parent domain
+ */
+static inline struct ibv_pd *ibv_alloc_parent_domain(struct ibv_context *context,
+						struct ibv_parent_domain_init_attr *attr)
+{
+	struct verbs_context *vctx;
+
+	vctx = verbs_get_ctx_op(context, alloc_parent_domain);
+	if (!vctx) {
+		errno = ENOSYS;
+		return NULL;
+	}
+
+	return vctx->alloc_parent_domain(context, attr);
+}
+
+/**
+ * ibv_dealloc_parent_domain - Free a parent domain
+ */
+static inline int ibv_dealloc_parent_domain(struct ibv_pd *domain)
+{
+	struct verbs_context *vctx;
+
+	vctx = verbs_get_ctx_op(domain->context, dealloc_parent_domain);
+	if (!vctx)
+		return ENOSYS;
+
+	return vctx->dealloc_parent_domain(domain);
+}
+
+/**
  * ibv_query_rt_values_ex - Get current real time @values of a device.
  * @values - in/out - defines the attributes we need to query/queried.
  * (Or's bits of enum ibv_values_mask on values->comp_mask field)
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
