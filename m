From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 0/3] Mellanox ConnectX-3 Diagnostic Counters
Date: Tue, 26 Jul 2016 13:15:21 +0300
Message-ID: <20160726101521.GA4628@leon.nu>
References: <1468950898-9674-1-git-send-email-leon@kernel.org>
 <20160720102217.GT20674@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160720102217.GT20674-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 20, 2016 at 01:22:17PM +0300, Leon Romanovsky wrote:
> On Tue, Jul 19, 2016 at 08:54:55PM +0300, Leon Romanovsky wrote:
> > Hi Doug,
> >=20
> > This patch series adds diagnostic hardware counters for Mellanox
> > ConnectX-3 which uses the dynamic IB counters infrastructure.
> >=20
> > This series includes three patches, the first two add the necessary
> > functions to read the counters from the firmware and check for
> > firmware capability. The third patch exposes the functions needed
> > for the counter infrastructure.
> >=20
> > The counters exposed are applicable for IB and RoCE.
>=20
> Hi Doug,
> Please drop this patch series because we want to update patch #1 to
> eliminate future conflict in include/linux/mlx4/device.h file between
> net and RDMA subsystems.

Hi Doug,
I'm hope that you didn't follow my request to drop this patch series.
Luckily enough, we avoided such conflict by dropping NET patches,
and we will be glad if you proceed with this patch series.

I tested it by applying on Linus's v4.7 code base and it applied
cleanly.

Sorry for the noise and for the inconvenience.

Thanks

>=20
> Thanks
>=20
> >=20
> > Mark Bloch (3):
> >   net/mlx4: Add diagnostic counters capability bit
> >   net/mlx4: Query performance and diagnostics counters
> >   IB/mlx4: Add diagnostic hardware counters
> >=20
> >  drivers/infiniband/hw/mlx4/main.c       | 198 ++++++++++++++++++++++++=
+++++++-
> >  drivers/infiniband/hw/mlx4/mlx4_ib.h    |   9 ++
> >  drivers/net/ethernet/mellanox/mlx4/fw.c |  40 +++++++
> >  include/linux/mlx4/device.h             |   7 ++
> >  4 files changed, 253 insertions(+), 1 deletion(-)
> >=20
> > --=20
> > 2.1.4
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html



--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXlzg5AAoJEORje4g2clinp0gP/RXw9rPxYE703aaBNtL6sucJ
Zw4VjhInKyAfOjhaelLCNFQmf5acII5W/qnAccs8RsoJp2BaMlu8+wndl4YcWYIw
8emh7rg174d66D5x+k7YishYyZXc1FSkyTcJ7Ub0rniZ2v0QIH6+q4o3xLZy6frq
Vs078bjRz9gxdGxTnaupgDOp/2WOfz9yVVS+y2yGIQNtkpSr/En8KqpQHpIbpOgj
TvcHdol8xQZJqF10jfw1adiOh8Tq02Y8aj5czX/bSAmgmtg34oyaskBlGs7Vw75t
lFiFk0sFlEq84yGLUlDy6LI8qUq+NHuCMd4ZW9o5wlcBqosUGRHTYX9R7VkcUNRb
uAe0sckBWXPrzd85Mp4NJH4a1hCx1v0a7BYunmIuZE7FB8+ad2NgTohi5VGwcVyz
RHRPPhM8DQx4999iOqqBm1YKuP2dtPKnIkr0jSOUPL12TYYJCgrwdrj4auVr1dhD
Jj/MGN70vE0RoHxRsS3GDL3p/5MHeW8dFt5Ptn12RsKS1ekzzrjWRWAcjUBMtKU5
QOO6HAxVgBTOdRQ9lydghn5Iuu3Vrh7m1WXpZCyGPLSroq4p0fX1yb5/TFV/uvyr
/Dp/fG0Bq4FUU+CY7Zsy3A7gLOjkTC7NbsGi24fLfI7GfcV0AnTE+gFas9desLjM
te1z17P9QsqKN7UyXETr
=vz7H
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
