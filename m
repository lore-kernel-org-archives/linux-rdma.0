From: "Boyer, Andrew" <Andrew.Boyer-8PEkshWhKlo@public.gmane.org>
Subject: Re: [PATCH 11/15] IB/rxe: Generate a completion for all failed work
 requests
Date: Mon, 9 Jan 2017 15:15:29 +0000
Message-ID: <D4991303.90AA%Andrew.Boyer@emc.com>
References: <1483353316.3592.14.camel@sandisk.com>
 <1483353685.3592.34.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1483353685.3592.34.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-US
Content-ID: <9366344E91A54144996423D5203E82FC-/m+UfqrgI5Tvk4DGDgVwFwC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/2/17, 5:42 AM, "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:

>Change do_complete() such that an error completion is not only
>generated if a QP is in the error state but also if a work request
>failed.
>
>Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
>Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
>---
> drivers/infiniband/sw/rxe/rxe_comp.c |  3 ++-
> drivers/infiniband/sw/rxe/rxe_loc.h  |  1 +
> drivers/infiniband/sw/rxe/rxe_req.c  | 18 +++++++-----------
> drivers/infiniband/sw/rxe/rxe_resp.c |  2 +-
> 4 files changed, 11 insertions(+), 13 deletions(-)
>
>diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c
>b/drivers/infiniband/sw/rxe/rxe_comp.c
>index 6769a075501e..d1c3411c5478 100644
>--- a/drivers/infiniband/sw/rxe/rxe_comp.c
>+++ b/drivers/infiniband/sw/rxe/rxe_comp.c
>@@ -418,7 +418,7 @@ static void do_complete(struct rxe_qp *qp, struct
>rxe_send_wqe *wqe)
>=20
> 	if ((qp->sq_sig_type =3D=3D IB_SIGNAL_ALL_WR) ||
> 	    (wqe->wr.send_flags & IB_SEND_SIGNALED) ||
>-	    (qp->req.state =3D=3D QP_STATE_ERROR)) {
>+	    wqe->status !=3D IB_WC_SUCCESS) {
> 		make_send_cqe(qp, wqe, &cqe);
> 		advance_consumer(qp->sq.queue);
> 		rxe_cq_post(qp->scq, &cqe, 0);
>@@ -709,6 +709,7 @@ int rxe_completer(void *arg)
> 			break;
>=20
> 		case COMPST_ERROR:
>+			WARN_ON_ONCE(wqe->status =3D=3D IB_WC_SUCCESS);
> 			do_complete(qp, wqe);
> 			rxe_qp_error(qp);
>=20
>diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h
>b/drivers/infiniband/sw/rxe/rxe_loc.h
>index da191d7acb6f..bdec460f1fce 100644
>--- a/drivers/infiniband/sw/rxe/rxe_loc.h
>+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
>@@ -225,6 +225,7 @@ extern struct ib_dma_mapping_ops rxe_dma_mapping_ops;
>=20
> void rxe_release(struct kref *kref);
>=20
>+void rxe_drain_req_pkts(struct rxe_qp *qp, bool notify);
> int rxe_completer(void *arg);
> int rxe_requester(void *arg);
> int rxe_responder(void *arg);
>diff --git a/drivers/infiniband/sw/rxe/rxe_req.c
>b/drivers/infiniband/sw/rxe/rxe_req.c
>index b95b6035e988..64999f529981 100644
>--- a/drivers/infiniband/sw/rxe/rxe_req.c
>+++ b/drivers/infiniband/sw/rxe/rxe_req.c
>@@ -594,9 +594,14 @@ int rxe_requester(void *arg)
> 	rxe_add_ref(qp);
>=20
> next_wqe:
>-	if (unlikely(!qp->valid || qp->req.state =3D=3D QP_STATE_ERROR))
>+	if (unlikely(!qp->valid))
> 		goto exit;
>=20
>+	if (unlikely(qp->req.state =3D=3D QP_STATE_ERROR)) {
>+		rxe_drain_req_pkts(qp, true);
>+		goto exit;
>+	}
>+
> 	if (unlikely(qp->req.state =3D=3D QP_STATE_RESET)) {
> 		qp->req.wqe_index =3D consumer_index(qp->sq.queue);
> 		qp->req.opcode =3D -1;
>@@ -743,17 +748,8 @@ int rxe_requester(void *arg)
> 	kfree_skb(skb);
> 	wqe->status =3D IB_WC_LOC_PROT_ERR;
> 	wqe->state =3D wqe_state_error;
>-
>-	/*
>-	 * IBA Spec. Section 10.7.3.1 SIGNALED COMPLETIONS
>-	 * ---------8<---------8<-------------
>-	 * ...Note that if a completion error occurs, a Work Completion
>-	 * will always be generated, even if the signaling
>-	 * indicator requests an Unsignaled Completion.
>-	 * ---------8<---------8<-------------
>-	 */

It wouldn=B9t hurt to move this comment over to the top of do_complete() to
explain the wqe->status !=3D IB_WC_SUCCESS test.

Reviewed-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>


>-	wqe->wr.send_flags |=3D IB_SEND_SIGNALED;
> 	__rxe_do_task(&qp->comp.task);
>+
> exit:
> 	rxe_drop_ref(qp);
> 	return -EAGAIN;
>diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c
>b/drivers/infiniband/sw/rxe/rxe_resp.c
>index 25951e9413b8..33defaddc000 100644
>--- a/drivers/infiniband/sw/rxe/rxe_resp.c
>+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
>@@ -1207,7 +1207,7 @@ static enum resp_states do_class_d1e_error(struct
>rxe_qp *qp)
> 	}
> }
>=20
>-static void rxe_drain_req_pkts(struct rxe_qp *qp, bool notify)
>+void rxe_drain_req_pkts(struct rxe_qp *qp, bool notify)
> {
> 	struct sk_buff *skb;
>=20
>--=20
>2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
