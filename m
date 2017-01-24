From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/5 v2] qedr: fix formatting
Date: Tue, 24 Jan 2017 17:25:51 +0200
Message-ID: <20170124152551.GK6005@mtr-leonro.local>
References: <1485258703-11949-1-git-send-email-Ram.Amrani@cavium.com>
 <1485258703-11949-3-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="q5r20fdKX+PFtYHw"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1485258703-11949-3-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--q5r20fdKX+PFtYHw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 24, 2017 at 01:51:40PM +0200, Ram Amrani wrote:
> From: Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>
>
> remove standalone ';'.
> list function's parameters in a single line.
>
> Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/qedr/main.c  | 3 +--
>  drivers/infiniband/hw/qedr/verbs.c | 1 -
>  2 files changed, 1 insertion(+), 3 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--q5r20fdKX+PFtYHw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliHcf8ACgkQ5GN7iDZy
WKdMGg//XLhjvkgs9aPUbvhbLHB7t61eEwX0v0ZZx8BW066zgsDo8KCpbAJvqQot
2kkxEs2C6w6wLAd/MxRN6oCXHz0Fu1xQFoN1MaiUg348sQXRSMsNwmkNIb+NHAGi
Rf6Go7M14hyOPXuIRG9LA4+oNsoBJRx23BXl0dM4A0lw787kxsXXdCk+iDlYtkb0
8wzLLta38zSVclRqMQH9MSD/k2UJkS+FS6wUSo2OMROIVqIulR9MrbBR2lMcAYAn
kt6gyDLHZyyAOvCz0Xi1RQuBwp/D/BJ9Imo2kZlas3IUxYPCRhy5iKXHDHmuFPE2
9lqC416Cdkx2ppwk1BVa2lZUPo6+qUxHIkFtSCHBOtgH8FC/lyTTphjNktHfelZf
jVxEhV5H5A6MG6IoinmFPCM/ZtW/5hm36LxRRjByXEhjaodyRbWf3gkZOemRwDRM
KvJH5DPgveSD707GoffacgE6Aa0Pi+w0sAZwqc2NtE1oQQonzk14xuu0rgQYOR+8
XB2D1kaU6vtmf0OG1KzQ/jD3f1f46CAvOuCVnAAP6TrjNUHjQ1niNs3e3y0WSsiI
P0VfFreB5r89WSY6NHdxFqqTSDJABBOP/DCSuk3f0wIsap6ccstnrQcUEIBEo3Eo
lL8BffGU/GP4LiGOQIXwKmTLNDORBq3mOl/dD6PFa6wGB5AhzrA=
=pJb4
-----END PGP SIGNATURE-----

--q5r20fdKX+PFtYHw--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
