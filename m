From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v2 8/8] IB/srp: Make CM timeout dependent on subnet timeout
Date: Wed, 11 Oct 2017 10:27:29 -0700
Message-ID: <20171011172729.16984-9-bart.vanassche@wdc.com>
References: <20171011172729.16984-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171011172729.16984-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

For small networks it is safe to reduce the subnet timeout from
its default value (18 for opensm) to 16. Make the SRP CM timeout
dependent on the subnet timeout such that decreasing the subnet
timeout also causes SRP failover and failback to occur faster.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 463c3ed440eb..972d4b3c5223 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -711,6 +711,23 @@ static int srp_lookup_path(struct srp_rdma_ch *ch)
 	return ret;
 }
 
+static u8 srp_get_subnet_timeout(struct srp_host *host)
+{
+	struct ib_port_attr attr;
+	int ret;
+	u8 subnet_timeout = 18;
+
+	ret = ib_query_port(host->srp_dev->dev, host->port, &attr);
+	if (ret == 0)
+		subnet_timeout = attr.subnet_timeout;
+
+	if (unlikely(subnet_timeout < 15))
+		pr_warn("%s: subnet timeout %d may cause SRP login to fail.\n",
+			dev_name(&host->srp_dev->dev->dev), subnet_timeout);
+
+	return subnet_timeout;
+}
+
 static int srp_send_req(struct srp_rdma_ch *ch, bool multich)
 {
 	struct srp_target_port *target = ch->target;
@@ -719,6 +736,9 @@ static int srp_send_req(struct srp_rdma_ch *ch, bool multich)
 		struct srp_login_req   priv;
 	} *req = NULL;
 	int status;
+	u8 subnet_timeout;
+
+	subnet_timeout = srp_get_subnet_timeout(target->srp_host);
 
 	req = kzalloc(sizeof *req, GFP_KERNEL);
 	if (!req)
@@ -741,8 +761,8 @@ static int srp_send_req(struct srp_rdma_ch *ch, bool multich)
 	 * module parameters if anyone cared about setting them.
 	 */
 	req->param.responder_resources	      = 4;
-	req->param.remote_cm_response_timeout = 20;
-	req->param.local_cm_response_timeout  = 20;
+	req->param.remote_cm_response_timeout = subnet_timeout + 2;
+	req->param.local_cm_response_timeout  = subnet_timeout + 2;
 	req->param.retry_count                = target->tl_retry_count;
 	req->param.rnr_retry_count 	      = 7;
 	req->param.max_cm_retries 	      = 15;
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
