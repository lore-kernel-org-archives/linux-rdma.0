From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 01/12] i40iw: Cleanup AE processing
Date: Mon, 16 Oct 2017 15:45:54 -0500
Message-ID: <20171016204605.37512-2-shiraz.saleem@intel.com>
References: <20171016204605.37512-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171016204605.37512-1-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Remove unimplemented Asynchronous Events (AE) and correct names.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c |  5 -----
 drivers/infiniband/hw/i40iw/i40iw_d.h    | 10 ++--------
 drivers/infiniband/hw/i40iw/i40iw_hw.c   |  2 +-
 3 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
index d1f5345..4597cf4 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
@@ -4376,10 +4376,6 @@ static int i40iw_bld_terminate_hdr(struct i40iw_sc_qp *qp,
 		i40iw_setup_termhdr(qp, termhdr, FLUSH_REM_ACCESS_ERR,
 				    (LAYER_RDMA << 4) | RDMAP_REMOTE_PROT, RDMAP_TO_WRAP);
 		break;
-	case I40IW_AE_LLP_RECEIVED_MARKER_AND_LENGTH_FIELDS_DONT_MATCH:
-		i40iw_setup_termhdr(qp, termhdr, FLUSH_LOC_LEN_ERR,
-				    (LAYER_MPA << 4) | DDP_LLP, MPA_MARKER);
-		break;
 	case I40IW_AE_LLP_RECEIVED_MPA_CRC_ERROR:
 		i40iw_setup_termhdr(qp, termhdr, FLUSH_GENERAL_ERR,
 				    (LAYER_MPA << 4) | DDP_LLP, MPA_CRC);
@@ -4395,7 +4391,6 @@ static int i40iw_bld_terminate_hdr(struct i40iw_sc_qp *qp,
 				    (LAYER_DDP << 4) | DDP_CATASTROPHIC, DDP_CATASTROPHIC_LOCAL);
 		break;
 	case I40IW_AE_DDP_INVALID_MSN_GAP_IN_MSN:
-	case I40IW_AE_DDP_INVALID_MSN_RANGE_IS_NOT_VALID:
 		i40iw_setup_termhdr(qp, termhdr, FLUSH_GENERAL_ERR,
 				    (LAYER_DDP << 4) | DDP_UNTAGGED_BUFFER, DDP_UNTAGGED_INV_MSN_RANGE);
 		break;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_d.h b/drivers/infiniband/hw/i40iw/i40iw_d.h
index 2ebaadb..dc319e9 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_d.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_d.h
@@ -1636,7 +1636,8 @@ enum i40iw_alignment {
 #define I40IW_AE_AMP_MWBIND_INVALID_BOUNDS                              0x0119
 #define I40IW_AE_AMP_MWBIND_TO_INVALID_PARENT                           0x011a
 #define I40IW_AE_AMP_MWBIND_BIND_DISABLED                               0x011b
-#define I40IW_AE_AMP_WQE_INVALID_PARAMETER                              0x0130
+#define I40IW_AE_UDA_XMIT_DGRAM_TOO_LONG                                0x0132
+#define I40IW_AE_UDA_XMIT_DGRAM_TOO_SHORT                               0x0134
 #define I40IW_AE_BAD_CLOSE                                              0x0201
 #define I40IW_AE_RDMAP_ROE_BAD_LLP_CLOSE                                0x0202
 #define I40IW_AE_CQ_OPERATION_ERROR                                     0x0203
@@ -1644,12 +1645,10 @@ enum i40iw_alignment {
 #define I40IW_AE_RDMA_READ_WHILE_ORD_ZERO                               0x0205
 #define I40IW_AE_STAG_ZERO_INVALID                                      0x0206
 #define I40IW_AE_IB_RREQ_AND_Q1_FULL                                    0x0207
-#define I40IW_AE_SRQ_LIMIT                                              0x0209
 #define I40IW_AE_WQE_UNEXPECTED_OPCODE                                  0x020a
 #define I40IW_AE_WQE_INVALID_PARAMETER                                  0x020b
 #define I40IW_AE_WQE_LSMM_TOO_LONG                                      0x0220
 #define I40IW_AE_DDP_INVALID_MSN_GAP_IN_MSN                             0x0301
-#define I40IW_AE_DDP_INVALID_MSN_RANGE_IS_NOT_VALID                     0x0302
 #define I40IW_AE_DDP_UBE_DDP_MESSAGE_TOO_LONG_FOR_AVAILABLE_BUFFER      0x0303
 #define I40IW_AE_DDP_UBE_INVALID_DDP_VERSION                            0x0304
 #define I40IW_AE_DDP_UBE_INVALID_MO                                     0x0305
@@ -1663,12 +1662,10 @@ enum i40iw_alignment {
 #define I40IW_AE_INVALID_ARP_ENTRY                                      0x0401
 #define I40IW_AE_INVALID_TCP_OPTION_RCVD                                0x0402
 #define I40IW_AE_STALE_ARP_ENTRY                                        0x0403
-#define I40IW_AE_INVALID_WQE_LENGTH                                     0x0404
 #define I40IW_AE_INVALID_MAC_ENTRY                                      0x0405
 #define I40IW_AE_LLP_CLOSE_COMPLETE                                     0x0501
 #define I40IW_AE_LLP_CONNECTION_RESET                                   0x0502
 #define I40IW_AE_LLP_FIN_RECEIVED                                       0x0503
-#define I40IW_AE_LLP_RECEIVED_MARKER_AND_LENGTH_FIELDS_DONT_MATCH       0x0504
 #define I40IW_AE_LLP_RECEIVED_MPA_CRC_ERROR                             0x0505
 #define I40IW_AE_LLP_SEGMENT_TOO_LARGE                                  0x0506
 #define I40IW_AE_LLP_SEGMENT_TOO_SMALL                                  0x0507
@@ -1685,9 +1682,6 @@ enum i40iw_alignment {
 #define I40IW_AE_LCE_QP_CATASTROPHIC                                    0x0700
 #define I40IW_AE_LCE_FUNCTION_CATASTROPHIC                              0x0701
 #define I40IW_AE_LCE_CQ_CATASTROPHIC                                    0x0702
-#define I40IW_AE_UDA_XMIT_FRAG_SEQ                                      0x0800
-#define I40IW_AE_UDA_XMIT_DGRAM_TOO_LONG                                0x0801
-#define I40IW_AE_UDA_XMIT_IPADDR_MISMATCH                               0x0802
 #define I40IW_AE_QP_SUSPEND_COMPLETE                                    0x0900
 
 #define OP_DELETE_LOCAL_MAC_IPADDR_ENTRY        1
diff --git a/drivers/infiniband/hw/i40iw/i40iw_hw.c b/drivers/infiniband/hw/i40iw/i40iw_hw.c
index 7e9de84..e96bdaf 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_hw.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_hw.c
@@ -408,7 +408,7 @@ void i40iw_process_aeq(struct i40iw_device *iwdev)
 		case I40IW_AE_LCE_FUNCTION_CATASTROPHIC:
 		case I40IW_AE_LCE_CQ_CATASTROPHIC:
 		case I40IW_AE_UDA_XMIT_DGRAM_TOO_LONG:
-		case I40IW_AE_UDA_XMIT_IPADDR_MISMATCH:
+		case I40IW_AE_UDA_XMIT_DGRAM_TOO_SHORT:
 			ctx_info->err_rq_idx_valid = false;
 			/* fall through */
 		default:
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
