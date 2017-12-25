From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 4/6] RDMA/hns: Filter for zero length of sge in
 hip08 kernel mode
Date: Mon, 25 Dec 2017 11:00:28 +0200
Message-ID: <20171225090028.GY2942@mtr-leonro.local>
References: <1514017342-91468-1-git-send-email-oulijun@huawei.com>
 <1514017342-91468-5-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Zqu75NDXmDJGUu04"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1514017342-91468-5-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Zqu75NDXmDJGUu04
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Dec 23, 2017 at 04:22:20PM +0800, Lijun Ou wrote:
> When the length of sge is zero, the driver need to filter it
>
> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 29 ++++++++++++++++++++---------
>  1 file changed, 20 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> index 869e36f..a1d8ca0 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> @@ -230,26 +230,37 @@ static int hns_roce_v2_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
>  				     V2_RC_SEND_WQE_BYTE_4_INLINE_S, 1);
>  		} else {
>  			if (wr->num_sge <= 2) {
> -				for (i = 0; i < wr->num_sge; i++)
> -					set_data_seg_v2(dseg + i,
> -							wr->sg_list + i);
> +				for (i = 0; i < wr->num_sge; i++) {
> +					if (likely(wr->sg_list[i].length)) {
> +						set_data_seg_v2(dseg,
> +							       wr->sg_list + i);
> +						dseg++;

Actually, you don't need to advance desg and keep your "desg + i" code as before.

I have a more general question, is this scenario (having length == 0) real?

Thanks

--Zqu75NDXmDJGUu04
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpAviwACgkQ5GN7iDZy
WKdFLw//XySslGJZTwpu8mEyZ2CLaBNVdIfNRH6LzsTooNBnWlOYaHYMVswCLK6F
75DnwVdo5OWtX1cnqxSsQhOsW1qSlgphGBmT/7WfcZNaNSBf5ifHTzhAqyApVHTE
h9JeUYi8ZBPRJ0iiu//JbA/ikGDTtiEpulPb5bTQ6Xe9UkQeZR9hcXiPzyMnqns/
3bGtc3w1o4YgBOM71R5ET8wK+ccPEYDlPmH68UKic6hvTi0aPOcmmkpthB//K5lx
bFRoaRSE8OVCTJ+00AdVfH0CyPnSpKwrJzM3zpY/hMquG3Y42FZZbsGnQpo83zl6
rM5+tx6+Jlg2vhRC7Pzorff/2oVVpiKZo7fYYz2bfWGTttZqOMaKBTqOGzPME9gE
qG6M5WpypIvlRoQYahrkOaaFhl44o5GH8jRtEGeM/syAou//w3ac2snpxWYkcMBO
eohFmhud2U/jq0TPH1GF+GS+FpjiG1fmckt8Z5rU0b7coPpaRz5QQd/ejj3eCL3q
4bwhnzWa1ZYTGFpfk5T2f++soYnd3b4DRs4KAeO/IcFXkEX6YZ8CnYurP3S9oklZ
6LCDlMIkRHM6L/d6PZXNwg5H/rVOHmWmLz22IzwFgiZKUUvk1nGyrBLQBQSk89Hv
x+Frvf9zQJ47q2bS+R35rzp5I+jpPsQ36vtRLi3HA+8Y0RW8bhE=
=rhWK
-----END PGP SIGNATURE-----

--Zqu75NDXmDJGUu04--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
