From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] iw_cxgb4: Use dsgl by default
Date: Thu, 2 Mar 2017 16:47:10 +0200
Message-ID: <20170302144710.GF9525@mtr-leonro.local>
References: <1487833303-4779-1-git-send-email-ganeshgr@chelsio.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kR3zbvD4cgoYnS/6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1487833303-4779-1-git-send-email-ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ganesh Goudar <ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, indranil-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Bharat Potnuri <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--kR3zbvD4cgoYnS/6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 23, 2017 at 12:31:43PM +0530, Ganesh Goudar wrote:
> Enable the use of dsgl by default and determine whether dsgl is
> supported from lld info.
>
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Signed-off-by: Bharat Potnuri <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Ganesh Goudar <ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> ---
>  drivers/infiniband/hw/cxgb4/mem.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
> index 410408f..8db7a11 100644
> --- a/drivers/infiniband/hw/cxgb4/mem.c
> +++ b/drivers/infiniband/hw/cxgb4/mem.c
> @@ -38,9 +38,9 @@
>
>  #include "iw_cxgb4.h"
>
> -int use_dsgl = 0;
> +int use_dsgl = 1;
>  module_param(use_dsgl, int, 0644);
> -MODULE_PARM_DESC(use_dsgl, "Use DSGL for PBL/FastReg (default=0)");
> +MODULE_PARM_DESC(use_dsgl, "Use DSGL for PBL/FastReg (default=1)");

Can we get rid of this module parameter completely?

>
>  #define T4_ULPTX_MIN_IO 32
>  #define C4IW_MAX_INLINE_SIZE 96
> @@ -231,7 +231,7 @@ static int _c4iw_write_mem_dma(struct c4iw_rdev *rdev, u32 addr, u32 len,
>  static int write_adapter_mem(struct c4iw_rdev *rdev, u32 addr, u32 len,
>  			     void *data, struct sk_buff *skb)
>  {
> -	if (is_t5(rdev->lldi.adapter_type) && use_dsgl) {
> +	if (rdev->lldi.ulptx_memwrite_dsgl && use_dsgl) {
>  		if (len > inline_threshold) {
>  			if (_c4iw_write_mem_dma(rdev, addr, len, data, skb)) {
>  				printk_ratelimited(KERN_WARNING
> --
> 2.1.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--kR3zbvD4cgoYnS/6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAli4MG4ACgkQ5GN7iDZy
WKdzdw/+PkjLKqNOPYi3MJi0LNmrILLzscdHEW+5xU3Jkf2tI1FXNFdd1x3VV8Lv
BDDnXRefMFiwH92a2B/zTmMsqo/qcopJfhZNfInqCkcY23ePSE2vqN4fZztIpr9r
SQgTB5ordIXOo+C8x5sudgCeEw48orGp27iJTiCq4fg+JCNG5ndVhgg/dEN6OMzg
1EQHSHTQMCROUyavowniKTWlumjdvKOB8/q+WnyhNLhXFAXMiWVNBQFNWrOBcxgq
4VVn+nrxJOa6bOiRZbaZ7vy5ovMlqUQGsDoTpU6NsOp0+ki2GZIV4j6rcsvQqwGF
l32N8mVKan9E1jVQ3uoxPTltzCEWTUjhmre48ACLAFcEClySDlB2w5yaP/PVOebG
yU5Mt+Y7lGa8a4OdFVNDDzgs4vf2JGXu0jOP+tpLi6H524PfJ0QKvDZyUAdqz7C+
02vWOGZi4DBSdydmX0v0I6jQTGxuTkc3CFbd3uKKKouPn3EqlboHx1Y0WnHnlsBs
Ru8ypPKLnvlL5MEpjiZIKjgbgtgcPaFCFhciWHhWCl5xTnSsDT59hHYMZ0O8araV
1uTaJFrAK4T7rn+fzmeACzeSLcI1z7TxbOq8FOcN+ev87Wy7r3soDs6pX2sg0j9m
rkIkTzcZn4e92g9oJV71+XQm1eiinJfk67rW686lhb4zbt2VvHw=
=aiTw
-----END PGP SIGNATURE-----

--kR3zbvD4cgoYnS/6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
