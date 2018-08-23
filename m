From: Doug Ledford <dledford@redhat.com>
Subject: Re: [RDMA bug] KASAN: use-after-free Read in __list_del_entry_valid
 (4)
Date: Thu, 23 Aug 2018 12:55:32 -0400
Message-ID: <1256f66271b31955f6e77c59335f4f75801eacf2.camel@redhat.com>
References: <001a1141551246502d056845782e@google.com>
         <001a1140f6ac1677460568489287@google.com>
         <20180823061630.GB736@sol.localdomain> <20180823145458.GC9366@ziepe.ca>
         <VI1PR0501MB22714BE9A34FA333671A0623D1370@VI1PR0501MB2271.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-1hOCxhPfAMC4OoIn6a/M"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <VI1PR0501MB22714BE9A34FA333671A0623D1370@VI1PR0501MB2271.eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Parav Pandit <parav@mellanox.com>, Jason Gunthorpe <jgg@ziepe.ca>, Eric Biggers <ebiggers@kernel.org>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "dasaratharaman.chandramouli@intel.com" <dasaratharaman.chandramouli@intel.com>, Leon Romanovsky <leonro@mellanox.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Moni Shoua <monis@mellanox.com>, "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>, syzbot <syzbot+29ee8f76017ce6cf03da@syzkaller.appspotmail.com>
List-Id: linux-rdma@vger.kernel.org


--=-1hOCxhPfAMC4OoIn6a/M
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2018-08-23 at 16:39 +0000, Parav Pandit wrote:
> > -----Original Message-----
> > From: Jason Gunthorpe <jgg@ziepe.ca>
> > Sent: Thursday, August 23, 2018 9:55 AM
> > To: Eric Biggers <ebiggers@kernel.org>
> > Cc: Doug Ledford <dledford@redhat.com>; linux-rdma@vger.kernel.org;
> > dasaratharaman.chandramouli@intel.com; Leon Romanovsky
> > <leonro@mellanox.com>; linux-kernel@vger.kernel.org; Mark Bloch
> > <markb@mellanox.com>; Moni Shoua <monis@mellanox.com>; Parav Pandit
> > <parav@mellanox.com>; syzkaller-bugs@googlegroups.com; syzbot
> > <syzbot+29ee8f76017ce6cf03da@syzkaller.appspotmail.com>
> > Subject: Re: [RDMA bug] KASAN: use-after-free Read in __list_del_entry_=
valid
> > (4)
> >=20
> > On Wed, Aug 22, 2018 at 11:16:31PM -0700, Eric Biggers wrote:
> > > Hello RDMA / InfiniBand maintainers,
> > >=20
> > > This is an RDMA bug and it still occurs on Linus' tree as of today
> > > (commit 815f0ddb346c1960).
> > >=20
> > > I've also simplified the reproducer for it; see below after the origi=
nal report.
> > > Apparently it involves a race between RDMA_USER_CM_CMD_RESOLVE_IP
> >=20
> > and
> > > RDMA_USER_CM_CMD_LISTEN.
> >=20
> > That is an amazing reproducer!
> >=20
> > I have a feeling this is the same cause as all the other syzkaller bugs=
 in this code:
> > lack of any sane locking at all :\
> >=20
> > We've talked about chucking a big lock around this whole thing, but nob=
ody has
> > done it yet.. It isn't so simple.
> >=20
>=20
> I had some code in which reduces three locks (handler_lock, qp_mutex, id_=
lock) to single mutex to protect the cm_id and protects every exported symb=
ol of rdmacm which works on cm_id.
> But not ready enough to post it as patch yet. Lot of tests required befor=
e I get there and some refactor too before that.

Does it finally address the fact that the rdmacm code was written so
that it was always synchronous but RoCE src gid (I think that's what it
was, I'm typing this from long ago memory) lookup broke that assumption?

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-1hOCxhPfAMC4OoIn6a/M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlt+5wUACgkQuCajMw5X
L92zTA//cxfwkrUPFruDslfZ1i8fasSqTzifYuRkh7wikJ/4wI+0+WYv550sgV77
0m/LdIx45d8kCNNfvWJbg/hcZCiskga9/89HPCwhv/imm9UDeQnU4JhULtVXhB5d
RLR8O3ObzaE3Vtotn7iX23/5tpe7+dlijq+pKfkCWyGMxX2ZPIyy6n2kpT7TB38O
9X5gFQ5jfcMAYRh8KzEguPL9Pv5p3X/dQ0Ugl1jSww+ylMcXGV5zU++79Jm19ZdZ
J9YVzhiB7uneMkCkAJu2YdbGMFqoA+3QU8Mimop9qWfSGhwOsIba6CBlsNoDrW3B
HCfUBLA8P5zWalLHOmWOECw3dZxe1o5KKrp5IoR0iR79VLuHhpoV+YanLlLfl+4U
/r6Vo/bNNtxVv3E/1X+uUz/YHmmhw12h2jaqtf8R9WOrgj9mdz2eIHv7ULSgovcy
2aIErmKwi2af2iWVrmFKsbQEWl8leA6P9yr44+v1GhALMulc3HLmiP12wpF/rSl9
V2/oCVxJXJdykrFctxQp1lxzsvEKYqSTEC4CgBY8Yftb2Eh7gGIheTYqFeRr0qI2
NervDVSU9tkvp4L7alNoMDeXwgD1ULkPFjfGDekzP0EuXFYIB6jMEghxQOeBbEOp
wSeqItmVIfIfskyf5eHSa5r1ycVaufTvElkto3ltzG2kBXM3HmI=
=1U3/
-----END PGP SIGNATURE-----

--=-1hOCxhPfAMC4OoIn6a/M--
