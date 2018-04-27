From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] RDMA/iwpm: fix memory leak on map_info
Date: Fri, 27 Apr 2018 14:23:33 -0400
Message-ID: <1524853413.11756.71.camel@redhat.com>
References: <20180425162404.28625-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-2v4Z2yp12xzBYoiqvhCn"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180425162404.28625-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-2v4Z2yp12xzBYoiqvhCn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-04-25 at 17:24 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>=20
> In the cases where iwpm_hash_bucket is NULL and where function
> get_mapinfo_hash_bucket returns NULL then the map_info is never added
> to hash_bucket_head and hence there is a leak of map_info. Fix this
> by nullifying hash_bucket_head and if that is null we know that
> that map_info was not added to hash_bucket_head and hence map_info
> should be free'd.
>=20
> Detected by CoverityScan, CID#1222481 ("Resource Leak")
>=20
> Fixes: 30dc5e63d6a5 ("RDMA/core: Add support for iWARP Port Mapper user s=
pace service")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Thanks, applied to for-rc.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-2v4Z2yp12xzBYoiqvhCn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlrjaqUACgkQuCajMw5X
L93FUg/+K2La2SGLcWy0/0smPST/DIwfhF9jqpZ9yYrgGzBtZD7ZtQR1XPvRQxrC
9pR5YOf6MwdEpTUKI9xb6utIQ53jG/fE7X0LvgpHFPQWNxm5KwVQ9eG7nfOBxFGr
74UvZoK76eBGnWTPCDxdNHFSh8NZ+071TFXvSrZcTGsOTacp5/az8Z5c1GYqKyXL
Jvz3eork1eS5vHa2YBQ3+3ynrnHqjRFU664KIXUyBXlJZEaCM+KTLRqyeqonPKPn
UREHFtzEjD5CX3IEunE5+BinI8fv/dCfzD+pKLrzELapcMr2BQA+1hVHQuPHm2t6
fECcHGVh0Qo2wNmQhJ+yGY01snkEO6pkNDSny1UJf+Wjt9zOp/PfV5RSTVnaqkXT
Va8uYhwx6e5TZC851YpC1D5sLdxqcadTzUTolGH81RC3a04Vlvpx7jJOrWBT4yZa
cYfeh/a/MPn/6uA520JqAjfdv7P37RXAmaHN6M+Hq+9NDUzY1e6mmwqTKj80BKJR
ardIfFBVjfpWRVUSocwul6zRllGuA+c+DxVeH3ezp/b87V92UVedCYa1SvpKqLYO
rozn76Py1cxNj0kOqocRKMDo9K8Zh7A519xr27bIR2xgPgfDlKb/fTc0pAdaG5Za
+d/WIfQSPhtNbtWHWlRoR2o3/hFWKld1xulDF+JrkG8fkrOHfLE=
=+d5T
-----END PGP SIGNATURE-----

--=-2v4Z2yp12xzBYoiqvhCn--
