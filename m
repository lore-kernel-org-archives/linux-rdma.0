From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 7/9] IB/mlx5: Add VERBOSITY Kconfig option
Date: Fri, 2 Sep 2016 13:52:59 -0400
Message-ID: <55889fa6-51c0-fcf6-7684-9712b82212d6@redhat.com>
References: <1472371118-8260-1-git-send-email-leon@kernel.org>
 <1472371118-8260-8-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Gn7RWIPQkuhGcfTumsk4qvT2TuMV2kOWK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472371118-8260-8-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Gn7RWIPQkuhGcfTumsk4qvT2TuMV2kOWK
Content-Type: multipart/mixed; boundary="rsIrSFpv68d8K0hHOIMRgwVqxvwdlmoel";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <55889fa6-51c0-fcf6-7684-9712b82212d6-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 7/9] IB/mlx5: Add VERBOSITY Kconfig option
References: <1472371118-8260-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <1472371118-8260-8-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
In-Reply-To: <1472371118-8260-8-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--rsIrSFpv68d8K0hHOIMRgwVqxvwdlmoel
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/28/2016 3:58 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> This patch introduces new MLX5_INFINIBAND_VERBOSE Kconfig
> option to enable the output of dump_wqe() which was never
> printed.
>=20
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/Kconfig | 6 ++++++
>  drivers/infiniband/hw/mlx5/qp.c    | 2 +-
>  2 files changed, 7 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx5/Kconfig b/drivers/infiniband/hw=
/mlx5/Kconfig
> index bce263b..789fef4 100644
> --- a/drivers/infiniband/hw/mlx5/Kconfig
> +++ b/drivers/infiniband/hw/mlx5/Kconfig
> @@ -6,3 +6,9 @@ config MLX5_INFINIBAND
>  	  Mellanox Connect-IB PCI Express host channel adapters (HCAs).
>  	  This is required to use InfiniBand protocols such as
>  	  IP-over-IB or SRP with these devices.
> +
> +config MLX5_INFINIBAND_VERBOSE
> +	bool "Enable ConnectX-4/Connect-IB verbosity"
> +	depends on MLX5_INFINIBAND
> +	---help---
> +	  This is a configuration option to enable verbose output to easy deb=
ug.
> diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/ml=
x5/qp.c
> index 174d09b..67b58f7 100644
> --- a/drivers/infiniband/hw/mlx5/qp.c
> +++ b/drivers/infiniband/hw/mlx5/qp.c
> @@ -3984,7 +3984,7 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct =
ib_send_wr *wr,
>  			   get_fence(fence, wr), next_fence,
>  			   mlx5_ib_opcode[wr->opcode]);
>  skip_psv:
> -		if (0)
> +		if (IS_BUILTIN(CONFIG_MLX5_INFINIBAND_VERBOSE))
>  			dump_wqe(qp, idx, size);
>  	}

This patch is just a big old bunch of no.  There is no way I'm sending
in Kconfig changes in a late -rc.  Further, there is no way I'm sending
in a Kconfig option for a single debug print function.  Third, there is
no way I'm sending in a Kconfig setting for what should be a runtime
debug switch or something like that.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--rsIrSFpv68d8K0hHOIMRgwVqxvwdlmoel--

--Gn7RWIPQkuhGcfTumsk4qvT2TuMV2kOWK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIbBAEBCAAGBQJXybx7AAoJELgmozMOVy/dcpcP+Ngb3ql7l4X5xJKNHzB8z0ub
i9Fg2VCdCw+hBwCBadAAF7v6n158McdvRiV7ebH8gXlL9vsQlZ73p763fCq2vo4t
quzBiB42bD3akKppLGpg/x090DMbrfFLkjZsZhddZSiIA5PwAX9MJhA43mRq8xZE
CEyNtdTH8vVn5zlgx28/JQDGnUZmk4wBaLHIqS/Onwf4xwe4Cktuj9tD8diskrQ4
5+QgnEUpM3ZhSAuUN1nS/R3iEVz690/0CIdRO/qyw/+5dEmLJY8gUcEtaG3us9Kd
khN1WLV1Ryx0Da8NFkc5kJ+MGAKX7cf/1F0boTOVQqsrArz/zv5cOJD8n+3YHC65
j+Ar43EGF/FuV+965b7pjpZ1qMmHau/p7cUrToC7ALV+A7lqfushNAn8+X8uT2kH
tKw8OxGt9a51noStrsNw4kNXO2IhdS4n1jhvp522Zw1LM7NJCLtOJcvOO+akqYSF
t6Tn3H9BPxQOSaAi3VyxD2W++a7CzFDEm4tizt/AqCyjOu1QnXPL4mSi1eeyYi1R
i55UwFOTuqWi722XASKsYtGv+3UANP9rIK56En7V2MsExIOzeGpdFQxFso1XT80Z
RX2CYOumWLRwCQEhaWIaJx4N/EUn9jdZ/ZYW39E+bgYQR9tFysL3mnKCr8qwgcmn
/QKk72U1g0v2EAbaajs=
=drro
-----END PGP SIGNATURE-----

--Gn7RWIPQkuhGcfTumsk4qvT2TuMV2kOWK--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
