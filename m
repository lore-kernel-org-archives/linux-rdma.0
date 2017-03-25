From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RESEND PATCH] IB/qib: fix false-postive maybe-uninitialized
 warning
Date: Fri, 24 Mar 2017 22:46:14 -0400
Message-ID: <1490409974.2404.44.camel@redhat.com>
References: <20170314121855.237347-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170314121855.237347-1-arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Masahiro Yamada <yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-03-14 at 13:18 +0100, Arnd Bergmann wrote:
> aarch64-linux-gcc-7 complains about code it doesn't fully understand:
> 
> drivers/infiniband/hw/qib/qib_iba7322.c: In function
> 'qib_7322_txchk_change':
> include/asm-generic/bitops/non-atomic.h:105:35: error: 'shadow' may
> be used uninitialized in this function [-Werror=maybe-uninitialized]
> 
> The code is right, and despite trying hard, I could not come up with
> a version
> that I liked better than just adding a fake initialization here to
> shut up the
> warning.
> 
> Fixes: f931551bafe1 ("IB/qib: Add new qib driver for QLogic PCIe
> InfiniBand adapters")
> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> Acked-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
> Submitted originally on Feb 27, the patch is still required on v4.11-
> rc2 to get
> a clean build.
> ---
>  drivers/infiniband/hw/qib/qib_iba7322.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c
> b/drivers/infiniband/hw/qib/qib_iba7322.c
> index 12c4208fd701..af9f596bb68b 100644
> --- a/drivers/infiniband/hw/qib/qib_iba7322.c
> +++ b/drivers/infiniband/hw/qib/qib_iba7322.c
> @@ -7068,7 +7068,7 @@ static void qib_7322_txchk_change(struct
> qib_devdata *dd, u32 start,
>  	unsigned long flags;
>  
>  	while (wait) {
> -		unsigned long shadow;
> +		unsigned long shadow = 0;
>  		int cstart, previ = -1;
>  
>  		/*

Applied.  Although, it would be preferable to fix the compiler, but I
don't have any control over that and as this breaks compiles with
-Werror, I'll relent and let it in.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
