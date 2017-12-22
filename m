From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-next 7/9] i40iw: Ignore LLP_DOUBT_REACHABILITY AE
Date: Fri, 22 Dec 2017 09:47:00 -0600
Message-ID: <20171222154702.12632-8-shiraz.saleem@intel.com>
References: <20171222154702.12632-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171222154702.12632-1-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The LLP_DOUBT_REACHABILITY Asynchronous Event (AE) is an early
warning of a connection issue. It is followed by LLP_TOO_MANY_RETRIES
AE, if the retransmit threshold is reached and recovery is not possible
for the connection.

Currently we terminate the connection on receiving the
LLP_DOUBT_REACHABILITY AE. Ignore this AE and
terminate the connection only on LLP_TOO_MANY_RETRIES AE.

This improves the user experience on cable disconnect/reconnect
scenario while running iWARP traffic. On cable disconnect,
the QP traffic is paused and the user has a larger and more
reasonable timeout within which if the cable is reconnected,
traffic can continue.

Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_hw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_hw.c b/drivers/infiniband/hw/i40iw/i40iw_hw.c
index e96bdaf..61540e1 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_hw.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_hw.c
@@ -385,6 +385,8 @@ void i40iw_process_aeq(struct i40iw_device *iwdev)
 				iwcq->ibcq.event_handler(&ibevent, iwcq->ibcq.cq_context);
 			}
 			break;
+		case I40IW_AE_LLP_DOUBT_REACHABILITY:
+			break;
 		case I40IW_AE_PRIV_OPERATION_DENIED:
 		case I40IW_AE_STAG_ZERO_INVALID:
 		case I40IW_AE_IB_RREQ_AND_Q1_FULL:
@@ -403,7 +405,6 @@ void i40iw_process_aeq(struct i40iw_device *iwdev)
 		case I40IW_AE_LLP_SEGMENT_TOO_SMALL:
 		case I40IW_AE_LLP_SYN_RECEIVED:
 		case I40IW_AE_LLP_TOO_MANY_RETRIES:
-		case I40IW_AE_LLP_DOUBT_REACHABILITY:
 		case I40IW_AE_LCE_QP_CATASTROPHIC:
 		case I40IW_AE_LCE_FUNCTION_CATASTROPHIC:
 		case I40IW_AE_LCE_CQ_CATASTROPHIC:
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
