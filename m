From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 3/6]  SRP implement device_loss_timeout per target
Date: Mon, 09 Nov 2009 13:32:55 -0800
Message-ID: <4AF88A87.300@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010903030009010303060803"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------010903030009010303060803
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Introducing device_loss_timeout per target granuality.
SRP driver will propagate I/O errors and clean up connection resources after
device_loss_timeout expired when local port or target port disconnected from
the fabric.
    
Signed-off-by: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>


--------------010903030009010303060803
Content-Type: text/plain;
 name="srp_3_device_loss_timeout.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="srp_3_device_loss_timeout.patch"

 drivers/infiniband/ulp/srp/ib_srp.c |   12 +++++++++++-
 drivers/infiniband/ulp/srp/ib_srp.h |    1 +
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index e44939a..047d488 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1298,7 +1298,6 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 	case IB_CM_TIMEWAIT_EXIT:
 		shost_printk(KERN_ERR, target->scsi_host,
 			     PFX "connection closed\n");
-
 		target->status = 0;
 		break;
 
@@ -1657,6 +1656,7 @@ enum {
 	SRP_OPT_MAX_CMD_PER_LUN	= 1 << 6,
 	SRP_OPT_IO_CLASS	= 1 << 7,
 	SRP_OPT_INITIATOR_EXT	= 1 << 8,
+	SRP_OPT_DEVICE_LOSS_TMO	= 1 << 9,
 	SRP_OPT_ALL		= (SRP_OPT_ID_EXT	|
 				   SRP_OPT_IOC_GUID	|
 				   SRP_OPT_DGID		|
@@ -1674,6 +1674,7 @@ static const match_table_t srp_opt_tokens = {
 	{ SRP_OPT_MAX_CMD_PER_LUN,	"max_cmd_per_lun=%d" 	},
 	{ SRP_OPT_IO_CLASS,		"io_class=%x"		},
 	{ SRP_OPT_INITIATOR_EXT,	"initiator_ext=%s"	},
+	{ SRP_OPT_DEVICE_LOSS_TMO,	"device_loss_timeout=%d"},
 	{ SRP_OPT_ERR,			NULL 			}
 };
 
@@ -1801,6 +1802,15 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 			kfree(p);
 			break;
 
+		case SRP_OPT_DEVICE_LOSS_TMO:
+			if (match_int(args, &token)) {
+				printk(KERN_WARNING PFX "bad device loss timeout '%s'\n", p);
+				goto out;
+			}
+			if (token > 0)
+				target->device_loss_timeout = token;
+			break;
+
 		default:
 			printk(KERN_WARNING PFX "unknown parameter or missing value "
 			       "'%s' in target creation request\n", p);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index e185b90..92db025 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -159,6 +159,7 @@ struct srp_target_port {
 	int			status;
 	enum srp_target_state	state;
 	int			qp_in_error;
+	int			device_loss_timeout;
 };
 
 struct srp_iu {

--------------010903030009010303060803--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
