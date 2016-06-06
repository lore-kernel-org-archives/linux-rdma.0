From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Fix device managed flow steering support test
Date: Mon, 6 Jun 2016 19:32:02 -0400
Message-ID: <85919659-75e9-284d-22de-7fc9843640c1@redhat.com>
References: <33c3370d-3568-a9aa-906f-683b0e1b1a5f@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mDWaqS1ErflIEfI6bWglKLE6n7wc3wEeM"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <33c3370d-3568-a9aa-906f-683b0e1b1a5f-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mDWaqS1ErflIEfI6bWglKLE6n7wc3wEeM
Content-Type: multipart/mixed; boundary="JU2XRavtLIx0MejtcgVmC0J58RhhUujfi"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <85919659-75e9-284d-22de-7fc9843640c1-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Fix device managed flow steering support test
References: <33c3370d-3568-a9aa-906f-683b0e1b1a5f-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <33c3370d-3568-a9aa-906f-683b0e1b1a5f-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>

--JU2XRavtLIx0MejtcgVmC0J58RhhUujfi
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 6/3/2016 10:58 AM, Bart Van Assche wrote:
> Perform the test for device managed flow steering support even if
> memory windows are not supported. I noticed this because smatch
> reported inconsistent indentation for the device managed flow
> steering support test.
>=20
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx4/main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/=
mlx4/main.c
> index b01ef6e..0eb09e1 100644
> --- a/drivers/infiniband/hw/mlx4/main.c
> +++ b/drivers/infiniband/hw/mlx4/main.c
> @@ -505,9 +505,9 @@ static int mlx4_ib_query_device(struct ib_device *i=
bdev,
>  			props->device_cap_flags |=3D IB_DEVICE_MEM_WINDOW_TYPE_2B;
>  		else
>  			props->device_cap_flags |=3D IB_DEVICE_MEM_WINDOW_TYPE_2A;
> -	if (dev->steering_support =3D=3D  MLX4_STEERING_MODE_DEVICE_MANAGED)
> -		props->device_cap_flags |=3D IB_DEVICE_MANAGED_FLOW_STEERING;
>  	}
> +	if (dev->steering_support =3D=3D MLX4_STEERING_MODE_DEVICE_MANAGED)
> +		props->device_cap_flags |=3D IB_DEVICE_MANAGED_FLOW_STEERING;
> =20
>  	props->device_cap_flags |=3D IB_DEVICE_RAW_IP_CSUM;
> =20
>=20

Thanks Bart, applied.


--JU2XRavtLIx0MejtcgVmC0J58RhhUujfi--

--mDWaqS1ErflIEfI6bWglKLE6n7wc3wEeM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXVgfyAAoJELgmozMOVy/dgn8P/1D2bB/UTLptM47jN4fwNg1w
n9gKyEva0PACV+e8nySE6L1YkaPjiI6r5YsaZXI0oxM0P1INQwFluJikIhW8n+Nm
M9Nm0yudeB5dKbbiD5GSO0pqjikbpSt4HQXVW0P1jmstdD8u8oUP7SirVvFso24k
ktHcApXZK/yrsHe49Twzts+XJby/nEtVCoH/dQLIbltkfJC0GtAzch5zSJcW6UpJ
bQIle2/ut+S1B206WG9z9dkXWPV5pN4NFO7bu5BN000nZ9n1x1oafi+DcdMd7c8L
uIWOpVoLsmhP3idlyCDXnVcVWZrvO2fIbdbtb8tmPVm3XCTevaOsWblP0hWuhlrq
Q+kDXrWKaKU16eEYLlF38P4XHryWVR6vBf6WKqwajHAU9+khoWqbEBvzbCZ9HVhk
lFGKjiV6nSyogiylLtjUUbtbklPNzb51cvcbFgC2spEAVUJLApZUxENr4vAuBxlG
i6PfBRSa81G5RVlbx4cq4wumPiOTivjgT/TI7MNhdTrhlna/t8XO0Lt3/VGS2PYJ
08hlTrcfvC/rbCECFxBNPNEaCXTP9aLAFb7au1BL7c5v/4z4J4dxC/zdpfDYA7az
ty2SZi5ZnGuRoFVoeRned0+GHb0eGtdkekVD9FzxdQ3kStUga/cHEP5hkCuPo/ag
vsryJ/gQjcJ+dC7ek15B
=w3PZ
-----END PGP SIGNATURE-----

--mDWaqS1ErflIEfI6bWglKLE6n7wc3wEeM--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
