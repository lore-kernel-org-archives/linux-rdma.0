From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 3/9] RDMA/hns: Add return statement when kzalloc
 return NULL in hns_roce_v1_recreate_lp_qp
Date: Thu, 28 Sep 2017 12:13:08 +0300
Message-ID: <20170928091308.GT2297@mtr-leonro.local>
References: <1506574654-56699-1-git-send-email-xavier.huwei@huawei.com>
 <1506574654-56699-4-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="y/XsGip80ttrIE8G"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1506574654-56699-4-git-send-email-xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lijun_nudt-9Onoh4P/yGk@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-WVlzvzqoTvw@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shaobohsu-9Onoh4P/yGk@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--y/XsGip80ttrIE8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 28, 2017 at 12:57:28PM +0800, Wei Hu (Xavier) wrote:
> From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>
> When lp_qp_work is NULL, it should be returned ENOMEM. This patch
> mainly fixes it.
>
> Ihis patch fixes the smatch error as below:
> drivers/infiniband/hw/hns/hns_roce_hw_v1.c:918 hns_roce_v1_recreate_lp_qp()
> error: potential null dereference 'lp_qp_work'.  (kzalloc returns null)
>
> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> index 95f5c88..1071fa2 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> @@ -912,6 +912,8 @@ static int hns_roce_v1_recreate_lp_qp(struct hns_roce_dev *hr_dev)
>
>  	lp_qp_work = kzalloc(sizeof(struct hns_roce_recreate_lp_qp_work),
>  			     GFP_KERNEL);
> +	if (!lp_qp_work)
> +		return -ENOMEM;
>

You will treat this error in the same was as you will treat timeout,
which is wrong.

1656          */
1657         if (hr_dev->hw->dereg_mr && hns_roce_v1_recreate_lp_qp(hr_dev))
1658                 dev_warn(&hr_dev->pdev->dev, "recreate lp qp timeout!\n");
1659
1660         p = (u32 *)(&addr[0]);


>  	INIT_WORK(&(lp_qp_work->work), hns_roce_v1_recreate_lp_qp_work_fn);
>
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--y/XsGip80ttrIE8G
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnMvSMACgkQ5GN7iDZy
WKfWlg/8CsVXjBpueFM/+ABOwnQhPXSD9sKM6zv2jtxXnvfDGVYzkcv5fTy31s1A
adkYI7ExtR0b9XsbaCmcOkwozAmSeSP2ojx1jhhWWi6DDBZt2kd5iCyniUdUN2cz
tpC+ndzQeoZwU5p03X4hW+fzVz9qLemG039AzTmLvUQrAVl4FDTAjUvY3icxoq5J
8uT6KCv+wBS8r48TbGbEzhzuqykPTJss/h45N6JNDsUrbVxdQgxsvuwfRHSVY+JZ
qI+UrcuyGUP1eIesukaYjPs5A8IwXoecQQN/rOJyU3iDCFB5FSA5Rd31i9JvktAR
mjzp6pV/rs8edRKxeoeMaRmKZTLF/xNYFdQ02VQ8H64t201g87uqRtGn9LEK3cl+
aFFmvUz5sWeoUcWWTA1SVfHXetnFz1JXH0a4ctxJ9IpASU4+Noy8JXX0UwrCzty0
d5tt8/g5MRwtfFL0IvvEaV6xaso5uQTX7c6kCLURQjwM2sSBhAPdISqB77zvtXLr
oobpdZLpkTT0PWe1zxYfVQm06LsJsMEWuq7MCREpuucECeRMTV6nk1mmu8jxRdGY
xD8Sg+aoHeC9rQr1pYk59AKKfPNmFtuh1g9b1nWgCcY9kFxdX4ZXnt8ULrW7wAx7
DXt7PfaY1dmoN03bad3wiWVelaqYoLZSaXe3dblFHmLbBExmolk=
=5TZ/
-----END PGP SIGNATURE-----

--y/XsGip80ttrIE8G--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
