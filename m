From: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH for-next] iw_cxgb4: Change error/warn prints to pr_debug
Date: Tue, 19 Dec 2017 15:44:30 +0530
Message-ID: <20171219101429.GA6736@chelsio.com>
References: <1513678108-6634-1-git-send-email-chelsiocudbg@users.noreply.github.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1513678108-6634-1-git-send-email-chelsiocudbg-KJX8L1YACloTKYOLMXNBRxrm3jAUxWOA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chelsio Cudbg <chelsiocudbg-YEAOTlfEoH4oZ4o0MQTwmEh/o/VBkw4H@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SWise OGC <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sorry, Please ignore this sent with wrong username.
Shall send a proper one.

-Bharat

On Tuesday, December 12/19/17, 2017 at 15:38:28 +0530, Chelsio Cudbg wrote:
> From: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> 
> These prints not neccesarily mean error, so changing them to debug.
> Redifining pr_fmt to print the kernel module name, prints the module
> name twice when +m flag of pr_debug is enabled, hence removing the
> pr_fmt redefinition.
> 
> Signed-off-by: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> ---
>  drivers/infiniband/hw/cxgb4/cm.c       | 4 ++--
>  drivers/infiniband/hw/cxgb4/ev.c       | 2 +-
>  drivers/infiniband/hw/cxgb4/iw_cxgb4.h | 6 ------
>  3 files changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
> index 21db3b48a617..eecdfb0c6be6 100644
> --- a/drivers/infiniband/hw/cxgb4/cm.c
> +++ b/drivers/infiniband/hw/cxgb4/cm.c
> @@ -3567,8 +3567,8 @@ int c4iw_ep_disconnect(struct c4iw_ep *ep, int abrupt, gfp_t gfp)
>  	case MORIBUND:
>  	case ABORTING:
>  	case DEAD:
> -		pr_info("%s ignoring disconnect ep %p state %u\n",
> -			__func__, ep, ep->com.state);
> +		pr_debug("ignoring disconnect ep %p state %u\n",
> +			 ep, ep->com.state);
>  		break;
>  	default:
>  		WARN_ONCE(1, "Bad endpoint state %u\n", ep->com.state);
> diff --git a/drivers/infiniband/hw/cxgb4/ev.c b/drivers/infiniband/hw/cxgb4/ev.c
> index a252d5c40ae3..3e9d8b277ab9 100644
> --- a/drivers/infiniband/hw/cxgb4/ev.c
> +++ b/drivers/infiniband/hw/cxgb4/ev.c
> @@ -236,7 +236,7 @@ int c4iw_ev_handler(struct c4iw_dev *dev, u32 qid)
>  		if (atomic_dec_and_test(&chp->refcnt))
>  			wake_up(&chp->wait);
>  	} else {
> -		pr_warn("%s unknown cqid 0x%x\n", __func__, qid);
> +		pr_debug("unknown cqid 0x%x\n", qid);
>  		spin_unlock_irqrestore(&dev->lock, flag);
>  	}
>  	return 0;
> diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
> index 470f97a79ebb..7d6ec29ec9d7 100644
> --- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
> +++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
> @@ -64,12 +64,6 @@
>  #define DRV_NAME "iw_cxgb4"
>  #define MOD DRV_NAME ":"
>  
> -#ifdef pr_fmt
> -#undef pr_fmt
> -#endif
> -
> -#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> -
>  #include "t4.h"
>  
>  #define PBL_OFF(rdev_p, a) ((a) - (rdev_p)->lldi.vr->pbl.start)
> -- 
> 2.5.3
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
