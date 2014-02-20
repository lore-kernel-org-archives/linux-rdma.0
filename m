From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 6/6] IB/srp: Avoid that writing into "add_target" hangs due
 to a cable pull
Date: Thu, 20 Feb 2014 11:55:36 +0100
Message-ID: <5305DF28.7090104@acm.org>
References: <5305DE01.7030004@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5305DE01.7030004-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If a cable is pulled while srp_connect_target() is in progress
that can result in that function never to return. That makes the
process, e.g. srp_daemon, that invoked this function unkillable.
Avoid this by letting srp_connect_target() finish if the event
IB_CM_TIMEWAIT_EXIT is received. This patch fixes a hang with the
following call trace:
 [<ffffffff814eae85>] schedule_timeout+0x215/0x2e0
 [<ffffffff814eab03>] wait_for_common+0x123/0x180
 [<ffffffff814eac1d>] wait_for_completion+0x1d/0x20
 [<ffffffffa03b398c>] srp_connect_target+0x1dc/0x410 [ib_srp]
 [<ffffffffa03b5809>] srp_create_target+0xba9/0xe70 [ib_srp]
 [<ffffffff8133e590>] dev_attr_store+0x20/0x30
 [<ffffffff811eb8f5>] sysfs_write_file+0xe5/0x170
 [<ffffffff811767c8>] vfs_write+0xb8/0x1a0
 [<ffffffff811770c1>] sys_write+0x51/0x90
 [<ffffffff8100b072>] system_call_fastpath+0x16/0x1b

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 0d934b7..dcdaf49 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1873,6 +1873,7 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 	case IB_CM_TIMEWAIT_EXIT:
 		shost_printk(KERN_ERR, target->scsi_host,
 			     PFX "connection closed\n");
+		comp = 1;
 
 		target->status = 0;
 		break;
-- 
1.8.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
