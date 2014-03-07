From: Hariprasad Shenai <hariprasad@chelsio.com>
Subject: [PATCHv4 net-next 15/32] iw_cxgb4: default peer2peer mode to 1
Date: Fri,  7 Mar 2014 16:03:12 +0530
Message-ID: <1394188409-9739-16-git-send-email-hariprasad@chelsio.com>
References: <1394188409-9739-1-git-send-email-hariprasad@chelsio.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1394188409-9739-1-git-send-email-hariprasad@chelsio.com>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: davem@davemloft.net, roland@purestorage.com, santosh@chelsio.com, dm@chelsio.com, kumaras@chelsio.com, swise@opengridcomputing.com, leedom@chelsio.com, nirranjan@chelsio.com, hariprasad@chelsio.com
List-Id: linux-rdma@vger.kernel.org

From: Steve Wise <swise@opengridcomputing.com>

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---
 drivers/infiniband/hw/cxgb4/cm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index c63dfe5..899be48 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -98,9 +98,9 @@ int c4iw_debug;
 module_param(c4iw_debug, int, 0644);
 MODULE_PARM_DESC(c4iw_debug, "Enable debug logging (default=0)");
 
-static int peer2peer;
+static int peer2peer = 1;
 module_param(peer2peer, int, 0644);
-MODULE_PARM_DESC(peer2peer, "Support peer2peer ULPs (default=0)");
+MODULE_PARM_DESC(peer2peer, "Support peer2peer ULPs (default=1)");
 
 static int p2p_type = FW_RI_INIT_P2PTYPE_READ_REQ;
 module_param(p2p_type, int, 0644);
-- 
1.8.4
