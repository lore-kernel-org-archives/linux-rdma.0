From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next] RDMA/hns: Delete the unnecessary initializing
 enum to zero
Date: Fri, 15 Sep 2017 09:36:25 +0300
Message-ID: <20170915063625.GD3405@mtr-leonro.local>
References: <1505443749-68733-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="o/5eNASeIIpuMggS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1505443749-68733-1-git-send-email-xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lijun_nudt-9Onoh4P/yGk@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier_huwei-9Onoh4P/yGk@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--o/5eNASeIIpuMggS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 15, 2017 at 10:49:09AM +0800, Wei Hu (Xavier) wrote:
> It deletes the unnecessary initializing enum to zero.
>
> Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
> This patch is based on the patchset as below:
> [PATCH for-next 00/20] RDMA/hns: Add hip08 RoCE driver support,
> the related link:
> https://www.spinics.net/lists/linux-rdma/msg54098.html
>
> This patch addresses the comment at Leon's suggestion.
> https://www.spinics.net/lists/linux-rdma/msg54392.html
> https://www.spinics.net/lists/linux-rdma/msg54400.html
> ---
>  drivers/infiniband/hw/hns/hns_roce_device.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--o/5eNASeIIpuMggS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlm7dOkACgkQ5GN7iDZy
WKdLCg/9G0d47HdFzMH8Iq1a9zgbb3Hb/9DXmbeVKKHQidEumEGtEJMqiSGcDjFQ
5E2ajJ7dFVFC8qru6KNjWhPGkLNcKhbUWCpg3ukXvap7U9ORd1OElrP4k1HWc1EK
/pUl86ZQM7JaCU58A3GlTY0+k80D9slKbw8CHAee9UCW9/Y0/0OPHJoC2sntLkhJ
8QcDqIhKKHpnu4qiIAZIK8HiLQsQe3KfRAY9aNssHUgCONmRCFYflIBtTtoq8Cyk
0Zy5Hxw92ANlFaT+UnSnythoPTGY05M0TUIyXVUPqTpbwQ2cgUVsO9cxfEuW2IXw
++OulTY9Qi3+L6mHwJvDkdBm5g4Mb68j3p9CbVXq7kepJQJVRK47/YV8FGfLKdPT
yMnB6JdfY3Za5d0IFlppm8CGsaO90/Zna5dASjOJ6UFVTtYOZ0HI+l4uNeViB2BS
RLG13GRuLkXmGs+Q2eu2ZetifJQY7ptkckecVpLqWjbB/LVU3jJZwo6HZzJD4nzB
GMHnR9SODE1vCIq2K1FmZrwZfxZs65uwoCWBZutROrntUFBLHQmYC0XmPeELHeZ4
TSo1WzKS0lKDaagPZmPjEz/NCLpfKNkBV0d8Cf6iPoPhr9+k7CG4ohAc+0A8vdvu
Uy6UAN7d5mIYJJT2YLRBrLhiJki9zVdn7dezMudm6jca0x9u7qU=
=cKH6
-----END PGP SIGNATURE-----

--o/5eNASeIIpuMggS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
