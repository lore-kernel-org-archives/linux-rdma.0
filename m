From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/mlx5: Expose correct maximum number of CQE capacity
Date: Tue, 19 Jan 2016 15:54:41 -0500
Message-ID: <569EA291.5050409@redhat.com>
References: <1452751900-23680-1-git-send-email-leon@leon.nu>
 <56978129.7060707@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="CcWja5cgM57aPSWW2gIBqjLfq7ht4ivxu"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <56978129.7060707@dev.mellanox.co.il>
Sender: stable-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, Leon Romanovsky <leon@leon.nu>
Cc: linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CcWja5cgM57aPSWW2gIBqjLfq7ht4ivxu
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 01/14/2016 06:06 AM, Sagi Grimberg wrote:
>=20
>> From: Leon Romanovsky <leonro@mellanox.com>
>>
>> Maximum number of EQE capacity per CQ was mistakenly exposed
>> as CQE. Fix that.
>>
>=20
> Looks good,
>=20
> Reviewed-by: Sagi Grimberg <sagig@mellanox.com>

Applied, thanks.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--CcWja5cgM57aPSWW2gIBqjLfq7ht4ivxu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWnqKRAAoJELgmozMOVy/dEkcP/itSdFrP5tPgM4ysWcEYuZTl
tr8MkX/8QtK9dUqho3jD6TFTa1CgHeRSOY5cFPtrByvE0pqS6YzYfaspHgcilssq
tc7Qhay/d+rTOqDqL+cS6ZruTUhfI+0+1G0ZT8InOmpdAnLIVrRYQRIXvO5McZLq
ouUgA1B4Z4XyN/XTpJsof0fCzserrThHOPTqDLXT0wF6flIXbsypOrJei1B9Z2aG
mC81OVoPfNtRzn+JeDPsXh//kcvgkfJLA196eiviDsEkS7ldlUszKvX1IegTk9bW
vvo7vQMwBuDyvySZcZSYF/YzwLWvpi2m7grWTwNkhksfMlKthgf8EYXN+PEpUbFB
G0Ll/fP970qM57cLXW3nTgSHm2uO8XEhArSEgETSRmeOIhoudWcJUol6mFk8vVIY
9powRRVQM8vXkF8yOO8HPQGJpjrKSrZVKgOV4Hfa1HfaIIrlFELNZe20Z0RPcMtR
IDemqYnRDewfIgshUl2IB+kWw4dwFbxAydRbAhXqn6bCR4eIDYIsctCCAUMfTsw6
7+Id8WeAX+W34YTSLgjrqbRuu/AhujmW75Ml/7J1XvtgNHMUKw94a11gEcSzqPq9
nrpMchM1kowHKjcHBxIuwER2Tz7ULLluqFBr/K/jou/EvHpIU1POo0dIevOBXGD2
f5m2nf1QRtjwJKN89OQE
=E0NP
-----END PGP SIGNATURE-----

--CcWja5cgM57aPSWW2gIBqjLfq7ht4ivxu--
