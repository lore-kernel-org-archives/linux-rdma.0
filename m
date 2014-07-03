From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 3/5] IB/srp: Fix residual handling
Date: Thu, 03 Jul 2014 15:47:12 +0200
Message-ID: <53B55EE0.1050403@acm.org>
References: <53B55E55.5040907@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53B55E55.5040907-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From Documentation/scsi/scsi_mid_low_api.txt: "resid - an LLD should
set this signed integer to the requested transfer length (i.e.
'request_bufflen') less the number of bytes that are actually
transferred." This means that resid > 0 in case of an underrun and
also that resid < 0 in case of an overrun. Modify the SRP initiator
code such that it matches this requirement.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 7670008..6abfff4 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1644,10 +1644,14 @@ static void srp_process_rsp(struct srp_target_port *target, struct srp_rsp *rsp)
 				     SCSI_SENSE_BUFFERSIZE));
 		}
 
-		if (rsp->flags & (SRP_RSP_FLAG_DOOVER | SRP_RSP_FLAG_DOUNDER))
-			scsi_set_resid(scmnd, be32_to_cpu(rsp->data_out_res_cnt));
-		else if (rsp->flags & (SRP_RSP_FLAG_DIOVER | SRP_RSP_FLAG_DIUNDER))
+		if (rsp->flags & SRP_RSP_FLAG_DIUNDER)
 			scsi_set_resid(scmnd, be32_to_cpu(rsp->data_in_res_cnt));
+		else if (rsp->flags & SRP_RSP_FLAG_DIOVER)
+			scsi_set_resid(scmnd, -be32_to_cpu(rsp->data_in_res_cnt));
+		else if (rsp->flags & SRP_RSP_FLAG_DOUNDER)
+			scsi_set_resid(scmnd, be32_to_cpu(rsp->data_out_res_cnt));
+		else if (rsp->flags & SRP_RSP_FLAG_DOOVER)
+			scsi_set_resid(scmnd, -be32_to_cpu(rsp->data_out_res_cnt));
 
 		srp_free_req(target, req, scmnd,
 			     be32_to_cpu(rsp->req_lim_delta));
-- 
1.8.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
