From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next] IB/rxe: Use DEFINE_SPINLOCK() for spinlock
Date: Sun, 30 Oct 2016 23:09:14 +0200
Message-ID: <20161030210914.GT3617@leon.nu>
References: <1477757973-32052-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="rBVNTu5JXDAWzN2S"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1477757973-32052-1-git-send-email-weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--rBVNTu5JXDAWzN2S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Oct 29, 2016 at 04:19:33PM +0000, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>
> spinlock can be initialized automatically with DEFINE_SPINLOCK()
> rather than explicitly calling spin_lock_init().
>
> Signed-off-by: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Thanks.
Reviewed-by: Leon Romanosky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

> ---
>  drivers/infiniband/sw/rxe/rxe_net.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
> index b8258e4..4cb6378 100644
> --- a/drivers/infiniband/sw/rxe/rxe_net.c
> +++ b/drivers/infiniband/sw/rxe/rxe_net.c
> @@ -46,7 +46,7 @@
>  #include "rxe_loc.h"
>
>  static LIST_HEAD(rxe_dev_list);
> -static spinlock_t dev_list_lock; /* spinlock for device list */
> +static DEFINE_SPINLOCK(dev_list_lock); /* spinlock for device list */
>
>  struct rxe_dev *net_to_rxe(struct net_device *ndev)
>  {
> @@ -663,8 +663,6 @@ struct notifier_block rxe_net_notifier = {
>
>  int rxe_net_ipv4_init(void)
>  {
> -	spin_lock_init(&dev_list_lock);
> -
>  	recv_sockets.sk4 = rxe_setup_udp_tunnel(&init_net,
>  				htons(ROCE_V2_UDP_DPORT), false);
>  	if (IS_ERR(recv_sockets.sk4)) {
> @@ -680,8 +678,6 @@ int rxe_net_ipv6_init(void)
>  {
>  #if IS_ENABLED(CONFIG_IPV6)
>
> -	spin_lock_init(&dev_list_lock);
> -
>  	recv_sockets.sk6 = rxe_setup_udp_tunnel(&init_net,
>  						htons(ROCE_V2_UDP_DPORT), true);
>  	if (IS_ERR(recv_sockets.sk6)) {
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--rBVNTu5JXDAWzN2S
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYFmF6AAoJEORje4g2clin+30P/Ah+Ww1cIhR99XtXcyLdClkI
XMqegW3OJa+hUvRQx8C+zOod+RLeXCbwSvkssVoAj6pMJxz8u+5Y8oE/wXwAR4Zd
syevRe0pNajPrWlqskVgNDX6b8L42KrDhgtaF7KgqYkPpfwFirtFRERSk/AnTqdX
qxjCwhCUjOdPCiv/EMe/KNAAGlNwysPbysBrhB5FgcGPc1oBC+2aJ+p/FwtZ86Pm
R9na9FHIM6jDxhQ88h932rWmm1SG0goqJi+nMMeYUAGms3+Vnki01HlNiuHqwMDG
q4/7IYl15LLexIb2w9dzTRUyuW37d1V2LLopAiSFHm4Ec29d/gsqaXKvBN93cb/2
1Z0YlCvdB16kxUI2/jSYH4Pzr15V5jEhqHmFLRAu4hFQ7eCyVsyWI/dSSz8aMLHb
NxejwW6yz0fj3okz2Hpb1miFN/flXYAGO1P0mVTXuhi6vFHEvP71VnpTx3v5r/XQ
/nqZCszRWINyN4Qc3hxmLYRCkyfFDXtaQXcCXNeHCGtTSgyzAeK7b6aYcS4fFprd
F0hzLqdrOzxF5bUm7ECivnGl2hXF2dxR6NjYymECNdpFnA9EtAv4ZOluUjlpJR9M
g8T0K/etLfxBqmJGDWSHFxlaf0hrc2YMeeK+PVu9FhL7RTW+1EQRyDVOd9yDwUUr
XdWGpRLnrr1vsnPPFryz
=xHtM
-----END PGP SIGNATURE-----

--rBVNTu5JXDAWzN2S--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
