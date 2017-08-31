From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next] IB/core: Fix for core panic
Date: Thu, 31 Aug 2017 12:00:27 +0300
Message-ID: <20170831090027.GE10539@mtr-leonro.local>
References: <20170830191409.4386.45635.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="XuV1QlJbYrcVoo+x"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170830191409.4386.45635.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--XuV1QlJbYrcVoo+x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 30, 2017 at 12:14:10PM -0700, Dennis Dalessandro wrote:
> From: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> Rdma device driver may not have implemented (*get_link_layer)()

s/Rdma/RDMA

> so it can not be called directly. Should use appropriate helper function.
>
> Fixes: 523633359224 ("IB/core: Fix the validations of a multicast LID in attach or detach operations")
> Signed-off-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/core/verbs.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> index ee9e27d..123084a 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -1646,8 +1646,9 @@ static bool is_valid_mcast_lid(struct ib_qp *qp, u16 lid)
>  	 */
>  	if (!ib_query_qp(qp, &attr, IB_QP_STATE | IB_QP_PORT, &init_attr)) {
>  		if (attr.qp_state >= IB_QPS_INIT) {
> -			if (qp->device->get_link_layer(qp->device, attr.port_num) !=
> -			    IB_LINK_LAYER_INFINIBAND)
> +			enum rdma_link_layer ll =
> +			rdma_port_get_link_layer(qp->device, attr.port_num);
> +			if (ll != IB_LINK_LAYER_INFINIBAND)

Please do the same solution as you did below. There is no need in temp variable.

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

>  				return true;
>  			goto lid_check;
>  		}
> @@ -1655,7 +1656,7 @@ static bool is_valid_mcast_lid(struct ib_qp *qp, u16 lid)
>
>  	/* Can't get a quick answer, iterate over all ports */
>  	for (port = 0; port < qp->device->phys_port_cnt; port++)
> -		if (qp->device->get_link_layer(qp->device, port) !=
> +		if (rdma_port_get_link_layer(qp->device, port) !=
>  		    IB_LINK_LAYER_INFINIBAND)
>  			num_eth_ports++;
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in

--XuV1QlJbYrcVoo+x
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmn0CsACgkQ5GN7iDZy
WKeMWA//Q3hlWfWRdEJNa5uw1o93apfEoD3AVHRutgaFPCL06pJRTUCnsT51e567
BEK7TqbSz8pr7fENguavAh+VJU6Yj/ShO14GPu3ODOOArSOgAifZgt/DAQ4TD1wK
dZMgYJFGL/wQTylCGD32iTE5/jS+s85brL3UC1Atmj9MLcI2svdbIXkZCtLZ/M12
Q+bSRthswGNJvOch8SORdNdcmjV6Nwwv3VydENEZdv51lTyiXzx+40s0Kx3Tg5dr
GBW7GhZqtd/Vyeugm3mhfLCirbtx+w+Xy+4TnW+V41XRz0Jza9IiZNsrIHlE6UcW
36hawMopYDEXMjwcf2G53cGMg77T33STh4FIPQ98VTn5avld3/WwGuQRZXEAf4nE
M66wli8fvCoFGU4qwlQdc9paMrs+X1KLL0+TPddMxbpePxzkF4/XTi0V/Hdr8fOZ
r6b3E0x+Lvlx6zoX9MFO4FQFskJIvxdlaVZiv5ZBGUbSRKHynRTW6Ydf3HFNgEj/
i956Sqi3ZsbnH0vPzuQyk198DqGwFO+AArB8D3+gwLbtPVwpk6b9+m13BUHn+7pD
eDq7Fr/7q7uWloD3fRFL9fDu6LFVT2ZlgkqqVqPnma5Ty1Qs9A6CCy2oPNueKSVk
rDNnU+/WfgrvFJ3iXQp34wPEK9YnLLrqBEm8FXzrnfOA0WO1vcI=
=tohZ
-----END PGP SIGNATURE-----

--XuV1QlJbYrcVoo+x--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
