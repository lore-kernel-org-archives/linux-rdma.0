From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] IB/ipoib: Skip napi_schedule if ib_poll_cq fails
Date: Wed, 13 Jul 2016 08:21:56 -0700
Message-ID: <1468423316-28246-2-git-send-email-yuval.shaia@oracle.com>
References: <1468423316-28246-1-git-send-email-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468423316-28246-1-git-send-email-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

To avoid entering into endless loop when device can't poll CQE from CQ
driver should not reschedule if error is not -EAGAIN.

Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Suggested-by: H=C3=A5kon Bugge <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Acked-by: Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h       |    5 +++++
 drivers/infiniband/ulp/ipoib/ipoib_ib.c    |   13 ++++++++++++-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c |    1 +
 3 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/=
ulp/ipoib/ipoib.h
index 4f7d9b4..1946149 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -116,6 +116,8 @@ enum {
 	IPOIB_NON_CHILD		  =3D 0,
 	IPOIB_LEGACY_CHILD	  =3D 1,
 	IPOIB_RTNL_CHILD	  =3D 2,
+
+	IPOIB_MAX_CONSEQ_CQ_ERR	  =3D 10,
 };
=20
 #define	IPOIB_OP_RECV   (1ul << 31)
@@ -347,6 +349,7 @@ struct ipoib_dev_priv {
 	u16		  pkey_index;
 	struct ib_pd	 *pd;
 	struct ib_cq	 *recv_cq;
+	int		  recv_conseq_cq_errs;
 	struct ib_cq	 *send_cq;
 	struct ib_qp	 *qp;
 	u32		  qkey;
@@ -772,6 +775,8 @@ static inline void ipoib_unregister_debugfs(void) {=
 }
 	printk(level "%s: " format, ((struct ipoib_dev_priv *) priv)->dev->na=
me , ## arg)
 #define ipoib_warn(priv, format, arg...)		\
 	ipoib_printk(KERN_WARNING, priv, format , ## arg)
+#define ipoib_crit(priv, format, arg...)		\
+	ipoib_printk(KERN_CRIT, priv, format , ## arg)
=20
 extern int ipoib_sendq_size;
 extern int ipoib_recvq_size;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniba=
nd/ulp/ipoib/ipoib_ib.c
index dc6d241..9395a24 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -449,7 +449,8 @@ int ipoib_poll(struct napi_struct *napi, int budget=
)
 	int t;
 	int n, i;
=20
-	done  =3D 0;
+	done =3D 0;
+	n =3D 0;
=20
 poll_more:
 	while (done < budget) {
@@ -475,6 +476,16 @@ poll_more:
 			break;
 	}
=20
+	if (unlikely(n < 0) && (n !=3D -EAGAIN)) {
+		if (priv->recv_conseq_cq_errs++ >=3D IPOIB_MAX_CONSEQ_CQ_ERR) {
+			ipoib_crit(priv,
+				   "Too many poll_cq errors, last error: %d\n",
+				   n);
+			return done;
+		}
+	} else
+		priv->recv_conseq_cq_errs =3D 0;
+
 	if (done < budget) {
 		napi_complete(napi);
 		if (unlikely(ib_req_notify_cq(priv->recv_cq,
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c b/drivers/infin=
iband/ulp/ipoib/ipoib_verbs.c
index 1e7cbba..6ca8bdd 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
@@ -181,6 +181,7 @@ int ipoib_transport_dev_init(struct net_device *dev=
, struct ib_device *ca)
 		printk(KERN_WARNING "%s: failed to create receive CQ\n", ca->name);
 		goto out_cm_dev_cleanup;
 	}
+	priv->recv_conseq_cq_errs =3D 0;
=20
 	cq_attr.cqe =3D ipoib_sendq_size;
 	priv->send_cq =3D ib_create_cq(priv->ca, ipoib_send_comp_handler, NUL=
L,
--=20
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
