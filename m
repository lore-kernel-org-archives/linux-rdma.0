From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 05/28] IB/srpt: Disable RDMA access by the initiator
Date: Wed,  3 Jan 2018 13:39:15 -0800
Message-ID: <20180103213938.11664-6-bart.vanassche@wdc.com>
References: <20180103213938.11664-1-bart.vanassche@wdc.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180103213938.11664-1-bart.vanassche@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

With the SRP protocol all RDMA operations are initiated by the target.
Since no RDMA operations are initiated by the initiator, do not grant
the initiator permission to submit RDMA reads or writes to the target.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: <stable@vger.kernel.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 8a1bd354b1cc..7c4249038004 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1013,8 +1013,7 @@ static int srpt_init_ch_qp(struct srpt_rdma_ch *ch, struct ib_qp *qp)
 		return -ENOMEM;
 
 	attr->qp_state = IB_QPS_INIT;
-	attr->qp_access_flags = IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_READ |
-	    IB_ACCESS_REMOTE_WRITE;
+	attr->qp_access_flags = IB_ACCESS_LOCAL_WRITE;
 	attr->port_num = ch->sport->port;
 	attr->pkey_index = 0;
 
-- 
2.15.1
