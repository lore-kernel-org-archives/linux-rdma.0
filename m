From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next] RDMA/hns: Remove unnecessary
 platform_get_resource() error check
Date: Wed, 17 Jan 2018 13:45:20 +0200
Message-ID: <20180117114520.GK13639@mtr-leonro.local>
References: <1516188518-147200-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ogUXNSQj4OI1q3LQ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1516188518-147200-1-git-send-email-weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--ogUXNSQj4OI1q3LQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 17, 2018 at 11:28:38AM +0000, Wei Yongjun wrote:
> devm_ioremap_resource() already checks if the resource is NULL, so
> remove the unnecessary platform_get_resource() error check.
>
> Signed-off-by: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 4 ----
>  1 file changed, 4 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--ogUXNSQj4OI1q3LQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpfN1AACgkQ5GN7iDZy
WKc30BAAhcQBR/FVRrILhYTdy1oILKsOmOZcSB5/FEGaw6Y/Ono8Tz4Up6WPxN+h
KuyqcfkSwUKwbUm+8QjmXA+Tzs7ZYFHkfggXS4O3rNUqnYzdT2fBwrj05KRryCUm
qxUwF68RQhS+iJwkDrn6Px299fIi/mrT7yCs1TLVAvxlPVSP//SdFftfW/CZ6yaB
cLWH0VsqgCwleRykMqG3sHIJGxGE2Bub7AtnZs2O5VlMboKXhbzfj2tiEd5nIHd+
Gi+Z9eH70ydmh8o4pyq+RThckP46IOL6ptDHkw65tBzy4zUnrqMP/26lmhfNDcCG
M3LXENFqH4DVQEeqgkj7Kv3L6pepggMdXduhWWVByt1P9mI97IJb6XDUp9M8FrUi
vmElx2ZJInJ+zfWyVFlVGE0pCUb/5dnvoWabhGYcSoHQ+z6wxp4l9YLATth9ljAE
1K4yCUcYEarzeWvwLVqwKSi1sRoPYicM1CKHfb7zLp4Ui97JhdI20FNTFMY8QwKP
staxIAFzVkAbE4QZYmyZevEqATRcQ2Y/YSQMP3JdU1zDU2dvsaOFwYOJ5QT3p5Mq
lNumUvzhQlvjVJl0+JqG13+9XbZD4OvQgIK4NmIKsw+G3w427gAbaZnKlQZTzI8h
IR7FhNfMPBqdGrKRXymvKBk7KafGpMZWbl9vQQ+dWoGmjLSPRpI=
=62nm
-----END PGP SIGNATURE-----

--ogUXNSQj4OI1q3LQ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
