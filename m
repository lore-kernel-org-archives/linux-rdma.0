From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Latest for-4.14
Date: Wed, 26 Jul 2017 16:03:50 +0300
Message-ID: <20170726130350.GW3259@mtr-leonro.local>
References: <20170726053749.GV3259@mtr-leonro.local>
 <b337a2ae-40ff-a207-82fa-fd3c7d2e1083@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="PLomxqHhGwMWzngE"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b337a2ae-40ff-a207-82fa-fd3c7d2e1083-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--PLomxqHhGwMWzngE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 26, 2017 at 08:24:44AM -0400, Dennis Dalessandro wrote:
> On 7/26/2017 1:37 AM, Leon Romanovsky wrote:
> > Reply to: "Re: [PATCH for-next 7/9] IB/core: Allow QP state transition from reset to error"
> >
> > On Sun, Jul 23, 2017 at 09:14:02AM -0400, Doug Ledford wrote:
> > > On 7/23/2017 9:04 AM, Leon Romanovsky wrote:
> >
> > <snip>
> >
> > > > BTW, when will you post for-4.14 branch so we will be able to base our
> > > > submission queue for the -next?
> > >
> > > Tomorrow.  I wanted to base it on 4.13-rc2 so it would get all of the
> > > fixes that went in this week.
> >
> > Any news on the matter?
> >
>
> Check Doug's GitHub, I see a 4.13-rc2 based "for-next" branch there.

Are you referring to this branch?
https://github.com/torvalds/linux/compare/master...dledford:k.o/for-next

It doesn't have most of mlx5/mlx4/cavium/core/e.t.c features.

Thanks

>
> -Denny
>

--PLomxqHhGwMWzngE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAll4kzYACgkQ5GN7iDZy
WKe6WA//c4fPlPUynDk58VeEXjRXiwZfhNmW1csJVW2o6WmsWDS00VgZmljefIrS
DGv8Yxgb02nBWSEv6LlKKL+xy5wyApfv5edGI32/A8l0+Kxjhe2cmwe+IaBr6k55
Vj1rOWPxfPyUHbLAn4Dv317QXV7rOM/YvGNIYbhSaTQt8nf+HRa5gexTe6IeW0Fk
Oa4giMlu/mfUs6EhwBocxeK1ywneUIw/RGU34MIOa1Gg3IKwL2uI2S15LSdyULVV
c1IXhDptM0NGGM5+BujJsTVIOS1+KFtgOqraEXqGufgap//VyuJA3+Lyfr+/YV05
urlqA1h85FgP3IbHERGr72s8hvIlbrA7Jp1hCg/5VIgMKQqxdK9+sDQ6MQO934gE
mqdAB6GbvHfoE6yeaujztk9wkqq6RvQNedYYhfN6zRdqOvGU2iG6O2iOngBygmO0
++L0q3xlJ1+v+lKiqvV98wml0MnaTN0qCaZtR6TLq+HYui4axwWhnc4KdVqPo/9i
LSxtVQQWrkKlqdI0lxXF6sYl518c6XAapro38dQk83HtDHliCWXoOHXOx4J8Ow+c
tosoQ92oMjwvc+VVSfCreG6AoOsh1+bvgHv1UvQAhqwf0x2+1Hqbd6aR2h0Tcui8
Ai+NKgVNaDw+VefN2vxmqgEabt2rgcGpe79ZG194bFJ59vzNs8Y=
=Vda1
-----END PGP SIGNATURE-----

--PLomxqHhGwMWzngE--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
