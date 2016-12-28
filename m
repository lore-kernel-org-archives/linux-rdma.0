From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/3] IB/srpt: allocate ib_qp_attr on the stack
Date: Wed, 28 Dec 2016 14:57:56 +0200
Message-ID: <20161228125756.GG26885@mtr-leonro.local>
References: <1482922813-8392-1-git-send-email-maxg@mellanox.com>
 <1482922813-8392-3-git-send-email-maxg@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="t4apE7yKrX2dGgJC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1482922813-8392-3-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: bvanassche-HInyCGIudOg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--t4apE7yKrX2dGgJC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 28, 2016 at 01:00:12PM +0200, Max Gurtovoy wrote:
> No reason to allocate it dynamically.
>
> Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/ulp/srpt/ib_srpt.c |   18 +++++++-----------
>  1 files changed, 7 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index 0b1f69e..aa18d74 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -984,24 +984,20 @@ static int srpt_get_desc_tbl(struct srpt_send_ioctx *ioctx,
>   */
>  static int srpt_init_ch_qp(struct srpt_rdma_ch *ch, struct ib_qp *qp)
>  {
> -	struct ib_qp_attr *attr;
> +	struct ib_qp_attr attr;
>  	int ret;
>
> -	attr = kzalloc(sizeof(*attr), GFP_KERNEL);
> -	if (!attr)
> -		return -ENOMEM;
> -
> -	attr->qp_state = IB_QPS_INIT;
> -	attr->qp_access_flags = IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_READ |
> +	memset(&attr, 0, sizeof(attr));

This line will not needed if you initialize to zero this struct attr at the beginning of function.


> +	attr.qp_state = IB_QPS_INIT;
> +	attr.qp_access_flags = IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_READ |
>  	    IB_ACCESS_REMOTE_WRITE;
> -	attr->port_num = ch->sport->port;
> -	attr->pkey_index = 0;
> +	attr.port_num = ch->sport->port;
> +	attr.pkey_index = 0;
>
> -	ret = ib_modify_qp(qp, attr,
> +	ret = ib_modify_qp(qp, &attr,
>  			   IB_QP_STATE | IB_QP_ACCESS_FLAGS | IB_QP_PORT |
>  			   IB_QP_PKEY_INDEX);
>
> -	kfree(attr);
>  	return ret;
>  }
>
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--t4apE7yKrX2dGgJC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhjttMACgkQ5GN7iDZy
WKcONw//YjCS0oM7MZD2CpnLBhpwv4plOBN5PeOUmWut7rJFOIV9a4sWjjijdehV
4TrASKLwmvJrmMgxFp7FXzbg+AFoIlkSJNmOVpt7bErrJWURDdE63Bj/bWSicbvG
y0y+LXGoSc/xJEjJjIbNLPRdwoH82dz6fZAbJ1MhZYbEbZjAvaFIV0iOpJA4wvsp
rW9VahLp1bmTPnaiviFjIWNKzGpngsBUe74sRH6P0e379kDT4+pUxnk/76X+5ox9
CM5cmLcXcvi0fxNV1DQbfhMUnROM/4xONJa9sHGyDwPNk2Kf2M14x71RDTlUwMz1
gkgOGaN72vuJLTzRpgxClAMUw+dpY+DEblGSBXeB39Y+L504oecbJViGnau4O1fC
r/lA4tSfqkprht5boHa0FQyNSytv2JHyyyw3mjdFXovAXVLwXf7TLZ99JQfiiOwE
6V/2IWWXE3o98VVLxf63+roHn92CL0k5zmgJYiZ5MOOlxF3cPpuDvS/aDq1hQT2p
FShGDpOZocXnEyHBqg0OL6wa42duAgYUIcPtE/rUMSH/Lfj4vBKuLV1DIB4xYG4r
7BSDYr0Jv+4V/m3uaXlYK8oNAabCtsKz8ehSBQnmxRHZ/FtJcDtphdDX5gMwaPOe
6KMQqYkY1pPpXgn6QQ6klpsHTt18XVUd6Vlc7j4YOQOQiucAbC4=
=+3Wu
-----END PGP SIGNATURE-----

--t4apE7yKrX2dGgJC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
