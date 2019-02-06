From: Doug Ledford <dledford@redhat.com>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Wed, 06 Feb 2019 17:24:50 -0500
Message-ID: <0c868bc615a60c44d618fb0183fcbe0c418c7c83.camel@redhat.com>
References: <20190205175059.GB21617@iweiny-DESK2.sc.intel.com>
         <20190206095000.GA12006@quack2.suse.cz> <20190206173114.GB12227@ziepe.ca>
         <20190206175233.GN21860@bombadil.infradead.org>
         <47820c4d696aee41225854071ec73373a273fd4a.camel@redhat.com>
         <01000168c43d594c-7979fcf8-b9c1-4bda-b29a-500efe001d66-000000@email.amazonses.com>
         <20190206210356.GZ6173@dastard> <20190206220828.GJ12227@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-5bjhfkCd3CuoQXipvuOM"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190206220828.GJ12227@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>, Dave Chinner <david@fromorbit.com>
Cc: Christopher Lameter <cl@linux.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Ira Weiny <ira.weiny@intel.com>, lsf-pc@lists.linux-foundation.org, linux-rdma@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org


--=-5bjhfkCd3CuoQXipvuOM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-02-06 at 15:08 -0700, Jason Gunthorpe wrote:
> On Thu, Feb 07, 2019 at 08:03:56AM +1100, Dave Chinner wrote:
> > On Wed, Feb 06, 2019 at 07:16:21PM +0000, Christopher Lameter wrote:
> > > On Wed, 6 Feb 2019, Doug Ledford wrote:
> > >=20
> > > > > Most of the cases we want revoke for are things like truncate().
> > > > > Shouldn't happen with a sane system, but we're trying to avoid us=
ers
> > > > > doing awful things like being able to DMA to pages that are now p=
art of
> > > > > a different file.
> > > >=20
> > > > Why is the solution revoke then?  Is there something besides trunca=
te
> > > > that we have to worry about?  I ask because EBUSY is not currently
> > > > listed as a return value of truncate, so extending the API to inclu=
de
> > > > EBUSY to mean "this file has pinned pages that can not be freed" is=
 not
> > > > (or should not be) totally out of the question.
> > > >=20
> > > > Admittedly, I'm coming in late to this conversation, but did I miss=
 the
> > > > portion where that alternative was ruled out?
> > >=20
> > > Coming in late here too but isnt the only DAX case that we are concer=
ned
> > > about where there was an mmap with the O_DAX option to do direct writ=
e
> > > though? If we only allow this use case then we may not have to worry =
about
> > > long term GUP because DAX mapped files will stay in the physical loca=
tion
> > > regardless.
> >=20
> > No, that is not guaranteed. Soon as we have reflink support on XFS,
> > writes will physically move the data to a new physical location.
> > This is non-negotiatiable, and cannot be blocked forever by a gup
> > pin.
> >=20
> > IOWs, DAX on RDMA requires a) page fault capable hardware so that
> > the filesystem can move data physically on write access, and b)
> > revokable file leases so that the filesystem can kick userspace out
> > of the way when it needs to.
>=20
> Why do we need both? You want to have leases for normal CPU mmaps too?
>=20
> > Truncate is a red herring. It's definitely a case for revokable
> > leases, but it's the rare case rather than the one we actually care
> > about. We really care about making copy-on-write capable filesystems li=
ke
> > XFS work with DAX (we've got people asking for it to be supported
> > yesterday!), and that means DAX+RDMA needs to work with storage that
> > can change physical location at any time.
>=20
> Then we must continue to ban longterm pin with DAX..
>=20
> Nobody is going to want to deploy a system where revoke can happen at
> any time and if you don't respond fast enough your system either locks
> with some kind of FS meltdown or your process gets SIGKILL.=20
>=20
> I don't really see a reason to invest so much design work into
> something that isn't production worthy.
>=20
> It *almost* made sense with ftruncate, because you could architect to
> avoid ftruncate.. But just any FS op might reallocate? Naw.
>=20
> Dave, you said the FS is responsible to arbitrate access to the
> physical pages..
>=20
> Is it possible to have a filesystem for DAX that is more suited to
> this environment? Ie designed to not require block reallocation (no
> COW, no reflinks, different approach to ftruncate, etc)

Can someone give me a real world scenario that someone is *actually*
asking for with this?  Are DAX users demanding xfs, or is it just the
filesystem of convenience?  Do they need to stick with xfs?  Are they
really trying to do COW backed mappings for the RDMA targets?  Or do
they want a COW backed FS but are perfectly happy if the specific RDMA
targets are *not* COW and are statically allocated?

> > And that's the real problem we need to solve here. RDMA has no trust
> > model other than "I'm userspace, I pinned you, trust me!". That's
> > not good enough for FS-DAX+RDMA....
>=20
> It is baked into the silicon, and I don't see much motion on this
> front right now. My best hope is that IOMMU PASID will get widely
> deployed and RDMA silicon will arrive that can use it. Seems to be
> years away, if at all.
>=20
> At least we have one chip design that can work in a page faulting mode
> ..
>=20
> Jason

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-5bjhfkCd3CuoQXipvuOM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlxbXrIACgkQuCajMw5X
L92eWQ/+ODb+cP0wjR0XAf8kfnKl79sjmcte7mdkTwDXOgwrGQ2T1H0sOmNqJ+g/
uJqSNYB5eS1qO7UedYc38TsAGDVIdCWIyHvdNPv2pg6csnujSOJO1cB1DdA5Vsj2
aBDEEbrR0nd/7QNcjooKlmZXtto8VgvVkSmKEauZNSeMaW80koef5dVzzRmkkRyq
nq3Pe+PzB+Ohre4ShN6LRkWnor5lv/aQ73Hg2FAC47rwmJVNCg2SRVw8JSs3BW9E
pwNBttGC5i9T9PPAcH2vAOUaZ7FZXh1O5FhHpTEhJiesu9TzW3gZZTUkCmE9aMPK
TCWBt7FhGa/x+qGJ2DL4fNWFXGW3mrVLQtgP/mdx6+cMxUn07/KkBZDnncT8TVDo
HyeD3yj3YFTG3sJp6zWsbKniyCIVB282pZXbjNudtdYMEt15Hq2WX3xzV4+g9QBs
elLaL4tkvd82G2TgrMgAtCis9dB9YYRWDLskRQA5azhLP82wrbOJF0dfRlQA2+NS
JDdGLpmXbBdwY4Qk4ZYzarE95pZ6Y5VOZSFRynunKnYb59NaCP9ZwrobDOd92m6H
tlpirK/NthJ0aPmkSVMFzu2jHO0zuuS4hkJBW8ZPhijaCSIIAKetS7wgBFqgLpL3
gGJKL35m5O7m5C7v2N5eICXKa/jtqchg00cVKLK1SF1FvFXhYEo=
=ritn
-----END PGP SIGNATURE-----

--=-5bjhfkCd3CuoQXipvuOM--
