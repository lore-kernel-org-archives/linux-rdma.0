From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH] IB/srp: Fail I/O requests if the transport is offline
Date: Fri, 15 Feb 2013 10:39:26 +0100
Message-ID: <511E024E.70002@acm.org>
References: <510BDCAA.204@acm.org> <CAJZOPZLKQV0QvrW5sK8hQJf7AZc+1nUzp+5YCkZ3iVU4oTWbLg@mail.gmail.com> <5111327F.6050402@acm.org> <CAJZOPZ+-Zg=jnqg4ZmFL5Yo4_2DoWGcgy=3u6g3Rf9y80pXnpg@mail.gmail.com> <5112049B.8030406@acm.org> <5112CE60.2030607@mellanox.com> <51136E74.9090209@acm.org> <5113F056.4020501@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5113F056.4020501-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If an SRP target is no longer reachable and srp_reset_host()
fails to reconnect then ib_srp will invoke scsi_remove_host().
That function will invoke __scsi_remove_device() for each LUN.
And that last function will change the device state from
SDEV_TRANSPORT_OFFLINE into SDEV_CANCEL. Certain user space
software, e.g. older versions of multipathd, continue queueing
I/O to SCSI devices that are in the SDEV_CANCEL state. If these
I/O requests are submitted as SG_IO that means that the
REQ_PREEMPT flag will be set and hence that these requests will
be passed to srp_queuecommand(). These requests will time out.
If new requests are queued fast enough from user space these
active requests will prevent __scsi_remove_device() to finish.
Avoid this by failing I/O requests in the SDEV_CANCEL state if
the transport is offline. Introduce a new variable to keep
track of the transport state instead of failing requests if
(!target->connected || target->qp_in_error) such that the SCSI
error handler has a chance to retry commands after a transport
layer failure occurred.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |    7 +++++++
 drivers/infiniband/ulp/srp/ib_srp.h |    1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 8a7eb9f..b34752d 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -734,6 +734,7 @@ static int srp_reconnect_target(struct srp_target_port *target)
 
 	scsi_target_unblock(&shost->shost_gendev, ret == 0 ? SDEV_RUNNING :
 			    SDEV_TRANSPORT_OFFLINE);
+	target->transport_offline = ret != 0;
 
 	if (ret)
 		goto err;
@@ -1353,6 +1354,12 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	unsigned long flags;
 	int len;
 
+	if (unlikely(target->transport_offline)) {
+		scmnd->result = DID_NO_CONNECT << 16;
+		scmnd->scsi_done(scmnd);
+		return 0;
+	}
+
 	spin_lock_irqsave(&target->lock, flags);
 	iu = __srp_get_tx_iu(target, SRP_IU_CMD);
 	if (!iu)
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index de2d0b3..66fbedd 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -140,6 +140,7 @@ struct srp_target_port {
 	unsigned int		cmd_sg_cnt;
 	unsigned int		indirect_size;
 	bool			allow_ext_sg;
+	bool			transport_offline;
 
 	/* Everything above this point is used in the hot path of
 	 * command processing. Try to keep them packed into cachelines.
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
