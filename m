From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] infiniband:cxgb4:Fix if statement check in the function
 pick_local_ip6adddrs
Date: Thu, 3 Sep 2015 14:05:47 -0400
Message-ID: <55E88BFB.8070609@redhat.com>
References: <1440644459-13595-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="UUpTqWxauJ45BtA69Bph33jVaGSM3Wr7l"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1440644459-13595-1-git-send-email-xerofoify@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicholas Krause <xerofoify@gmail.com>, swise@chelsio.com
Cc: sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UUpTqWxauJ45BtA69Bph33jVaGSM3Wr7l
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/26/2015 11:00 PM, Nicholas Krause wrote:
> This fixes a if statement checking the return value of the function
> get_lladdr for success in the function pick_local_ip6addrs to instead
> of directly checking the return value of this call check the opposite
> as get_lladdr returns zero for success which would incorrectly make
> this if statement block  not execute with the current if statement
> check.
>=20
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>

Thanks, applied.

> ---
>  drivers/infiniband/hw/cxgb4/cm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/c=
xgb4/cm.c
> index 3ad8dc7..b85b94b 100644
> --- a/drivers/infiniband/hw/cxgb4/cm.c
> +++ b/drivers/infiniband/hw/cxgb4/cm.c
> @@ -2976,7 +2976,7 @@ static int pick_local_ip6addrs(struct c4iw_dev *d=
ev, struct iw_cm_id *cm_id)
>  	struct sockaddr_in6 *la6 =3D (struct sockaddr_in6 *)&cm_id->local_add=
r;
>  	struct sockaddr_in6 *ra6 =3D (struct sockaddr_in6 *)&cm_id->remote_ad=
dr;
> =20
> -	if (get_lladdr(dev->rdev.lldi.ports[0], &addr, IFA_F_TENTATIVE)) {
> +	if (!get_lladdr(dev->rdev.lldi.ports[0], &addr, IFA_F_TENTATIVE)) {
>  		memcpy(la6->sin6_addr.s6_addr, &addr, 16);
>  		memcpy(ra6->sin6_addr.s6_addr, &addr, 16);
>  		return 0;
>=20


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--UUpTqWxauJ45BtA69Bph33jVaGSM3Wr7l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV6Iv7AAoJELgmozMOVy/deREP/3j6Dol5qo5ULMoYHYW4zTjH
Og7uO4yA3VHFb6iU06m89AZGZl4sVgYDY6hWa2K/M74gqj+p4mUIn9RmMPOkfHYJ
nhtTNfJAJg6Bt5KffS8MlWu8dii5R5zjbE9pMCzEaagMjZWAhlgCnLiIAQEKhPv7
L8Ku/yeTepAhSWCTHsWDBOd7sk1PhYZGNaFGe1J/KZUj1EpYcSAowfrQBWaXkzPl
68PpUp04TgjZ6WZGo2jo7PFyH7D3thn4BtqkSo1fL1biPediWLA1z1tYjyJiQbt6
iJYbWVC12hOoXcmPIyQrBxuJZNGSfnM/FRwDfqRwWiMmi2vcf+6wir0EIoqfg/Wy
9sY3UyL6RI8WU3l1nVTLTwsHmy61JLM1QlqCud709jdTuGb9dlLMHHcHtLmcHqtU
Jstt3X9Gz5KctZSAK4DaX4iiuliVGct2s3Kf9By6FG3MlPphFo1m/46t59GIaRPn
hBqEIAchYVb04fy1cw8Zg1wYgT9siZzAg3255GpIDwHgW9RTpPSSbBy+PDqBRsZw
iVZngxzVcr7T26PllOycKsMq3b4+jXwqAghV4MkZHnKYFFQ/MmGs4buYMEMuoAPp
x6BXUyCA3N35MpfynliZzvOCRS7UgwkqCJ2feMfrmoYQMzbiVZ4o2crwu5U97nlp
lZqHqrIlDsB3f9aJlGel
=uD+v
-----END PGP SIGNATURE-----

--UUpTqWxauJ45BtA69Bph33jVaGSM3Wr7l--
