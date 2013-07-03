From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH v3 03/13] IB/srp: Fail I/O fast if target offline
Date: Wed, 03 Jul 2013 14:45:26 +0200
Message-ID: <51D41CE6.3030702@acm.org>
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

If reconnecting failed we know that no command completion will
be received anymore. Hence let the SCSI error handler fail such
commands immediately.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Acked-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Acked-by: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 0e0a5a2..19279e5 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1753,6 +1753,8 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 	if (srp_send_tsk_mgmt(target, req->index, scmnd->device->lun,
 			      SRP_TSK_ABORT_TASK) == 0)
 		ret = SUCCESS;
+	else if (target->transport_offline)
+		ret = FAST_IO_FAIL;
 	else
 		ret = FAILED;
 	srp_free_req(target, req, scmnd, 0);
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
