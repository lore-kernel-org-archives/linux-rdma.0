From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] rdma/ib_cm: check LAP state before sending an MRA
Date: Wed, 21 Jul 2010 16:36:52 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A71DAEF8@orsmsx501.amr.corp.intel.com>
References: <AANLkTikwDEJY_F1ziGNPhYMBJEBC5UqD2XOLM7wSByj1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikwDEJY_F1ziGNPhYMBJEBC5UqD2XOLM7wSByj1-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh England <jjengla-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "akepner-sJ/iWh9BUns@public.gmane.org" <akepner-sJ/iWh9BUns@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This problem was originally reported by Arthur Kepner <akepner-sJ/iWh9BUns@public.gmane.org>:

We have a customer who has repeatedly had system panics with 
the following signature:

Unable to handle kernel NULL pointer dereference at 0000000000000010 RIP:
<ffffffff882c2c5c>{:ib_cm:ib_cm_init_qp_attr+580}
PGD 3a2db6067 PUD 0
Oops: 0000 [1] SMP
last sysfs file: /class/infiniband/mlx4_0/node_guid
CPU 4
Modules linked in: i2c_dev sg sd_mod crc32c libcrc32c iscsi_tcp libiscsi
scsi_transport_iscsi rdma_ucm rdma_cm
iw_cm ib_addr ib_ipoib ib_cm ib_sa ipv6 ib_uverbs ib_umad iw_cxgb3 cxgb3
firmware_class mlx4_ib ib_mthca ib_mad
 ib_core loop numatools xpmem worm mlx4_core libata i2c_i801 scsi_mod i2c_core
shpchp pci_hotplug nfs lockd nfs
_acl af_packet sunrpc e1000
Pid: 3256, comm: star Tainted: G     U 2.6.16.60-0.34-smp #1
RIP: 0010:[<ffffffff882c2c5c>]
<ffffffff882c2c5c>{:ib_cm:ib_cm_init_qp_attr+580}
RSP: 0018:ffff810369d09d38  EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff810419678c00 RCX: 0000000000000008
RDX: 0000000000000246 RSI: ffff810419678d18 RDI: ffff810369d09e70
RBP: ffff810369d09e18 R08: 000000030000003d R09: 0000000000000000
R10: ffff810369d09e18 R11: 0000000000000088 R12: ffff810369d09d88
R13: 0000000000000000 R14: ffff810419678c80 R15: 00000000403500b0
FS:  0000000040354940(0063) GS:ffff810420ffbbc0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000010 CR3: 000000039f0c4000 CR4: 00000000000006e0
Process star (pid: 3256, threadinfo ffff810369d08000, task ffff8103b81b5830)
Stack: ffff810419678a00 ffff810369d09d88 ffff810369d09e18 ffff810369d09e18
       0000000040143430 ffffffff882fb6d5 ffff810376261540 ffff81040bea4740
       ffff810376261540 ffffffff88309285
Call Trace: <ffffffff882fb6d5>{:rdma_cm:rdma_init_qp_attr+209}
       <ffffffff88309285>{:rdma_ucm:ucma_init_qp_attr+160}
       <ffffffff802ea55a>{thread_return+0}
<ffffffff8830832e>{:rdma_ucm:ucma_write+115}
       <ffffffff80186662>{vfs_write+215} <ffffffff80186c2b>{sys_write+69}
      <ffffffff8010adba>{system_call+126}

Code: 8a 40 10 88 85 85 00 00 00 8b 83 38 01 00 00 66 89 45 7a 8a
RIP <ffffffff882c2c5c>{:ib_cm:ib_cm_init_qp_attr+580} RSP <ffff810369d09d38>


>From a crash dump, I determined that we died in cm_init_qp_rts_attr() 
(it's inline, so it doesn't show up in the traceback) on the line 
labeled below:

static int cm_init_qp_rts_attr(struct cm_id_private *cm_id_priv,
                               struct ib_qp_attr *qp_attr,
                               int *qp_attr_mask)
{
        ........
        if (cm_id_priv->id.lap_state == IB_CM_LAP_UNINIT) {
                .....
        } else {
               *qp_attr_mask = IB_QP_ALT_PATH | IB_QP_PATH_MIG_STATE;
               qp_attr->alt_port_num = cm_id_priv->alt_av.port->port_num; <-die


A similar problem was reported by Josh England <jjengla-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>.

The problem is that the rdma_cm can call ib_send_cm_mra() after a
connection has been established.  The ib_cm incorrectly assumes that the
MRA is in response to a LAP (load alternate path) message, even though no
LAP message has been received.  The ib_cm needs to check the lap_state
before sending an MRA if the cm_id state is established.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Josh or Arthur, can either of you confirm if this patch fixes the crashes that
you've seen?

 drivers/infiniband/core/cm.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index ad63b79..64e0903 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -2409,10 +2409,12 @@ int ib_send_cm_mra(struct ib_cm_id *cm_id,
 		msg_response = CM_MSG_RESPONSE_REP;
 		break;
 	case IB_CM_ESTABLISHED:
-		cm_state = cm_id->state;
-		lap_state = IB_CM_MRA_LAP_SENT;
-		msg_response = CM_MSG_RESPONSE_OTHER;
-		break;
+		if (cm_id->lap_state == IB_CM_LAP_RCVD) {
+			cm_state = cm_id->state;
+			lap_state = IB_CM_MRA_LAP_SENT;
+			msg_response = CM_MSG_RESPONSE_OTHER;
+			break;
+		}
 	default:
 		ret = -EINVAL;
 		goto error1;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
