From: "Boyer, Andrew" <Andrew.Boyer-8PEkshWhKlo@public.gmane.org>
Subject: Re: [PATCH 12/15] IB/rxe: Fix a MR reference leak in check_rkey()
Date: Mon, 9 Jan 2017 14:42:31 +0000
Message-ID: <D4990AEE.9042%Andrew.Boyer@emc.com>
References: <1483353316.3592.14.camel@sandisk.com>
 <1483353706.3592.35.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1483353706.3592.35.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-US
Content-ID: <7654FFB7D241234CA4F7BB628396B332-/m+UfqrgI5Tvk4DGDgVwFwC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/2/17, 5:43 AM, "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:

>Avoid that calling check_rkey() for mem->state =3D=3D RXE_MEM_STATE_FREE
>triggers an MR reference leak.
>
>Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
>Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
>---
> drivers/infiniband/sw/rxe/rxe_resp.c | 20 ++++++++++----------
> 1 file changed, 10 insertions(+), 10 deletions(-)
>
>diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c
>b/drivers/infiniband/sw/rxe/rxe_resp.c
>index 33defaddc000..60d78f45aa04 100644
>--- a/drivers/infiniband/sw/rxe/rxe_resp.c
>+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
>@@ -418,7 +418,7 @@ static enum resp_states check_length(struct rxe_qp
>*qp,
> static enum resp_states check_rkey(struct rxe_qp *qp,
> 				   struct rxe_pkt_info *pkt)
> {
>-	struct rxe_mem *mem;
>+	struct rxe_mem *mem =3D NULL;

I like having this extra load for clarity, but the general sentiment
around here seems to be that it should be avoided. There=B9s no path I can
see that touches mem before lookup_mem() sets it.

Otherwise
Reviewed-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>


> 	u64 va;
> 	u32 rkey;
> 	u32 resid;
>@@ -459,38 +459,38 @@ static enum resp_states check_rkey(struct rxe_qp
>*qp,
> 	mem =3D lookup_mem(qp->pd, access, rkey, lookup_remote);
> 	if (!mem) {
> 		state =3D RESPST_ERR_RKEY_VIOLATION;
>-		goto err1;
>+		goto err;
> 	}
>=20
> 	if (unlikely(mem->state =3D=3D RXE_MEM_STATE_FREE)) {
> 		state =3D RESPST_ERR_RKEY_VIOLATION;
>-		goto err1;
>+		goto err;
> 	}
>=20
> 	if (mem_check_range(mem, va, resid)) {
> 		state =3D RESPST_ERR_RKEY_VIOLATION;
>-		goto err2;
>+		goto err;
> 	}
>=20
> 	if (pkt->mask & RXE_WRITE_MASK)	 {
> 		if (resid > mtu) {
> 			if (pktlen !=3D mtu || bth_pad(pkt)) {
> 				state =3D RESPST_ERR_LENGTH;
>-				goto err2;
>+				goto err;
> 			}
>=20
> 			resid =3D mtu;
> 		} else {
> 			if (pktlen !=3D resid) {
> 				state =3D RESPST_ERR_LENGTH;
>-				goto err2;
>+				goto err;
> 			}
> 			if ((bth_pad(pkt) !=3D (0x3 & (-resid)))) {
> 				/* This case may not be exactly that
> 				 * but nothing else fits.
> 				 */
> 				state =3D RESPST_ERR_LENGTH;
>-				goto err2;
>+				goto err;
> 			}
> 		}
> 	}
>@@ -500,9 +500,9 @@ static enum resp_states check_rkey(struct rxe_qp *qp,
> 	qp->resp.mr =3D mem;
> 	return RESPST_EXECUTE;
>=20
>-err2:
>-	rxe_drop_ref(mem);
>-err1:
>+err:
>+	if (mem)
>+		rxe_drop_ref(mem);
> 	return state;
> }
>=20
>--=20
>2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
