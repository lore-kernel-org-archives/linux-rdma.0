From: Bhaktipriya Shridhar <bhaktipriya96-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC] IB/srp: Remove create_workqueue
Date: Tue, 7 Jun 2016 23:46:17 +0530
Message-ID: <20160607181617.GA6556@Karyakshetra>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

alloc_workqueue replaces deprecated create_workqueue().

A dedicated workqueue has been used since the workqueue srp_remove_wq with
workitem &target->remove_work, is a work queue for the SRP target removal.
WQ_MEM_RECLAIM has been set to ensure forward progress under memory
pressure.
Since there are only a fixed number of work items, explicit
concurrency limit is unnecessary here.

Is the workqueue being used on a memory reclaim path?
Does it require WQ_MEM_RECLAIM?

Thanks.

Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 646de17..1730d1f 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3685,7 +3685,7 @@ static int __init srp_init_module(void)
 		indirect_sg_entries = cmd_sg_entries;
 	}

-	srp_remove_wq = create_workqueue("srp_remove");
+	srp_remove_wq = alloc_workqueue("srp_remove", WQ_MEM_RECLAIM, 0);
 	if (!srp_remove_wq) {
 		ret = -ENOMEM;
 		goto out;
--
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
