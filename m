From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core v2 4/4] redhat/spec: build split rpm packages
Date: Fri, 28 Oct 2016 11:25:03 -0600
Message-ID: <20161028172503.GA28451@obsidianresearch.com>
References: <20161014192136.11731-1-jarod@redhat.com>
 <20161020153357.27286-1-jarod@redhat.com>
 <20161020153357.27286-5-jarod@redhat.com>
 <20161027211059.GA7224@obsidianresearch.com>
 <20161028171147.GJ42084@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161028171147.GJ42084-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 28, 2016 at 01:11:47PM -0400, Jarod Wilson wrote:
> On Thu, Oct 27, 2016 at 03:10:59PM -0600, Jason Gunthorpe wrote:
> > On Thu, Oct 20, 2016 at 11:33:57AM -0400, Jarod Wilson wrote:
> > > @@ -7,10 +7,11 @@ Summary: RDMA core userspace libraries and daemons
> > >  #  providers/ipathverbs/ Dual licensed using a BSD license with an extra patent clause
> > >  #  providers/rxe/ Incorporates code from ipathverbs and contains the patent clause
> > >  #  providers/hfi1verbs Uses the 3 Clause BSD license
> > > -License: (GPLv2 or BSD) and (GPLv2 or PathScale-BSD)
> > > +License: GPLv2 or BSD
> > 
> > Is this Ok? The Fedora guidelines I read suggested the PathScale
> > license would need to be assigned a short tag, and I'd be surprised if
> > 'BSD' is the right tag due to the patent stuff..
> 
> Our standalone libipathverbs has just "GPLv2 or BSD",

I suspect that was a mistake, the difference in the pathscale license
is subtle and several other people assumed it was the cannonical 'BSD'
text...

> and I didn't see anything specific about PathScale, but I may not
> have been looking hard enough or in the right place in the Fedora
> packaging guidelines. Where did you see that?

https://fedoraproject.org/wiki/Licensing:Main?rd=Licensing

'All software in Fedora must be under licenses in the Fedora licensing list.'

The Pathscale license is not in the licensing list. The patent clause
seems legally significant enough to at least ask what tag is OK.

Also, we now have CC0 and MIT licensed files, so I guess a 'and CC0
and MIT' is appropriate too?

> Nah, I think things look good, and we can always keep tweaking as needed,
> this is a solid update to work on top of.

Okay, I'll patch in the changes from this discussion and send the
pull.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
