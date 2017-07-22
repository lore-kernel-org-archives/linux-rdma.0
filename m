From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB: Convert msleep below 20ms to usleep_range
Date: Sat, 22 Jul 2017 13:06:56 -0400
Message-ID: <182b46cb-db3b-911e-f2a8-5b9a07e1d3a4@redhat.com>
References: <20170523082942.13314-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="W7bt6dK3RArcH5P0qiRv4WmiFs3aBjmAR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170523082942.13314-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--W7bt6dK3RArcH5P0qiRv4WmiFs3aBjmAR
Content-Type: multipart/mixed; boundary="jdotRBXWeI1opuD1qVoKtdrjP5pEwjoK0";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>,
 Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <182b46cb-db3b-911e-f2a8-5b9a07e1d3a4-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB: Convert msleep below 20ms to usleep_range
References: <20170523082942.13314-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
In-Reply-To: <20170523082942.13314-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--jdotRBXWeI1opuD1qVoKtdrjP5pEwjoK0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 5/23/2017 4:29 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> The msleep(1) may do not sleep 1 ms as expected
> and will sleep longer. The simple conversion from
> msleep to usleep_range between 1ms and 2ms can solve an
> issue.
>=20
> The full and comprehensive explanation can be found at [1] and [2].
>=20
> [1] https://lkml.org/lkml/2007/8/3/250
> [2] Documentation/timers/timers-howto.txt
>=20
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This has been accepted into 4.13-rc, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--jdotRBXWeI1opuD1qVoKtdrjP5pEwjoK0--

--W7bt6dK3RArcH5P0qiRv4WmiFs3aBjmAR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZc4YwAAoJELgmozMOVy/dIAkQAMM6JVKzSTivNjmChNkzl4s5
CuawrBAAiRtuKV1HHWXlmDSQO476GpbhVHxqflU95q/cBXWCNz79NDPG0s39u910
KF2KS99dCdHi6DM1Kf9f93ufe/iiEXV+7j2pOLzp3tD2/jIpKk0Ljuq+pMuS92e5
1TZ69Pbv2Jjy8SD+QE57RMnugoYHvsis6yW1OK8Umt4gOzWTSvHIpyhhSw/2QDfA
C5NcgAHYBFQl2edIoT3TJQx2pZotColKdGri6591s6aQnHJKIBqnIOknvMMknb1H
7bwsosjUPWIugowlPQyXk7g3ocf6VgDJZzHjJX8R60RpJgQ0Y0lS8NThtTa8QSHY
q9xiJYy387+if6nbLWElfWsTbCXuAiqClierx3bspV/lG6eJu1N9CxbRIjrZ2C1S
RRu0oPrEBfZBB+8dovmaWW7cFh5kTqmC6MxDpvO4TGzG+2jESdBRUIJkKkFg2Yr5
lfLOodMfIFtQrG+FWfAdDPQVR1RNr34Zq2JUtU2L0rWTYQ/I/HBzAGrCZHIzf/ir
rT+gZEOFSxV/ntvUwK3fDHo0fUnTGfuSW7feexnEi15A1GvCelUFWqsBY7hVbfgL
kyxrks5U19Q+jYSY7EmAoOJJeaZxeOgspOh3CwWJKsCYA97B1Y9MU4EWAbuWMOlE
JbH5NBHcwmd7YDgebj09
=GvKQ
-----END PGP SIGNATURE-----

--W7bt6dK3RArcH5P0qiRv4WmiFs3aBjmAR--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
