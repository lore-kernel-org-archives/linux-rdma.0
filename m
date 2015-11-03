From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: shrink struct ib_send_wr V4
Date: Mon, 2 Nov 2015 19:52:05 -0500
Message-ID: <56380535.5040101@redhat.com>
References: <1442157215-22341-1-git-send-email-hch@lst.de>
 <5631839B.30300@redhat.com> <56318B37.20207@redhat.com>
 <20151029115114.GA18466@lst.de> <56360148.8060608@mellanox.com>
 <20151101180609.GC13943@kroah.com> <5637EFC8.4010300@redhat.com>
 <20151102233726.GA18251@kroah.com> <5637F97C.5090205@redhat.com>
 <20151103001845.GA24206@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FH6lex5ao87XCfmtoUfJmDC5IgtesHT4P"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151103001845.GA24206-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FH6lex5ao87XCfmtoUfJmDC5IgtesHT4P
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 11/02/2015 07:18 PM, Jason Gunthorpe wrote:
> On Mon, Nov 02, 2015 at 07:02:04PM -0500, Doug Ledford wrote:
>=20
>> Because they are *scheduled* for removal.  If I simply didn't care if
>> they went away, then I wouldn't screw around with deprecating them or
>> tagging them to be removed, I'd just delete them.  Breaking them befor=
e
>> the scheduled removal time defeats that entire purpose.
>=20
> You don't see in the compiles, but IIRC ipath is unusable after the
> PAT rework.

It shouldn't be.  I reviewed those changes and they looked right (given
the limitations).  All you needed was to boot with nopat on the kernel
command line to get the old kernel behavior and it would continue to
work as before, and it would print out a message telling you to do so if
you hadn't already.

> We've also been ripping out the ULP side of things that would let
> amso1100/ehca work in any meningful way with the kernel ULPs.

For amso1100, kernel ULPs has never been its target.  Didn't we only
recently got any support for iWARP in iSER?  And we never had it or will
have it in IPoIB or SRP/SRPT.  That only leaves RDS and NFSoRDMA.
RDS/RDMA upstream has been a mess for a long time.  That only leaves
NFSoRDMA.  So it's fair to say amso1100 has been primarily a user space
RDMA device, not a kernel ULP device.

For ehca, that's another matter entirely.  I gave up trying to work with
that driver a long time ago.  If IBM tells me something is broke, I'll
review their patches to fix it, but as I have no working hardware, and
only every had hardware I couldn't get working in our environment, there
isn't much I can do about it.

> The reason I lobbied to get rid of them is specifically because they
> don't work and maintaining them (ie the driver and the single-use ULP
> codepath side) is a huge pain. Keeping them around and keeping them
> compiling defeats the entire point. Just delete them, we don't need to
> wait for 4.6.

That's not true.  User space continues to work, and amso1100 shouldn't
be greatly negatively impacted by recent changes.  Nor should ipath.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--FH6lex5ao87XCfmtoUfJmDC5IgtesHT4P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWOAU1AAoJELgmozMOVy/dT+cP/1GxQp601305oRG1pbGrRwKb
fYunyh1zyyK3baxvXU1YJENtQ6myxsFacaSTXHpBoAvWsH3zAF+yHJD1/dn+Q+kV
f5Rttb25kYdtoKnDwaSia8q723oiGiDb3757W+Z6Kllf5aRomEla6XyHat7IaqQK
sVrsXzWHW4bHMkAcwEOXlKbqWlVdTUAj6chU1KE6ClvZH+1ZsrIaSsgsfZXYUME4
helW8EeIVCy4ng4pa8+btqQ+S6bsiCq7Rq22Cia//Wb3NZBam+ndLZUWFFPeqLBb
vHXcScK1B6dipeSgBrvKnKqpI4sPzcL2Ghc0dbmtau8CDXUB38kESmCSuo+yiRQd
ok+hua25js44BlCQD5Lc5ZPF95i/36/xqLqSrqBKV3C/TzymIM3HRCZHlCJQsGFS
a8dZIiVJTII7G2GauDc61PK5Mljom24GwDgF8jqUyx4s4kwNsPd1DzFDDEgjAeoz
1YUDVbd5+3FxmsPq/kUr9f0sNQHWXq0EY4A5jhJOAOTmGJBTsmFCkGDUL7/eqqcj
LYDF4Bzq4bnB/wqbrpypF53NKs0eunbl5zI3IK/EiqUE1XkgaqkXBjE/AxcmoDZz
UCsW3bvZEgqvsYGG8C3Rbci+kSxat1eCcAGN8lXK4O7GuoPjoCYfCQEZpFyx8bTI
hdLQMVEO9v+AE+vcy6NZ
=MGd8
-----END PGP SIGNATURE-----

--FH6lex5ao87XCfmtoUfJmDC5IgtesHT4P--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
