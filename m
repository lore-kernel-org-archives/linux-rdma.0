From: Doug Ledford <dledford@redhat.com>
Subject: Re: [patch] IB/rxe: Remove unneeded cast in rxe_srq_from_attr()
Date: Mon, 12 Dec 2016 16:37:14 -0500
Message-ID: <ecfe27c3-61b0-1ec1-9bdd-cbbd12bd09e9@redhat.com>
References: <20161117110005.GB32143@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mBnQGkvDbt5sIvDWSi7kF2voijlKsAden"
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20161117110005.GB32143@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Moni Shoua <monis@mellanox.com>
Cc: Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mBnQGkvDbt5sIvDWSi7kF2voijlKsAden
Content-Type: multipart/mixed; boundary="aEvL2T8ax3KbFEPCJ0CKeaND4a0mPpqr0";
 protected-headers="v1"
From: Doug Ledford <dledford@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>, Moni Shoua <monis@mellanox.com>
Cc: Sean Hefty <sean.hefty@intel.com>,
 Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
 kernel-janitors@vger.kernel.org
Message-ID: <ecfe27c3-61b0-1ec1-9bdd-cbbd12bd09e9@redhat.com>
Subject: Re: [patch] IB/rxe: Remove unneeded cast in rxe_srq_from_attr()
References: <20161117110005.GB32143@mwanda>
In-Reply-To: <20161117110005.GB32143@mwanda>

--aEvL2T8ax3KbFEPCJ0CKeaND4a0mPpqr0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 11/17/2016 6:00 AM, Dan Carpenter wrote:
> It makes me nervous when we cast pointer parameters.  I would estimate
> that around 50% of the time, it indicates a bug.  Here the cast is not
> needed becaue u32 and and unsigned int are the same thing.  Removing th=
e
> cast makes the code more robust and future proof in case any of the
> types change.
>=20
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks, applied.

--=20
Doug Ledford <dledford@redhat.com>
    GPG Key ID: 0E572FDD


--aEvL2T8ax3KbFEPCJ0CKeaND4a0mPpqr0--

--mBnQGkvDbt5sIvDWSi7kF2voijlKsAden
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYTxiKAAoJELgmozMOVy/dRn4QALMFMpPEaWKSEFfQQ4xdZYzZ
zvjrcbqPbVU3hBTnM083q7KVEz7nZ65SJCiRoXIHxlCR03FbEWWGC1LLVE9JzrnN
Zlpq+hlpdzbnwMF5ociquHVaJcK2Ym0HLG3oLzvhU8wik4Md2twLS+FNv17O7I/F
EKPDPVAuSYMttdpCDbBbfUDv3dd6cGOgSvPZ5vT2Fyq6WZMikInq+PKFjwepjzSV
bDEJlnWL7VfjseMUeTKa86q1lKxp3e5Rh3R7/HduEj0ZfS3/9oJYpLaxswI+rP6b
zVz406DKyHHwck4qzm04oJKIc4xauEDUaATscPp4e90Iy01/G5GGByNXRDeaFBJK
OCJtJnYYz9JYJZ7+09fMwL77E2kBArAN2eE2PMHHqj+eHpKLFJG4TBWwsqREqxK2
bBkYcpeDgaTLxEE09zg20v2iLY6mkqaW0ET41LtP7elbWGrTzIXHPYe8sGdH7HWL
e6CCWzTaL6Gw+DFWf2FvXgB+VYTgkThOlBImMTJ8am6mwKPCxYBduDqBwW9Pb/zs
HxNggu8OQkxLH94JHD/PYda1QUvRmmV1gqUTAxlekUR9zPYTyhQDPeFHn23oaoEQ
/1mJKmG/fRqXZf8+wrUDgOadhQChmyWVb6tJTvraiPrpx84BqshW7U4tpV9HWFRM
4N+ViPDv6K6nWLzg+wcx
=l2az
-----END PGP SIGNATURE-----

--mBnQGkvDbt5sIvDWSi7kF2voijlKsAden--
