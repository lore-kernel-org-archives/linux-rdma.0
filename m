From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc 02/15] RDMA/restrack: Remove unimplemented XRCD
 object
Date: Tue, 13 Feb 2018 20:09:56 +0200
Message-ID: <20180213180956.GU2197@mtr-leonro.local>
References: <20180213101841.20101-1-leon@kernel.org>
 <20180213101841.20101-3-leon@kernel.org>
 <7e464caf-6875-9232-be9a-31324b03323f@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yhze8HlyfmXt1APY"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7e464caf-6875-9232-be9a-31324b03323f-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--yhze8HlyfmXt1APY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 13, 2018 at 12:00:25PM -0500, Dennis Dalessandro wrote:
> On 2/13/2018 5:18 AM, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > Resource tracking of XRCD objects is not implemented in current
> > version of restrack and hence can be removed.
> >
> > Fixes: 02d8883f520e ("RDMA/restrack: Add general infrastructure to track RDMA resources")
> > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > ---
> >   drivers/infiniband/core/restrack.c | 5 -----
> >   include/rdma/restrack.h            | 4 ----
> >   2 files changed, 9 deletions(-)
> >
> > diff --git a/drivers/infiniband/core/restrack.c b/drivers/infiniband/core/restrack.c
> > index 857637bf46da..d8dc709a3715 100644
> > --- a/drivers/infiniband/core/restrack.c
> > +++ b/drivers/infiniband/core/restrack.c
> > @@ -63,7 +63,6 @@ static struct ib_device *res_to_dev(struct rdma_restrack_entry *res)
> >   {
> >   	enum rdma_restrack_type type = res->type;
> >   	struct ib_device *dev;
> > -	struct ib_xrcd *xrcd;
> >   	struct ib_pd *pd;
> >   	struct ib_cq *cq;
> >   	struct ib_qp *qp;
> > @@ -81,10 +80,6 @@ static struct ib_device *res_to_dev(struct rdma_restrack_entry *res)
> >   		qp = container_of(res, struct ib_qp, res);
> >   		dev = qp->device;
> >   		break;
> > -	case RDMA_RESTRACK_XRCD:
> > -		xrcd = container_of(res, struct ib_xrcd, res);
> > -		dev = xrcd->device;
> > -		break;
> >   	default:
> >   		WARN_ONCE(true, "Wrong resource tracking type %u\n", type);
> >   		return NULL;
> > diff --git a/include/rdma/restrack.h b/include/rdma/restrack.h
> > index c2d81167c858..2cdf8dcf4bdc 100644
> > --- a/include/rdma/restrack.h
> > +++ b/include/rdma/restrack.h
> > @@ -28,10 +28,6 @@ enum rdma_restrack_type {
> >   	 * @RDMA_RESTRACK_QP: Queue pair (QP)
> >   	 */
> >   	RDMA_RESTRACK_QP,
> > -	/**
> > -	 * @RDMA_RESTRACK_XRCD: XRC domain (XRCD)
> > -	 */
> > -	RDMA_RESTRACK_XRCD,
> >   	/**
> >   	 * @RDMA_RESTRACK_MAX: Last entry, used for array dclarations
> >   	 */
> >
>
> Not -rc material in my opinion.

We are in -rc1 and it is exactly the time to clean up the code which was
entered a couple of weeks before.

>
> -Denny

--yhze8HlyfmXt1APY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlqDKfQACgkQ5GN7iDZy
WKcrTBAAo0stQka2cJPbwKQ4jXp8o09ry5whU0TdAj1VNwtk5PEDIlO1L7UGj5wu
8kGINl7X6t+ipiqlAnow2SKL0U5BZ7ostqtvDSuIHVkz9caMHHGBpVOMgBvy/dm3
gTe74xBF085HXhVKcnam/IXjjRc8pQG8W2jQZkVExrQEhizvhbrYBRYH5L59dzDe
n25Fv0yIetEbwvrZ2tdwa8Z1keEraJmilmW6gAgXRPdRQvBo/6G4QaJ6oC/6Etiy
0nw0r+b1pqW36m6oLm9A2vo6JNnygf8pO+2glvUG2qGktfOozIs728gV4rFmll6q
o0wj95B3mQshREQXo/1kIn5DWWhI5decmbN76c6AalZXZATxNNa+3VgtXQ32Ogpp
T6YtswPI40M7u4lh3GLPPS8SN2zpRtrYGdRHkdAF3g3zpYkiPkqiUWxCEcmxD5wh
8Y6bhcEX/FgNVli0UdS4BFQhsDzXWZzcXSEvFKHcJuL8WQ4YC0AaOaW0S+mx3Cz+
nVjCdrZYaWrGBCCJMrBL0UB13OS2ztfJDNuQ2wqOlGjMG9fM2WeMtocUTLb8bHgO
MPzCE/9c/IYW3Mh6SaCl0obo8BqdcY0hDdQFUR2bVfMjjQ4bScsd+4s5Z4cG6HZt
kAny00xSTXF+z8y83h2fIJtoUCe2usx3wtzmrT+NoDkxO6SMehg=
=Bnlg
-----END PGP SIGNATURE-----

--yhze8HlyfmXt1APY--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
