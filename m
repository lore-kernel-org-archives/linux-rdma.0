From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/9] dapl-2.0: scm: remove modify QP to ERR state during
 disconnect on UD type QP
Date: Wed, 19 May 2010 11:23:08 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983C70130D0@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Patch set of bug fixes as a result of scale-out testing on 128 nodes/1538 cores.

1/9 scm: remove modify QP to ERR state during disconnect on UD type QP
2/9 ucm: increase default UCM retry count for connect reply to 15
3/9 cma, ucm: cleanup issues with dat_ep_free on a connected EP without disconnecting.
4/9 ucm: UD mode, active side cm object released to soon, the RTU could be lost.
5/9 scm: SOCKOPT ERR Connection timed out on large clusters
6/9 scm: cr_thread occasionally segv's when disconnecting all-to-all MPI static connections
7/9 scm: add option to use other network devices with environment variable DAPL_SCM_NETDEV
8/9 scm, cma: fini code can be called multiple times and hang via fork
9/9 scm: check for hca object before signaling thread

The disconnect on a UD type QP should not modify QP to error
since this is a shared QP. The disconnect should be treated
as a NOP on the UD type QP and only be transitioned during
the QP destroy (dat_ep_free).

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_scm/cm.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/dapl/openib_scm/cm.c b/dapl/openib_scm/cm.c
index afd0d93..7465190 100644
--- a/dapl/openib_scm/cm.c
+++ b/dapl/openib_scm/cm.c
@@ -458,13 +458,13 @@ DAT_RETURN dapli_socket_disconnect(dp_ib_cm_handle_t cm_ptr)
 	dapl_os_unlock(&cm_ptr->lock);
 	
 	/* send disc date, close socket, schedule destroy */
-	dapl_os_lock(&cm_ptr->ep->header.lock);
-	dapls_modify_qp_state(cm_ptr->ep->qp_handle, IBV_QPS_ERR, 0,0,0);
-	dapl_os_unlock(&cm_ptr->ep->header.lock);
 	send(cm_ptr->socket, (char *)&disc_data, sizeof(disc_data), 0);
 
 	/* disconnect events for RC's only */
 	if (cm_ptr->ep->param.ep_attr.service_type == DAT_SERVICE_TYPE_RC) {
+		dapl_os_lock(&cm_ptr->ep->header.lock);
+		dapls_modify_qp_state(cm_ptr->ep->qp_handle, IBV_QPS_ERR, 0,0,0);
+		dapl_os_unlock(&cm_ptr->ep->header.lock);
 		if (cm_ptr->ep->cr_ptr) {
 			dapls_cr_callback(cm_ptr,
 					  IB_CME_DISCONNECTED,
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
