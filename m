From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 2/8] IB/srp: Avoid that duplicate responses trigger a kernel bug
Date: Tue, 14 Feb 2017 10:56:30 -0800
Message-ID: <20170214185636.29250-3-bart.vanassche@sandisk.com>
References: <20170214185636.29250-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170214185636.29250-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Feeley <Steve.Feeley-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

After srp_process_rsp() returns there is a short time during which
the scsi_host_find_tag() call will return a pointer to the SCSI
command that is being completed. If during that time a duplicate
response is received, avoid that the following call stack appears:

BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: srp_recv_done+0x450/0x6b0 [ib_srp]
Oops: 0000 [#1] SMP
CPU: 10 PID: 0 Comm: swapper/10 Not tainted 4.10.0-rc7-dbg+ #1
Call Trace:
 <IRQ>
 __ib_process_cq+0x4b/0xd0 [ib_core]
 ib_poll_handler+0x1d/0x70 [ib_core]
 irq_poll_softirq+0xba/0x120
 __do_softirq+0xba/0x4c0
 irq_exit+0xbe/0xd0
 smp_apic_timer_interrupt+0x38/0x50
 apic_timer_interrupt+0x90/0xa0
 </IRQ>
RIP: srp_recv_done+0x450/0x6b0 [ib_srp] RSP: ffff88046f483e20

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Steve Feeley <Steve.Feeley-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 07e3613e4798..12027e3a4dec 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1892,9 +1892,11 @@ static void srp_process_rsp(struct srp_rdma_ch *ch, struct srp_rsp *rsp)
 		complete(&ch->tsk_mgmt_done);
 	} else {
 		scmnd = scsi_host_find_tag(target->scsi_host, rsp->tag);
-		if (scmnd) {
+		if (scmnd && scmnd->host_scribble) {
 			req = (void *)scmnd->host_scribble;
 			scmnd = srp_claim_req(ch, req, NULL, scmnd);
+		} else {
+			scmnd = NULL;
 		}
 		if (!scmnd) {
 			shost_printk(KERN_ERR, target->scsi_host,
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
