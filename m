From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 3/7] IB/iser: Set IP_CSUM as default guard type
Date: Wed, 13 Aug 2014 19:54:31 +0300
Message-ID: <1407948875-733-4-git-send-email-sagig@mellanox.com>
References: <1407948875-733-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1407948875-733-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: roland@kernel.org, nab@linux-iscsi.org
Cc: martin.petersen@oracle.com, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, oren@mellanox.com
List-Id: linux-rdma@vger.kernel.org

In the future this will be a per-command parameter so we
can lose it, but in the mean time IP_CSUM is a lot lighter
for SW layers to compute, set it as default.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index eb79739..d42658f 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -83,7 +83,7 @@ module_param_named(max_lun, iscsi_max_lun, uint, S_IRUGO);
 
 int iser_debug_level = 0;
 bool iser_pi_enable = false;
-int iser_pi_guard = 0;
+int iser_pi_guard = 1;
 
 MODULE_DESCRIPTION("iSER (iSCSI Extensions for RDMA) Datamover");
 MODULE_LICENSE("Dual BSD/GPL");
@@ -97,7 +97,7 @@ module_param_named(pi_enable, iser_pi_enable, bool, 0644);
 MODULE_PARM_DESC(pi_enable, "Enable T10-PI offload support (default:disabled)");
 
 module_param_named(pi_guard, iser_pi_guard, int, 0644);
-MODULE_PARM_DESC(pi_guard, "T10-PI guard_type, 0:CRC|1:IP_CSUM (default:CRC)");
+MODULE_PARM_DESC(pi_guard, "T10-PI guard_type, 0:CRC|1:IP_CSUM (default:IP_CSUM)");
 
 static struct workqueue_struct *release_wq;
 struct iser_global ig;
-- 
1.7.1
