From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 2/2] verbs: Switch simpler man pages over to markdown format
Date: Mon, 12 Feb 2018 20:51:30 -0700
Message-ID: <20180213035130.980-3-jgg@ziepe.ca>
References: <20180213035130.980-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180213035130.980-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This conversion was done via automatic script from my tooling branch
and handles man pages that follow a fairly regular format.

There are a few variations from the original:
 - AUTHOR and AUTHORS is used properly (computed automatically)
 - SEE ALSO and AUTHORS lists are sorted and comma'd properly
 - All synopsis text was run through clang-format and is fully normalized
   to a linux style with 'BinPackParameters: false'
 - All C code, structs, etc was run through clang-format with
   'AlignConsecutiveDeclarations: true' and 'AlignTrailingComments: true'
   and a narrower width. This largely avoids the excessive
   long lines.

This commit includes only the man pages that do not include
embedded structs.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/man/CMakeLists.txt           | 28 +++++-----
 libibverbs/man/ibv_attach_mcast.3       | 54 -------------------
 libibverbs/man/ibv_attach_mcast.3.md    | 57 +++++++++++++++++++++
 libibverbs/man/ibv_event_type_str.3     | 41 ---------------
 libibverbs/man/ibv_event_type_str.3.md  | 49 ++++++++++++++++++
 libibverbs/man/ibv_fork_init.3          | 69 -------------------------
 libibverbs/man/ibv_fork_init.3.md       | 69 +++++++++++++++++++++++++
 libibverbs/man/ibv_get_device_guid.3    | 26 ----------
 libibverbs/man/ibv_get_device_guid.3.md | 41 +++++++++++++++
 libibverbs/man/ibv_get_device_name.3    | 26 ----------
 libibverbs/man/ibv_get_device_name.3.md | 41 +++++++++++++++
 libibverbs/man/ibv_get_srq_num.3        | 33 ------------
 libibverbs/man/ibv_get_srq_num.3.md     | 45 ++++++++++++++++
 libibverbs/man/ibv_inc_rkey.3           | 33 ------------
 libibverbs/man/ibv_inc_rkey.3.md        | 43 ++++++++++++++++
 libibverbs/man/ibv_query_gid.3          | 34 ------------
 libibverbs/man/ibv_query_gid.3.md       | 44 ++++++++++++++++
 libibverbs/man/ibv_query_pkey.3         | 34 ------------
 libibverbs/man/ibv_query_pkey.3.md      | 45 ++++++++++++++++
 libibverbs/man/ibv_rate_to_mbps.3       | 46 -----------------
 libibverbs/man/ibv_rate_to_mbps.3.md    | 50 ++++++++++++++++++
 libibverbs/man/ibv_rate_to_mult.3       | 47 -----------------
 libibverbs/man/ibv_rate_to_mult.3.md    | 52 +++++++++++++++++++
 libibverbs/man/ibv_req_notify_cq.3      | 44 ----------------
 libibverbs/man/ibv_req_notify_cq.3.md   | 55 ++++++++++++++++++++
 libibverbs/man/ibv_rereg_mr.3           | 77 ----------------------------
 libibverbs/man/ibv_rereg_mr.3.md        | 91 +++++++++++++++++++++++++++++++++
 libibverbs/man/ibv_resize_cq.3          | 43 ----------------
 libibverbs/man/ibv_resize_cq.3.md       | 48 +++++++++++++++++
 29 files changed, 744 insertions(+), 621 deletions(-)
 delete mode 100644 libibverbs/man/ibv_attach_mcast.3
 create mode 100644 libibverbs/man/ibv_attach_mcast.3.md
 delete mode 100644 libibverbs/man/ibv_event_type_str.3
 create mode 100644 libibverbs/man/ibv_event_type_str.3.md
 delete mode 100644 libibverbs/man/ibv_fork_init.3
 create mode 100644 libibverbs/man/ibv_fork_init.3.md
 delete mode 100644 libibverbs/man/ibv_get_device_guid.3
 create mode 100644 libibverbs/man/ibv_get_device_guid.3.md
 delete mode 100644 libibverbs/man/ibv_get_device_name.3
 create mode 100644 libibverbs/man/ibv_get_device_name.3.md
 delete mode 100644 libibverbs/man/ibv_get_srq_num.3
 create mode 100644 libibverbs/man/ibv_get_srq_num.3.md
 delete mode 100644 libibverbs/man/ibv_inc_rkey.3
 create mode 100644 libibverbs/man/ibv_inc_rkey.3.md
 delete mode 100644 libibverbs/man/ibv_query_gid.3
 create mode 100644 libibverbs/man/ibv_query_gid.3.md
 delete mode 100644 libibverbs/man/ibv_query_pkey.3
 create mode 100644 libibverbs/man/ibv_query_pkey.3.md
 delete mode 100644 libibverbs/man/ibv_rate_to_mbps.3
 create mode 100644 libibverbs/man/ibv_rate_to_mbps.3.md
 delete mode 100644 libibverbs/man/ibv_rate_to_mult.3
 create mode 100644 libibverbs/man/ibv_rate_to_mult.3.md
 delete mode 100644 libibverbs/man/ibv_req_notify_cq.3
 create mode 100644 libibverbs/man/ibv_req_notify_cq.3.md
 delete mode 100644 libibverbs/man/ibv_rereg_mr.3
 create mode 100644 libibverbs/man/ibv_rereg_mr.3.md
 delete mode 100644 libibverbs/man/ibv_resize_cq.3
 create mode 100644 libibverbs/man/ibv_resize_cq.3.md

