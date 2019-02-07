From: Doug Ledford <dledford@redhat.com>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Thu, 07 Feb 2019 10:56:35 -0500
Message-ID: <68c1e70d768922f6b1b4b833c433aff12a87336a.camel@redhat.com>
References: <20190205175059.GB21617@iweiny-DESK2.sc.intel.com>
         <20190206095000.GA12006@quack2.suse.cz> <20190206173114.GB12227@ziepe.ca>
         <20190206175233.GN21860@bombadil.infradead.org>
         <47820c4d696aee41225854071ec73373a273fd4a.camel@redhat.com>
         <01000168c43d594c-7979fcf8-b9c1-4bda-b29a-500efe001d66-000000@email.amazonses.com>
         <20190206210356.GZ6173@dastard> <20190206220828.GJ12227@ziepe.ca>
         <0c868bc615a60c44d618fb0183fcbe0c418c7c83.camel@redhat.com>
         <20190207035258.GD6173@dastard> <20190207052310.GA22726@ziepe.ca>
         <CC414509-F046-49E3-9D0C-F66FD488AC64@oracle.com>
         <6b260348-966a-bc95-162b-44ae8265cf03@talpey.com>
         <f000f699219a8f636dccfbe1fde3e17acdc674a4.camel@redhat.com>
         <ea175620-3dc2-c7f0-1590-02080216edf8@talpey.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-G+f9gGSQ2dAX1z2qQpRX"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ea175620-3dc2-c7f0-1590-02080216edf8@talpey.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tom Talpey <tom@talpey.com>, Chuck Lever <chuck.lever@oracle.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Dave Chinner <david@fromorbit.com>, Christopher Lameter <cl@linux.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Ira Weiny <ira.weiny@intel.com>, lsf-pc@lists.linux-foundation.org, linux-rdma <linux-rdma@vger.kernel.org>, linux-mm@kvack.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org


--=-G+f9gGSQ2dAX1z2qQpRX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2019-02-07 at 10:41 -0500, Tom Talpey wrote:
> On 2/7/2019 10:37 AM, Doug Ledford wrote:
> > On Thu, 2019-02-07 at 10:28 -0500, Tom Talpey wrote:
> > > On 2/7/2019 10:04 AM, Chuck Lever wrote:
> > > > > On Feb 7, 2019, at 12:23 AM, Jason Gunthorpe <jgg@ziepe.ca> wrote=
:
> > > > >=20
> > > > > On Thu, Feb 07, 2019 at 02:52:58PM +1100, Dave Chinner wrote:
> > > > >=20
> > > > > > Requiring ODP capable hardware and applications that control RD=
MA
> > > > > > access to use file leases and be able to cancel/recall client s=
ide
> > > > > > delegations (like NFS is already able to do!) seems like a pret=
ty
> > > > >=20
> > > > > So, what happens on NFS if the revoke takes too long?
> > > >=20
> > > > NFS distinguishes between "recall" and "revoke". Dave used "recall"
> > > > here, it means that the server recalls the client's delegation. If
> > > > the client doesn't respond, the server revokes the delegation
> > > > unilaterally and other users are allowed to proceed.
> > >=20
> > > The SMB3 protocol has a similar "lease break" mechanism, btw.
> > >=20
> > > SMB3 "push mode" has long-expected to allow DAX mapping of files
> > > only when an exclusive lease is held by the requesting client.
> > > The server may recall the lease if the DAX mapping needs to change.
> > >=20
> > > Once local (MMU) and remote (RDMA) mappings are dropped, the
> > > client may re-request that the server reestablish them. No
> > > connection or process is terminated, and no data is silently lost.
> >=20
> > Yeah, but you're referring to a situation where the communication agent
> > and the filesystem agent are one and the same and they work
> > cooperatively to resolve the issue.  With DAX under Linux, the
> > filesystem agent and the communication agent are separate, and right
> > now, to my knowledge, the filesystem agent doesn't tell the
> > communication agent about a broken lease, it want's to be able to do
> > things 100% transparently without any work on the communication agent's
> > part.  That works for ODP, but not for anything else.  If the filesyste=
m
> > notified the communication agent of the need to drop the MMU region and
> > rebuild it, the communication agent could communicate that to the remot=
e
> > host, and things would work.  But there's no POSIX message for "your
> > file is moving on media, redo your mmap".
>=20
> Indeed, the MMU notifier and the filesystem need to be integrated.

And right now, the method of sharing this across the network is:

persistent memory in machine
  local filesystem supporting a DAX mount
    custom application that knows how to mmap then rdma map files,
    and can manage the connection long term

The point being that every single method of sharing this stuff is a one
off custom application (Oracle just being one).  I'm not really all that
thrilled about the idea of writing the same mmap/rdma map/oob-management=
=20
code in every single app out there.  To me, this problem is screaming
for a more general purpose kernel solution, just like NVMe over Fabrics.
I'm thinking a clustered filesystem on top of a shared memory segment
between hosts is a much more natural fit.  Then applications just mmap
the files locally, and the kernel does the rest.

> I'm unmoved by the POSIX argument. This stuff didn't happen in 1990.
>=20
> Tom.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-G+f9gGSQ2dAX1z2qQpRX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlxcVTMACgkQuCajMw5X
L90Z/w//W7vouBfKgeHWd7q/6pHaRFPVjV7bGkmFwaHGvrbnQU3Fnfcj8Ts8ShZW
T4p4pJKmARkSPJqqR/hvH+Ln3SJCVf49tdhCbu7VaYkYk3iZJmWfdvF/oItdH7//
g2iIbUEYujIF5ZsAEss93Ma3SXP8Bvre0Vq15GX8Zu7oogXtj6zypek+3t9kfbt9
pQl63VTylLbxu4jAJz0VoLz5VpSe2uzR/piuQZpMp/of9t62a8OIQVRU1rC8O/rm
20A9RkrHRNRbUNjC4EqMfv+4t6zVL4sC/QUCUx07rOYwWVLXgqYUv9GqzCkdl/fA
3wJFMohDOW8V9dDg9LroWki2xdCCm22JVtDoQK/pMNhIONDxu5JqHbuSNKs/BcXc
3MgPFSJueLey5j9u4VTGlLwhLSPPBdeUyPTx1MRuqaZInXDRJxDupajQ96MY7vfb
Ckw6SXV1U51eXohXgGnXQRgt7K4JRS8SA6Iky7UyukxCevIIfvF8zD3HPv6wfho+
IPwaUsbfH88HJzjwpnN4KV9RDB6irg4GfNsS1IGbuXOw+0lNGeG5zlfKlfY1y/Yr
YARFzuESMq1ky2CRDntL7fbso2AWEhrrsvic1SycYvNTElztvwbXRQs1rDyvdaKZ
DsU00Sq9PuwzmEosfsm18bYkKHD2SMPEtPR+7k2obc3RRPTjWxc=
=LiqC
-----END PGP SIGNATURE-----

--=-G+f9gGSQ2dAX1z2qQpRX--
