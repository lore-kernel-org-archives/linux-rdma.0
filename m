From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 3/3] IB/srp: Delete unwanted spaces behind usages of the
 sizeof operator
Date: Sat, 8 Apr 2017 14:13:45 +0200
Message-ID: <8ce69cd6-d8fb-3468-1629-611f2fa76eff@users.sourceforge.net>
References: <50db1f1d-b689-1a9d-f6dd-a0f55169c75a@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <50db1f1d-b689-1a9d-f6dd-a0f55169c75a@users.sourceforge.net>
Content-Language: en-GB
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 8 Apr 2017 13:56:33 +0200

Replace the source code "sizeof (" by "sizeof("
according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index bc934c5f1e36..0229328e65e3 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1628,7 +1628,7 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 	u8 fmt;
 
 	if (!scsi_sglist(scmnd) || scmnd->sc_data_direction == DMA_NONE)
-		return sizeof (struct srp_cmd);
+		return sizeof(struct srp_cmd);
 
 	if (scmnd->sc_data_direction != DMA_FROM_DEVICE &&
 	    scmnd->sc_data_direction != DMA_TO_DEVICE) {
@@ -1649,7 +1649,7 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 		return -EIO;
 
 	fmt = SRP_DATA_DESC_DIRECT;
-	len = sizeof (struct srp_cmd) +	sizeof (struct srp_direct_buf);
+	len = sizeof(struct srp_cmd) + sizeof(struct srp_direct_buf);
 
 	if (count == 1 && (pd->flags & IB_PD_UNSAFE_GLOBAL_RKEY)) {
 		/*
@@ -1722,15 +1722,15 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 	}
 
 	count = min(state.ndesc, target->cmd_sg_cnt);
-	table_len = state.ndesc * sizeof (struct srp_direct_buf);
+	table_len = state.ndesc * sizeof(struct srp_direct_buf);
 	idb_len = sizeof(struct srp_indirect_buf) + table_len;
 
 	fmt = SRP_DATA_DESC_INDIRECT;
-	len = sizeof(struct srp_cmd) + sizeof (struct srp_indirect_buf);
-	len += count * sizeof (struct srp_direct_buf);
+	len = sizeof(struct srp_cmd) + sizeof(struct srp_indirect_buf);
+	len += count * sizeof(struct srp_direct_buf);
 
 	memcpy(indirect_hdr->desc_list, req->indirect_desc,
-	       count * sizeof (struct srp_direct_buf));
+	       count * sizeof(struct srp_direct_buf));
 
 	if (!(pd->flags & IB_PD_UNSAFE_GLOBAL_RKEY)) {
 		ret = srp_map_idb(ch, req, state.gen.next, state.gen.end,
@@ -3300,7 +3300,7 @@ static ssize_t srp_create_target(struct device *dev,
 	bool multich = false;
 
 	target_host = scsi_host_alloc(&srp_template,
-				      sizeof (struct srp_target_port));
+				      sizeof(struct srp_target_port));
 	if (!target_host)
 		return -ENOMEM;
 
@@ -3383,10 +3383,10 @@ static ssize_t srp_create_target(struct device *dev,
 	target->mr_pool_size = target->scsi_host->can_queue * mr_per_cmd;
 	target->mr_per_cmd = mr_per_cmd;
 	target->indirect_size = target->sg_tablesize *
-				sizeof (struct srp_direct_buf);
-	target->max_iu_len = sizeof (struct srp_cmd) +
-			     sizeof (struct srp_indirect_buf) +
-			     target->cmd_sg_cnt * sizeof (struct srp_direct_buf);
+				sizeof(struct srp_direct_buf);
+	target->max_iu_len = sizeof(struct srp_cmd) +
+			     sizeof(struct srp_indirect_buf) +
+			     target->cmd_sg_cnt * sizeof(struct srp_direct_buf);
 
 	INIT_WORK(&target->tl_err_work, srp_tl_err_work);
 	INIT_WORK(&target->remove_work, srp_remove_work);
-- 
2.12.2