diff --git a/libibverbs/man/CMakeLists.txt b/libibverbs/man/CMakeLists.txt
index 53dbb066b4c1ce..1aa44442331718 100644
--- a/libibverbs/man/CMakeLists.txt
+++ b/libibverbs/man/CMakeLists.txt
@@ -4,7 +4,7 @@ rdma_man_pages(
   ibv_alloc_pd.3
   ibv_alloc_td.3
   ibv_asyncwatch.1
-  ibv_attach_mcast.3
+  ibv_attach_mcast.3.md
   ibv_bind_mw.3
   ibv_create_ah.3
   ibv_create_ah_from_wc.3
@@ -21,15 +21,15 @@ rdma_man_pages(
   ibv_create_wq.3
   ibv_devices.1
   ibv_devinfo.1
-  ibv_event_type_str.3
-  ibv_fork_init.3
+  ibv_event_type_str.3.md
+  ibv_fork_init.3.md
   ibv_get_async_event.3
   ibv_get_cq_event.3
-  ibv_get_device_guid.3
+  ibv_get_device_guid.3.md
   ibv_get_device_list.3
-  ibv_get_device_name.3
-  ibv_get_srq_num.3
-  ibv_inc_rkey.3
+  ibv_get_device_name.3.md
+  ibv_get_srq_num.3.md
+  ibv_inc_rkey.3.md
   ibv_modify_qp.3
   ibv_modify_srq.3
   ibv_modify_wq.3
@@ -43,19 +43,19 @@ rdma_man_pages(
   ibv_post_srq_recv.3
   ibv_query_device.3
   ibv_query_device_ex.3
-  ibv_query_gid.3
-  ibv_query_pkey.3
+  ibv_query_gid.3.md
+  ibv_query_pkey.3.md
   ibv_query_port.3
   ibv_query_qp.3
   ibv_query_rt_values_ex.3
   ibv_query_srq.3
-  ibv_rate_to_mbps.3
-  ibv_rate_to_mult.3
+  ibv_rate_to_mbps.3.md
+  ibv_rate_to_mult.3.md
   ibv_rc_pingpong.1
   ibv_reg_mr.3
-  ibv_req_notify_cq.3
-  ibv_rereg_mr.3
-  ibv_resize_cq.3
+  ibv_req_notify_cq.3.md
+  ibv_rereg_mr.3.md
+  ibv_resize_cq.3.md
   ibv_srq_pingpong.1
   ibv_uc_pingpong.1
   ibv_ud_pingpong.1
diff --git a/libibverbs/man/ibv_attach_mcast.3 b/libibverbs/man/ibv_attach_mcast.3
deleted file mode 100644
index 2ae1f5d08d4a12..00000000000000
diff --git a/libibverbs/man/ibv_attach_mcast.3.md b/libibverbs/man/ibv_attach_mcast.3.md
new file mode 100644
index 00000000000000..42fb738fbc9d86
--- /dev/null
+++ b/libibverbs/man/ibv_attach_mcast.3.md
@@ -0,0 +1,57 @@
+---
+date: 2006-10-31
+footer: libibverbs
+header: "Libibverbs Programmer's Manual"
+layout: page
+license: 'Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md'
+section: 3
+title: IBV_ATTACH_MCAST
+---
+
+# NAME
+
+ibv_attach_mcast, ibv_detach_mcast - attach and detach a queue pair (QPs)
+to/from a multicast group
+
+# SYNOPSIS
+
+```c
+#include <infiniband/verbs.h>
+
+int ibv_attach_mcast(struct ibv_qp *qp, const union ibv_gid *gid, uint16_t lid);
+
+int ibv_detach_mcast(struct ibv_qp *qp, const union ibv_gid *gid, uint16_t lid);
+```
+
+# DESCRIPTION
+
+**ibv_attach_mcast()** attaches the QP *qp* to the multicast group having MGID
+*gid* and MLID *lid*.
+
+**ibv_detach_mcast()** detaches the QP *qp* to the multicast group having MGID
+*gid* and MLID *lid*.
+
+# RETURN VALUE
+
+**ibv_attach_mcast()** and **ibv_detach_mcast()** returns 0 on success, or the
+value of errno on failure (which indicates the failure reason).
+
+# NOTES
+
+Only QPs of Transport Service Type **IBV_QPT_UD** may be attached to multicast
+groups.
+
+If a QP is attached to the same multicast group multiple times, the QP will
+still receive a single copy of a multicast message.
+
+In order to receive multicast messages, a join request for the multicast group
+must be sent to the subnet administrator (SA), so that the fabric's multicast
+routing is configured to deliver messages to the local port.
+
+# SEE ALSO
+
+**ibv_create_qp**(3)
+
+# AUTHOR
+
+Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
diff --git a/libibverbs/man/ibv_event_type_str.3 b/libibverbs/man/ibv_event_type_str.3
deleted file mode 100644
index 2ae8b1c7ee3545..00000000000000
diff --git a/libibverbs/man/ibv_event_type_str.3.md b/libibverbs/man/ibv_event_type_str.3.md
new file mode 100644
index 00000000000000..35e61a3ced3ace
--- /dev/null
+++ b/libibverbs/man/ibv_event_type_str.3.md
@@ -0,0 +1,49 @@
+---
+date: 2006-10-31
+footer: libibverbs
+header: "Libibverbs Programmer's Manual"
+layout: page
+license: 'Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md'
+section: 3
+title: IBV_EVENT_TYPE_STR
+---
+
+# NAME
+
+ibv_event_type_str - Return string describing event_type enum value
+
+ibv_node_type_str - Return string describing node_type enum value
+
+ibv_port_state_str - Return string describing port_state enum value
+
+# SYNOPSIS
+
+```c
+#include <infiniband/verbs.h>
+
+const char *ibv_event_type_str(enum ibv_event_type event_type);
+
+const char *ibv_node_type_str(enum ibv_node_type node_type);
+
+const char *ibv_port_state_str(enum ibv_port_state port_state);
+```
+
+# DESCRIPTION
+
+**ibv_node_type_str()** returns a string describing the node type enum value
+*node_type*.
+
+**ibv_port_state_str()** returns a string describing the port state enum value
+*port_state*.
+
+**ibv_event_type_str()** returns a string describing the event type enum value
+*event_type*.
+
+# RETURN VALUE
+
+These functions return a constant string that describes the enum value passed
+as their argument.
+
+# AUTHOR
+
+Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
diff --git a/libibverbs/man/ibv_fork_init.3 b/libibverbs/man/ibv_fork_init.3
deleted file mode 100644
index 012ea20a4bffc5..00000000000000
diff --git a/libibverbs/man/ibv_fork_init.3.md b/libibverbs/man/ibv_fork_init.3.md
new file mode 100644
index 00000000000000..5b2a56472c1390
--- /dev/null
+++ b/libibverbs/man/ibv_fork_init.3.md
@@ -0,0 +1,69 @@
+---
+date: 2006-10-31
+footer: libibverbs
+header: "Libibverbs Programmer's Manual"
+layout: page
+license: 'Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md'
+section: 3
+title: IBV_FORK_INIT
+---
+
+# NAME
+
+ibv_fork_init - initialize libibverbs to support fork()
+
+# SYNOPSIS
+
+```c
+#include <infiniband/verbs.h>
+
+int ibv_fork_init(void);
+```
+
+# DESCRIPTION
+
+**ibv_fork_init()** initializes libibverbs's data structures to handle
+**fork()** function calls correctly and avoid data corruption, whether
+**fork()** is called explicitly or implicitly (such as in **system()**).
+
+It is not necessary to use this function if all parent process threads are
+always blocked until all child processes end or change address spaces via an
+**exec()** operation.
+
+# RETURN VALUE
+
+**ibv_fork_init()** returns 0 on success, or the value of errno on failure
+(which indicates the failure reason).
+
+# NOTES
+
+**ibv_fork_init()** works on Linux kernels supporting the **MADV_DONTFORK**
+flag for **madvise()** (2.6.17 and higher).
+
+Setting the environment variable **RDMAV_FORK_SAFE** or **IBV_FORK_SAFE** has
+the same effect as calling **ibv_fork_init()**.
+
+Setting the environment variable **RDMAV_HUGEPAGES_SAFE** tells the library to
+check the underlying page size used by the kernel for memory regions.  This is
+required if an application uses huge pages either directly or indirectly via a
+library such as libhugetlbfs.
+
+Calling **ibv_fork_init()** will reduce performance due to an extra system
+call for every memory registration, and the additional memory allocated to
+track memory regions.  The precise performance impact depends on the workload
+and usually will not be significant.
+
+Setting **RDMAV_HUGEPAGES_SAFE** adds further overhead to all memory
+registrations.
+
+# SEE ALSO
+
+**exec**(3),
+**fork**(2),
+**ibv_get_device_list**(3),
+**system**(3),
+**wait**(2)
+
+# AUTHOR
+
+Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
diff --git a/libibverbs/man/ibv_get_device_guid.3 b/libibverbs/man/ibv_get_device_guid.3
deleted file mode 100644
index 4652614033ea85..00000000000000
diff --git a/libibverbs/man/ibv_get_device_guid.3.md b/libibverbs/man/ibv_get_device_guid.3.md
new file mode 100644
index 00000000000000..683900f974cac7
--- /dev/null
+++ b/libibverbs/man/ibv_get_device_guid.3.md
@@ -0,0 +1,41 @@
+---
+date: 2006-10-31
+footer: libibverbs
+header: "Libibverbs Programmer's Manual"
+layout: page
+license: 'Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md'
+section: 3
+title: IBV_GET_DEVICE_GUID
+---
+
+# NAME
+
+ibv_get_device_guid - get an RDMA device's GUID
+
+# SYNOPSIS
+
+```c
+#include <infiniband/verbs.h>
+
+uint64_t ibv_get_device_guid(struct ibv_device *device);
+```
+
+# DESCRIPTION
+
+**ibv_get_device_name()** returns the Global Unique IDentifier (GUID) of the
+RDMA device *device*.
+
+# RETURN VALUE
+
+**ibv_get_device_guid()** returns the GUID of the device in network byte
+order.
+
+# SEE ALSO
+
+**ibv_get_device_list**(3),
+**ibv_get_device_name**(3),
+**ibv_open_device**(3)
+
+# AUTHOR
+
+Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
diff --git a/libibverbs/man/ibv_get_device_name.3 b/libibverbs/man/ibv_get_device_name.3
deleted file mode 100644
index ff9fa7fca9f517..00000000000000
diff --git a/libibverbs/man/ibv_get_device_name.3.md b/libibverbs/man/ibv_get_device_name.3.md
new file mode 100644
index 00000000000000..57035621a3cfbc
--- /dev/null
+++ b/libibverbs/man/ibv_get_device_name.3.md
@@ -0,0 +1,41 @@
+---
+date: ' 2006-10-31'
+footer: libibverbs
+header: "Libibverbs Programmer's Manual"
+layout: page
+license: 'Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md'
+section: 3
+title: IBV_GET_DEVICE_NAME
+---
+
+# NAME
+
+ibv_get_device_name - get an RDMA device's name
+
+# SYNOPSIS
+
+```c
+#include <infiniband/verbs.h>
+
+const char *ibv_get_device_name(struct ibv_device *device);
+```
+
+# DESCRIPTION
+
+**ibv_get_device_name()** returns a human-readable name associated with the
+RDMA device *device*.
+
+# RETURN VALUE
+
+**ibv_get_device_name()** returns a pointer to the device name, or NULL if the
+request fails.
+
+# SEE ALSO
+
+**ibv_get_device_guid**(3),
+**ibv_get_device_list**(3),
+**ibv_open_device**(3)
+
+# AUTHOR
+
+Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
diff --git a/libibverbs/man/ibv_get_srq_num.3 b/libibverbs/man/ibv_get_srq_num.3
deleted file mode 100644
index 4a1c92f32a2206..00000000000000
diff --git a/libibverbs/man/ibv_get_srq_num.3.md b/libibverbs/man/ibv_get_srq_num.3.md
new file mode 100644
index 00000000000000..f015b9ed783839
--- /dev/null
+++ b/libibverbs/man/ibv_get_srq_num.3.md
@@ -0,0 +1,45 @@
+---
+date: 2013-06-26
+footer: libibverbs
+header: "Libibverbs Programmer's Manual"
+layout: page
+license: 'Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md'
+section: 3
+title: IBV_GET_SRQ_NUM
+---
+
+# NAME
+
+ibv_get_srq_num  - return srq number associated with the given shared receive
+queue (SRQ)
+
+# SYNOPSIS
+
+```c
+#include <infiniband/verbs.h>
+
+int ibv_get_srq_num(struct ibv_srq *srq, uint32_t *srq_num);
+```
+
+# DESCRIPTION
+
+**ibv_get_srq_num()** return srq number associated with the given shared
+receive queue The argument *srq* is an ibv_srq struct, as defined in
+<infiniband/verbs.h>. *srq_num* is an output parameter that holds the returned
+srq number.
+
+
+# RETURN VALUE
+
+**ibv_get_srq_num()** returns 0 on success, or the value of errno on failure
+(which indicates the failure reason).
+
+# SEE ALSO
+
+**ibv_alloc_pd**(3),
+**ibv_create_srq_ex**(3),
+**ibv_modify_srq**(3)
+
+# AUTHOR
+
+Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/libibverbs/man/ibv_inc_rkey.3 b/libibverbs/man/ibv_inc_rkey.3
deleted file mode 100644
index 5c54a68bf34457..00000000000000
diff --git a/libibverbs/man/ibv_inc_rkey.3.md b/libibverbs/man/ibv_inc_rkey.3.md
new file mode 100644
index 00000000000000..44ba8e1758494b
--- /dev/null
+++ b/libibverbs/man/ibv_inc_rkey.3.md
@@ -0,0 +1,43 @@
+---
+date: 2015-01-29
+footer: libibverbs
+header: "Libibverbs Programmer's Manual"
+layout: page
+license: 'Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md'
+section: 3
+title: IBV_INC_RKEY
+---
+
+# NAME
+
+ibv_inc_rkey - creates a new rkey from the given one
+
+# SYNOPSIS
+
+```c
+#include <infiniband/verbs.h>
+
+uint32_t ibv_inc_rkey(uint32_t rkey);
+```
+
+# DESCRIPTION
+
+**ibv_inc_rkey()** Increases the 8 LSB of *rkey* and returns the new value.
+
+
+# RETURN VALUE
+
+**ibv_inc_rkey()** returns the new rkey.
+
+# NOTES
+
+
+The verb generates a new rkey that is different from the previous one on its
+tag part but has the same index (bits 0xffffff00). A use case for this verb
+can be to create a new rkey from a Memory window's rkey when binding it to a
+Memory region.
+
+# AUTHORS
+
+Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
+Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/libibverbs/man/ibv_query_gid.3 b/libibverbs/man/ibv_query_gid.3
deleted file mode 100644
index 45e128bcd1b069..00000000000000
diff --git a/libibverbs/man/ibv_query_gid.3.md b/libibverbs/man/ibv_query_gid.3.md
new file mode 100644
index 00000000000000..e1c67bb5a3bccf
--- /dev/null
+++ b/libibverbs/man/ibv_query_gid.3.md
@@ -0,0 +1,44 @@
+---
+date: 2006-10-31
+footer: libibverbs
+header: "Libibverbs Programmer's Manual"
+layout: page
+license: 'Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md'
+section: 3
+title: IBV_QUERY_GID
+---
+
+# NAME
+
+ibv_query_gid - query an InfiniBand port's GID table
+
+# SYNOPSIS
+
+```c
+#include <infiniband/verbs.h>
+
+int ibv_query_gid(struct ibv_context *context,
+                  uint8_t port_num,
+                  int index,
+                  union ibv_gid *gid);
+```
+
+# DESCRIPTION
+
+**ibv_query_gid()** returns the GID value in entry *index* of port *port_num*
+for device context *context* through the pointer *gid*.
+
+# RETURN VALUE
+
+**ibv_query_gid()** returns 0 on success, and -1 on error.
+
+# SEE ALSO
+
+**ibv_open_device**(3),
+**ibv_query_device**(3),
+**ibv_query_pkey**(3),
+**ibv_query_port**(3)
+
+# AUTHOR
+
+Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
diff --git a/libibverbs/man/ibv_query_pkey.3 b/libibverbs/man/ibv_query_pkey.3
deleted file mode 100644
index 3af40443bf5cf4..00000000000000
diff --git a/libibverbs/man/ibv_query_pkey.3.md b/libibverbs/man/ibv_query_pkey.3.md
new file mode 100644
index 00000000000000..8c8e71bc12e3a9
--- /dev/null
+++ b/libibverbs/man/ibv_query_pkey.3.md
@@ -0,0 +1,45 @@
+---
+date: 2006-10-31
+footer: libibverbs
+header: "Libibverbs Programmer's Manual"
+layout: page
+license: 'Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md'
+section: 3
+title: IBV_QUERY_PKEY
+---
+
+# NAME
+
+ibv_query_pkey - query an InfiniBand port's P_Key table
+
+# SYNOPSIS
+
+```c
+#include <infiniband/verbs.h>
+
+int ibv_query_pkey(struct ibv_context *context,
+                   uint8_t port_num,
+                   int index,
+                   uint16_t *pkey);
+```
+
+# DESCRIPTION
+
+**ibv_query_pkey()** returns the P_Key value (in network byte order) in entry
+*index* of port *port_num* for device context *context* through the pointer
+*pkey*.
+
+# RETURN VALUE
+
+**ibv_query_pkey()** returns 0 on success, and -1 on error.
+
+# SEE ALSO
+
+**ibv_open_device**(3),
+**ibv_query_device**(3),
+**ibv_query_gid**(3),
+**ibv_query_port**(3)
+
+# AUTHOR
+
+Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
diff --git a/libibverbs/man/ibv_rate_to_mbps.3 b/libibverbs/man/ibv_rate_to_mbps.3
deleted file mode 100644
index 27e8724b5fa3a7..00000000000000
diff --git a/libibverbs/man/ibv_rate_to_mbps.3.md b/libibverbs/man/ibv_rate_to_mbps.3.md
new file mode 100644
index 00000000000000..edfb4ff3c31506
--- /dev/null
+++ b/libibverbs/man/ibv_rate_to_mbps.3.md
@@ -0,0 +1,50 @@
+---
+date: 2012-03-31
+footer: libibverbs
+header: "Libibverbs Programmer's Manual"
+layout: page
+license: 'Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md'
+section: 3
+title: IBV_RATE_TO_MBPS
+---
+
+# NAME
+
+ibv_rate_to_mbps - convert IB rate enumeration to Mbit/sec
+
+mbps_to_ibv_rate - convert Mbit/sec to an IB rate enumeration
+
+# SYNOPSIS
+
+```c
+#include <infiniband/verbs.h>
+
+int ibv_rate_to_mbps(enum ibv_rate rate);
+
+enum ibv_rate mbps_to_ibv_rate(int mbps);
+```
+
+# DESCRIPTION
+
+**ibv_rate_to_mbps()** converts the IB transmission rate enumeration *rate* to
+a number of Mbit/sec. For example, if *rate* is **IBV_RATE_5_GBPS**, the
+value 5000 will be returned (5 Gbit/sec = 5000 Mbit/sec).
+
+**mbps_to_ibv_rate()** converts the number of Mbit/sec *mult* to an IB
+transmission rate enumeration. For example, if *mult* is 5000, the rate
+enumeration **IBV_RATE_5_GBPS** will be returned.
+
+# RETURN VALUE
+
+**ibv_rate_to_mbps()** returns the number of Mbit/sec.
+
+**mbps_to_ibv_rate()** returns the enumeration representing the IB
+transmission rate.
+
+# SEE ALSO
+
+**ibv_query_port**(3)
+
+# AUTHOR
+
+Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
diff --git a/libibverbs/man/ibv_rate_to_mult.3 b/libibverbs/man/ibv_rate_to_mult.3
deleted file mode 100644
index 6e2a59ddf10948..00000000000000
diff --git a/libibverbs/man/ibv_rate_to_mult.3.md b/libibverbs/man/ibv_rate_to_mult.3.md
new file mode 100644
index 00000000000000..0833809924b43e
--- /dev/null
+++ b/libibverbs/man/ibv_rate_to_mult.3.md
@@ -0,0 +1,52 @@
+---
+date: 2006-10-31
+footer: libibverbs
+header: "Libibverbs Programmer's Manual"
+layout: page
+license: 'Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md'
+section: 3
+title: IBV_RATE_TO_MULT
+---
+
+# NAME
+
+ibv_rate_to_mult - convert IB rate enumeration to multiplier of 2.5 Gbit/sec
+
+mult_to_ibv_rate - convert multiplier of 2.5 Gbit/sec to an IB rate
+enumeration
+
+# SYNOPSIS
+
+```c
+#include <infiniband/verbs.h>
+
+int ibv_rate_to_mult(enum ibv_rate rate);
+
+enum ibv_rate mult_to_ibv_rate(int mult);
+```
+
+# DESCRIPTION
+
+**ibv_rate_to_mult()** converts the IB transmission rate enumeration *rate* to
+a multiple of 2.5 Gbit/sec (the base rate). For example, if *rate* is
+**IBV_RATE_5_GBPS**, the value 2 will be returned (5 Gbit/sec = 2 * 2.5
+Gbit/sec).
+
+**mult_to_ibv_rate()** converts the multiplier value (of 2.5 Gbit/sec) *mult*
+to an IB transmission rate enumeration. For example, if *mult* is 2, the rate
+enumeration **IBV_RATE_5_GBPS** will be returned.
+
+# RETURN VALUE
+
+**ibv_rate_to_mult()** returns the multiplier of the base rate 2.5 Gbit/sec.
+
+**mult_to_ibv_rate()** returns the enumeration representing the IB
+transmission rate.
+
+# SEE ALSO
+
+**ibv_query_port**(3)
+
+# AUTHOR
+
+Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
diff --git a/libibverbs/man/ibv_req_notify_cq.3 b/libibverbs/man/ibv_req_notify_cq.3
deleted file mode 100644
index 1d1d62130d7bc7..00000000000000
diff --git a/libibverbs/man/ibv_req_notify_cq.3.md b/libibverbs/man/ibv_req_notify_cq.3.md
new file mode 100644
index 00000000000000..b1b57b483eaca1
--- /dev/null
+++ b/libibverbs/man/ibv_req_notify_cq.3.md
@@ -0,0 +1,55 @@
+---
+date: 2006-10-31
+footer: libibverbs
+header: "Libibverbs Programmer's Manual"
+layout: page
+license: 'Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md'
+section: 3
+title: IBV_REQ_NOTIFY_CQ
+---
+
+# NAME
+
+ibv_req_notify_cq - request completion notification on a completion queue (CQ)
+
+# SYNOPSIS
+
+```c
+#include <infiniband/verbs.h>
+
+int ibv_req_notify_cq(struct ibv_cq *cq, int solicited_only);
+```
+
+# DESCRIPTION
+
+**ibv_req_notify_cq()** requests a completion notification on the completion
+queue (CQ) *cq*.
+
+Upon the addition of a new CQ entry (CQE) to *cq*, a completion event will be
+added to the completion channel associated with the CQ. If the argument
+*solicited_only* is zero, a completion event is generated for any new CQE.  If
+*solicited_only* is non-zero, an event is only generated for a new CQE with
+that is considered "solicited."  A CQE is solicited if it is a receive
+completion for a message with the Solicited Event header bit set, or if the
+status is not successful.  All other successful receive completions, or any
+successful send completion is unsolicited.
+
+# RETURN VALUE
+
+**ibv_req_notify_cq()** returns 0 on success, or the value of errno on failure
+(which indicates the failure reason).
+
+# NOTES
+
+The request for notification is "one shot."  Only one completion event will be
+generated for each call to **ibv_req_notify_cq()**.
+
+# SEE ALSO
+
+**ibv_create_comp_channel**(3),
+**ibv_create_cq**(3),
+**ibv_get_cq_event**(3)
+
+# AUTHOR
+
+Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
diff --git a/libibverbs/man/ibv_rereg_mr.3 b/libibverbs/man/ibv_rereg_mr.3
deleted file mode 100644
index 9fa567c2a2eb72..00000000000000
diff --git a/libibverbs/man/ibv_rereg_mr.3.md b/libibverbs/man/ibv_rereg_mr.3.md
new file mode 100644
index 00000000000000..e6b00983f40131
--- /dev/null
+++ b/libibverbs/man/ibv_rereg_mr.3.md
@@ -0,0 +1,91 @@
+---
+date: 2016-03-13
+footer: libibverbs
+header: "Libibverbs Programmer's Manual"
+layout: page
+license: 'Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md'
+section: 3
+title: IBV_REREG_MR
+---
+
+# NAME
+
+ibv_rereg_mr - re-register a memory region (MR)
+
+# SYNOPSIS
+
+```c
+#include <infiniband/verbs.h>
+
+int ibv_rereg_mr(struct ibv_mr *mr,
+                 int flags,
+                 struct ibv_pd *pd,
+                 void *addr,
+                 size_t length,
+                 int access);
+```
+
+# DESCRIPTION
+
+**ibv_rereg_mr()** Modifies the attributes of an existing memory region (MR)
+*mr*. Conceptually, this call performs the functions deregister memory region
+followed by register memory region.  Where possible, resources are reused
+instead of deallocated and reallocated.
+
+*flags* is a bit-mask used to indicate which of the following properties of
+the memory region are being modified. Flags should be a combination (bit
+field) of:
+
+**IBV_REREG_MR_CHANGE_TRANSLATION **
+:	Change translation (location and length)
+
+**IBV_REREG_MR_CHANGE_PD **
+:	Change protection domain
+
+**IBV_REREG_MR_CHANGE_ACCESS **
+:	Change access flags
+
+When **IBV_REREG_MR_CHANGE_PD** is used, *pd* represents the new PD this MR
+should be registered to.
+
+When **IBV_REREG_MR_CHANGE_TRANSLATION** is used, *addr*. represents the
+virtual address (user-space pointer) of the new MR, while *length* represents
+its length.
+
+The access and other flags are represented in the field *access*. This field
+describes the desired memory protection attributes; it is either 0 or the
+bitwise OR of one or more of ibv_access_flags.
+
+# RETURN VALUE
+
+**ibv_rereg_mr()** returns 0 on success, otherwise an error has occurred,
+*enum ibv_rereg_mr_err_code* represents the error as of below.
+
+IBV_REREG_MR_ERR_INPUT - Old MR is valid, an input error was detected by
+libibverbs.
+
+IBV_REREG_MR_ERR_DONT_FORK_NEW - Old MR is valid, failed via don't fork on new
+address range.
+
+IBV_REREG_MR_ERR_DO_FORK_OLD - New MR is valid, failed via do fork on old
+address range.
+
+IBV_REREG_MR_ERR_CMD - MR shouldn't be used, command error.
+
+IBV_REREG_MR_ERR_CMD_AND_DO_FORK_NEW - MR shouldn't be used, command error,
+invalid fork state on new address range.
+
+
+# NOTES
+
+Even on a failure, the user still needs to call ibv_dereg_mr on this MR.
+
+# SEE ALSO
+
+**ibv_dereg_mr**(3),
+**ibv_reg_mr**(3)
+
+# AUTHORS
+
+Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
+Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/libibverbs/man/ibv_resize_cq.3 b/libibverbs/man/ibv_resize_cq.3
deleted file mode 100644
index b1595010373348..00000000000000
diff --git a/libibverbs/man/ibv_resize_cq.3.md b/libibverbs/man/ibv_resize_cq.3.md
new file mode 100644
index 00000000000000..6582d12502f8c0
--- /dev/null
+++ b/libibverbs/man/ibv_resize_cq.3.md
@@ -0,0 +1,48 @@
+---
+date: 2006-10-31
+footer: libibverbs
+header: "Libibverbs Programmer's Manual"
+layout: page
+license: 'Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md'
+section: 3
+title: IBV_RESIZE_CQ
+---
+
+# NAME
+
+ibv_resize_cq - resize a completion queue (CQ)
+
+# SYNOPSIS
+
+```c
+#include <infiniband/verbs.h>
+
+int ibv_resize_cq(struct ibv_cq *cq, int cqe);
+```
+
+# DESCRIPTION
+
+**ibv_resize_cq()** resizes the completion queue (CQ) *cq* to have at least
+*cqe* entries. *cqe* must be at least the number of unpolled entries in the CQ
+*cq*. If *cqe* is a valid value less than the current CQ size,
+**ibv_resize_cq()** may not do anything, since this function is only
+guaranteed to resize the CQ to a size at least as big as the requested size.
+
+# RETURN VALUE
+
+**ibv_resize_cq()** returns 0 on success, or the value of errno on failure
+(which indicates the failure reason).
+
+# NOTES
+
+**ibv_resize_cq()** may assign a CQ size greater than or equal to the
+requested size. The cqe member of *cq* will be updated to the actual size.
+
+# SEE ALSO
+
+**ibv_create_cq**(3),
+**ibv_destroy_cq**(3)
+
+# AUTHOR
+
+Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
