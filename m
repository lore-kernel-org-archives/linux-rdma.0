From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] RDMA/bnxt_re: Fix an error code in
 bnxt_qplib_create_srq()
Date: Wed, 31 Jan 2018 11:19:54 -0500
Message-ID: <1517415594.19117.17.camel@redhat.com>
References: <20180130150434.GA13690@mwanda>
         <CANjDDBjO7ZWE+OAzBRUZh_233YrRf++aeB3BitFAZNGf2RS-5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-yTOH6P/zmBnZELqUhOWs"
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <CANjDDBjO7ZWE+OAzBRUZh_233YrRf++aeB3BitFAZNGf2RS-5w@mail.gmail.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: Devesh Sharma <devesh.sharma@broadcom.com>, Dan Carpenter <dan.carpenter@oracle.com>
Cc: Selvin Xavier <selvin.xavier@broadcom.com>, Somnath Kotur <somnath.kotur@broadcom.com>, Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma <linux-rdma@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-yTOH6P/zmBnZELqUhOWs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-01-31 at 11:06 +0530, Devesh Sharma wrote:
> On Wed, Jan 31, 2018 at 2:10 AM, Dan Carpenter <dan.carpenter@oracle.com>=
 wrote:
> > We should return -ENOMEM if the allocation fails.  (The current code
> > returns succees).
> >=20
> > Fixes: 37cb11acf1f7 ("RDMA/bnxt_re: Add SRQ support for Broadcom adapte=
rs")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> >=20
> > diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infinib=
and/hw/bnxt_re/qplib_fp.c
> > index 8b5f11ac0e42..1b0e94697fe3 100644
> > --- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
> > +++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
> > @@ -557,8 +557,10 @@ int bnxt_qplib_create_srq(struct bnxt_qplib_res *r=
es,
> >=20
> >         srq->swq =3D kcalloc(srq->hwq.max_elements, sizeof(*srq->swq),
> >                            GFP_KERNEL);
> > -       if (!srq->swq)
> > +       if (!srq->swq) {
> > +               rc =3D -ENOMEM;
> >                 goto fail;
> > +       }
>=20
> Opps!! my bad. Thanks for fixing.
>=20
> Acked-By: Devesh Sharma <devesh.sharma@broadcom.com>

Thanks, applied.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-yTOH6P/zmBnZELqUhOWs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpx7KoACgkQuCajMw5X
L924eA/+M7LWzYb/FB1QLR3EOp/KvHMH4HHdhOFeB1dbCCSgx32Kl1t+YfGToYXd
FQOSeJagVPN7s1vtaBeWI2ZwkAsznrfzgOkBVFXNucVxzpAfk6nSOkuk1LAASX0E
9k2Of28aSlZJPOugDxvkHUHXSMMuD0Z+ATH4HkMHCocubXcHEI81spvWWmFy1+t9
VjdA4PGdRd/9d3Xl7itvnPD/C4BgTwl9wMrfKKDCq7Xphg5cVHWqrna9dHoMgBmn
p2t+T+ZgLZWPczlr7dvsEeqc0Kaz72PXe9FNdL31rzCrC6t1SHIYX5FcZra/Ryhx
4QTh/n+1u4hZRuw4SKNtSgfQOwRuUgSxAwfqZVb4oZKi22eKMoowceA0YxL1rz7k
pA11ZL4QAUcGqdcEQffPfOBRXvy3zoDgUx8EGg+c44Y8TcQWz13WmQlqKR3YFJ5+
5Ozdopri5zEf3zUWByBe/fyNoMp2DdgZ9SdvyokH/eJnoX6HAvoYc+u5/nsJowz7
Dy6lS1LJYeZG5yfrn3pm+9D/RqlxOVvObzFR/GTW968y7gOnD9m4Vkd/RzpUmvRv
7RMB/mf38AUUjels0vAJihTZEHGDm3BBwiQ/mb4C8jySteNnzAdsk3TCF3hTK9je
n7jNJMZCdm5EH+TjBvw3F64vpvze/7W9M3IDzd4uuS6zyGoe4Rc=
=al6f
-----END PGP SIGNATURE-----

--=-yTOH6P/zmBnZELqUhOWs--

