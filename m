From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH mlx5-next] net/mlx5: Separate ODP capabilities
Date: Thu, 21 Feb 2019 12:10:06 +0000
Message-ID: <20190221121003.GB17501@mtr-leonro.mtl.com>
References: <20190219130638.21981-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="61jdw2sOBCFtR2d/"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190219130638.21981-1-leon@kernel.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Moni Shoua <monis@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

--61jdw2sOBCFtR2d/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 19, 2019 at 03:06:37PM +0200, Leon Romanovsky wrote:
> From: Moni Shoua <monis@mellanox.com>
>
> ODP support for XRC transport is not enabled by default in FW,
> so we need separate ODP checks to enable/disable it.
>
> While that, rewrite the set of ODP SRQ support capabilities in way
> that tests each field separately for clearness, which is not needed
> for current FW, but better to have it separated.
>
> Signed-off-by: Moni Shoua <monis@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/main.c    | 29 ++++++++++---------
>  1 file changed, 15 insertions(+), 14 deletions(-)
>

Thanks, applied to mlx5-next
f1463b9f1a97 net/mlx5: Separate ODP capabilities

Doug, Jason,

Can you please merge this branch into rdma-next as a preparation
to pull request?

Thanks

--61jdw2sOBCFtR2d/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcbpUbAAoJEORje4g2clinusoQALbPkU8wFkuCw7wVxlKnd622
iNU4xx8ACWowLVYfcUc+b8uG+Mb47hI7btdj0hGRi3CwwUlzjeqbKd+7YQjvQ0xr
+U5Ae2PsCSLV/Vpwxt1MfR2GLPp7l+acMiqUiqlnkKypbAzq2yFk4prW4NqQAbpk
wBp7zN+0ILw26inrNeumUIfhJ5b+aCnoUBQvSpkDCpea3oJzRAyzukeWJ5uo/iTA
Sy4cXghC7xXW4PZywjWFkrNJnXi/52j8NGoGWRcaIC3MzKVh3ErX7U7xhHsqeARd
kL2XL7ShYM863Nb48VW9Ik5OlpSGTlO+vPec5h4t4WWw50QeQOp4WVXUeIOXoHCA
6ODiZ2hCr52lZ4wM9fdMrVVrM7PaDuHuTiTAZw/0z1CFuoA+yeimqM9o1R1R7lqq
6I6AlKd3ijUUEDNZhcyDogW0AQctzq5eM16voAnXRHvEEXUgj5hpCKnDepZJuQdB
zKDexp4N7WKQx3Sfd/kMDwp9Jh9eVynvMhYpQaKXSrW7D4uwewZN+ScGa4iZmF1A
7B2tgUffTSvAJjSVQUBs4O7aApHtc4t/N98S1gcX8w2zxi6GFAcFDXFPFnRdAEt0
InL+5RpxbnwpMkuYzMI30zFgAYfbqsat+cMuFLoeHpZqA9TDjrEZedK0xekODsox
g0a3qfiX0azPYEejCRPC
=lKu1
-----END PGP SIGNATURE-----

--61jdw2sOBCFtR2d/--
