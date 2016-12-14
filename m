From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 1/1] infiniband: hw: mlx4: fix improper return value
Date: Wed, 14 Dec 2016 14:35:44 -0500
Message-ID: <93e36d99-86b5-03b0-3226-2993c428e155@redhat.com>
References: <1480833938-6284-1-git-send-email-bianpan201603@163.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="m1Oui1a7Tix9JXTr6v5mJ9jX8rxFWhls3"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1480833938-6284-1-git-send-email-bianpan201603@163.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Pan Bian <bianpan201603@163.com>, Leon Romanovsky <leon@kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--m1Oui1a7Tix9JXTr6v5mJ9jX8rxFWhls3
Content-Type: multipart/mixed; boundary="0I4sFi7Lo6LNn4gSWm4Rg1Fd4Gv5OJHnj";
 protected-headers="v1"
From: Doug Ledford <dledford@redhat.com>
To: Pan Bian <bianpan201603@163.com>, Leon Romanovsky <leon@kernel.org>,
 Yishai Hadas <yishaih@mellanox.com>, Sean Hefty <sean.hefty@intel.com>,
 Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
Message-ID: <93e36d99-86b5-03b0-3226-2993c428e155@redhat.com>
Subject: Re: [PATCH 1/1] infiniband: hw: mlx4: fix improper return value
References: <1480833938-6284-1-git-send-email-bianpan201603@163.com>
In-Reply-To: <1480833938-6284-1-git-send-email-bianpan201603@163.com>

--0I4sFi7Lo6LNn4gSWm4Rg1Fd4Gv5OJHnj
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/4/2016 1:45 AM, Pan Bian wrote:
> From: Pan Bian <bianpan2016@163.com>
>=20
> If uhw->inlen is non-zero, the value of variable err is 0 if the copy
> succeeds. Then, if kzalloc() or kmalloc() returns a NULL pointer, it
> will return 0 to the callers. As a result, the callers cannot detect th=
e
> errors. This patch fixes the bug, assign "-ENOMEM" to err before the
> NULL pointer checks, and remove the initialization of err at the
> beginning.
>=20
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=3D189031
> Signed-off-by: Pan Bian <bianpan2016@163.com>

Thanks, applied.

--=20
Doug Ledford <dledford@redhat.com>
    GPG Key ID: 0E572FDD


--0I4sFi7Lo6LNn4gSWm4Rg1Fd4Gv5OJHnj--

--m1Oui1a7Tix9JXTr6v5mJ9jX8rxFWhls3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYUZ8QAAoJELgmozMOVy/dlT0QAJFWxNLZ/m/+u7ltfxyRUQXV
COhg94To0jqinqD66LUiUE593wd/x1f9RYRph1BrrFeO5Ux6YD13carcfbG4AhZd
9J0bFgj9iUedIgoQCqDCDx4fucLN1g11584ueMi+8zOjX6UcShnmNd9APfdFY+JI
4wRVNj8c1y3fVNUprbMBEf2BM/YGW58mS1/9gr0dV9GxNu0G50cPrca9LLT2ZsVx
91+Dx69kyM2dCRIDnnRrhuehrn7ghXrW30Hh5NTFLXY6HOzB2UBiU9D0M0HZ4h3p
HKFwimAzhBj9SsJlauWiEKGE+W+iXO5vAFXVO5HqGH4fGGscfcPuoGlymJ5vyR0K
2JA/gtimT5qwGEWHpeB4Qwajx+eYlxqpCmdua7nXz1XqWDaCt1aHpxzi09D1yItL
EHVdcVVV2XSfwbJeD1qzu5INiDLiaI9iMVusxu8Z3vdsIBmj/MSg1ECJ6N3xM2rB
YiOHik/jCDU8J84uDZvQuj3oiWChtmKkwdwIfRV0sHS2YCSpo3iVhfbHtNioOzfw
33v4zMcmV8G9MPBefodfy8EhHi6ampGiAHuxJMXF6V8hsmhrmx5D+vDiNsMMQbet
oRoxNlRfsgq1TVriqlfhE5aKJW82s5iqsmEVgZeonSZMm3kay+NioLjGKobaVuly
daewPcNTD8zbpxDqMlNG
=oG58
-----END PGP SIGNATURE-----

--m1Oui1a7Tix9JXTr6v5mJ9jX8rxFWhls3--
