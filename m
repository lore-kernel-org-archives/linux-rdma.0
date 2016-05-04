From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] Proposal to address hfi1 UI and EPROM devices
Date: Wed, 4 May 2016 08:17:15 -0400
Message-ID: <20160504121714.GA10916@phlsvsds.ph.intel.com>
References: <20160502195502.GA31800@phlsvsds.ph.intel.com> <20160503173130.GA1921@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160503173130.GA1921-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, May 03, 2016 at 11:31:30AM -0600, Jason Gunthorpe wrote:

>> Another approach is using the driver's resource0 file. We can mmap() the BAR
>> and access the registers. The main drawback we have with that is we have
>> some hardware requirements that the driver needs to arbitrate access to
>> certain registers. This means some form of kernel/user space shared locking.
>> We are currently not aware of anything that the kernel provides to achieve
>> this. However, we are still looking and would appreciate any pointers.
>
>You should probably use resource0 as much as possible - that minimizes
>the kernel code required.
>
>> The third approach would be to take our existing UI implementation and plop
>> it down in debugfs as a binary file. We can control our locking just as we
>> do today, in the driver. This gets rid of the character device, and it's not
>> even available unless the admin decides to mount debugfs.
>
>.. and use debugfs just for that little bit of shared locking you need
>to make resource0 work out.

Yeah. I was hoping we could find some other kernel facility that can provide 
a locking type mechanism between the driver and user space rather than go 
roll our own. We'll come up with something more concrete in the form of 
patch and post soon though.

>Minimizing the kernel impact for debugging code is generally desirable.

Agree. Especially in this case where we should be able to make do with the 
already provided facilities. 

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
