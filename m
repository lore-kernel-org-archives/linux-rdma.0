From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] ibverbs: remove unused ibv command declarations
Date: Sun, 5 Feb 2017 12:00:27 +0200
Message-ID: <20170205100027.GF6005@mtr-leonro.local>
References: <1486288224-17134-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="myN6XCtPygAIW5jc"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1486288224-17134-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--myN6XCtPygAIW5jc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Feb 05, 2017 at 11:50:24AM +0200, Ram Amrani wrote:
> Remove the IBV command declarations ibv_cmd_query_gid and
> ibv_cmd_query_pkey as they are not implemented.
>
> Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> ---
>  libibverbs/driver.h       | 4 ----
>  libibverbs/libibverbs.map | 2 --
>  2 files changed, 6 deletions(-)
>
> diff --git a/libibverbs/driver.h b/libibverbs/driver.h
> index 8ed2d30..5d29b14 100644
> --- a/libibverbs/driver.h
> +++ b/libibverbs/driver.h
> @@ -123,10 +123,6 @@ int ibv_cmd_query_device_ex(struct ibv_context *context,
>  int ibv_cmd_query_port(struct ibv_context *context, uint8_t port_num,
>  		       struct ibv_port_attr *port_attr,
>  		       struct ibv_query_port *cmd, size_t cmd_size);
> -int ibv_cmd_query_gid(struct ibv_context *context, uint8_t port_num,
> -		      int index, union ibv_gid *gid);
> -int ibv_cmd_query_pkey(struct ibv_context *context, uint8_t port_num,
> -		       int index, uint16_t *pkey);
>  int ibv_cmd_alloc_pd(struct ibv_context *context, struct ibv_pd *pd,
>  		     struct ibv_alloc_pd *cmd, size_t cmd_size,
>  		     struct ibv_alloc_pd_resp *resp, size_t resp_size);
> diff --git a/libibverbs/libibverbs.map b/libibverbs/libibverbs.map
> index d510c86..007a683 100644
> --- a/libibverbs/libibverbs.map
> +++ b/libibverbs/libibverbs.map
> @@ -12,8 +12,6 @@ IBVERBS_1.0 {
>  		ibv_query_device;
>  		ibv_query_device_ex;
>  		ibv_query_port;
> -		ibv_query_gid;
> -		ibv_query_pkey;

It should be ibv_cmd_query_gid and ibv_cmd_query_pkey.

>  		ibv_alloc_pd;
>  		ibv_dealloc_pd;
>  		ibv_reg_mr;
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--myN6XCtPygAIW5jc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliW97IACgkQ5GN7iDZy
WKf9jA//fKOeDRVdCTGov3rCwZgGVeJ2Bw6HyqDNlHFR0/9/hr87FOBJqdkN12bw
Jz5bbs/F+7OIH2hGXjSZws/Gn9OFKqvXvniQKcyWGoYNEm9ZpiwdIRzWpC9rT10T
Irk4kVTlWfrFDRXGsRgQvVjnU3QL10lo/KIYKVCL9SFKnmMiSg8AXw922FstLyXL
OFcLhAXPnWvpOY4s+ECrCVG3/NhW0KONAo7UAPqRI0EpNI4BXLQ/qZ1CeAIYyBku
gw5QrpeSiCVx/TV1ObV78B4RK66ZB+RM1QG/x1UVgiXuWTlSQuCKjVyVWykGJnyB
QY1qBdSirYQCZNC6j6eNTW7n1/yj0Arxb0JVjMvGtCLyK4LdpMznQOBmfWrvzvaA
2x5IJiCfJ+hwmNv0dZxlbfapIPY7bQBTLrkrU4e/TkAeNLBdzOGpgEnYQaWJMEfo
Yj78swCf7pOUo0JhkUd918gs7dorw/TKuIq/NrR7zYmN6RwAPkFU5MRePfHzA4mQ
vunn0SVdZPx5CPdXZiVhoqxuNAbGOHfqvUVzoN9X3CWrp6gSdD5J06QBczseDSBf
j6LawekTa84WHtaOF/Yi8aUVbJL7pyLELy0K2hZ/0kI8POKdIaYZdrLMyOHFVk/c
9N1hLZPE3EhefXxX7H5HE7IQxvOTKR9lhBTSZQssA+cgtxeiAbY=
=pABU
-----END PGP SIGNATURE-----

--myN6XCtPygAIW5jc--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
