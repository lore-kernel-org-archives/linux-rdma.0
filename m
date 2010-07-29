From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Suspected SPAM] Re: [RFC PATCH 2/4] uverbs: Add common
 ib_iomem_get service
Date: Thu, 29 Jul 2010 15:49:49 -0700
Message-ID: <1280443789.6820.153.camel@chromite.mv.qlogic.com>
References: <20100729162339.14674.15788.stgit@build.ogc.int>
	 <20100729162509.14674.34237.stgit@build.ogc.int>
	 <1280427723.6820.56.camel@chromite.mv.qlogic.com>
	 <4C51D15F.8060708@opengridcomputing.com>
	 <20100729201317.GA7920@obsidianresearch.com>
	 <4C51E4B1  <20100729204150.GC7920@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100729204150.GC7920-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "brandt-4OHPYypu0djtX7QSmKvirg@public.gmane.org" <brandt-4OHPYypu0djtX7QSmKvirg@public.gmane.org>, "swise-/Yg/VP3ZvrM@public.gmane.org" <swise-/Yg/VP3ZvrM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2010-07-29 at 13:41 -0700, Jason Gunthorpe wrote:
> On Thu, Jul 29, 2010 at 03:29:37PM -0500, Tom Tucker wrote:
> 
> >> Also, I'd like to see a strong defence of this new user space API
> >> particularly:
> >>   1) Why can't this be done with the existing ibv_reg_mr, like huge
> >>      pages are.
> 
> > The ibv_reg_mr API assumes that the memory being registered was  
> > allocated in user mode and is part of the current->mm VMA. It uses  
> > get_user_pages which will scoff and jeer at kernel memory.
> 
> I'm confused? What is the vaddr input then? How does userspace get
> that value? Isn't it created by mmap or the like?
> 
> Ie for the PCI-E example you gave I assume the flow is that userspace
> mmaps devices/pci0000:00/0000:00:XX.X/resourceX to get the IO memory
> and then passes that through to ibv_reg_mr?
> 
> IMHO, ibv_reg_mr API should accept any valid vaddr available to the
> process and if it bombs for certain kinds of vaddrs then it is just a
> bug..

The reason that get_user_pages() returns an error for
VM_IO and VM_PFNMAP mappings is that there may not be a struct page
associated with the physical address so there is no general way
for the VM layer to allow sharing the page and know when the page
(not the mapping into user space) is not being used.

I looked at this issue for supporting Nvidia CUDA driver which
sets the VM_IO flag on its memory mmaped into user space.
Nvidia wanted to add a set of callback functions and a new
get_driver_pages() function which should be called instead of
get_user_pages() very similar to what is being proposed here for
VM_PFNMAP.
My solution to the problem was to change the Nvidia driver by
not setting VM_IO (since the memory was normal kernel memory with
a struct page) but Nvidia didn't like that solution.

> >>   2) How is it possible for userspace to know when it should use
> >>      ibv_reg_mr vs ibv_reg_io_mr?
> 
> > By virtue of the device that it is mmap'ing. If I mmap my_vmstat_driver,  
> > I know that the memory I am mapping is a kernel buffer.
> 
> Yah, but what if the next version of your vmstat driver changes the
> kind of memory it returns?
> 
> >> On first glance, this seems like a hugely bad API to me :)
> 
> > Well hopefully now that it's purpose is revealed you will change your  
> > view and we can collaboratively make it better :-)
> 
> I don't object to the idea, just to the notion that user space is
> supposed to somehow know that one vaddr is different from another
> vaddr and call the right API - seems impossible to use correctly to
> me.

I agree unless there is some function that can be called which
calls into the kernel and returns an enum or something to
indicate which call to use.

> What would you have to do to implement this using scheme using
> ibv_reg_mr as the entry point?
> 
> Jason

You would need to modify ib_umem_get() to check for the VM_PFNMAP
flag and build the struct ib_umem similar to the proposed
ib_iomem_get(). However, the page reference counting/sharing issue
would need to be solved. I think there are kernel level callbacks
for this that could be used.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
