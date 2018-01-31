From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 1/4] RDMA/hns: Fix the endian problem for hns
Date: Wed, 31 Jan 2018 10:44:45 -0500
Message-ID: <1517413485.19117.14.camel@redhat.com>
References: <1517314845-126094-1-git-send-email-oulijun@huawei.com>
         <1517314845-126094-2-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-0TZJu+7oT3aBv4oQ3uWh"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1517314845-126094-2-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-0TZJu+7oT3aBv4oQ3uWh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-01-30 at 20:20 +0800, Lijun Ou wrote:
> The hip06 and hip08 run on a little endian ARM, it needs to
> revise the annotations to indicate that the HW uses little
> endian data in the various DMA buffers, and flow the necessary
> swaps throughout.
>=20
> The imm_data use big endian mode. The cpu_to_le32/le32_to_cpu
> swaps are no-op for this, which makes the only substantive
> change the handling of imm_data which is now mandatory swapped.
>=20
> This also keep match with the userspace hns driver and resolve
> the warning by sparse.
>=20
> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/hns/hns_roce_common.h |   6 +-
>  drivers/infiniband/hw/hns/hns_roce_device.h |   2 +-
>  drivers/infiniband/hw/hns/hns_roce_hw_v1.c  |  57 ++++--
>  drivers/infiniband/hw/hns/hns_roce_hw_v1.h  | 258 ++++++++++++----------=
---
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c  |  51 +++--
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.h  | 283 ++++++++++++++--------=
------
>  drivers/infiniband/hw/hns/hns_roce_main.c   |   2 +-
>  drivers/infiniband/hw/hns/hns_roce_qp.c     |  18 +-
>  8 files changed, 357 insertions(+), 320 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/hns/hns_roce_common.h b/drivers/infini=
band/hw/hns/hns_roce_common.h
> index dd67faf..319cb74 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_common.h
> +++ b/drivers/infiniband/hw/hns/hns_roce_common.h
> @@ -43,15 +43,15 @@
>  	__raw_writel((__force u32)cpu_to_le32(value), (addr))
> =20
>  #define roce_get_field(origin, mask, shift) \
> -	(((origin) & (mask)) >> (shift))
> +	(((le32_to_cpu(origin)) & (mask)) >> (shift))
> =20
>  #define roce_get_bit(origin, shift) \
>  	roce_get_field((origin), (1ul << (shift)), (shift))
> =20
>  #define roce_set_field(origin, mask, shift, val) \
>  	do { \
> -		(origin) &=3D (~(mask)); \
> -		(origin) |=3D (((u32)(val) << (shift)) & (mask)); \
> +		(origin) &=3D ~cpu_to_le32(mask); \
> +		(origin) |=3D cpu_to_le32(((u32)(val) << (shift)) & (mask)); \
>  	} while (0)
> =20
>  #define roce_set_bit(origin, shift, val) \
> diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infini=
band/hw/hns/hns_roce_device.h
> index 42c3b5a..2503d7f 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_device.h
> +++ b/drivers/infiniband/hw/hns/hns_roce_device.h
> @@ -466,7 +466,7 @@ struct hns_roce_qp {
>  	struct ib_qp		ibqp;
>  	struct hns_roce_buf	hr_buf;
>  	struct hns_roce_wq	rq;
> -	__le64			doorbell_qpn;
> +	u32			doorbell_qpn;

Why the change in size here?  Did you mean to go from 64bits down to
32bits?

>=20
>  		} else if (ibqp->qp_type =3D=3D IB_QPT_RC) {
>  			ctrl =3D wqe;
>  			memset(ctrl, 0, sizeof(struct hns_roce_wqe_ctrl_seg));
>  			for (i =3D 0; i < wr->num_sge; i++)
> -				ctrl->msg_length +=3D wr->sg_list[i].length;
> +				ctrl->msg_length =3D
> +				     cpu_to_le32(le32_to_cpu(ctrl->msg_length) +
> +				     wr->sg_list[i].length);

Minor nit:

Doing le32_to_cpu and cpu_to_le32 over and over again in a loop is
horribly inefficient.  It would be much better IMO if you had a local
variable to use for the length, used that in the loop, and then only at
the end of the loop do a single cpu_to_le32 of the local variable to
store in msg_length.  Same comment applies to the other spot in this
patch that does the same loop.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-0TZJu+7oT3aBv4oQ3uWh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpx5G0ACgkQuCajMw5X
L92lBhAArLOsKfPkZqncBMgL3Y1jK/AcOSsC1NXB2W5/2L9OZyRFVi3sj5kdLAO9
1FVn6tVgs4Q2tbQhvYi1UwSkNmNjrHd7BqTiLVdqUKn87dzU/pUSq9ATLZBmicm/
Ihar8g5O6yx2z89DPC8t/lSqwtWTjw6W9uD0EGeOv7aEgm1BxBBHCCEPns8vkD28
RkIoTsq81X1O5nQtFNz2k8JB+t6KkIq1PS7vm8l+o4AfCqFcNBF+EWRKp7FXC2JZ
J6x2ZHLfAcec5kiQaLe7YywE+zjbzRjkjgVREhWe3PJiFmjbe/j1gTX4nruo3ONC
hYXmX8QkXX5DtvUHv0Y+KrKVsun3iMiDC7yh21y9cS9D17AzEOVYLH50gYdHCeeP
8wauWcgaXY2DzE//AQHWzRZtEQPqosPaKJ70zC6zn7awibS1KvIZ8lQMfbqy3nrl
OsHgJ/oVGyEyyu58EYLi4AFp3iOVAr8rI6pF+/9uMCYU3M70rWM7tnwzYTJEdHwJ
a6J1U4IqNleOa6ASc27oMwOU5GWJ1fM4sljzaNR5D3ShtYdliU7iXwYzDlI9AFjo
018Gcgkw9NnxQfYPmbO/3zxJ007ytslO2RtJx2M2BA6MKqGm8HoBgjQgz8kGFwL5
09w+RXxzzJcaoV8Wg7ihhnBUlqqex0ftURwK9Nvb2eLoVFxOgqU=
=STY8
-----END PGP SIGNATURE-----

--=-0TZJu+7oT3aBv4oQ3uWh--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
