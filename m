From: Oren Duer <oren.duer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH RFC] Introduce verbs API for NVMe-oF target offload
Date: Mon, 25 Dec 2017 15:14:37 +0200
Message-ID: <CADZhsQrncxo9DvD4+bzWNmepf=EpbwysRoU2z=2UQSjp9LXxXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This RFC patch introduces a libibverbs API for offloading NVMe-over-Fabrics
target protocol to HCA.

Using this feature, the HCA will terminate the target side NVMe-oF protocol and
submit the NVMe requests directly to NVMe devices over PCI using peer-to-peer
communication. No CPU involvement is needed beyond first configuration, setting
up connections with clients, and exceptions handling.

Userspace applications that implement NVMe-oF target, such as SPDK, are
the target for this capability.

Full explanation is in Documentation/nvmf_offload.md, part of this patch.

Issue: 1160022
Change-Id: Icdc530c8cf3be076407b6059df0dd315e3ce35a0
Signed-off-by: Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 Documentation/nvmf_offload.md             | 172 ++++++++++++++++++++++++++++++
 libibverbs/man/ibv_create_srq_ex.3        |  48 +++++++--
 libibverbs/man/ibv_get_async_event.3      |  15 ++-
 libibverbs/man/ibv_map_nvmf_nsid.3        |  89 ++++++++++++++++
 libibverbs/man/ibv_qp_set_nvmf.3          |  53 +++++++++
 libibverbs/man/ibv_query_device_ex.3      |  26 +++++
 libibverbs/man/ibv_srq_create_nvme_ctrl.3 |  89 ++++++++++++++++
 libibverbs/verbs.h                        | 107 ++++++++++++++++++-
 8 files changed, 588 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/nvmf_offload.md
 create mode 100644 libibverbs/man/ibv_map_nvmf_nsid.3
 create mode 100644 libibverbs/man/ibv_qp_set_nvmf.3
 create mode 100644 libibverbs/man/ibv_srq_create_nvme_ctrl.3

