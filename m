From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V2 rdma-core] libhns: Update the size and member order of
 hns_roce_create_qp structure
Date: Mon, 2 Oct 2017 08:51:35 +0300
Message-ID: <20171002055135.GI2031@mtr-leonro.local>
References: <1506889029-25168-1-git-send-email-xavier.huwei@tom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="h22Fi9ANawrtbNPX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1506889029-25168-1-git-send-email-xavier.huwei-WVlzvzqoTvw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wei Hu (Xavier)" <xavier.huwei-WVlzvzqoTvw@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, haifeng.wei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--h22Fi9ANawrtbNPX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 02, 2017 at 04:17:09AM +0800, Wei Hu (Xavier) wrote:
> From: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>
> In order to keep the size and member order with the
> hns_roce_ib_create_qp sturcture of the kernel driver,
> it needs to update hns_roce_create_qp's structure
> members. Otherwise, it will run fail.
>
> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
> Patch V2: Address comments by Jason:
> 	https://patchwork.kernel.org/patch/9979299/
>
> Patch V1: Initial Submit
> ---
>  providers/hns/hns_roce_u_abi.h | 2 ++
>  1 file changed, 2 insertions(+)
>

Thanks, applied and completely rewrote the commit message.

--h22Fi9ANawrtbNPX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnR0+cACgkQ5GN7iDZy
WKdsuA/7BrV+eF2P/X6S/0Mtm6kxW9qV0h1PErWgyp9rYplkhF+/4ffHIrdikWi9
Yc1nF6M2co6kGZnUZyUwsLISl+zZk1q30mjg4THWM1nUd0F9IHFsOwq5Fqgr64mO
jRK/wkoiOn/N0ONHXbQ5wqQhYWmeZcEO88VQEyRcub5qenB3UNTcAxE4lZj5O6gG
Cc80HlYu/FOjNuLf51QYFlpe0hn+XiaSzS2AFMxqA1NEkKEG62lZHqCYE6U2zZb+
jB+sswaD4Oy/UMOcqg7FaWiMsst0pNb0kA43+PwJlRKjHpxz0oRepM/W8Z4DylDr
jV3hdOoOeaQ0y8JVNa/xYHyk/5/71ajEGXdYb2928A6RkEzeeK8FtHdXS2QmF7WW
vyEd3QOdg6lrZ5GE0V2NP1wwW5FUBaOouzGQmDxtNfkLbaPBMbFyWnMoGx3sN7we
+63NqZS7Nz8J6c9yuFem0ol43eQr0mR5g3Uh+R6JLiglVoxdcDQJmGwQaZVcgiDE
e1SLpkA1gDe/lPkeE3XOWKx8i1ceSDBkvHhnijZUq8SvGV9kBurl3UyYLJwggRSB
8VNnUpgOthy+/7Y3B/XKWU85mQdXkByccFrcFJsfcO4RFF4gyWSF+Z1LizkG7MbM
LgLrC0J3YoR9YbsGB5IGwtVPOg5Y7oGAJYCxfoTnx7omdbMrRkM=
=y+/t
-----END PGP SIGNATURE-----

--h22Fi9ANawrtbNPX--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
