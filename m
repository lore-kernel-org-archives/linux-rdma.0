From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 2/3] IB/srpt: Fix srpt_cm_req_recv() error path (2/2)
Date: Tue, 10 Jul 2018 10:31:59 -0700
Message-ID: <20180710173200.19853-3-bart.vanassche@wdc.com>
References: <20180710173200.19853-1-bart.vanassche@wdc.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180710173200.19853-1-bart.vanassche@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

If a login request was received through the RDMA/CM and if an
error occurs during login, clear rdma_cm_id->context instead of
ib_cm_id->context.

Fixes: 63cf1a902c9d ("IB/srpt: Add RDMA/CM support")
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: <stable@vger.kernel.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index e95d0c1c0652..325bae29e90d 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2361,8 +2361,11 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
 	srpt_free_ioctx_ring((struct srpt_ioctx **)ch->ioctx_ring,
 			     ch->sport->sdev, ch->rq_size,
 			     ch->max_rsp_size, DMA_TO_DEVICE);
+
 free_ch:
-	if (ib_cm_id)
+	if (rdma_cm_id)
+		rdma_cm_id->context = NULL;
+	else
 		ib_cm_id->context = NULL;
 	kfree(ch);
 	ch = NULL;
-- 
2.18.0
