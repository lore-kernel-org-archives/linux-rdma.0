From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH] IB/srp: Avoid that sg_reset -d ${srp_device} triggers an infinite loop
Date: Mon, 17 Sep 2018 18:10:05 -0700
Message-ID: <20180918011005.8275-1-bvanassche@acm.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>, Max Gurtovoy <maxg@mellanox.com>, Laurence Oberman <loberman@redhat.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Use different loop variables for the inner and outer loop. This avoids
that an infinite loop occurs if there are more RDMA channels than
target->req_ring_size.

Fixes: d92c0da71a35 ("IB/srp: Add multichannel support")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Max Gurtovoy <maxg@mellanox.com>
Cc: Laurence Oberman <loberman@redhat.com>
Cc: <stable@vger.kernel.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 444d16520506..0b34e909505f 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2951,7 +2951,7 @@ static int srp_reset_device(struct scsi_cmnd *scmnd)
 {
 	struct srp_target_port *target = host_to_target(scmnd->device->host);
 	struct srp_rdma_ch *ch;
-	int i;
+	int i, j;
 	u8 status;
 
 	shost_printk(KERN_ERR, target->scsi_host, "SRP reset_device called\n");
@@ -2965,8 +2965,8 @@ static int srp_reset_device(struct scsi_cmnd *scmnd)
 
 	for (i = 0; i < target->ch_count; i++) {
 		ch = &target->ch[i];
-		for (i = 0; i < target->req_ring_size; ++i) {
-			struct srp_request *req = &ch->req_ring[i];
+		for (j = 0; j < target->req_ring_size; ++j) {
+			struct srp_request *req = &ch->req_ring[j];
 
 			srp_finish_req(ch, req, scmnd->device, DID_RESET << 16);
 		}
-- 
2.18.0
