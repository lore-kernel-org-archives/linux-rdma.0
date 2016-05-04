From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 3/4] IB/core: Fix a potential array overrun in
 CMA and SA agent
Date: Wed, 4 May 2016 17:37:17 -0400
Message-ID: <20160504213717.GD10115@rhel.ra.intel.com>
References: <1462340165-16067-1-git-send-email-leon@kernel.org>
 <1462340165-16067-4-git-send-email-leon@kernel.org>
 <20160504181922.GA20554@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160504181922.GA20554-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 04, 2016 at 12:19:22PM -0600, Jason Gunthorpe wrote:
> On Wed, May 04, 2016 at 08:36:04AM +0300, Leon Romanovsky wrote:
> 
> > -static const struct ibnl_client_cbs cma_cb_table[] = {
> > +static const struct ibnl_client_cbs cma_cb_table[RDMA_NL_RDMA_CM_NUM_OPS] = {
> >  	[RDMA_NL_RDMA_CM_ID_STATS] = { .dump = cma_get_id_stats,
> >  				       .module = THIS_MODULE },
> 
> Isn't it much better to change this:
> 
>         if (ibnl_add_client(RDMA_NL_RDMA_CM, RDMA_NL_RDMA_CM_NUM_OPS, cma_cb_table))
> 
> to 
>         if (ibnl_add_client(RDMA_NL_RDMA_CM, NELEMS(cma_cb_table), cma_cb_table))
> 
> And eliminate RDMA_NL_RDMA_CM_NUM_OPS entirely?

Well based on their other series I think we may need to revisit the design
pattern of netlink altogether.  But yea if we just want to fix this we can do
this.

Ira

> 
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
