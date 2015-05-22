From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/5] dapl ucm: check for AH caching when destroying via UD
 extension
Date: Fri, 22 May 2015 21:43:06 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F977D76B90@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_common/ib_extensions.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/dapl/openib_common/ib_extensions.c b/dapl/openib_common/ib_extensions.c
index fc03d9c..25db541 100644
--- a/dapl/openib_common/ib_extensions.c
+++ b/dapl/openib_common/ib_extensions.c
@@ -202,7 +202,6 @@ dapl_extensions(IN DAT_HANDLE dat_handle,
 			status = DAT_ERROR(DAT_INVALID_HANDLE,
 					   DAT_INVALID_HANDLE_EP);
 		else {
-			cm->ah = NULL; /* consumer will free AH */
 			status = dapls_ud_cm_free(ep, cm);
 		}
 		break;
@@ -210,6 +209,7 @@ dapl_extensions(IN DAT_HANDLE dat_handle,
 	case DAT_IB_UD_AH_FREE_OP:
 	{
 		DAT_IB_ADDR_HANDLE *dat_ah;
+		uint16_t lid;
 		int ret;
 
 		dapl_dbg_log(DAPL_DBG_TYPE_RTN,
@@ -222,8 +222,18 @@ dapl_extensions(IN DAT_HANDLE dat_handle,
 			status = DAT_ERROR(DAT_INVALID_HANDLE,
 					   DAT_INVALID_HANDLE_EP);
 		} else {
+			lid = ntohs(((union dcm_addr *)&dat_ah->ia_addr)->ib.lid);
+
+			if (lid > DCM_AH_SPACE) {
+				status = DAT_ERROR(DAT_INVALID_PARAMETER,
+						   DAT_INVALID_ARG2);
+				break;
+			}
+
 			errno = 0;
-			ret = ibv_destroy_ah(dat_ah->ah);
+			if (!((DAPL_EP *)ep)->qp_handle->ah[lid])
+				ret = ibv_destroy_ah(dat_ah->ah);
+
 			status = dapl_convert_errno(errno, "destroy_ah");
 		}
 		break;
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
