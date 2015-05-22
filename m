From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/5] dapl ucm: optimizations for large scale UD
 communication management
Date: Fri, 22 May 2015 21:42:36 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F977D76B7B@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

AH caching per QP, AH space set to 48K for LID unicast
Bump port space up to 24 bits
Reduce CM object and reduce private data to 68 bytes
Add xport space and rtns to DCM reserve fields.

New indexer macros for port space hash table management

Add hash table storage to ibtrans device objects

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_common/dapl_ib_common.h |   15 ++++++++++---
 dapl/openib_ucm/dapl_ib_util.h      |   37 ++++++++++++++++++++++++++++++++--
 2 files changed, 45 insertions(+), 7 deletions(-)

diff --git a/dapl/openib_common/dapl_ib_common.h b/dapl/openib_common/dapl_ib_common.h
index 180c876..7b3e5d0 100644
--- a/dapl/openib_common/dapl_ib_common.h
+++ b/dapl/openib_common/dapl_ib_common.h
@@ -43,11 +43,14 @@
 #define true  1
 #endif /*__cplusplus */
 
+#define DCM_AH_SPACE (0xC000) /* unicast LID range */
+
 /* Typedefs to map common DAPL provider types to IB verbs */
 struct dcm_ib_qp {
 	struct _ib_hca_transport *tp;
 	struct dapl_ep		 *ep;
 	struct ibv_qp		 *qp;	   /* local QP1 snd-rcv or rcv from PO */
+	struct ibv_ah		**ah;	   /* UD AH cache, LID index */
 #ifdef _OPENIB_MCM_
 	struct dcm_ib_cq	 *req_cq;  /* ref to req CQ for HST->MXS */
 	struct dcm_ib_cq	 *rcv_cq;  /* ref to rcv CQ for HST->MXS */
@@ -98,11 +101,13 @@ typedef	struct ibv_context	*ib_hca_handle_t;
 typedef ib_hca_handle_t		dapl_ibal_ca_t;
 
 /* QP info to exchange, wire protocol version for these CM's */
-#define DCM_VER 7
+/* Version 8, 24-bit port space and rtns value */
+#define DCM_VER 8
+#define DCM_VER_XPS 8 /* extended port space, rtns */
 #define DCM_VER_MIN 6 /* backward compatibility limit */
 
 /* CM private data areas, same for all operations */
-#define        DCM_MAX_PDATA_SIZE      118
+#define        DCM_MAX_PDATA_SIZE      68
 
 /*
  * UCM DAPL IB/QP address (lid, qp_num, gid) mapping to
@@ -127,7 +132,6 @@ union dcm_addr {
        } ib;
 };
 
-/* 256 bytes total; default max_inline_send, min IB MTU size */
 typedef struct _ib_cm_msg
 {
 	uint16_t		ver;
@@ -140,7 +144,10 @@ typedef struct _ib_cm_msg
 	uint32_t		s_id;  /* src pid */
 	uint32_t		d_id;  /* dst pid */
 	uint8_t			rd_in; /* atomic_rd_in */
-	uint8_t			resv[5];
+	uint8_t			sportx; /* extend to 24 bits */
+	uint8_t			dportx; /* extend to 24 bits */
+	uint8_t			rtns; 	/* retransmissions */
+	uint8_t			resv[2];
 	union dcm_addr		saddr;
 	union dcm_addr		daddr;
 	union dcm_addr		saddr_alt;
diff --git a/dapl/openib_ucm/dapl_ib_util.h b/dapl/openib_ucm/dapl_ib_util.h
index 8665491..ece9c88 100644
--- a/dapl/openib_ucm/dapl_ib_util.h
+++ b/dapl/openib_ucm/dapl_ib_util.h
@@ -33,15 +33,39 @@
 #include "openib_osd.h"
 #include "dapl_ib_common.h"
 
+#define UCM_SID_BITS 16  /* 64K */
+#define UCM_SID_SPACE (1 << UCM_SID_BITS)
+#define UCM_SID_MASK (UCM_SID_SPACE-1)
+#define UCM_SID_ENTRY 8	/* 8 bit entry */
+
+#define UCM_CHK_SID(a,p) (a[p/UCM_SID_ENTRY] & (1 << (p%UCM_SID_ENTRY)))
+#define UCM_SET_SID(a,p) (a[p/UCM_SID_ENTRY] = (a[p/UCM_SID_ENTRY] |  (1 << (p%UCM_SID_ENTRY))))
+#define UCM_CLR_SID(a,p) (a[p/UCM_SID_ENTRY] = (a[p/UCM_SID_ENTRY] & ~(1 << (p%UCM_SID_ENTRY))))
+
+#define UCM_PORT_BITS 24   /* 16M total, wire protocol max */
+#define UCM_PORT_SPACE (1 << UCM_SID_BITS)
+#define UCM_PORT_MASK (UCM_PORT_SPACE-1)
+#define UCM_PORT_NTOH(hi,lo) ((((hi & 0xff) << 16) | (ntohs(lo) & 0xffff)) & (UCM_PORT_MASK))
+#define UCM_PORT(p) (p & 0xffff)
+#define UCM_PORTX(p) ((p >> 16) & 0xff)
+
+#define UCM_ENTRY_BITS 11    /* 2K entries, default */
+#define UCM_ARRAY_BITS 18    /* 256K total ports, default */
+#define UCM_ENTRY_SIZE(ebits) (1 << ebits)
+#define UCM_ARRAY_SIZE(abits, ebits) (1 << (abits - ebits))
+#define UCM_ARRAY_IDX_MAX(abits) ((1 << abits) - 1)
+#define UCM_ARRAY_IDX(idx, abits) (idx >> abits)
+#define UCM_ENTRY_IDX(idx, abits) (idx & (abits - 1))
+
+
 /* DAPL CM objects MUST include list_entry, ref_count, event for EP linking */
 struct ib_cm_handle
 { 
 	struct dapl_llist_entry	list_entry;
 	struct dapl_llist_entry	local_entry;
-	DAPL_OS_WAIT_OBJECT	d_event;
-	DAPL_OS_WAIT_OBJECT	f_event;
 	DAPL_OS_LOCK		lock;
 	DAPL_OS_TIMEVAL		timer;
+	uint32_t		cm_id;
         int			ref_count;
 	int			state;
 	int			retries;
@@ -49,7 +73,6 @@ struct ib_cm_handle
 	struct dapl_sp		*sp;	
 	struct dapl_ep 		*ep;
 	struct dapl_cr 		*cr;
-	struct ibv_ah		*ah;
 	uint16_t		p_size; /* accept p_data, for retries */
 	uint8_t			p_data[DCM_MAX_PDATA_SIZE];
 	ib_cm_msg_t		msg;
@@ -69,8 +92,16 @@ typedef struct _ib_hca_transport
         struct  ibv_context     *ib_ctx;
         struct ibv_comp_channel *ib_cq;
         ib_cq_handle_t          ib_cq_empty;
+        DAPL_OS_LOCK		ilock;	/* idxr list */
+	void 			**cm_idxr;
 	int			destroy;
 	int			cm_state;
+	int			cm_array_bits;
+	int			cm_entry_bits;
+	int			cm_idxr_cur;
+	int			cm_last;
+	int 			cm_free;
+	int			cm_cnt;
 	DAPL_OS_THREAD		thread;
 	DAPL_OS_LOCK		lock;	/* connect list */
 	struct dapl_llist_entry	*list;	
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