diff --git a/Documentation/nvmf_offload.md b/Documentation/nvmf_offload.md
new file mode 100644
index 0000000..c002e60
--- /dev/null
+++ b/Documentation/nvmf_offload.md
@@ -0,0 +1,172 @@
+# Hardware NVMe-oF target offload
+
+## Introduction
+
+NVMe-over-Fabrics target offload allows an HCA to offload the complete NVMe-oF
+protocol datapath at the target (storage server) side, when the backend storage
+devices are locally attached NVMe PCI devices.
+
+After correctly setting up the offload and connections to clients, every
+read/write/flush operation may be completely processed in the HCA at the target
+side. No software will be running on the CPU to process those offloaded IO
+operations. The HCA is utilizing the PCIe peer-to-peer capability to "talk"
+directly to the NVMe drives over PCI. It is required that the system
+architecture will allow such peer-to-peer communications.
+
+The software at the server side is in charge of configuring the feature and
+managing the NVMe-oF control communication with the clients (via NVMe-oF admin
+queue). As response to these communications, connected QPs are
created with each
+client (by means of RDMA-CM, as defined in the NVMe-oF standard), which
+represent NVMe-oF SQ and CQ pairs. Once a connection is created, the QP is
+handed to the device to start offloading all IO commands.
+
+Software is also required to handle any error cases, and IO commands that were
+not configured to be offloaded.
+
+## NVMe-oF target offload datapath
+
+Once properly configured and connections are established, the HCA will:
+* Parse the RECVed NVMe-oF command capsule, and understand whether it is a READ
+  / WRITE / FLUSH operation that should be offloaded.
+* If this is a WRITE, the HCA will RDMA_READ the data from the client to local
+  memory (unless it was inline with the command).
+* The HCA will strip the NVMe command from the capsule, place it in an NVMe
+  submit queue, and write to the submit queue doorbell.
+* The HCA will poll the NVMe completion queue, and write to the
completion queue
+  doorbell.
+* If this is a READ, the HCA will RDMA_WRITE the data from the local memory to
+  the client.
+* The HCA will SEND the the NVMe completion in a response capsule back to the
+  client.
+
+## NVMe-oF target offload configuration
+
+Setting up NVMe-oF target offload requires few steps:
+1. Identify NVMe-oF offload capabilities of the device
+2. Creating a SRQ with NVMe-oF offload attributes, to represent a
single NVMe-oF
+   subsystem
+3. Creating NVMe backend device objects to represent locally attached NVMe
+   subsystems
+4. Setting up mappings between front-end facing namespace ids to a specific
+   backend NVMe objects and namespace ids
+5. Creating QPs connected with clients (using RDMA-CM, not in the scope of this
+   document), bound to an SRQ with NVMe-oF offload
+6. Modifying QP to enable NVMe-oF offload
+
+### Identify NVMe-oF offload capabilities
+
+Software should call `ibv_query_device_ex()`, and test the returned
+`ibv_device_attr_ex.comp_mask` for the avilability of NVMe-oF offload. If
+available, the `ibv_device_attr_ex.nvmf_caps` struct holds the exact offload
+capabilities and parameters of the device. These should be considered later
+during the configuration.
+
+### Creating a SRQ with NVMe-oF offload attributes
+
+A SRQ with NVMe-oF target offload represents a single NVMe-oF subsystem (a
+storage target) to the fabric.  Software should call
`ibv_create_srq_ex()`, with
+`ibv_srq_init_attr_ex.srq_type` set to `nvmf_target_offload` and
+`ibv_srq_init_attr_ex.nvmf_attr` set to the specific offload parameters
+requested for this SRQ. Parameters should be within the boundaries of the
+respected capabilities. Along with the parameters, a staging buffer is provided
+for the device use during the offload. This is a piece of memory allocated,
+registered and provided via {mr, addr, len}. Software should not modify this
+memory after creating the SRQ, as the device manages it by itself, and stores
+there data that is in transit between network and NVMe device.
+
+Note that this SRQ still has a receive queue. HCA will deliver to software
+received commands that are not offloaded, and received commands from QPs
+attached to the SRQ that are not configured with NVMF_OFFLOAD enabled.
+
+### Creating NVMe backend device objects
+
+For the SRQ with NVMe-oF target offload feature to be able to submit work to
+attached NVMe devices, software must provide the details of where to find the
+NVMe submit queue, completion queue and their respective doorbells.  How these
+NVMe SQ, CQ and DBs are created is out of scope for this document. Normally
+there should be an NVMe driver that owns the NVMe Admin Queue. By submitting
+commands to this Admin Queue, SQs, CQs and DBs are generated.  Software should
+call `ibv_srq_create_nvme_ctrl()` with a set of NVMe {SQ, CQ, SQDB, CQDB} to
+create an `ibv_nvme_ctrl` instance representing a specific NVMe backend
+controller. These {SQ, CQ, SQDB, CQDB} should have been created exclusively for
+this NVMe backend controller object, and this NVMe backend controller can be
+used exclusively with the SRQ it was created for.  SQ, CQ, SQDB and
CQDB are all
+provided by means of MR, address and possibly length (doorbells don't need
+length as they have fixed 32 bit size). This means that those
structures need to
+be registered using `ibv_reg_mr()` before `ibv_nvme_ctrl` can be created.
+
+Additionally, SQDB and CQDB initial values are provided.
+
+Having NVMe objects created on SRQ does not yet allow servicing NVMe-oF to
+clients. Namespace mappings that use these NVMe objects must be added.
+
+### Setting up namespaces mappings
+
+When a client connects to an NVMe-oF subsystem, it will ask for the namespaces
+list on that subsystem. Each namespace is identified by a namespace id (nsid),
+that is then part of every IO request. The SRQ with NVMe-oF target offload
+feature enabled will look at this nsid and map it to a specific nsid in one of
+the NVMe backend objects created with it.  Software should call
+`ibv_map_nvmf_nsid()` to add such mappings to a SRQ. Each mapping consists of a
+fabric-facing nsid and a set of {nvme_ctrl, nvme_nsid}. So IO operations
+arriving from network for nsid will be submitted to nvme_ctrl, with a different
+nvme_nsid.  Software may create as many front-facing namespaces as needed, and
+map them to different namespaces within the same nvme_ctrl or to namespaces in
+different nvme_ctrls. However, as noted before, an nvme_ctrl may only
be used in
+mappings for the same SRQ it was created for.
+
+After adding at least one namespace mapping, the SRQ as NVMe-oF
target subsystem
+is ready to service IOs.
+
+### Creating QPs
+
+This stage is not different than any other normal QP creation and association
+with SRQ.  The NVMe-oF protocol standard requires that the first
command on a QP
+(that represents NVMe SQ) will be the CONNECT command capsule, and any other
+commands should be responded with error. To meet the standard, the software
+should not enable the QP NVme-oF offload (see next section) until after seeing
+the CONNECT command. If a command different than CONNECT is received, software
+should respond with error.
+
+### Modifying QP to enable NVMe-oF offload
+
+Once a CONNECT command was received, software can modify the QP to enable its
+NVMe-oF offload. `ibv_modify_qp_nvmf()` should be used to enable NVMe-oF
+offload.  From this point on, the HCA is taking ownership over the QP,
+inspecting each command capsule received by the SRQ, and if this should be an
+offloaded command, the flow described above is followed.
+
+Note that enabling the NVMe-oF offload on the QP when created exposes the
+solution to possible standard violation: if an IO command capsule will arrive
+before the CONNECT request, the device will service it.
+
+## Errors and exceptions
+
+Software should properly handle the following errors and exceptions:
+1. Handle a non-offloaded IO request
+2. Handle async events with QP type
+3. Handle async events with SRQ type
+
+### Handle a non-offloaded IO request
+
+This should be considered as a normal exception in case the SRQ was configured
+to offload only part of the IO requests.  In this case, software will receive
+the completion on the CQ assigned with the QP, with the request in the SRQ.
+Software should process the request, and it is allowed to generate RDMA
+operations (reads, writes, sends) on the relevant QP in order to properly
+terminate the transaction.
+
+### Handle async events with QP type
+
+Software should listen to async events using `ibv_get_async_event()`.
In case of
+unrecoverable transport error hapenning on one of the offloaded QPs
it will move
+to error state and flush its queue. Since in normal operation the software may
+not post to such QP and expect completions on it, the HCA will report an async
+event indicating this QP has moved to error state.  Software should treat this
+as any other QP in error, i.e. close the connection and all its resources.
+
+### Handle async events with NVME_CTRL type
+
+In case of unrecoverable error in HCA communication with an NVMe device, HCA
+will report an async event indicating an error with NVME_CTRL. Software is
+expected to remove this NVMe object and its related mappings.
diff --git a/libibverbs/man/ibv_create_srq_ex.3
b/libibverbs/man/ibv_create_srq_ex.3
index 97529ae..056bfc8 100644
--- a/libibverbs/man/ibv_create_srq_ex.3
+++ b/libibverbs/man/ibv_create_srq_ex.3
@@ -26,11 +26,12 @@ struct ibv_srq_init_attr_ex {
 void                   *srq_context;    /* Associated context of the SRQ */
 struct ibv_srq_attr     attr;           /* SRQ attributes */
 uint32_t                comp_mask;      /* Identifies valid fields */
-enum ibv_srq_type       srq_type;       /* Basic / XRC / tag matching */
+enum ibv_srq_type       srq_type;       /* Basic / XRC / tag matching
/ NVMe-oF target offload */
 struct ibv_pd          *pd;             /* PD associated with the SRQ */
 struct ibv_xrcd        *xrcd;           /* XRC domain to associate
with the SRQ */
 struct ibv_cq          *cq;             /* CQ to associate with the
SRQ for XRC mode */
 struct ibv_tm_cap       tm_cap;         /* Tag matching attributes */
+struct ibv_nvmf_attrs   nvmf_attr;      /* NVMe-oF target offload attributes */
 .in -8
 };
 .sp
