From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] ib: Init subsystems if compiled to vmlinuz-core
Date: Wed, 29 Nov 2017 11:47:03 +0200
Message-ID: <20171129094703.GW29104@mtr-leonro.local>
References: <20171129090949.27602-1-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+S4DbcR7QPeSsP0V"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171129090949.27602-1-dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dmitry Monakhov <dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--+S4DbcR7QPeSsP0V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 29, 2017 at 09:09:49AM +0000, Dmitry Monakhov wrote:
> Once infiniband was compiled as core component it's subsystems must be
> enabled before device initialization. Otherwise this result NULL pointer
> dereference during mlx4_core init, calltrace:
> ->device_add
>   if (dev->class) {
>      deref  dev->class->p =>NULLPTR
>
> #Config
> CONFIG_NET_DEVLINK=y
> CONFIG_MAY_USE_DEVLINK=y
> CONFIG_MLX4_EN=y
>
> Signed-off-by: Dmitry Monakhov <dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/core/cm.c        | 2 +-
>  drivers/infiniband/core/device.c    | 2 +-
>  drivers/infiniband/ulp/srp/ib_srp.c | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)

First please follow submission rules (patch versioning and changelog)
and second, I have hard time to believe that those changes in CM and SRP
are really needed.

Can you please provide actual kernel panic *without* any changes to init
sequences?

Thanks

>
> diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
> index 4c4b465..1012fd8 100644
> --- a/drivers/infiniband/core/cm.c
> +++ b/drivers/infiniband/core/cm.c
> @@ -4370,6 +4370,6 @@ static void __exit ib_cm_cleanup(void)
>  	idr_destroy(&cm.local_id_table);
>  }
>
> -module_init(ib_cm_init);
> +subsys_initcall(ib_cm_init);
>  module_exit(ib_cm_cleanup);
>
> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> index 84fc32a..5e1be49 100644
> --- a/drivers/infiniband/core/device.c
> +++ b/drivers/infiniband/core/device.c
> @@ -1253,5 +1253,5 @@ static void __exit ib_core_cleanup(void)
>
>  MODULE_ALIAS_RDMA_NETLINK(RDMA_NL_LS, 4);
>
> -module_init(ib_core_init);
> +subsys_initcall(ib_core_init);
>  module_exit(ib_core_cleanup);
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index fa5ccdb..0c21a71 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -3785,5 +3785,5 @@ static void __exit srp_cleanup_module(void)
>  	destroy_workqueue(srp_remove_wq);
>  }
>
> -module_init(srp_init_module);
> +subsys_initcall(srp_init_module);
>  module_exit(srp_cleanup_module);
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--+S4DbcR7QPeSsP0V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloeghcACgkQ5GN7iDZy
WKf6KQ//UHB4Zvcom/tqISTsB7HPp9z1d59TWhSK+AOisjN/W2eLq1BricZVlM+m
410/7s7qAOoDOtMxfLO676vAtNlGKY8bz2ZM0bsUD1tCgAf8IrozCj9Zfn6mvLhr
s96nLOY0gy4LuEKvt+4KCPnR3nBHdKg9TeoNzECdmgd0ezIBbqaouhXL5qSAS8q9
R9WQF/b6t+9+yjpkZm9iYUVANoLZ5VrapANgI5n5zECjnLaoYQe7aZplGp3qnlW8
Dv1FUZEG62jCUYlUAj2zwgL2VMplF9JaUQTj0Jw8tbGHKnfvVMML/2e0Ad+pgWTP
X2Jclhv7UPw5mzZc3A1F3Xu/4dEZ54Ix4VJVaWmxV2+PItNsf8Lwl0IxMlLZe9n/
fWoylIjLZHzxkoLmsz4fC6PohL/PtvX08xHK2UVPLYwxhLYGE0mFQYfiPPSMNobS
KjbVtovs3QBqyArUybUaJe4haio++byN+zXrxS+/aqnYw/vC/el9To6css884U5t
ycGhI1+it4Pm8ZdVv0hTBOVxNgSZDK4/QZ8fG9NNMAD1ong2C+Bt8npVvlwvU+ie
hCQ6mlPEM1nGHEsQ22v+znrX31bpqYJZVjuVXzxJ9CXfIL1J1nvLX531HOKm11Tv
islvGoBCVhu8VEZMBtrNBeGRrCoqp34JUEI7+Ahks6ToypnNn0U=
=96n6
-----END PGP SIGNATURE-----

--+S4DbcR7QPeSsP0V--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
