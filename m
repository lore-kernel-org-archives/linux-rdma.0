From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 13/13] IB-mgmt: Define data type to indicate values are in
 big-endian
Date: Wed, 3 Nov 2010 16:11:44 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B837B380@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The ib management interfaces require that the user specify
certain values in network-byte order.  To clarify which values
should be in big endian format, introduce a new data type
at the libibumad level.

Byte arrays which are in big endian format are simply marked
with a comment.

The new data types do not contain the 'umad' prefix in order to
allow the definition to move to another library (such as libibverbs)
and be used by other packages. 

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 libibumad/include/infiniband/umad.h       |   21 +++++++++++++--------
 libibumad/include/infiniband/umad_sa.h    |   13 ++++++++-----
 libibumad/include/infiniband/umad_sm.h    |   16 ++++++++--------
 libibumad/include/infiniband/umad_types.h |   23 ++++++++++++-----------
 4 files changed, 41 insertions(+), 32 deletions(-)

diff --git a/libibumad/include/infiniband/umad.h b/libibumad/include/infiniband/umad.h
index a798cf8..99f5bc9 100755
--- a/libibumad/include/infiniband/umad.h
+++ b/libibumad/include/infiniband/umad.h
@@ -47,21 +47,26 @@
 #endif				/* __cplusplus */
 
 BEGIN_C_DECLS
+
+typedef uint16_t be16_t;
+typedef uint32_t be32_t;
+typedef uint64_t be64_t;
+
 #define UMAD_MAX_DEVICES 32
 #define UMAD_ANY_PORT	0
 typedef struct ib_mad_addr {
-	uint32_t qpn;
-	uint32_t qkey;
-	uint16_t lid;
+	be32_t qpn;
+	be32_t qkey;
+	be16_t lid;
 	uint8_t sl;
 	uint8_t path_bits;
 	uint8_t grh_present;
 	uint8_t gid_index;
 	uint8_t hop_limit;
 	uint8_t traffic_class;
-	uint8_t gid[16];
-	uint32_t flow_label;
-	uint16_t pkey_index;
+	uint8_t gid[16]; /* network-byte order */
+	be32_t flow_label;
+	be16_t pkey_index;
 	uint8_t reserved[6];
 } ib_mad_addr_t;
 
@@ -154,9 +159,9 @@ typedef struct umad_ca {
 typedef struct umad_filter {
 	uint8_t  mgmt_class;
 	uint8_t  mgmt_version;
-	uint16_t attr_id;
+	be16_t   attr_id;
 	uint8_t  errors;
-	uint8_t  oui[3];
+	uint8_t  oui[3]; /* network-byte order */
 } umad_filter_t;
 
 int umad_init(void);
diff --git a/libibumad/include/infiniband/umad_sa.h b/libibumad/include/infiniband/umad_sa.h
index f3e161e..92248de 100755
--- a/libibumad/include/infiniband/umad_sa.h
+++ b/libibumad/include/infiniband/umad_sa.h
@@ -87,14 +87,17 @@ enum {
 	UMAD_LEN_SA_DATA		= 200
 };
 
+/*
+ *  sm_key is not aligned on an 8-byte boundary, so is defined as a byte array
+ */
 struct umad_sa_packet {
 	struct umad_hdr		mad_hdr;
 	struct umad_rmpp_hdr	rmpp_hdr;
-	uint8_t			sm_key[8];
-	uint16_t		attr_offset;
-	uint16_t		reserved;
-	uint64_t		comp_mask;
-	uint8_t 		data[UMAD_LEN_SA_DATA];
+	uint8_t			sm_key[8]; /* network-byte order */
+	be16_t			attr_offset;
+	be16_t			reserved;
+	be64_t			comp_mask;
+	uint8_t 		data[UMAD_LEN_SA_DATA]; /* network-byte order */
 };
 
 END_C_DECLS
diff --git a/libibumad/include/infiniband/umad_sm.h b/libibumad/include/infiniband/umad_sm.h
index 62c75da..10348d4 100755
--- a/libibumad/include/infiniband/umad_sm.h
+++ b/libibumad/include/infiniband/umad_sm.h
@@ -82,16 +82,16 @@ struct umad_smp {
 	uint8_t	 mgmt_class;
 	uint8_t	 class_version;
 	uint8_t	 method;
-	uint16_t status;
+	be16_t   status;
 	uint8_t  hop_ptr;
 	uint8_t  hop_cnt;
-	uint64_t tid;
-	uint16_t attr_id;
-	uint16_t resv;
-	uint32_t attr_mod;
-	uint64_t mkey;
-	uint16_t dr_slid;
-	uint16_t dr_dlid;
+	be64_t   tid;
+	be16_t   attr_id;
+	be16_t   resv;
+	be32_t   attr_mod;
+	be64_t   mkey;
+	be16_t   dr_slid;
+	be16_t   dr_dlid;
 	uint8_t  reserved[28];
 	uint8_t  data[UMAD_LEN_SMP_DATA];
 	uint8_t  initial_path[UMAD_SMP_MAX_HOPS];
diff --git a/libibumad/include/infiniband/umad_types.h b/libibumad/include/infiniband/umad_types.h
index 54b7e72..bf93add 100755
--- a/libibumad/include/infiniband/umad_types.h
+++ b/libibumad/include/infiniband/umad_types.h
@@ -38,6 +38,7 @@
 #define _UMAD_TYPES_H
 
 #include <stdint.h>
+#include <infiniband/umad.h>
 
 #ifdef __cplusplus
 #  define BEGIN_C_DECLS extern "C" {
@@ -149,11 +150,11 @@ struct umad_hdr {
 	uint8_t	 class_version;
 	uint8_t	 method;
 	uint16_t status;
-	uint16_t class_specific;
-	uint64_t tid;
-	uint16_t attr_id;
-	uint16_t resv;
-	uint32_t attr_mod;
+	be16_t   class_specific;
+	be64_t   tid;
+	be16_t   attr_id;
+	be16_t   resv;
+	be32_t   attr_mod;
 };
 
 struct umad_rmpp_hdr {
@@ -161,27 +162,27 @@ struct umad_rmpp_hdr {
 	uint8_t	 rmpp_type;
 	uint8_t	 rmpp_rtime_flags;
 	uint8_t	 rmpp_status;
-	uint32_t seg_num;
-	uint32_t paylen_newwin;
+	be32_t   seg_num;
+	be32_t   paylen_newwin;
 };
 
 struct umad_packet {
 	struct umad_hdr		mad_hdr;
-	uint8_t			data[UMAD_LEN_DATA];
+	uint8_t			data[UMAD_LEN_DATA]; /* network-byte order */
 };
 
 struct umad_rmpp_packet {
 	struct umad_hdr		mad_hdr;
 	struct umad_rmpp_hdr	rmpp_hdr;
-	uint8_t			data[UMAD_LEN_RMPP_DATA];
+	uint8_t			data[UMAD_LEN_RMPP_DATA]; /* network-byte order */
 };
 
 struct umad_vendor_packet {
 	struct umad_hdr		mad_hdr;
 	struct umad_rmpp_hdr	rmpp_hdr;
 	uint8_t			reserved;
-	uint8_t			oui[3];
-	uint8_t			data[UMAD_LEN_VENDOR_DATA];
+	uint8_t			oui[3];	/* network-byte order */
+	uint8_t			data[UMAD_LEN_VENDOR_DATA]; /* network-byte order */
 };
 
 enum {


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
