From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH for-next] iw_cxgb4: Change error/warn prints to pr_debug
Date: Tue, 19 Dec 2017 15:23:00 -0700
Message-ID: <20171219222300.GH14814@ziepe.ca>
References: <1513680256-8153-1-git-send-email-bharat@chelsio.com>
 <20171219201639.GA14814@ziepe.ca>
 <017901d3790e$030ddea0$09299be0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <017901d3790e$030ddea0$09299be0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Potnuri Bharat Teja' <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 19, 2017 at 03:12:01PM -0600, Steve Wise wrote:
> > On Tue, Dec 19, 2017 at 04:14:16PM +0530, Potnuri Bharat Teja wrote:
> > > @@ -64,12 +64,6 @@
> > >  #define DRV_NAME "iw_cxgb4"
> > >  #define MOD DRV_NAME ":"
> > >
> > > -#ifdef pr_fmt
> > > -#undef pr_fmt
> > > -#endif
> > > -
> > > -#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > > -
> > 
> > Lots of other places in RDMA set a prefix, can we come to some agreement
> if
> > we
> > should drop or keep this unverisally?
> 
> Either way we go, pr_fmt being redefined screws up pr_debug() which
> optionally prepends the function, line, module names depending on the
> dynamic debug settings.  You end up with the module name embedded in the
> middle of the log statement, and duplicated with +m is used.  That is why
> Bharat removed it from iw_cxgb4.  
> 
> In general, I like module names in log statements, but we just need to do it
> the right way to avoid the pr_debug issue...

Seems like a bigger problem than for linux-rdma?

Shouldn't many of these prints be using dev_* stuff and be prefixed
with their device name?

Usually pr should only be used in places where the device does not yet
exist.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
