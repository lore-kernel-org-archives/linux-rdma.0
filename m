From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next 0/2] Fix to mlx5 devx interface
Date: Thu, 20 Dec 2018 08:11:05 +0200
Message-ID: <20181220061105.GG13943@mtr-leonro.mtl.com>
References: <20181219142811.21301-1-leon@kernel.org>
 <20181219191432.GY30567@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="CXFpZVxO6m2Ol4tQ"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181219191432.GY30567@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--CXFpZVxO6m2Ol4tQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 19, 2018 at 07:14:38PM +0000, Jason Gunthorpe wrote:
> On Wed, Dec 19, 2018 at 04:28:09PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Hi,
> >
> > This small fix to mlx5 devx interface is separated to two, so we can
> > apply first patch to mlx5-next.
> >
> > Thanks
> >
> > Yishai Hadas (2):
> >   IB/mlx5: Introduce uid as part of alloc/dealloc transport domain
> >   IB/mlx5: Use uid as part of alloc/dealloc transport domain
> >
> >  drivers/infiniband/hw/mlx5/cmd.c | 2 ++
> >  include/linux/mlx5/mlx5_ifc.h    | 4 ++--
> >  2 files changed, 4 insertions(+), 2 deletions(-)
>
> These look fine too, please update the shared branch

Done, thanks
71bef2fd583b IB/mlx5: Introduce uid as part of alloc/dealloc transport domain


>
> Thanks,
> Jason

--CXFpZVxO6m2Ol4tQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcGzJ5AAoJEORje4g2clinhogP/2yAT4a1BibBVym0Pl9vFjjk
9gU+eFVPOoBVnFGsL7zirYP5j9+OFFTsKQHSkXKqjYHkXfJQNZEedC7FvaLlbIdH
Tk9W6S6wROWCxDjJP/iZN/CYtTthrUHs4BoYAXzubQW59b3J3IGilb6J5v5AZf1O
ZngPsRqjqlC6W6dMUoBMsjihtWVJAk4uUIZr6ZCNNWyyrakIP8JrsHEMDH7P3Vv3
xmbJG9sZrYEPfm1/ahh01pZT+SLkLLvKWwGaAOD2ENCd1w1voZy8buhgvCUkrlh0
8Eoy1VJEFYy4dDopwy8dgH6MNEs8hPjcF2Rg5kx0BfNOHLtInzIIlP0OD/2RJqWF
a8r0QrB9Uac6mC5GkbK6l94YLuVgmVaLlCDhNkp8YZ1X1ZOOb/uyu6TRN/GDryaM
1tVxqQzkavQO0UmVmJxjKWXm+53URhIZqxu0RVYfhBlxuoUBcPDJDHUipMght2rg
LLgo1OpgobQQlwrpfOoog8uBYrE88TqdEcB3QkbQhxG+u0SJBLV/qGu0vR50Ut0r
HcUSa94T6W8ZMrNz4QlilQ1SAa4rNMsHXWcPRz1Mk6mFvAqb5cbS0jviwvlFJb/G
iSG+YjNgyPDXBRGzrRqO/LP5y8lJNGGSewCR7c7JFW181uu4vYjfdXHRmHgyT8aM
W/Vtxbd3qbtx++ewDQMW
=SBSn
-----END PGP SIGNATURE-----

--CXFpZVxO6m2Ol4tQ--
