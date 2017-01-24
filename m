From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/5 v2] qedr: remove CQ spinlock from RDMA CM completion
 handlers
Date: Tue, 24 Jan 2017 17:24:58 +0200
Message-ID: <20170124152458.GJ6005@mtr-leonro.local>
References: <1485258638-11884-1-git-send-email-Ram.Amrani@cavium.com>
 <1485258638-11884-4-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="QDIl5R72YNOeCxaP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1485258638-11884-4-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--QDIl5R72YNOeCxaP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 24, 2017 at 01:50:36PM +0200, Ram Amrani wrote:
> From: Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>
>
> There is only a single event queue that triggers the completion
> events for the RDMA CM and it is being processed serially. This means
> that inherently there can no parallelism of CQ completion handler.
> Hence the lock is redundant.
>
> Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/qedr/qedr.h    |  3 ---
>  drivers/infiniband/hw/qedr/qedr_cm.c | 10 ++--------
>  2 files changed, 2 insertions(+), 11 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--QDIl5R72YNOeCxaP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliHccoACgkQ5GN7iDZy
WKfUVw/9Ht2RbmNoqwXQGbDco1y8q2fzl96CUNlN3H9QRfOSDcBLxh8SdOP0vONZ
WVt0K0teIOJyGj/8SWzLWPFN3StUuMEE/ibKlzdhdO+HrxFf/8yHZaxlblMBGFbV
C9sqU7yXiv/3bUhWTmVUXfKUt0wQlSoDelVvdSCYq1szKRh2XJKwPI49W3fisLXq
Jv36pdd3luJ6R24+jqlWvSUO/AGeXPqhxYvXJNdXFAz4goIJ6wEXQtFZdjglwtQ5
cF12tcUpz9MUP8VcFrKw8zQfyWRV+7Upgfra45e4P1v21r5Cf1M1Z54zanVxbvnR
tZGGLcU5riHiIzJO8GXscFGl3R+AReUwKt6/wQBr2DTq6wmrbN5oC00bUAsfT0k9
XRc7es/EWArnQD5JoPP7oe282U461jTBgX5liqfHBDAE8ssmtrE+LCVADM8QkGMG
jAtAi7giOEklNGsT5GTTDdmbnMwYI0DFAVBmX9WjrX/kq8sHQz4OWaDfj/meR/wC
CEdqa8jjOdErLAKUrjHzZJ7EYfLnZKcz9tHz1+h32a/QRnQsfc8DGJbuSfFWcIxD
Loz6UgPE0h8BtthEXtHIzslrDOl9GAddU3pFm4Smn5GFd+9MyKodh2XUTKpVH7QJ
P806+f1D0zSlsZFB3FRJ3EbBm+Jm7qMUO5PYqR1wV/xA2nUMIPA=
=3OXy
-----END PGP SIGNATURE-----

--QDIl5R72YNOeCxaP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
