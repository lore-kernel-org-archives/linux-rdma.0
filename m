From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core] qede: fix general protection fault may occur on probe
Date: Tue, 25 Oct 2016 15:53:59 +0300
Message-ID: <1477400039-16925-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Yuval.Mintz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The recent introduction of qedr driver support in qede causes a
GPF when probing the driver in a server without a RoCE enabled
QLogic NIC. This fix avoids using an uninitialized pointer in such
a case. Caught by the kernel test robot.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 drivers/net/ethernet/qlogic/qede/qede_roce.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_roce.c b/drivers/net/ethernet/qlogic/qede/qede_roce.c
index 9867f96..4927271 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_roce.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_roce.c
@@ -191,8 +191,8 @@ int qede_roce_register_driver(struct qedr_driver *drv)
 	}
 	mutex_unlock(&qedr_dev_list_lock);
 
-	DP_INFO(edev, "qedr: discovered and registered %d RoCE funcs\n",
-		qedr_counter);
+	pr_notice("qedr: discovered and registered %d RoCE funcs\n",
+		  qedr_counter);
 
 	return 0;
 }
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
