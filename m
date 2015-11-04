From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: shrink struct ib_send_wr V4
Date: Wed, 4 Nov 2015 09:16:20 -0800
Message-ID: <20151104171620.GA8504@kroah.com>
References: <20151101180609.GC13943@kroah.com>
 <5637EFC8.4010300@redhat.com>
 <20151102233726.GA18251@kroah.com>
 <5637F97C.5090205@redhat.com>
 <20151103001845.GA24206@obsidianresearch.com>
 <56380535.5040101@redhat.com>
 <20151103012821.GA24650@obsidianresearch.com>
 <563815F7.2090003@redhat.com>
 <20151103041614.GA14023@kroah.com>
 <563A1D96.2050507@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <563A1D96.2050507-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 04, 2015 at 10:00:38AM -0500, Doug Ledford wrote:
> On 11/02/2015 11:16 PM, Greg Kroah-Hartman wrote:
> > This too was something we discussed at the kernel summit, it's
> > recommended that you just delete the drivers from where they are now, no
> > need to move them to staging first.
> 
> So, don't take any more patches against them then.  I'll delete them in
> a week or so when I send my pull request.  I have a few other things to
> touch up before then and I have patches that touch those drivers, so in
> order to avoid merge issues that would seem the best course at this point.

Which drivers specifically are you referring to?

And I'm not queueing up any new patches in my tree due to the merge
window, so there's nothing for me to take right now :)

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
