From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 00/17] Fixes, flattening and packaging
Date: Fri, 7 Oct 2016 13:07:44 -0400
Message-ID: <ed5eadc6-db9b-8238-9ec2-9ba1cf7dfca2@redhat.com>
References: <1475787103-13283-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="owT0fPMijlsO1NrwbWDtidkqWchqxTpjD"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475787103-13283-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--owT0fPMijlsO1NrwbWDtidkqWchqxTpjD
Content-Type: multipart/mixed; boundary="gRhFdMFNkbNWeTfJvOr5vKAlak83C8v7m";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
 linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <ed5eadc6-db9b-8238-9ec2-9ba1cf7dfca2-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 00/17] Fixes, flattening and packaging
References: <1475787103-13283-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
In-Reply-To: <1475787103-13283-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

--gRhFdMFNkbNWeTfJvOr5vKAlak83C8v7m
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/6/2016 4:51 PM, Jason Gunthorpe wrote:
> This is mostly a grab bag of the finished work left in my tree:
>=20
>  - Missed items for the last merge
>  - Fix a few mistakes in the earlier patches and build system
>  - Final rename of directories to make the tree shallower (eg eliminate=
 src/, add providers/)
>  - RPM and DEB packaging
>=20
> See
>=20
> https://github.com/linux-rdma/rdma-core/pull/13
>=20
> Jason Gunthorpe (17):
>   Update Intel lists in MAINTAINERS
>   Update COPYING to reflect recent cxgb4 merge
>   Update comment in cxbg* drivers
>   Remove missed auto* related files
>   rdmacm: Drop SONAME in rspreload
>   umad: Use symlinks instead of a NROFF .so directive
>   verbs: Remove -fno-strict-aliasing
>   Move providers into providers/
>   iwpmd: Flatten iwpmd/src into iwpmd/
>   srp_deamon: Flatten srp_daemon/src,etc into srp_daemon/
>   ibcm: Flatten libibcm/src,include into libibcm/
>   umad: Flatten libibumad/src,include into libibumad/
>   verbs: Flatten libibverbs/src,include into libibverbs/
>   rdmacm: Flatten librdmacm/src,include into librdmacm/
>   Combined RPM Spec file
>   srp_daemon: Add the debian initscripts as an option
>   Debian Packaging

Thanks Jason, series (including the addition of adding Steve Wise to the
Maintainers file for iwpmd) applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--gRhFdMFNkbNWeTfJvOr5vKAlak83C8v7m--

--owT0fPMijlsO1NrwbWDtidkqWchqxTpjD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX99ZmAAoJELgmozMOVy/dn9gP/iz3uiRuq3O2vT8T4gjE5q7l
mDbH+f4VojNWo2oRjozamd6IyI5nxejFw6hjpAtjbdQ09Msl4tylxcj/yYq0+7L+
WoA0m2IAVWDVeoJF5bSCB0aZ4505socx9vJ+RpFR8guk1EPogo0Xt2/CwWRRFoaa
zGvPJQDrfk8/nkZg6eTLnF0TxyhbJtUL+8doCQKeBlKokqdks2wktQPn+7kDbOEb
XKITf5lEQBSZRo8wrr3iS9UFuKBK1cSgwt1G3otWiZU2lQ2ytgKuqLIBJaTVn/rF
rAlykEeGzOjwtmMG/+VvOygfG2PCjtxdR5wKgzKnkqs654W1jKGqf6ony/i9XPYA
gH+0olRX04bek5DNKHw3aiXmZUHCBv4fjiGBUMD7hnROKBru5ZsRUek1PflwrqAO
u4RqHr/TW79VIocFTcLswzPC6usbAcmKShUfroXc0jofgMrrRYdzk+RjJvwfISJj
IaNlj8gwNjNEOYNEskfzP598w8NRT1RisxW6pYaamDT5ha6FJoJIacmmUX10qi4U
RQGTuiPGVkKr9Dd/wT0YbSU+LiNKdiM89UNQQv7//UcT/zmkHtimzd16Lft8iqgu
M3vF19QTz5oeHSVFlMR2O6ayZiyZItPDY95SxFufuyKDYaccpmQ6+qx3V2IjYOKF
e3VOqhDfh9mU6jc4Bpdd
=E6Xa
-----END PGP SIGNATURE-----

--owT0fPMijlsO1NrwbWDtidkqWchqxTpjD--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
