From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] qedr: Fix missing unlock on error in qedr_post_send()
Date: Mon, 31 Oct 2016 07:38:35 +0200
Message-ID: <20161031053835.GV3617@leon.nu>
References: <1477672406-31487-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="HzaOE8X7KzPzAQEl"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1477672406-31487-1-git-send-email-weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Rajesh Borundia <rajesh.borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--HzaOE8X7KzPzAQEl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 28, 2016 at 04:33:26PM +0000, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>
> Add the missing unlock before return from function qedr_post_send()
> in the error handling case.
>
> Signed-off-by: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/qedr/verbs.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
> index a615142..e7c7417 100644
> --- a/drivers/infiniband/hw/qedr/verbs.c
> +++ b/drivers/infiniband/hw/qedr/verbs.c
> @@ -2983,7 +2983,8 @@ int qedr_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
>
>  	if (!wr) {
>  		DP_ERR(dev, "Got an empty post send.\n");
> -		return -EINVAL;
> +		rc = -EINVAL;
> +		goto out_unlock;
>  	}

IMHO, this if needs to be moved to be before acquiring spinlock and
avoid introducing new labels for this one case only.

>
>  	while (wr) {
> @@ -3012,6 +3013,7 @@ int qedr_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
>  	/* Make sure write sticks */
>  	mmiowb();
>
> +out_unlock:
>  	spin_unlock_irqrestore(&qp->q_lock, flags);
>
>  	return rc;
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--HzaOE8X7KzPzAQEl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYFtjbAAoJEORje4g2clinykcQAKhB0drRFas5d8Hh7qDXdj48
L6b4xfy5XqVm+Ej+w/bPdnEcU8zjWt1f9C3KyFC8IeknaETqVYNSg8ccBEO6r6Lj
o9Sdm86Mv9aEflSFkg30XoGXOhpdJR7b1JBVWOg4hzdXMKhbqytY3d6HrWadea5m
yCKZwbFcBZzkyllV3w/mOkqgKADvaJtrx7/qgRgY9X+fRbflLu5PySmLjTWU1FHC
7/ZH91h1Gnd1pUevEJsnbUXCTpMgdQl+dffd2E83mqPQKexrD7Q5AXfNKPvHY5+F
I234QvqECRmlolSxaloOTl/Abha0p3P7OwdQAHBZymaUOabJguhx8oS4CDsFKzyj
xQ4JLSqJkDXSOMvdMA/e/YIlJXUzukph/GqleuqbXsexl6Obi0mQXOOO/proZNdm
FDBK8tewer18GsswoxervE47yozSJ5QCmYm4qzMCI625xcX2jRgS5mu2oaWstQLU
2zBsyNURvLkaA7nXwP0ac1f0pyRH0qpib2fl9XDxckX3ByzpQaIsjwus7ovxMzeV
6uZa2jkQfhkaW6Zn8Og+kN1cDw5nNt6ZrXWHWVDitve1B7BemlyRz6hHCdHJoDxu
gonXRO2PxkObhzn7ipLXK1m+K7YmIUKixSWWZwIgLpIfUoy6TyziXhRpLkeHGJjo
7ro9z+GNcFIcJifUo987
=sIXh
-----END PGP SIGNATURE-----

--HzaOE8X7KzPzAQEl--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