@@ -42,16 +43,48 @@ uint32_t                max_sge;        /*
Requested max number of scatter eleme
 uint32_t                srq_limit;      /* The limit value of the SRQ */
 .in -8
 };
-.sp
-.nf
+
 struct ibv_tm_cap {
 .in +8
 uint32_t                max_num_tags;   /* Tag matching list size */
 uint32_t                max_ops;        /* Number of outstanding tag
list operations */
 .in -8
 };
-.sp
-.nf
+
+
+enum ibv_nvmf_offload_ops {
+.in +8
+IBV_NVMF_OPS_WRITE            = 1 << 0,
+IBV_NVMF_OPS_READ             = 1 << 1,
+IBV_NVMF_OPS_FLUSH            = 1 << 2,
+IBV_NVMF_OPS_READ_WRITE       = IBV_NVMF_OPS_READ | IBV_NVMF_OPS_WRITE,
+IBV_NVMF_OPS_READ_WRITE_FLUSH = IBV_NVMF_OPS_READ_WRITE | IBV_NVMF_OPS_FLUSH
+.in -8
+};
+
+struct ibv_mr_sg {
+.in +8
+struct ibv_mr   *mr;
+union {
+        void            *addr;
+        uint64_t         offset;
+};
+uint64_t        len;
+.in -8
+}
+
+struct ibv_nvmf_attrs {
+.in +8
+enum ibv_nvmf_offload_ops offload_ops ;     /* Which NVMe-oF
operations to offload, combination should be supported according to
caps */
+uint32_t                max_namespaces;   /* Maximum allowed
front-facing namespaces */
+uint8_t                 nvme_log_page_sz; /* Page size of NVMe
backend controllers, log, 4KB units */
+uint32_t                ioccsz;           /* IO command capsule size,
16B units (NVMe-oF standard) */
+uint16_t                icdoff;           /* In-capsule data offset,
16B units (NVMe-oF standard) */
+uint32_t                max_io_sz;        /* Max IO transfer per NVMf
transaction */
+uint16_t                nvme_queue_depth; /* Number of elements in
queues of NVMe backend controllers */
+struct ibv_mr_sg        staging_buf;      /* Memory for a staging
buffer space */
+.in -8
+};
 .fi
 .PP
 The function
