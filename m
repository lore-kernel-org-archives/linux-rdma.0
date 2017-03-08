From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/rxe: double free on error
Date: Wed, 8 Mar 2017 08:58:29 +0200
Message-ID: <20170308065829.GV14379@mtr-leonro.local>
References: <20170308052152.GA31503@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="aNvCJ41Feu8IgPyB"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170308052152.GA31503@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--aNvCJ41Feu8IgPyB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 08, 2017 at 08:21:52AM +0300, Dan Carpenter wrote:
> "goto err;" has it's own kfree_skb() call so it's a double free.  We
> only need to free on the "goto exit;" path.
>
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
> Static analysis.  Not tested.  Please review carefully.
>
> diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
> index dbfde0dc6ff7..9f95f50b2909 100644
> --- a/drivers/infiniband/sw/rxe/rxe_req.c
> +++ b/drivers/infiniband/sw/rxe/rxe_req.c
> @@ -729,11 +729,11 @@ int rxe_requester(void *arg)
>  	ret = rxe_xmit_packet(to_rdev(qp->ibqp.device), qp, &pkt, skb);

This rxe_xmit_packet() looks a little bit awkward. It calls to
kfree_skb and returns ret = 0 after drop decision. It doesn't
free on error (ret != 0), but this rxe_requester does.

However in case of not error, the skb won't be released and goto
next_cqe will be called, which has a lot of exit paths without freeing
skb.

Moni, Yonatan
Is it done on purpose?


>  	if (ret) {
>  		qp->need_req_skb = 1;
> -		kfree_skb(skb);
>
>  		rollback_state(wqe, qp, &rollback_wqe, rollback_psn);
>
>  		if (ret == -EAGAIN) {
> +			kfree_skb(skb);
>  			rxe_run_task(&qp->req.task, 1);
>  			goto exit;
>  		}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--aNvCJ41Feu8IgPyB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAli/q5UACgkQ5GN7iDZy
WKdszw//SrCqAvbke+JIuWuFo8lm2EBI6CTk2jCn2ycAhGJZ0tvCBF4zdo9bq10U
T4AIRgeUBrodFiFgPTxIAFwRwwp4Y8nDRwgV5dgyyb4ltMT4K4mX1M2GCa/Ipe6U
O+J8wfqiAZfJKJCB9Dej03TLWPJRq6S+FMqcJ56beFRMgcF0HwU8JgL8uKhQqqeW
FRSSdCNlRQAXCFzeJhUjtCOi6XkIUWb3KoxYjyRZvjB2a2rPjlFOsFG/fDHDCGht
KwGYwdHl/oajJb7irAmBtqV1k5vnSQXsSMDM3bickEISGaOJgLlcQ2ZGAASzPtoq
XxRfk3nCBTsIlWu1rrKliWrFblsG4g/qBDc72PzWwgX/z/43hJ9Q+hMQHkqUxyZz
tiXChSAL5DtICmqzSjVRTr7sK76kk5TQYDEOBFXWAZ8Ld8ZPydwu+CjzJ5dS63tc
qJsGugowEcM8Evunpcw7TC4dd0XRpepGM/VqmkW1PChcVC83Uxx89VByUlthFf31
48tYhPkVyU7eTHj2JpE0A5vbe5nOKy4I/PQjEu/imtWgWs+zUzLO631+Kt7YlsR2
Le4bqsHMh6Cs3kngul+CyLizu3VDUx8KBU4EMnHYdC545eRcb61aHuKdJPCikja8
Od4GoxMaROR8FEPxG+0GNa0/U9IvhG0gaGP723kSBgcc2uemDQY=
=cpxC
-----END PGP SIGNATURE-----

--aNvCJ41Feu8IgPyB--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
