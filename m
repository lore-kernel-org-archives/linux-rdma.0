From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] uDAPL v2.0: common: qp modify RTR using wrong ep attribute
 parameter for dest_rd_atomic
Date: Tue, 4 Jan 2011 17:03:06 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C983011F10C34E@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

max_rdma_read_in should be used instead of max_rdma_read_out

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_common/qp.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/dapl/openib_common/qp.c b/dapl/openib_common/qp.c
index 1e5b6d4..1826362 100644
--- a/dapl/openib_common/qp.c
+++ b/dapl/openib_common/qp.c
@@ -458,7 +458,7 @@ dapls_modify_qp_state(IN ib_qp_handle_t		qp_handle,
 		qp_attr.rq_psn = 1;
 		qp_attr.path_mtu = ia_ptr->hca_ptr->ib_trans.mtu;
 		qp_attr.max_dest_rd_atomic =
-			ep_ptr->param.ep_attr.max_rdma_read_out;
+			ep_ptr->param.ep_attr.max_rdma_read_in;
 		qp_attr.min_rnr_timer =
 			ia_ptr->hca_ptr->ib_trans.rnr_timer;
 
@@ -564,6 +564,16 @@ dapls_modify_qp_state(IN ib_qp_handle_t		qp_handle,
 		ep_ptr->qp_state = qp_state;
 		return DAT_SUCCESS;
 	} else {
+		dapl_log(DAPL_DBG_TYPE_ERR,
+			" RTR ERR: type %d qpn 0x%x gid %p (%d) lid 0x%x"
+			" port %d state %d mtu %d rd %d rnr %d sl %d\n",
+			qp_handle->qp_type, ntohl(qpn), gid,
+			ia_ptr->hca_ptr->ib_trans.global,
+			ntohs(lid), ia_ptr->hca_ptr->port_num,
+			ep_ptr->qp_state,
+			qp_attr.path_mtu, qp_attr.max_dest_rd_atomic,
+			qp_attr.min_rnr_timer, qp_attr.ah_attr.sl);
+
 		return (dapl_convert_errno(errno, "modify_qp_state"));
 	}
 }
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
