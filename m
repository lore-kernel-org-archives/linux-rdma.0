From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 10/10] IB/cma: Print warning on different inner and header P_Keys
Date: Mon, 29 Feb 2016 15:45:12 +0200
Message-ID: <1456753512-17688-11-git-send-email-haggaie@mellanox.com>
References: <1456753512-17688-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456753512-17688-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Commit 4c21b5bcef73 ("IB/cma: Add net_dev and private data checks to RDMA
CM") added checks for incoming RDMA CM requests that they can be matched to
a netdev based on the P_Key in the BTH of the request. This behavior was
reverted in commit ab3964ad2acf ("IB/cma: Use inner P_Key to determine
netdev"), since the mlx5 and ipath drivers didn't send the correct value
in the BTH P_Key.

Since the ipath driver was removed, and the mlx5 driver can now send GSI
packets on different P_Keys, we could revert the patch to let the rdma_cm
module look on the BTH P_Key when deciding to what netdev a packet belongs.
However, that still breaks compatibility with the older drivers.

Change the behavior to print a warning when receiving a request that has a
different BTH P_Key and inner payload P_Key. In the future, after users
have seen the warnings and upgraded their setups, remove the warning and
block these requests.

Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 9729639df407..7eace1ffa74d 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1206,6 +1206,10 @@ static int cma_save_req_info(const struct ib_cm_event *ib_event,
 		req->has_gid	= true;
 		req->service_id	= req_param->primary_path->service_id;
 		req->pkey	= be16_to_cpu(req_param->primary_path->pkey);
+		if (req->pkey != req_param->bth_pkey)
+			pr_warn_ratelimited("RDMA CMA: got different BTH P_Key (0x%x) and primary path P_Key (0x%x)\n"
+					    "RDMA CMA: in the future this may cause the request to be dropped\n",
+					    req_param->bth_pkey, req->pkey);
 		break;
 	case IB_CM_SIDR_REQ_RECEIVED:
 		req->device	= sidr_param->listen_id->device;
@@ -1213,6 +1217,10 @@ static int cma_save_req_info(const struct ib_cm_event *ib_event,
 		req->has_gid	= false;
 		req->service_id	= sidr_param->service_id;
 		req->pkey	= sidr_param->pkey;
+		if (req->pkey != sidr_param->bth_pkey)
+			pr_warn_ratelimited("RDMA CMA: got different BTH P_Key (0x%x) and SIDR request payload P_Key (0x%x)\n"
+					    "RDMA CMA: in the future this may cause the request to be dropped\n",
+					    sidr_param->bth_pkey, req->pkey);
 		break;
 	default:
 		return -EINVAL;
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
