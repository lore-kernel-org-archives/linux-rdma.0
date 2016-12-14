From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/isert: do not ignore errors in dma_map_single()
Date: Wed, 14 Dec 2016 12:51:40 -0500
Message-ID: <76723a14-43dd-b25a-c863-7f95cfc129e6@redhat.com>
References: <1477087281-26275-1-git-send-email-khoroshilov@ispras.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LJiQlCBamA5pTUNRvMSIibKmQMkBfTfT2"
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1477087281-26275-1-git-send-email-khoroshilov@ispras.ru>
Sender: target-devel-owner@vger.kernel.org
To: Alexey Khoroshilov <khoroshilov@ispras.ru>, Sagi Grimberg <sagi@grimberg.me>
Cc: Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LJiQlCBamA5pTUNRvMSIibKmQMkBfTfT2
Content-Type: multipart/mixed; boundary="HvDqPFBI4q8e25RimPaR8qUeK804GsUNm";
 protected-headers="v1"
From: Doug Ledford <dledford@redhat.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>,
 Sagi Grimberg <sagi@grimberg.me>
Cc: Sean Hefty <sean.hefty@intel.com>,
 Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
 target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 ldv-project@linuxtesting.org
Message-ID: <76723a14-43dd-b25a-c863-7f95cfc129e6@redhat.com>
Subject: Re: [PATCH] IB/isert: do not ignore errors in dma_map_single()
References: <1477087281-26275-1-git-send-email-khoroshilov@ispras.ru>
In-Reply-To: <1477087281-26275-1-git-send-email-khoroshilov@ispras.ru>

--HvDqPFBI4q8e25RimPaR8qUeK804GsUNm
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/21/2016 6:01 PM, Alexey Khoroshilov wrote:
> There are several places, where errors in dma_map_single() are
> ignored. The patch fixes them.
>=20
> Found by Linux Driver Verification project (linuxtesting.org).
>=20
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Thanks, applied.

--=20
Doug Ledford <dledford@redhat.com>
    GPG Key ID: 0E572FDD


--HvDqPFBI4q8e25RimPaR8qUeK804GsUNm--

--LJiQlCBamA5pTUNRvMSIibKmQMkBfTfT2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYUYasAAoJELgmozMOVy/dHDgP/09O0UKlpKYApql8vW2lBwU7
cTXc20QFSfcTBheEN8AIAWleKPl0dIkAfSt9u9lMUJXW69iZpHB+pmDaI9K8xirD
B13LKkf23jPWp7AL9Jpqjr9KHeymIt9VszF/bJURi3ctq12Qt5Q1mtJjKkJoCN7r
PxMG1KLXAlMoZFmC/S3BZTCjKmFZYggpYH8XXZOw6tMGinHwIhz6OlI6ZGNQIUN8
14tVG7NXV9ySWl5+Gq+kbqHTHjmM+W4fpEMcv+440COfHU28lIzUZn9rIVY9mH28
VPH3rtIey+x7YJQitQy+apKze6uvdelxYP1BKeVPE958kGz2uUEXa8/HWDp6SH0i
BEBu8WxSxTeQKGA9QyIVNmj/Z77Rr/cnBT2RjVjz9T0AA78i0cR13aqRtK+1ftEY
FGvzwBSmjI6UBOnDUM2vi3V+EiWB+ckn2D7AAox//rYd302sSbnIJPk2SjnZsLPc
Kcx5ZQBGQ8vl+8EeLnmvfQ760FDMMMKDo3jnoiMBrtRf1MYIbKB0Qqbw63b94LrO
KWuuzNZpOlTPOD3PWbIm21B4yhWzhmIlr8MUiCT7GNOeFGTmUNcISSVLEpAOyIJ7
xlAnda3uNfzuUH7a7XHi9veDy8SkqOnWfcRJ8Pcl6tgnjuqpuQg3hjPKDqylSjoP
gs27dxn2SVmkGpDuW9M7
=eMyj
-----END PGP SIGNATURE-----

--LJiQlCBamA5pTUNRvMSIibKmQMkBfTfT2--
