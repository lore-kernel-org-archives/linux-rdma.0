From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] infiniband: free only allocated items
Date: Wed, 08 Jul 2015 17:54:56 -0400
Message-ID: <559D9C30.5090203@redhat.com>
References: <1436328815-28072-1-git-send-email-maninder1.s@samsung.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QFWXRhnOqiBCw4VG1lKfApJ5B76fgrts0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436328815-28072-1-git-send-email-maninder1.s-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Maninder Singh <maninder1.s-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: pankaj.m-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QFWXRhnOqiBCw4VG1lKfApJ5B76fgrts0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/08/2015 12:13 AM, Maninder Singh wrote:
>  o If allocation of dm fails, no need to free it.
>  o Free only allocated items.

I've taken the patch, but I reworked your commit message.  The v1
version of the patch had a more correct commit message, but it could
have used a little rework as well.  This is what I entered in the commit
message:

IB/mlx4: Optimize freeing of items on error unwind

On failure, we loop through all possible pointers and test them before
calling kfree.  But really, why even attempt to free items we didn't
allocate when we can easily loop through exactly and only the devices
for which the original memory allocation succeeded and free just those.

Signed-off-by: Maninder Singh <maninder1.s-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


>=20
> Signed-off-by: Maninder Singh <maninder1.s-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx4/main.c |    8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/=
mlx4/main.c
> index 067a691..253498f 100644
> --- a/drivers/infiniband/hw/mlx4/main.c
> +++ b/drivers/infiniband/hw/mlx4/main.c
> @@ -2669,17 +2669,15 @@ static void do_slave_init(struct mlx4_ib_dev *i=
bdev, int slave, int do_init)
>  	dm =3D kcalloc(ports, sizeof(*dm), GFP_ATOMIC);
>  	if (!dm) {
>  		pr_err("failed to allocate memory for tunneling qp update\n");
> -		goto out;
> +		return;
>  	}
> =20
>  	for (i =3D 0; i < ports; i++) {
>  		dm[i] =3D kmalloc(sizeof (struct mlx4_ib_demux_work), GFP_ATOMIC);
>  		if (!dm[i]) {
>  			pr_err("failed to allocate memory for tunneling qp update work stru=
ct\n");
> -			for (i =3D 0; i < dev->caps.num_ports; i++) {
> -				if (dm[i])
> -					kfree(dm[i]);
> -			}
> +			while (--i >=3D 0)
> +				kfree(dm[i]);
>  			goto out;
>  		}
>  	}
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--QFWXRhnOqiBCw4VG1lKfApJ5B76fgrts0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVnZwwAAoJELgmozMOVy/dwPEQALIV4qotUuCIeW2eyWf8tLaM
95oH2JXe9IDXY9JJeYOTPM8HyG1AL58YXVq9kUPHhk/v6BqgAQssvYf0NatMGoCl
eijG7C74SXWLqcXObYm/UKaWZSdlIGouhI2s49JKAKMdWnPbax+RdaWATKfGbk6d
O0Nry6gtmB+sfOPNepcUlki1sxE35y72mt4gtJLVmq0h0IYGnhiyVimqVeyYHyZX
YcEIIahhoRwCfLI6PZqXNVWYQwewuH7ZAKA5xMhfOtaszRHfEih9pgiulTjCK/gS
QckNzU24VjoOrad0NqSw3WTJtmo51cRFzOAKmFDtQdRmw/n7HONanbRfjBQ6rsOE
uJjCou3UjWTYY9MW11+eYrV58yq2CjqqUYbDk+Er5tabxa5pdUkGFmQYZAel3T07
Zkw6kos+WTMZY3ZMtUbiubVmhMO3NU+kGRyECm2LsoytyItP4NbhqsRo5EwlN+xW
nsOL9HR9XGI3rGkSH4iqulQRn2b1Na2iwVCdBjWkh7t38qea+5zNi0KJRs3ocPkq
gFZhXRatsrfvQpf7pBYhG542h795wh0sB0V59G1uyOtX+MooBmqVwYuprCxzYjZJ
TXrgQXLJnEkZMuHh8ln53g/Ak0s7QWkTjzu3rcBVlm2AR3ydniKPrLqP5gFOnglI
jY7BwUzvCklLnwE5D2/W
=cVX7
-----END PGP SIGNATURE-----

--QFWXRhnOqiBCw4VG1lKfApJ5B76fgrts0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
