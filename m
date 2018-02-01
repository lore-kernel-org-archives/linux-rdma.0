From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC 2/2] RDMA/nldev: provide detailed CM_ID information
Date: Thu, 1 Feb 2018 10:01:09 +0200
Message-ID: <20180201080109.GG2055@mtr-leonro.local>
References: <cover.1517418595.git.swise@opengridcomputing.com>
 <531889e6a24f7919dec71734c91298d266aa9721.1517418595.git.swise@opengridcomputing.com>
 <VI1PR0502MB3008805F1A6056F50A12DEDBD1FB0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <01ea01d39ad5$ec30f7a0$c492e6e0$@opengridcomputing.com>
 <VI1PR0502MB30088B50BEA14B4C05EA2BC7D1FB0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="IJKqlw44nclc26Ih"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <VI1PR0502MB30088B50BEA14B4C05EA2BC7D1FB0-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--IJKqlw44nclc26Ih
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 31, 2018 at 09:18:39PM +0000, Parav Pandit wrote:
>
>
> > -----Original Message-----
> > From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Steve Wise
> > Sent: Wednesday, January 31, 2018 2:56 PM
> > To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; Jason
> > Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> > Subject: RE: [PATCH RFC 2/2] RDMA/nldev: provide detailed CM_ID information
> >
> > > > 182,6 +199,7 @@ static int fill_res_info(struct sk_buff *msg, struct
> > ib_device
> > > > *device)
> > > >  		[RDMA_RESTRACK_PD] = "pd",
> > > >  		[RDMA_RESTRACK_CQ] = "cq",
> > > >  		[RDMA_RESTRACK_QP] = "qp",
> > > > +		[RDMA_RESTRACK_CM_ID] = "cm_id",
> > >
> > > May be rdmacm_id a better name to avoid confusion with ib_cm/iw_cm ids?
> >
> > Eventually, I could see the ib_cm and/or iw_cm info also getting dumped as part
> Yes. But it is still coming through id of rdmacm_id as transport id information.
> > of this.  So perhaps the name "cm_id" is ok?
> It's just that longer name removes the ambiguity.
> I am not too particular about this particular naming.
>
> > I prefer it also because its shorter (lazy typer! :) )
> Sure, shorter names are useful to end user.
> But I think this is handled well at iproute2 tool level.
> For example below two commands achieves the same task.
> #ip address show
> #ip a s
> So may be shorter naming at command level is better left at user space tool level.

The shorter naming is working on commands and not on objects.
In rdamtool, you can write "rdma d s" instead of "rdma dev show", but
the name of device (mlx5_0) or object (qp) should be full.

Regarding the name, I personally think that cm_id is better because it
is general and applicable both to ib_cm and iw_cm. The separation
between them can be done with introduction of new netlink attribute, e.g.
cm_id_type.

Thanks

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--IJKqlw44nclc26Ih
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpyyUQACgkQ5GN7iDZy
WKdgyQ/9GMEOKqUUxfrdqG7MG7R+UF4ieSUK3YbrBPcIaqPAVJFITK1SXMDYh1N1
hF6ayhrgxguQIbFKdWKXh7M5+pr1I5lOcKWHgwBnbs6yh/GuaAeYt3BSPTZYXczL
+vuLUJdkOKCBSPz8YBsst8qZ+O6fd8THHWYSCQ8FIcNbj19JsBfW0YPCvnt0GPB2
rIMvbgzgtbJrMlLcVDgjt09fPYupfzud5PDW+3mdQ7lHbtiUA9ZysKiBdM4qydb4
Z4z0578txIolQI5u98ilyS28R+VfC0u65rHAi7yHBrJzY4beWzO6KziuZmK7U6+e
MLrv1N5/27/78/QYircM83WYBQ2IZZ52H5QiODDYrTipCwe7Wu0eef/eTnmWWUqn
LwgEzXoyYNUSWKwToBru7Xw3tDfgEWqOcWF2TbhqqUnSGN8ycMxwBdwnGjZwf8aC
4SmkT55M43l6XniYzVNTPWl8Y4bY2ztTAMn7FrKQ6p2zPfWXsqMPrExhkYQGkVP0
lYDHX9FEGn1jyLuBz0fbIz8Bj1dHJMtvH9y+C6RflEyatMI6qZhloW7n2SVpqUXs
K8vmvlSX89QihviE438QlkdpJrTQirQZBlg5NFeNjSezvtJmuKgi+85147em3a7r
mj7ynNa3pgkI969AtmY0bHrhv/l7O+dRvMh/ZbLn0l2gJKh28Rs=
=gIN1
-----END PGP SIGNATURE-----

--IJKqlw44nclc26Ih--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
