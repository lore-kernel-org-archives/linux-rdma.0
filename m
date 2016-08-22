From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v2] iser-target: fix error return code in
 isert_alloc_login_buf()
Date: Mon, 22 Aug 2016 14:11:11 -0400
Message-ID: <eea52d82-9470-680f-636e-c2dbb6fb02ec@redhat.com>
References: <1470404968-17339-1-git-send-email-weiyj.lk@gmail.com>
 <1470572438-12360-1-git-send-email-weiyj.lk@gmail.com>
 <20160807130806.GR27667@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wPOrF6q6J6UUXDWeBRwBHcG3oCtc0aIBn"
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160807130806.GR27667@leon.nu>
Sender: target-devel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Wei Yongjun <weiyj.lk@gmail.com>
Cc: Sagi Grimberg <sagi@grimberg.me>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wPOrF6q6J6UUXDWeBRwBHcG3oCtc0aIBn
Content-Type: multipart/mixed; boundary="eBoGOq6GAHMKlidPnnFmHoCoSVoxJuUlU"
From: Doug Ledford <dledford@redhat.com>
To: Leon Romanovsky <leon@kernel.org>, Wei Yongjun <weiyj.lk@gmail.com>
Cc: Sagi Grimberg <sagi@grimberg.me>, Sean Hefty <sean.hefty@intel.com>,
 Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
 target-devel@vger.kernel.org
Message-ID: <eea52d82-9470-680f-636e-c2dbb6fb02ec@redhat.com>
Subject: Re: [PATCH v2] iser-target: fix error return code in
 isert_alloc_login_buf()
References: <1470404968-17339-1-git-send-email-weiyj.lk@gmail.com>
 <1470572438-12360-1-git-send-email-weiyj.lk@gmail.com>
 <20160807130806.GR27667@leon.nu>
In-Reply-To: <20160807130806.GR27667@leon.nu>

--eBoGOq6GAHMKlidPnnFmHoCoSVoxJuUlU
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/7/2016 9:08 AM, Leon Romanovsky wrote:
> On Sun, Aug 07, 2016 at 12:20:38PM +0000, Wei Yongjun wrote:
>> Fix to return error code -ENOMEM from the alloc error handling
>> case instead of 0, as done elsewhere in this function.
>>
>> Signed-off-by: Wei Yongjun <weiyj.lk@gmail.com>
>> Acked-by: Sagi Grimberg <sagi@grimberg.me>
>> ---
>> v1 -> v2: fix with Leon's comment
>> ---
>>  drivers/infiniband/ulp/isert/ib_isert.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> Thanks,
> Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
>=20

Thanks, applied.

--=20
Doug Ledford <dledford@redhat.com>
    GPG Key ID: 0E572FDD


--eBoGOq6GAHMKlidPnnFmHoCoSVoxJuUlU--

--wPOrF6q6J6UUXDWeBRwBHcG3oCtc0aIBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXu0A/AAoJELgmozMOVy/dCKMP/it66iuRv89HC1YZmID1S3Cv
jdh/FuhKodg8xlDnYqQwRgeMTIW3SotbMZMoeOqQg5iiyfL9swvQOfndEfT1GcUL
+oaiNdc7IuCWIMVOqIySiTNHkEuUF5ECxctBlWw+qScBM3XatF92Jks9igbISfgx
znoKw3uzw/PZGs7wjHQvG4DXV6JW1lrpGFAPld7zr5dyCzngdtpR9/qyKUlMgzmI
PNutUXqe3gdUSLrZ7qsH3LbDmJSCIs0gEJ1iLPDFnBEJKaSJiqbn3TzBlgj9Kbav
jXAK74Daa6+YQTqzxYqkmX5ArqVbFHZNpN6fyibejGaqKc87mVMCxJQ/W22s2bab
IEeNxo5d0y2RHfJ5rsu3H2427e6o3huDj8TKjXYnNJMLTFol8C3zPTIwlTQUpr3S
i9qJpM4kBvF+Xt6Kx/HSHvNjfkuX75SPzD8YNBFSzM81jDHIikhhi4XZcufWvL4B
RnMGkxFBVtS8ruSEOccWCydtlA6xBL26VphJrvXFy6+245E09cqv8/lAN2Hc6ff+
oibhzfAPSaM7be2+ri843IA+WV5T8FyXxMuZu5JEu/WXZiofYWm6jekxBAbIAnOW
Is5eMnsfmBdSOx5d1pGemdYyTIBpi7AL/XW7nt87DPTVSa/Sd0qV28tAOyC4XZQ2
2SyyoOSfYMcr8eDe9b8W
=ohRE
-----END PGP SIGNATURE-----

--wPOrF6q6J6UUXDWeBRwBHcG3oCtc0aIBn--