@@ -77,7 +110,10 @@ fails if any queue pair is still associated with this SRQ.
 .SH "SEE ALSO"
 .BR ibv_alloc_pd (3),
 .BR ibv_modify_srq (3),
-.BR ibv_query_srq (3)
+.BR ibv_query_srq (3),
+.BR ibv_map_nvmf_nsid (3),
+.BR ibv_unmap_nvmf_nsid (3),
+.BR ibv_query_device_ex (3)
 .SH "AUTHORS"
 .TP
 Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/libibverbs/man/ibv_get_async_event.3
b/libibverbs/man/ibv_get_async_event.3
index 85ce6e1..ecd8387 100644
--- a/libibverbs/man/ibv_get_async_event.3
+++ b/libibverbs/man/ibv_get_async_event.3
@@ -26,10 +26,11 @@ struct ibv_async_event {
 .in +8
 union {
 .in +8
-struct ibv_cq  *cq;             /* CQ that got the event */
-struct ibv_qp  *qp;             /* QP that got the event */
-struct ibv_srq *srq;            /* SRQ that got the event */
-int             port_num;       /* port number that got the event */
+struct ibv_cq        *cq;             /* CQ that got the event */
+struct ibv_qp        *qp;             /* QP that got the event */
+struct ibv_srq       *srq;            /* SRQ that got the event */
+struct ibv_nvme_ctrl *nvme_ctrl;      /* NVMe backend controller got event */
+int                   port_num;       /* port number that got the event */
 .in -8
 } element;
 enum ibv_event_type     event_type;     /* type of the event */
@@ -89,6 +90,12 @@ following events:
 .TP
 .B IBV_EVENT_DEVICE_FATAL \fR CA is in FATAL state
 .PP
+.I NVMe controller events:
+.TP
+.B IBV_EVENT_NVME_PCI_ERR \fR NVMe backend controller PCI error
+.TP
+.B IBV_EVENT_NVME_TIMEOUT \fR NVMe backend controller completion timeout
+.PP
 .B ibv_ack_async_event()
 acknowledge the async event
 .I event\fR.
diff --git a/libibverbs/man/ibv_map_nvmf_nsid.3
b/libibverbs/man/ibv_map_nvmf_nsid.3
new file mode 100644
index 0000000..e472803
--- /dev/null
+++ b/libibverbs/man/ibv_map_nvmf_nsid.3
@@ -0,0 +1,89 @@
+.\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See
COPYING.md
+.\"
+.TH IBV_MAP_NVMF_NSID 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
+.SH "NAME"
+ibv_map_nvmf_nsid \- add namespace id mapping to NVMe-oF offload
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/verbs.h>
+.sp
+.BI "int ibv_map_nvmf_nsid(struct ibv_nvme_ctrl " "*nvme_ctrl" ,
+.BI "                         uint32_t " "fe_nsid" ,
+.BI "                         uint16_t " "lba_data_size" ,
+.BI "                         uint32_t " "nvme_nsid" );
+.sp
+.BI "int ibv_unmap_nvmf_nsid(struct ibv_nvme_ctrl " "*nvme_ctrl" ,
+.BI "                         uint32_t " "fe_nsid" );
+.fi
+.SH "DESCRIPTION"
+.B ibv_map_nvmf_nsid()
+adds a new NVMe-oF namespace mapping to a given \fInvme_ctrl\fR.
+The mapping is from the fabric facing frontend namespace ID
+.I fe_nsid
+to namespace
+.I nvme_nsid
+on this NVMe subsystem.
+.I fe_nsid
+must be unique within the SRQ that
+.I nvme_ctrl
+belongs to, all ibv_nvme_ctrl objects attached to the same SRQ share
the same number space.
+.PP
+.I lba_data_size
+defines the block size this namespace is formatted to, in bytes. Only
specific block sizes are supported by the device.
+
+.fi
+.PP
+If the operation is successful, NVMe-oF IO requests to namespace
+.I fe_nsid
+received by the SRQ that belongs to
+.I nvme_ctrl
+are forwarded to namespace
+.I nvme_nsid
+within that NVMe subsystem.
+
+.PP
+Mapping several namespaces of the same NVMe subsystem will be done by
calling this function several times with the same
+.I nvme_ctrl
+while assigning different
+.I fe_nsid
+and
+.I nvme_nsid
+with each call.
+
+.PP
+.B ibv_unmap_nvmf_nsid()
+deletes the map of
+.I fe_nsid
+from the given
+.I nvme_ctrl
+
+.SH "RETURN VALUE"
+.B ibv_map_nvmf_nsid()
+and
+.B ibv_unmap_nvmf_nsid
+returns 0 on success, or the value of errno on failure (which
indicates the failure reason).
+.PP
+failure reasons may be:
+.IP EEXIST
+Trying to map an already existing front-facing
+.I fe_nsid
+.IP ENOENT
+Trying to delete a non existing front-facing
+.I fe_nsid
+.IP ENOTSUP
+Given
+.I lba_data_size
+is not supported on this device. Check device release notes for
supported sizes. Format the NVMe namespace to a LBA Format where the
data + metadata size is supported by the device.
+
+
+.SH "NOTES"
+This function does not validate that the supplied NVMe subsystem
indeed serves the mapped nvme_nsid. Mapping to an un-existing
nvme_nsid will result in failure of IOs to the mapped front-facing
fe_nsid.
+
+.SH "SEE ALSO"
+.BR ibv_create_srq_ex (3), ibv_srq_create_nvme_ctrl (3)
+
+.SH "AUTHORS"
+.TP
+Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+
diff --git a/libibverbs/man/ibv_qp_set_nvmf.3 b/libibverbs/man/ibv_qp_set_nvmf.3
new file mode 100644
index 0000000..581e59f
--- /dev/null
+++ b/libibverbs/man/ibv_qp_set_nvmf.3
@@ -0,0 +1,53 @@
+.\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See
COPYING.md
+.\"
+.TH IBV_QP_SET_NVMF 3 libibverbs "Libibverbs Programmer's Manual"
+.SH "NAME"
+ibv_qp_set_nvmf \- modify the NVMe-oF offload attribute of a queue pair (QP)
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/verbs.h>
+.sp
+.BI "int ibv_qp_set_nvmf(struct ibv_qp " "*qp" ", unsigned int flags);"
+.fi
+.SH "DESCRIPTION"
+.B ibv_qp_set_nvmf()
+modifies NVMe-oF offload functionality of
+.I qp
+according to the given
+.I flags
+:
+
+.PP
+.nf
+enum {
+.in +8
+IBV_QP_NVMF_ATTR_FLAG_ENABLE     = 1 << 0,
+.in -8
+}
+.fi
+
+.PP
+To enable the NVMe-oF offload capability, the QP must be bound with a
SRQ that was created with NVMe-oF attributes. As long as NVMe-oF
offload isn't enabled for the QP, all messages arriving to it will be
delivered to software via the bound SRQ. After enabling NVMe-oF
offload, NVMe-oF requests that were configured in the SRQ attributes
to be offloaded will be handled completely by the device.
+.PP
+Unrecognized messages or NVMe-oF requests that were not configured to
be offloaded will continue to be delivered to software via the SRQ.
Software may continue to post on the QP even after NVMe-oF offload was
enabled on it, and the hardware will arbitrate between the software
posts and the device posts done by the offload. Posts done by software
will be completed as normal using the assigned CQ.
+.PP
+The NVMe-oF standard requires that the first command sent on an IO
queue will be the "CONNECT" command. It is expected that software will
enable NVMe-oF offload on the QP after the "CONNECT" command was seen.
In case other commands preceeded the "CONNECT" command, it is expected
that software will send errors to the client.
+.PP
+In case of a transport error on the QP that resulted in it changing
to the ERROR state, posted commands are completed with errors. When
NVMe-oF offload is enabled, an async message will be sent to indicate
this, since it is possible that software does not have anything posted
on this QP. Therefore it is required to listen on async events when
working with NVMe-oF offload.
+
+.SH "RETURN VALUE"
+.B ibv_qp_set_nvmf()
+returns 0 on success, or the value of errno on failure:
+.IP EINVAL
+Trying to enable NVMe-oF offload on a QP not bound to SRQ with
NVMe-oF configured.
+
+.SH "NOTES"
+
+.SH "SEE ALSO"
+.BR ibv_create_srq_ex (3),
+.BR ibv_get_async_event (3)
+
+.SH "AUTHORS"
+.TP
+Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/libibverbs/man/ibv_query_device_ex.3
b/libibverbs/man/ibv_query_device_ex.3
index 1172523..0336583 100644
--- a/libibverbs/man/ibv_query_device_ex.3
+++ b/libibverbs/man/ibv_query_device_ex.3
@@ -35,6 +35,7 @@ struct ibv_packet_pacing_caps packet_pacing_caps; /*
Packet pacing capabilities
 uint32_t               raw_packet_caps;            /* Raw packet
capabilities, use enum ibv_raw_packet_caps */
 struct ibv_tm_caps     tm_caps;                    /* Tag matching
capabilities */
 struct ibv_cq_moderation_caps  cq_mod_caps;        /* CQ moderation
max capabilities */
+struct ibv_nvmf_caps   nvmf_caps;                  /* NVMe-oF target
offload capabilities */
 .in -8
 };

