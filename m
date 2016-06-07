From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 2/2] IB/sysfs: fix memory leak
Date: Tue, 7 Jun 2016 07:50:01 -0400
Message-ID: <f0d31d00-4ec5-efac-408a-d539dd7bffac@redhat.com>
References: <1465157636-10120-1-git-send-email-sudipm.mukherjee@gmail.com>
 <1465157636-10120-2-git-send-email-sudipm.mukherjee@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MRogIhTehVmamjbeA70DLhF5kKnChnT6A"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1465157636-10120-2-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MRogIhTehVmamjbeA70DLhF5kKnChnT6A
Content-Type: multipart/mixed; boundary="1OFrPxdOObQiWB9KDCKVwx0abaXNAoCVU"
From: Doug Ledford <dledford@redhat.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
 Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Message-ID: <f0d31d00-4ec5-efac-408a-d539dd7bffac@redhat.com>
Subject: Re: [PATCH 2/2] IB/sysfs: fix memory leak
References: <1465157636-10120-1-git-send-email-sudipm.mukherjee@gmail.com>
 <1465157636-10120-2-git-send-email-sudipm.mukherjee@gmail.com>
In-Reply-To: <1465157636-10120-2-git-send-email-sudipm.mukherjee@gmail.com>

--1OFrPxdOObQiWB9KDCKVwx0abaXNAoCVU
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 6/5/2016 4:13 PM, Sudip Mukherjee wrote:
> If the allocation of hsag fails we were just returning but stats was
> not released.
>=20
> Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
> ---
>  drivers/infiniband/core/sysfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/=
sysfs.c
> index fcf6f9c..8d8732c 100644
> --- a/drivers/infiniband/core/sysfs.c
> +++ b/drivers/infiniband/core/sysfs.c
> @@ -906,7 +906,7 @@ static void setup_hw_stats(struct ib_device *device=
, struct ib_port *port,
>  		       sizeof(void *) * (stats->num_counters + 1),
>  		       GFP_KERNEL);
>  	if (!hsag)
> -		return;
> +		goto err;
> =20
>  	ret =3D device->get_hw_stats(device, stats, port_num,
>  				   stats->num_counters);
>=20

This issue was previously fixed by another patch and is no longer
applicable.


--1OFrPxdOObQiWB9KDCKVwx0abaXNAoCVU--

--MRogIhTehVmamjbeA70DLhF5kKnChnT6A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXVrTpAAoJELgmozMOVy/duikQAIfeQQEAjmJsTv3j7KhQdWrK
yKqHM6kuWTimyuM8h684Ukffz+Ui9H7t4bQqxKmliXkgAb17M1/uWe6vLYK2jr1d
m2xS2/J6zZItONY1GfjYM3ntX3JBL/DRy3dt0NCf75q7gALtLqw8N7MpBVy57pJO
Rl32IWCvPYOilhwHCwhZMzmBIIue2M0683VMyyOIpguzo8g2PDP2SEWrXlFQu/b/
R0QojqI+QkwwcFKYEgmGMlXcP0iOj5NXdp3KicJQwIzMSUSiHpva1NWaTqTTveMk
99q+whRcP8Sbi31tjyTrg2JQ6mSNkJo8EoNBYwwfPU4CyQzbcl9D6jsrJm5s8kNH
UyoE/Hi4baqj4CRWEhqa2RA5WDSH6aPffRNiZQR0bemVPUp6IK4Kn1ghxUowQb7t
QJw/kzxBE+RhKrAMsC1z73GnXhqO8mwJWTPDX60Z6ZIN7D3PzMOc8uf6J2CAlXOQ
klRnZvDG8JvZ4FrDRBLJ1uNGAdO0Ogr0JXuJAEZKi3ZzCt0Rr9tFbiftXQtPT+9/
GbMT0bbDJimWPVaAa11RS2HD87WLCcLAvKOIcPM5OwWeuwMWAUhqhaWyk25MfiuR
8zY46U38v48yqS3jW9kxB5PCxha3Y2WqL1MTLzMA2kklpMSWrpT2tD2+DvgaNpud
6tZsvxzN939evrTqM1py
=BGQb
-----END PGP SIGNATURE-----

--MRogIhTehVmamjbeA70DLhF5kKnChnT6A--
