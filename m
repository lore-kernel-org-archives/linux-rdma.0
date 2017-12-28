From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 6/8] RDMA/netlink: Protect device query from
 device removal
Date: Thu, 28 Dec 2017 07:04:54 +0200
Message-ID: <20171228050454.GK3494@mtr-leonro.local>
References: <20171224134328.17398-1-leon@kernel.org>
 <20171224134328.17398-7-leon@kernel.org>
 <20171227230552.GL25436@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mrJd9p1Ce66CJMxE"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171227230552.GL25436-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--mrJd9p1Ce66CJMxE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 27, 2017 at 04:05:52PM -0700, Jason Gunthorpe wrote:
> On Sun, Dec 24, 2017 at 03:43:26PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > There is a chance that device will be removed during device query
> > operations and it will cause to kernel panic in the flows which
> > doesn't hold lists_rwsem semaphore.
> >
> > Fixes: e5c9469efcb1 ("RDMA/netlink: Add nldev device doit implementation")
> > Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >  drivers/infiniband/core/nldev.c | 25 +++++++++++++++----------
> >  1 file changed, 15 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
> > index 2b631307349d..e3033d7a4029 100644
> > +++ b/drivers/infiniband/core/nldev.c
> > @@ -141,36 +141,41 @@ static int nldev_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
> >  	struct ib_device *device;
> >  	struct sk_buff *msg;
> >  	u32 index;
> > -	int err;
> > +	int ret = -ENOMEM;
> >
> > -	err = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
> > +	ret = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
> >  			  nldev_policy, extack);
> > -	if (err || !tb[RDMA_NLDEV_ATTR_DEV_INDEX])
> > +	if (ret || !tb[RDMA_NLDEV_ATTR_DEV_INDEX])
> >  		return -EINVAL;
> >
> >  	index = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
> >
> > -	device = __ib_device_get_by_index(index);
>
> It is not possible to correctly use __ib_device_get_by_index without
> grabbing one of the locks which are static to device.c
>
> Thus it should not be in core_priv.h and every single user must be
> wrong, please fix them all here and make it static again.

Ok, I'll squash patch 6 & 7 and remove the declaration from core_priv.h

Thanks


>
> Jason

--mrJd9p1Ce66CJMxE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpEe3YACgkQ5GN7iDZy
WKeuqg/+PzM8oiELsKy24SMQ6gMtEu1OA5Q9znv3KnJQkGqVALAmiFLD1Kx2PRjl
vFCVbThLlfE41V/XEUrhzGSQrjHhzgTJH3RWPyvsbh9kbTElAK5QPFYe7hNP9Hlc
MHqZ4p7zOiJbWtc9Ts/svsarVdLwIEExCeCKN6mlabmDfTu3AtPkNdEhfIXE9F+J
EhfvZdB+0oWVPzo0TP3HnC3A2DFsb2X6qRoAg90JifT8rJ79zhFujPKvRE/FYpad
FtfB3v+1VM9OBsB31TQ/6f69CJonDMIEUrz+kmUqAeZRREN4ogXV+mQfPWPex27p
MuGE3LsB0G0SAaEDN2rBHIONHv/OJvcJFiIZaFF0uGWcHxOntzfX0rYlseVg4rfD
qPbJw+tSIH6sIclAg5FLb2gle17P5mnNxB6hshUaW2juQfj/LxK3It+jNeza/rhq
J1WegODTR0xyEv8CLmMkZw8g3TDM1nRIDvVyKjQZvgP0b0KwdV4wmQwYdibrKszu
G7xg6k76w/gNFF9QpMvkG3rEDqBq+DDXhhPlj2IM7RiuyqZx4vYmntkV2cwgSfWF
kvwDQrl6rZnuF95ujwm+VAt72Xo+r5LBNdXKBEIUb7YSuie3HXGYlIbBBCM1i2PA
RK/Kwll64KhaQI0ssEX8y3QGMLQDA1qyInS961iCNYioYUeokeg=
=4olU
-----END PGP SIGNATURE-----

--mrJd9p1Ce66CJMxE--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
