From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: libibverbs: Added the man page verbs.7
Date: Thu, 10 Nov 2011 11:03:41 +0200
Message-ID: <201111101103.41673.dotanb@sw.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Added the man page verbs.7 which is an introduction to libibverbs man pages.

Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 Makefile.am        |    2 +-
 libibverbs.spec.in |    1 +
 man/verbs.7        |  201 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 203 insertions(+), 1 deletions(-)
 create mode 100644 man/verbs.7

diff --git a/Makefile.am b/Makefile.am
index cd00a65..08903b5 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -54,7 +54,7 @@ man_MANS = man/ibv_asyncwatch.1 man/ibv_devices.1 man/ibv_devinfo.1	\
     man/ibv_post_srq_recv.3 man/ibv_query_device.3 man/ibv_query_gid.3	\
     man/ibv_query_pkey.3 man/ibv_query_port.3 man/ibv_query_qp.3	\
     man/ibv_query_srq.3 man/ibv_rate_to_mult.3 man/ibv_reg_mr.3		\
-    man/ibv_req_notify_cq.3 man/ibv_resize_cq.3
+    man/ibv_req_notify_cq.3 man/ibv_resize_cq.3 man/verbs.7
 
 DEBIAN = debian/changelog debian/compat debian/control debian/copyright \
     debian/ibverbs-utils.install debian/libibverbs1.install \
