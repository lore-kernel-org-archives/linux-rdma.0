From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 09/12] IB/srpt: Reduce frequency of receive failure messages
Date: Mon,  8 Jan 2018 11:00:48 -0800
Message-ID: <20180108190051.32008-10-bart.vanassche@wdc.com>
References: <20180108190051.32008-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180108190051.32008-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Disabling an SRP target port causes the state of all QPs associated
with a port to be changed into IB_QPS_ERR. Avoid that this causes
one error message per I/O context to be reported.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 31b6f108dffb..6f5a4d66eacc 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1622,8 +1622,8 @@ static void srpt_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			pr_err("req_lim = %d < 0\n", req_lim);
 		srpt_handle_new_iu(ch, ioctx, NULL);
 	} else {
-		pr_info("receiving failed for ioctx %p with status %d\n",
-			ioctx, wc->status);
+		pr_info_ratelimited("receiving failed for ioctx %p with status %d\n",
+				    ioctx, wc->status);
 	}
 }
 
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
