From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/qib: Support creating qps with GFP_NOIO flag
Date: Tue, 19 Jan 2016 16:04:33 -0500
Message-ID: <569EA4E1.6020606@redhat.com>
References: <20160111175725.743.92967.stgit@phlsvslse11.ph.intel.com>
 <20160111181354.GA19166@obsidianresearch.com>
 <32E1700B9017364D9B60AED9960492BC259E9BB7@fmsmsx120.amr.corp.intel.com>
 <20160111182314.GB19260@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="PtW7Sh2Wdd4b8Px060hOvPVsxpAv14rX2"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160111182314.GB19260-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PtW7Sh2Wdd4b8Px060hOvPVsxpAv14rX2
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 01/11/2016 01:23 PM, Jason Gunthorpe wrote:
> On Mon, Jan 11, 2016 at 06:20:30PM +0000, Marciniszyn, Mike wrote:
>> The equivalent change has already been made for mlx4 in commit 40f2287=
bd and
>> Ib_verbs.h core include file in 09b93088d7.
>=20
> Okay, looks sane
>=20
> Jason
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--PtW7Sh2Wdd4b8Px060hOvPVsxpAv14rX2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWnqThAAoJELgmozMOVy/dJ24P/i4N1avME7sRmzdutGBwRcnZ
q6N0m4vNdpFk3lqiN7w0ldJmB06iSspgSPPGTKqGeeDVJlk1EUpCmP03eKuB5kKV
RpUw6Rl4fLuifLRY7dRunH0SBWmjGDQpFqbQxtue322pCkSzXq5KXs2hIwCbc/z2
9rEJPQjcKeRC9DTfUGgmSPKgcICYbbD9aDSHT8B0+zd0OtMOLxPal5wnSIJL/Exn
nyMm8UoA1NrWKAoazsT/H85raj0J7cvXoD9EUzKBriQoyY8bFbYmZ4MHBTO45hn6
4Rjq9lOa5r2PEZ2NkHax2je861qZX9J2iANZnpvejpbnk/RZxXyAvJdTJQO/SW/z
wHA5LhLWxsZaQyAY8No7C/uI0Cb7VlVSEsw5h1R8/isySZ+dL3l1zme4dL9Fk+i9
Ky1hnw3CAX4zojMnjCdUSidD9i7CVIfkQQ0/fst5KhABbK7NXsXbw4RvgYv9hD+K
iRr2ha3xoUerK1vkZUCba+bbG/aXUdoiTvyTSP2NbqwObIpdRTNP3cbGZ1PJUvXI
YQcSs6/5dNLhBpkAZhKyTMWAoGhKRItF3tXpXqKmMJTutxy08Baa09UqoD7PlVTS
sc80T6SQQwZ3KHtk0HB3+JvXQ6cM7G3l0poSFdeefbq+WjRZGiDB4HHr1IdN+zr6
Bsz1sWp/rS2O/hUZ4vu4
=E2aZ
-----END PGP SIGNATURE-----

--PtW7Sh2Wdd4b8Px060hOvPVsxpAv14rX2--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
