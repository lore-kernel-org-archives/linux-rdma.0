From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH for-next] iw_cxgb4: Change error/warn prints to pr_debug
Date: Tue, 19 Dec 2017 16:32:54 -0600
Message-ID: <018501d37919$4fdccc90$ef9665b0$@opengridcomputing.com>
References: <1513680256-8153-1-git-send-email-bharat@chelsio.com> <20171219201639.GA14814@ziepe.ca> <017901d3790e$030ddea0$09299be0$@opengridcomputing.com> <20171219222300.GH14814@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171219222300.GH14814-uk2M96/98Pc@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgg-uk2M96/98Pc@public.gmane.org>
Cc: 'Potnuri Bharat Teja' <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> On Tue, Dec 19, 2017 at 03:12:01PM -0600, Steve Wise wrote:
> > > On Tue, Dec 19, 2017 at 04:14:16PM +0530, Potnuri Bharat Teja wrote:
> > > > @@ -64,12 +64,6 @@
> > > >  #define DRV_NAME "iw_cxgb4"
> > > >  #define MOD DRV_NAME ":"
> > > >
> > > > -#ifdef pr_fmt
> > > > -#undef pr_fmt
> > > > -#endif
> > > > -
> > > > -#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > > > -
> > >
> > > Lots of other places in RDMA set a prefix, can we come to some
agreement
> > if
> > > we
> > > should drop or keep this unverisally?
> >
> > Either way we go, pr_fmt being redefined screws up pr_debug() which
> > optionally prepends the function, line, module names depending on the
> > dynamic debug settings.  You end up with the module name embedded in the
> > middle of the log statement, and duplicated with +m is used.  That is
why
> > Bharat removed it from iw_cxgb4.
> >
> > In general, I like module names in log statements, but we just need to
do it
> > the right way to avoid the pr_debug issue...
> 
> Seems like a bigger problem than for linux-rdma?
> 

If redefining pr_fmt is actually the preferred way to add module names, then
I think pr_debug() might need
to be fixed.

> Shouldn't many of these prints be using dev_* stuff and be prefixed
> with their device name?

Yea, that makes sense.

steve


---
This email has been checked for viruses by AVG.
http://www.avg.com

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
