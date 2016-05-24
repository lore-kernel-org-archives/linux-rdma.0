From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 09/10] IB/hfi1: Do not free hfi1 cdev parent structure early
Date: Tue, 24 May 2016 15:39:56 -0400
Message-ID: <20160524193955.GA17130@phlsvsds.ph.intel.com>
References: <20160519122318.22041.58871.stgit@scvm10.sc.intel.com> <20160519122642.22041.66203.stgit@scvm10.sc.intel.com> <20160519183100.GC26130@obsidianresearch.com> <20160524141756.GA17438@phlsvsds.ph.intel.com> <20160524172054.GC8037@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160524172054.GC8037-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 24, 2016 at 11:20:54AM -0600, Jason Gunthorpe wrote:
>On Tue, May 24, 2016 at 10:17:57AM -0400, Dennis Dalessandro wrote:
>
>> Due to the nature of our hardware user space has direct access to the
>> device. This means there is always going to be a race between the card going
>> away and user space trying to access something that isn't there.
>
>You have to fix this. mlx did and uses a similar direct sharing
>scheme. IIRC for hot-removal they swapped out the mmapped PCI bar with
>0's or something.
>
>Alternatively, somehow block device removal until it is safe, all
>mmaps are closed and all fds are closed.
>
>> The situations which we have to worry about are someone physically removing
>> the card, or using admin priv to unbind it from pci, things of that nature.
>> All of which are not normal use cases.
>
>You need to go through this process for PCI error recovery, IIRC, and
>there was a patch series lately to make the core support device
>hot-removal for exactly this reason.
>
>hfi1 does not need to support hot removal, but it must support safe
>removal by blocking remove until it is safe. This is the problem with
>doing all your own cdev infrastructure, you have to also duplicate all
>this stuff from the core code as well.

Agreed, it is a drawback. For now we'll continue improving what we have. I'm 
intrigued by the idea of holding onto the PCI bar and looking into that 
more. I see that as a follow on patch though.

>> This patch handles a specific issue. The parent data structure of the cdev
>> going away. So if something is hanging onto the cdev we won't panic when it
>> tries to close. For instance a user application sending the get_version
>> ioctl after the device has gone away but before closing its FD.
>
>Yes, but there are clearly more problems.

We may need other fixes I'll give you that, but is there a reason not to 
apply this particular patch?

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
