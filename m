From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH v3 12/13] IB/srp: Make transport layer retry count configurable
Date: Wed, 03 Jul 2013 14:59:58 +0200
Message-ID: <51D4204E.7040301@acm.org>
References: <51D41C03.4020607@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51D41C03.4020607-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Allow the InfiniBand RC retry count to be configured by the user
as an option in the target login string. Reducing this retry count
helps with reducing path failover time.

[bvanassche: Rewrote patch description / changed default retry count from 2 back to 7]
Signed-off-by: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 Documentation/ABI/stable/sysfs-driver-ib_srp |    2 ++
 drivers/infiniband/ulp/srp/ib_srp.c          |   24 +++++++++++++++++++++++-
 drivers/infiniband/ulp/srp/ib_srp.h          |    1 +
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/stable/sysfs-driver-ib_srp b/Documentation/ABI/stable/sysfs-driver-ib_srp
index 5c53d28..18e9b27 100644
--- a/Documentation/ABI/stable/sysfs-driver-ib_srp
+++ b/Documentation/ABI/stable/sysfs-driver-ib_srp
@@ -61,6 +61,8 @@ Description:	Interface for making ib_srp connect to a new target.
 		  interrupt is handled by a different CPU then the comp_vector
 		  parameter can be used to spread the SRP completion workload
 		  over multiple CPU's.
+		* tl_retry_count, a number in the range 2..7 specifying the
+		  IB RC retry count.
 
 What:		/sys/class/infiniband_srp/srp-<hca>-<port_number>/ibdev
 Date:		January 2, 2006
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 6c164f6..91b2d04 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -453,7 +453,7 @@ static int srp_send_req(struct srp_target_port *target)
 	req->param.responder_resources	      = 4;
 	req->param.remote_cm_response_timeout = 20;
 	req->param.local_cm_response_timeout  = 20;
-	req->param.retry_count 		      = 7;
+	req->param.retry_count                = target->tl_retry_count;
 	req->param.rnr_retry_count 	      = 7;
 	req->param.max_cm_retries 	      = 15;
 
@@ -1986,6 +1986,14 @@ static ssize_t show_comp_vector(struct device *dev,
 	return sprintf(buf, "%d\n", target->comp_vector);
 }
 
+static ssize_t show_tl_retry_count(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct srp_target_port *target = host_to_target(class_to_shost(dev));
+
+	return sprintf(buf, "%d\n", target->tl_retry_count);
+}
+
 static ssize_t show_cmd_sg_entries(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
@@ -2013,6 +2021,7 @@ static DEVICE_ATTR(zero_req_lim,    S_IRUGO, show_zero_req_lim,	   NULL);
 static DEVICE_ATTR(local_ib_port,   S_IRUGO, show_local_ib_port,   NULL);
 static DEVICE_ATTR(local_ib_device, S_IRUGO, show_local_ib_device, NULL);
 static DEVICE_ATTR(comp_vector,     S_IRUGO, show_comp_vector,     NULL);
+static DEVICE_ATTR(tl_retry_count,  S_IRUGO, show_tl_retry_count,  NULL);
 static DEVICE_ATTR(cmd_sg_entries,  S_IRUGO, show_cmd_sg_entries,  NULL);
 static DEVICE_ATTR(allow_ext_sg,    S_IRUGO, show_allow_ext_sg,    NULL);
 
@@ -2028,6 +2037,7 @@ static struct device_attribute *srp_host_attrs[] = {
 	&dev_attr_local_ib_port,
 	&dev_attr_local_ib_device,
 	&dev_attr_comp_vector,
+	&dev_attr_tl_retry_count,
 	&dev_attr_cmd_sg_entries,
 	&dev_attr_allow_ext_sg,
 	NULL
@@ -2153,6 +2163,7 @@ enum {
 	SRP_OPT_ALLOW_EXT_SG	= 1 << 10,
 	SRP_OPT_SG_TABLESIZE	= 1 << 11,
 	SRP_OPT_COMP_VECTOR	= 1 << 12,
+	SRP_OPT_TL_RETRY_COUNT	= 1 << 13,
 	SRP_OPT_ALL		= (SRP_OPT_ID_EXT	|
 				   SRP_OPT_IOC_GUID	|
 				   SRP_OPT_DGID		|
@@ -2174,6 +2185,7 @@ static const match_table_t srp_opt_tokens = {
 	{ SRP_OPT_ALLOW_EXT_SG,		"allow_ext_sg=%u"	},
 	{ SRP_OPT_SG_TABLESIZE,		"sg_tablesize=%u"	},
 	{ SRP_OPT_COMP_VECTOR,		"comp_vector=%u"	},
+	{ SRP_OPT_TL_RETRY_COUNT,	"tl_retry_count=%u"	},
 	{ SRP_OPT_ERR,			NULL 			}
 };
 
@@ -2337,6 +2349,15 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 			target->comp_vector = token;
 			break;
 
+		case SRP_OPT_TL_RETRY_COUNT:
+			if (match_int(args, &token) || token < 2 || token > 7) {
+				pr_warn("bad tl_retry_count parameter '%s' (must be a number between 2 and 7)\n",
+					p);
+				goto out;
+			}
+			target->tl_retry_count = token;
+			break;
+
 		default:
 			pr_warn("unknown parameter or missing value '%s' in target creation request\n",
 				p);
@@ -2391,6 +2412,7 @@ static ssize_t srp_create_target(struct device *dev,
 	target->cmd_sg_cnt	= cmd_sg_entries;
 	target->sg_tablesize	= indirect_sg_entries ? : cmd_sg_entries;
 	target->allow_ext_sg	= allow_ext_sg;
+	target->tl_retry_count	= 7;
 
 	ret = srp_parse_options(buf, target);
 	if (ret)
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index cbc0b14..446b045 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -157,6 +157,7 @@ struct srp_target_port {
 	unsigned int		scsi_id;
 	unsigned int		sg_tablesize;
 	int			comp_vector;
+	int			tl_retry_count;
 
 	struct ib_sa_path_rec	path;
 	__be16			orig_dgid[8];
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
