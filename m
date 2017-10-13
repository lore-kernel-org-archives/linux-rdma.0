From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/hfi1: Fix a wrapping test (make it less strict)
Date: Fri, 13 Oct 2017 13:56:02 +0300
Message-ID: <20171013105559.tqzh6jhcnvmqhdwy@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The "2 * UINT_MAX" overflows so the test is essentially doing this:

	if ((u64)(ts - cce->timestamp) > UINT_MAX - 1) {

I've changed it to a 64bit type.

Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
Not tested.

diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index f4c0ffc040cc..3aeea8afd44f 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -3781,7 +3781,7 @@ static int __subn_get_opa_hfi1_cong_log(struct opa_smp *smp, u32 am,
 		 * required to wrap the counter are supposed to
 		 * be zeroed (CA10-49 IBTA, release 1.2.1, V1).
 		 */
-		if ((u64)(ts - cce->timestamp) > (2 * UINT_MAX))
+		if ((u64)(ts - cce->timestamp) > (2ULL * UINT_MAX))
 			continue;
 		memcpy(cong_log->events[i].local_qp_cn_entry, &cce->lqpn, 3);
 		memcpy(cong_log->events[i].remote_qp_number_cn_entry,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
