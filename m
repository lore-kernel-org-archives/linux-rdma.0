From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 3/6] IB/mlx5: Add support for QP with a
 given source QPN
Date: Mon, 12 Jun 2017 10:02:57 -0600
Message-ID: <20170612160257.GA24829@obsidianresearch.com>
References: <20170608131511.21040-1-leon@kernel.org>
 <20170608131511.21040-4-leon@kernel.org>
 <20170608163020.GA16857@obsidianresearch.com>
 <0ee2641a-4308-6b35-cd0a-e1a5b8b84a6a@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0ee2641a-4308-6b35-cd0a-e1a5b8b84a6a-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jun 11, 2017 at 09:51:49AM +0300, Yishai Hadas wrote:
> On 6/8/2017 7:30 PM, Jason Gunthorpe wrote:
> 
> >I thought the discussion conclusion was to get rid of this confusing
> >linkage from the API?
> >
> 
> We agreed that from API point of view as introduced in the IB patches there
> is no linkage, however, each vendor can implement it according to its
> hardware.

That doesn't even make sense. An API is an API, if the API does not
require linkage then the hardware can't either.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
