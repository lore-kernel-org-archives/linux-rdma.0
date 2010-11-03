From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/13] IB-mgmt: Add API to register for MAD snooping
Date: Wed, 3 Nov 2010 16:11:56 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B837B375@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add a new call to libibumad that allows a user to register
for snooping MADs.  Snooped MADs are returned to the user
through the umad_recv routine.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 libibumad/Makefile.am               |    1 +
 libibumad/include/infiniband/umad.h |   10 ++++++
 libibumad/man/umad_register_snoop.3 |   52 ++++++++++++++++++++++++++++++++++
 libibumad/src/libibumad.map         |    1 +
 libibumad/src/umad.c                |   54 ++++++++++++++++++++++++++++++++++-
 5 files changed, 117 insertions(+), 1 deletions(-)
 mode change 100644 => 100755 libibumad/include/infiniband/umad.h
 create mode 100755 libibumad/man/umad_register_snoop.3
 mode change 100644 => 100755 libibumad/src/umad.c

diff --git a/libibumad/Makefile.am b/libibumad/Makefile.am
index 28bf69c..6dc2955 100644
--- a/libibumad/Makefile.am
+++ b/libibumad/Makefile.am
@@ -14,6 +14,7 @@ man_MANS = man/umad_debug.3 man/umad_get_ca.3 \
 	   man/umad_set_addr_net.3 man/umad_set_addr.3 man/umad_set_pkey.3 \
 	   man/umad_get_pkey.3 \
 	   man/umad_register.3 man/umad_register_oui.3 man/umad_unregister.3 \
+	   man/umad_register_snoop.3 \
 	   man/umad_send.3 man/umad_recv.3 man/umad_poll.3 \
 	   man/umad_get_issm_path.3
 
diff --git a/libibumad/include/infiniband/umad.h b/libibumad/include/infiniband/umad.h
old mode 100644
new mode 100755
index 23abf0d..650654e
--- a/libibumad/include/infiniband/umad.h
+++ b/libibumad/include/infiniband/umad.h
@@ -149,6 +149,14 @@ typedef struct umad_ca {
 	umad_port_t *ports[UMAD_CA_MAX_PORTS];
 } umad_ca_t;
 
+typedef struct umad_filter {
+	uint8_t  mgmt_class;
+	uint8_t  mgmt_version;
+	uint16_t attr_id;
+	uint8_t  errors;
+	uint8_t  oui[3];
+} umad_filter_t;
+
 int umad_init(void);
 int umad_done(void);
 
@@ -187,6 +195,8 @@ int umad_register(int portid, int mgmt_class, int mgmt_version,
 		  uint8_t rmpp_version, long method_mask[16 / sizeof(long)]);
 int umad_register_oui(int portid, int mgmt_class, uint8_t rmpp_version,
 		      uint8_t oui[3], long method_mask[16 / sizeof(long)]);
+int umad_register_snoop(int portid, umad_filter_t *filter,
+			size_t filter_length);
 int umad_unregister(int portid, int agentid);
 
 int umad_debug(int level);
diff --git a/libibumad/man/umad_register_snoop.3 b/libibumad/man/umad_register_snoop.3
new file mode 100755
index 0000000..00b361d
--- /dev/null
+++ b/libibumad/man/umad_register_snoop.3
@@ -0,0 +1,52 @@
+.\" -*- nroff -*-
+.\"
+.TH UMAD_REGISTER_SNOOP 3  "October 15, 2010" "OpenIB" "OpenIB Programmer\'s Manual"
+.SH "NAME"
+umad_register_snoop \- register to capture sent and received MADs
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/umad.h>
+.sp
+.BI "int umad_register_snoop(int " "portid" ", umad_filter_t " "filter" ", size_t " "filter_length");
+.fi
+.SH "DESCRIPTION"
+.B umad_register_snoop()
+Registers to snoop MADs that meet the specified filter.
+MAD snooping occurs after RMPP segmentation has occurred on sent MADs,
+and before RMPP reassembly occurs on received MADs.  Snooped MADs
+are returned to the user through the umad_recv interface.
+.SH "FILTER"
+Users specify a filter through the umad_filter_t routine.
+Only MADs which pass all indicated filtering restrictions are reported
+to the user.  The definition for the umad_filter_t fields are:
+.IP mgmt_class
+Only MADs for the specified management class are reported to the user.
+If mgmt_class is set to 0, then MADs for all management classes
+sent or received on the GSI interface (QP1) are reported.
+.IP mgmt_version
+Restricts reported MADs to the specified management class version.
+A user may set mgmt_version to 0 to report MADs of all versions.
+This field is ignored if mgmt_class is set to 0. 
+.IP attr_id
+Restricts MADs to those containing the specified attribute identifier.
+A user may set attr_id to 0 to report MADs referencing any attribute ID.
+This field is ignored if mgmt_class is set to 0. 
+.IP errors
+If non-zero, only reports sent MADs that complete in error or MADs
+containing a non-zero status value.  Sent MADs which complete as successful
+or canceled are not reported.
+.IP oui
+If non-zero, only reports MADs that contain the specified OUI.
+This field is ignored if the mgmt_class is not in the vendor
+class 2 range.
+.SH "RETURN VALUE"
+.B umad_register_snoop()
+returns non-negative agent id number on success, and a negative value on error as follows:
+ -EINVAL invalid port handle, filter, or filter_length
+ -EPERM  registration failed
+.SH "SEE ALSO"
+.BR umad_register(3),
+.BR umad_unregister(3)
+.SH "AUTHOR"
+.TP
+Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
diff --git a/libibumad/src/libibumad.map b/libibumad/src/libibumad.map
index 0154b7f..b4b0b4b 100644
--- a/libibumad/src/libibumad.map
+++ b/libibumad/src/libibumad.map
@@ -30,5 +30,6 @@ IBUMAD_1.0 {
 		umad_debug;
 		umad_addr_dump;
 		umad_dump;
+		umad_register_snoop;
 	local: *;
 };
