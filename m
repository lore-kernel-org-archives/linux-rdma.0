From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 3/6] IB/mlx5: Add support for QP with a
 given source QPN
Date: Thu, 8 Jun 2017 10:30:20 -0600
Message-ID: <20170608163020.GA16857@obsidianresearch.com>
References: <20170608131511.21040-1-leon@kernel.org>
 <20170608131511.21040-4-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170608131511.21040-4-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 08, 2017 at 04:15:08PM +0300, Leon Romanovsky wrote:
> From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Allow user space applications to accelerate send and receive
> traffic which is typically handled by IPoIB ULP by creating
> a UD QP with a given source QPN of the IPoIB UD QP.
> 
> UD QP with a given source QPN should basically be similar to
> RAW QP from point of view of its created resources.
> 
> However,
> - Its TIS should point to the source QPN.
> - Modify can be done only on its state as the transport attributes
>   are managed by its source QP.

I thought the discussion conclusion was to get rid of this confusing
linkage from the API?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
