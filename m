From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: Fix hard lockup due to not using save/restore
 spin lock
Date: Wed, 1 Jun 2016 18:44:40 +0300
Message-ID: <20160601154440.GH7477@leon.nu>
References: <20160601143812.26872.85826.stgit@phlsvslse11.ph.intel.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RwGu8mu1E+uYXPWP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160601143812.26872.85826.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--RwGu8mu1E+uYXPWP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 01, 2016 at 10:38:12AM -0400, Mike Marciniszyn wrote:
> Upstream commit 7049de65c9e5 into 4.6.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Is it part of the commit message?

>=20
> Commit b9b06cb6feda
> ("IB/hfi1: Fix missing lock/unlock in verbs drain callback")
> added a spin lock.
>=20
> Unfortunately, the new lock code can be called from a base
> level interrupt state, and an interrupt that can get stacked
> will attempt to get the same lock.
>=20
> Fix by using the flag save/restore spin lock variation.
>=20
> Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/staging/rdma/hfi1/qp.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/q=
p.c
> index dc9119e..0401955 100644
> --- a/drivers/staging/rdma/hfi1/qp.c
> +++ b/drivers/staging/rdma/hfi1/qp.c
> @@ -512,6 +512,7 @@ static void iowait_wakeup(struct iowait *wait, int re=
ason)
>  static void iowait_sdma_drained(struct iowait *wait)
>  {
>  	struct rvt_qp *qp =3D iowait_to_qp(wait);
> +	unsigned long flags;
> =20
>  	/*
>  	 * This happens when the send engine notes
> @@ -519,12 +520,12 @@ static void iowait_sdma_drained(struct iowait *wait)
>  	 * do the flush work until that QP's
>  	 * sdma work has finished.
>  	 */
> -	spin_lock(&qp->s_lock);
> +	spin_lock_irqsave(&qp->s_lock, flags);
>  	if (qp->s_flags & RVT_S_WAIT_DMA) {
>  		qp->s_flags &=3D ~RVT_S_WAIT_DMA;
>  		hfi1_schedule_send(qp);
>  	}
> -	spin_unlock(&qp->s_lock);
> +	spin_unlock_irqrestore(&qp->s_lock, flags);
>  }
> =20
>  /**
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--RwGu8mu1E+uYXPWP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXTwLoAAoJEORje4g2clinNqMP/1xRpDUKTCauLpVhgw7a+wTc
THog9SRsmq5klhAf5Belyjbg8s4DjWB4NzX9X6S81ddvC+H1dMwHY+w3UcVmRsyp
+L5BrM2kLcQ4yw0unLnM1I/qvA9dp5sPrNqsTIPP4GQYVjPsGaGlwvkkuEq/KOh6
fHqIJe6aky/ShvBWvS7G1i/uCZcPsMDPVZdX/C47g/dnYrFXU0RZZLiuJLOaca+/
0kbYPoMkH/PbhPFZKK/3iO0djqvgw2ZSCt3JLjjc0o3WdQHvAhAT/hvnD4ILUuGS
ScCBMpI8uerggNrDlAQWpFpKXwx3tn3WPYsypr8QXjqyTQPUqSHEC4PMDUXFq41k
v9y15lBA3cRgGKsY0wGd8HzLgebhIir/PVJCH98me+IF3mOxC55jYLUDjSy6q+nJ
JdvCAMHYYoA0Q6eb/R8bmtmVbEghPomZOuIFbu1/r8R7BWNUxCX1utlXg1VC7SFx
KoFrPQ01sA/o9Qc35tH+ClvlAH4ARcjKyzgdTncsjjFuqWaXnXq37nPv4L46BmUK
mAoHRmimWRTvX9YJZwzqFW/RCfGnRjuDYkPG+wXQVYENNuIOAhasbr/IH0LFJJnO
3Hhrgvxd443NjzGnlILPvFR+e8kXIpjrGWKiuE9KRnf8YRP32dB3hTsVEnI9VHdS
gxo+3uYDYmph3IjYMK02
=oKgP
-----END PGP SIGNATURE-----

--RwGu8mu1E+uYXPWP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
