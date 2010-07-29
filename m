From: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [RFC PATCH 2/4] uverbs: Add common ib_iomem_get service
Date: Thu, 29 Jul 2010 15:29:37 -0500
Message-ID: <4C51E4B1.6040800@opengridcomputing.com>
References: <20100729162339.14674.15788.stgit@build.ogc.int> <20100729162509.14674.34237.stgit@build.ogc.int> <1280427723.6820.56.camel@chromite.mv.qlogic.com> <4C51D15F.8060708@opengridcomputing.com> <20100729201317.GA7920@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100729201317.GA7920-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>, "rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "brandt-4OHPYypu0djtX7QSmKvirg@public.gmane.org" <brandt-4OHPYypu0djtX7QSmKvirg@public.gmane.org>, "swise-/Yg/VP3ZvrM@public.gmane.org" <swise-/Yg/VP3ZvrM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/29/10 3:13 PM, Jason Gunthorpe wrote:
> On Thu, Jul 29, 2010 at 02:07:11PM -0500, Tom Tucker wrote:
>    
>>>> Add an ib_iomem_get service that converts a vma to an array of
>>>> physical addresses. This makes it easier for each device driver to
>>>> add support for the reg_io_mr provider method.
>>>>          
> Tom, could you say a few words on what this is for?
>
>    

The proposed interface is there to allow a user-mode application to mmap 
kernel memory and/or device memory as a data source or sync for RDMA.

This is useful for a number of applications, for example:

- An application that wishes to provide kernel statistics to a 
monitoring host with zero overhead. For example, a set of compute nodes 
that are being monitored by a statistics gathering application (Ovis), 
but don't want to introduce scheduler jitter into the compute node.  The 
stats are provided in a kernel allocated buffer and the monitoring app 
'gathers' those statistics with RDMA_READ at zero cost to the monitored 
host.

- An application that wishes to provide network (RDMA) access to a large 
static memory hung off of it's PCI-e bus, thereby creating a distributed 
and persistent memory

Those are the only two that I've written so far that use these verbs.


> Also, I'd like to see a strong defence of this new user space API
> particularly:
>   1) Why can't this be done with the existing ibv_reg_mr, like huge
>      pages are.
>    

The ibv_reg_mr API assumes that the memory being registered was 
allocated in user mode and is part of the current->mm VMA. It uses 
get_user_pages which will scoff and jeer at kernel memory.

>   2) How is it possible for userspace to know when it should use
>      ibv_reg_mr vs ibv_reg_io_mr?
>    

By virtue of the device that it is mmap'ing. If I mmap my_vmstat_driver, 
I know that the memory I am mapping is a kernel buffer.

>   3) Why can't ibv_dereg_io_mr be entirely handled by ibv_dereg_mr?
>
>    
Probably could.

> On first glance, this seems like a hugely bad API to me :)
>
>    

Well hopefully now that it's purpose is revealed you will change your 
view and we can collaboratively make it better :-)

> Also, if new user space APIs are really needed, they do need man pages
> too ...
>
>    
Of course.

> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>    

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