@@ -106,6 +107,31 @@ struct ibv_cq_moderation_caps {
        uint16_t max_cq_count;
        uint16_t max_cq_period;
 };
+
+enum ibv_nvmf_offload_type {
+.in +8
+IBV_NVMF_WRITE_OFFLOAD            = 1 << 0,
+IBV_NVMF_READ_OFFLOAD             = 1 << 1,
+IBV_NVMF_READ_WRITE_OFFLOAD       = 1 << 2,
+IBV_NVMF_READ_WRITE_FLUSH_OFFLOAD = 1 << 3,
+.in -8
+};
+
+struct ibv_nvmf_caps {
+.in +8
+enum ibv_nvmf_offload_type offload_type;        /* Which NVMe-oF
operations can be offloaded, 0 = no NVMf offload support */
+uint32_t        max_backend_ctrls_total;    /* Max NVMe backend
controllers total for the device */
+uint32_t        max_srq_backend_ctrls;      /* Max NVMe backend
controllers per SRQ */
+uint32_t        max_srq_namespaces;         /* Max namespaces per SRQ */
+uint32_t        min_staging_buf_size;       /* Min size of the
staging buffer */
+uint32_t        max_io_sz;                  /* Max IO transfer per
NVMf transaction */
+uint16_t        max_nvme_queue_depth;       /* Max queue depth for
NVMe backend controller queues */
+uint16_t        min_nvme_queue_depth;       /* Min queue depth for
NVMe backend controller queues */
+uint32_t        max_ioccsz;                 /* Max IO command capsule
size, 16B units (NVMe-oF spec) */
+uint32_t        min_ioccsz;                 /* Min IO command capsule
size, 16B units (NVMe-oF spec) */
+uint16_t        max_icdoff;                 /* Max in-capsule data
offset, 16B units (NVMe-oF spec) */
+.in -8
+};
 .fi

 Extended device capability flags (device_cap_flags_ex):
