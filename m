From: Doug Ledford <dledford@redhat.com>
Subject: Re: [patch 1/1] drivers/infiniband/core/verbs.c: fix build with
 gcc-4.4.4
Date: Wed, 14 Mar 2018 16:41:00 -0400
Message-ID: <1521060060.18703.111.camel@redhat.com>
References: <20180313215157.GL3mSm-p6%akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-ABDqG9Lrm+/lS+l3X7qm"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180313215157.GL3mSm-p6%akpm@linux-foundation.org>
Sender: stable-owner@vger.kernel.org
To: akpm@linux-foundation.org, bart.vanassche@wdc.com, jgg@mellanox.com, linux-rdma@vger.kernel.org, sagi@grimberg.me, stable@vger.kernel.org, swise@opengridcomputing.com
List-Id: linux-rdma@vger.kernel.org


--=-ABDqG9Lrm+/lS+l3X7qm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-03-13 at 14:51 -0700, akpm@linux-foundation.org wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: drivers/infiniband/core/verbs.c: fix build with gcc-4.4.4
>=20
> gcc-4.4.4 has issues with initialization of anonymous unions.

That compiler was released in April of 2010, almost a full 8 years ago.=20
What still uses it, and do we seriously care?

>=20
> drivers/infiniband/core/verbs.c: In function '__ib_drain_sq':
> drivers/infiniband/core/verbs.c:2204: error: unknown field 'wr_cqe' speci=
fied in initializer
> drivers/infiniband/core/verbs.c:2204: warning: initialization makes integ=
er from pointer without a cast
>=20
> Work around this.
>=20
> Fixes: a1ae7d0345edd5 ("RDMA/core: Avoid that ib_drain_qp() triggers an o=
ut-of-bounds stack access")
> Cc: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Steve Wise <swise@opengridcomputing.com>
> Cc: Sagi Grimberg <sagi@grimberg.me>
> Cc: Jason Gunthorpe <jgg@mellanox.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>=20
>  drivers/infiniband/core/verbs.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff -puN drivers/infiniband/core/verbs.c~drivers-infiniband-core-verbsc-=
fix-build-with-gcc-444 drivers/infiniband/core/verbs.c
> --- a/drivers/infiniband/core/verbs.c~drivers-infiniband-core-verbsc-fix-=
build-with-gcc-444
> +++ a/drivers/infiniband/core/verbs.c
> @@ -2200,8 +2200,9 @@ static void __ib_drain_sq(struct ib_qp *
>  	struct ib_send_wr *bad_swr;
>  	struct ib_rdma_wr swr =3D {
>  		.wr =3D {
> +			.next =3D NULL,
> +			{ .wr_cqe	=3D &sdrain.cqe, },
>  			.opcode	=3D IB_WR_RDMA_WRITE,
> -			.wr_cqe	=3D &sdrain.cqe,
>  		},
>  	};
>  	int ret;
> _
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-ABDqG9Lrm+/lS+l3X7qm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlqpiNwACgkQuCajMw5X
L91jpBAAgrGeR4lUBy4XstYC+T563vt7QdFlL1UAEe5NWXy5P6OZuHd9iuu15dm6
Gpoxbkr5SHWXJE3UB00/KjaOHOF2HnOIc1Yl0qWsOguSImgxiTFvjQiUoiKk+75I
E6ibXxrs/bylbxG+FaIlsHI9KRPEKQFwiX0BMQ2tewQi5fY3qyTWwEZ27do4/Mkn
IgZmbRUUNCtGa8HPVBJfD8w/ZQ65DNJodvOQYt/Pt85u5AjwiWep5KMlqrTUx2jY
EXFERQgXudPAGQfqYdfZxKtqQwvjpMmzvX2lfBECLo0CzxQm2vvUKyZBu0oetIed
iQrgRNLztPZqI3uAaZpkU/KlvC2lqQ7nMsbowfoKvKODU2BQuYAaxuMbPrctgpzg
Mt/Sa4gkq6WRyximZntYv3rE/bpUkpmTcyIEoV6hQLhaZPWxR1F4NS3q9l6tfvpr
Xcg67ZNAncwi0cnaeUFggzkytEKwyelMkXccQqqwkNNbce15OWP+UfMFxV7Byds6
llMJhw7aGm1FJ5kHnD50j29pZDU7niwXt1UdDou8+OcE9QcGb4dJA4o+fQ4WiZk6
mC234KwG0m9q15RVu31z86DW674oS9g2NxRcvedIR2/1/LAnTIOETXtkHHauQrKc
MGxLASHlMW6xbWhECCQWLeHRnWEpt/z7wH3Q8k1/xUD9pdfONBg=
=PeSj
-----END PGP SIGNATURE-----

--=-ABDqG9Lrm+/lS+l3X7qm--
