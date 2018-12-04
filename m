From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH mlx5-next 1/7] net/mlx5: Update mlx5_ifc with DEVX UCTX
 capabilities bits
Date: Tue, 4 Dec 2018 09:56:43 +0200
Message-ID: <20181204075643.GS6462@mtr-leonro.mtl.com>
References: <20181126062838.5907-1-leon@kernel.org>
 <20181126062838.5907-2-leon@kernel.org>
 <92d7a16f7c83b870d7c905d9199b28edd5aedbdc.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="jtcAeju3WzRmRF+o"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <92d7a16f7c83b870d7c905d9199b28edd5aedbdc.camel@redhat.com>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--jtcAeju3WzRmRF+o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 03, 2018 at 01:32:45PM -0500, Doug Ledford wrote:
> On Mon, 2018-11-26 at 08:28 +0200, Leon Romanovsky wrote:
> > From: Yishai Hadas <yishaih@mellanox.com>
> >
> > Expose device capabilities for DEVX user context, it includes which caps
> > the device is supported and a matching bit to set as part of user
> > context creation.
> >
> > Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
> > Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>
> This looks fine to me.  Is it in mlx5-next yet?
>

9d43faac02e3 net/mlx5: Update mlx5_ifc with DEVX UCTX capabilities bits

Thanks

--jtcAeju3WzRmRF+o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcBjM7AAoJEORje4g2clin3kcP/RPIY8uVS5miSPVtadH3TQ6a
WDXG7dhp2SG26u7m5cV5rOSuATaexlu931HQEHYacDv58y2NpKwJtIqoXOO/NoGz
+hyzbFeI2SrbLiZAu7zgqtlrEIYrSlUjnZeFUeOclnwK6YNBLlOrQeLv0vmPJEBC
mttvHtFBucZK3RkJFAMmO2PtchRGNQgyDarlMtgFrUYF9eJaz532W//9MCHZ3hfk
wxdja+QyDffJxQ4EouT0Y9FDefmUcSOIF08c3NMhoaxJ+dllxvwZVnF47FUvXGTm
wF2fkw12PdPVJpM5idDy1I1pSRT4krkO/VuKhY6JKrffKGbeE+fxF54JlUpSXWt7
HmQAhwdhHHg+2nbVMZp3ewdYRj76TliKg1Y7+IPxAnJfjQQDv/PqA+BmuGF/LXlq
CRxnokvsQXFjSjTCxSsHCA32wU+5/7oQ8hYaDra9lBYF0ANa7aOaZkjqWzgY4Spi
dw7Fa70t1553AFnuG1dWXruhh0EOss+ILfR4LZ6gjyr+u/Jgg9dD5I8fptrHKwpb
UKTFuq5BmleRuEknYe+0tVGyX29pTTtbyROHFzXsBT3szSSeGt1fbRJfqnmCPeWu
IeZWYH71mWNoR9Y1nNidI3PBRceiMcQarqB2PBkNncwr2UrjDmd+b4pm5HIDsZGv
qxhy6OV1pqC8ju3Ds4i3
=+yxO
-----END PGP SIGNATURE-----

--jtcAeju3WzRmRF+o--
