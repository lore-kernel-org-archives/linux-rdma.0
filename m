From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/3] Debian 15.1-1 changes
Date: Sun, 3 Dec 2017 09:27:04 -0700
Message-ID: <20171203162704.GA8566@ziepe.ca>
References: <20171130174750.GD7754@ziepe.ca>
 <1512066118.4246.2.camel@profitbricks.com>
 <20171130185822.GE7754@ziepe.ca>
 <1512079788.3878.1.camel@profitbricks.com>
 <20171201055732.GC8126@mtr-leonro.local>
 <1512151985.9183.4.camel@profitbricks.com>
 <20171201182806.GL7754@ziepe.ca>
 <20171202084019.GG8126@mtr-leonro.local>
 <20171202162856.GA28143@ziepe.ca>
 <20171203065501.GA2110@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171203065501.GA2110-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 03, 2017 at 08:55:01AM +0200, Leon Romanovsky wrote:
> > Are we?
> 
> Rarely,
> 
> Merge: cea6f4e0 e0ed9229
> Author: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Date:   Thu Sep 28 16:58:57 2017 +0300
> 
>     Merge branch 'jgunthorpe-new-init'
> 
>     * jgunthorpe-new-init:
>       rxe: Use VERBS_NAME_MATCH to match the rxe device
>       hns: Use the generic modalias matcher
>       cxgb: Use the new common PCI matching infrastructure
>       providers: Use the new common PCI matching infrastructure
>       verbs: Provide common code to match providers against kernel devices
>       verbs: Remove the init_device entry point
>       providers: Use the new match_device and allocate_device ops
>       verbs: Split init_device into a match and alloc/bind step
>       cxgb4: Move sysconf up to driver_init
>       verbs: Change verbs_register_driver to accept the ops struct directly
> 
> 
> > I wish github did that :(
> 
> Github is doing it, it will help if PR authors place cover letter in
> their PR.

How do you do that? I always write a letter in the PR?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