diff --git a/libibverbs.spec.in b/libibverbs.spec.in
index 2244c50..27197ee 100644
--- a/libibverbs.spec.in
+++ b/libibverbs.spec.in
@@ -74,6 +74,7 @@ rm -rf $RPM_BUILD_ROOT
 %{_libdir}/lib*.so
 %{_includedir}/*
 %{_mandir}/man3/*
+%{_mandir}/man7/*
 
 %files devel-static
 %defattr(-,root,root,-)
diff --git a/man/verbs.7 b/man/verbs.7
new file mode 100644
index 0000000..6861900
--- /dev/null
+++ b/man/verbs.7
@@ -0,0 +1,201 @@
+.\" -*- nroff -*-
+.\"
+.TH VERBS 7 2008-01-17 libibverbs "Libibverbs Programmer's Manual"
+.SH "NAME"
+verbs \- Infiniband verbs library
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/verbs.h>
+.fi
+.SH "DESCRIPTION"
+This library is an implementation of the RDMA verbs for both Infiniband (according to the Infiniband specification volume 1, release 1.2.1) and iWarp. It handles the control path of creating, modifying, querying and destroying resources such as Protection Domains (PD), Completion Queues (CQ), Queue-Pairs (QP), Shared Receive Queues (SRQ), Address Handles (AH), Memory Regions (MR). It also handles sending and receiving data posted to QPs and SRQs, getting completions from CQs using polling and completions events.
+
+The control path is implemented through system calls to the uverbs kernel module which further calls the low level HW driver. The data path is implemented through calls made to low level HW library which in most cases interacts directly with the HW providing kernel and network stack bypass (saving context/mode switches) along with zero copy and an asynchronous I/O model.
+
+
+Typically, under network and RDMA programming, there are operations which involve interaction with remote peers (such as address resolution and connection establishment) and remote entities (such as route resolution and joining a multicast group under IB), where a resource managed through IB verbs such as QP or AH would be eventually created or effected from this interaction. In such cases, applications whose addressing semantics is based on IP can use librdmacm (see rdma_cm(7)) which works in conjunction with libibverbs.
+
+This library is thread safe library and verbs can be called from every thread in the process (the same resource can even be handled from different threads, for example: ibv_poll_cq can be called from more than one thread).
+
+However, it is up to the user to stop working with a resource after it was destroyed (by the same thread or by any other thread), this may result a segmentation fault.
+
+If fork (or any other system call that perform fork directly or indirectly) is being used, please see ibv_fork_init(3).
+
+.LP
+The following shall be declared as functions and may also be defined
+as macros. Function prototypes shall be provided.
+.RS
+.nf
+
+\fB
+.B Library functions
+
+int ibv_fork_init(void);
+
+.B Device functions
+
+struct ibv_device **ibv_get_device_list(int *num_devices);
+void ibv_free_device_list(struct ibv_device **list);
+const char *ibv_get_device_name(struct ibv_device *device);
+uint64_t ibv_get_device_guid(struct ibv_device *device);
+
+.B Context functions
+
+struct ibv_context *ibv_open_device(struct ibv_device *device);
+int ibv_close_device(struct ibv_context *context);
+
+.B Queries
+
+int ibv_query_device(struct ibv_context *context,
+                     struct ibv_device_attr *device_attr);
+int ibv_query_port(struct ibv_context *context, uint8_t port_num,
+                   struct ibv_port_attr *port_attr);
+int ibv_query_pkey(struct ibv_context *context, uint8_t port_num,
+                   int index, uint16_t *pkey);
+int ibv_query_gid(struct ibv_context *context, uint8_t port_num,
+                  int index, union ibv_gid *gid);
+
+.B Asynchronous events
+
+int ibv_get_async_event(struct ibv_context *context,
+                        struct ibv_async_event *event);
+void ibv_ack_async_event(struct ibv_async_event *event);
+
+.B Protection Domains
+
+struct ibv_pd *ibv_alloc_pd(struct ibv_context *context);
+int ibv_dealloc_pd(struct ibv_pd *pd);
+
+.B Memory Regions
+
+struct ibv_mr *ibv_reg_mr(struct ibv_pd *pd, void *addr,
+                          size_t length, enum ibv_access_flags access);
+int ibv_dereg_mr(struct ibv_mr *mr);
+
+.B Address Handles
+
+struct ibv_ah *ibv_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr);
+int ibv_init_ah_from_wc(struct ibv_context *context, uint8_t port_num,
+                        struct ibv_wc *wc, struct ibv_grh *grh,
+                        struct ibv_ah_attr *ah_attr);
+struct ibv_ah *ibv_create_ah_from_wc(struct ibv_pd *pd, struct ibv_wc *wc,
+                                     struct ibv_grh *grh, uint8_t port_num);
+int ibv_destroy_ah(struct ibv_ah *ah);
+
+.B Completion event channels
+
+struct ibv_comp_channel *ibv_create_comp_channel(struct ibv_context *context);
+int ibv_destroy_comp_channel(struct ibv_comp_channel *channel);
+
+.B Completion Queues Control
+
+struct ibv_cq *ibv_create_cq(struct ibv_context *context, int cqe,
+                             void *cq_context,
+                             struct ibv_comp_channel *channel,
+                             int comp_vector);
+int ibv_destroy_cq(struct ibv_cq *cq);
+int ibv_resize_cq(struct ibv_cq *cq, int cqe);
+
+.B Reading Completions from CQ
+
+int ibv_poll_cq(struct ibv_cq *cq, int num_entries, struct ibv_wc *wc);
+
+.B Requesting / Managing CQ events
+
+int ibv_req_notify_cq(struct ibv_cq *cq, int solicited_only);
+int ibv_get_cq_event(struct ibv_comp_channel *channel,
+                     struct ibv_cq **cq, void **cq_context);
+void ibv_ack_cq_events(struct ibv_cq *cq, unsigned int nevents);
+
+.B Shared Receive Queue control
+
+struct ibv_srq *ibv_create_srq(struct ibv_pd *pd,
+                               struct ibv_srq_init_attr *srq_init_attr);
+int ibv_destroy_srq(struct ibv_srq *srq);
+int ibv_modify_srq(struct ibv_srq *srq,
+                   struct ibv_srq_attr *srq_attr,
+                   enum ibv_srq_attr_mask srq_attr_mask);
+int ibv_query_srq(struct ibv_srq *srq, struct ibv_srq_attr *srq_attr);
+
+.B Queue Pair control
+
+struct ibv_qp *ibv_create_qp(struct ibv_pd *pd,
+                             struct ibv_qp_init_attr *qp_init_attr);
+int ibv_destroy_qp(struct ibv_qp *qp);
+int ibv_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
+                  enum ibv_qp_attr_mask attr_mask);
+int ibv_query_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
+                 enum ibv_qp_attr_mask attr_mask,
+                 struct ibv_qp_init_attr *init_attr);
+
+.B posting Work Requests to QPs/SRQs
+int ibv_post_send(struct ibv_qp *qp, struct ibv_send_wr *wr,
+                  struct ibv_send_wr **bad_wr);
+int ibv_post_recv(struct ibv_qp *qp, struct ibv_recv_wr *wr,
+                  struct ibv_recv_wr **bad_wr);
+int ibv_post_srq_recv(struct ibv_srq *srq,
+                      struct ibv_recv_wr *recv_wr,
+                      struct ibv_recv_wr **bad_recv_wr);
+
+.B Multicast group
+
+int ibv_attach_mcast(struct ibv_qp *qp, union ibv_gid *gid, uint16_t lid);
+int ibv_detach_mcast(struct ibv_qp *qp, union ibv_gid *gid, uint16_t lid);
+
+.B General functions
+
+int ibv_rate_to_mult(enum ibv_rate rate);
+enum ibv_rate mult_to_ibv_rate(int mult);
+\fP
+.SH "SEE ALSO"
+.LP
+\fIibv_fork_init\fP(),
+\fIibv_get_device_list\fP(),
+\fIibv_free_device_list\fP(),
+\fIibv_get_device_name\fP(),
+\fIibv_get_device_guid\fP(),
+\fIibv_open_device\fP(),
+\fIibv_close_device\fP(),
+\fIibv_query_device\fP(),
+\fIibv_query_port\fP(),
+\fIibv_query_pkey\fP(),
+\fIibv_query_gid\fP(),
+\fIibv_get_async_event\fP(),
+\fIibv_ack_async_event\fP(),
+\fIibv_alloc_pd\fP(),
+\fIibv_dealloc_pd\fP(),
+\fIibv_reg_mr\fP(),
+\fIibv_dereg_mr\fP(),
+\fIibv_create_ah\fP(),
+\fIibv_init_ah_from_wc\fP(),
+\fIibv_create_ah_from_wc\fP(),
+\fIibv_destroy_ah\fP(),
+\fIibv_create_comp_channel\fP(),
+\fIibv_destroy_comp_channel\fP(),
+\fIibv_create_cq\fP(),
+\fIibv_destroy_cq\fP(),
+\fIibv_resize_cq\fP(),
+\fIibv_poll_cq\fP(),
+\fIibv_req_notify_cq\fP(),
+\fIibv_get_cq_event\fP(),
+\fIibv_ack_cq_events\fP(),
+\fIibv_create_srq\fP(),
+\fIibv_destroy_srq\fP(),
+\fIibv_modify_srq\fP(),
+\fIibv_query_srq\fP(),
+\fIibv_post_srq_recv\fP(),
+\fIibv_create_qp\fP(),
+\fIibv_destroy_qp\fP(),
+\fIibv_modify_qp\fP(),
+\fIibv_query_qp\fP(),
+\fIibv_post_send\fP(),
+\fIibv_post_recv\fP(),
+\fIibv_attach_mcast\fP(),
+\fIibv_detach_mcast\fP(),
+\fIibv_rate_to_mult\fP(),
+\fImult_to_ibv_rate\fP()
+.SH "AUTHORS"
+.TP
+Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+.TP
+Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
-- 
1.7.6.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
