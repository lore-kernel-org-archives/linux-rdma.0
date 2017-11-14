From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] librdmacm: Add support for extended join multicast API V2
Date: Tue, 14 Nov 2017 12:57:21 -0600
Message-ID: <20171114185739.838757957@linux.com>
References: <20171114185720.609975150@linux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=0001-librdmacm-Add-support-for-extended-join-multicast-AP.patch
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/2] librdmacm: Add support for extended join multicast API V2

V1->V2
 - Fix comments to correctly refer to sendonly joins
 - Fix API spec.

Add support for specifying MC join flags.
The following multicast join flags will now be supported by
librdmacm (as already defined in the join flags in
rdma_user_cm.h through the UAPI of the kernel).

-Full Member:
 The initiator creates the Multicast group(MCG) if it wasn't
 previously created, can send Multicast messages to the group
 and receive messages from the MCG.

-Send Only Full Member:
 The initiator creates the Multicast group(MCG) if it wasn't
 previously created, can send Multicast messages but doesn't
 receive any messages from the MCG (send-only).

Tested-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Reviewed by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
---

diff --git a/debian/librdmacm-dev.install b/debian/librdmacm-dev.install
index bfd8ad8..53dcb4b 100644
--- a/debian/librdmacm-dev.install
+++ b/debian/librdmacm-dev.install
@@ -33,6 +33,7 @@ usr/share/man/man3/rdma_get_send_comp.3
 usr/share/man/man3/rdma_get_src_port.3
 usr/share/man/man3/rdma_getaddrinfo.3
 usr/share/man/man3/rdma_join_multicast.3
+usr/share/man/man3/rdma_join_multicast_ex.3
 usr/share/man/man3/rdma_leave_multicast.3
 usr/share/man/man3/rdma_listen.3
 usr/share/man/man3/rdma_migrate_id.3
diff --git a/debian/librdmacm1.symbols b/debian/librdmacm1.symbols
index 7cec5c6..a7d8085 100644
--- a/debian/librdmacm1.symbols
+++ b/debian/librdmacm1.symbols
@@ -31,6 +31,7 @@ librdmacm.so.1 librdmacm1 #MINVER#
  rdma_get_src_port@RDMACM_1.0 1.0.19
  rdma_getaddrinfo@RDMACM_1.0 1.0.15
  rdma_join_multicast@RDMACM_1.0 1.0.15
+ rdma_join_multicast_ex@RDMACM_1.1 1.0.15
  rdma_leave_multicast@RDMACM_1.0 1.0.15
  rdma_listen@RDMACM_1.0 1.0.15
  rdma_migrate_id@RDMACM_1.0 1.0.15
diff --git a/librdmacm/cma.c b/librdmacm/cma.c
index 25ebaae..31cf11b 100644
--- a/librdmacm/cma.c
+++ b/librdmacm/cma.c
@@ -114,6 +114,7 @@ struct cma_multicast {
 	uint32_t	handle;
 	union ibv_gid	mgid;
 	uint16_t	mlid;
+	uint16_t	join_flags;
 	struct sockaddr_storage addr;
 };
 
