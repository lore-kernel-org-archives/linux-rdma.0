From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] infiniband: hw: cxgb4: Use AF_INET for sin_family field
Date: Sun, 25 Dec 2016 09:49:33 +0200
Message-ID: <20161225074933.GB14356@mtr-leonro.local>
References: <1482543875-17141-1-git-send-email-mayhs11saini@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="24zk1gE8NUlDmwG9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1482543875-17141-1-git-send-email-mayhs11saini-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shyam Saini <mayhs11saini-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--24zk1gE8NUlDmwG9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Dec 24, 2016 at 07:14:35AM +0530, Shyam Saini wrote:
> Elsewhere the sin_family field holds a value with a name of the form
> AF_..., so it seems reasonable to do so here as well.  Also the values
> of PF_INET and AF_INET are the same.
>
> The semantic patch that makes this change is as follows:
>
> //</smpl>
> @@
> struct sockaddr_in sip;
> @@
>
> (
> sip.sin_family ==
> - PF_INET
> + AF_INET
> |
> sip.sin_family !=
> - PF_INET
> + AF_INET
> |
> sip.sin_family =
> - PF_INET
> + AF_INET
> )
> //</smpl>
>
> Signed-off-by: Shyam Saini <mayhs11saini-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/cxgb4/cm.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

>
> diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
> index f1510cc..9749c52 100644
> --- a/drivers/infiniband/hw/cxgb4/cm.c
> +++ b/drivers/infiniband/hw/cxgb4/cm.c
> @@ -2516,18 +2516,18 @@ static int pass_accept_req(struct c4iw_dev *dev, struct sk_buff *skb)
>  		struct sockaddr_in *sin = (struct sockaddr_in *)
>  			&child_ep->com.local_addr;
>
> -		sin->sin_family = PF_INET;
> +		sin->sin_family = AF_INET;
>  		sin->sin_port = local_port;
>  		sin->sin_addr.s_addr = *(__be32 *)local_ip;
>
>  		sin = (struct sockaddr_in *)&child_ep->com.local_addr;
> -		sin->sin_family = PF_INET;
> +		sin->sin_family = AF_INET;
>  		sin->sin_port = ((struct sockaddr_in *)
>  				 &parent_ep->com.local_addr)->sin_port;
>  		sin->sin_addr.s_addr = *(__be32 *)local_ip;
>
>  		sin = (struct sockaddr_in *)&child_ep->com.remote_addr;
> -		sin->sin_family = PF_INET;
> +		sin->sin_family = AF_INET;
>  		sin->sin_port = peer_port;
>  		sin->sin_addr.s_addr = *(__be32 *)peer_ip;
>  	} else {
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--24zk1gE8NUlDmwG9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhfeg0ACgkQ5GN7iDZy
WKd+WhAAoPZfo5F1tC7LEaLnQdlmKx/mCMFnkEk6j1blREpzJHWHj3Iv40rwlfB1
eEheDGASgbHNNAb5gmqGY3JdT/SYmCHa8KXVEsgfA6/qhOwV2DKTD3TLcd2SHmSE
PTxAwUQ37x9vocQxr8DIZ2h6wssHQePS7ur1exDk+n6ymI7NPgfvWRpyiCF+Ooes
mC+URf0Tbrz+JQ2699w9LZ2VUOa1Ox06lXjruvdi3flZZhy2rO5Pzu6fAumxedQm
NiufFgMsLbCz+5ET4zg+6InJY0tqXYP00b64VezIebV5o7ZG4zSt2NERSGuhmBZG
/6r0BShLBGO6IwMiGoNsGJUYFSa5PaKi2Mgsoukugmh2dbAKKatviOqSPi/DwpfC
nnBXe42t8k8q4tFfiHCerJvXgW3/GqnDHdoI5vSWKOAZmVqvJUdQJzfXbfMCkJX1
42d52w3vyrtrgnxqnKuGWV/HTmqzuMjlqKgR+YrbekGV/KhenKvNUysciKiN58Fd
3ZEpr+Z3VZDSTH8oPC5J3/iYL6dNk2kT8I1m4/FPnjXq8MSNx6b+gbroX9ZgeD89
fWdVwIJaobNMxMrStsp9rgKdPpiJXaWjX9a181gg0OAU71yFlvoBMhCFclDe42oO
yVPZCl5/X6frHxjoIeFLmEubXAbcF/ViWjKtKv+Hreqn+P7TKp4=
=SkMG
-----END PGP SIGNATURE-----

--24zk1gE8NUlDmwG9--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
