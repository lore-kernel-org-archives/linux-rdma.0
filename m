From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 2/9] RDMA/hns: Factor out the code for checking
 sdb status into a new function
Date: Thu, 28 Sep 2017 16:50:14 +0300
Message-ID: <20170928135014.GY2297@mtr-leonro.local>
References: <1506574654-56699-1-git-send-email-xavier.huwei@huawei.com>
 <1506574654-56699-3-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/iGx3h4bc2ZI981g"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1506574654-56699-3-git-send-email-xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lijun_nudt-9Onoh4P/yGk@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-WVlzvzqoTvw@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shaobohsu-9Onoh4P/yGk@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--/iGx3h4bc2ZI981g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 28, 2017 at 12:57:27PM +0800, Wei Hu (Xavier) wrote:
> From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>
> It mainly places the lines for checking send doorbell status
> into a special functions. As a result, we can directly call it in
> check_qp_db_process_status function and keep consistent indenting
> style.
>
> It fixes: 5f110ac4bed8 ("IB/hns: Fix for checkpatch.pl comment style)

You forgot " at the end of the line, and there is need to put fixes
(should be Fixes) in the line before Signed-off-by.

> The warning from static checker:
> drivers/infiniband/hw/hns/hns_roce_hw_v1.c:3562 check_qp_db_process_status()
> warn: inconsistent indenting
>
> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 95 ++++++++++++++++--------------
>  1 file changed, 51 insertions(+), 44 deletions(-)
>

--/iGx3h4bc2ZI981g
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnM/hUACgkQ5GN7iDZy
WKef5BAAnKTif+pcrsUgxkCeMy8XhzXOK0weAkLauqR0rzGKB4UHpR04A4qh/vTK
0Ytp3IZUDQJsn33TEmLTVP6AdWgORJjVH25/5W0XUJCIFE2kW3XNemynPfQzUKTo
l3DZ9VosNF4DZdp88XC6qrYAra6qgw79jCOJ5DN9HxxFfgjzvsCWOIc+IYYJbZLl
NJQeKOQJ5ztAoyODNnUHpiIig/glPfCAiD/n/kcWncjQmosFVG4OCwlx6Zez80qG
R1T8gJPVPqlXJtghvLqIQyuAwrldhSO6rmgITa3X0RqExJZ7TryQPRDRmor3SB4p
ESdSLq8n7AZMzDbNmdSehf3kSpcAD5H36LxY71H78YlMQpZFN6NI0GJyQqQDORnp
ed6Wrd6sT6R4CJtgs2jGOYTcwK9G7wJre/vcOQBaf5iug13mNSdZYWB2a6IWACpa
QKGbW6BDBd2iewLEtFmTcv74EoLRzl18AhwOCBIIBQP0+lPwZfrF6+jI5Ft/PnT2
26e+ryqA+jrEURjo7xQI4EN4qR4Ek2DJkeu43zx69429NVSBAve7M+6+lGPekouL
ifHslbpA5SgfBalUKz6bK4pwX+kbwThckUHBiDCBQEbmle7LEJ2BsI+uJbUanghv
4D/+WpnBkp1MjKqJQpNKw5AB3K1IZke7eZO6KGnxT2dOt1Rz7Jw=
=ksDR
-----END PGP SIGNATURE-----

--/iGx3h4bc2ZI981g--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
