From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core v2 4/4] redhat/spec: build split rpm packages
Date: Fri, 28 Oct 2016 17:55:25 -0400
Message-ID: <20161028215525.GT42084@redhat.com>
References: <20161014192136.11731-1-jarod@redhat.com>
 <20161020153357.27286-1-jarod@redhat.com>
 <20161020153357.27286-5-jarod@redhat.com>
 <20161027211059.GA7224@obsidianresearch.com>
 <20161028171147.GJ42084@redhat.com>
 <20161028172503.GA28451@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161028172503.GA28451-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 28, 2016 at 11:25:03AM -0600, Jason Gunthorpe wrote:
> On Fri, Oct 28, 2016 at 01:11:47PM -0400, Jarod Wilson wrote:
> > On Thu, Oct 27, 2016 at 03:10:59PM -0600, Jason Gunthorpe wrote:
> > > On Thu, Oct 20, 2016 at 11:33:57AM -0400, Jarod Wilson wrote:
> > > > @@ -7,10 +7,11 @@ Summary: RDMA core userspace libraries and daemons
> > > >  #  providers/ipathverbs/ Dual licensed using a BSD license with an extra patent clause
> > > >  #  providers/rxe/ Incorporates code from ipathverbs and contains the patent clause
> > > >  #  providers/hfi1verbs Uses the 3 Clause BSD license
> > > > -License: (GPLv2 or BSD) and (GPLv2 or PathScale-BSD)
> > > > +License: GPLv2 or BSD
> > > 
> > > Is this Ok? The Fedora guidelines I read suggested the PathScale
> > > license would need to be assigned a short tag, and I'd be surprised if
> > > 'BSD' is the right tag due to the patent stuff..
> > 
> > Our standalone libipathverbs has just "GPLv2 or BSD",
> 
> I suspect that was a mistake, the difference in the pathscale license
> is subtle and several other people assumed it was the cannonical 'BSD'
> text...

I sent something off to the Fedora legal mailing list, we'll see what they
have to say. I didn't find anything interesting in the initial package
review, nobody questioned the license there, but that could easily have
been an oversight.

-- 
Jarod Wilson
jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
