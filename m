From: "Boyer, Andrew" <Andrew.Boyer-8PEkshWhKlo@public.gmane.org>
Subject: Re: [PATCH 15/15] IB/rxe: Fix an skb leak
Date: Mon, 9 Jan 2017 14:59:47 +0000
Message-ID: <D4990F1B.9071%Andrew.Boyer@emc.com>
References: <1483353316.3592.14.camel@sandisk.com>
 <1483353777.3592.42.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1483353777.3592.42.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-US
Content-ID: <293B224FD76A1C4E8ABC1E8014864926-/m+UfqrgI5Tvk4DGDgVwFwC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/2/17, 5:44 AM, "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:

>Additionally, make it easier to detect skb leaks by issuing a warning
>if a leak occurs.
>
>Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
>Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
>---
> drivers/infiniband/sw/rxe/rxe_comp.c | 15 ++++++++++++++-
> 1 file changed, 14 insertions(+), 1 deletion(-)

I liked this better when it was doing the rxe_drop_ref() and kfree_skb()
after exit: and done:, if pkt was set.
Maybe that was just in our private patchset, I don=B9t remember, but it
would be fewer lines and fewer chances to miss something.

>
>diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c
>b/drivers/infiniband/sw/rxe/rxe_comp.c
>index d1c3411c5478..bbc7cd39f978 100644
>--- a/drivers/infiniband/sw/rxe/rxe_comp.c
>+++ b/drivers/infiniband/sw/rxe/rxe_comp.c
>@@ -622,6 +622,7 @@ int rxe_completer(void *arg)
> 			if (pkt) {
> 				rxe_drop_ref(pkt->qp);
> 				kfree_skb(skb);
>+				skb =3D NULL;
> 			}
> 			goto done;
>=20
>@@ -645,6 +646,7 @@ int rxe_completer(void *arg)
> 			    qp->qp_timeout_jiffies)
> 				mod_timer(&qp->retrans_timer,
> 					  jiffies + qp->qp_timeout_jiffies);
>+			WARN_ON_ONCE(skb);
> 			goto exit;
>=20
> 		case COMPST_ERROR_RETRY:
>@@ -657,8 +659,10 @@ int rxe_completer(void *arg)
> 			 */
>=20
> 			/* there is nothing to retry in this case */
>-			if (!wqe || (wqe->state =3D=3D wqe_state_posted))
>+			if (!wqe || (wqe->state =3D=3D wqe_state_posted)) {
>+				WARN_ON_ONCE(skb);
> 				goto exit;
>+			}
>=20
> 			if (qp->comp.retry_cnt > 0) {
> 				if (qp->comp.retry_cnt !=3D 7)
>@@ -680,8 +684,10 @@ int rxe_completer(void *arg)
> 				if (pkt) {
> 					rxe_drop_ref(pkt->qp);
> 					kfree_skb(skb);
>+					skb =3D NULL;
> 				}
>=20
>+				WARN_ON_ONCE(skb);
> 				goto exit;
>=20
> 			} else {
>@@ -701,6 +707,9 @@ int rxe_completer(void *arg)
> 				mod_timer(&qp->rnr_nak_timer,
> 					  jiffies + rnrnak_jiffies(aeth_syn(pkt)
> 						& ~AETH_TYPE_MASK));
>+				rxe_drop_ref(pkt->qp);
>+				kfree_skb(skb);
>+				skb =3D NULL;
> 				goto exit;
> 			} else {
> 				wqe->status =3D IB_WC_RNR_RETRY_EXC_ERR;
>@@ -716,8 +725,10 @@ int rxe_completer(void *arg)
> 			if (pkt) {
> 				rxe_drop_ref(pkt->qp);
> 				kfree_skb(skb);
>+				skb =3D NULL;
> 			}
>=20
>+			WARN_ON_ONCE(skb);
> 			goto exit;
> 		}
> 	}
>@@ -726,6 +737,7 @@ int rxe_completer(void *arg)
> 	/* we come here if we are done with processing and want the task to
> 	 * exit from the loop calling us
> 	 */
>+	WARN_ON_ONCE(skb);
> 	rxe_drop_ref(qp);
> 	return -EAGAIN;
>=20
>@@ -733,6 +745,7 @@ int rxe_completer(void *arg)
> 	/* we come here if we have processed a packet we want the task to call
> 	 * us again to see if there is anything else to do
> 	 */
>+	WARN_ON_ONCE(skb);
> 	rxe_drop_ref(qp);
> 	return 0;
> }
>--=20
>2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
