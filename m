From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] RDMA/core: reduce IB_POLL_BATCH constant
Date: Wed, 28 Feb 2018 13:55:14 -0500
Message-ID: <1519844114.28560.216.camel@redhat.com>
References: <20180220205924.2035765-1-arnd@arndb.de>
         <1519161268.3737.12.camel@wdc.com>
         <F2FB1034-BFB6-45ED-878E-6FADD756157D@oracle.com>
         <c3eab137-1c37-0e6c-a53a-df2cf80653d2@grimberg.me>
         <0f90134c-3d40-1d24-711f-e4ab32802bd8@mellanox.com>
         <c1bcd5cc-381d-2d94-1278-f9fb5c9c0b14@grimberg.me>
         <20180227220958.GA21714@ziepe.ca>
         <193aaf91-c9d1-38b1-a89f-45f129ca5798@mellanox.com>
         <d2875648-20d9-43b9-abf1-8ecbf049c4bf@wdc.com>
         <1e7c373f-21bd-4d45-3dd6-68467bf09d0d@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-CYAKZfCrWJJbB8XaESeN"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1e7c373f-21bd-4d45-3dd6-68467bf09d0d@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Max Gurtovoy <maxg@mellanox.com>, Bart Van Assche <bart.vanassche@wdc.com>, Jason Gunthorpe <jgg@ziepe.ca>, Sagi Grimberg <sagi@grimberg.me>
Cc: Chuck Lever <chuck.lever@oracle.com>, "arnd@arndb.de" <arnd@arndb.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "leonro@mellanox.com" <leonro@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--=-CYAKZfCrWJJbB8XaESeN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-02-28 at 11:50 +0200, Max Gurtovoy wrote:
>=20
> On 2/28/2018 2:21 AM, Bart Van Assche wrote:
> > On 02/27/18 14:15, Max Gurtovoy wrote:
> > > -static int __ib_process_cq(struct ib_cq *cq, int budget, struct ib_w=
c=20
> > > *poll_wc)
> > > +static int __ib_process_cq(struct ib_cq *cq, int budget, struct ib_w=
c=20
> > > *poll_wc,
> > > +                          int batch)
> > >   {
> > > -       int i, n, completed =3D 0;
> > > -       struct ib_wc *wcs =3D poll_wc ? : cq->wc;
> > > +       int i, n, ib_poll_batch, completed =3D 0;
> > > +       struct ib_wc *wcs;
> > > +
> > > +       if (poll_wc) {
> > > +               wcs =3D poll_wc;
> > > +               ib_poll_batch =3D batch;
> > > +       } else {
> > > +               wcs =3D cq->wc;
> > > +               ib_poll_batch =3D IB_POLL_BATCH;
> > > +       }
> >=20
> > Since this code has to be touched I think that we can use this=20
> > opportunity to get rid of the "poll_wc ? : cq->wc" conditional and=20
> > instead use what the caller passes. That will require to update all=20
> > __ib_process_cq(..., ..., NULL) calls. I also propose to let the caller=
=20
> > pass ib_poll_batch instead of figuring it out in this function.=20
> > Otherwise the approach of this patch looks fine to me.
>=20
> Thanks Bart.
> I'll make these changes and submit.

That sounds reasonable to me too, thanks for reworking and resubmitting.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-CYAKZfCrWJJbB8XaESeN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlqW+xIACgkQuCajMw5X
L92yoBAAoX6ppzz3BTC8UJViwV+8KOklKRhAcs7HQ6+oxxRBLTQrwkARXIEAVUSD
w4/rQIp9T4UPIIrtzqmLIji5QStlABbpIko02BMUsZ0zw3t6PTNX0QkbyCXeXxdn
FDP7tHATdQue1ONhqsNM3YLDy2qeazxCiYQsqvzx+YmkVkmaoeKF5bK9BTjnuDQa
UsBD20RBDUEhm911fYTP0ah8JrVWfaiafhdZAzp/vSWzP2Wrqb+crblWjZ0N0x3f
d5Z4ESq0HAlv0OhiBklxyLrws3MjMyJrDeOJ06s3btr7dqIjbnBeveDO8vGJSUGx
Bd/maWQ1AKobevvys2oPc5cNO7eXZPWk6wjGa8ZqOmfTm5X0V6V71v0kB7hGks+e
K1bJcbQvfO4M+HqbGdbDdHVA1KtWBhbqCUIkVixrPi4g2JKfunwBwih6DEVuAMOj
CqX3semucdFc8v8q0/AQlFZmkgZfVEuig2N5OUdVzKihOL1jeIDbsaM4DzZK8V41
aLAAbVuHZ/8MJ0USUvZskvEUfbhA3JUEkKpqrwdaA5EvFLTNwDoEZri+JXPYQ3Tr
+fV3pcPtvPtsOjM8nCdTKVWmiYc1/iTEATtMk86/K58V78LUV4rUxb1QboDr+Gcv
XbGQPWQDCfxTLPnJ4c/g2jrMqLIMt9Bgf2SIgawRcwHAsNyvZfE=
=pUan
-----END PGP SIGNATURE-----

--=-CYAKZfCrWJJbB8XaESeN--
