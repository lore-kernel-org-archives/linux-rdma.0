From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next v6 3/8] RDMA/restrack: Add general
 infrastructure to track RDMA resources
Date: Thu, 25 Jan 2018 11:39:59 -0500
Message-ID: <1516898399.27592.139.camel@redhat.com>
References: <20180125151227.28202-1-leon@kernel.org>
         <20180125151227.28202-4-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-xPTXeckV7hmxA8TyLVNJ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180125151227.28202-4-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-xPTXeckV7hmxA8TyLVNJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2018-01-25 at 17:12 +0200, Leon Romanovsky wrote:
> +       if (rdma_restrack_init(&device->res)) {
> +               kfree(device);
> +               return NULL;
> +       }
> +

[ snip ]

> +int rdma_restrack_init(struct rdma_restrack_root *res)
> +{
> +       init_rwsem(&res->rwsem);
> +       return 0;
> +}
> +

Is there a reason you are doing it this way?  Right now, the init can't
fail and the test for failure is a no-op.  I looked through the
remaining patches and nothing in this patchset changes that (at least
that I caught).  Is there a future intent here?  If so, I can see
leaving this as is (although if there is a respin, fixing it and then
changing it back when you add the actual failure opportunity would make
sense).  But, if not, the init function should be void and there should
be no failure test when calling it.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-xPTXeckV7hmxA8TyLVNJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpqCF8ACgkQuCajMw5X
L91u8g/8COA2ySCXLMd/ZkboOARd4mziJG9H+TS2NbvPUedr/3b5B/A1/tsdDYVo
SAioNaEw8MK+P/6ZYNTwHwBlWoBL40Rnz9vP+DcBos26T1m9VdGnKjeTwZlA2d3e
ARvhnkyNlBCdAVjJc+efmlgtwKKYkb91U3KBFf7ILGQwwk81rXBtW4GOX0uz90gt
c4eT+2y7pzM1/zVWaW0jDQSIHpRkyqrtng/+VTlDRRNr4rPHNutMP4SDsrOC7xB/
m0czOpWz1OzGTxDaSDRy6aK72Fmj9cjdoM8mF4PHp2UeUr54DSTXbd0RJ3T5ymyM
Xgk3kMMWv/i2YDYYpPHZDdhDmaHk+1ymEEwxdlb4r9mw+qHngiKp1aSWSjSuJOfR
MlSfXZOEmIXjDnVTt7f615LPXDd3H76n31bLRwpbvlPHB6gcflEAn7qFYKhZIoIT
OFJ/c0gryQJIMhcFPswRXEf6e/QbV9strZ9Gqp84BCfCLI2MjscTe4NYD/V2Ed/Y
uLtlb97498H1rFjLXSL+TfovwIQsMW6knYRJTXpGCx9AVP9wOERMRELMXxcHNRQL
Pk0r/LVtezJ1Y0DZd1g+fc8a9JwKdd0hodxFICu+o6/plUyzAm9SuJ66GB/pDxZj
wMUPIH1ieC02iv8+Mk9pKuoGWqTVWNl+0o88+wZzIcIXPS+xBas=
=lqVZ
-----END PGP SIGNATURE-----

--=-xPTXeckV7hmxA8TyLVNJ--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
