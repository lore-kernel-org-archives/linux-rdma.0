From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] Proposal to address hfi1 UI and EPROM devices
Date: Tue, 3 May 2016 11:31:30 -0600
Message-ID: <20160503173130.GA1921@obsidianresearch.com>
References: <20160502195502.GA31800@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160502195502.GA31800-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, May 02, 2016 at 03:55:02PM -0400, Dennis Dalessandro wrote:
> One approach we have considered is using the regmap interface. This has a
> number of problems. It is primarily a read only interface. The write
> capability is not even available as a compile time option. A code change is
> needed to make use of it. There are other issues as well such as being 32bit
> when we need 64bit. So this seems like the wrong option.

Yah, the places I've seen regmap used don't seem to match this use
case.

> Another approach is using the driver's resource0 file. We can mmap() the BAR
> and access the registers. The main drawback we have with that is we have
> some hardware requirements that the driver needs to arbitrate access to
> certain registers. This means some form of kernel/user space shared locking.
> We are currently not aware of anything that the kernel provides to achieve
> this. However, we are still looking and would appreciate any pointers.

You should probably use resource0 as much as possible - that minimizes
the kernel code required.

> The third approach would be to take our existing UI implementation and plop
> it down in debugfs as a binary file. We can control our locking just as we
> do today, in the driver. This gets rid of the character device, and it's not
> even available unless the admin decides to mount debugfs.

.. and use debugfs just for that little bit of shared locking you need
to make resource0 work out.

Minimizing the kernel impact for debugging code is generally desirable.

> We also should be able to use any of these schemes to handle our eprom
> reading/writing. Adding eprom to IPoIB as Doug suggested is a fine
> plan, but

I would be fine with this if you moved the eeprom handling to user
space and used resource0.

Less fine if the code remains in the kernel but just moves to debugfs.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
