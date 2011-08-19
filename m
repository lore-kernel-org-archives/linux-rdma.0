From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 15/20 v2] ib/cm: Do not automatically disconnect XRC TGT QPs
Date: Fri, 19 Aug 2011 02:14:06 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E41A73@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Because an XRC TGT QP can end up being shared among multiple
processes, don't have the ib_cm automatically send a DREQ
when the user space process that owns the ib_cm_id exits.
Disconnect can be initiated by the user directly, otherwise,
the owner of the XRC INI QP controls the connection.

Note that as a result of the process exiting, the ib_cm will
stop tracking the XRC connection on the target side.  For the
purposes of disconnecting, this isn't a big deal.  The ib_cm
will respond to the DREQ appropriately.  For other messages,
mainly LAP, the cm will reject the request, since there's no
one available to route the request to.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 42a7a9b..4104ea2 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -889,6 +889,8 @@ retest:
 		break;
 	case IB_CM_ESTABLISHED:
 		spin_unlock_irq(&cm_id_priv->lock);
+		if (cm_id_priv->qp_type == IB_QPT_XRC_TGT)
+			break;
 		ib_send_cm_dreq(cm_id, NULL, 0);
 		goto retest;
 	case IB_CM_DREQ_SENT:


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
