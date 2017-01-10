From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] redhat: Remove non-existed infiniband modules
Date: Tue, 10 Jan 2017 15:29:00 +0200
Message-ID: <20170110132900.GL7218@mtr-leonro.local>
References: <20170109085429.32598-1-leonro@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+jhVVhN62yS6hEJ8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170109085429.32598-1-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--+jhVVhN62yS6hEJ8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 09, 2017 at 10:54:29AM +0200, Leon Romanovsky wrote:
> The modules ib_addr.ko, ib_mad.ko and ib_sa.ko were integrated
> into ib_core.ko in following kernel commits:
>  * c2e49c92326f ("IB/SA: Integrate ib_sa module into ib_core module")
>  * 4c2cb4220431 ("IB/MAD: Integrate ib_mad module into ib_core module")
>  * e3f20f02864f ("IB/core: Integrate IB address resolution module into core")
>
> Fixes: 39fa824dd80e ("redhat: add udev/systemd/etc infrastructure bits")
> Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  redhat/rdma.kernel-init | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied

--+jhVVhN62yS6hEJ8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlh04ZwACgkQ5GN7iDZy
WKfsyRAAzB4fOZ7s03JdGjemI3sR9vK4E+tOkOm1ACVgTfrm3JAvOLYVdw9Vui64
kG4aG+szkOOO5a1kLP+Om5LTmHkxJ42/LjzVQZal002eiIXgkcBOgxzqSsCdiOPM
MX1lEUtUZWaOi3UJyqwkJ2xU4OYXmnqtO3knOkU+v4Hbv7b4+AthhRYI39D2HSM/
daIh1k2n1eS025iY2o4WEnxTvIl0F18c6cKV8Sjj+LPT1uy2gI7NbQMULiXJAHWR
N2Pv6Zzm89ERNAgoiZ0cvimgKY+4iVOnnGmg1QyKEzR/BaRJrAPKJeXILaIMPe6b
luSnsN+9erwjS0eq9bZ9cP0ZbrJ+PAjNCxOnUOnfNQPOM7gQlWxu2Le+nFqtcmbq
UGN/8fT5Gzyr28ROk4MV4bPAuKxxrdRYsbWL4gWcBzTiZx7cW1QYiQRhlIEb0lYM
EL89pO27jRWfjHIOD005SGWqLY0PqwJKpObGfpfu/SzvGX1pbHoWiLGO4eJOv0K/
YMLtVD3KMkcwhLjAR/256GzyGjsPFNBkvqO/W8oIThCHA7KB/4oV0lBDJb3ovxnk
gtCIpV1whUWcHSxYN0mxS9G7BzecF3mPygdO3r81hepl1sOxJAtklV1fHh8q0YiH
/+7wPT3e7LNGhid59l3NVk/uUqtq595vGkNDYVeqyGJaROqlSMI=
=BRkM
-----END PGP SIGNATURE-----

--+jhVVhN62yS6hEJ8--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
