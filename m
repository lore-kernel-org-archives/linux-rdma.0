From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [infiniband-hw-i40iw] question about identical code for
 different branches
Date: Thu, 18 May 2017 08:00:29 +0300
Message-ID: <20170518050029.GY3616@mtr-leonro.local>
References: <20170517170654.Horde.cfktFjC4G4wPJvJ8X1ZyUvW@gator4166.hostgator.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="D5arhb13WwWKLIR9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170517170654.Horde.cfktFjC4G4wPJvJ8X1ZyUvW-fU+oOHjIBR1LoJgMfuPDHBfZZeVsHd8q@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Gustavo A. R. Silva" <garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>
Cc: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--D5arhb13WwWKLIR9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 17, 2017 at 05:06:54PM -0500, Gustavo A. R. Silva wrote:
>
> Hello everybody,
>
> While looking into Coverity ID 1362263 I ran into the following piece of
> code at drivers/infiniband/hw/i40iw/i40iw_virtchnl.c:445:
>
> 445        if (vchnl_msg->iw_op_code == I40IW_VCHNL_OP_GET_VER) {
> 446                if (vchnl_msg->iw_op_ver != I40IW_VCHNL_OP_GET_VER_V0)
> 447                        vchnl_pf_send_get_ver_resp(dev, vf_id, vchnl_msg);
> 448                else
> 449                        vchnl_pf_send_get_ver_resp(dev, vf_id, vchnl_msg);
> 450                return I40IW_SUCCESS;
> 451        }
>
> The issue is that lines of code 447 and 449 are identical for different
> branches.
>
> My question here is if one of the branches should be modified, or the entire
> _if_ statement replaced?
>
> Maybe a patch like the following could be applied:

It looks like that you can replace I40IW_VCHNL_OP_GET_VER_V0 with
I40IW_VCHNL_OP_GET_VER and get rid of all places with
I40IW_VCHNL_OP_GET_VER_V0.

Thanks

>
> index f4d1368..48fd327 100644
> --- a/drivers/infiniband/hw/i40iw/i40iw_virtchnl.c
> +++ b/drivers/infiniband/hw/i40iw/i40iw_virtchnl.c
> @@ -443,10 +443,7 @@ enum i40iw_status_code i40iw_vchnl_recv_pf(struct
> i40iw_sc_dev *dev,
>         if (!dev->vchnl_up)
>                 return I40IW_ERR_NOT_READY;
>         if (vchnl_msg->iw_op_code == I40IW_VCHNL_OP_GET_VER) {
> -               if (vchnl_msg->iw_op_ver != I40IW_VCHNL_OP_GET_VER_V0)
> -                       vchnl_pf_send_get_ver_resp(dev, vf_id, vchnl_msg);
> -               else
> -                       vchnl_pf_send_get_ver_resp(dev, vf_id, vchnl_msg);
> +               vchnl_pf_send_get_ver_resp(dev, vf_id, vchnl_msg);
>                 return I40IW_SUCCESS;
>         }
>         for (iw_vf_idx = 0; iw_vf_idx < I40IW_MAX_PE_ENABLED_VF_COUNT;
> iw_vf_idx++) {
>
> What do you think?
>
> I'd really appreciate any comment on this.
>
> Thank you!
> --
> Gustavo A. R. Silva
>
>
>
>

--D5arhb13WwWKLIR9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkdKm0ACgkQ5GN7iDZy
WKcHZhAAqoDZ/O7GJGRil8xIChuRUND0OP9LrbgbMrJ4OH1ObvQCZpYlUOH7ZpNo
jj+FDvFeapwj6NsuNcQBqFXjxy7/ZnMo9BoIgvJHM6Y+YsdOG+JOWhAKukyS0JC0
HicjVNH05tGZZY+YequJ15JoulOj4rDJqeqVrhP9WVj/zhZk5fOpn4zosu9OWt4C
sWyLsE9W2IOxCalIykFjbdZebqSC1smcPnszeUweHvDKSZwIzKvnwauYim5UdOay
t3RKa4hj90pBSTGQvR9Sy0qDhDE7W9IjdYDPq3m8VhXLPnNbkwwhv/QYRXoBrKyU
X9222DjMPow0Q5nxzT51NM99cxO4ghCup0vM4pwJbPZnfjWRWdzbaHQHXqnGKGDr
Eq9x+mLopnwKySTnh+1X/yjAHU0cQHPOsKdCuULziR38LwMqb8z2us45STqt96w4
UrtLHk5nj7eqwsfotm6OIMsezFXizNbcxJyXmSI1lZCOkwtoIjuG5T6OyxsU37ml
mKsnWdF4f4bcoaSaAkqDGEvuYawEmkvzcLyKwpn/NZ3Mz3NGHgbb6KRZ/zZbQyuq
xtzQ5V/T5mKqQRZ9haO8Z7KwI0mP2Lv42yBFAOCc6ugGlwStxx01RZKpLgcDaJBJ
jHdcX4ICnD5yMNFf91X6TzyIHlaIlERSVDTLDRN1F84o1e/geOY=
=Sc4q
-----END PGP SIGNATURE-----

--D5arhb13WwWKLIR9--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
