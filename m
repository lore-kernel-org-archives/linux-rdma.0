From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 09/11] IB/srp: Fix a NULL pointer dereference
Date: Fri, 22 Apr 2016 14:15:30 -0700
Message-ID: <571A9472.5050202@sandisk.com>
References: <571A936F.7040409@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <571A936F.7040409-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid that running xfstests on top of the SRP initiator triggers
the call trace below. This patch has been tested by running the
following shell command on an initiator system that has access
to 3200 SRP LUNs:

/etc/init.d/multipathd start
while true; do
  /etc/init.d/srpd start
  sleep 400
  /etc/init.d/srpd stop
  for p in /sys/class/srp_remote_ports/*; do
    echo 1 >$p/delete &
  done
  wait
  dmsetup remove_all
done

BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffffa0918bb1>] srp_claim_req+0x31/0x90 [ib_srp]
Call Trace:
 <IRQ>
 [<ffffffffa091c096>] srp_process_rsp+0xa6/0x2a0 [ib_srp]
 [<ffffffffa091c5ec>] srp_handle_recv+0x16c/0x340 [ib_srp]
 [<ffffffffa091c7f9>] srp_recv_completion+0x39/0x70 [ib_srp]
 [<ffffffffa0184442>] mlx4_ib_cq_comp+0x12/0x20 [mlx4_ib]
 [<ffffffffa005e86d>] mlx4_cq_completion+0x3d/0x80 [mlx4_core]
 [<ffffffffa006002b>] mlx4_eq_int+0x53b/0xd50 [mlx4_core]
 [<ffffffffa006084f>] mlx4_msi_x_interrupt+0xf/0x20 [mlx4_core]
 [<ffffffff810b67e0>] handle_irq_event_percpu+0x40/0x110
 [<ffffffff810b68ef>] handle_irq_event+0x3f/0x70
 [<ffffffff810ba829>] handle_edge_irq+0x79/0x120
 [<ffffffff81007f2d>] handle_irq+0x5d/0x130
 [<ffffffff810071ed>] do_IRQ+0x6d/0x130
 [<ffffffff8151c104>] common_interrupt+0x84/0x84
 <EOI>

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index caefd1a..f4003f6 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1814,7 +1814,8 @@ static void srp_process_rsp(struct srp_rdma_ch *ch, struct srp_rsp *rsp)
 		scmnd = scsi_host_find_tag(target->scsi_host, rsp->tag);
 		if (scmnd) {
 			req = (void *)scmnd->host_scribble;
-			scmnd = srp_claim_req(ch, req, NULL, scmnd);
+			scmnd = req ? srp_claim_req(ch, req, NULL, scmnd) :
+				NULL;
 		}
 		if (!scmnd) {
 			shost_printk(KERN_ERR, target->scsi_host,
-- 
2.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
