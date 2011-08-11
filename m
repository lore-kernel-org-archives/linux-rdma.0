From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/10] DAPL v2.0: dat: add definitions for MPI offloaded
 collectives in IB transport extensions
Date: Thu, 11 Aug 2011 00:41:36 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F916E42B1A@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

New definitions for offloaded MPI collectives. Roll IB extensions to v2.0.6
and clean up some counter definitions for consistency. 

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dat/include/dat2/dat_ib_extensions.h |  685 +++++++++++++++++++++++++++++++---
 1 files changed, 624 insertions(+), 61 deletions(-)

diff --git a/dat/include/dat2/dat_ib_extensions.h b/dat/include/dat2/dat_ib_extensions.h
index a32a4ed..ac69fed 100755
--- a/dat/include/dat2/dat_ib_extensions.h
+++ b/dat/include/dat2/dat_ib_extensions.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2007 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2007-2011 Intel Corporation.  All rights reserved.
  * 
  * This Software is licensed under one of the following licenses:
  * 
@@ -72,15 +72,36 @@
  *
  * 2.0.4 - Add DAT_IB_UD_CONNECTION_REJECT_EVENT extended UD event
  * 2.0.5 - Add DAT_IB_UD extended UD connection error events
+ * 2.0.6 - Add MPI over IB collective extensions
  *
  */
-#define DAT_IB_EXTENSION_VERSION	205	/* 2.0.5 */
-#define DAT_ATTR_COUNTERS		"DAT_COUNTERS"
+#define DAT_IB_EXTENSION_VERSION	206	/* 2.0.6 */
+#define DAT_IB_ATTR_COUNTERS		"DAT_COUNTERS"
 #define DAT_IB_ATTR_FETCH_AND_ADD	"DAT_IB_FETCH_AND_ADD"
 #define DAT_IB_ATTR_CMP_AND_SWAP	"DAT_IB_CMP_AND_SWAP"
 #define DAT_IB_ATTR_IMMED_DATA		"DAT_IB_IMMED_DATA"
 #define DAT_IB_ATTR_UD			"DAT_IB_UD"
 
