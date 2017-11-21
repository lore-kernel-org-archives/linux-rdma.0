From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 1/7] i40iw: Use sqsize to initialize cqp_requests elements
Date: Tue, 21 Nov 2017 12:44:56 -0600
Message-ID: <20171121184502.14056-2-henry.orosco@intel.com>
References: <20171121184502.14056-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171121184502.14056-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Use sqsize instead of I40IW_CQP_SW_SQSIZE_2048 to initialize
cqp_requests elements in the for-loop as sqsize is used
to allocate memory for cqp_requests.

Fixes: 8e06af711bf2 ("i40iw: add main, hdr, status")
Signed-off-by: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index e824296..1f9d9c7 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -607,7 +607,7 @@ static enum i40iw_status_code i40iw_create_cqp(struct i40iw_device *iwdev)
 	INIT_LIST_HEAD(&cqp->cqp_avail_reqs);
 	INIT_LIST_HEAD(&cqp->cqp_pending_reqs);
 	/* init the waitq of the cqp_requests and add them to the list */
-	for (i = 0; i < I40IW_CQP_SW_SQSIZE_2048; i++) {
+	for (i = 0; i < sqsize; i++) {
 		init_waitqueue_head(&cqp->cqp_requests[i].waitq);
 		list_add_tail(&cqp->cqp_requests[i].list, &cqp->cqp_avail_reqs);
 	}
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
