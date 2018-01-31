From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [bug report] RDMA/bnxt_re: Add SRQ support for Broadcom adapters
Date: Wed, 31 Jan 2018 11:04:30 -0500
Message-ID: <1517414670.19117.16.camel@redhat.com>
References: <20180130124546.GA9394@mwanda>
         <CANjDDBiiL1TtH5OZ9gYuiZquKu2=AV+u9nJDQ--qibOP5CXgYg@mail.gmail.com>
         <20180131063238.ch4mcl7c6ps7ykxe@mwanda>
         <20180131064829.GR2055@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-d2J/iZRN+V+sgUK7jorf"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180131064829.GR2055-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-d2J/iZRN+V+sgUK7jorf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-01-31 at 08:48 +0200, Leon Romanovsky wrote:
> On Wed, Jan 31, 2018 at 09:32:38AM +0300, Dan Carpenter wrote:
> > On Wed, Jan 31, 2018 at 11:16:55AM +0530, Devesh Sharma wrote:
> > > On Tue, Jan 30, 2018 at 6:15 PM, Dan Carpenter <dan.carpenter@oracle.=
com> wrote:
> > > > Hello Devesh Sharma,
> > > >=20
> > > > The patch 37cb11acf1f7: "RDMA/bnxt_re: Add SRQ support for Broadcom
> > > > adapters" from Jan 11, 2018, leads to the following static checker
> > > > warning:
> > > >=20
> > > >         drivers/infiniband/hw/bnxt_re/ib_verbs.c:1317 bnxt_re_destr=
oy_srq()
> > > >         warn: 'srq->umem' isn't an ERR_PTR
> > > >=20
> > > > drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > > >   1313                  dev_err(rdev_to_dev(rdev), "Destroy HW SRQ =
failed!");
> > > >   1314                  return rc;
> > > >   1315          }
> > > >   1316
> > > >   1317          if (srq->umem && !IS_ERR(srq->umem))
> > > >                                   ^^^^^^^^^^^^^^^^
> > > > We never store error pointers to srq->umem.  It's pretty consistent=
ly
> > > > checked for error pointers though so maybe that's fine.  It causes =
a
> > > > static checker warning because error pointer confusion is a pretty
> > > > common source of bugs.  Anyway, feel free to ignore if you want...
> > >=20
> > > Thanks for reporting Dan,
> > >=20
> > > Is there a way out, I want to call ib_umem_release only if it was val=
id.
> > > I think if ib_umem_release checks for the validity of pointer then I
> > > can get rid of this?
> > > There are other places also in bnxt_re driver where such checks are p=
resent.
> >=20
> > Yeah.  Those places generate warnings as well, but I thought one was
> > enough.  It's fine if you want to ignore the warning, no one will be
> > upset.  :P
>=20
> Not really, we are trying to clean the subsystem from the warnings
> and driver authors who ignore such warnings simply and very effective
> sabotage it.
>=20
> Currently my checks print ~400 warnings for the drivers/infiniband/* +
> drivers/net/ethernet/mellanox/*
>=20
> So please don't increase this number, or fix the driver or fix the tool :=
)
>=20
> Thanks

Looking at the code, the proper fix for this is:

[dledford@haswell-e linus (k.o/wip/dl-for-next *)]$ git diff
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 9b8fa77b8831..ae9e9ff54826 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1314,7 +1314,7 @@ int bnxt_re_destroy_srq(struct ib_srq *ib_srq)
                return rc;
        }
=20
-       if (srq->umem && !IS_ERR(srq->umem))
+       if (srq->umem)
                ib_umem_release(srq->umem);
        kfree(srq);
        atomic_dec(&rdev->srq_count);
@@ -1430,11 +1430,8 @@ struct ib_srq *bnxt_re_create_srq(struct ib_pd
*ib_pd,
        return &srq->ib_srq;
=20
 fail:
-       if (udata && srq->umem && !IS_ERR(srq->umem)) {
+       if (srq->umem)
                ib_umem_release(srq->umem);
-               srq->umem =3D NULL;
-       }
-
        kfree(srq);
 exit:
        return ERR_PTR(rc);
[dledford@haswell-e linus (k.o/wip/dl-for-next *)]$=20

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-d2J/iZRN+V+sgUK7jorf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpx6Q8ACgkQuCajMw5X
L91N3Q/+JHIV1CWRZet/Z3az1peHMiIm1XqIexsAe7lCmeUJ0OSWYc0+azOnjYgM
2PkRfOHwd8uqJP3MTK64Hs0Ec8RlheewWhoSgsEYzLPTGPOkzuSqsO52e94aECoh
TAeOQedUgFsu5Ae9607crRa41FmYU3OZyuY12QoaAAwVijkxF01m1blPtgVNTw+6
bwNuS+XL5DqQBPCmjWlXVi1yFi1Km+Vjde6RpFQ0RlGBE7oIOVJXBqRNJUsrfTxg
WPFKA6ytVRFB2nR9EkJQupOvv7UQVCqsjqvoYDDjqYDzrTyZLfGbUsEM3Gxe9X3m
es8y1XcvPgFD/v2Cf+2XGuYymYx34PUMeDfAK8cE4vNZjozzlIjZMcZcwSumSUw8
BQ9H2ayNCC79BY5G0W7eWqGs9PFHdTjy+Zq55h90tE96+ad5MtmVOrxOnIPfkkQl
wbc+78a2IIa3spOxuvbfbMXMz3aqJqdzIf2CkrByNHNHUgViNNwjN0B1+EHFOfJ+
FFrM32ZBuLR69uPZLYgtCYbAbaKjPpZ1c+cXbKXbZvEeS52HnZewFOFDP6x75TLZ
3ZOkC2RHXr18AKLyXBKC6eJ+IuLfBzeorq6FAg7AoWwMw4z/oMvLTigLm2M4rlA3
7z4tENeeWlpgi7hrhtc7J2CrsM4VxuqfQnfO0rR3O5r8oJM9Svk=
=w/3F
-----END PGP SIGNATURE-----

--=-d2J/iZRN+V+sgUK7jorf--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
