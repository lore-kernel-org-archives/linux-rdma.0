From: Alex Vainman <alexv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RFC] Verbs RSS.
Date: Mon, 11 May 2015 17:04:08 +0300
Message-ID: <1431353048-2410-1-git-send-email-alexv@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, alexv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Purpose and Motivation
-----------------------
RSS (Receive Side Scaling) technology allows to spread incoming traffic between
different receive descriptor queues.
Assigning each queue to different CPU cores allows to better load balance the
incoming traffic and improve performance.
This RFC introduces RSS arch and libibverbs API, in order to allow verbs based
solutions to utilize the RSS offload capability, widely supported today by many
modern cards cards.

Overview of the Proposed Changes
-----------------
- Add new verbs objects: Work Queue and Receive Work Queues Indirection Table.
- Add new verbs that are required to handle the new objects:
  ibv_create_wq(), ibv_modify_wq(), ibv_destory_wq(),
  ibv_create_rwq_ind_table(), ibv_modify_rwq_ind_table(),
  ibv_destroy_rwq_ind_table(), ibv_post_wq_recv().
- Add support for QP that spreads incoming traffic between different Receive
  Work Queues. We call this QP "RX Hash QP" since it applies hash function
  in order to spread the received traffic.
- Reflect RSS capabilities in ibv_device_attr_ex and add new query device verb:
  ibv_query_device_ex().

The changes are described in more details below.

RSS Flow Overview
-----------------
Steering rules classify incoming packets and deliver a specific traffic types
(e.g. TCP/UDP, IP only) or spesific flows to "RX Hash" QP.
"RX Hash" QP is responsible to spread the traffic it handles between
Receive Work Queues using RX hash and Indirection Table.
Receive Work Queue can point to different CQs that can be associated
with different CPU cores.

"RX Hash" QP
-------------
"RX Hash" QPs don't have internal Receive/Send Work Queues
packaged" inside them.
"RX Hash" QPs are associated with Indirection Table of Receive Work Queues.
On packet reception the QP chooses to which Receive Work Queue to deliver
an incoming packet using RX hash value that points to an Indirection
Table entry that points to Receive Work Queue.
RX hash function and packet fields to use in RX hash calculation are initialized
on QP creation.
"RX Hash" QPs are created by enabling a new init attribute flag:
IBV_QP_INIT_ATTR_RX_HASH.
Device capabilities flags must report which QP types support the "RX Hash" mode.

Additional properties of "RX Hash" QP:
- The QP is stateless
- Receive/Send Work Queues parameters are invalid for it:
  send/recv_cq, qp_cap, srq, etc...
- ibv_post_recv() and ibv_post_send() can't be done on that QP
- The QP is assosiated (many to one) with Receive Work Queue Indirection Table.
- Flow rules can point to that QP
- QP is created and manipulated via existing verbs
- QP's transport properties can be set via ibv_create_qp_ex() verb and can be
  modified via ibv_modify_qp() verb.
  Notice:
  1. The list of supported properties is depended on QP's transport type.
  2. WQ properties can't be set via ibv_create_qp_ex() or modified via
     ibv_modify_qp().

New Verbs Objects:
------------------
- ibv_rwq_ind_tbl: Receive Work Queue Indirection Table.
  Its size must be power of two, hoverwer the number of Receive WQs it contains
  doesn't have to be power of two.

- ibv_wq: Work Queue.
  Work Queue is associated (many to one) with  Completion Queue
  it owns Work Queue properties (PD, WQ size etc).
  Currently two WQ types are supported: IBV_RQ and IBV_SRQ.
  IBV_RQ WQ contains receive WQEs.
  IBV_SRQ WQ is associated (many to one) with IB_SRQT_BASIC SRQ,
  in which case it does not hold receive WQEs.
  QPs are connected to IBV_RQ/IBV_SRQ WQ (many to many) via Indirection Table.
  WQEs are posted to IBV_RQ WQ via ibv_post_wq_recv().
  For IBV_SRQ WQ WQE are posted via ibv_post_srq_recv().
  WQ context is subject to a well-defined state transitions as illustrated
  in the following table:

   Next State|Initial|RESET|RDY|ERR|Final
Current State
--------------------------------------------
Initial|NA|create|NA|NA|NA
RESET|NA|modify|modify|NA|destroy
RDY|NA|modify|modify|modify/HW error|destroy
ERR|NA|modify|NA|NA|destroy
Final|NA|NA|NA|NA|NA