diff --git a/libibumad/src/umad.c b/libibumad/src/umad.c
old mode 100644
new mode 100755
index 45a9423..28e7bf3
--- a/libibumad/src/umad.c
+++ b/libibumad/src/umad.c
@@ -66,9 +66,24 @@
 #  define VALGRIND_MAKE_MEM_DEFINED(addr,len)
 #endif
 
+struct ib_user_mad_snoop_filter {
+	uint16_t attr_id;
+	uint8_t	 errors;
+	uint8_t	 reserved[13];
+};
+
+enum {
+	UMAD_SNOOP_QP  = 0x80,
+	UMAD_SNOOP_QP0 = 0x80,
+	UMAD_SNOOP_QP1 = 0x81
+};
+
 typedef struct ib_user_mad_reg_req {
 	uint32_t id;
-	uint32_t method_mask[4];
+	union {
+		uint32_t method_mask[4];
+		struct ib_user_mad_snoop_filter filter;
+	};
 	uint8_t qpn;
 	uint8_t mgmt_class;
 	uint8_t mgmt_class_version;
@@ -878,6 +893,43 @@ int umad_get_fd(int fd)
 	return fd;
 }
 
+int umad_register_snoop(int fd, umad_filter_t *filter,
+			size_t filter_length)
+{
+	struct ib_user_mad_reg_req req;
+
+	if (filter_length != sizeof(struct umad_filter))
+		return -EINVAL;
+
+	TRACE("fd %d mgmt_class %u mgmt_version %d oui 0x%x%x%x attr_id %d errors %d",
+	      fd, filter->mgmt_class, filter->mgmt_version,
+	      (int) filter->oui[0], (int) filter->oui[1], (int) filter->oui[2],
+	      filter->attr_id, filter->errors);
+
+	memset(&req, 0, sizeof req);
+	req.qpn = (filter->mgmt_class == 0x1 || filter->mgmt_class == 0x81) ?
+		  UMAD_SNOOP_QP0 : UMAD_SNOOP_QP1;
+	req.mgmt_class = filter->mgmt_class;
+	req.mgmt_class_version = filter->mgmt_version;
+	memcpy(req.oui, filter->oui, sizeof req.oui);
+	req.filter.attr_id = filter->attr_id;
+	req.filter.errors = filter->errors;
+
+	VALGRIND_MAKE_MEM_DEFINED(&req, sizeof req);
+
+	if (!ioctl(fd, IB_USER_MAD_REGISTER_AGENT, (void *)&req)) {
+		DEBUG("fd %d registered to use agent %d qp %d class 0x%x oui 0x%x%x%x",
+		      fd, req.id, req.qpn & ~UMAD_SNOOP_QP, req.mgmt_class,
+		      (int) filter->oui[0], (int) filter->oui[1], (int) filter->oui[2]);
+		return req.id;	/* return agentid */
+	}
+
+	DEBUG("fd %d registering qp %d class 0x%x oui 0x%x%x%x failed: %m",
+	      fd, req.qpn & ~UMAD_SNOOP_QP, req.mgmt_class,
+	      (int) filter->oui[0], (int) filter->oui[1], (int) filter->oui[2]);
+	return -EPERM;
+}
+
 int umad_register_oui(int fd, int mgmt_class, uint8_t rmpp_version,
 		      uint8_t oui[3], long method_mask[])
 {


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
