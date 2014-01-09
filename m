From: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v1 for-next 15/15] IB/usnic: Fix false log
Date: Thu,  9 Jan 2014 14:47:43 -0800
Message-ID: <1389307663-11296-16-git-send-email-umalhi@cisco.com>
References: <1389307663-11296-1-git-send-email-umalhi@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389307663-11296-1-git-send-email-umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

usNIC is falsing printing an error if usnic_ib_qp_grp_modify
succeeds.

Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_ib_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infiniband/hw/usnic/usnic_ib_main.c
index bbe614b..dc09c12 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
@@ -115,7 +115,7 @@ static void usnic_ib_qp_grp_modify_active_to_err(struct usnic_ib_dev *us_ibdev)
 				status = usnic_ib_qp_grp_modify(qp_grp,
 								IB_QPS_ERR,
 								NULL);
-				if (!status) {
+				if (status) {
 					usnic_err("Failed to transistion qp grp %u from %s to %s\n",
 						qp_grp->grp_id,
 						usnic_ib_qp_grp_state_to_string
-- 
1.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
