From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] qede: fix general protection fault may occur
 on probe
Date: Thu, 27 Oct 2016 17:05:09 +0300
Message-ID: <20161027140509.GH3617@leon.nu>
References: <1477400039-16925-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="CEUtFxTsmBsHRLs3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1477400039-16925-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Yuval.Mintz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--CEUtFxTsmBsHRLs3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 25, 2016 at 03:53:59PM +0300, Ram Amrani wrote:
> The recent introduction of qedr driver support in qede causes a
> GPF when probing the driver in a server without a RoCE enabled
> QLogic NIC. This fix avoids using an uninitialized pointer in such
> a case. Caught by the kernel test robot.
>
> Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/net/ethernet/qlogic/qede/qede_roce.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Ram,

The rdma-core word in the subject is misleading.

Thanks

>
> diff --git a/drivers/net/ethernet/qlogic/qede/qede_roce.c b/drivers/net/ethernet/qlogic/qede/qede_roce.c
> index 9867f96..4927271 100644
> --- a/drivers/net/ethernet/qlogic/qede/qede_roce.c
> +++ b/drivers/net/ethernet/qlogic/qede/qede_roce.c
> @@ -191,8 +191,8 @@ int qede_roce_register_driver(struct qedr_driver *drv)
>  	}
>  	mutex_unlock(&qedr_dev_list_lock);
>
> -	DP_INFO(edev, "qedr: discovered and registered %d RoCE funcs\n",
> -		qedr_counter);
> +	pr_notice("qedr: discovered and registered %d RoCE funcs\n",
> +		  qedr_counter);
>
>  	return 0;
>  }
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--CEUtFxTsmBsHRLs3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYEgmVAAoJEORje4g2clinNUQP/2Do42s7ijbOmyeh3VOsJ0C6
6+S5I3Hp7TDyrt+nl1E3WPSC13uOUbuRCl7U+CRITMD1caPcKGSzGPRsKTv5P3NE
6yIU/KKmMKkj29+81g9F/wlAXvnyDr6jsp9zr+lD4P+YOKVh5+LnzyQrYzfyTLVs
7RDEO1bq0MNXq4nPJHYdLK7I/4qu+oCrIPTnFehAJI5mbfbuW6/2Pn+ZFM0+FNdP
SchgQjCbUXd+UlG7CA8vFRXcPPkBGeXUfO/+AQiISqq2j9/RqpgVEWfs97nciMAe
gE0KgxhIT8ZaDJTVnRFOY4Drp4gUOLYrV4lFki+bX88xarZRi61a+YkhwUnkOPVx
RwUP/6AbVELzhNneywP4XgkTrILFMJD7VU+A99C3DiWfhlveql9XKj4P0zF+vRPM
e/17ttGK8EuzHNY46IezQvaZVpJSS98csR9xiZGQMYXMbtqJfUaNP/ATdob0Ahph
pIKNYzpXRKDj1jd57sFSo4YmSYvGqILR4krZQnrtN7of9TNoC9YOXLYqxb/aGkl8
U7+u5xlcutth9JjK39+5MRHlfBWDuMGTVDwsQ1dV2daKP7sbnDyMil5VNcmf4SEt
xVRAW6sq+quEJOtbSpBjP45hzv4Zz6J2XL1oZrWnouMSPjdjPLZ92ntaeO9eYzJH
sBVwS7Tn70/SKoHyxL1s
=Uxlq
-----END PGP SIGNATURE-----

--CEUtFxTsmBsHRLs3--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
