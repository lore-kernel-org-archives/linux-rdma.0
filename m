From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [bug report] IB/mlx5: Respect mlx5_core reserved GIDs
Date: Thu, 6 Jul 2017 14:47:33 +0300
Message-ID: <20170706114733.GZ1528@mtr-leonro.local>
References: <20170706093923.4azhres5ymy4vefp@mwanda>
 <20170706103811.GY1528@mtr-leonro.local>
 <20170706111057.vdhnx7agww7j3pcv@mwanda>
 <AM4PR0501MB194030AAB6D5D15585C416AADBD50@AM4PR0501MB1940.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="WU3I8Do+sziGY3UL"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AM4PR0501MB194030AAB6D5D15585C416AADBD50-dp/nxUn679gfNUYDR5dMTsDSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ilan Tayari <ilant-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--WU3I8Do+sziGY3UL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 06, 2017 at 11:24:13AM +0000, Ilan Tayari wrote:
> > -----Original Message-----
> > From: Dan Carpenter [mailto:dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org]
> > Sent: Thursday, July 06, 2017 2:11 PM
> > To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Cc: Ilan Tayari <ilant-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Subject: Re: [bug report] IB/mlx5: Respect mlx5_core reserved GIDs
> >
> > On Thu, Jul 06, 2017 at 01:38:11PM +0300, Leon Romanovsky wrote:
> > > On Thu, Jul 06, 2017 at 12:39:24PM +0300, Dan Carpenter wrote:
> > > > Hello Ilan Tayari,
> > > >
> > > > This is a semi-automatic email about new static checker warnings.
> > > >
> > > > The patch 095b0927f0ce: "IB/mlx5: Respect mlx5_core reserved GIDs"
> > > > from May 14, 2017, leads to the following Smatch complaint:
> > > >
> > > > drivers/infiniband/hw/mlx5/main.c:327 set_roce_addr()
> > > > 	 error: we previously assumed 'gid' could be null (see line 300)
> > > >
> > > > drivers/infiniband/hw/mlx5/main.c
> > > >    299
> > > >    300		if (gid) {
> > > >                     ^^^
> > > > Before we used to return early if gid was NULL.
> > >
> > > Thanks Dan,
> > > It is bug.
> > > mlx5_ib_del_gid calls this function with gid == NULL.
> > >
> > >  363 static int mlx5_ib_del_gid(struct ib_device *device, u8 port_num,
> > >  364                            unsigned int index, __always_unused void
> > **context)
> > >  365 {
> > >  366         return set_roce_addr(device, port_num, index, NULL, NULL);
> > >  367 }
> > >
> >
> > Hm...  You're right.  Btw, that code also generates a static checker
> > warning, but I just hadn't got around to reporting it yet.
> >
> > 	drivers/infiniband/hw/mlx5/main.c:342 mlx5_ib_del_gid()
> > 	error: NULL dereference inside function.
>
> This is not a real NULL pointer dereference, because set_roce_addr() passes
> parameter 4 to mlx5_core_roce_gid_set() as a pointer. So the -> operator
> is not a dereference, it's pointer arithmetics.
>
> It might have been a logic error, except that gid->raw is the first member,
> so gid->raw == gid always.
>
> So the logic in mlx5_core_roce_gid_set() also works as intended.

It works by chance, assuming that "->raw" will be always first member is
not a good strategy, so I agree with Dan. It is NULL dereferencing.

>
> Nevertheless, this is semantically wrong, so I'll push a fix.
>
> >
> > regards,
> > dan carpenter
>

--WU3I8Do+sziGY3UL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlleI1UACgkQ5GN7iDZy
WKc5Yw/9FBjT+7eYNp4t+2e9mmC25bs4XRZVIykfmv5A9t67dpEfLlmN1vJsAQlf
Nuhy2RPWcusJ4hl6lgXlEnboZL7XQpAlMLVZhfXLaHr13NWBYK90RuQz2o0CkgHH
gmp/PA2BpkU2/dkEJN2/QYRQD+JMlxH8GlLraajcRRSjcXb1k4dQbtpHhzA+MTDc
jk2MqWxktboBA+7fGfeP3f7uOxPo13Cqr/MxV79WZDPutkh19e7O3c/fnGrqELKz
3INMIPRZ/5Unqj+9rV43csvl/GLU32ORBwgbzMO9mYkqPhsvLv0NbOAszDWALhhB
V5/azBNde7EWHeBGfgOx8up6viLBlrTwvk/Kax+Ra2NtfdaZ/7nAKWViQQ4RKbhL
fnWxL/5tqb/xNnjGnB2E+YZB07sMlf2rGbOh8vmz4R0Y3bhioFx8j/YNyiAMCF54
rOuyU7aDv2b6iX6qJD8O9gvIcOmbREClFqUfQ1tDA9or+feqJ/9K/ZPPvHXqQF6W
vaooju2rR/KG3KYGnBdJzUmkZRGwPAjr6Opo2A5rGL0kHUNnzB0UGXtN3dkZMuYW
dpXbm0MdheUiBQHP1C2TbnIjVzDFDVffbBvSUBZmZX6yL8VQcx4p3feWA2mG/nV3
uDNmjhc6j35GVvOpuZ6onje8aZRvkSF0D5lESs0CpU58pe6P6N0=
=8EtF
-----END PGP SIGNATURE-----

--WU3I8Do+sziGY3UL--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
