From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 12/14] IB/srp: Make HCA completion vector configurable
Date: Wed, 12 Jun 2013 15:35:00 +0200
Message-ID: <51B87904.1070803@acm.org>
References: <51B87501.4070005@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51B87501.4070005-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Several InfiniBand HCA's allow to configure the completion vector
per queue pair. This allows to spread the workload created by IB
completion interrupts over multiple MSI-X vectors and hence over
multiple CPU cores. In other words, configuring the completion
vector properly not only allows to reduce latency on an initiator
connected to multiple SRP targets but also allows to improve
throughput.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   26 ++++++++++++++++++++++++--
 drivers/infiniband/ulp/srp/ib_srp.h |    1 +
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index dbedac9..49d8464 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -294,14 +294,16 @@ static int srp_create_target_ib(struct srp_target_port *target)
 		return -ENOMEM;
 
 	recv_cq = ib_create_cq(target->srp_host->srp_dev->dev,
-			       srp_recv_completion, NULL, target, SRP_RQ_SIZE, 0);
+			       srp_recv_completion, NULL, target, SRP_RQ_SIZE,
+			       target->comp_vector);
 	if (IS_ERR(recv_cq)) {
 		ret = PTR_ERR(recv_cq);
 		goto err;
 	}
 
 	send_cq = ib_create_cq(target->srp_host->srp_dev->dev,
-			       srp_send_completion, NULL, target, SRP_SQ_SIZE, 0);
+			       srp_send_completion, NULL, target, SRP_SQ_SIZE,
+			       target->comp_vector);
 	if (IS_ERR(send_cq)) {
 		ret = PTR_ERR(send_cq);
 		goto err_recv_cq;
@@ -2006,6 +2008,14 @@ static ssize_t show_local_ib_device(struct device *dev,
 	return sprintf(buf, "%s\n", target->srp_host->srp_dev->dev->name);
 }
 
+static ssize_t show_comp_vector(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct srp_target_port *target = host_to_target(class_to_shost(dev));
+
+	return sprintf(buf, "%d\n", target->comp_vector);
+}
+
 static ssize_t show_cmd_sg_entries(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
@@ -2032,6 +2042,7 @@ static DEVICE_ATTR(req_lim,         S_IRUGO, show_req_lim,         NULL);
 static DEVICE_ATTR(zero_req_lim,    S_IRUGO, show_zero_req_lim,	   NULL);
 static DEVICE_ATTR(local_ib_port,   S_IRUGO, show_local_ib_port,   NULL);
 static DEVICE_ATTR(local_ib_device, S_IRUGO, show_local_ib_device, NULL);
+static DEVICE_ATTR(comp_vector,     S_IRUGO, show_comp_vector,     NULL);
 static DEVICE_ATTR(cmd_sg_entries,  S_IRUGO, show_cmd_sg_entries,  NULL);
 static DEVICE_ATTR(allow_ext_sg,    S_IRUGO, show_allow_ext_sg,    NULL);
 
@@ -2046,6 +2057,7 @@ static struct device_attribute *srp_host_attrs[] = {
 	&dev_attr_zero_req_lim,
 	&dev_attr_local_ib_port,
 	&dev_attr_local_ib_device,
+	&dev_attr_comp_vector,
 	&dev_attr_cmd_sg_entries,
 	&dev_attr_allow_ext_sg,
 	NULL
@@ -2140,6 +2152,7 @@ enum {
 	SRP_OPT_CMD_SG_ENTRIES	= 1 << 9,
 	SRP_OPT_ALLOW_EXT_SG	= 1 << 10,
 	SRP_OPT_SG_TABLESIZE	= 1 << 11,
+	SRP_OPT_COMP_VECTOR	= 1 << 12,
 	SRP_OPT_ALL		= (SRP_OPT_ID_EXT	|
 				   SRP_OPT_IOC_GUID	|
 				   SRP_OPT_DGID		|
@@ -2160,6 +2173,7 @@ static const match_table_t srp_opt_tokens = {
 	{ SRP_OPT_CMD_SG_ENTRIES,	"cmd_sg_entries=%u"	},
 	{ SRP_OPT_ALLOW_EXT_SG,		"allow_ext_sg=%u"	},
 	{ SRP_OPT_SG_TABLESIZE,		"sg_tablesize=%u"	},
+	{ SRP_OPT_COMP_VECTOR,		"comp_vector=%u"	},
 	{ SRP_OPT_ERR,			NULL 			}
 };
 
@@ -2315,6 +2329,14 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 			target->sg_tablesize = token;
 			break;
 
+		case SRP_OPT_COMP_VECTOR:
+			if (match_int(args, &token) || token < 0) {
+				pr_warn("bad comp_vector parameter '%s'\n", p);
+				goto out;
+			}
+			target->comp_vector = token;
+			break;
+
 		default:
 			pr_warn("unknown parameter or missing value '%s' in target creation request\n",
 				p);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index e45d9d0..cbc0b14 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -156,6 +156,7 @@ struct srp_target_port {
 	char			target_name[32];
 	unsigned int		scsi_id;
 	unsigned int		sg_tablesize;
+	int			comp_vector;
 
 	struct ib_sa_path_rec	path;
 	__be16			orig_dgid[8];
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
