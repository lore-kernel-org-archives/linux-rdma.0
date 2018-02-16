From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] vmw_pvrdma: Avoid rounding up of sge count to power of 2
Date: Fri, 16 Feb 2018 19:18:56 +0200
Message-ID: <20180216171856.GR2197@mtr-leonro.local>
References: <1518741592-12723-1-git-send-email-aditr@vmware.com>
 <20180216161526.GC22739@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rYRijwbmzeJBcrGE"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180216161526.GC22739-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--rYRijwbmzeJBcrGE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 16, 2018 at 09:15:26AM -0700, Jason Gunthorpe wrote:
> On Thu, Feb 15, 2018 at 04:39:52PM -0800, Adit Ranadive wrote:
> > Creation of resources can fail if the rounding up exceeds
> > provider supported values.
> >
> > Fixes: 4c8ed14eb6b7 ("vmw_pvrdma: Add SRQ support")
> > Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Nitish Bhat <bnitish-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Cc: stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org
> >  providers/vmw_pvrdma/qp.c | 8 +++-----
> >  1 file changed, 3 insertions(+), 5 deletions(-)
> >
> > diff --git a/providers/vmw_pvrdma/qp.c b/providers/vmw_pvrdma/qp.c
> > index efcc99b..4b9f897 100644
> > +++ b/providers/vmw_pvrdma/qp.c
> > @@ -113,7 +113,7 @@ struct ibv_srq *pvrdma_create_srq(struct ibv_pd *pd,
> >  	int ret;
> >
> >  	attr->attr.max_wr = align_next_power2(max_t(uint32_t, 1U, attr->attr.max_wr));
> > -	attr->attr.max_sge = align_next_power2(max_t(uint32_t, 1U, attr->attr.max_sge));
> > +	attr->attr.max_sge = max_t(uint32_t, 1U, attr->attr.max_sge);
>
> What is with all these max's? If the user provides <= 0 for these
> values it should be EINVAL, not round up.

SRQ attributes are uint32_t, user can't provide negative values.

 680 struct ibv_srq_attr {
 681         uint32_t                max_wr;
 682         uint32_t                max_sge;
 683         uint32_t                srq_limit;
 684 };

Thanks

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--rYRijwbmzeJBcrGE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlqHEoAACgkQ5GN7iDZy
WKfCkA/+JHO98xRuwJudB16bNQ2nfGd7N053oSTTEXukfuVZnnj5281NVQtVUMq1
bZX2GrLdJ1Og3IQ1EUNwsb+sBpXQKoLPNpnK+0cRPnFALZxuXsh1IfLs2N/+46Q2
rjYLSI59GCi1RBq3VMSq6/JWOTmmAa0bkLWcdaivRosQ3q6b35NxGocMDY8fx6/K
d/zdxIekhuAClLKlvpJc8zYjARQdlY2Q0+iq8PZH1ZQcermQxCv9oxQRWNJNSgS8
1kFnbFxvJ9IOz438la9VSBT3lczMdKkej9Da6SHLjYNr+es3LpbIfyK465M/VQPH
QVe/pwhX+vMWJvEW8UzI4Uis2Wxj8TN257uUgNnB2G0z9KTIlbu4hi7fh1jziI9c
S4gfSOSOoaqxaCf4hgSbzQl2SYmF2Cq14jcHW1fxx7YRW+oyOzLRSZ1Hd6Yy/l3x
Wla7mEKpojbjEl6Ic673uWKU3YwsBmQsV67IoZ16Q9wRPOBf3M1GxgviPYloM0Cs
8EENU/NPQ8BWrIe2k0KKz98CC8Rg+ADZqP2j9q+wlqx7g5rJDJ5EoAgX8afSj3M+
C7Jyb3xDRXYu2VUyTXDHqxFwjdihJ6OwBQpEHTkWpU1b9NIjlvaqhQhDTtueTpuo
y9xIvUaOV6PBPR+CBbIZygVrAUdCohSGK7hBJhqvfsJuIuC5j6Q=
=0YQo
-----END PGP SIGNATURE-----

--rYRijwbmzeJBcrGE--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
