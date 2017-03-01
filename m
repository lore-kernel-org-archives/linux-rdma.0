From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: [PATCH v8 08/11] cryptouser.h: fix include from userland
Date: Wed, 1 Mar 2017 12:52:41 +0800
Message-ID: <20170301045241.GB9156@gondor.apana.org.au>
References: <20170228024844.GA28691@altlinux.org>
 <1488314857-28327-1-git-send-email-nicolas.dichtel@6wind.com>
 <1488314857-28327-9-git-send-email-nicolas.dichtel@6wind.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1488314857-28327-9-git-send-email-nicolas.dichtel-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Dichtel <nicolas.dichtel-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>
Cc: arnd-r2nGTMty4D4@public.gmane.org, mmarek-IBi9RG/b67k@public.gmane.org, linux-kbuild-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, airlied-cv59FeDIM0c@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, slash.tmp-GANU6spQydw@public.gmane.org, daniel.vetter-/w4YWyX8dFk@public.gmane.org, rmk+kernel-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jengelh-9+2X+4sQBs8@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 28, 2017 at 09:47:34PM +0100, Nicolas Dichtel wrote:
> This patch prepares the uapi export by fixing the following error:
> 
> .../linux/cryptouser.h:58:16: error: ‘CRYPTO_MAX_ALG_NAME’ undeclared here (not in a function)
>   char cru_name[CRYPTO_MAX_ALG_NAME];
> 
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>
> ---
>  include/linux/crypto.h          | 2 +-
>  include/uapi/linux/cryptouser.h | 7 +++++++
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/crypto.h b/include/linux/crypto.h
> index c0b0cf3d2d2f..4cf29a35bb4b 100644
> --- a/include/linux/crypto.h
> +++ b/include/linux/crypto.h
> @@ -24,6 +24,7 @@
>  #include <linux/slab.h>
>  #include <linux/string.h>
>  #include <linux/uaccess.h>
> +#include <uapi/linux/cryptouser.h>

Nack.  cryptouser is just one interface in the crypto API.  It
should not be included by every single crypto user in the kernel.

You could perhaps introduce a new file under uapi just for this.

Cheers,
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