+#define DAT_IB_COLL_SET_CLOCK		"DAT_COLL_SET_CLOCK"
+#define DAT_IB_COLL_READ_CLOCK		"DAT_COLL_READ_CLOCK"
+#define DAT_IB_COLL_BROADCAST		"DAT_COLL_BROADCAST"
+#define DAT_IB_COLL_BARRIER		"DAT_COLL_BARRIER"
+#define DAT_IB_COLL_SCATTER		"DAT_COLL_SCATTER"
+#define DAT_IB_COLL_SCATTERV		"DAT_COLL_SCATTERV"
+#define DAT_IB_COLL_GATHER		"DAT_COLL_GATHER"
+#define DAT_IB_COLL_GATHERV		"DAT_COLL_GATHERV"
+#define DAT_IB_COLL_ALLGATHER		"DAT_COLL_ALLGATHER"
+#define DAT_IB_COLL_ALLGATHERV		"DAT_COLL_ALLGATHERV"
+#define DAT_IB_COLL_ALLTOALL		"DAT_COLL_ALLTOALL"
+#define DAT_IB_COLL_ALLTOALLV		"DAT_COLL_ALLTOALLV"
+#define DAT_IB_COLL_REDUCE		"DAT_COLL_REDUCE"
+#define DAT_IB_COLL_ALLREDUCE		"DAT_COLL_ALLREDUCE"
+#define DAT_IB_COLL_REDUCE_SCATTER	"DAT_COLL_REDUCE_SCATTER"
+#define DAT_IB_COLL_SCAN		"DAT_COLL_SCAN"
+
+/* Collective handle */
+typedef	DAT_HANDLE	DAT_IB_COLLECTIVE_HANDLE;
+
 /* 
  * Definition for extended EVENT numbers, DAT_IB_EXTENSION_BASE_RANGE
  * is used by these extensions as a starting point for extended event numbers 
@@ -94,7 +115,8 @@ typedef enum dat_ib_event_number
 	DAT_IB_UD_CONNECTION_REQUEST_EVENT,
 	DAT_IB_UD_CONNECTION_EVENT_ESTABLISHED,
 	DAT_IB_UD_CONNECTION_REJECT_EVENT,
-	DAT_IB_UD_CONNECTION_ERROR_EVENT
+	DAT_IB_UD_CONNECTION_ERROR_EVENT,
+	DAT_IB_COLLECTIVE_EVENT,
 
 } DAT_IB_EVENT_NUMBER;
 
@@ -107,8 +129,28 @@ typedef enum dat_ib_op
 	DAT_IB_CMP_AND_SWAP_OP,
 	DAT_IB_RDMA_WRITE_IMMED_OP,
 	DAT_IB_UD_SEND_OP,
-	DAT_QUERY_COUNTERS_OP,
-	DAT_PRINT_COUNTERS_OP
+	DAT_IB_QUERY_COUNTERS_OP,
+	DAT_IB_PRINT_COUNTERS_OP,
+	DAT_IB_COLLECTIVE_CREATE_MEMBER_OP,
+	DAT_IB_COLLECTIVE_FREE_MEMBER_OP,
+	DAT_IB_COLLECTIVE_CREATE_GROUP_OP,
+	DAT_IB_COLLECTIVE_FREE_GROUP_OP,
+	DAT_IB_COLLECTIVE_SET_CLOCK_OP,
+	DAT_IB_COLLECTIVE_READ_CLOCK_OP,
+	DAT_IB_COLLECTIVE_SCATTER_OP,
+	DAT_IB_COLLECTIVE_SCATTERV_OP,
+	DAT_IB_COLLECTIVE_GATHER_OP,
+	DAT_IB_COLLECTIVE_GATHERV_OP,
+	DAT_IB_COLLECTIVE_ALLGATHER_OP,
+	DAT_IB_COLLECTIVE_ALLGATHERV_OP,
+	DAT_IB_COLLECTIVE_ALLTOALL_OP,
+	DAT_IB_COLLECTIVE_ALLTOALLV_OP,
+	DAT_IB_COLLECTIVE_REDUCE_OP,
+	DAT_IB_COLLECTIVE_ALLREDUCE_OP,
+	DAT_IB_COLLECTIVE_REDUCE_SCATTER_OP,
+	DAT_IB_COLLECTIVE_SCAN_OP,
+	DAT_IB_COLLECTIVE_BROADCAST_OP,
+	DAT_IB_COLLECTIVE_BARRIER_OP,
 	
 } DAT_IB_OP;
 
@@ -135,6 +177,24 @@ typedef enum dat_ib_ext_type
 	DAT_IB_UD_CONNECT_REJECT,	// 10
 	DAT_IB_UD_CONNECT_ERROR,	// 11
 
+	DAT_IB_COLLECTIVE_CREATE_STATUS,	// 12
+	DAT_IB_COLLECTIVE_CREATE_DATA,		// 13
+	DAT_IB_COLLECTIVE_CLOCK_SET_STATUS,	// 14
+	DAT_IB_COLLECTIVE_SCATTER_STATUS,	// 15
+	DAT_IB_COLLECTIVE_SCATTERV_STATUS,	// 16
+	DAT_IB_COLLECTIVE_GATHER_STATUS,	// 17
+	DAT_IB_COLLECTIVE_GATHERV_STATUS,	// 18
+	DAT_IB_COLLECTIVE_ALLGATHER_STATUS,	// 19
+	DAT_IB_COLLECTIVE_ALLGATHERV_STATUS,	// 20
+	DAT_IB_COLLECTIVE_ALLTOALL_STATUS,	// 21
+	DAT_IB_COLLECTIVE_ALLTOALLV_STATUS,	// 22
+	DAT_IB_COLLECTIVE_REDUCE_STATUS,	// 23
+	DAT_IB_COLLECTIVE_ALLREDUCE_STATUS,	// 24
+	DAT_IB_COLLECTIVE_REDUCE_SCATTER_STATUS,// 25
+	DAT_IB_COLLECTIVE_SCAN_STATUS,		// 26
+	DAT_IB_COLLECTIVE_BROADCAST_STATUS,	// 27
+	DAT_IB_COLLECTIVE_BARRIER_STATUS,	// 28
+
 } DAT_IB_EXT_TYPE;
 
 /* 
@@ -144,10 +204,10 @@ typedef enum dat_ib_status
 {
 	DAT_OP_SUCCESS = DAT_SUCCESS,
 	DAT_IB_OP_ERR,
+	DAT_IB_COLL_COMP_ERR,
 
 } DAT_IB_STATUS;
 
-
 /* 
  * Definitions for additional extension type RETURN codes above
  * standard DAT types. Included with standard DAT_TYPE_STATUS 
@@ -156,6 +216,7 @@ typedef enum dat_ib_status
 typedef enum dat_ib_return
 {
 	DAT_IB_ERR = DAT_EXTENSION_BASE,
+	DAT_IB_COLLECTIVE_ERR
 
 } DAT_IB_RETURN;
 
@@ -173,7 +234,8 @@ typedef enum dat_ib_dtos
 	DAT_IB_DTO_SEND_UD,
 	DAT_IB_DTO_RECV_UD,
 	DAT_IB_DTO_RECV_UD_IMMED,	
-
+	DAT_IB_DTO_COLLECTIVES,
+	
 } DAT_IB_DTOS;
 
 /* 
@@ -184,6 +246,7 @@ typedef enum dat_ib_dtos
 typedef enum dat_ib_handle_type
 {
     DAT_IB_HANDLE_TYPE_EXT = DAT_HANDLE_TYPE_EXTENSION_BASE,
+    DAT_IB_HANDLE_TYPE_COLLECTIVE
 
 } DAT_IB_HANDLE_TYPE;
 
@@ -221,14 +284,8 @@ typedef struct dat_ib_addr_handle
    
 } DAT_IB_ADDR_HANDLE;
 
-/* 
- * Definitions for extended event data:
- *	When dat_event->event_number >= DAT_IB_EXTENSION_BASE_RANGE
- *	then dat_event->extension_data == DAT_IB_EXT_EVENT_DATA type
- *	and ((DAT_IB_EXT_EVENT_DATA*)dat_event->extension_data)->type
- *	specifies extension data values. 
- * NOTE: DAT_IB_EXT_EVENT_DATA cannot exceed 64 bytes as defined by 
- *	 "DAT_UINT64 extension_data[8]" in DAT_EVENT (dat.h)
+/*
+ * Definition for the value filed of extended event that contains immediate data
  */
 typedef struct dat_ib_immed_data 
 {
@@ -236,13 +293,21 @@ typedef struct dat_ib_immed_data
 
 } DAT_IB_IMMED_DATA;
 
