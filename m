From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 15/26] rdma/cm: fixup white space
Date: Thu, 1 Apr 2010 10:08:41 -0700
Message-ID: <D6E0EA95CF7C431B9307EABCF454543D@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
References: 
In-Reply-To: 
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fix a white space issue that bug me.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/infiniband/core/cma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index cc35872..0432eca 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1655,7 +1655,7 @@ static int cma_query_ib_route(struct rdma_id_private *id_priv, int timeout_ms,
 	path_rec.numb_path = 1;
 	path_rec.reversible = 1;
 	path_rec.service_id = cma_get_service_id(id_priv->id.ps,
-							(struct sockaddr *) &addr->dst_addr);
+						 (struct sockaddr *) &addr->dst_addr);
 
 	comp_mask = IB_SA_PATH_REC_DGID | IB_SA_PATH_REC_SGID |
 		    IB_SA_PATH_REC_PKEY | IB_SA_PATH_REC_NUMB_PATH |



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