@@ -1715,7 +1716,8 @@ int rdma_disconnect(struct rdma_cm_id *id)
 }
 
 static int rdma_join_multicast2(struct rdma_cm_id *id, struct sockaddr *addr,
-				socklen_t addrlen, void *context)
+				socklen_t addrlen, uint16_t join_flags,
+				void *context)
 {
 	struct ucma_abi_create_id_resp resp;
 	struct cma_id_private *id_priv;
@@ -1729,6 +1731,7 @@ static int rdma_join_multicast2(struct rdma_cm_id *id, struct sockaddr *addr,
 
 	mc->context = context;
 	mc->id_priv = id_priv;
+	mc->join_flags = join_flags;
 	memcpy(&mc->addr, addr, addrlen);
 	if (pthread_cond_init(&mc->cond, NULL)) {
 		ret = -1;
@@ -1748,7 +1751,7 @@ static int rdma_join_multicast2(struct rdma_cm_id *id, struct sockaddr *addr,
 		memcpy(&cmd.addr, addr, addrlen);
 		cmd.addr_size = addrlen;
 		cmd.uid = (uintptr_t) mc;
-		cmd.reserved = 0;
+		cmd.join_flags = join_flags;
 
 		ret = write(id->channel->fd, &cmd, sizeof cmd);
 		if (ret != sizeof cmd) {
@@ -1786,6 +1789,30 @@ err1:
 	return ret;
 }
 
+int rdma_join_multicast_ex(struct rdma_cm_id *id,
+			   struct rdma_cm_join_mc_attr_ex *mc_join_attr,
+			   void *context)
+{
+	int addrlen;
+
+	if (mc_join_attr->comp_mask >= RDMA_CM_JOIN_MC_ATTR_RESERVED)
+		return ERR(ENOTSUP);
+
+	if (!(mc_join_attr->comp_mask & RDMA_CM_JOIN_MC_ATTR_ADDRESS))
+		return ERR(EINVAL);
+
+	addrlen = ucma_addrlen(mc_join_attr->addr);
+	if (!addrlen)
+		return ERR(EINVAL);
+
+	if (!(mc_join_attr->comp_mask & RDMA_CM_JOIN_MC_ATTR_JOIN_FLAGS) ||
+	    (mc_join_attr->join_flags >= RDMA_MC_JOIN_FLAG_RESERVED))
+		return ERR(EINVAL);
+
+	return rdma_join_multicast2(id, mc_join_attr->addr, addrlen,
+				    mc_join_attr->join_flags, context);
+}
+
 int rdma_join_multicast(struct rdma_cm_id *id, struct sockaddr *addr,
 			void *context)
 {
@@ -1795,7 +1822,9 @@ int rdma_join_multicast(struct rdma_cm_id *id, struct sockaddr *addr,
 	if (!addrlen)
 		return ERR(EINVAL);
 
-	return rdma_join_multicast2(id, addr, addrlen, context);
+	return rdma_join_multicast2(id, addr, addrlen,
+				    RDMA_MC_JOIN_FLAG_FULLMEMBER,
+				    context);
 }
 
 int rdma_leave_multicast(struct rdma_cm_id *id, struct sockaddr *addr)
@@ -1823,7 +1852,7 @@ int rdma_leave_multicast(struct rdma_cm_id *id, struct sockaddr *addr)
 	if (!mc)
 		return ERR(EADDRNOTAVAIL);
 
-	if (id->qp)
+	if (id->qp && (mc->join_flags != RDMA_MC_JOIN_FLAG_SENDONLY_FULLMEMBER))
 		ibv_detach_mcast(id->qp, &mc->mgid, mc->mlid);
 	
 	CMA_INIT_CMD_RESP(&cmd, sizeof cmd, LEAVE_MCAST, &resp, sizeof resp);
@@ -2011,6 +2040,10 @@ static int ucma_process_join(struct cma_event *evt)
 	if (!evt->id_priv->id.qp)
 		return 0;
 
+	/* Don't attach QP to multicast if joined as send only full member */
+	if (evt->mc->join_flags == RDMA_MC_JOIN_FLAG_SENDONLY_FULLMEMBER)
+		return 0;
+
 	return rdma_seterrno(ibv_attach_mcast(evt->id_priv->id.qp,
 					      &evt->mc->mgid, evt->mc->mlid));
 }
diff --git a/librdmacm/librdmacm.map b/librdmacm/librdmacm.map
index 65c0492..5813d74 100644
--- a/librdmacm/librdmacm.map
+++ b/librdmacm/librdmacm.map
@@ -71,3 +71,8 @@ RDMACM_1.0 {
 		rdma_create_qp_ex;
 	local: *;
 };
+
+RDMACM_1.1 {
+	global:
+		rdma_join_multicast_ex;
+} RDMACM_1.0;
diff --git a/librdmacm/man/CMakeLists.txt b/librdmacm/man/CMakeLists.txt
index d4d54c5..d016c92 100644
--- a/librdmacm/man/CMakeLists.txt
+++ b/librdmacm/man/CMakeLists.txt
@@ -33,6 +33,7 @@ rdma_man_pages(
   rdma_get_src_port.3
   rdma_getaddrinfo.3
   rdma_join_multicast.3
+  rdma_join_multicast_ex.3
   rdma_leave_multicast.3
   rdma_listen.3
   rdma_migrate_id.3
diff --git a/librdmacm/man/rdma_join_multicast_ex.3 b/librdmacm/man/rdma_join_multicast_ex.3
new file mode 100644
index 0000000..b095376
--- /dev/null
+++ b/librdmacm/man/rdma_join_multicast_ex.3
@@ -0,0 +1,66 @@
+.TH "RDMA_JOIN_MULTICAST_EX" 3 "2016-06-21" "librdmacm" "Librdmacm Programmer's Manual" librdmacm
+.SH NAME
+rdma_join_multicast_ex \- Joins a multicast group with extended options.
+.SH SYNOPSIS
+.B "#include <rdma/rdma_cma.h>"
+.P
+.B "int" rdma_join_multicast_ex
+.BI "(struct rdma_cm_id *" id ","
+.BI "struct rdma_cm_join_mc_attr_ex *" mc_join_attr ","
+.BI "void *" context ");"
+.SH ARGUMENTS
+.IP "id" 20
+Communication identifier associated with the request.
+.IP "mc_join_attr" 20
+Is an rdma_cm_join_mc_attr_ex struct, as defined in <rdma/rdma_cma.h>.
+.IP "context" 20
+User-defined context associated with the join request.
+.SH "DESCRIPTION"
+Joins a multicast group (MCG) with extended options.
+Currently supporting MC join with a specified join flag.
+.P
+.nf
+struct rdma_cm_join_mc_attr_ex {
+.in +8
+uint32_t                comp_mask;      /* Bitwise OR between "rdma_cm_join_mc_attr_mask" enum */
+uint32_t                join_flags;     /* Use a single flag from "rdma_cm_mc_join_flags" enum */
+struct sockaddr         *addr;          /* Multicast address identifying the group to join */
+.in -8
+};
+.fi
+.P
+The supported join flags are:
+.P
+.B RDMA_MC_JOIN_FLAG_FULLMEMBER
+- Create multicast group, Send multicast messages to MCG, Receive multicast messages from MCG.
+.P
+.B RDMA_MC_JOIN_FLAG_SENDONLY_FULLMEMBER
+- Create multicast group, Send multicast messages to MCG, Don't receive multicast messages from MCG (send-only).
+.P
+Initiating a MC join as "Send Only Full Member" on infiniband requires SM support, without such support joining will fail.
+.P
+Initiating a MC join as "Send Only Full Member" on RoCEv2/ETH will not send an IGMP message unlike a Full Member MC join.
+When "Send Only Full Member" is used QP will not be attached to the MCG.
+.P
+.SH "RETURN VALUE"
+Returns 0 on success, or -1 on error.  If an error occurs, errno will be
+set to indicate the failure reason.
+.SH "NOTES"
+Before joining a multicast group, the rdma_cm_id must be bound to
+an RDMA device by calling rdma_bind_addr or rdma_resolve_addr.  Use of
+rdma_resolve_addr requires the local routing tables to resolve the
+multicast address to an RDMA device, unless a specific source address
+is provided.  The user must call rdma_leave_multicast to leave the
+multicast group and release any multicast resources.  After the join
+operation completes, if a QP is associated with the rdma_cm_id,
+it is automatically attached to the multicast group when the multicast
+event is retrieved by the user.  Otherwise, the user is responsible
+for calling ibv_attach_mcast to bind the QP to the multicast group.
+The join context is returned to the user through the private_data
+field in the rdma_cm_event.
+.SH "SEE ALSO"
+rdma_join_multicast(3), rdma_leave_multicast(3), rdma_bind_addr(3), rdma_resolve_addr(3), rdma_create_qp(3),
+rdma_get_cm_event(3)
+.SH "AUTHORS"
+.TP
+Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/librdmacm/rdma_cma.h b/librdmacm/rdma_cma.h
index e0fc58e..2096a81 100644
--- a/librdmacm/rdma_cma.h
+++ b/librdmacm/rdma_cma.h
@@ -197,6 +197,29 @@ struct rdma_addrinfo {
 	struct rdma_addrinfo	*ai_next;
 };
 
+/* Multicast join compatibility mask attributes */
+enum rdma_cm_join_mc_attr_mask {
+	RDMA_CM_JOIN_MC_ATTR_ADDRESS	= 1 << 0,
+	RDMA_CM_JOIN_MC_ATTR_JOIN_FLAGS	= 1 << 1,
+	RDMA_CM_JOIN_MC_ATTR_RESERVED	= 1 << 2,
+};
+
+/* Multicast join flags */
+enum rdma_cm_mc_join_flags {
+	RDMA_MC_JOIN_FLAG_FULLMEMBER,
+	RDMA_MC_JOIN_FLAG_SENDONLY_FULLMEMBER,
+	RDMA_MC_JOIN_FLAG_RESERVED,
+};
+
+struct rdma_cm_join_mc_attr_ex {
+	/* Bitwise OR between "rdma_cm_join_mc_attr_mask" enum */
+	uint32_t comp_mask;
+	/* Use a flag from "rdma_cm_mc_join_flags" enum */
+	uint32_t join_flags;
+	/* Multicast address identifying the group to join */
+	struct sockaddr *addr;
+};
+
 /**
  * rdma_create_event_channel - Open a channel used to report communication events.
  * Description:
@@ -555,6 +578,30 @@ int rdma_join_multicast(struct rdma_cm_id *id, struct sockaddr *addr,
 int rdma_leave_multicast(struct rdma_cm_id *id, struct sockaddr *addr);
 
 /**
+ * rdma_multicast_ex - Joins a multicast group with options.
+ * @id: Communication identifier associated with the request.
+ * @mc_join_attr: Extensive struct containing multicast join parameters.
+ * @context: User-defined context associated with the join request.
+ * Description:
+ *  Joins a multicast group with options. Currently supporting MC join flags.
+ *  The QP will be attached based on the given join flag.
+ *  Join message will be sent according to the join flag.
+ * Notes:
+ *  Before joining a multicast group, the rdma_cm_id must be bound to
+ *  an RDMA device by calling rdma_bind_addr or rdma_resolve_addr.  Use of
+ *  rdma_resolve_addr requires the local routing tables to resolve the
+ *  multicast address to an RDMA device.  The user must call
+ *  rdma_leave_multicast to leave the multicast group and release any
+ *  multicast resources.  The context is returned to the user through
+ *  the private_data field in the rdma_cm_event.
+ * See also:
+ *  rdma_leave_multicast, rdma_bind_addr, rdma_resolve_addr, rdma_create_qp
+ */
+int rdma_join_multicast_ex(struct rdma_cm_id *id,
+			   struct rdma_cm_join_mc_attr_ex *mc_join_attr,
+			   void *context);
+
+/**
  * rdma_get_cm_event - Retrieves the next pending communication event.
  * @channel: Event channel to check for events.
  * @event: Allocated information about the next communication event.
diff --git a/librdmacm/rdma_cma_abi.h b/librdmacm/rdma_cma_abi.h
index 29d6f0d..deb37a4 100644
--- a/librdmacm/rdma_cma_abi.h
+++ b/librdmacm/rdma_cma_abi.h
@@ -302,7 +302,7 @@ struct ucma_abi_join_mcast {
 	__u64 uid;
 	__u32 id;
 	__u16 addr_size;
-	__u16 reserved;
+	__u16 join_flags;
 	struct sockaddr_storage addr;
 };
 
-- 
1.7.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
