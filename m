From: "Boyer, Andrew" <Andrew.Boyer-8PEkshWhKlo@public.gmane.org>
Subject: Re: [PATCH 10/15] IB/rxe: Introduce functions for queue draining
Date: Mon, 9 Jan 2017 15:06:39 +0000
Message-ID: <D49910D0.9088%Andrew.Boyer@emc.com>
References: <1483353316.3592.14.camel@sandisk.com>
 <1483353661.3592.32.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1483353661.3592.32.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-US
Content-ID: <F9AA24A68C17F240932A43CD6B0196D3-/m+UfqrgI5Tvk4DGDgVwFwC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 1/2/17, 5:42 AM, "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:

>This change makes the code easier to read and avoids that code is
>duplicated.
>
>Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
>Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
>---
> drivers/infiniband/sw/rxe/rxe_comp.c | 63
>+++++++++++++-----------------------
> drivers/infiniband/sw/rxe/rxe_resp.c | 28 ++++++++--------
> 2 files changed, 38 insertions(+), 53 deletions(-)
>
>diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c
>b/drivers/infiniband/sw/rxe/rxe_comp.c
>index e912e5396e8c..6769a075501e 100644
>--- a/drivers/infiniband/sw/rxe/rxe_comp.c
>+++ b/drivers/infiniband/sw/rxe/rxe_comp.c
>@@ -503,57 +503,40 @@ static inline enum comp_state complete_wqe(struct
>rxe_qp *qp,
> 	return COMPST_GET_WQE;
> }
>=20
>-int rxe_completer(void *arg)
>+static void rxe_drain_resp_pkts(struct rxe_qp *qp, bool notify)
> {
>-	struct rxe_qp *qp =3D (struct rxe_qp *)arg;
>-	struct rxe_send_wqe *wqe =3D wqe;
>-	struct sk_buff *skb =3D NULL;
>-	struct rxe_pkt_info *pkt =3D NULL;
>-	enum comp_state state;
>-
>-	rxe_add_ref(qp);
>-
>-	if (!qp->valid) {
>-		while ((skb =3D skb_dequeue(&qp->resp_pkts))) {
>-			rxe_drop_ref(qp);
>-			kfree_skb(skb);
>-		}
>-		skb =3D NULL;
>-		pkt =3D NULL;
>-
>-		while (queue_head(qp->sq.queue))
>-			advance_consumer(qp->sq.queue);
>+	struct sk_buff *skb;
>+	struct rxe_send_wqe *wqe;
>=20
>-		goto exit;
>+	while ((skb =3D skb_dequeue(&qp->resp_pkts))) {
>+		rxe_drop_ref(qp);
>+		kfree_skb(skb);
> 	}
>=20
>-	if (qp->req.state =3D=3D QP_STATE_ERROR) {
>-		while ((skb =3D skb_dequeue(&qp->resp_pkts))) {
>-			rxe_drop_ref(qp);
>-			kfree_skb(skb);
>-		}
>-		skb =3D NULL;
>-		pkt =3D NULL;
>-
>-		while ((wqe =3D queue_head(qp->sq.queue))) {
>+	while ((wqe =3D queue_head(qp->sq.queue))) {
>+		if (notify) {
> 			wqe->status =3D IB_WC_WR_FLUSH_ERR;
> 			do_complete(qp, wqe);
>+		} else {
>+			advance_consumer(qp->sq.queue);
> 		}
>-
>-		goto exit;
> 	}
>+}
>=20
>-	if (qp->req.state =3D=3D QP_STATE_RESET) {
>-		while ((skb =3D skb_dequeue(&qp->resp_pkts))) {
>-			rxe_drop_ref(qp);
>-			kfree_skb(skb);
>-		}
>-		skb =3D NULL;
>-		pkt =3D NULL;
>+int rxe_completer(void *arg)
>+{
>+	struct rxe_qp *qp =3D (struct rxe_qp *)arg;
>+	struct rxe_send_wqe *wqe =3D wqe;
>+	struct sk_buff *skb =3D NULL;
>+	struct rxe_pkt_info *pkt =3D NULL;
>+	enum comp_state state;
>=20
>-		while (queue_head(qp->sq.queue))
>-			advance_consumer(qp->sq.queue);
>+	rxe_add_ref(qp);
>=20
>+	if (!qp->valid || qp->req.state =3D=3D QP_STATE_ERROR ||
>+	    qp->req.state =3D=3D QP_STATE_RESET) {
>+		rxe_drain_resp_pkts(qp, qp->valid &&
>+				    qp->req.state =3D=3D QP_STATE_ERROR);
> 		goto exit;
> 	}
>=20
>diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c
>b/drivers/infiniband/sw/rxe/rxe_resp.c
>index 6dbd069689fc..25951e9413b8 100644
>--- a/drivers/infiniband/sw/rxe/rxe_resp.c
>+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
>@@ -1207,6 +1207,19 @@ static enum resp_states do_class_d1e_error(struct
>rxe_qp *qp)
> 	}
> }
>=20
>+static void rxe_drain_req_pkts(struct rxe_qp *qp, bool notify)

Is notify unused? Is it here just for symmetry with the responder?

>+{
>+	struct sk_buff *skb;
>+
>+	while ((skb =3D skb_dequeue(&qp->req_pkts))) {
>+		rxe_drop_ref(qp);
>+		kfree_skb(skb);
>+	}
>+
>+	while (!qp->srq && qp->rq.queue && queue_head(qp->rq.queue))
>+		advance_consumer(qp->rq.queue);
>+}
>+
> int rxe_responder(void *arg)
> {
> 	struct rxe_qp *qp =3D (struct rxe_qp *)arg;
>@@ -1374,21 +1387,10 @@ int rxe_responder(void *arg)
>=20
> 			goto exit;
>=20
>-		case RESPST_RESET: {
>-			struct sk_buff *skb;
>-
>-			while ((skb =3D skb_dequeue(&qp->req_pkts))) {
>-				rxe_drop_ref(qp);
>-				kfree_skb(skb);
>-			}
>-
>-			while (!qp->srq && qp->rq.queue &&
>-			       queue_head(qp->rq.queue))
>-				advance_consumer(qp->rq.queue);
>-
>+		case RESPST_RESET:
>+			rxe_drain_req_pkts(qp, false);
> 			qp->resp.wqe =3D NULL;
> 			goto exit;
>-		}
>=20
> 		case RESPST_ERROR:
> 			qp->resp.goto_error =3D 0;
>--=20
>2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
