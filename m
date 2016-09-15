From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 03/20] IB/hns: Add the check for pointer ctrl
Date: Thu, 15 Sep 2016 13:07:57 +0300
Message-ID: <20160915100757.GW26069@leon.nu>
References: <1473417051-99560-1-git-send-email-salil.mehta@huawei.com>
 <1473417051-99560-4-git-send-email-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="hSsVBZHIO2Q9XETc"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1473417051-99560-4-git-send-email-salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--hSsVBZHIO2Q9XETc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 09, 2016 at 06:30:34PM +0800, Salil Mehta wrote:
> From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>
> The pointer ctrl may be null, so we add check for it.
>
> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Wei Hu <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/hns/hns_roce_hw_v1.c |    6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> index 5f76fc1..ea47ec4 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> @@ -336,6 +336,12 @@ int hns_roce_v1_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
>  		}
>
>  		ctrl = get_recv_wqe(hr_qp, ind);
> +		if (unlikely(!ctrl)) {

Yes, as you wrote, this check and patch are redundant too.

> +			dev_err(dev, "Get recv wqe failed!\n");
> +			ret = -EINVAL;
> +			*bad_wr = wr;
> +			goto out;
> +		}
>
>  		roce_set_field(ctrl->rwqe_byte_12,
>  			       RQ_WQE_CTRL_RWQE_BYTE_12_RWQE_SGE_NUM_M,
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--hSsVBZHIO2Q9XETc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX2nL9AAoJEORje4g2clinZmMP/im4M9pdOpBR/vDGAf3ZqRq4
1pnQHNkUXP8+NO8DHAiWHRazz0+yGB80kPheumaDQdObK9/9mVzxZABtluT1TXqJ
ZF4GSCzUCqEf9OpPFxKSvAj4o9DoTNsAkJnUpdrW7g3TyJvvmG+zW1L/9CFVIxUt
UCpEZQoPS8shmB/BINlBuBYgMk+bZAotHeo1DgFFJjYAwuHco3eIwPuhyyjyaTK4
wR0SILcczDlg19PbqfbFK3eAX/if2HFmoVPRb1qWHi9kKXpNmdRLXdA8I4jgB5Da
Xtz+DGPVrjxxlv5i1g2/wv/a0V8Z6ePcLbESFdwNJRHe3AWzt5bsHh5F5V9ewtm3
lIOAw2CGMe6Wt1ATL9aLSKnLlJtLzTgT4v0M8CtCmj2viDmGbRxGGXLVNSPzULgg
BA9GN4E3YKdjDfbhpERrPIq34zHqj3HYxlXVE0om/dt9z7K+Lp2nhhH6do59uvBc
2Txls9++u2OiWg3jSpPxdwVZ1xzkR2duNcEn2TNF3xWzgBkI4ZMj73wSH5Sfe1rV
kGeNsf5E4IWnhi9R+CPtV2J3TgzT6djBH9T0JwJOLlU9ZlVavbOEKvU+uMWBNttA
vlAwHFrva16z+I7TLLEmIvbTqpgDOPXv9aMbfWZ9zvzz48GrJysSS+iUFvjVFEIm
tTUthHwCYEdMdidZaruD
=pkJw
-----END PGP SIGNATURE-----

--hSsVBZHIO2Q9XETc--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
