From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 3/4] RDMA/hns: Update the IRRL table chunk size
 in hip08
Date: Sun, 1 Oct 2017 08:40:37 +0300
Message-ID: <20171001054037.GB2031@mtr-leonro.local>
References: <1506763741-81429-1-git-send-email-xavier.huwei@huawei.com>
 <1506763741-81429-4-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="LyciRD1jyfeSSjG0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1506763741-81429-4-git-send-email-xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lijun_nudt-9Onoh4P/yGk@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-WVlzvzqoTvw@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shaobohsu-9Onoh4P/yGk@public.gmane.org, shaoboxu-WVlzvzqoTvw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--LyciRD1jyfeSSjG0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Sep 30, 2017 at 05:29:00PM +0800, Wei Hu (Xavier) wrote:
> As the increase of the IRRL specification in hip08, the IRRL table
> chunk size needs to be updated.
> This patch updates the IRRL table chunk size to 256k for hip08.
>
> Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/hns/hns_roce_device.h |  3 +++
>  drivers/infiniband/hw/hns/hns_roce_hem.c    | 31 ++++++++++++++---------------
>  drivers/infiniband/hw/hns/hns_roce_hw_v1.c  |  1 +
>  drivers/infiniband/hw/hns/hns_roce_hw_v1.h  |  2 ++
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c  |  1 +
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |  2 ++
>  6 files changed, 24 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
> index 9353400..fc2a53d 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_device.h
> +++ b/drivers/infiniband/hw/hns/hns_roce_device.h
> @@ -236,6 +236,8 @@ struct hns_roce_hem_table {
>  	unsigned long	num_obj;
>  	/*Single obj size */
>  	unsigned long	obj_size;
> +	unsigned long	table_chunk_size;
> +	unsigned long	hem_alloc_size;
>  	int		lowmem;
>  	struct mutex	mutex;
>  	struct hns_roce_hem **hem;
> @@ -565,6 +567,7 @@ struct hns_roce_caps {
>  	u32		cqe_ba_pg_sz;
>  	u32		cqe_buf_pg_sz;
>  	u32		cqe_hop_num;
> +	u32		chunk_sz;	/* chunk size in non multihop mode*/
>  };

Hi,

I have two comments:
1. In this code table_chunk_size is equal and similar to hem_alloc_size.
Please don't introduce unneeded complexity.
2. The size of table is num_obj * obj_size, there is no need to
table_chunk_size and hem_alloc_size at all. There are plenty of macros in
the kernel to deal with the tables.

Thanks

--LyciRD1jyfeSSjG0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnQf9UACgkQ5GN7iDZy
WKdPBA/+OO1rSm3dWg8Ly3G7tv00S6cepQ679XZAiDmNA9XRJt9M450eLhagxah1
QU+mSXK4Kt4fIue8H7edwXkz7JJgp0/NLtgiqkJzrXFhufVYwSmHHRljrwI6gMAc
eZi+k3gzgYBIYQ3iYssQSqzLjBym50BmXDPe48U1erTCGMs4mcr6lsvHgtfGHNBY
ZGLiN8LFgGrFOQ47ImKxVEvSh7TRF7NDmMK/+5m0m6u7x3kC7J4R9gB5Mf7Gnha9
ubxxLHogFMkKMBe2C5/S3Fz98CF4Y+thi9+m7utMFBxz+EtvqEjv8YM1KI4bVtZ6
pDJrDwVG8tBBa7YtDD4milaq2Kg+yk+WTcZdFI2sOp2K2pNq3BwSL2HQRXBWJGnT
rX8x7yXz6NIPaObSY1Uq/9ytIkrq5r2gd912Kp887OaEI2L7CmDj7jVLrSkLsEMe
yqhjwrhRDFoJ9AK1QT8L+k5qPl5ZwO1kJdaD/6qDZSMQ0iAjabhob87eOJksw28W
joBYuSYuN84xW+kCx1yktOUDqA1ZPHhvvMUMIbEZQsACCzmyEp5sHLC5z3wMtJp8
iLieMK1OMv4pjExmTEVukATbXdZ0SyeXme1q90sEn6LrrdOURPhRCs8al1NzMYCK
sfSJ8GLZxwgd1kVPG9NI3JiNqyKx+IrhwR3NQCtI8kF4b89a82E=
=pky9
-----END PGP SIGNATURE-----

--LyciRD1jyfeSSjG0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