+/* definition for IB collective event data */
+typedef struct dat_ib_collective_event_data
+{
+    DAT_HANDLE  handle;
+    DAT_CONTEXT context;
+
+} DAT_IB_COLLECTIVE_EVENT_DATA;
+
 /* 
  * Definitions for extended event data:
  *	When dat_event->event_number >= DAT_IB_EXTENSION_BASE_RANGE
- *	then dat_event->extension_data == DAT_EXTENSION_EVENT_DATA type
- *	and ((DAT_EXTENSION_EVENT_DATA*)dat_event->extension_data)->type
+ *	then dat_event->extension_data == DAT_IB_EXTENSION_EVENT_DATA type
+ *	and ((DAT_IB_EXTENSION_EVENT_DATA*)dat_event->extension_data)->type
  *	specifies extension data values. 
- * NOTE: DAT_EXTENSION_EVENT_DATA cannot exceed 64 bytes as defined by 
+ * NOTE: DAT_IB_EXTENSION_EVENT_DATA cannot exceed 64 bytes as defined by 
  *	 "DAT_UINT64 extension_data[8]" in DAT_EVENT (dat.h)
  *
  *  Provide UD address handles via extended connect establishment. 
@@ -255,7 +320,10 @@ typedef struct dat_ib_extension_event_data
     union {
 		DAT_IB_IMMED_DATA	immed;
     } val;
-    DAT_IB_ADDR_HANDLE	remote_ah; 
+    union {
+	    DAT_IB_ADDR_HANDLE			remote_ah;
+	    DAT_IB_COLLECTIVE_EVENT_DATA	coll;
+    };
 
 } DAT_IB_EXTENSION_EVENT_DATA;
 
@@ -357,6 +425,71 @@ typedef enum dat_evd_counters
 
 } DAT_EVD_COUNTERS;
 
+/*
+ * Data type for reduce operations
+ */
+typedef enum dat_ib_collective_data_type
+{
+        DAT_IB_COLLECTIVE_TYPE_INT8,
+        DAT_IB_COLLECTIVE_TYPE_UINT8,
+        DAT_IB_COLLECTIVE_TYPE_INT16,
+        DAT_IB_COLLECTIVE_TYPE_UINT16,
+        DAT_IB_COLLECTIVE_TYPE_INT32,
+        DAT_IB_COLLECTIVE_TYPE_UINT32,
+        DAT_IB_COLLECTIVE_TYPE_INT64,
+        DAT_IB_COLLECTIVE_TYPE_UINT64,
+        DAT_IB_COLLECTIVE_TYPE_FLOAT,
+        DAT_IB_COLLECTIVE_TYPE_DOUBLE,
+        DAT_IB_COLLECTIVE_TYPE_LONG_DOUBLE,
+        DAT_IB_COLLECTIVE_TYPE_SHORT_INT,
+        DAT_IB_COLLECTIVE_TYPE_2INT,
+        DAT_IB_COLLECTIVE_TYPE_FLOAT_INT,
+        DAT_IB_COLLECTIVE_TYPE_LONG_INT,
+        DAT_IB_COLLECTIVE_TYPE_DOUBLE_INT,
+        
+} DAT_IB_COLLECTIVE_DATA_TYPE;
+
+/*
+ * Opcode for reduce operations
+ */
+typedef enum dat_ib_collective_reduce_data_op
+{
+        DAT_IB_COLLECTIVE_REDUCE_OP_MAX, 
+        DAT_IB_COLLECTIVE_REDUCE_OP_MIN,
+        DAT_IB_COLLECTIVE_REDUCE_OP_SUM,
+        DAT_IB_COLLECTIVE_REDUCE_OP_PROD,
+        DAT_IB_COLLECTIVE_REDUCE_OP_LAND,
+        DAT_IB_COLLECTIVE_REDUCE_OP_BAND,
+        DAT_IB_COLLECTIVE_REDUCE_OP_LOR,
+        DAT_IB_COLLECTIVE_REDUCE_OP_BOR,
+        DAT_IB_COLLECTIVE_REDUCE_OP_LXOR,
+        DAT_IB_COLLECTIVE_REDUCE_OP_BXOR,
+        DAT_IB_COLLECTIVE_REDUCE_OP_MAXLOC,
+        DAT_IB_COLLECTIVE_REDUCE_OP_MINLOC
+
+} DAT_IB_COLLECTIVE_REDUCE_DATA_OP;
+
+/*
+ * For group creation
+ */
+typedef unsigned int DAT_IB_COLLECTIVE_RANK;
+typedef unsigned int DAT_IB_COLLECTIVE_ID;
+typedef	void * DAT_IB_COLLECTIVE_MEMBER;
+
+typedef struct dat_ib_collective_group
+{
+	int	local_size;       /* # of processes on this node */
+	int	local_rank;       /* my rank within the node */
+	int 	*local_ranks;     /* global rank for each local process */
+	int	external_size;    /* # of nodes, each node has exactly one external process (local root) */
+	int	external_rank;    /* my rank among all external processes if one of them, otherwise -1 */
+	int	*external_ranks;  /* global rank for each external process */
+	int	*intranode_table; /* mapping from global rank to local rank. -1 if the process is on a different node */
+	int	*internode_table; /* mapping from global rank to external rank. -1 if the process is >not external */
+	int	is_comm_world;
+
+} DAT_IB_COLLECTIVE_GROUP;
+
 /* Extended RETURN and EVENT STATUS string helper functions */
 
 /* DAT_EXT_RETURN error to string */
