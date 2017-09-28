From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [ANNOUNCE] Shared pull requests (was Re: Workflow for i40iw
 patch submissions)
Date: Thu, 28 Sep 2017 09:53:55 -0600
Message-ID: <20170928155355.GA16780@obsidianresearch.com>
References: <9DD61F30A802C4429A01CA4200E302A75B9FB085@fmsmsx116.amr.corp.intel.com>
 <1506179005.120853.67.camel@redhat.com>
 <20170924195627.GB18007@obsidianresearch.com>
 <20170925042355.GM25094@mtr-leonro.local>
 <20170926033343.GA10193@obsidianresearch.com>
 <20170926052805.GC1230@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170926052805.GC1230-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Saleem, Shiraz" <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 26, 2017 at 08:28:05AM +0300, Leon Romanovsky wrote:

> At some point of time, usually after -rc4 for bleeding edge devices,
> the netdev and RDAM trees are so different in that area (for example mlx5_core)
> that the chances to have clean PR are not high.

Well, exactly. That is the entire problem.

And it is solvable, with work and understanding. You need to use git
properly, and create a PR that starts out with a merge of the netdev
and rdma trees from the 'right point'.

But you absolutely can technically construct a driver PR that passes
QA, includes the rdma and netdev components, and all of the driver
related patches.

And I think the result would be better if the driver teams did this
directly instead of trying to explain to Doug what it is they need and
then having him do it for them.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
