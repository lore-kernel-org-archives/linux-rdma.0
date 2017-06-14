From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 4/5] IB/ipoib: Fix access to un-initialized napi struct
Date: Wed, 14 Jun 2017 09:59:08 +0300
Message-ID: <20170614065909.23650-5-leon@kernel.org>
References: <20170614065909.23650-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170614065909.23650-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

There is no need to re-enable napi since we set the initialized
flag before calling ipoib_ib_dev_stop which will disable napi,
disabling napi twice is harmless in case it was already disabled.

One more reason for this fix is that when using IPoIB new device
driver napi is not added to priv, this can lead to kernel panic
when rn_ops ndo_open fails.

[ 289.755840] invalid opcode: 0000 [#1] SMP
[ 289.757111] task: ffff880036964440 ti: ffff880178ee8000 task.ti: ffff880178ee8000
[ 289.757111] RIP: 0010:[<ffffffffa05368d6>] [<ffffffffa05368d6>] napi_enable.part.24+0x4/0x6 [ib_ipoib]
[ 289.757111] RSP: 0018:ffff880178eeb6d8 EFLAGS: 00010246
[ 289.757111] RAX: 0000000000000000 RBX: ffff880177a80010 RCX: 000000007fffffff
[ 289.757111] RDX: ffffffff81d5f118 RSI: 0000000000000000 RDI: ffff880177a80010
[ 289.757111] RBP: ffff880178eeb6d8 R08: 0000000000000082 R09: 0000000000000283
[ 289.757111] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880175a00000
[ 289.757111] R13: ffff880177a80080 R14: 0000000000000000 R15: 0000000000000001
[ 289.757111] FS: 00007fe2ee346880(0000) GS:ffff88017fc00000(0000) knlGS:0000000000000000
[ 289.757111] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 289.757111] CR2: 00007fffca979020 CR3: 00000001792e4000 CR4: 00000000000006f0
[ 289.757111] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 289.757111] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 289.757111] Stack:
[ 289.796027] ffff880178eeb6f0 ffffffffa05251f5 ffff880177a80000 ffff880178eeb718
[ 289.796027] ffffffffa0528505 ffff880175a00000 ffff880177a80000 0000000000000000
[ 289.796027] ffff880178eeb748 ffffffffa051f0ab ffff880175a00000 ffffffffa0537d60
[ 289.796027] Call Trace:
[ 289.796027] [<ffffffffa05251f5>] napi_enable+0x25/0x30 [ib_ipoib]
[ 289.796027] [<ffffffffa0528505>] ipoib_ib_dev_open+0x175/0x190 [ib_ipoib]
[ 289.796027] [<ffffffffa051f0ab>] ipoib_open+0x4b/0x160 [ib_ipoib]
[ 289.796027] [<ffffffff814fe33f>] _dev_open+0xbf/0x130
[ 289.796027] [<ffffffff814fe62d>] __dev_change_flags+0x9d/0x170
[ 289.796027] [<ffffffff814fe729>] dev_change_flags+0x29/0x60
[ 289.796027] [<ffffffff8150caf7>] do_setlink+0x397/0xa40

Fixes: cd565b4b51e5 ('IB/IPoIB: Support acceleration options callbacks')
Signed-off-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_ib.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 0060b2f9f659..efe7402f4885 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -863,7 +863,6 @@ int ipoib_ib_dev_open(struct net_device *dev)
 	set_bit(IPOIB_STOP_REAPER, &priv->flags);
 	cancel_delayed_work(&priv->ah_reap_task);
 	set_bit(IPOIB_FLAG_INITIALIZED, &priv->flags);
-	napi_enable(&priv->napi);
 	ipoib_ib_dev_stop(dev);
 	return -1;
 }
-- 
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
