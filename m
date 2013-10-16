From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH net-next 6/7] IB/ipoib: Add path queries flushing in ipoib_ib_dev_cleanup
Date: Wed, 16 Oct 2013 17:37:52 +0300
Message-ID: <1381934273-29683-7-git-send-email-ogerlitz@mellanox.com>
References: <1381934273-29683-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1381934273-29683-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Alex Markuze <markuze-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The path_rec_completion() callback may be invoked asynchronously even at the
middle of "driver uninit" process. This can lead to scheduling a task that tries
to touch members of the priv object that are no longer valid. For example the
function cm_create_tx_qp can attempt to create qp with no valid priv->pd object.

The following crash is one of the results:
RIP: 0010:[<ffffffffa021bb47>]  [<ffffffffa021bb47>] ipoib_cm_create_tx_qp+0x57/0x90 [ib_ipoib]
Process ipoib (pid: 5916, threadinfo ffff8803786e4000, task ffff8804150e1500)
Stack:
Call Trace:
[<ffffffff81309ef0>] ? get_random_bytes+0x20/0x30
[<ffffffffa021be2a>] ipoib_cm_tx_init+0xca/0x340 [ib_ipoib]
[<ffffffffa021f765>] ipoib_cm_tx_start+0x215/0x3f0 [ib_ipoib]
[<ffffffffa021f550>] ? ipoib_cm_tx_start+0x0/0x3f0 [ib_ipoib]
[<ffffffff8108b2b0>] worker_thread+0x170/0x2a0
[<ffffffff81090bf0>] ? autoremove_wake_function+0x0/0x40
[<ffffffff8108b140>] ? worker_thread+0x0/0x2a0
[<ffffffff81090886>] kthread+0x96/0xa0
[<ffffffff8100c14a>] child_rip+0xa/0x20
[<ffffffff810907f0>] ? kthread+0x0/0xa0
[<ffffffff8100c140>] ? child_rip+0x0/0x20

Fix that by flushing all pending path queries at this point.

Signed-off-by: Alex Markuze <markuze-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_ib.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index ff64b16..6a7003d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -1082,6 +1082,11 @@ void ipoib_ib_dev_cleanup(struct net_device *dev)
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 
 	ipoib_dbg(priv, "cleaning up ib_dev\n");
+	/*
+	 * We must make sure there are no more (path) completions
+	 * that may wish to touch priv fields that are no longer valid
+	 */
+	ipoib_flush_paths(dev);
 
 	ipoib_mcast_stop_thread(dev, 1);
 	ipoib_mcast_dev_flush(dev);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
