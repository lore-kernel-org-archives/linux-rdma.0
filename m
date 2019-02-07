From: Doug Ledford <dledford@redhat.com>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Wed, 06 Feb 2019 20:57:22 -0500
Message-ID: <645c5e11b28ff10d354ae17ed3016bc895c9028b.camel@redhat.com>
References: <20190205175059.GB21617@iweiny-DESK2.sc.intel.com>
         <20190206095000.GA12006@quack2.suse.cz> <20190206173114.GB12227@ziepe.ca>
         <20190206175233.GN21860@bombadil.infradead.org>
         <47820c4d696aee41225854071ec73373a273fd4a.camel@redhat.com>
         <01000168c43d594c-7979fcf8-b9c1-4bda-b29a-500efe001d66-000000@email.amazonses.com>
         <20190206210356.GZ6173@dastard> <20190206220828.GJ12227@ziepe.ca>
         <0c868bc615a60c44d618fb0183fcbe0c418c7c83.camel@redhat.com>
         <CAPcyv4hqya1iKCfHJRXQJRD4qXZa3VjkoKGw6tEvtWNkKVbP+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-wpk6Y1FXNFOa7iPpHSPR"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4hqya1iKCfHJRXQJRD4qXZa3VjkoKGw6tEvtWNkKVbP+A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Dave Chinner <david@fromorbit.com>, Christopher Lameter <cl@linux.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Ira Weiny <ira.weiny@intel.com>, lsf-pc@lists.linux-foundation.org, linux-rdma <linux-rdma@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org


--=-wpk6Y1FXNFOa7iPpHSPR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-02-06 at 14:44 -0800, Dan Williams wrote:
> On Wed, Feb 6, 2019 at 2:25 PM Doug Ledford <dledford@redhat.com> wrote:
> > On Wed, 2019-02-06 at 15:08 -0700, Jason Gunthorpe wrote:
> > > On Thu, Feb 07, 2019 at 08:03:56AM +1100, Dave Chinner wrote:
> > > > On Wed, Feb 06, 2019 at 07:16:21PM +0000, Christopher Lameter wrote=
:
> > > > > On Wed, 6 Feb 2019, Doug Ledford wrote:
> > > > >=20
> > > > > > > Most of the cases we want revoke for are things like truncate=
().
> > > > > > > Shouldn't happen with a sane system, but we're trying to avoi=
d users
> > > > > > > doing awful things like being able to DMA to pages that are n=
ow part of
> > > > > > > a different file.
> > > > > >=20
> > > > > > Why is the solution revoke then?  Is there something besides tr=
uncate
> > > > > > that we have to worry about?  I ask because EBUSY is not curren=
tly
> > > > > > listed as a return value of truncate, so extending the API to i=
nclude
> > > > > > EBUSY to mean "this file has pinned pages that can not be freed=
" is not
> > > > > > (or should not be) totally out of the question.
> > > > > >=20
> > > > > > Admittedly, I'm coming in late to this conversation, but did I =
miss the
> > > > > > portion where that alternative was ruled out?
> > > > >=20
> > > > > Coming in late here too but isnt the only DAX case that we are co=
ncerned
> > > > > about where there was an mmap with the O_DAX option to do direct =
write
> > > > > though? If we only allow this use case then we may not have to wo=
rry about
> > > > > long term GUP because DAX mapped files will stay in the physical =
location
> > > > > regardless.
> > > >=20
> > > > No, that is not guaranteed. Soon as we have reflink support on XFS,
> > > > writes will physically move the data to a new physical location.
> > > > This is non-negotiatiable, and cannot be blocked forever by a gup
> > > > pin.
> > > >=20
> > > > IOWs, DAX on RDMA requires a) page fault capable hardware so that
> > > > the filesystem can move data physically on write access, and b)
> > > > revokable file leases so that the filesystem can kick userspace out
> > > > of the way when it needs to.
> > >=20
> > > Why do we need both? You want to have leases for normal CPU mmaps too=
?
> > >=20
> > > > Truncate is a red herring. It's definitely a case for revokable
> > > > leases, but it's the rare case rather than the one we actually care
> > > > about. We really care about making copy-on-write capable filesystem=
s like
> > > > XFS work with DAX (we've got people asking for it to be supported
> > > > yesterday!), and that means DAX+RDMA needs to work with storage tha=
t
> > > > can change physical location at any time.
> > >=20
> > > Then we must continue to ban longterm pin with DAX..
> > >=20
> > > Nobody is going to want to deploy a system where revoke can happen at
> > > any time and if you don't respond fast enough your system either lock=
s
> > > with some kind of FS meltdown or your process gets SIGKILL.
> > >=20
> > > I don't really see a reason to invest so much design work into
> > > something that isn't production worthy.
> > >=20
> > > It *almost* made sense with ftruncate, because you could architect to
> > > avoid ftruncate.. But just any FS op might reallocate? Naw.
> > >=20
> > > Dave, you said the FS is responsible to arbitrate access to the
> > > physical pages..
> > >=20
> > > Is it possible to have a filesystem for DAX that is more suited to
> > > this environment? Ie designed to not require block reallocation (no
> > > COW, no reflinks, different approach to ftruncate, etc)
> >=20
> > Can someone give me a real world scenario that someone is *actually*
> > asking for with this?
>=20
> I'll point to this example. At the 6:35 mark Kodi talks about the
> Oracle use case for DAX + RDMA.
>=20
> https://youtu.be/ywKPPIE8JfQ?t=3D395

