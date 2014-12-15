From: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/3] extension: add IB UD extensions to reduce provider CM and AH memory footprint
Date: Mon, 15 Dec 2014 10:11:37 -0800
Message-ID: <1418667099-32449-2-git-send-email-arlin.r.davis@intel.com>
References: <1418667099-32449-1-git-send-email-arlin.r.davis@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418667099-32449-1-git-send-email-arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

dat_ib_ud_cm_free, dat_ib_ud_ah_free added to allow consumers
the option to free provider CM and AH objects, related to AH resolution,
immediately after consuming CONN events instead of waiting for
EP destroy. With existing UD service providers the CM and AH objects
are linked to EP and not destroyed until consumer calls dat_ep_free.

dat_ib_ud_cm_free() frees CM object after AH and private data are copied
and stored by consumer. Provider will destroy internal object
and memory associated with CM and AH resolution.
MAY be called after CM establishment and before EP destroyed

dat_ib_ud_ah_free() destroys UD Address Handle (AH).
MUST be called after all UD sends are complete and
before UD EP is destroyed.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_common/ib_extensions.c   |   40 ++++++++++++++++++++++++++++
 dat/include/dat2/dat_ib_extensions.h |   47 +++++++++++++++++++++++++++++++---
 2 files changed, 83 insertions(+), 4 deletions(-)

diff --git a/dapl/openib_common/ib_extensions.c b/dapl/openib_common/ib_extensions.c
index 339dae7..fc03d9c 100644
--- a/dapl/openib_common/ib_extensions.c
+++ b/dapl/openib_common/ib_extensions.c
@@ -188,6 +188,46 @@ dapl_extensions(IN DAT_HANDLE dat_handle,
 					OP_SEND_UD, comp_flags, ah);
 		break;
 
