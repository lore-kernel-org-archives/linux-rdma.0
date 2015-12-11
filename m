From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: device attr cleanup (was: Handle mlx4 max_sge_rd correctly)
Date: Fri, 11 Dec 2015 12:10:21 -0500
Message-ID: <566B037D.2040009@redhat.com>
References: <CAJ3xEMj2EOxX1CiA93MPOsM-FdU9ijcWCYm9tObbkLqqja0PoA@mail.gmail.com>
 <566753E3.9060301@redhat.com>
 <CAJ3xEMhaEnv9He7N5q8fFsRzy_j27wdE6KWSFF39UzA680udwA@mail.gmail.com>
 <20151208225940.GB27609@obsidianresearch.com>
 <CAJ3xEMiEYgsxiL6zR-Dia3Rxwriye1WHcadTmUjU7zV=ide1LA@mail.gmail.com>
 <20151209184448.GC4522@infradead.org> <5669BA8E.30200@redhat.com>
 <20151210232956.GA26009@infradead.org> <566A5792.9080102@redhat.com>
 <20151211061433.GB16513@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lSWoeU0bl18WAB9hTkVloOaN3pRsjEj5k"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151211061433.GB16513-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lSWoeU0bl18WAB9hTkVloOaN3pRsjEj5k
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/11/2015 01:14 AM, Jason Gunthorpe wrote:
> On Thu, Dec 10, 2015 at 11:56:50PM -0500, Doug Ledford wrote:
>=20
>> Looking at struct netdevice, it has the sort of organization I would
>> call reasonable.  Things like struct tx_stats is a struct, even though=

>> it's embedded in the parent struct and not a pointer and there is
>> exactly and only one copy, so it could be flat.
>=20
> struct net_device_stats exists because it is used in many more places
> that just in struct net_device, so this is a code sharing thing.

It doubles well as decent organization.

>> something I would call well organized.  And speaking of that, in struc=
t
>> netdevice, all of the various ops elements are handled as structs,
>=20
> .. and 'struct net_device_ops' is used extensively.
>=20
> Whereas once we get rid of the query call ib_device_attr has no second
> user.
>=20
>> including the base netdevice ops, whereas struct ib_device puts the ba=
se
>> ops flat in the struct.  So if we wanted to be more like struct
>> netdevice, we would move the base ops out of struct ib_device.
>=20
> It would make the drivers a bit nicer if they initialized an ib_ops
> structure like netdev does instead of in code, but performance wise
> this is probably better, especially if we sorted the struct members
> sanely..

You could still create a struct and embed the struct in ibdev and it
would make reading ibdev *much* nicer while preserving this performance
benefit (which is probably very minor, if at all, and very well might
become a performance penalty if you have more than one ibdev in heavy
use on the system).  The huge list of ops in the middle of the struct is
a gigantic eyesore.

>> out like this.  An ib_device can be multi-port, and each port can be a=

>> different RDMA device type.
>=20
> I thought we figured out that wasn't actually allowed today when
> working on the caps rework?

We figured out that the core code couldn't currently do something like
iWARP and RoCE on the same port even if registered as two different
ports.  We do IB/RoCE on different ports because they both appear as an
IB device, but I think the ongoing namespace work shows that they are
diverging more over time and eventually may not work in this fashion
nearly as cleanly as they did to start with.

I also commented that it was entirely understandable for a person to
want to do the whole iWARP/RoCE on one port via two registrations thing
once both the soft-RoCE and soft-iWARP drivers were in the kernel.  As
such, I'd like to see us not make achieving this goal harder in case we
decide to pursue it later.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--lSWoeU0bl18WAB9hTkVloOaN3pRsjEj5k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWawN+AAoJELgmozMOVy/d1a0P/RUEH5GjAlypvUPudA6sjGt3
zRbGGpcDm6wQjJPrKg9UcEjvCCmt7WqK9QU9xMEfB0e0WjybKn2plx4p+Vt4Figx
/E2wB+8FTIrriskpOac/CjEOc6tk74CHc91ApuVJjT5k27peGjxl4kWcedmb36jQ
k3GF33zE2p+c49fg/enPTVtruMx3uu6m91FhklMJLs/y8rpG3W73ZOFPL+NvtVpH
0vikOmnwk+dMmTsRL5jqaa2ZUvFZDDVic67z9YVnxFNa+vQfcZxyqxaFLfNCZdJs
v9Vl1s/AySvBp1N+NMS6EqXFaVow9m24ry0U2Ol6D9oywOo2KMQ10XhKRAbjnG4H
90HvZVJF0aUg+s3ocG+lg+NTKI92Va82SCABvTk3pOfRltNiBuTk9jnjc+s5ap+H
NnT4ghYseA3qqWeLz2qFk/getwAKtQhNWxDkayb6p47vzoaWu4dx2ROtqFankO0N
S86e2lutV2VdTWz9kHIlON6RnV1qonPX7QsYxYbZ6ruIZf7e4YMPYJ2mBMPCBcAa
kwlJeyc1F49HDFe/Ll8vaz1MJS3RJIOgNG3yu+HMwnJINS0A+kUJ0O/g625bMNFO
WWi4zWp2FVjtXn7aoBX69xzFMwo9Y+iNuVd6a4HVJ0j8q8Hhfy+8n2xD/TRVJutD
zh3eGV0yZp2jnv1V56px
=2NhO
-----END PGP SIGNATURE-----

--lSWoeU0bl18WAB9hTkVloOaN3pRsjEj5k--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