RSS Capabilities
----------------
RSS capabilities must be added to ibv_device_attr_ex and queried via
ibv_query_device_ex() verb.
The capabilities should cover:
- QP types that supports "RX Hash" mode.
- Supported hash functions and packet fields that can participate in RX hash.
- Max Indirection table size.
- Max number of supported IBV_S/RQ WQs .
- Max number of supported Indirection tables.

Initialization Flow Example
---------------------------
- N X Create CQ.
- N X Create IBV_RQ WQ, using ibv_create_wq() verb.
- Create and populate Receive Work Queue Indirection Table with previously
  created Receive WQs, using ibv_create_rwq_ind_table() verb.
- Create 2 X IB_QPT_RAW_PACKET QPs with enabled IBV_DEVICE_RAW_PACKET_RX_HASH
  capability flag with the following RX hash configuration:
  QP1:
      - Hash function: XOR.
      - Enabled hash bits: TCP source port, TCP destination port,
                           IPv4 source address, IPv4 destination address.
  QP2
      - Hash function: XOR.
      - Enabled hash bits: UDP source port, UDP destination port,
                           IPv4 source address, IPv4 destination address.
  Both QPs are assosiated with previously created Indirection Table.
- N X post receive to Receive WQ, using ibv_post_wq_recv() verb.
- Create appropriate flow rules:
      - Configure steering to deliver TCP/IPv4 packets to QP1.
      - Configure steering to deliver UDP/IPv4 packets to QP2.

