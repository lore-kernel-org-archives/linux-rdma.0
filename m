From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] IB/cma: Use inner P_Key to determine netdev
Date: Mon, 19 Oct 2015 21:09:25 +0300
Message-ID: <1445278165-18442-1-git-send-email-haggaie@mellanox.com>
References: <56252F7B.4000300@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56252F7B.4000300-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When discussing the patches to demux ids in rdma_cm instead of ib_cm, it
was decided that it is best to use the P_Key value in the packet headers
[1]. However, some drivers are currently unable to send correct P_Key in
GMP headers.

Change the rdma_cm code to look at the P_Key value that is part of the
packet payload as a workaround. Once the drivers are fixed this patch can
be reverted.

Fixes: 4c21b5bcef73 ("IB/cma: Add net_dev and private data checks to
RDMA CM")
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 59a2dafc8c57..e8324543e085 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1067,14 +1067,14 @@ static int cma_save_req_info(const struct ib_cm_event *ib_event,
 		       sizeof(req->local_gid));
 		req->has_gid	= true;
 		req->service_id	= req_param->primary_path->service_id;
-		req->pkey	= req_param->bth_pkey;
+		req->pkey	= be16_to_cpu(req_param->primary_path->pkey);
 		break;
 	case IB_CM_SIDR_REQ_RECEIVED:
 		req->device	= sidr_param->listen_id->device;
 		req->port	= sidr_param->port;
 		req->has_gid	= false;
 		req->service_id	= sidr_param->service_id;
-		req->pkey	= sidr_param->bth_pkey;
+		req->pkey	= sidr_param->pkey;
 		break;
 	default:
 		return -EINVAL;
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
