From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH for-next] iw_cxgb4: Change error/warn prints to pr_debug
Date: Fri, 22 Dec 2017 10:32:07 -0700
Message-ID: <20171222173207.GF30884@ziepe.ca>
References: <1513680256-8153-1-git-send-email-bharat@chelsio.com>
 <20171219201639.GA14814@ziepe.ca>
 <017901d3790e$030ddea0$09299be0$@opengridcomputing.com>
 <20171219222300.GH14814@ziepe.ca>
 <018501d37919$4fdccc90$ef9665b0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <018501d37919$4fdccc90$ef9665b0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Potnuri Bharat Teja' <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 19, 2017 at 04:32:54PM -0600, Steve Wise wrote:

> > > In general, I like module names in log statements, but we just
> > > need to do it the right way to avoid the pr_debug issue...
> > 
> > Seems like a bigger problem than for linux-rdma?
> > 
> 
> If redefining pr_fmt is actually the preferred way to add module names, then
> I think pr_debug() might need
> to be fixed.
> 
> > Shouldn't many of these prints be using dev_* stuff and be prefixed
> > with their device name?
> 
> Yea, that makes sense.

Okay, I've dropped this patch.

The two changes to pr_debug should probably become dev_dbg, and
resend?

Deal with the 'what should pr_fmt be' question someplace else :)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
