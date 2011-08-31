From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH] RDMA/cxgb4: remove accidentally left mutex_unlock(&dev_mutex)
Date: Wed, 31 Aug 2011 15:46:13 -0500
Message-ID: <4E5E9D95.2050601@opengridcomputing.com>
References: <1314823410-12621-1-git-send-email-khoroshilov@ispras.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1314823410-12621-1-git-send-email-khoroshilov-ufN2psIa012HXe+LvDLADg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexey Khoroshilov <khoroshilov-ufN2psIa012HXe+LvDLADg@public.gmane.org>
Cc: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ldv-project-ufN2psIa012HXe+LvDLADg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 08/31/2011 03:43 PM, Alexey Khoroshilov wrote:
> The patch "RDMA/cxgb4: EEH errors can hang the driver" removes
> mutex lock/unlock from c4iw_alloc() except for error path.
> This patch removes the remained mutex_unlock(&dev_mutex).
>
> Found by Linux Driver Verification project (linuxtesting.org).
>
> Signed-off-by: Alexey Khoroshilov<khoroshilov-ufN2psIa012HXe+LvDLADg@public.gmane.org>
> ---
>   drivers/infiniband/hw/cxgb4/device.c |    1 -
>   1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
> index 40a13cc..35896ff 100644
> --- a/drivers/infiniband/hw/cxgb4/device.c
> +++ b/drivers/infiniband/hw/cxgb4/device.c
> @@ -414,7 +414,6 @@ static struct c4iw_dev *c4iw_alloc(const struct cxgb4_lld_info *infop)
>
>   	ret = c4iw_rdev_open(&devp->rdev);
>   	if (ret) {
> -		mutex_unlock(&dev_mutex);
>   		printk(KERN_ERR MOD "Unable to open CXIO rdev err %d\n", ret);
>   		ib_dealloc_device(&devp->ibdev);
>   		return ERR_PTR(ret);

This is actually included in my previously submitted patch:

https://patchwork.kernel.org/patch/1026942/

Steve.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
