From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [ANNOUNCE] Shared pull requests (was Re: Workflow for i40iw
 patch submissions)
Date: Mon, 25 Sep 2017 21:33:43 -0600
Message-ID: <20170926033343.GA10193@obsidianresearch.com>
References: <9DD61F30A802C4429A01CA4200E302A75B9FB085@fmsmsx116.amr.corp.intel.com>
 <1506179005.120853.67.camel@redhat.com>
 <20170924195627.GB18007@obsidianresearch.com>
 <20170925042355.GM25094@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170925042355.GM25094-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Saleem, Shiraz" <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 25, 2017 at 07:23:55AM +0300, Leon Romanovsky wrote:

> I reread it a couple of times and still didn't find an answer for
> myself. Why do we need it?

The point is to make it easier for everyone to understand what is
going on by clearly documenting via git the actual dependencies that
are required, and to enable early QA on something that will actually
become merged without being rebased.

Handling cross tree dependencies is hard, and if Doug is saying it is
caused so much trouble he wants to basically stop doing it, then
exploring another way to handle it does make sense.

I think it would work better to send a complete workable PR than to
try and wrangle all the manual coordination on what should be merged
on top of what tree and so on.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
