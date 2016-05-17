From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 5/5] IB/core: Integrate IB address resolution
 module into core
Date: Tue, 17 May 2016 10:52:41 -0400
Message-ID: <3dc71281-19eb-b42b-5090-be8350b2ca97@redhat.com>
References: <1462563928-29164-1-git-send-email-leon@kernel.org>
 <1462563928-29164-6-git-send-email-leon@kernel.org>
 <ea50f1d2-6f05-66f7-18f7-0a569fd9cea5@redhat.com>
 <VI1PR05MB1391AD099C536541E79A09F9D2760@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <db369e8e-7993-dfb8-d459-2c4f3d6e5b14@redhat.com>
 <20160516163048.GB4662@leon.nu>
 <298657b0-6e57-745b-5eb3-001984bffbc3@redhat.com>
 <20160516185434.GC4662@leon.nu>
 <82b21da8-8bec-a7ed-fc48-b7570c0aa4ce@redhat.com>
 <20160516210327.GB10945@obsidianresearch.com>
 <20160517054652.GA17101@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GqFLqJXBhE3rDRJB4E2P7PH7AdBQT3FWf"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160517054652.GA17101-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GqFLqJXBhE3rDRJB4E2P7PH7AdBQT3FWf
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/17/2016 01:46 AM, Christoph Hellwig wrote:
> On Mon, May 16, 2016 at 03:03:27PM -0600, Jason Gunthorpe wrote:
>> It is unfortunate that distro scripts have become such that they break=

>> if the kernel changes even something small like dependencies.
>=20
> What script exactly break, btw?  We had quite a few module merges /
> split in other subsystems I contribute to, and they've not been major
> issues.

The Red Hat SysV Init script for the RDMA subsystem on both RHEL and
Fedora (prior to the switch over to systemd for the RDMA init, which
means EL6 and earlier and I'm not sure when we switched in Fedora, but
I'm sure the old SysV init version of the Fedora rdma package is already
EOL) and the OFED SysV init script are the two for certain that I know of=
=2E

The RDMA subsystem is a bit unique in that the older SysV init scripts
allowed a reload operation, and that required removing all the modules
and then reinserting them.  The more modern systemd unit did away with
reload as an option and so it would work fine with the module name
change (although it would barf on other more important modules if they
changed names, primarily the end modules, such as ucma and friends).

I can't speak to Debian.  Among other issues, the only reason this would
even possibly be an issue for seemingly older OS releases is if the OS
in question still does either an RDMA stack update in a stable kernel
(like Red Hat does with all of its releases, including EL 6) or if the
older release gets newer kernels (like we do with Fedora, but our Fedora
releases short lived and so this isn't a problem there, but I have no
knowledge of Debian releases).

>=20
>> Another alternative is to move only the parts of ib_addr that touch
>> netlink into ib_core. Hopefully that doesn't create an empty module.
>=20
> Or just create a dummy ib_addr module IFF it really is an issue.

This is an awful lot of arguing over seemingly nothing.  These things
were true when I rejected the first patch:

1) It didn't solve any problem.  By code inspection, it wouldn't even
work to solve the problem that the commit message says it was supposed
to solve.
2) It was part of a series that was unrelated to the issue it was
supposed to help instead of part of the series that supposedly needed it.=

3) It needlessly broke user space scripts (for systems that get updated
to modern upstream, which, believe it or not, EL 6 still is included in
that...the EL 6.8 update that just went out includes an upstream 4.1
RDMA core subsystem).

If you want me to take the patch, then one of 1? and 2 need to be true:

1a) It needs to actually solve a problem in the patch itself (and the
git log should reflect the problem it solves).

1b) It can solve a problem for some other code in the same series as it.

2) The solution must at least be more elegant or appropriate than
alternative solutions that don't break user space.

In short, give me actual justification and I'll take it.  After all,
breaking older init scripts is a pretty minor user space break.  But I
need *some* justification.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--GqFLqJXBhE3rDRJB4E2P7PH7AdBQT3FWf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXOzA5AAoJELgmozMOVy/dRO0P/ieHjffkxX6948P6vRQBVG9m
qBd6+wRq4/pEssTjKw8EOyXgp93bBGk1Rj61g8dgScabUw2ZcpBI415AnbXPYsiM
OzOHEnJXIRi++tgK/NTtqJIOfeH/XQKPBo2Aumi4BHoM0O2204Q9VyVZyIDxgF//
kJkzmmwaaxUxEM59pSsaG0c5DG83TVDtdCKtouiULmdtmFNu944fRv11yCTF76qr
oNzYLisQQflIqoJoP4Jg9l0frVeU5NRB+pxUuAgeowmgUfwq08x+YJP0UduNoANQ
Of5okGku5rkVQTp/dBZ3hElTew4p/vPnMz9eWQVtG6ZvGoPQScTim5hY7+HdfP3h
/Jn2dd1Yg6iGG6s+pxmuZfneozq7sWslYM+Z1DxpyMTuFKh65PQHNEi/cakJQ8fP
abGziHyoUxtHuAWrGhLoTp9NDShgFdoYYsxUtgoDlVibSlJQdWCWTfrYP1Upndkx
YzwhHuvoBD/AMEP2G8a9PzR6EhcHUlJx4lHw9nGrMlDVGOtk6A3OWR0fhNB5/Jki
jEOSYz8fbpauH4jNysJ0WhHKqnWIbNwShOUJERmi5epSLUwGw1UoB88pN2+snA+y
xu4H9OXxhw4LjZcG7U9/fUNhbfv71JwMYeIb0Rp9Y9j880qdrKOzC0o1KALpPUcg
x9SXiLZWFhoq15TtNbr9
=KrPz
-----END PGP SIGNATURE-----

--GqFLqJXBhE3rDRJB4E2P7PH7AdBQT3FWf--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
