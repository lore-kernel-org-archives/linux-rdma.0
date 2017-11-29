From: Jonathan Cameron <Jonathan.Cameron-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] RDMA/hns: Bug fixes in hns RoCE driver
Date: Wed, 29 Nov 2017 10:00:54 +0000
Message-ID: <20171129100054.0000402c@huawei.com>
References: <1511750484-102395-1-git-send-email-xavier.huwei@huawei.com>
        <20171127183637.GA13966@ziepe.ca>
        <20171128061517.GO29104@mtr-leonro.local>
        <6e9c4251-8e56-54e2-b186-d3d5b1b85204@intel.com>
        <20171128183910.GA21325@ziepe.ca>
        <1511895042.28512.6.camel@wdc.com>
        <20171128193311.GB21325@ziepe.ca>
        <c3d23cf8-ed10-73a3-7b5b-8c58b7aa4781@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c3d23cf8-ed10-73a3-7b5b-8c58b7aa4781-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "xavier.huwei-WVlzvzqoTvw@public.gmane.org" <xavier.huwei-WVlzvzqoTvw@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "xavier_huwei-9Onoh4P/yGk@public.gmane.org" <xavier_huwei-9Onoh4P/yGk@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 28 Nov 2017 15:27:23 -0500
Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> On 11/28/2017 2:33 PM, Jason Gunthorpe wrote:
> > On Tue, Nov 28, 2017 at 06:50:44PM +0000, Bart Van Assche wrote:  
> >> On Tue, 2017-11-28 at 11:39 -0700, Jason Gunthorpe wrote:  
> >>> On Tue, Nov 28, 2017 at 08:20:09AM -0500, Dennis Dalessandro wrote:  
> >>>> I could resubmit just the series, or you could just pick the 4 driver
> >>>> patches from patchworks whatever is easiest.  
> >>>
> >>> I marked them in patchworks, but can you review the commit messages
> >>> and make sure you think Linus will see them as rc material too?  
> >>
> >> My understanding is that the rc stage is intended primarily for fixes for
> >> bugs introduced during the merge window. For all patches that do not fix
> >> bugs introduced during the merge window it should be evaluated carefully
> >> whether or not these are important enough to be included in a rc pull request.  
> > 
> > Oh? I thought it was more up to the maintainer discretion within some
> > limits. Eg I thought we were running rdma more with the 'if it is OK
> > for -stable, then it is OK -rc' kind of mentality?  
> 
> That's always been my understanding.

Where I maintain, I've always taken a risk judgment. If it a simple fix
for something that is obviously wrong and comes reasonably early in the
RCs I'll take it for the RCs even if the issue wasn't introduced this cycle.
There is some bias in favor of taking regression fixes even if the issue
was introduced a cycle or two back..

Something that has always been broken or broken for a long time probably
isn't effecting lots of people and can wait a few months.

Later in the RCs where there is less time to revert / follow up fix
I get fussier and will queue for the merge window even when marking
for stable.

Another obvious factor is fixes for new drivers are easier to take,
however invasive and dangerous the changes, as there can't be any
existing users to cause regressions for!

So definitely a maintainer judgment call.  I've struck this balance based
on Greg KH pushing back on my pull requests from time to time ;)

Just put on your 'grumpy maintainer' hat and base it on likelihood of
shouting and how much you care about who is doing that shouting!

> 
> > eg -rc is for stablization and bugfixing only, and not restricted only
> > to bugs introduced in the latest merge window??  
> 
> Makes no sense to me to have a hard restriction here. Security fixes, 
> panics, and other serious bugs should certainly qualify. Of course that 
> is subject to how complex the fix is.

Agreed entirely. Answer isn't always obvious though.

Jonathan

> 
> -Denny
> _______________________________________________
> linuxarm mailing list
> linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
> http://rnd-openeuler.huawei.com/mailman/listinfo/linuxarm

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
