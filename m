From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 3/3] IB/srpt: Fix a use-after-free
Date: Tue, 10 Jul 2018 10:32:00 -0700
Message-ID: <20180710173200.19853-4-bart.vanassche@wdc.com>
References: <20180710173200.19853-1-bart.vanassche@wdc.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180710173200.19853-1-bart.vanassche@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Make sure that channel objects continue to exist until the target
core has called the .close_session() callback function. This patch
voids that KASAN sporadically reports the following:

BUG: KASAN: use-after-free in do_raw_spin_lock+0x1c/0x130
Read of size 4 at addr ffff8801534b16e4 by task rmdir/14805
CPU: 16 PID: 14805 Comm: rmdir Not tainted 4.18.0-rc2-dbg+ #5
Call Trace:
dump_stack+0xa4/0xf5
print_address_description+0x6f/0x270
kasan_report+0x241/0x360
__asan_load4+0x78/0x80
do_raw_spin_lock+0x1c/0x130
_raw_spin_lock_irqsave+0x52/0x60
srpt_set_ch_state+0x27/0x70 [ib_srpt]
srpt_disconnect_ch+0x1b/0xc0 [ib_srpt]
srpt_close_session+0xa8/0x260 [ib_srpt]
target_shutdown_sessions+0x170/0x180 [target_core_mod]
core_tpg_del_initiator_node_acl+0xf3/0x200 [target_core_mod]
target_fabric_nacl_base_release+0x25/0x30 [target_core_mod]
config_item_release+0x9c/0x110 [configfs]
config_item_put+0x26/0x30 [configfs]
configfs_rmdir+0x3b8/0x510 [configfs]
vfs_rmdir+0xb3/0x1e0
do_rmdir+0x262/0x2c0
do_syscall_64+0x77/0x230
entry_SYSCALL_64_after_hwframe+0x49/0xbe

Fixes: a42d985bd5b2 ("ib_srpt: Initial SRP Target merge for v3.3-rc1")
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: <stable@vger.kernel.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 325bae29e90d..705f6a992d82 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2152,6 +2152,7 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
 	}
 
 	kref_init(&ch->kref);
+	kref_get(&ch->kref);
 	ch->pkey = be16_to_cpu(pkey);
 	ch->nexus = nexus;
 	ch->zw_cqe.done = srpt_zerolength_write_done;
@@ -3212,6 +3213,7 @@ static void srpt_close_session(struct se_session *se_sess)
 	struct srpt_rdma_ch *ch = se_sess->fabric_sess_ptr;
 
 	srpt_disconnect_ch_sync(ch);
+	kref_put(&ch->kref, srpt_free_ch);
 }
 
 /**
-- 
2.18.0