Signed-off-by: Alex Vainman <alexv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/verbs.h | 292 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 290 insertions(+), 2 deletions(-)

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index cfa1156..624e1fc 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -116,7 +116,13 @@ enum ibv_device_cap_flags {
 	IBV_DEVICE_SRQ_RESIZE		= 1 << 13,
 	IBV_DEVICE_N_NOTIFY_CQ		= 1 << 14,
 	IBV_DEVICE_XRC			= 1 << 20,
-	IBV_DEVICE_MANAGED_FLOW_STEERING = 1 << 29
+	IBV_DEVICE_MANAGED_FLOW_STEERING = 1 << 29,
+	/* Devices should set IBV_DEVICE_RAW_PACKET_RX_HASH if they
+	* support IBV_QPT_RAW_PACKET QPs that can spread incoming traffic
+	* to different Receive Work Queues, by applying hash function
+	* on selected packet fields.
+	*/
+	IBV_DEVICE_RAW_PACKET_RX_HASH	= 1 << 30
 };
 
 enum ibv_atomic_cap {
@@ -241,6 +247,7 @@ struct ibv_async_event {
 	union {
 		struct ibv_cq  *cq;
 		struct ibv_qp  *qp;
+		struct ibv_wq  *wq;
 		struct ibv_srq *srq;
 		int		port_num;
 	} element;
@@ -300,6 +307,7 @@ struct ibv_wc {
 	uint32_t		vendor_err;
 	uint32_t		byte_len;
 	uint32_t		imm_data;	/* in network byte order */
+	/* WQ number for WC generated by WQ */
 	uint32_t		qp_num;
 	uint32_t		src_qp;
 	int			wc_flags;
@@ -481,6 +489,83 @@ struct ibv_srq_init_attr_ex {
 	struct ibv_cq	       *cq;
 };
 
+enum ibv_wq_type {
+	IBV_WQT_RQ,
+	IBV_WQT_SRQ
+};
+
+struct ibv_wq_init_attr {
+	/* Associated Context of the WQ */
+	void		       *wq_context;
+	enum ibv_wq_type	wq_type;
+	/* Valid for non IBV_WQT_SRQ WQ */
+	uint32_t		max_wr;
+	/* Valid for non IBV_WQT_SRQ WQ */
+	uint32_t		max_sge;
+	/* Protection domain WQ should be associated with */
+	struct	ibv_pd	       *pd;
+	/* CQ to be associated with the WQ */
+	struct	ibv_cq	       *cq;
+	/* SRQ handle if WQ is of type IBV_WQT_SRQ, otherwise NULL */
+	struct	ibv_srq	       *srq;
+	uint32_t		comp_mask;
+};
+
+enum ibv_wq_state {
+	IBV_WQS_RESET,
+	IBV_WQS_RDY,
+	IBV_WQS_ERR,
+	IBV_WQS_UNKNOWN
+};
+
+enum ibv_wq_attr_mask {
+	IBV_WQ_ATTR_STATE	= 1 << 0,
+	IBV_WQ_ATTR_CURR_STATE	= 1 << 1,
+	IBV_WQ_ATTR_RESERVED	= 1 << 2
+};
+
+struct ibv_wq_attr {
+	/* enum ibv_wq_attr_mask */
+	uint32_t		attr_mask;
+	/* Move the RQ to this state */
+	enum	ibv_wq_state	wq_state;
+	/* Assume this is the current RQ state */
+	enum	ibv_wq_state	curr_wq_state;
+};
+
+/*
+ * Receive Work Queue Indirection Table attributes
+*/
+struct ibv_rwq_ind_table_init_attr {
+	struct ibv_pd	       *pd;
+	/* Log, base 2, of Indirection table size */
+	uint32_t		log_rwq_ind_tbl_size;
+	/* Each entry is a pointer to Receive Work Queue */
+	struct ibv_wq	      **rwq_ind_tbl;
+	uint32_t		comp_mask;
+};
+
+/*
+ * Receive Work Queue Indirection Table attributes mask
+*/
+enum ibv_rwq_ind_table_attr_mask {
+	IBV_RWQ_IND_TABLE_ATTR_TABLE		= 1 << 0,
+	IBV_RWQ_IND_TABLE_ATTR_TABLE_SIZE	= 1 << 1,
+	IBV_RWQ_IND_TABLE_ATTR_RESERVED		= 1 << 2
+};
+
+/*
+ * Receive Work Queue Indirection Table attributes
+*/
+struct ibv_rwq_ind_table_attr {
+	/* enum ibv_rwq_ind_table_attr_mask */
+	uint32_t		attr_mask;
+	/* Log, base 2, of Indirection table size */
+	uint32_t		log_rwq_ind_tbl_size;
+	/* Each entry is a pointer to Receive Work Queue */
+	struct ibv_wq	      **rwq_ind_tbl;
+};
+
 enum ibv_qp_type {
 	IBV_QPT_RC = 2,
 	IBV_QPT_UC,
@@ -511,7 +596,50 @@ struct ibv_qp_init_attr {
 enum ibv_qp_init_attr_mask {
 	IBV_QP_INIT_ATTR_PD		= 1 << 0,
 	IBV_QP_INIT_ATTR_XRCD		= 1 << 1,
-	IBV_QP_INIT_ATTR_RESERVED	= 1 << 2
+	IBV_QP_INIT_ATTR_RX_HASH	= 1 << 2,
+	IBV_QP_INIT_ATTR_PORT		= 1 << 3,
+	IBV_QP_INIT_ATTR_RESERVED	= 1 << 4
+};
+
+/*
+ * RX Hash Function flags.
+*/
+enum ibv_rx_hash_function_flags {
+	IBV_EX_RX_HASH_FUNC_TOEPLTIZ	= 1 << 0,
+	IBV_EX_RX_HASH_FUNC_XOR		= 1 << 1
+};
+
+/*
+ * RX Hash flags, these flags allows to set which incoming packet field should
+ * participates in RX Hash. Each flag represent certain packet's field,
+ * when the flag is set the field that is represented by the flag will
+ * participate in RX Hash calculation.
+ * Notice: *IPV4 and *IPV6 flags can't be enabled together on the same QP
+ * and *TCP and *UDP flags can't be enabled together on the same QP.
+*/
+enum ibv_rx_hash_fields {
+	IBV_RX_HASH_SRC_IPV4		= 1 << 0,
+	IBV_RX_HASH_DST_IPV4		= 1 << 1,
+	IBV_RX_HASH_SRC_IPV6		= 1 << 2,
+	IBV_RX_HASH_DST_IPV6		= 1 << 3,
+	IBV_RX_HASH_SRC_PORT_TCP	= 1 << 4,
+	IBV_RX_HASH_DST_PORT_TCP	= 1 << 5,
+	IBV_RX_HASH_SRC_PORT_UDP	= 1 << 6,
+	IBV_RX_HASH_DST_PORT_UDP	= 1 << 7
+};
+
+/*
+ * RX Hash QP configuration. Sets hash function, hash types and
+ * Indirection table for QPs with enabled IBV_QP_INIT_ATTR_RX_HASH flag.
+*/
+struct ibv_rx_hash_conf {
+	/* enum ib_rx_hash_fnction */
+	uint8_t				rx_hash_function;
+	/* valid only for Toeplitz */
+	uint8_t                        *rx_hash_key;
+	/* enum ib_rx_hash_fields */
+	uint64_t			rx_hash_fields_mask;
+	struct ibv_rwq_ind_table       *rwq_ind_tbl;
 };
 
 struct ibv_qp_init_attr_ex {
@@ -526,6 +654,8 @@ struct ibv_qp_init_attr_ex {
 	uint32_t		comp_mask;
 	struct ibv_pd	       *pd;
 	struct ibv_xrcd	       *xrcd;
+	struct ibv_rx_hash_conf	       *rx_hash_conf;
+	uint8_t			port_num;
 };
 
 enum ibv_qp_open_attr_mask {
@@ -695,6 +825,51 @@ struct ibv_srq {
 	uint32_t		events_completed;
 };
 
+/*
+ * Work Queue. QP can be created without internal WQs "packaged" inside it,
+ * this QPs can be configured to use "external" WQ object as its
+ * receive/send queue.
+ * WQ associated (many to one) with Completion Queue it owns WQ properties
+ * (PD, WQ size etc).
+ * WQ of type IBV_RQ contains receive WQEs, in which case its PD serves
+ * scatter as well.
+ * WQ of type IBV_SRQ is associated (many to one) with IB_SRQT_BASIC SRQ,
+ * in which case it does not hold receive WQEs.
+ * QPs can be associated with IBV_S/RQ WQs via WQ Indirection Table
+ * (many to many).
+ */
+struct ibv_wq {
+	struct ibv_context     *context;
+	void		       *wq_context; /* Associated Context of the WQ */
+	uint32_t		handle;
+	/* Protection domain WQ should be associated with */
+	struct	ibv_pd	       *pd;
+	/* CQ to be associated with the Receive Queue (WQ) */
+	struct	ibv_cq	       *cq;
+	/* SRQ handle if WQ is to be associated with an SRQ, otherwise NULL */
+	struct	ibv_srq	       *srq;
+	uint32_t		wq_num;
+	enum ibv_wq_state       state;
+	enum ibv_wq_type	wq_type;
+	uint32_t		comp_mask;
+};
+
+/*
+ * Receive Work Queue Indirection Table.
+ * QPs with IBV_QP_INIT_ATTR_RX_HASH flag enabled use Indirection Table
+ * in order to distribute incoming packets between different
+ * Receive Work Queues. Associating Receive WQs with different CPU cores
+ * allows to workload the traffic between different CPU cores.
+ * The Indirection Table can contain only WQs of type IBV_RQ/IBV_SRQ.
+ * Notice: Multiple QP can point to the same Indirection Table.
+*/
+struct ibv_rwq_ind_table {
+	struct ibv_context     *context;
+	struct ibv_pd	       *pd;
+	int			ind_tbl_num;
+	uint32_t		comp_mask;
+};
+
 struct ibv_qp {
 	struct ibv_context     *context;
 	void		       *qp_context;
@@ -1355,6 +1530,11 @@ static inline int ibv_post_srq_recv(struct ibv_srq *srq,
 struct ibv_qp *ibv_create_qp(struct ibv_pd *pd,
 			     struct ibv_qp_init_attr *qp_init_attr);
 
+/*
+* The following QP init attributes are supported and required for
+* IBV_QPT_RAW_PACKET QP that supports packet spreading using RX Hash:
+* IBV_QP_INIT_ATTR_PD, IBV_QP_INIT_ATTR_RX_HASH, IBV_QP_INIT_ATTR_PORT
+*/
 static inline struct ibv_qp *
 ibv_create_qp_ex(struct ibv_context *context, struct ibv_qp_init_attr_ex *qp_init_attr_ex)
 {
@@ -1413,6 +1593,114 @@ int ibv_query_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
  */
 int ibv_destroy_qp(struct ibv_qp *qp);
 
+/*
+ * ibv_create_wq - Creates a WQ associated with the specified protection
+ * domain.
+ * @context: ibv_context.
+ * @wq_init_attr: A list of initial attributes required to create the
+ * WQ. If WQ creation succeeds, then the attributes are updated to
+ * the actual capabilities of the created WQ.
+ *
+ * wq_init_attr->wq_cap.max_wr and wq_init_attr->max_sge determine
+ * the requested size of the RQ's WQ, and set to the actual values allocated
+ * on return.
+ * If ibv_create_wq() succeeds, then max_wr and max_sge will always be
+ * at least as large as the requested values.
+ *
+ * Return Value
+ * ibv_create_wq() returns a pointer to the created WQ, or NULL if the request
+ * fails.
+ */
+struct ibv_wq *ibv_create_wq(struct ibv_context *context,
+				struct ibv_wq_init_attr *wq_init_attr);
+
+/*
+ * ib_modify_wq - Modifies the attributes for the specified WQ.
+ * @wq: The WQ to modify.
+ * @wq_init_attr: On input, specifies the WQ attributes to modify.
+ * On output, the current values of selected WQ attributes are returned.
+ * @wq_attr_mask: A bit-mask used to specify which attributes of the WQ
+ * are being modified.
+ *
+ * Return Value
+ * ibv_modify_wq() returns 0 on success, or the value of errno
+ * on failure (which indicates the failure reason).
+ *
+ * WQ States Transition Properties
+ * -------------------------------
+ * IB_RQ WQ Type:
+ * Transition    Required Attributes    Optional Attributes
+ * ----------    --------------------   -------------------
+ * RESET2RDY     IBV_WQ_ATTR_STATE	IBV_WQ_ATTR_CURR_STATE
+ * RDY2RDY       IBV_WQ_ATTR_STATE	IBV_WQ_ATTR_CURR_STATE
+ *
+ * IB_SRQ WQ  Type:
+ * Transition    Required Attributes    Optional Attributes
+ * ----------    --------------------   -------------------
+ * RESET2RDY     IBV_WQ_ATTR_STATE	IBV_WQ_ATTR_CURR_STATE
+ * RESET2RDY     IBV_WQ_ATTR_STATE	IBV_WQ_ATTR_CURR_STATE
+ *
+*/
+int ibv_modify_wq(struct ibv_wq *wq, struct ibv_wq_attr *wq_attr);
+
+/*
+ * ibv_destroy_wq - Destroys the specified WQ.
+ * @ibv_wq: The WQ to destroy.
+ * Return Value
+ * ibv_destroy_wq() returns 0 on success, or the value of errno
+ * on failure (which indicates the failure reason).
+*/
+int ibv_destroy_wq(struct ibv_wq *wq);
+
+/*
+ * ib_post_rq_recv - Posts a list of work requests to the specified WQ
+ * of type IBV_RQ.
+ * @wq: The WQ to post the work request on.
+ * @recv_wr: A list of work requests to post on the receive queue.
+ * @bad_recv_wr: On an immediate failure, this parameter will reference
+ * the work request that failed to be posted on the WQ.
+ * Return Value
+ * ibv_post_wq_recv() returns 0 on success, or the value of errno
+ * on failure (which indicates the failure reason).
+*/
+static inline int ibv_post_wq_recv(struct ibv_wq *wq,
+				  struct ibv_recv_wr *recv_wr,
+				  struct ibv_recv_wr **bad_recv_wr);
+
+/*
+ * ibv_create_rwq_ind_table - Creates a RQ Indirection Table associated
+ * with the specified protection domain.
+ * @pd: The protection domain associated with the Indirection Table.
+ * @ibv_rwq_ind_table_init_attr: A list of initial attributes required to
+ * create the Indirection Table.
+ * If Indirection Table creation succeeds, then the attributes are updated to
+ * the actual capabilities of the created Indirection Table.
+ *
+ * Return Value
+ * ibv_create_rwq_ind_table returns a pointer to the created
+ * Indirection Table, or NULL if the request fails.
+ */
+struct ibv_wq_ind_tbl *ibv_create_rwq_ind_table(struct ibv_context *context,
+					struct ibv_rwq_ind_table_init_attr*
+					wq_ind_table_init_attr);
+/*
+ * ibv_modify_rwq_ind_table - Modify the specified Indirection Table.
+ * @wq_ind_table: The Indirection Table to modify.
+ * Return Value
+ * ibv_modify_rwq_ind_table() returns 0 on success, or the value of errno
+ * on failure (which indicates the failure reason).
+*/
+int ibv_modify_rwq_ind_table(struct ibv_rwq_ind_table *wq_ind_table);
+
+/*
+ * ibv_destroy_rwq_ind_table - Destroys the specified Indirection Table.
+ * @wq_ind_table: The Indirection Table to destroy.
+ * Return Value
+ * ibv_destroy_rwq_ind_table() returns 0 on success, or the value of errno
+ * on failure (which indicates the failure reason).
+*/
+int ibv_destroy_rwq_ind_table(struct ibv_rwq_ind_table *wq_ind_table);
+
 /**
  * ibv_post_send - Post a list of work requests to a send queue.
  *
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
