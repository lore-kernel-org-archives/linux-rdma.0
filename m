From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v1 rdma-next 8/9] i40iw: Validate correct IRD/ORD connection parameters
Date: Fri, 22 Dec 2017 14:29:31 -0600
Message-ID: <20171222202932.9324-9-shiraz.saleem@intel.com>
References: <20171222202932.9324-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171222202932.9324-1-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Casting to u16 before validating IRD/ORD connection
parameters could cause recording wrong IRD/ORD values
in the cm_node. Validate the IRD/ORD parameters as
they are passed by the application before recording
them.

Fixes: f27b4746f378 ("i40iw: add connection management code")
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index 7810642..34cc335 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -120,7 +120,7 @@ static u8 i40iw_derive_hw_ird_setting(u16 cm_ird)
  * @conn_ird: connection IRD
  * @conn_ord: connection ORD
  */
-static void i40iw_record_ird_ord(struct i40iw_cm_node *cm_node, u16 conn_ird, u16 conn_ord)
+static void i40iw_record_ird_ord(struct i40iw_cm_node *cm_node, u32 conn_ird, u32 conn_ord)
 {
 	if (conn_ird > I40IW_MAX_IRD_SIZE)
 		conn_ird = I40IW_MAX_IRD_SIZE;
@@ -3842,7 +3842,7 @@ int i40iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	}
 
 	cm_node->apbvt_set = true;
-	i40iw_record_ird_ord(cm_node, (u16)conn_param->ird, (u16)conn_param->ord);
+	i40iw_record_ird_ord(cm_node, conn_param->ird, conn_param->ord);
 	if (cm_node->send_rdma0_op == SEND_RDMA_READ_ZERO &&
 	    !cm_node->ord_size)
 		cm_node->ord_size = 1;
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
