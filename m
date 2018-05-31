From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] iw_cxgb4: add INFINIBAND_ADDR_TRANS dependency
Date: Thu, 31 May 2018 14:40:59 -0400
Message-ID: <d23e215a30f1277c941973043262cdfc60c71315.camel@redhat.com>
References: <20180530215826.1343234-1-arnd@arndb.de>
         <20180530220405.GH30754@ziepe.ca>
         <0be4e0fb-8d8e-b337-fc8d-550c90829d8c@opengridcomputing.com>
         <20180530222520.GJ30754@ziepe.ca>
         <d2472443-3ae6-63f4-59ad-d6367b837038@opengridcomputing.com>
         <CAK8P3a3HZXTR60ua=cjBHnB5FWWKve9F-JqcNwn0ujks+=FsNg@mail.gmail.com>
         <20180530230136.GK30754@ziepe.ca>
         <CAHH2K0ZLDmsPNw=sOobL=+R54yRFrnG4syWcW43UEbwxsvFehw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-ZyZG+Y8B7/CFG123HGDp"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHH2K0ZLDmsPNw=sOobL=+R54yRFrnG4syWcW43UEbwxsvFehw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Thelen <gthelen@google.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Arnd Bergmann <arnd@arndb.de>, swise@opengridcomputing.com, swise@chelsio.com, yuval.shaia@oracle.com, linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Tarick Bedeir <tarick@google.com>
List-Id: linux-rdma@vger.kernel.org


--=-ZyZG+Y8B7/CFG123HGDp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-05-30 at 21:03 -0700, Greg Thelen wrote:
> On Wed, May 30, 2018 at 4:01 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>=20
> > On Thu, May 31, 2018 at 12:40:54AM +0200, Arnd Bergmann wrote:
> > > > On 5/30/2018 5:25 PM, Jason Gunthorpe wrote:
> > > > > On Wed, May 30, 2018 at 05:10:35PM -0500, Steve Wise wrote:
> > > > > >=20
> > > > > > On 5/30/2018 5:04 PM, Jason Gunthorpe wrote:
> > > > > > > On Wed, May 30, 2018 at 11:58:18PM +0200, Arnd Bergmann wrote=
:
> > > > > > > > The newly added fill_res_ep_entry function fails to link if
> > > > > > > > CONFIG_INFINIBAND_ADDR_TRANS is not set:
> > > > > > > >=20
> > > > > > > > drivers/infiniband/hw/cxgb4/restrack.o: In function
>=20
> `fill_res_ep_entry':
> > > > > > > > restrack.c:(.text+0x3cc): undefined reference to `rdma_res_=
to_id'
> > > > > > > > restrack.c:(.text+0x3d0): undefined reference to `rdma_iw_c=
m_id'
> > > > > > > >=20
> > > > > > > > This adds a Kconfig dependency for the driver.
> > > > > > > >=20
> > > > > > > > Fixes: 116aeb887371 ("iw_cxgb4: provide detailed
>=20
> provider-specific CM_ID information")
> > > > > > > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > > > > > > >  drivers/infiniband/hw/cxgb4/Kconfig | 1 +
> > > > > > > >  1 file changed, 1 insertion(+)
> > > > > > >=20
> > > > > > > Oh, I think we need to solve this with maybe a header fill nu=
ll
>=20
> stub
> > > > > > > instead..
> > > > > > >=20
> > > > > > > We don't want to disable drivers just because a user interfac=
e is
> > > > > > > disabled.
> > > > > > >=20
> > > > > >=20
> > > > > > Why does CONFIG_INFINIBAND_ADDR_TRANS disable building rdma_cm.=
ko?
>=20
> That
> > > > > > is not correct.
> > > > >=20
> > > > > That seems like a reasonable thing to do..
> > > >=20
> > > > rdma_ucm.ko is for usermode users, rdma_cm.ko is for kernel users, =
and
> > > > is required for iwarp drivers.  It seems rdma_cm.ko is not being
> > > > compiled if ADDR_TRANS is not set.
> > I think the intention was to completely disable rdma-cm, including all
> > support for rx'ing remote packets? Greg?
>=20
> Yes.  That's my goal when INFINIBAND_ADDR_TRANS is unset.
>=20
> > If this is required for iwarp then Arnd's patch is probably the right
> > way to go..
> > Jason
>=20
> Agreed.
> Acked-by: Greg Thelen <gthelen@google.com>

If that's the case, then there should be a NOTE: in the Kconfig that
disabling the connection manager completely disables iWARP hardware.

I don't really think I like this approach though.  At a minimum if you
are going to make iWARP totally dependent on rdmacm, then there is zero
reason that iw_cm.o should be part of the obj-$(CONFIG_INFINIBAND)
Makefile recipe when ADDR_TRANS is disabled.

We can take this patch as a band-aid, but IMO it's either incomplete or
simply not the right solution.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-ZyZG+Y8B7/CFG123HGDp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlsQQbsACgkQuCajMw5X
L90J9A//WegGX8YmCVvC3IzVaBGFKGiuNaCa1/hoE5s0IFwvxB6LV+HaON5W+Edi
uhrkEWtwXQ4l9oEBipk2RxAZ+o9dlPRvRlTMrd6RHOlZ9zXo9LGifLUN8evPm3wU
aGVtZkLyZRY7rhRFsfXIdwrIa1bvlacxNqXIWbItFbCg5ClsGLoFs1qrTB4+zqjp
0rafaTZysFNngA8axHl4NSboEJj51XitfTahYhCd39a/CMtl2P4g0Su05fPvfMck
VmYuL95941B2yVQ/nPEh7qldlEb6/P8tlLEpcE6mMl/Ok/MTJHtb9Fng8ZIIhXLG
OyzSINrMeKQT6mVBd0VQwwJ02KGa6G/P36ESajCCie8SmROrszzw5njX1Ae0RSDD
p/mP4hRpaIBhtP+TrFncXBtfUN4zGhBMMnp7q6Q+YriS74Lk0/ONBJptTh1MVa7k
t6+YvbVrUBX2PqhBsZToqCw6Ys4b2qoWg9A9MEAFXu4XcIHovb7lIjCQX3ou2uTH
7sK79FhS6dfuLqTw8B2Y0x4tBO9YmHY/pwQF10vCcs3QeG9SH7aZN5HVTiknQpvA
+zbGD5EOWuJTOugMrLCsQ+XF7ickxLVW1Zj335K+plVfiaz3QG+lFN9CIOt93Zn1
Mo5NTXfBS5tCyhaWEk+r97NbtPawn4BPAw3ujG+BV3FCoFGCTtA=
=FkYT
-----END PGP SIGNATURE-----

--=-ZyZG+Y8B7/CFG123HGDp--
