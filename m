From: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: [PATCH 5/5] IB/hfi1: Improve another size determination in
 hfi1_user_sdma_process_request()
Date: Fri, 10 Feb 2017 22:05:40 +0100
Message-ID: <ee953516-99a1-133c-9c6b-45838698a235@users.sourceforge.net>
References: <8a997282-09c7-0f9f-645e-d7c6e8c79e67@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8a997282-09c7-0f9f-645e-d7c6e8c79e67-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Date: Fri, 10 Feb 2017 21:45:38 +0100

Replace the specification of a data structure by a reference to
the desired member as the parameter for the operator "sizeof" to make
the corresponding size determination a bit safer according to
the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/user_sdma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 5a73d738f2ba..da131a530b88 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -704,7 +704,9 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 	/* Save all the IO vector structures */
 	for (i = 0; i < req->data_iovs; i++) {
 		INIT_LIST_HEAD(&req->iovs[i].list);
-		memcpy(&req->iovs[i].iov, iovec + idx++, sizeof(struct iovec));
+		memcpy(&req->iovs[i].iov,
+		       iovec + idx++,
+		       sizeof(req->iovs[i].iov));
 		ret = pin_vector_pages(req, &req->iovs[i]);
 		if (ret) {
 			req->status = ret;
-- 
2.11.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
