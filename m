From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 6/7] i40iw: Move MPA request event for loopback after connect
Date: Tue, 21 Nov 2017 12:45:01 -0600
Message-ID: <20171121184502.14056-7-henry.orosco@intel.com>
References: <20171121184502.14056-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171121184502.14056-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

For loopback, MPA request event is generated when cm_node
is initialized, which allows applications to act on the
connect request before i40iw_connect() has completed.
In some cases, the reject flow executes in parallel with
the connect flow and doesn't delete an APBVT entry,
because the apbvt_set variable is still not set by the
connect flow. Move the MPA request event to the end of
i40iw_connect() to notify application for a connect
request, after connect has completed.

Fixes: f27b4746f378 ("i40iw: add connection management code")
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index e145417..3a35d56 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -2947,8 +2947,6 @@ static struct i40iw_cm_node *i40iw_create_cm_node(
 			loopback_remotenode->tcp_cntxt.snd_wnd = cm_node->tcp_cntxt.rcv_wnd;
 			cm_node->tcp_cntxt.snd_wscale = loopback_remotenode->tcp_cntxt.rcv_wscale;
 			loopback_remotenode->tcp_cntxt.snd_wscale = cm_node->tcp_cntxt.rcv_wscale;
-			loopback_remotenode->state = I40IW_CM_STATE_MPAREQ_RCVD;
-			i40iw_create_event(loopback_remotenode, I40IW_CM_EVENT_MPA_REQ);
 		}
 		return cm_node;
 	}
@@ -3864,6 +3862,11 @@ int i40iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 			goto err;
 	}
 
+	if (cm_node->loopbackpartner) {
+		cm_node->loopbackpartner->state = I40IW_CM_STATE_MPAREQ_RCVD;
+		i40iw_create_event(cm_node->loopbackpartner, I40IW_CM_EVENT_MPA_REQ);
+	}
+
 	i40iw_debug(cm_node->dev,
 		    I40IW_DEBUG_CM,
 		    "Api - connect(): port=0x%04x, cm_node=%p, cm_id = %p.\n",
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
