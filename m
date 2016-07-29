From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 02/15] IB/pvrdma: Add device command support
Date: Fri, 29 Jul 2016 15:37:11 +0300
Message-ID: <20160729123711.GU4628@leon.nu>
References: <1468352205-9137-1-git-send-email-aditr@vmware.com>
 <1468352205-9137-3-git-send-email-aditr@vmware.com>
 <20160718124652.GE6165@yuval-lap.uk.oracle.com>
 <BLUPR0501MB8363954E94FE9D268E66CB7C5000@BLUPR0501MB836.namprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+tDoj9+U2XbkXuwv"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BLUPR0501MB8363954E94FE9D268E66CB7C5000-84Rf5TRaNBMVDhIuTCx1aJLWcSx1hRipwIZJ9u9yWa8oOQlpcoRfSA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org" <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "Jorgen S. Hansen" <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--+tDoj9+U2XbkXuwv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 28, 2016 at 10:51:39PM +0000, Adit Ranadive wrote:
> On Mon, 18 Jul 2016 15:46:53 +0300 Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> w=
rote:
> > On Tue, Jul 12, 2016 at 12:36:32PM -0700, Adit Ranadive wrote:
> > > This patch enables posting Verb requests and receiving responses to/f=
rom
> > > the backend PVRDMA emulation layer.
> > >
>=20
> ...
>=20
> > > +int
> > > +pvrdma_cmd_post(struct pvrdma_dev *dev, union pvrdma_cmd_req *req,
> > > +		bool expect_resp, union pvrdma_cmd_resp *resp)
> > > +{
> > > +	int err;
> > > +
> > > +	dev_dbg(&dev->pdev->dev, "post request to device\n");
> > > +
> > > +	/* Serializiation */
> > > +	down(&dev->cmd_sema);
> > > +
> > > +	spin_lock(&dev->cmd_lock);
> > > +	memcpy(dev->cmd_slot, req, sizeof(*req));
> >=20
> > Just to protect against memory corruption suggesting to do:
> > 	memcpy(dev->cmd_slot, req, min(PAGE_SIZE, sizeof(*req)));
> >=20
>=20
> Done.

Hi Adit,
I didn't check how "dev->cmd_slot" was declared and if it is equal to
req in size. Additionally I didn't check if memcpy has any size
limitations, but wanted to warn you that implementation of this
suggestion as is will leave your system in much worse situation of
partially copied data.

if you really want to check sizes, please do it with BUILD_ON compilation
macro. I have serious doubts if you need it.

Thanks

--+tDoj9+U2XbkXuwv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXm033AAoJEORje4g2clinVQ0QAIYQy8EgksY7gD96y446KuzT
cOAAFa5/h77e4MIW7vWOhqP0hesJ6Bnis/3vihLsNCcoj5tpvH2GJ4YTTxgDjjUv
M7LOU7TCcwDmR2US5x1rfPQ6wlXeyRl7YRKp7i7udQstYirG32coaPYkz2h0VGsa
jf92q/JFebFbBDinC4m3kQbhhJaQc39rqCq6LoKW79jwkQ6A9FX64dSw68h3fTs7
Hn7iiLantQOE8w+L80auiXo+EabN/w9xFanOEC0KetIX/lRt4GI6R1QxVyYVBoa8
hKs6gpBgn1U7zwi+Ar8YTQQBgpwLKEeF8So4cw711QgLPUNFbKV7GTikxgs1aiwT
szb6+CeZCEWC4he3TgIkCBbQHzKS5ae7two+/OD/3T5DepbTtA7U5PY+G1ZfRyFk
3Yo3GLoIqob+HTL2fcfBzLfExSbvqzHASY2c2mX/R7o3DJRwBiwr5sO6CT9toYpR
AN+tAwIr8XLbJ2PQKDUpImowxs+fXclWbvOrAtj2P49fpX9E6eJ68Jn5wOP6L9Vy
EoKhT6wP1pMmCqzD9kGLYtE0RAmOlaFRZKm9irGtPoeADmVReoRKGEGhyjsAo9r5
t8bxH+JHkDPzmwBrRzTaeRQcAVoyh/xEsqvlnS/r5cTRfEs5acSldH3Vb4lRA33v
taKGUi2WAs3t8NeWp6qF
=rD/M
-----END PGP SIGNATURE-----

--+tDoj9+U2XbkXuwv--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
