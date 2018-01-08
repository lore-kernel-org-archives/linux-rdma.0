From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 08/12] IB/srpt: Convert a warning into a debug message
Date: Mon,  8 Jan 2018 11:00:47 -0800
Message-ID: <20180108190051.32008-9-bart.vanassche@wdc.com>
References: <20180108190051.32008-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180108190051.32008-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

At least when running the ib_srpt driver on top of the rdma_rxe
driver it is easy to trigger a zero-length write completion in
the CH_DISCONNECTED state. Hence make the message that reports
this less noisy.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 25c5e188c740..31b6f108dffb 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -875,7 +875,8 @@ static void srpt_zerolength_write_done(struct ib_cq *cq, struct ib_wc *wc)
 		if (srpt_set_ch_state(ch, CH_DISCONNECTED))
 			schedule_work(&ch->release_work);
 		else
-			WARN_ONCE(1, "%s-%d\n", ch->sess_name, ch->qp->qp_num);
+			pr_debug("%s-%d: already disconnected.\n",
+				 ch->sess_name, ch->qp->qp_num);
 	}
 }
 
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
