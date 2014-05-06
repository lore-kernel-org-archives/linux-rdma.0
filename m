From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 1/9] IB/srp: Fix kernel-doc warnings
Date: Tue, 06 May 2014 14:50:58 +0200
Message-ID: <5368DAB2.2070006@acm.org>
References: <5368DA5B.80609@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5368DA5B.80609-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid that the kernel-doc tool warns about missing argument descriptions
for the ib_srp.[ch] source files.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 66a908b..cf80f7a 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -813,6 +813,10 @@ static struct scsi_cmnd *srp_claim_req(struct srp_target_port *target,
 
 /**
  * srp_free_req() - Unmap data and add request to the free request list.
+ * @target: SRP target port.
+ * @req:    Request to be freed.
+ * @scmnd:  SCSI command associated with @req.
+ * @req_lim_delta: Amount to be added to @target->req_lim.
  */
 static void srp_free_req(struct srp_target_port *target,
 			 struct srp_request *req, struct scsi_cmnd *scmnd,
@@ -1455,6 +1459,7 @@ static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
 
 /**
  * srp_tl_err_work() - handle a transport layer error
+ * @work: Work structure embedded in an SRP target port.
  *
  * Note: This function may get invoked before the rport has been created,
  * hence the target->rport test.
@@ -2310,6 +2315,8 @@ static struct class srp_class = {
 
 /**
  * srp_conn_unique() - check whether the connection to a target is unique
+ * @host:   SRP host.
+ * @target: SRP target port.
  */
 static bool srp_conn_unique(struct srp_host *host,
 			    struct srp_target_port *target)
-- 
1.8.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
