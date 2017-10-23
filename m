From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 7/7] IB/hfi1: Take advantage of kvzalloc_node in
 sdma initialization
Date: Mon, 23 Oct 2017 06:06:32 -0700
Message-ID: <20171023130629.21191.43615.stgit@scvm10.sc.intel.com>
References: <20171023125327.21191.31462.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171023125327.21191.31462.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The code that allocates the tx ring in the sdma code fails to take
advantage of kvzalloc variations.

Fix by converting to use kvzalloc_node.

Reported-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/sdma.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index e7df779..a059049 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -1465,13 +1465,8 @@ int sdma_init(struct hfi1_devdata *dd, u8 port)
 		if (!sde->descq)
 			goto bail;
 		sde->tx_ring =
-			kcalloc(descq_cnt, sizeof(struct sdma_txreq *),
-				GFP_KERNEL);
-		if (!sde->tx_ring)
-			sde->tx_ring =
-				vzalloc(
-					sizeof(struct sdma_txreq *) *
-					descq_cnt);
+			kvzalloc_node(sizeof(struct sdma_txreq *) * descq_cnt,
+				      GFP_KERNEL, dd->node);
 		if (!sde->tx_ring)
 			goto bail;
 	}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
