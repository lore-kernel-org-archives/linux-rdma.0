From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 1/8] IB/srp: Avoid that duplicate responses trigger a kernel bug
Date: Fri, 10 Feb 2017 15:56:04 -0800
Message-ID: <20170210235611.3243-2-bart.vanassche@sandisk.com>
References: <20170210235611.3243-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170210235611.3243-1-bart.vanassche@sandisk.com>
Sender: stable-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Israel Rukshin <israelr@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Laurence Oberman <loberman@redhat.com>, Steve Feeley <Steve.Feeley@sandisk.com>, stable@vger.kernel.org
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
 cpuidle_enter_state+0xf2/0x370
 cpuidle_enter+0x12/0x20
 call_cpuidle+0x1e/0x40
 do_idle+0xe3/0x1c0
 cpu_startup_entry+0x18/0x20
 start_secondary+0x103/0x130
 start_cpu+0x14/0x14
RIP: srp_recv_done+0x450/0x6b0 [ib_srp] RSP: ffff88046f483e20

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Israel Rukshin <israelr@mellanox.com>
Cc: Max Gurtovoy <maxg@mellanox.com>
Cc: Laurence Oberman <loberman@redhat.com>
Cc: Steve Feeley <Steve.Feeley@sandisk.com>
Cc: <stable@vger.kernel.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 79bf48477ddb..4068d34f5427 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1899,7 +1899,14 @@ static void srp_process_rsp(struct srp_rdma_ch *ch, struct srp_rsp *rsp)
 		scmnd = scsi_host_find_tag(target->scsi_host, rsp->tag);
 		if (scmnd) {
 			req = (void *)scmnd->host_scribble;
-			scmnd = srp_claim_req(ch, req, NULL, scmnd);
+			if (req) {
+				scmnd = srp_claim_req(ch, req, NULL, scmnd);
+			} else {
+				shost_printk(KERN_ERR, target->scsi_host,
+					     "NULL host_scribble for response with tag %#llx\n",
+					     rsp->tag);
+				scmnd = NULL;
+			}
 		}
 		if (!scmnd) {
 			shost_printk(KERN_ERR, target->scsi_host,
-- 
2.11.0