+	case DAT_IB_UD_CM_FREE_OP:
+	{
+		ib_cm_srvc_handle_t cm;
+
+		dapl_dbg_log(DAPL_DBG_TYPE_RTN,
+			     " UD cm_free extension call\n");
+
+		ep = dat_handle;
+		cm = (ib_cm_srvc_handle_t) va_arg(args, DAT_UINT64);
+
+		if (DAPL_BAD_HANDLE(ep, DAPL_MAGIC_EP))
+			status = DAT_ERROR(DAT_INVALID_HANDLE,
+					   DAT_INVALID_HANDLE_EP);
+		else {
+			cm->ah = NULL; /* consumer will free AH */
+			status = dapls_ud_cm_free(ep, cm);
+		}
+		break;
+	}
+	case DAT_IB_UD_AH_FREE_OP:
+	{
+		DAT_IB_ADDR_HANDLE *dat_ah;
+		int ret;
+
+		dapl_dbg_log(DAPL_DBG_TYPE_RTN,
+			     " UD ah_free extension call\n");
+
+		ep = dat_handle;
+		dat_ah = va_arg(args, DAT_IB_ADDR_HANDLE *);
+
+		if (DAPL_BAD_HANDLE(ep, DAPL_MAGIC_EP)) {
+			status = DAT_ERROR(DAT_INVALID_HANDLE,
+					   DAT_INVALID_HANDLE_EP);
+		} else {
+			errno = 0;
+			ret = ibv_destroy_ah(dat_ah->ah);
+			status = dapl_convert_errno(errno, "destroy_ah");
+		}
+		break;
+	}
 #ifdef DAPL_COUNTERS
 	case DAT_QUERY_COUNTERS_OP:
 		{
diff --git a/dat/include/dat2/dat_ib_extensions.h b/dat/include/dat2/dat_ib_extensions.h
index 31e7f48..94ded25 100755
--- a/dat/include/dat2/dat_ib_extensions.h
+++ b/dat/include/dat2/dat_ib_extensions.h
@@ -75,9 +75,9 @@
  * 2.0.6 - Add MPI over IB collective extensions
  * 2.0.7 - Add new IA counters for dapl CM, device LINK, device DIAG
  * 2.0.8 - Add DAT_IB_OPEN_QUERY_OP, DAT_IB_CLOSE_QUERY_OP, fast provider query interface
- *
+ * 2.0.9 - Add DAT_IB_UD_CM_FREE and DAT_IB_UD_AH_FREE
  */
-#define DAT_IB_EXTENSION_VERSION	208	/* 2.0.8 */
+#define DAT_IB_EXTENSION_VERSION	209	/* 2.0.9 */
 #define DAT_IB_ATTR_COUNTERS		"DAT_COUNTERS"
 #define DAT_IB_ATTR_FETCH_AND_ADD	"DAT_IB_FETCH_AND_ADD"
 #define DAT_IB_ATTR_CMP_AND_SWAP	"DAT_IB_CMP_AND_SWAP"
@@ -155,6 +155,8 @@ typedef enum dat_ib_op
 	DAT_IB_COLLECTIVE_BARRIER_OP,
 	DAT_IB_START_COUNTERS_OP,
 	DAT_IB_STOP_COUNTERS_OP,
+	DAT_IB_UD_CM_FREE_OP,
+	DAT_IB_UD_AH_FREE_OP,
 	/* OPEN and CLOSE extensions require DAT support, set proper range */
 	DAT_IB_OPEN_QUERY_OP  = DAT_OPEN_EXTENSION_BASE,
 	DAT_IB_CLOSE_QUERY_OP = DAT_CLOSE_EXTENSION_BASE,
@@ -317,8 +319,12 @@ typedef struct dat_ib_collective_event_data
  * NOTE: DAT_IB_EXTENSION_EVENT_DATA cannot exceed 64 bytes as defined by 
  *	 "DAT_UINT64 extension_data[8]" in DAT_EVENT (dat.h)
  *
- *  Provide UD address handles via extended connect establishment. 
- *  ia_addr provided with extended conn events for reference.
+ *  DAT_IB_UD_CONNECTION_EVENT_ESTABLISHED
+ *    UD address and CM handles via extended UD connect establishment.
+ *    	ia_addr provided with extended conn events for reference.
+ *    	CM handle provided via context, for dat_ib_ud_cm_release().
+ *      AH provided via remote_ah, for dat_ib_ud_ah_destroy().
+ *      NOTE: if CM released, AH must be destroy before dat_ep_free.
  */
 typedef struct dat_ib_extension_event_data
 {
@@ -331,6 +337,7 @@ typedef struct dat_ib_extension_event_data
 	    DAT_IB_ADDR_HANDLE			remote_ah;
 	    DAT_IB_COLLECTIVE_EVENT_DATA	coll;
     };
+    DAT_CONTEXT		context;
 
 } DAT_IB_EXTENSION_EVENT_DATA;
 
@@ -706,6 +713,38 @@ dat_strerror_ext_status (
 #define dat_ib_post_recv_ud	dat_ep_post_recv
 
 /* 
+ * Unreliable datagram: free CM
+ *
+ * This call frees CM object after AH and private data are copied
+ * and stored by consumer. Provider will destroy internal object
+ * and memory associated with CM and AH resolution. MAY be called
+ * after CM establishment and before EP destroyed
+ *
+ * Other extension flags:
+ *	n/a
+ */
+#define dat_ib_ud_cm_free(ep, cm) \
+	dat_extension_op(\
+		IN (DAT_EP_HANDLE) (ep), \
+		IN (DAT_IB_OP) DAT_IB_UD_CM_FREE_OP, \
+		IN (DAT_CONTEXT) (cm))
+
+/*
+ * Unreliable datagram: free AH
+ *
+ * This call frees UD Address Handle (AH). MUST be called after all UD sends
+ * are complete and before UD EP is destroyed.
+ *
+ * Other extension flags:
+ *	n/a
+ */
+#define dat_ib_ud_ah_free(ep, ah) \
+	dat_extension_op(\
+		IN (DAT_EP_HANDLE) (ep), \
+		IN (DAT_IB_OP) DAT_IB_UD_AH_FREE_OP, \
+		IN (DAT_IB_ADDR_HANDLE *) (ah))
+
+ /*
  * Query counter(s):  
  * Provide IA, EP, or EVD and call will return appropriate counters
  * 	DAT_HANDLE dat_handle, enum cntr, *DAT_UINT64 p_cntrs_out, int reset
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
