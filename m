From: =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>
Subject: [PATCH] mlx4_ib: Increase the timeout for CM cache
Date: Thu, 31 Jan 2019 18:09:51 +0100
Message-ID: <20190131170951.178676-1-haakon.bugge@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "David S . Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Using CX-3 virtual functions, either from a bare-metal machine or
pass-through from a VM, MAD packets are proxied through the PF driver.

Since the VMs have separate name spaces for MAD Transaction Ids
(TIDs), the PF driver has to re-map the TIDs and keep the book keeping
in a cache.

Following the RDMA CM protocol, it is clear when an entry has to
evicted form the cache. But life is not perfect, remote peers may die
or be rebooted. Hence, it's a timeout to wipe out a cache entry, when
the PF driver assumes the remote peer has gone.

We have experienced excessive amount of DREQ retries during fail-over
testing, when running with eight VMs per database server.

The problem has been reproduced in a bare-metal system using one VM
per physical node. In this environment, running 256 processes in each
VM, each process uses RDMA CM to create an RC QP between himself and
all (256) remote processes. All in all 16K QPs.

When tearing down these 16K QPs, excessive DREQ retries (and
duplicates) are observed. With some cat/paste/awk wizardry on the
infiniband_cm sysfs, we observe:

      dreq:       5007
cm_rx_msgs:
      drep:       3838
      dreq:      13018
       rep:       8128
       req:       8256
       rtu:       8256
cm_tx_msgs:
      drep:       8011
      dreq:      68856
       rep:       8256
       req:       8128
       rtu:       8128
cm_tx_retries:
      dreq:      60483

Note that the active/passive side is distributed.

Enabling pr_debug in cm.c gives tons of:

[171778.814239] <mlx4_ib> mlx4_ib_multiplex_cm_handler: id{slave:
1,sl_cm_id: 0xd393089f} is NULL!

By increasing the CM_CLEANUP_CACHE_TIMEOUT from 5 to 30 seconds, the
tear-down phase of the application is reduced from 113 to 67
seconds. Retries/duplicates are also significantly reduced:

cm_rx_duplicates:
      dreq:       7726
[]
cm_tx_retries:
      drep:          1
      dreq:       7779

Increasing the timeout further didn't help, as these duplicates and
retries stem from a too short CMA timeout, which was 20 (~4 seconds)
on the systems. By increasing the CMA timeout to 22 (~17 seconds), the
numbers fell down to about one hundred for both of them.

Adjustment of the CMA timeout is _not_ part of this commit.

Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
---
 drivers/infiniband/hw/mlx4/cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/cm.c b/drivers/infiniband/hw/mlx4/cm.c
index fedaf8260105..8c79a480f2b7 100644
--- a/drivers/infiniband/hw/mlx4/cm.c
+++ b/drivers/infiniband/hw/mlx4/cm.c
@@ -39,7 +39,7 @@
 
 #include "mlx4_ib.h"
 
-#define CM_CLEANUP_CACHE_TIMEOUT  (5 * HZ)
+#define CM_CLEANUP_CACHE_TIMEOUT  (30 * HZ)
 
 struct id_map_entry {
 	struct rb_node node;
-- 
2.20.1
