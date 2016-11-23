From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] qede: fix general protection fault may occur on probe
Date: Wed, 23 Nov 2016 08:03:04 +0000
Message-ID: <SN1PR07MB220763908ED050AAFE840CEAF8B70@SN1PR07MB2207.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Mintz, Yuval" <Yuval.Mintz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The recent introduction of qedr driver support in qede causes a GPF when pr=
obing the driver in a server without a RoCE enabled QLogic NIC. This fix av=
oids using an uninitialized pointer in such a case. Caught by the kernel te=
st robot.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
drivers/net/ethernet/qlogic/qede/qede_roce.c | 4 ++--
1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_roce.c b/drivers/net/eth=
ernet/qlogic/qede/qede_roce.c
index 9867f96..4927271 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_roce.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_roce.c
@@ -191,8 +191,8 @@ int qede_roce_register_driver(struct qedr_driver *drv)
              }
              mutex_unlock(&qedr_dev_list_lock);

-              DP_INFO(edev, "qedr: discovered and registered %d RoCE funcs=
\n",
-                             qedr_counter);
+             pr_notice("qedr: discovered and registered %d RoCE funcs\n",
+                              qedr_counter);

               return 0;
}
--
1.8.3.1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
