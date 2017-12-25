From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 2/9] verbs: Introduce ibv_parent_domain and its related verbs
Date: Mon, 25 Dec 2017 15:56:54 +0200
Message-ID: <1514210221-10466-3-git-send-email-yishaih@mellanox.com>
References: <1514210221-10466-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1514210221-10466-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch introduces the ibv_parent_domain user space object and its
related verbs.

This object must include a protection domain (i.e. ibv_pd), and
optionally a thread domain (i.e. ibv_td). In the future some other
domains such as loopback domain may be added as well.

The main purpose of introducing this is to enable an application setting
of the required domains in one object and pass them all at once upon
verbs objects creation.

To prevent the need to change/extend current verbs APIs this parent
object is defined as ibv_pd outside the libraries so that verbs that
already get a PD can now get this object without any change.

It's the responsibility of the driver to wrap it internally as already
done today for other objects (e.g. QP, SRQ) and have some indication
whether the given ibv_pd is some legacy object or this is the new parent
object which includes some other domains.

Combined with the ibv_td object that was introduced in the previous
patch will enable the provider to share hardware resources and drop
locks for verbs objects that will be created within the same thread
domain.

Extra details appear in the man page which is part of this patch.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/driver.h                      | 25 +++++++++++
 libibverbs/man/CMakeLists.txt            |  1 +
 libibverbs/man/ibv_alloc_parent_domain.3 | 74 ++++++++++++++++++++++++++++++++
 libibverbs/verbs.h                       | 26 +++++++++++
 4 files changed, 126 insertions(+)
 create mode 100644 libibverbs/man/ibv_alloc_parent_domain.3

diff --git a/libibverbs/driver.h b/libibverbs/driver.h
index 4698ba4..60c955e 100644
--- a/libibverbs/driver.h
+++ b/libibverbs/driver.h
@@ -405,4 +405,29 @@ static inline bool check_comp_mask(uint64_t input, uint64_t supported)
 
 int ibv_query_gid_type(struct ibv_context *context, uint8_t port_num,
 		       unsigned int index, enum ibv_gid_type *type);
+
+static inline int
+ibv_check_alloc_parent_domain(struct ibv_parent_domain_init_attr *attr)
+{
+	/* A valid protection domain must be set */
+	if (!attr->pd) {
+		errno = EINVAL;
+		return -1;
+	}
+
+	return 0;
+}
+
+/*
+ * Initialize the ibv_pd which is being used as a parent_domain. From the
+ * perspective of the core code the new ibv_pd is completely interchangable
+ * with the passed contained_pd.
+ */
+static inline void ibv_initialize_parent_domain(struct ibv_pd *parent_domain,
+						struct ibv_pd *contained_pd)
+{
+	parent_domain->context = contained_pd->context;
+	parent_domain->handle = contained_pd->handle;
+}
+
 #endif /* INFINIBAND_DRIVER_H */
