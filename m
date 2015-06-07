From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V2 0/9] Add completion timestamping support
Date: Sat, 6 Jun 2015 22:42:07 -0600
Message-ID: <20150607044207.GA24678@obsidianresearch.com>
References: <1433157904.114391.188.camel@redhat.com>
 <20150601164322.GA14391@obsidianresearch.com>
 <1433255724.114391.225.camel@redhat.com>
 <20150602180844.GD17776@obsidianresearch.com>
 <CAJ3xEMjZqwJC8=HrMBv_eSVKVtLW7qjVZNjtuD28octGPtYu6w@mail.gmail.com>
 <20150603204633.GE7902@obsidianresearch.com>
 <alpine.DEB.2.11.1506031953500.11879@east.gentwo.org>
 <20150604042540.GA8837@obsidianresearch.com>
 <alpine.DEB.2.11.1506060304480.29634@east.gentwo.org>
 <1433605546.40123.217.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1433605546.40123.217.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jun 06, 2015 at 11:45:46AM -0400, Doug Ledford wrote:
> The ppm rating is based upon the speed of the clock, not time.  It's how
> many cycles of variance you are allowed from the target speed given in
> cycles / millions of cycles of the target clock frequency.

Right, it is 'parts per million'. Hz, ppm, and a measure of 'phase
noise' are the three technical characteristics used to define a
communications clock source.

> > > That translates into 0.0625 Hz. for a 312.5 MHz ethernet reference clock
> 
> I don't know how this number is derived, but 0.0625Hz sounds like an odd
> variance.

I used 200ppm for that example, as it is closer to the ethernet worst
case.

> He's pointing out that the design as specified passes the clock
> frequency to the user space library in terms of integer MHz.  The
> standard Ethernet clock frequency is 312.5MHz.  That .5MHz, or
> 500,000Hz, must be rounded off as it is passed from the kernel to
> the

Yes, right, thank you, I thought I was loosing my mind :)

> Jason's point, and one that isn't addressed yet, is that this might not
> be variance in the clocks and instead might be a design flaw in the API
> you are using and the way the clock speeds are passed to user space.
> Changing from int MHz to int KHz might solve your problem.

I would use a period in picoseconds to describe a clock..

But really, if you start talking about IEEE 1588 (the PTP standard
Christoph mentioned) then even that is not enough accuracy to
represent a synchronized clock, and the frequency may change as the
NIC adjusts the time base.

So, if verbs has a 'time stamp to timespec' driver call back then that
would be most general. Userspace that needs high speed self managed
conversion can call 'time stamp to timespec' once with the value 1E9
and learn the general clock period, exactly as if it was in
query_device. So nothing is lost by this small API change.

Which suggest to me, this shouldn't be in the kernel general UAPI at
all.

That just leaves the mask, I dislike it, but.. if Or says it is too
hard to fix then we are stuck with it. I don't think the wrapping can
really be fixed unless the HW generates a CQE entry for every counter
roll over. At least I haven't had a better idea on the subject this week..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
