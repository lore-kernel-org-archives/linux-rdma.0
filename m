From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] iw_cxgb4: calculate t4_eq_status_entries properly
Date: Fri, 19 May 2017 10:27:12 -0600
Message-ID: <354fd98c-5f9f-2851-91b0-9248fa47431f@deltatee.com>
References: <1495185522-8055-1-git-send-email-ganeshgr@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1495185522-8055-1-git-send-email-ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ganesh Goudar <ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

I've tested this on top of v4.12-rc1 and the patch fixes my issue.

Thanks for the quick fix!

Logan

On 19/05/17 03:18 AM, Ganesh Goudar wrote:
> use egrstatuspagesize to calculate t4_eq_status_entries.
> 
> Fixes: bb58d07964f2 ("cxgb4: Update IngPad and IngPack values")
> Reported-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Ganesh Goudar <ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> ---
>  drivers/infiniband/hw/cxgb4/device.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
> index 329fb65e..f96a96d 100644
> --- a/drivers/infiniband/hw/cxgb4/device.c
> +++ b/drivers/infiniband/hw/cxgb4/device.c
> @@ -971,7 +971,7 @@ static struct c4iw_dev *c4iw_alloc(const struct cxgb4_lld_info *infop)
>  		 devp->rdev.lldi.sge_egrstatuspagesize);
>  
>  	devp->rdev.hw_queue.t4_eq_status_entries =
> -		devp->rdev.lldi.sge_ingpadboundary > 64 ? 2 : 1;
> +		devp->rdev.lldi.sge_egrstatuspagesize / 64;
>  	devp->rdev.hw_queue.t4_max_eq_size = 65520;
>  	devp->rdev.hw_queue.t4_max_iq_size = 65520;
>  	devp->rdev.hw_queue.t4_max_rq_size = 8192 -
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
