From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/core: add the function ib_mtu_int_to_enum
Date: Tue, 27 Dec 2016 09:34:11 +0200
Message-ID: <20161227073411.GF14356@mtr-leonro.local>
References: <1482734458-32131-1-git-send-email-Ram.Amrani@cavium.com>
 <1482734458-32131-2-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="A9z/3b/E4MkkD+7G"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1482734458-32131-2-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--A9z/3b/E4MkkD+7G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 26, 2016 at 08:40:57AM +0200, Ram Amrani wrote:
> As the functionality to convert the MTU from a number to enum_ib_mtu
> is ubiquitous, define a dedicated function and remove the duplicated
> code.
>
> Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/cxgb3/iwch_provider.c | 11 +----------
>  drivers/infiniband/hw/cxgb4/provider.c      | 11 +----------
>  drivers/infiniband/hw/i40iw/i40iw_verbs.c   | 11 +----------
>  drivers/infiniband/hw/nes/nes_verbs.c       | 12 +-----------
>  include/rdma/ib_verbs.h                     | 14 ++++++++++++++
>  5 files changed, 18 insertions(+), 41 deletions(-)

Looks good,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--A9z/3b/E4MkkD+7G
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhiGXMACgkQ5GN7iDZy
WKfhWg//bzs6iTD40Z4ps5pVrcgPnOm42rLJEZclqVGaSFJqgn5zqRCm60l6tM5D
fdR3v1csbeinjURx8UU0L9iGua1C1mn5vJprB06zzX9bI0zlmO2nR6dXI6oHd5rw
pHgQh760YmemQp7w89K0LCfOVonbG6qAIugVKGpkawlJn/b9midQBgOemcJsTfy+
csaZmvXbe2xrUUNV/rpJCFrH46Jk1sDitqHXzvMskUbUmevlD45Kr43je9H0PWqG
HipzXAgCWzmdGuJl0NH4nOfPGilHeaAIgtBJrLk3M1fyxS9ev5Z2IYUQUarmG2MW
+4kM75X4QPJ3Ij6ekcADHJVkn5shzaC6rMNKjUsIpyoeolSucaJ0TiHUuJC0uP+A
+HN70I9bGHh4mf2INmEj8mkO3Yf7uVHLfrBsLcwGalYORF8CiYgNxdux/5nr4LYw
vpeSBomo74AYuSnCcRdt0n42tYfR/Zv/vVL5gvMtJJ8NLhuI6H/snxTc0X6Tu8gP
WPjgRmHvidZYasUZpoHErrUfx20aDvPcnszJIpYdhBnTexw056KcudFpvTX6cq0m
HGHAEfTK4NBbu9CSFsMs1NTak/cUipacH2+vIqfNuLfd29SBKsoXhqVBUMgz7MZy
LMyeFmYDYSf0YSFcpF44+QdYoX1T3QZOzJHfkCgkmNrZEO4nIC8=
=aUXM
-----END PGP SIGNATURE-----

--A9z/3b/E4MkkD+7G--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
