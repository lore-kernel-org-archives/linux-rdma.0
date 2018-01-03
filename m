From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 03/13] Attach/detach SoftiWarp to/from network and
 RDMA subsystem
Date: Wed, 3 Jan 2018 19:31:05 +0200
Message-ID: <20180103173105.GX10145@mtr-leonro.local>
References: <20171014064132.GT2106@mtr-leonro.local>
 <20171008130342.GV25829@mtr-leonro.local>
 <20171006122853.16310-1-bmt@zurich.ibm.com>
 <20171006122853.16310-4-bmt@zurich.ibm.com>
 <OF406E95F8.33CF80BB-ON002581B9.00073D6F-002581B9.00081F69@notes.na.collabserv.com>
 <OF663C0801.8471532E-ON002581FE.003B73D6-002581FE.003F2369@notes.na.collabserv.com>
 <20180102213706.GB19027@ziepe.ca>
 <20180103052529.GI10145@mtr-leonro.local>
 <20180103155225.GA11348@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="brdEIFGMNIjz5YJG"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180103155225.GA11348-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--brdEIFGMNIjz5YJG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 03, 2018 at 08:52:25AM -0700, Jason Gunthorpe wrote:
> On Wed, Jan 03, 2018 at 07:25:29AM +0200, Leon Romanovsky wrote:
> > On Tue, Jan 02, 2018 at 02:37:06PM -0700, Jason Gunthorpe wrote:
> > > On Fri, Dec 22, 2017 at 11:29:38AM +0000, Bernard Metzler wrote:
> > >
> > > > One question I have - what is the recommended way of replacing
> > > > those module parameters, if we need to flexibly parameterize
> > > > things from user land? For the rxe driver, I see the usage of
> > > > module_param_cb, but this probably is not what we want in the
> > > > long run? Would a sysctl be appropriate, or a char device
> > > > (we may need to pass strings like interface names), or configfs?
> > >
> > > Probably something like 'rdmatool interface attach' eg cause it to
> > > create using the RDMA netlink protocol.
> > >
> > > Leon?
> >
> > https://www.spinics.net/lists/linux-rdma/msg58498.html
> > "It looks like "ip" tool can be good fit ..."
> >
> > ip link add ...
> > ip link set ...
>
> ip link adds netdevs, so that doesn't quite feel right for adding rdma
> devices???

It depends on the add/delete order, currently we are adding
RDMA (RXE/SoftiWARP) device to existing netdev. Will it make
sense to reverse order and add/delete netdev device for the
existing RDMA (RXE/SoftiWARP) device?

In this "reverse order", ip tool can be right tool.

Thanks

>
> Jason

--brdEIFGMNIjz5YJG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpNE1gACgkQ5GN7iDZy
WKfBJxAArTB5nGaj5GGvlk2oFYZLHpDZBRHZ5gO07lNCnPYIkfdZWczMvVrq6NZL
zDRXoDYMbJ0cA8R6N6Dbi3/uKNydS+wbQmAFnAEo7LpjQBrMv1Z2iV+0Wv+xT5sQ
//YG8rbVj/lkI7nVgXot4JyikTORQ/MwPk3m2lAvRJJgzwPyLZA/yFfBfp/sfvTf
+gA2py8b4gwxqnFN0cHmwTpXFAkxsIiC3mcpp14qTFkMPjYgeJtrFRNVL8P6TzeM
WxUVJrnCtls7RSHCN+/XUEaIaInSw+zjOiYOed2pcdSk3dj8yV+T6AyOZmtM6ZJL
3B5/yOGocQJlW23PL2jr9r4OLJInQWAk1lhCxPX+4y9UYjnNiEXTcqzn7XpOfcyI
g3P1A91zTTrIO8JAu90JUH5qZ49WifCynIdqUIozEAcBeIh3Tqyt6geb6oK42VoM
QZOKL5C4thcxUOQvPZrUKMg5dzZY09QNY78XsJaX1MHfKBhmIajzf59KM3U+cAho
OLMoEkU7R6/2JLZs55DLv7CQptiDunti2npdchxul9beNpi/7JWDG8LdHZHawi/k
m5KqpWz0iP+qzjnuhsYuBQt7ERtcmph0olkaUnTHjzGzN7XVR/AKMV8Y4/0gMk/0
3F8lKUW9MarzaXZ96RN/ZQ2htDQss15ci09u6X8VPwwRb9TAtiI=
=8WUh
-----END PGP SIGNATURE-----

--brdEIFGMNIjz5YJG--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
