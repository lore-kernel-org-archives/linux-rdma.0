From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 07/28] IB/srpt: Remove an unused structure member
Date: Wed,  3 Jan 2018 13:39:17 -0800
Message-ID: <20180103213938.11664-8-bart.vanassche@wdc.com>
References: <20180103213938.11664-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180103213938.11664-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fixes: commit a42d985bd5b2 ("ib_srpt: Initial SRP Target merge for v3.3-rc1")
Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 1 -
 drivers/infiniband/ulp/srpt/ib_srpt.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index bfa576aa9f03..81e8085bc5bb 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1123,7 +1123,6 @@ static struct srpt_send_ioctx *srpt_get_send_ioctx(struct srpt_rdma_ch *ch)
 	ioctx->state = SRPT_STATE_NEW;
 	ioctx->n_rdma = 0;
 	ioctx->n_rw_ctx = 0;
-	init_completion(&ioctx->tx_done);
 	ioctx->queue_status_only = false;
 	/*
 	 * transport_init_se_cmd() does not initialize all fields, so do it
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 673387d365a3..7fff73a5d1e6 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -207,7 +207,6 @@ struct srpt_send_ioctx {
 	spinlock_t		spinlock;
 	enum srpt_command_state	state;
 	struct se_cmd		cmd;
-	struct completion	tx_done;
 	u8			n_rdma;
 	u8			n_rw_ctx;
 	bool			queue_status_only;
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
