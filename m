From: Doug Ledford <dledford@redhat.com>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Wed, 06 Feb 2019 15:47:53 -0500
Message-ID: <fbdeccb01f7d0ba2f6ebb69660b7aa3d99690042.camel@redhat.com>
References: <20190205175059.GB21617@iweiny-DESK2.sc.intel.com>
         <20190206095000.GA12006@quack2.suse.cz> <20190206173114.GB12227@ziepe.ca>
         <20190206175233.GN21860@bombadil.infradead.org>
         <47820c4d696aee41225854071ec73373a273fd4a.camel@redhat.com>
         <01000168c43d594c-7979fcf8-b9c1-4bda-b29a-500efe001d66-000000@email.amazonses.com>
         <20190206194055.GP21860@bombadil.infradead.org>
         <a9df9be75966f34f55f843a3cd7e1ee7d497c7fa.camel@redhat.com>
         <20190206202021.GQ21860@bombadil.infradead.org>
         <a8dc27e81182060b3480127332c77ac624abcb22.camel@redhat.com>
         <20190206204128.GR21860@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-v2GlgXLGc1VDjmRb7kC5"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190206204128.GR21860@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: Christopher Lameter <cl@linux.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jan Kara <jack@suse.cz>, Ira Weiny <ira.weiny@intel.com>, lsf-pc@lists.linux-foundation.org, linux-rdma@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org


--=-v2GlgXLGc1VDjmRb7kC5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-02-06 at 12:41 -0800, Matthew Wilcox wrote:
> On Wed, Feb 06, 2019 at 03:28:35PM -0500, Doug Ledford wrote:
> > On Wed, 2019-02-06 at 12:20 -0800, Matthew Wilcox wrote:
> > > On Wed, Feb 06, 2019 at 03:16:02PM -0500, Doug Ledford wrote:
> > > > On Wed, 2019-02-06 at 11:40 -0800, Matthew Wilcox wrote:
> > > > > On Wed, Feb 06, 2019 at 07:16:21PM +0000, Christopher Lameter wro=
te:
> > > > > > though? If we only allow this use case then we may not have to =
worry about
> > > > > > long term GUP because DAX mapped files will stay in the physica=
l location
> > > > > > regardless.
> > > > >=20
> > > > > ... except for truncate.  And now that I think about it, there wa=
s a
> > > > > desire to support hot-unplug which also needed revoke.
> > > >=20
> > > > We already support hot unplug of RDMA devices.  But it is extreme. =
 How
> > > > does hot unplug deal with a program running from the device (someth=
ing
> > > > that would have returned ETXTBSY)?
> > >=20
> > > Not hot-unplugging the RDMA device but hot-unplugging an NV-DIMM.
> > >=20
> > > It's straightforward to migrate text pages from one DIMM to another;
> > > you remove the PTEs from the CPU's page tables, copy the data over an=
d
> > > pagefaults put the new PTEs in place.  We don't have a way to do simi=
lar
> > > things to an RDMA device, do we?
> >=20
> > We don't have a means of migration except in the narrowly scoped sense
> > of queue pair migration as defined by the IBTA and implemented on some
> > dual port IB cards.  This narrowly scoped migration even still involves
> > notification of the app.
> >=20
> > Since there's no guarantee that any other port can connect to the same
> > machine as any port that's going away, it would always be a
> > disconnect/reconnect sequence in the app to support this, not an under
> > the covers migration.
>=20
> I don't understand you.  We're not talking about migrating from one IB
> card to another, we're talking about changing the addresses that an STag
> refers to.

You said "now that I think about it, there was a desire to support hot-
unplug which also needed revoke".  For us, hot unplug is done at the
device level and means all connections must be torn down.  So in the
context of this argument, if people want revoke so DAX can migrate from
one NV-DIMM to another, ok.  But revoke does not help RDMA migrate.

If, instead, you mean that you want to support hot unplug of an NV-DIMM
that is currently the target of RDMA transfers, then I believe
Christoph's answer on this is correct.  It all boils down to which
device you are talking about doing the hot unplug on.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-v2GlgXLGc1VDjmRb7kC5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlxbR/kACgkQuCajMw5X
L91T8Q//aNjsSFtXDnw9aQVHjEgaDUPAYp2QhT6rVK0ClhXiUiaP32FB0XYzeCCR
zXGaQydIteslRpddKI444p3f5lf8ysE/xVFqilSCJOIt2XypGyMk/pIRyGriERXD
rf8vljgMPGUiI5tCLx/AmSIlNSDkeRI5RbAsJlvFu15Mybgyj8+zeBz+eif7d20p
7lwAX9xSXJ6t9aQKM2P/wbrttXrIZDoKGvqm8eyy7wgzldnKgoemmMIdWqpj+vqJ
fus9lfFLjvt+3IsI7tbvT2hGAoRdSDHWnR0BxDhoWpwIdsJ+0cbwKCju9F+sdWg2
kjD6Fi4XpqgIl/K+4zgGxIPNl2LJ04FfXv/sfgI3ut3zO++J1QZYbKLMQ+wjykhg
6HVDIKCbe8kN3kT+vrUNzzxKQRFApZ9xrF+khoTTxYH2zaShIWi/3hzobtXIhpBh
jpoAiYr+iI0oOrHBgeWhjkuTDJ09H/MaokkL0PqLAp8tS+ZHz6muMOHS5imAID0w
ZuSNSKPJrmuMQp7Ze761NwI+/ABvM3XhT+JZGfrrjJb+UQZwVVW5mLK7bkgG1ZCv
aaZzo8UY6TBK2QOpdENbBVra8JnVy7+QdklWtUObatYTg05lwHtiJ8cz3jqY/+rA
yigK1CEB/QbkTp705ydzbiEUl2uRG3STxqKmaCiilOiqD/olhwU=
=lD5/
-----END PGP SIGNATURE-----

--=-v2GlgXLGc1VDjmRb7kC5--
