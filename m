From: Hans Westgaard Ry <hans.westgaard.ry-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/ipoib: Add handling of skb with many frags
Date: Thu, 18 Feb 2016 09:37:54 +0100
Message-ID: <1455784674-8412-1-git-send-email-hans.westgaard.ry@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hans Westgaard Ry <hans.westgaard.ry-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christian Marie <christian-x8YiTEMPTCFhl2p70BpVqQ@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Wei Lin Guay <wei.lin.guay-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "open list:INFINIBAND SUBSYSTEM" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

IPoIB converts skb-fragments to sge adding 1 extra sge when offloading
is enabled. Current codepath assumes that the max number of sge a devic=
e
support is at least MAX_SKB_FRAGS+1, there is no interaction with upper
layers to limit number of fragments in an skb if a device suports fewer
sge. The assumptions also lead to requesting a fixed number ot sge when
IPoIB creates queue-pairs with scatter/gather enabled.

A fallback/slowpath is implemented using skb_linearize to
handle cases where the conversion would result in more sges than suppor=
ted.

Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: H=C3=A5kon Bugge <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Wei Lin Guay <wei.lin.guay-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_cm.c    | 4 +++-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c    | 9 +++++++++
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c | 4 +++-
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniba=
nd/ulp/ipoib/ipoib_cm.c
index 917e46e..0a2bd43 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -1031,7 +1031,9 @@ static struct ib_qp *ipoib_cm_create_tx_qp(struct=
 net_device *dev, struct ipoib_
 	struct ib_qp *tx_qp;
=20
 	if (dev->features & NETIF_F_SG)
-		attr.cap.max_send_sge =3D MAX_SKB_FRAGS + 1;
+		attr.cap.max_send_sge =3D min_t(u32,
+					      priv->ca->attrs.max_sge,
+					      MAX_SKB_FRAGS + 1);
=20
 	tx_qp =3D ib_create_qp(priv->pd, &attr);
 	if (PTR_ERR(tx_qp) =3D=3D -EINVAL) {
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniba=
nd/ulp/ipoib/ipoib_ib.c
index 5ea0c14..b4f2240 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -541,6 +541,15 @@ void ipoib_send(struct net_device *dev, struct sk_=
buff *skb,
 	int hlen, rc;
 	void *phead;
=20
+	if (skb_shinfo(skb)->nr_frags >=3D priv->ca->attrs.max_sge) {
+		if (skb_linearize(skb) !=3D 0) {
+			ipoib_warn(priv, "skb could not be linearized\n");
+			++dev->stats.tx_dropped;
+			++dev->stats.tx_errors;
+			dev_kfree_skb_any(skb);
+			return;
+		}
+	}
 	if (skb_is_gso(skb)) {
 		hlen =3D skb_transport_offset(skb) + tcp_hdrlen(skb);
 		phead =3D skb->data;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c b/drivers/infin=
iband/ulp/ipoib/ipoib_verbs.c
index d48c5ba..62f8ec3 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
@@ -206,7 +206,9 @@ int ipoib_transport_dev_init(struct net_device *dev=
, struct ib_device *ca)
 		init_attr.create_flags |=3D IB_QP_CREATE_NETIF_QP;
=20
 	if (dev->features & NETIF_F_SG)
-		init_attr.cap.max_send_sge =3D MAX_SKB_FRAGS + 1;
+		init_attr.cap.max_send_sge =3D min_t(u32,
+						   priv->ca->attrs.max_sge,
+						   MAX_SKB_FRAGS + 1);
=20
 	priv->qp =3D ib_create_qp(priv->pd, &init_attr);
 	if (IS_ERR(priv->qp)) {
--=20
2.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