diff --git a/libibverbs/man/ibv_srq_create_nvme_ctrl.3
b/libibverbs/man/ibv_srq_create_nvme_ctrl.3
new file mode 100644
index 0000000..07eb60d
--- /dev/null
+++ b/libibverbs/man/ibv_srq_create_nvme_ctrl.3
@@ -0,0 +1,89 @@
+.\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See
COPYING.md
+.\"
+.TH IBV_SRQ_CREATE_NVME_CTRL 3 2006-10-31 libibverbs "Libibverbs
Programmer's Manual"
+.SH "NAME"
+ibv_srq_create_nvme_ctrl \- create a backend NVMe controller to be
used in SRQ with NVMe-oF offload enabled
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/verbs.h>
+.sp
+.BI "struct ibv_nvme_ctrl *ibv_srq_create_nvme_ctrl(struct ibv_srq " "*srq" ,
+.BI "                         struct nvme_ctrl_attrs " "*nvme_attrs" );
+.sp
+.BI "int ibv_srq_remove_nvme_ctrl(struct ibv_srq " "*srq" ,
+.BI "                         struct ibv_nvme_ctrl " "*nvme_ctrl" );
+.fi
+.SH "DESCRIPTION"
+.B ibv_srq_create_nvme_ctrl()
+adds a new NVMe backend device to a given
+.I srq
+which is configured with the NVMe-oF target offloading feature.
+This backend NVMe device can then be used to create mappings between
front-facing namespace IDs and namespaces on this NVMe device.
+The structure
+.I nvme_ctl_attrs
+holds all required properties to allow the NVMe-oF target offload
feature submit works to an NVMe device. This includes details on where
to find the NVMe submit queue, completion queue and their respected
doorbells:
+.PP
+.nf
+struct nvme_ctrl_attrs {
+.in +8
+struct ibv_mr_sg      sq_buf;        /* The NVMe submit queue */
+struct ibv_mr_sg      cq_buf;        /* The NVMe completion queue */
+
+struct ibv_mr_sg      sqdb;          /* The NVMe submit queue
doorbell, must be 4 bytes*/
+struct ibv_mr_sg      cqdb;          /* The NVMe completion queue
doorbell, must be 4 bytes*/
+
+uint16_t              sqdb_ini;      /* NVMe SQ doorbell initial value */
+uint16_t              cqdb_ini;      /* NVMe CQ doorbell initial value */
+
+uint16_t              cmd_timeout_ms; /* Command timeout */
+
+uint32_t              comp_mask;     /* For future extention */
+.in -8
+};
+.fi
+
+.PP
+SQ and CQ are supplied each by {mr, addr, len}, and their doorbells
are supplied each by {mr, addr} (since an NVMe doorbell length is
fixed 32 bit).
+This means the memory holding the SQ, CQ and doorbells need to be
registered with Memory Region(s).
+
+.PP
+If the operation is successful an NVMe controller object is created
and returned. This controller can only be used to create namespace
mappings on this SRQ. In the case where several SRQs need to share the
same physical NVMe device as a backend, several NVMe backend
controller objects need to be created from the same physical NVMe
device, each with a different set of SQ, CQ and doorbells.
+
+.PP
+.I cmd_timeout_ms
+is the time (in milliseconds) that the device will wait for a command
submitted to this NVMe backend to complete. After that timeout, the
device will send an nvme_ctrl async event IBV_EVENT_NVME_TIMEOUT. When
happens, software should consider this NVMe backend controller to be
dead, and remove it (and maps associated with it) from the SRQ.
+
+.B ibv_srq_remove_nvme_ctrl()
+removes the NVMe backend controller
+.I nvme_ctrl
+from the given
+.I srq
+which is configured with the NVMe-oF target offloading feature. All
namespace mappings that are using this
+.I nvme_ctrl
+must be deleted first.
+
+.SH "RETURN VALUE"
+.B ibv_srq_create_nvme_ctrl()
+On success, returns a pointer to struct ibv_nvme_ctrl. On error,
returns NULL and sets errno accordingly.
+.B ibv_srq_remove_nvme_ctrl()
+Returns 0 on success or a negative errno value on error.
+
+.PP
+Failure reasons may be:
+.IP EINVAL
+The length or alignment of the supplied SQ/CQ/doorbell is illegal.
+.IP ENOENT
+Trying to remove a non existing nvme_ctrl.
+.IP EBUSY
+Trying to remove an nvme_ctrl that is being used by namespace mappings.
+
+.SH "NOTES"
+
+.SH "SEE ALSO"
+.BR ibv_create_srq (3), ibv_srq_add_nvmf_nsid_map (3), ibv_get_async_event (3)
+
+.SH "AUTHORS"
+.TP
+Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 0785c77..3d32cf4 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -288,6 +288,27 @@ struct ibv_cq_moderation_caps {
        uint16_t max_cq_period; /* in micro seconds */
 };

