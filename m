From: Baole Ni <baolex.ni@intel.com>
Subject: [PATCH 0252/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 18:53:28 +0800
Message-ID: <20160802105328.30539-1-baolex.ni@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, airlied@linux.ie, kgene@kernel.org, k.kozlowski@samsung.com, dougthompson@xmission.com, bp@alien8.de
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, ira.weiny@intel.com, sagi@grimberg.me, hch@infradead.org, matanb@mellanox.com, markb@mellanox.com, jgunthorpe@obsidianresearch.com, dean.luick@intel.com, chuansheng.liu@intel.com, baolex.ni@intel.com
List-Id: linux-rdma@vger.kernel.org

I find that the developers often just specified the numeric value
when calling a macro which is defined with a parameter for access permission.
As we know, these numeric value for access permission have had the corresponding macro,
and that using macro can improve the robustness and readability of the code,
thus, I suggest replacing the numeric parameter with the macro.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Baole Ni <baolex.ni@intel.com>
---
 drivers/infiniband/core/mad.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 2d49228..d78e96f 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -52,9 +52,9 @@
 static int mad_sendq_size = IB_MAD_QP_SEND_SIZE;
 static int mad_recvq_size = IB_MAD_QP_RECV_SIZE;
 
-module_param_named(send_queue_size, mad_sendq_size, int, 0444);
+module_param_named(send_queue_size, mad_sendq_size, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(send_queue_size, "Size of send queue in number of work requests");
-module_param_named(recv_queue_size, mad_recvq_size, int, 0444);
+module_param_named(recv_queue_size, mad_recvq_size, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(recv_queue_size, "Size of receive queue in number of work requests");
 
 static struct list_head ib_mad_port_list;
-- 
2.9.2