@@ -397,6 +530,9 @@ dat_strerror_ext_status (
 /* 
  * Extended IB transport specific APIs
  *  redirection via DAT extension function
+ *  va_arg function: DAT_HANDLE and OP type MUST be first 2 parameters
+ *
+ *  RETURN VALUE: DAT_RETURN
  */
 
 /*
@@ -406,13 +542,14 @@ dat_strerror_ext_status (
  * and the result is stored in the local_iov.  
  */
 #define dat_ib_post_fetch_and_add(ep, add_val, lbuf, cookie, rbuf, flgs) \
-	     dat_extension_op(  ep, \
-				DAT_IB_FETCH_AND_ADD_OP, \
-				(add_val), \
-				(lbuf), \
-				(cookie), \
-				(rbuf), \
-				(flgs))
+	dat_extension_op(\
+		IN (DAT_EP_HANDLE) (ep), \
+		IN (DAT_IB_OP) DAT_IB_FETCH_AND_ADD_OP, \
+		IN (DAT_UINT64) (add_val), \
+		IN (DAT_LMR_TRIPLET *) (lbuf), \
+		IN (cookie), \
+		IN (DAT_RMR_TRIPLET *) (rbuf), \
+		IN (DAT_COMPLETION_FLAGS) (flgs))
 				
 /*
  * This asynchronous call is modeled after the InfiniBand atomic 
@@ -423,14 +560,15 @@ dat_strerror_ext_status (
  * value stored in the remote memory location is copied to the local_iov.
  */
 #define dat_ib_post_cmp_and_swap(ep, cmp_val, swap_val, lbuf, cookie, rbuf, flgs) \
-	     dat_extension_op(  ep, \
-				DAT_IB_CMP_AND_SWAP_OP, \
-				(cmp_val), \
-				(swap_val), \
-				(lbuf), \
-				(cookie), \
-				(rbuf), \
-				(flgs))
+	dat_extension_op(\
+		IN (DAT_EP_HANDLE) (ep), \
+		IN (DAT_IB_OP) DAT_IB_CMP_AND_SWAP_OP, \
+		IN (DAT_UINT64) (cmp_val), \
+		IN (DAT_UINT64) (swap_val), \
+		IN (DAT_LMR_TRIPLET *) (lbuf), \
+		IN (cookie), \
+		IN (DAT_RMR_TRIPLET *) (rbuf), \
+		IN (DAT_COMPLETION_FLAGS) (flgs))
 
 /* 
  * RDMA Write with IMMEDIATE:
@@ -449,14 +587,15 @@ dat_strerror_ext_status (
  *	n/a
  */
 #define dat_ib_post_rdma_write_immed(ep, size, lbuf, cookie, rbuf, idata, flgs) \
-	     dat_extension_op(  ep, \
-				DAT_IB_RDMA_WRITE_IMMED_OP, \
-				(size), \
-				(lbuf), \
-				(cookie), \
-				(rbuf), \
-				(idata), \
-				(flgs))
+	dat_extension_op(\
+		IN (DAT_EP_HANDLE) (ep), \
+		IN (DAT_IB_OP) DAT_IB_RDMA_WRITE_IMMED_OP, \
+		IN (DAT_COUNT) (size), \
+		IN (DAT_LMR_TRIPLET *) (lbuf), \
+		IN (cookie), \
+		IN (DAT_RMR_TRIPLET *) (rbuf), \
+		IN (DAT_UINT32) (idata), \
+		IN (DAT_COMPLETION_FLAGS) (flgs))
 
 /* 
  * Unreliable datagram: msg send 
@@ -471,14 +610,21 @@ dat_strerror_ext_status (
  *	n/a
  */
 #define dat_ib_post_send_ud(ep, segments, lbuf, ah_ptr, cookie, flgs) \
-	     dat_extension_op(  ep, \
-				DAT_IB_UD_SEND_OP, \
-				(segments), \
-				(lbuf), \
-				(ah_ptr), \
-				(cookie), \
-				(flgs))
+	dat_extension_op(\
+		IN (DAT_EP_HANDLE) (ep), \
+		IN (DAT_IB_OP) DAT_IB_UD_SEND_OP, \
+		IN (DAT_COUNT) (segments), \
+		IN (DAT_LMR_TRIPLET *) (lbuf), \
+		IN (DAT_IB_ADDR_HANDLE *) (ah_ptr), \
+		IN (cookie), \
+		IN (DAT_COMPLETION_FLAGS) (flgs))
 
+/* 
+ * Unreliable datagram: msg recv 
+ *
+ * Mapping to standard EP post call.
+ */
+#define dat_ib_post_recv_ud	dat_ep_post_recv
 
 /* 
  * Query counter(s):  
@@ -487,12 +633,13 @@ dat_strerror_ext_status (
  *
  * use _ALL_COUNTERS to query all
  */
-#define dat_query_counters(dat_handle, cntr, p_cntrs_out, reset) \
-	     dat_extension_op(  dat_handle, \
-				DAT_QUERY_COUNTERS_OP, \
-				(cntr), \
-				(p_cntrs_out), \
-				(reset))
+#define dat_ib_query_counters(dat_handle, cntr, p_cntrs_out, reset) \
+	dat_extension_op(\
+		IN (DAT_HANDLE) dat_handle, \
+		IN (DAT_IB_OP) DAT_QUERY_COUNTERS_OP, \
+		IN (int) (cntr), \
+		IN (DAT_UINT64 *) (p_cntrs_out), \
+		IN (int) (reset))
 /* 
  * Print counter(s):  
  * Provide IA, EP, or EVD and call will print appropriate counters
@@ -500,11 +647,427 @@ dat_strerror_ext_status (
  * 
  * use _ALL_COUNTERS to print all
  */
-#define dat_print_counters(dat_handle, cntr, reset) \
-	     dat_extension_op(  dat_handle, \
-				DAT_PRINT_COUNTERS_OP, \
-				(cntr), \
-				(reset))
+#define dat_ib_print_counters(dat_handle, cntr, reset) \
+	dat_extension_op(\
+		IN (DAT_HANDLE) dat_handle, \
+		IN (DAT_IB_OP) DAT_PRINT_COUNTERS_OP, \
+		IN (int) (cntr), \
+		IN (int) (reset))
+
+/*
+ ************************ MPI IB Collective Functions ***********************
+ */
+
+/* MPI collective member and group setup functions */
+
+/*
+ * This synchronous call creates and returns local member
+ * address information for a collective device or provider
+ * for each rank. The size of the member address information
+ * is dependent on the collective device or provider.
+ * This address information, for each rank, must be exchanged
+ * and used for group creation on all ranks.
+ */
+#define dat_ib_collective_create_member(ia_handle, progress_func, member, member_size) \
+	dat_extension_op(\
+		IN  (DAT_IA_HANDLE) (ia_handle), \
+		IN  (DAT_IB_OP) DAT_IB_COLLECTIVE_CREATE_MEMBER_OP, \
+		IN  (void *) (progress_func), \
+		OUT (DAT_IB_COLLECTIVE_MEMBER *) (member), \
+		OUT (DAT_UINT32 *) (member_size))
+
+/*
+ * This synchronous call destroys a previously created member
+ * information associated with the this device ia_handle argument.
+ */
+#define dat_ib_collective_free_member(ia_handle, member) \
+	dat_extension_op(\
+		IN (DAT_IA_HANDLE) (ia_handle), \
+		IN (DAT_IB_OP) DAT_IB_COLLECTIVE_FREE_MEMBER_OP, \
+		IN (DAT_IB_COLLECTIVE_MEMBER) (member))
+
+/*
+ * This asynchronous call initiates the process of creating a collective
+ * group and must be called by all group members. The collective_group
+ * argument points to an array of address/connection qualifier pairs that
+ * identify the members of the group in rank order. The group_size argument
+ * specifies the size of the group and therefore the size of the coll_group
+ * array. The self argument identifies the rank of the caller.
+ * The group_id argument specifies a network-unique identifier for this
+ * instance of the collective group. The group_info provides global and local
+ * rank and process information. All members of the group must specify
+ * the same group_id value for the same collective instance. The evd_handle
+ * argument specifies the EVD used for all asynchronous collective completions
+ * including this call. The user_context argument will be returned in the
+ * DAT_EXT_COLLECTIVE_CREATE_DATA event.
+ *
+ * On a successful completion, each group member will receive a
+ * DAT_EXT_COLLECTIVE_CREATE_DATA event on the EVD specified by evd_handle.
+ * The event contains the collective handle, the rank of the receiving
+ * Endpoint within the collective group, the size of the group, and the
+ * caller specified user_context. The returned collective handle can be used
+ * in network clock, Multicast, and other collective operations.
+ *
+ * RETURN VALUE: DAT_RETURN
+ */
+#define dat_ib_collective_create_group(members, group_size, self, group_id, group_info, evd, pd, user_context) \
+	dat_extension_op(\
+		IN (DAT_EVD_HANDLE) (evd), \
+		IN (DAT_IB_OP) DAT_IB_COLLECTIVE_CREATE_GROUP_OP, \
+		IN (DAT_IB_COLLECTIVE_MEMBER *) (members), \
+		IN (DAT_COUNT) (group_size), \
+		IN (DAT_IB_COLLECTIVE_RANK) (self), \
+		IN (DAT_IB_COLLECTIVE_ID) (group_id), \
+		IN (DAT_IB_COLLECTIVE_GROUP *) (group_info), \
+		IN (DAT_PZ_HANDLE) (pd), \
+		IN (DAT_CONTEXT) (user_context))
+
+/*
+ * This synchronous call destroys a previously created collective group
+ * associated with the collective_handle argument. Any pending or
+ * in-process requests associated with the collective group will be
+ * terminated and be posted to the appropriate EVD.
+ *
+ * RETURN VALUE: DAT_RETURN
+ */
+#define dat_ib_collective_free_group(coll_handle) \
+	dat_extension_op(\
+		IN (DAT_IB_COLLECTIVE_HANDLE) (coll_handle), \
+		IN (DAT_IB_OP) DAT_IB_COLLECTIVE_FREE_GROUP_OP)
+
+
+/* MPI collective data operations */
+
+/*
+ * This call sets the network clock associated with
+ * collective_handle. A provider implementation may keep a single
+ * global clock for all collective handles. When this is the case,
+ * this call sets an adjustment for the given handle so that
+ * subsequent calls to read the clock will be relative to the value
+ * specified by clock_value. This is an asynchronous call that
+ * completes on the collective EVD. The network clock will not be
+ * synchronized until the request is completed. Any member of the
+ * collective can set the clock and only one member should make
+ * this call on behave of the entire collective.
+ */
+#define dat_ib_collective_set_clock(coll_handle, clock_value, user_context ) \
+	dat_extension_op( \
+		IN (DAT_IB_COLLECTIVE_HANDLE) (coll_handle), \
+		IN (DAT_IB_OP) DAT_IB_COLLECTIVE_READ_CLOCK_OP, \
+		IN (DAT_UINT64) (clock_value), \
+		IN (DAT_CONTEXT) (user_contex))
+
+/*
+ * This synchronous call returns the current value of the network clock
+ * associated with the given collective handle. This is a light weight
+ * call to minimize skew
+ */
+#define dat_ib_collective_read_clock(coll_handle, clock_value ) \
+	dat_extension_op( \
+		IN  (DAT_IB_COLLECTIVE_HANDLE) (coll_handle), \
+		IN  (DAT_IB_OP) DAT_IB_COLLECTIVE_READ_CLOCK_OP, \
+		OUT (DAT_UINT64 *) clock_value))
+
+/*
+ * This call performs a scatter of the data specified by the
+ * send_buffer argument to the collective group specified by coll_handle.
+ * Data is received in the buffer specified by the recv_buffer argument.
+ * The recv_byte_count argument specifies the size of the receive buffer.
+ * Data from the root send_buffer will be divided by the number of members
+ * in the collective group to form equal and contiguous memory partitions.
+ * Each member of the collective group will receive its rank relative
+ * partition. An error is returned if the send_byte_count does not describe
+ * memory that can be evenly divided by the size of the collective group.
+ * An "in place" transfer for the root rank can be indicated by passing NULL
+ * as the recv_buffer argument. The send_buffer and send_byte_count
+ * arguments are ignored on non-root members. The operation is completed on
+ * the collective EVD unless completions are suppressed through the
+ * completion flags.
+ */
+#define dat_ib_collective_scatter(coll_handle, sendbuf, sendsize, recvbuf, recvsize, root, user_context, flags) \
+	dat_extension_op( \
+		IN (DAT_IB_COLLECTIVE_HANDLE) (coll_handle), \
+		IN (DAT_IB_OP) DAT_IB_COLLECTIVE_SCATTER_OP, \
+		IN (DAT_PVOID) (sendbuf), \
+		IN (DAT_COUNT) (sendsize), \
+		IN (DAT_PVOID) (recvbuf), \
+		IN (DAT_COUNT) (recvsize), \
+		IN (DAT_IB_COLLECTIVE_RANK) (root), \
+		IN (DAT_CONTEXT) (user_context), \
+		IN (DAT_COMPLETION_FLAGS) (flags))
+
+/*
+ * This call performs a non-uniform scatter of the data
+ * specified by the send_buffers array argument to the collective group
+ * specified by coll_handle. The send_buffers array contains one buffer
+ * pointer for each member of the collective group, in rank order.
+ * The send_byte_counts array contains a byte count for each corresponding
+ * send buffer pointer. The recv_buffer and recev_byte_count arguments
+ * specify where received portions of the scatter are to be received.
+ * An "in place" transfer for the root rank can be indicated by passing
+ * NULL as the recv_buffer argument. The send_buffers and send_byte_counts
+ * arguments are ignored on non-root members. The operation is completed
+ * on the collective EVD unless completions are suppressed through the
+ * completion flags.
+ *
+ */
+#define dat_ib_collective_scatterv(coll_handle, sendbuf, sendsizes, displs, recvbuf, recvsize, root, user_context, flags) \
+	dat_extension_op( \
+		IN (DAT_IB_COLLECTIVE_HANDLE) (coll_handle), \
+		IN (DAT_IB_OP) DAT_IB_COLLECTIVE_SCATTERV_OP, \
+		IN (DAT_PVOID) (sendbuf), \
+		IN (DAT_COUNT *) (sendsizes), \
+		IN (DAT_COUNT *) (displs), \
+		IN (DAT_PVOID) (recvbuf), \
+		IN (DAT_COUNT) (recvsize), \
+		IN (DAT_IB_COLLECTIVE_RANK) (root), \
+		IN (DAT_CONTEXT) (user_context), \
+		IN (DAT_COMPLETION_FLAGS) (flags))
+
+/*
+ * This call performs a gather of the data sent by all
+ * members of the collective specified by the collective_handle argument.
+ * The data to be sent is specified by the send_buffer and send_byte_count
+ * arguments. Data is received by the collective member specified by the
+ * root argument in the buffer specified by the recv_buffer and
+ * recv_byte_count arguments.  Data is placed into the receive buffer in
+ * collective rank order.  An "in place" transfer for the root rank can
+ * be indicated by passing NULL as the send_buffer argument.
+ * The recv_buffer and recv_byte_count arguments are ignored on non-root
+ * members.  The operation is completed on the collective EVD unless
+ * completions are suppressed through the completion flags.
+ */
+#define dat_ib_collective_gather(coll_handle, sendbuf, sendsize, recvbuf, recvsize, root, user_context, flags) \
+	dat_extension_op( \
+		IN (DAT_IB_COLLECTIVE_HANDLE) (coll_handle), \
+		IN (DAT_IB_OP) DAT_IB_COLLECTIVE_GATHER_OP, \
+		IN (DAT_PVOID) (sendbuf), \
+		IN (DAT_COUNT) (sendsize), \
+		IN (DAT_PVOID) (recvbuf), \
+		IN (DAT_COUNT) (recvsize), \
+		IN (DAT_IB_COLLECTIVE_RANK) (root), \
+		IN (DAT_CONTEXT) (user_context), \
+		IN (DAT_COMPLETION_FLAGS)(flags))
+
+/*
+ * This call performs a non-uniform gather of the data sent by
+ * all members of the collective specified by the collective_handle argument.
+ * The data to be sent is specified by the send_buffer and send_byte_count
+ * arguments.  Data is received by the collective member specified by the
+ * root argument into the buffers specified by the recv_buffers and
+ * recv_byte_counts array arguments.  Data is placed into the receive buffer
+ * associated with the rank that sent it. An "in place" transfer for the root
+ * rank can be indicated by passing NULL as the send_buffer argument.
+ * The recv_buffers and recv_byte_counts arguments are ignored on non-root
+ * members.  The operation is completed on the collective EVD unless
+ * completions are suppressed through the completion flags.
+ */
+#define dat_ib_collective_gatherv(coll_handle, sendbuf, sendsize, recvbufs, recvsizes, displs, root, user_context, flags) \
+	dat_extension_op( \
+		(DAT_IB_COLLECTIVE_HANDLE)(coll_handle), \
+		IN (DAT_IB_OP) DAT_IB_COLLECTIVE_GATHERV_OP, \
+		IN (DAT_PVOID) (sendbuf), \
+		IN (DAT_COUNT) (sendsize), \
+		IN (DAT_PVOID) (recvbuf), \
+		IN (DAT_COUNT *) (recvsizes), \
+		IN (DAT_COUNT *) (displs), \
+		IN (DAT_IB_COLLECTIVE_RANK) (root), \
+		IN (DAT_CONTEXT) (user_context), \
+		IN (DAT_COMPLETION_FLAGS) (flags))
+
+/*
+ * This call is equivalent to having all members of a collective
+ * group perform a dat_collective_gather() as the root.  This results in all
+ * members of the collective having identical contents in their receive buffer
+ */
+#define dat_ib_collective_allgather(coll_handle, sendbuf, sendsize, recvbuf, recvsize, user_context, flags) \
+	dat_extension_op( \
+		(DAT_IB_COLLECTIVE_HANDLE)(coll_handle), \
+		IN (DAT_IB_OP) DAT_IB_COLLECTIVE_ALLGATHER_OP, \
+		IN (DAT_PVOID) (sendbuf), \
+		IN (DAT_COUNT) (sendsize), \
+		IN (DAT_PVOID) (recvbuf), \
+		IN (DAT_COUNT) (recvsize), \
+		IN (DAT_CONTEXT) (user_context), \
+		IN (DAT_COMPLETION_FLAGS) (flags))
+
+/*
+ * This call performs a non-uniform dat_collective_allgather()
+ * operation.  It is equivalent to having all members of a collective group
+ * perform a dat_collective_gatherv() as the root.  This results in all
+ * members of the collective having identical contents in their receive
+ * buffer.
+ */
+#define dat_ib_collective_allgatherv(coll_handle, sendbuf, sendsize, recvbuf, recvsizes, displs, user_context, flags) \
+	dat_extension_op( \
+		(DAT_IB_COLLECTIVE_HANDLE)(coll_handle), \
+		IN (DAT_IB_OP) DAT_IB_COLLECTIVE_ALLGATHERV_OP, \
+		IN (DAT_PVOID) (sendbuf), \
+		IN (DAT_COUNT) (sendsize), \
+		IN (DAT_PVOID) (recvbuf), \
+		IN (DAT_COUNT *) (recvsizes), \
+		IN (DAT_COUNT *) (displs), \
+		IN (DAT_CONTEXT) (user_context), \
+		IN (DAT_COMPLETION_FLAGS) (flags))
+
+/*
+ * This call is an extension of dat_collective_allgather()
+ * to the case where each member sends distinct data specified by send_buffer
+ * to each of the other members. The jth block sent from rank i is received
+ * by rank j and is placed in the ith block of recv_buffer.
+ */
+#define dat_ib_collective_alltoall(coll_handle, sendbuf, sendsize, recvbuf, recvsize, user_context, flags) \
+	dat_extension_op( \
+		(DAT_IB_COLLECTIVE_HANDLE)(coll_handle), \
+		IN (DAT_IB_OP) DAT_IB_COLLECTIVE_ALLTOALL_OP, \
+		IN (DAT_PVOID) (sendbuf), \
+		IN (DAT_COUNT) (sendsize), \
+		IN (DAT_PVOID) (recvbuf), \
+		IN (DAT_COUNT) (recvsize), \
+		IN (DAT_CONTEXT) (user_context), \
+		IN (DAT_COMPLETION_FLAGS) (flags))
+
+/*
+ * This call performs a non-uniform dat_collective_alltoall() operation
+ */
+#define dat_ib_collective_alltoallv(coll_handle, sendbuf, sendsizes, senddspls, recvbuf, recvsizes, recvdispls, user_context, flags) \
+	dat_extension_op( \
+		(DAT_IB_COLLECTIVE_HANDLE)(coll_handle), \
+		IN (DAT_IB_OP) DAT_IB_COLLECTIVE_ALLTOALLV_OP, \
+		IN (DAT_PVOID) (sendbuf), \
+		IN (DAT_COUNT *) (sendsizes), \
+		IN (DAT_COUNT *) (senddispls), \
+		IN (DAT_PVOID) (recvbuf), \
+		IN (DAT_COUNT *) (recvsizes), \
+		IN (DAT_COUNT *) (recvdispls), \
+		IN (DAT_CONTEXT) (user_context), \
+		IN (DAT_COMPLETION_FLAGS) (flags))
+
+/*
+ * This call combines the elements of the data type specified
+ * by data_type from the buffer specified by send_buffer of all members of
+ * the collective by performing the operation specified by reduce_operation
+ * and placing the result into the buffer of the root member specified by
+ * recv_buffer. It is an error to specify a floating point type with
+ * any of the logical reduction operators.When using the REDUCE_OP_MINLOC
+ * and REDUCE_OP _MAXLOC operations, it is assumed that the input and output
+ * buffers contain pair values where the first member of the pair is of the
+ * type specified by data_type followed by a COLLECTIVE_TYPE_UINT32 type.
+ * When the reduction is complete, the receive buffer will contain the
+ * MIN/MAX value in the first member of the pair with the first member rank
+ * that contained it in the second member of the pair.  The tables below
+ * show the result of a REDUCE_OP_SUM reduce operation.
+ */
+#define dat_ib_collective_reduce(coll_handle, sendbuf, sendsize, recvbuf, recvsize, op, type, root, user_context, flags) \
+	dat_extension_op( \
+		IN (DAT_IB_COLLECTIVE_HANDLE)(coll_handle), \
+		IN (DAT_IB_OP) DAT_IB_COLLECTIVE_REDUCE_OP, \
+		IN (DAT_PVOID) (sendbuf), \
+		IN (DAT_COUNT) (sendsize), \
+		IN (DAT_PVOID) (recvbuf), \
+		IN (DAT_COUNT) (recvsize), \
+		IN (DAT_IB_COLLECTIVE_REDUCE_DATA_OP) (op), \
+		IN (DAT_IB_COLLECTIVE_DATA_TYPE) (type), \
+		IN (DAT_IB_COLLECTIVE_RANK) (root), \
+		IN (DAT_CONTEXT) (user_context), \
+		IN (DAT_COMPLETION_FLAGS) (flags))
+
+/*
+ * This call is identical to the dat_collective_reduce()
+ * call with the exception that the recv_buffer and recv_byte_count arguments
+ * are valid for all members of the collective and all members of will
+ * receive the reduction results.
+ */
+#define dat_ib_collective_allreduce(coll_handle, sendbuf, sendsize, recvbuf, recvsize, op, type, user_context, flags) \
+	dat_extension_op( \
+		IN (DAT_IB_COLLECTIVE_HANDLE) (coll_handle), \
+		IN (DAT_IB_OP) DAT_IB_COLLECTIVE_ALLREDUCE_OP, \
+		IN (DAT_PVOID) (sendbuf), \
+		IN (DAT_COUNT) (sendsize), \
+		IN (DAT_PVOID) (recvbuf), \
+		IN (DAT_COUNT) (recvsize), \
+		IN (DAT_IB_COLLECTIVE_REDUCE_DATA_OP) (op), \
+		IN (DAT_IB_COLLECTIVE_DATA_TYPE) (type), \
+		IN (DAT_CONTEXT) (user_context), \
+		IN (DAT_COMPLETION_FLAGS) (flags))
+/*
+ * This call is identical to rank 0 of the collective calling
+ * this dat_collective_reduce() followed by dat_collective_scatterv().
+ * The number of bytes received in the scatter for each rank is determined
+ * by rank offset into the recv_byte_counts array.
+ */
+#define dat_ib_collective_reduce_scatter(coll_handle, sendbuf, sendsize, recvbuf, recvsizes, op, type, user_context, flags) \
+	dat_extension_op( \
+		IN (DAT_IB_COLLECTIVE_HANDLE) (coll_handle), \
+		IN (DAT_IB_OP) DAT_IB_COLLECTIVE_REDUCE_SCATTER_OP, \
+		IN (DAT_PVOID) (sendbuf), \
+		IN (DAT_COUNT) (sendsize), \
+		IN (DAT_PVOID) (recvbuf), \
+		IN (DAT_COUNT *) (recvsizes), \
+		IN (DAT_IB_COLLECTIVE_REDUCE_DATA_OP) (op), \
+		IN (DAT_IB_COLLECTIVE_DATA_TYPE) (type), \
+		IN (DAT_CONTEXT) (user_context), \
+		IN (DAT_COMPLETION_FLAGS) (flags))
+
+/*
+ * This call is used to perform a prefix reduction on data
+ * distributed across the group. The operation returns, in recv_buffer of
+ * the member with rank i, the reduction of the values in send_buffer of
+ * members with ranks 0,...,i (inclusive). The tables below show the
+ * result of a REDUCE_OP_SUM scan operation.
+ */
+#define dat_ib_collective_scan(coll_handle, sendbuf, sendsize, recvbuf, recvsize, op, type, user_context, flags) \
+	dat_extension_op( \
+		IN (DAT_IB_COLLECTIVE_HANDLE) (coll_handle), \
+		IN (DAT_IB_OP) DAT_IB_COLLECTIVE_SCAN_OP, \
+		IN (DAT_PVOID) (sendbuf), \
+		IN (DAT_COUNT) (sendsize), \
+		IN (DAT_PVOID) (recvbuf), \
+		IN (DAT_COUNT) (recvsize), \
+		IN (DAT_IB_COLLECTIVE_REDUCE_DATA_OP) (op), \
+		IN (DAT_IB_COLLECTIVE_DATA_TYPE) (type), \
+		IN (DAT_CONTEXT) (user_context), \
+		IN (DAT_COMPLETION_FLAGS) (flags))
+
+/*
+ * This call performs a broadcast send operation that transfers
+ * data specified by the buffer argument of the root into the buffer argument
+ * of all other Endpoints in the collective group specified by coll_handle.
+ * The operation is completed on the collective EVD unless completions are
+ * suppressed through the completion flags.  All broadcasts are considered
+ * o?=in placeo?= transfers.  The tables below show the result of a broadcast
+ * operation.
+ */
+#define dat_ib_collective_broadcast(coll_handle, buf, size, root, user_context, flags) \
+	dat_extension_op(\
+		IN (DAT_IB_COLLECTIVE_HANDLE) (coll_handle), \
+		IN (DAT_IB_OP) DAT_IB_COLLECTIVE_BROADCAST_OP, \
+		IN (DAT_PVOID) (buf), \
+		IN (DAT_COUNT) (size), \
+		IN (DAT_IB_COLLECTIVE_RANK) (root), \
+		IN (DAT_CONTEXT) (user_context), \
+		IN (DAT_COMPLETION_FLAGS) (flags))
+
+/*
+ * This call will synchronize all endpoints of the collective
+ * group specified by coll_handle. This is an asynchronous call that
+ * will post a completion to the collective EVD when all endpoints
+ * have synchronized.
+ */
+#define dat_ib_collective_barrier(coll_handle, user_context, flags) \
+	dat_extension_op( \
+		IN (DAT_IB_COLLECTIVE_HANDLE) (coll_handle), \
+		IN (DAT_IB_OP) DAT_IB_COLLECTIVE_BARRIER_OP, \
+		IN (DAT_CONTEXT) (user_context), \
+		IN (DAT_COMPLETION_FLAGS) (flags))
+
+
+/* Backward compatibility */
+#define DAT_ATTR_COUNTERS DAT_IB_ATTR_COUNTERS
+#define dat_query_counters dat_ib_query_counters	
+#define dat_print_counters dat_ib_print_counters
+#define DAT_QUERY_COUNTERS_OP DAT_IB_QUERY_COUNTERS_OP
+#define DAT_PRINT_COUNTERS_OP DAT_IB_PRINT_COUNTERS_OP
 
 #endif /* _DAT_IB_EXTENSIONS_H_ */
 
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
