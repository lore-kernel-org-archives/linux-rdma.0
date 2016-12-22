From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] redhat/spec: further cleanups to
 depdendencies, descriptions, formatting
Date: Thu, 22 Dec 2016 12:00:57 -0700
Message-ID: <20161222190057.GC5660@obsidianresearch.com>
References: <20161222180220.49558-1-jarod@redhat.com>
 <20161222181323.GA5053@obsidianresearch.com>
 <bf346322-4ef4-032d-9ea2-5a63ae7737e5@redhat.com>
 <20161222183536.GB5660@obsidianresearch.com>
 <f5f043f3-a396-ee44-6f7f-ef3b14daae15@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f5f043f3-a396-ee44-6f7f-ef3b14daae15-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 22, 2016 at 01:41:59PM -0500, Doug Ledford wrote:
> On 12/22/2016 1:35 PM, Jason Gunthorpe wrote:
> > On Thu, Dec 22, 2016 at 01:17:00PM -0500, Jarod Wilson wrote:
> > 
> >>>> - Add explicit dependencies on kmod, initscripts and systemd, as there
> >>>>  are container and vm cases where there might not be a kernel
> >>>>  installed
> >>>
> >>> Do we need initscripts?
> >>
> >> Not really sure, the Fedora package reviewer insists we do.
> > 
> > Hm, no idea what for. We don't provide any LSB init scripts any more,
> > right?
> 
> I think this is a distro specific thing.  Last I knew, there might still
> be one or two things that haven't been migrated from initscripts to
> systemd, or maybe they want the functions that the initscripts package
> provides?

No idea, but it is a big dependency (12 pacakges, 5M)

If the reviewer wants it, lets have them propose a comment about what
it is needed for since none of us seem to know :)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
