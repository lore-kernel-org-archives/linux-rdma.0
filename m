From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] RDMA/hns: Use 64-bit arithmetic instead of 32-bit
Date: Thu, 18 Oct 2018 14:01:55 +0300
Message-ID: <20181018110155.GH5007@mtr-leonro.mtl.com>
References: <20181018080258.GA1720@embeddedor.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="f2QGlHpHGjS2mn6Y"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181018080258.GA1720@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Lijun Ou <oulijun@huawei.com>, "Wei Hu(Xavier)" <xavier.huwei@huawei.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--f2QGlHpHGjS2mn6Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 18, 2018 at 10:02:58AM +0200, Gustavo A. R. Silva wrote:
> Cast *max_num_sg* to u64 in order to give the compiler complete
> information about the proper arithmetic to use.
>
> Notice that such variable is used in a context that expects an
> expression of type u64 (64 bits, unsigned) and the following
> expression is currently being evaluated using 32-bit
> arithmetic:

And what is wrong with that?
Please fix static analyzer tool instead of fixing proper C code.

Thanks

>
> length = max_num_sg * page_size;
>
> Addresses-Coverity-ID: 1474517 ("Unintentional integer overflow")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  drivers/infiniband/hw/hns/hns_roce_mr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
> index 521ad2a..d479d5e 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_mr.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
> @@ -1219,7 +1219,7 @@ struct ib_mr *hns_roce_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
>  	int ret;
>
>  	page_size = 1 << (hr_dev->caps.pbl_buf_pg_sz + PAGE_SHIFT);
> -	length = max_num_sg * page_size;
> +	length = (u64)max_num_sg * page_size;
>
>  	if (mr_type != IB_MR_TYPE_MEM_REG)
>  		return ERR_PTR(-EINVAL);
> --
> 2.7.4
>

--f2QGlHpHGjS2mn6Y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbyGgjAAoJEORje4g2clinEbgQAMQxaoNws6n8a+P3oQPc32fT
jdbDLhhgQZYnVRVn4i4kRegae1ipUfHO99CJHioqmtfARMuHIPJY+lISRc3w4YEq
0CKM6Ej8C9vrORCTeBHxfTER6YeglanT4X4hvqxlbtsyLwqCSa0+uhCTIrmw9gfC
DDLd43l468YfiNTB0DgoKnqL3DhrzvV4y+LpNautd5nGx+toZh1wTxoCZphuzio/
zCZhpbrr8HrjLzDreEXLkdhgzHajN2z3t09Dfgr0hVefs3Wjj+v6g6AU5t0d6Cf5
O+xKjS+fFBejOAhKQ+h9oq/isYrV9PYSrQwydas/53XSf/AnHXJJo7zq0sD41/BH
dviY6lvJ0awXiRua9A2nzewEYQ7PZThodPlx+IuYj0y49o7+Md4UwNOyngzy7nsd
6sLU/MDoNBiQyizBRd+VblcuzJ5dLotGHFGuRVZYFZZZztojTpF/i1lYG26qK3Gv
mYOEakKYXe4iFAfUaiYEIvbAr1cZG43eLYeZuUzWgAtwP7FD9C/Ifj24iyPToqD+
hgvomTPwGCGfkuXijLDUFVNDbJ95inCVSDS0pF3xHmovH1DGp1TXTQdq0orGKiAm
uV0UA8kKIsHMt2z7Dk6JKj2nXggfGQJI/IJYjqoumpbNLc3TRWIgmDG5Fo03qzoq
pXHiJeMR0FXDV6i7FCCE
=1ivn
-----END PGP SIGNATURE-----

--f2QGlHpHGjS2mn6Y--
