From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH] ib_srp: Avoid that LUN scanning creates duplicate devices
Date: Sat, 25 Jun 2011 10:10:30 +0200
Message-ID: <201106251010.30994.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

SCSI scanning of a channel:id:lun triplet in Linux works as follows (function
scsi_scan_target() in drivers/scsi/scsi_scan.c):
- If lun == SCAN_WILD_CARD, send a REPORT LUNS command to the target and
  process the result.
- If lun != SCAN_WILD_CARD, send an INQUIRY command to the LUN corresponding
  to the specified channel:id:lun triplet to verify whether the LUN exists.
So a SCSI driver must either take the channel and target id values in account
in its quecommand() function or it should declare that it only supports one
channel and one target id. Currently the ib_srp driver does neither. As a
result scanning the SCSI bus via e.g. rescan-scsi-bus.sh causes many
duplicate SCSI devices to be created. For each 0:0:L device, several
duplicates are created with the same LUN number and with (C:I) != (0:0). Fix
this by declaring that the ib_srp driver only supports one channel and one
target id.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

---
 drivers/infiniband/ulp/srp/ib_srp.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index ee165fd..7d5109b 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2127,6 +2127,8 @@ static ssize_t srp_create_target(struct device *dev,
 		return -ENOMEM;
 
 	target_host->transportt  = ib_srp_transport_template;
+	target_host->max_channel = 0;
+	target_host->max_id      = 1;
 	target_host->max_lun     = SRP_MAX_LUN;
 	target_host->max_cmd_len = sizeof ((struct srp_cmd *) (void *) 0L)->cdb;
 
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
