From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] RDMA/hns: Use 64-bit arithmetic instead of 32-bit
Date: Thu, 18 Oct 2018 20:17:10 -0400
Message-ID: <4bf459e9feb559270983530d2e3720e78a167b05.camel@redhat.com>
References: <20181018080258.GA1720@embeddedor.com>
         <20181018110155.GH5007@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-QTC4Qu8i3B+FHK5g2WYS"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181018110155.GH5007@mtr-leonro.mtl.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Lijun Ou <oulijun@huawei.com>, "Wei Hu(Xavier)" <xavier.huwei@huawei.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-QTC4Qu8i3B+FHK5g2WYS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2018-10-18 at 14:01 +0300, Leon Romanovsky wrote:
> On Thu, Oct 18, 2018 at 10:02:58AM +0200, Gustavo A. R. Silva wrote:
> > Cast *max_num_sg* to u64 in order to give the compiler complete
> > information about the proper arithmetic to use.
> >=20
> > Notice that such variable is used in a context that expects an
> > expression of type u64 (64 bits, unsigned) and the following
> > expression is currently being evaluated using 32-bit
> > arithmetic:
>=20
> And what is wrong with that?
> Please fix static analyzer tool instead of fixing proper C code.

Judging on the static analyzer tool's message, I don't see anything
wrong with it.  The code contains a potential unintentional overflow
error.  The author might have been well aware of the overflow and not
cared and in that case this is valid C, but the analyzer has no way of
knowing that, so it flags it for review.  To silence the checker you
could either cast the arithmetic to u64, or cast length to u32.  Either
would clear up the ambiguity.  I guess I'm not seeing why you would
blame the static checker in this case, it did the best it is possible
for it to do.

> Thanks
>=20
> >=20
> > length =3D max_num_sg * page_size;
> >=20
> > Addresses-Coverity-ID: 1474517 ("Unintentional integer overflow")
> > Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> > ---
> >  drivers/infiniband/hw/hns/hns_roce_mr.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniba=
nd/hw/hns/hns_roce_mr.c
> > index 521ad2a..d479d5e 100644
> > --- a/drivers/infiniband/hw/hns/hns_roce_mr.c
> > +++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
> > @@ -1219,7 +1219,7 @@ struct ib_mr *hns_roce_alloc_mr(struct ib_pd *pd,=
 enum ib_mr_type mr_type,
> >  	int ret;
> >=20
> >  	page_size =3D 1 << (hr_dev->caps.pbl_buf_pg_sz + PAGE_SHIFT);
> > -	length =3D max_num_sg * page_size;
> > +	length =3D (u64)max_num_sg * page_size;
> >=20
> >  	if (mr_type !=3D IB_MR_TYPE_MEM_REG)
> >  		return ERR_PTR(-EINVAL);
> > --
> > 2.7.4
> >=20

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-QTC4Qu8i3B+FHK5g2WYS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlvJIoYACgkQuCajMw5X
L93sIg//TG/UnayqkdNN90uh3lQS5Zw5UQLBWQyvoV/KE73eu59CosYQBJ8z291C
WotzE/XpwmXGtPSeacdhOo811sRWGIIR2g7B0gJzAdiX9z81L6kygX+mXLu8/yls
nmHeDUqc86IeCNdSaLRlxP1TKZMSmZ3EpWeMLkWEkSBhBzkxKzc0z9h+LTsWvDG3
Qo+4r2yPEDtguNHm/zdGU9eWSEn+EUBOBM0upaCmoKl+fIvhp3Dy1ZO43QbcjoDG
Sm8YrKw3SNUSqKtloro49EAAibiYPgN6icY1dLi0A7R6v7187+cN3s4zsuXmywe8
Bz7jLcYgbQzn0AkM3Hxyu+I1nV98RKKuAmp8vWFyHjexHrbtGFxw/WIVJ7wTYgEo
lS/aXRpexpVvKkvorMpvfu5+j+bicOtHmPEl9gzZq4hTBzxoJhAmgj+B1col8JAN
eAnMJ82IaCyUJT6gNf4KUNQbVuK1CMGLhloXBdBbELBvDu/aorIWSXYVy7J2OtEr
WlbU9uE5kuUhd0EtEDWDpHaa3dYWugQ12B7Ngky4Qi5I+Y43POIcXozxkl7GAGCF
ja9v6MizzcCST3shDxOFa8U38TFlwGfOhwxk9Ao5E48N8HpQjSweIp/HifM+znE5
FVCoVcWdhKcPQ7e/nxWSaPURY+VDhkOzvu+zrQY60ncC1mBAZ8o=
=shAM
-----END PGP SIGNATURE-----

--=-QTC4Qu8i3B+FHK5g2WYS--
