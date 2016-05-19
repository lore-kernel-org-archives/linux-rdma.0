From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: Re: small conflict between rdma-next and net-next
Date: Fri, 20 May 2016 07:42:04 +1000
Message-ID: <20160520074204.1061c1b2@canb.auug.org.au>
References: <VI1PR05MB1742B61672A343702D9E8483B04A0@VI1PR05MB1742.eurprd05.prod.outlook.com>
	<995acb69-f95d-a298-231c-20810e390cf0@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <995acb69-f95d-a298-231c-20810e390cf0-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Or,

On Thu, 19 May 2016 16:25:44 +0300 Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>
> Conflict:
> 
> ------------------------------------------------------------
> 
> diff --cc include/linux/mlx5/driver.h
> index 07b504f7eb84,816fe005ca5e..000000000000
> --- a/include/linux/mlx5/driver.h
> +++ b/include/linux/mlx5/driver.h
> @@@ -41,7 -41,7 +41,11 @@@
>    #include <linux/slab.h>
>    #include <linux/vmalloc.h>
>    #include <linux/radix-tree.h>
> ++<<<<<<< HEAD
> +#include <linux/workqueue.h>
> ++=======
> + #include <linux/interrupt.h>
> ++>>>>>>> origin/ib-next-mlx  
>    #include <linux/mlx5/device.h>
>    #include <linux/mlx5/doorbell.h>

I reported this yesterday when it appeared in linux-next.  Small
conflicts like this are really nothing to worry about and Linus (and I)
deal with them all the time.  I only report them in case there is some
semantic change I missed so that the authors can correct me.

P.S. there is something wrong in your mailer (or some part of your
process as the patch parts of your email were double spaced and whits
space damaged.
-- 
Cheers,
Stephen Rothwell
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
