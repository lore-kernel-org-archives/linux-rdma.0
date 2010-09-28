From: Animesh K Trivedi1 <ATR-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: fixing blocking rdma_connect call on failure
Date: Tue, 28 Sep 2010 16:44:02 +0200
Message-ID: <OFD1E009D6.AB14F4A6-ONC12577AC.00485D02-C12577AC.0050EF83@ch.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Hi,

Below is a short patch to eliminate an uninterruptible indefinite wait in
kernel while destroying the cm_id when iw_cm_connect(...) fails.

It happens when creation of a protection domain fails but user, without
checking the return value, continues with an attempt to connect to the
server. In the call iw_cm_connect(...) it retrieves  a NULL qp from the
device and fails, but does not clear the IWCM_F_CONNECT_WAIT bit. In
destroy_cm_id(...) it  waits on clearance of IWCM_F_CONNECT_WAIT bit which
never happens.

Same goes with the accept call.

I am not on the list, so please cc me for the comments and changes.

Thanks,
--
Animesh



Signed-off-by: Animesh Trivedi <atr-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>

diff --git a/drivers/infiniband/core/iwcm.c
b/drivers/infiniband/core/iwcm.c
index bfead5b..2a1e9ae 100644
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -506,6 +506,8 @@ int iw_cm_accept(struct iw_cm_id *cm_id,
      qp = cm_id->device->iwcm->get_qp(cm_id->device, iw_param->qpn);
      if (!qp) {
            spin_unlock_irqrestore(&cm_id_priv->lock, flags);
+           clear_bit(IWCM_F_CONNECT_WAIT, &cm_id_priv->flags);
+           wake_up_all(&cm_id_priv->connect_wait);
            return -EINVAL;
      }
      cm_id->device->iwcm->add_ref(qp);
@@ -565,6 +567,8 @@ int iw_cm_connect(struct iw_cm_id *cm_id, struct
iw_cm_conn_param *iw_param)
      qp = cm_id->device->iwcm->get_qp(cm_id->device, iw_param->qpn);
      if (!qp) {
            spin_unlock_irqrestore(&cm_id_priv->lock, flags);
+           clear_bit(IWCM_F_CONNECT_WAIT, &cm_id_priv->flags);
+           wake_up_all(&cm_id_priv->connect_wait);
            return -EINVAL;
      }
      cm_id->device->iwcm->add_ref(qp);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