Thanks for the link, I'll review the panel.

> Currently the only way to get this to work is to use ODP capable
> hardware, or Device-DAX. Device-DAX is a facility to map persistent
> memory statically through device-file. It's great for statically
> allocated use cases, but loses all the nice things (provisioning,
> permissions, naming) that a filesystem gives you. This debate is what
> to do about non-ODP capable hardware and Filesystem-DAX facility. The
> current answer is "no RDMA for you".
>=20
> > Are DAX users demanding xfs, or is it just the
> > filesystem of convenience?
>=20
> xfs is the only Linux filesystem that supports DAX and reflink.

Is it going to be clear from the link above why reflink + DAX + RDMA is
a good/desirable thing?

> > Do they need to stick with xfs?
>=20
> Can you clarify the motivation for that question?

I did a little googling and research before I asked that question.=20
According to the documentation, other FSes can work with DAX too (namely
ext2 and ext4).  The question was more or less pondering whether or not
ext2 or ext4 + RDMA + DAX would solve people's problems without the
issues that xfs brings.

>  This problem exists
> for any filesystem that implements an mmap that where the physical
> page backing the mapping is identical to the physical storage location
> for the file data. I don't see it as an xfs specific problem. Rather,
> xfs is taking the lead in this space because it has already deployed
> and demonstrated that leases work for the pnfs4 block-server case, so
> it seems logical to attempt to extend that case for non-ODP-RDMA.
>=20
> > Are they
> > really trying to do COW backed mappings for the RDMA targets?  Or do
> > they want a COW backed FS but are perfectly happy if the specific RDMA
> > targets are *not* COW and are statically allocated?
>=20
> I would expect the COW to be broken at registration time. Only ODP
> could possibly support reflink + RDMA. So I think this devolves the
> problem back to just the "what to do about truncate/punch-hole"
> problem in the specific case of non-ODP hardware combined with the
> Filesystem-DAX facility.

If that's the case, then we are back to EBUSY *could* work (despite the
objections made so far).

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-wpk6Y1FXNFOa7iPpHSPR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlxbkIIACgkQuCajMw5X
L91Evg//SBibnwgXwOjP007M0LvpMBWOIkoB9F+nU3UqhTEPFeMUlyf2En8+5NvK
+HW7QW68QNt5kEcEVnWDB0ixvcEiaO4ma/RQeTODtB5ARtiduHXa6IFo/ndVVuwf
t8DAqtLamKEaORgQ52Km2a1QXDgIDGZzs6LrJMTIsv9NBh8hFmjA2CdgX1xk79lL
gxqdZupI18nTyzj91VaKeYUhSJSB160w2xtkfosZlx58mlrKocEOm+7irNQsj5xj
ElIDIVhcToRUROd0Qy14KNnQZWsjFcU2CDNpojGiXbHzF5I1aAcnU2WPurEMXKJ8
rl090f8TA33e1OM1ZDwpMuieE/b5IESS31KTQ06gFdtGUll+Suyr+2Ra6grEi1s6
8bc6vv1Fd2Dq7+JAISo2T1O94nTK0E1YdpyxCsuPBr/Av2Np02tpByIxND+vz7Ay
Ut52Xy5R3unsEnONn/XxkYRsXt06EMaVnd1cTZUdnvTVoiMz7P/+bbK310NzYnDL
5LSL+9W7ee5UWOngJ2Rme2p9+lZE8zzEwMr84kwzHpPfLYFLswT2FZ7ICGF3B/K+
hdowtSBW9MngzFsEfj4zUrz+wfyRa/+WHszt/CorYRkrpV7u7KQvHssoGpMVyzut
1QHb+rmYsKFwlqNDJ/Pbe+dARCq/RYvZ3UXCW6AQ+fNJjipOMVw=
=0el0
-----END PGP SIGNATURE-----

--=-wpk6Y1FXNFOa7iPpHSPR--