diff --git a/libibverbs/man/CMakeLists.txt b/libibverbs/man/CMakeLists.txt
index f098311..53dbb06 100644
--- a/libibverbs/man/CMakeLists.txt
+++ b/libibverbs/man/CMakeLists.txt
@@ -1,5 +1,6 @@
 rdma_man_pages(
   ibv_alloc_mw.3
+  ibv_alloc_parent_domain.3
   ibv_alloc_pd.3
   ibv_alloc_td.3
   ibv_asyncwatch.1
diff --git a/libibverbs/man/ibv_alloc_parent_domain.3 b/libibverbs/man/ibv_alloc_parent_domain.3
new file mode 100644
index 0000000..e231307
--- /dev/null
+++ b/libibverbs/man/ibv_alloc_parent_domain.3
@@ -0,0 +1,74 @@
+.\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
+.\"
+.TH IBV_ALLOC_PARENT_DOMAIN 3 2017-11-06 libibverbs "Libibverbs Programmer's Manual"
+.SH "NAME"
+ibv_alloc_parent_domain(), ibv_dealloc_pd() \- allocate and deallocate the parent domain object
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/verbs.h>
+.sp
+.BI "struct ibv_pd *ibv_alloc_parent_domain(struct ibv_context "*context" ", struct ibv_domain_init_attr " "*attr");
+.sp
+.SH "DESCRIPTION"
+.B ibv_alloc_parent_domain()
+allocates a parent domain object for the RDMA device context
+.I context\fR.
+.sp
+The parent domain object extends the normal protection domain with additional
+objects, such as a thread domain.
+.sp
+A parent domain is completely interchangable with the
+.I
+struct ibv_pd
+used to create it, and can be used as an input argument to any function accepting a
+.I
+struct ibv_pd.
+.sp
+The behavior of each verb may be different if the verb is passed a parent
+domain
+.I
+struct ibv_pd
+that contains a
+.I
+struct ibv_td pointer\fR.
+For instance the verb my choose to share resources
+between objects using the same thread domain. The exact behavior is provider
+dependent.
+.sp
+The
+.I attr
+argument specifies the following:
+.PP
+.nf
+struct ibv_parent_domain_init_attr {
+.in +8
+struct ibv_pd *pd; /* referance to a protection domain, can't be NULL */
+struct ibv_td *td; /* referance to a thread domain, or NULL */
+uint32_t comp_mask;
+.in -8
+};
+.fi
+.PP
+.sp
+.B ibv_dealloc_pd()
+will deallocate the parent domain as its exposed as an ibv_pd
+.I pd\fR.
+All resources created with the parent domain
+should be destroyed prior to deallocating the parent domain\fR.
+.SH "RETURN VALUE"
+.B ibv_alloc_parent_domain()
+returns a pointer to the allocated struct
+.I ibv_pd
+object, or NULL if the request fails (and sets errno to indicate the failure reason).
+.sp
+.SH "SEE ALSO"
+.BR ibv_alloc_parent_domain (3),
+.BR ibv_dealloc_pd (3),
+.BR ibv_alloc_pd (3),
+.BR ibv_alloc_td (3)
+.SH "AUTHORS"
+.TP
+Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+.TP
+Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 9329151..1f5d9c6 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -1632,6 +1632,12 @@ struct ibv_cq_init_attr_ex {
 	uint32_t		flags;
 };
 
+struct ibv_parent_domain_init_attr {
+	struct ibv_pd *pd; /* referance to a protection domain object, can't be NULL */
+	struct ibv_td *td; /* referance to a thread domain object, or NULL */
+	uint32_t comp_mask;
+};
+
 enum ibv_values_mask {
 	IBV_VALUES_MASK_RAW_CLOCK	= 1 << 0,
 	IBV_VALUES_MASK_RESERVED	= 1 << 1
@@ -1644,6 +1650,8 @@ struct ibv_values_ex {
 
 struct verbs_context {
 	/*  "grows up" - new fields go here */
+	struct ibv_pd *(*alloc_parent_domain)(struct ibv_context *context,
+					      struct ibv_parent_domain_init_attr *attr);
 	int (*dealloc_td)(struct ibv_td *td);
 	struct ibv_td *(*alloc_td)(struct ibv_context *context, struct ibv_td_init_attr *init_attr);
 	int (*modify_cq)(struct ibv_cq *cq, struct ibv_modify_cq_attr *attr);
@@ -2227,6 +2235,24 @@ static inline int ibv_dealloc_td(struct ibv_td *td)
 }
 
 /**
+ * ibv_alloc_parent_domain - Allocate a parent domain
+ */
+static inline struct ibv_pd *
+ibv_alloc_parent_domain(struct ibv_context *context,
+			struct ibv_parent_domain_init_attr *attr)
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
  * ibv_query_rt_values_ex - Get current real time @values of a device.
  * @values - in/out - defines the attributes we need to query/queried.
  * (Or's bits of enum ibv_values_mask on values->comp_mask field)
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
