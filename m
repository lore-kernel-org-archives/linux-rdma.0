From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] RDMA/core: Fix for parsing netlink string attribute
Date: Tue, 12 May 2015 11:50:33 -0600
Message-ID: <20150512175033.GA15891@obsidianresearch.com>
References: <20150508213633.GA13012@TENIKOLO-MOBL2>
 <20150508215328.GB3917@obsidianresearch.com>
 <1431450866.43876.65.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1431450866.43876.65.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, May 12, 2015 at 01:14:26PM -0400, Doug Ledford wrote:
> On Fri, 2015-05-08 at 15:53 -0600, Jason Gunthorpe wrote:
> > On Fri, May 08, 2015 at 04:36:33PM -0500, Tatyana Nikolova wrote:
> > > The string iwpm_ulib_name is recorded in a nlmsg as a netlink attribute.
> > > Without this fix parsing of the nlmsg by the userspace port mapper service fails
> > > because of unknown attribute length, causing the port mapper service not to
> > > register the client, which has sent the nlmsg.
> > 
> > Reviewed-By: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > 
> > This actually will copy some kernel memory to userspace. I think the
> > overflow is in .text, so probably not a security issue..
> 
> It shouldn't be in the .text section.  

Pedantically, that is right, it is an archaic colloquialism to refer
to the entire set of post-link read-only sections as .text. (typically
the linker used to merge everything into .text)

I realize now I didn't consider modules when looking into this. No
time right now, can you check if there is any chance the read can
overflow past the page allocated to the module's .rodata?

> char array, so it should be in one of the data sections.  And since we
> are using an initializer smaller than the specific size of the array, I
> would expect all of the unitialized bits to be 0.  

I was talking about the situation before the patch. 

C defines a zero fill for incomplete initialization.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
