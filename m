From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/10] Hardware tag matching support
Date: Thu, 13 Oct 2016 13:56:05 -0600
Message-ID: <20161013195605.GA8077@obsidianresearch.com>
References: <1472382050-25908-1-git-send-email-leon@kernel.org>
 <20161007145620.GV9282@leon.nu>
 <1828884A29C6694DAF28B7E6B8A82373AB093986@ORSMSX109.amr.corp.intel.com>
 <6259953b-27fe-77c9-ea90-af744f188671@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373AB095429@ORSMSX109.amr.corp.intel.com>
 <20161013170641.GA9094@infradead.org>
 <1828884A29C6694DAF28B7E6B8A82373AB095647@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB095647-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 13, 2016 at 07:43:25PM +0000, Hefty, Sean wrote:

> > What makes OFVWG more qualified to review an ABI than linux-rdma?
> 
> We've had this discussion on the list before.  The issue is that
> verbs isn't just a software API.  It defines a hardware
> implementation.  The consensus was that some 'standards' body needed
> to be able to review the proposed changes and its impact.  The OFVWG
> was selected as the best available option.  If we want to say no,
> and let the linux-rdma maintainer dictate the hardware interface
> exported by the kernel, then, yes, that's an option.

A bigger objection I have is that much of this new stuff is not
adaquately documented.

Tag matching is a great example. It looks like this introduces many new
headers into the on-wire protocol. Where are these headers documented?
Where is the spec for the on-wire format? Where is the implementation
for rxe?

Basically, is there enough public information that another vendor
could implement this wire protocol? (if not, why are we even
*contemplating* merging something like this???)

'Hopefully' the answer is that this information is all hidden away in
the IBTA... Which opens up an entire new line of problems reviewing
something like this without seeing the agreed spec..

The basic problem with linux-rdma is that it is not a reasonable place
to review a new on-wire protocol amendment to the IBA. Nor is ofvwg
for that matter.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
