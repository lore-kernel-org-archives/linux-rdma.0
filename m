From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core v2] qedr: Set immediate data sent via EDPM as
 is.
Date: Wed, 21 Jun 2017 09:36:08 +0300
Message-ID: <20170621063608.GA1248@mtr-leonro.local>
References: <1498026775-7927-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1498026775-7927-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 21, 2017 at 09:32:55AM +0300, Ram Amrani wrote:
> Enhanced Direct Packet Mode doesn't require flipping of bytes as it
> is sent directly to the transmitting HW and isn't processed by the
> FW that requires specific order.
>
> Fixes: c0965e4fe6fe ("libqedr (qelr) verbs")
>
> Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> ---
>  providers/qedr/qelr_verbs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Please try to avoid usage of dot mark at the end of patch subject.

Thanks

>
> diff --git a/providers/qedr/qelr_verbs.c b/providers/qedr/qelr_verbs.c
> index 676b18c..68429df 100644
> --- a/providers/qedr/qelr_verbs.c
> +++ b/providers/qedr/qelr_verbs.c
> @@ -1259,7 +1259,7 @@ static int __qelr_post_send(struct qelr_devctx *cxt, struct qelr_qp *qp,
>  		swqe->wqe_size = 2;
>  		swqe2 = (struct rdma_sq_send_wqe_2st *)qelr_chain_produce(&qp->sq.chain);
>  		swqe->inv_key_or_imm_data = htobe32(htole32(wr->imm_data));
> -		qelr_edpm_set_inv_imm(qp, &edpm, swqe->inv_key_or_imm_data);
> +		qelr_edpm_set_inv_imm(qp, &edpm, wr->imm_data);
>  		qelr_prepare_sq_send_data(qp, &edpm, data_size, swqe, swqe2, wr);
>  		qelr_edpm_set_msg_data(qp, &edpm,
>  				       QELR_IB_OPCODE_SEND_ONLY_WITH_IMMEDIATE,
> @@ -1291,7 +1291,7 @@ static int __qelr_post_send(struct qelr_devctx *cxt, struct qelr_qp *qp,
>  		rwqe->imm_data = htobe32(htole32(wr->imm_data));
>  		qelr_edpm_set_rdma_ext(qp, &edpm, wr->wr.rdma.remote_addr,
>  				       wr->wr.rdma.rkey);
> -		qelr_edpm_set_inv_imm(qp, &edpm, rwqe->imm_data);
> +		qelr_edpm_set_inv_imm(qp, &edpm, wr->imm_data);
>  		rwqe2 = (struct rdma_sq_rdma_wqe_2nd *)qelr_chain_produce(&qp->sq.chain);
>  		qelr_prepare_sq_rdma_data(qp, &edpm, data_size, rwqe, rwqe2, wr);
>  		qelr_edpm_set_msg_data(qp, &edpm,
> --
> 1.8.3.1
>

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllKE9gACgkQ5GN7iDZy
WKeTGBAA0TYQqlisV3YqYhCgJ3J27JcZd+bNEZnUxjTXJacAR57NAbAViJ9bjPK8
9j5teqMMkXL6zJSVJtfPSkWL6NyL02SWlkM3qzsocJ4ee0FW14F6vuRkZTKpqCgW
Ky2URB2w0NRTZQt4UzwmGT5NgSJ52dVYcZSyjQpG9raoJCouYvVFLPvdaqMhUb5U
D0JdHvk/VBFsk0yKNT0jYxAaghrNFqV5qwOEzQYs347Q4NbKLGTQFph2GHIXSw4x
DLZjERksep1asSFgF636ZvFU3wzrfYopnw1h+xfobRGpuK9uStm1836Umq90VAvc
z+6LHO+A9hXKMHCRewFSwFOGiksFX1AjcLOx0Sb7y+XAQsJE3fPDdcojZKFmWrlt
a34ohFAwUE7ytMIUxRsARu4x2yWHbSOyfEW9b6xBTS4hPx8bEiEilx1Uz9DyLLOJ
YfslmgmntUOtlyFP08wx7sUS5SlO9nVDmZaTZj2J1gZx2vy7sLcEBWzN91Pg8fcT
AamVaKP29mbRlfdymNbtPd2l+ktQmT4+H4vPKBcl2JEdk5jYNEUIHUwXXXJ8J3nQ
/4X44wGwL2xgmqeU0B3hMFF6421EvzGKh1neq0gwdTo80RzR6QmVRfsCwbADhuY4
hFqBRfJO/t9/rJ9Z8I+9YLKIxm4h3Yt4euYM+y/wBN/UUfCIews=
=qPMt
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
