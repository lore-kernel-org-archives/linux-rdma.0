From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 8/9] RDMA/hns: Remove unused struct members in
 hns-abi.h
Date: Thu, 28 Sep 2017 12:02:03 +0300
Message-ID: <20170928090203.GS2297@mtr-leonro.local>
References: <1506574654-56699-1-git-send-email-xavier.huwei@huawei.com>
 <1506574654-56699-9-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="TSQPSNmi3T91JED+"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1506574654-56699-9-git-send-email-xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lijun_nudt-9Onoh4P/yGk@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-WVlzvzqoTvw@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shaobohsu-9Onoh4P/yGk@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--TSQPSNmi3T91JED+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 28, 2017 at 12:57:33PM +0800, Wei Hu (Xavier) wrote:
> From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>
> This patch mainly deletes some unused struct members for
> hns_roce_ib_create_qp in order to match libhns, because
> the num of struct members of hns_roce_ib_create_qp must
> be the same with hns_roce_create_qp in libhns.
>
> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  include/uapi/rdma/hns-abi.h | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/include/uapi/rdma/hns-abi.h b/include/uapi/rdma/hns-abi.h
> index 5d74019..79251b6 100644
> --- a/include/uapi/rdma/hns-abi.h
> +++ b/include/uapi/rdma/hns-abi.h
> @@ -41,10 +41,8 @@ struct hns_roce_ib_create_cq {
>
>  struct hns_roce_ib_create_qp {
>  	__u64	buf_addr;
> -	__u64   db_addr;
>  	__u8    log_sq_bb_count;
>  	__u8    log_sq_stride;
> -	__u8    sq_no_prefetch;
>  	__u8    reserved[5];
>  };

It is classical UAPI breakage which kernel tries to avoid.

In RDMA, we do allow rename of fields from reserved to something, but
don't allow binary layout change.

NAK to this change.

Thanks

>
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--TSQPSNmi3T91JED+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnMuosACgkQ5GN7iDZy
WKfC6xAAuVA9BWnPNKSMlE/kAnUeigc4JeQfXPVVlCto3vjSVziTmiaZGm/Hx/aI
Be+lzTTvpJQXYENibZHAtevVZu9mILFpCZHEY8JmT6kPnY3t19XJjmyeVkNjrRaC
7rxhrFwPYqoexrPIkGUTY9yydXms74PU8PoXE1svSfDmoxhbR1Em0EuMKweNl4z3
20GDlfFTM26VmI9FQrq03s6oBrpOerqhmxjrNAPQLijs+wAF/iqb3qWp2nMT6J69
FxtmJJq99mhLmLaoQG0JSnxndFo3vhhrJ+afySGF0MIh2ygniNStD3gGFuQdv/m0
rUTejs1FCRmAfqBlaFoMJuAUbgu/7HF4FDsjMefvhZrGTrLmjjAH7TPm0iOlS+zG
cnsxfFNVF/mkvGs7VmRPqAykoY946mzfISCBof8hKJirdeLyKDySTAS7BOH+7MZj
KbtA5g65HiqZ0oqTxbgami3j/kVPj7IGnMaAPJUAatWRlMNU1DSyJpIjxo9U8RWk
XcfCdjVU5SK1yzL74yKKbyjlYnADvGcRwOA5Sdk411QXyI4lP+FAq5h1sCuEqFag
CREZRsA2ONtjjUqQpURymXxwnVtQD1IMRUdb5uajqDOjUdw9C3LxcZTeSvRGJ53H
U2zoOXFW1G3aVGN0pvAZeXSjTDdQaOEsMEZH6o4AnSKNq4mTnVQ=
=7E8p
-----END PGP SIGNATURE-----

--TSQPSNmi3T91JED+--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