+enum ibv_nvmf_offload_type {
+       IBV_NVMF_WRITE_OFFLOAD          = 1 << 0,
+       IBV_NVMF_READ_OFFLOAD           = 1 << 1,
+       IBV_NVMF_READ_WRITE_OFFLOAD             = 1 << 2,
+       IBV_NVMF_READ_WRITE_FLUSH_OFFLOAD       = 1 << 3,
+};
+
+struct ibv_nvmf_caps {
+       enum ibv_nvmf_offload_type offload_type; /* if 0, NVMf offload
not supported */
+       uint32_t        max_backend_ctrls_total;
+       uint32_t        max_srq_backend_ctrls;
+       uint32_t        max_srq_namespaces;
+       uint32_t        min_staging_buf_size;
+       uint32_t        max_io_sz;
+       uint16_t        max_nvme_queue_depth;
+       uint16_t        min_nvme_queue_depth;
+       uint32_t        max_ioccsz;
+       uint32_t        min_ioccsz;
+       uint16_t        max_icdoff;
+};
+
 struct ibv_device_attr_ex {
        struct ibv_device_attr  orig_attr;
        uint32_t                comp_mask;
@@ -302,6 +323,7 @@ struct ibv_device_attr_ex {
        uint32_t                raw_packet_caps; /* Use ibv_raw_packet_caps */
        struct ibv_tm_caps      tm_caps;
        struct ibv_cq_moderation_caps  cq_mod_caps;
+       struct ibv_nvmf_caps    nvmf_caps;
 };

 enum ibv_mtu {
@@ -398,6 +420,8 @@ enum ibv_event_type {
        IBV_EVENT_CLIENT_REREGISTER,
        IBV_EVENT_GID_CHANGE,
        IBV_EVENT_WQ_FATAL,
+       IBV_EVENT_NVME_PCI_ERR,
+       IBV_EVENT_NVME_TIMEOUT
 };

 struct ibv_async_event {
@@ -407,6 +431,7 @@ struct ibv_async_event {
                struct ibv_srq *srq;
                struct ibv_wq  *wq;
                int             port_num;
+               struct ibv_nvme_ctrl *nvme_ctrl;
        } element;
        enum ibv_event_type     event_type;
 };
@@ -586,6 +611,15 @@ struct ibv_mr {
        uint32_t                rkey;
 };

+struct ibv_mr_sg {
+       struct ibv_mr   *mr;
+       union {
+               void            *addr;
+               uint64_t        offset;
+       };
+       uint64_t        len;
+};
+
 enum ibv_mw_type {
        IBV_MW_TYPE_1                   = 1,
        IBV_MW_TYPE_2                   = 2
@@ -694,6 +728,7 @@ enum ibv_srq_type {
        IBV_SRQT_BASIC,
        IBV_SRQT_XRC,
        IBV_SRQT_TM,
+       IBV_SRQT_NVMF,
 };

 enum ibv_srq_init_attr_mask {
@@ -702,7 +737,8 @@ enum ibv_srq_init_attr_mask {
        IBV_SRQ_INIT_ATTR_XRCD          = 1 << 2,
        IBV_SRQ_INIT_ATTR_CQ            = 1 << 3,
        IBV_SRQ_INIT_ATTR_TM            = 1 << 4,
-       IBV_SRQ_INIT_ATTR_RESERVED      = 1 << 5,
+       IBV_SRQ_INIT_ATTR_NVMF          = 1 << 5,
+       IBV_SRQ_INIT_ATTR_RESERVED      = 1 << 6,
 };

 struct ibv_tm_cap {
@@ -710,6 +746,25 @@ struct ibv_tm_cap {
        uint32_t                max_ops;
 };

+enum ibv_nvmf_offload_ops {
+       IBV_NVMF_OPS_WRITE              = 1 << 0,
+       IBV_NVMF_OPS_READ               = 1 << 1,
+       IBV_NVMF_OPS_FLUSH              = 1 << 2,
+       IBV_NVMF_OPS_READ_WRITE         = IBV_NVMF_OPS_READ| IBV_NVMF_OPS_WRITE,
+       IBV_NVMF_OPS_READ_WRITE_FLUSH   = IBV_NVMF_OPS_READ_WRITE |
IBV_NVMF_OPS_FLUSH,
+};
+
+struct ibv_nvmf_attrs {
+       enum ibv_nvmf_offload_ops offload_ops;
+       uint32_t                max_namespaces;
+       uint8_t                 nvme_log_page_sz;
+       uint32_t                ioccsz;
+       uint16_t                icdoff;
+       uint32_t                max_io_sz;
+       uint16_t                nvme_queue_depth;
+       struct ibv_mr_sg        staging_buf;
+};
+
 struct ibv_srq_init_attr_ex {
        void                   *srq_context;
        struct ibv_srq_attr     attr;
@@ -720,6 +775,7 @@ struct ibv_srq_init_attr_ex {
        struct ibv_xrcd        *xrcd;
        struct ibv_cq          *cq;
        struct ibv_tm_cap       tm_cap;
+       struct ibv_nvmf_attrs   nvmf_attr;
 };

 enum ibv_wq_type {
@@ -2182,6 +2238,46 @@ static inline int ibv_post_srq_ops(struct ibv_srq *srq,
        return vctx->post_srq_ops(srq, op, bad_op);
 }

+struct ibv_nvme_ctrl;
+
+struct nvme_ctrl_attrs {
+       struct ibv_mr_sg        sq_buf;
+       struct ibv_mr_sg        cq_buf;
+       struct ibv_mr_sg        sqdb;
+       struct ibv_mr_sg        cqdb;
+       uint16_t                sqdb_ini;
+       uint16_t                cqdb_ini;
+       uint16_t                cmd_timeout_ms;
+       uint32_t                comp_mask;
+};
+
+/**
+ * ibv_srq_create_nvme_ctrl - Return a new NVMe controller object for use
+ * with NVMe-oF offload
+ */
+struct ibv_nvme_ctrl *ibv_srq_create_nvme_ctrl(struct ibv_srq *srq,
+                                              struct nvme_ctrl_attrs
*nvme_attrs);
+
+/**
+ *ibv_srq_remove_nvme_ctrl - Remove an NVMe controller object
+ */
+int ibv_srq_remove_nvme_ctrl(struct ibv_srq *srq,
+                            struct ibv_nvme_ctrl *nvme_ctrl);
+
+/**
+ * ibv_map_nvmf_nsid - Map namespace of NVMe controller to frontend namesapce
+ */
+int ibv_map_nvmf_nsid(struct ibv_nvme_ctrl *nvme_ctrl,
+                     uint32_t fe_nsid,
+                     uint16_t lba_data_size,
+                     uint32_t nvme_nsid);
+
+/**
+ * ibv_unmap_nvmf_nsid - Unmap a namespace of NVMe controller
+ */
+int ibv_unmap_nvmf_nsid(struct ibv_nvme_ctrl *nvme_ctrl,
+                       uint32_t fe_nsid);
+
 /**
  * ibv_create_qp - Create a queue pair.
  */
@@ -2295,6 +2391,15 @@ int ibv_query_qp(struct ibv_qp *qp, struct
ibv_qp_attr *attr,
  */
 int ibv_destroy_qp(struct ibv_qp *qp);

+enum {
+       IBV_QP_NVMF_ATTR_FLAG_ENABLE    = 1 << 0,
+};
+
+/**
+ * ibv_qp_set_nvmf - set NVMe-oF offload related flags of a QP
+ */
+int ibv_qp_set_nvmf(struct ibv_qp *qp, unsigned int flags);
+
 /*
  * ibv_create_wq - Creates a WQ associated with the specified protection
  * domain.
--
2.7.4
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
