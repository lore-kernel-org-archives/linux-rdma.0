From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] rdma-core: define link speed and link width enums
Date: Mon, 8 May 2017 16:54:04 +0300
Message-ID: <20170508135404.GD10073@mtr-leonro.local>
References: <1494251057-1060-1-git-send-email-devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bAmEntskrkuBymla"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1494251057-1060-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--bAmEntskrkuBymla
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 08, 2017 at 09:44:17AM -0400, Devesh Sharma wrote:
> Currently application either need to define its own enum
> values for link-speed and link-width or use hard coded
> values. This patch inharits the enums from kernel space
> ib_verbs.h and puts into verbs.h for ease of programming.
>
> Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> ---
>  libibverbs/examples/devinfo.c | 22 ++++++++++++----------
>  libibverbs/verbs.h            | 18 ++++++++++++++++++
>  2 files changed, 30 insertions(+), 10 deletions(-)

I think the better approach will be move these defines from
include/rdma/ib_verbs.h to include/uapi/rdma/ib_user_verbs.h
and reuse ib_user_verbs.h file directly in libibverbs.

>
> diff --git a/libibverbs/examples/devinfo.c b/libibverbs/examples/devinfo.c
> index 2c1e3f1..42ed50c 100644
> --- a/libibverbs/examples/devinfo.c
> +++ b/libibverbs/examples/devinfo.c
> @@ -124,10 +124,10 @@ static const char *mtu_str(enum ibv_mtu max_mtu)
>  static const char *width_str(uint8_t width)
>  {
>  	switch (width) {
> -	case 1:  return "1";
> -	case 2:  return "4";
> -	case 4:  return "8";
> -	case 8:  return "12";
> +	case IBV_WIDTH_1X:  return "1";
> +	case IBV_WIDTH_4X:  return "4";
> +	case IBV_WIDTH_8X:  return "8";
> +	case IBV_WIDTH_12X:  return "12";
>  	default: return "invalid width";
>  	}
>  }
> @@ -135,14 +135,16 @@ static const char *width_str(uint8_t width)
>  static const char *speed_str(uint8_t speed)
>  {
>  	switch (speed) {
> -	case 1:  return "2.5 Gbps";
> -	case 2:  return "5.0 Gbps";
> +	case IBV_SPEED_SDR:  return "2.5 Gbps";
> +	case IBV_SPEED_DDR:  return "5.0 Gbps";
>
> -	case 4:  /* fall through */
> -	case 8:  return "10.0 Gbps";
> +	case IBV_SPEED_QDR:  /* fall through */
> +	case IBV_SPEED_FDR10:  return "10.0 Gbps";
>
> -	case 16: return "14.0 Gbps";
> -	case 32: return "25.0 Gbps";
> +	case IBV_SPEED_FDR: return "14.0 Gbps";
> +	case IBV_SPEED_EDR: return "25.0 Gbps";
> +	case IBV_SPEED_HDR: return "50.0 Gbps";
> +	case IBV_SPEE_NDR: return "100.0 Gbps";
>  	default: return "invalid speed";
>  	}
>  }
> diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
> index b27dfd1..39a65fe 100644
> --- a/libibverbs/verbs.h
> +++ b/libibverbs/verbs.h
> @@ -290,6 +290,24 @@ enum ibv_port_state {
>  	IBV_PORT_ACTIVE_DEFER	= 5
>  };
>
> +enum ibv_port_speed {
> +	IBV_SPEED_SDR    = 1,
> +	IBV_SPEED_DDR    = 2,
> +	IBV_SPEED_QDR    = 4,
> +	IBV_SPEED_FDR10  = 8,
> +	IBV_SPEED_FDR    = 16,
> +	IBV_SPEED_EDR    = 32,
> +	IBV_SPEED_HDR    = 64,
> +	IBV_SPEED_NDR    = 128
> +};
> +
> +enum ibv_port_width {
> +	IBV_WIDTH_1X     = 1,
> +	IBV_WIDTH_4X     = 2,
> +	IBV_WIDTH_8X     = 4,
> +	IBV_WIDTH_12X    = 8
> +};
> +
>  enum {
>  	IBV_LINK_LAYER_UNSPECIFIED,
>  	IBV_LINK_LAYER_INFINIBAND,
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--bAmEntskrkuBymla
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkQeHwACgkQ5GN7iDZy
WKdXtQ//ZLk8c0bNUPkZyDICasWwpB5jTb5G3kQ69mgh0Lyrotdr2LOprVNCANCU
9Yr0oTVdprzTsK/U/MWpYwvrdh92AJm28vP+LR9K3+nK7EbXN30T4aEkEq5+Unar
5utFvVzVc9LYu+/cn/M3ZDumE+iPJnOC+HieASkc+t/Yr4L/5UQacz12OlKuZzi9
sqJq8pA0F4lXyzQYHLvUDKT+cahetXvIHFgSJGJrdNnoMHuuA29sPh0Gu3jnUdPt
cEGOcJsWgH6+dCNCeJUILWK+2B83E8y25wzEr8NVyMt0wR19FVx2obfAVbUcPQdM
AdJ1C0SBS5QKMXf8nzzMmvK3N9Esh/FausjJxi5YxK7SqOhftour0K0fU2winy8r
XeA6Dav5m9a1nGLqMwxg1kiOiTxOJpZdqDNbpob/KGpYDz42jAzIfHk4EWlQN601
9InC8LnS4wjFu5izMILzWBOdBy+E/AYt9aMNx6liEi6G7CxDcKX1QveHHfe1m68W
o3RlffYGcjYmdF3HR4kDJ4P0NPmJ4FW3Pd4tPfLykqxYi5QANGKGZ1IzV/WyAYZc
TDbJI+SwnkHrbsqO7Gnm8TH5G6pUSmJTDBwl8Ff4F/jN3xCYogyC654jNmm8oWl4
Vg0G89B/HaMeEjTVtmZHDLWWY6xO4ArdYCNO4L4kKU9caGsmzWg=
=sn7D
-----END PGP SIGNATURE-----

--bAmEntskrkuBymla--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
