From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 2/7] IB/srp: Fix a memory descriptor leak in an error path
Date: Thu, 12 May 2016 10:48:13 -0700
Message-ID: <5734C1DD.80702@sandisk.com>
References: <5734C181.2020003@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5734C181.2020003-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If an error occurs after srp_fr_pool_get() succeeded and before the
descriptor is stored in srp_map_state (*state->fr.next++ = desc)
then srp_unmap_data() won't free the newly allocated memory
descriptor. Hence free the descriptor explicitly.

Fixes: f7f7aab1a5c0 ("IB/srp: Convert to new registration API")
Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Tested-by: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sai-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v4.4+
---
 drivers/infiniband/ulp/srp/ib_srp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index e088a49..74e3ec8 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1330,8 +1330,13 @@ static int srp_map_finish_fr(struct srp_map_state *state,
 	ib_update_fast_reg_key(desc->mr, rkey);
 
 	n = ib_map_mr_sg(desc->mr, state->sg, sg_nents, 0, dev->mr_page_size);
-	if (unlikely(n < 0))
+	if (unlikely(n < 0)) {
+		srp_fr_pool_put(ch->fr_pool, &desc, 1);
+		pr_debug("%s: ib_map_mr_sg(%d) returned %d.\n",
+			 dev_name(&req->scmnd->device->sdev_gendev), sg_nents,
+			 n);
 		return n;
+	}
 
 	req->reg_cqe.done = srp_reg_mr_err_done;
 
-- 
2.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
