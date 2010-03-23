From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Ummunotify: progress at last!
Date: Tue, 23 Mar 2010 14:11:24 -0600
Message-ID: <20100323201124.GK29129@obsidianresearch.com>
References: <1CDB2AA4-A8DF-4169-943E-4EA190814596@cisco.com> <20100323165920.GH29129@obsidianresearch.com> <D7DCABC9-4BB2-4FBA-A7B3-C06F4A848467@cisco.com> <20100323172953.GI29129@obsidianresearch.com> <5F80899D-F989-4162-B050-7E4D6B389876@cisco.com> <20100323195251.GJ29129@obsidianresearch.com> <3B848E1F-C9B6-416A-9E6E-99604E71902A@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3B848E1F-C9B6-416A-9E6E-99604E71902A-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Brad Benton <brad.benton-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 23, 2010 at 04:01:21PM -0400, Jeff Squyres wrote:
> On Mar 23, 2010, at 3:52 PM, Jason Gunthorpe wrote:
> 
> > > > ibv_set_mmu_counter(verbs, &my_counter);
> > > > ibv_get_mmu_notifications(verbs, &my_list, sizeof(my_list));
> > 
> > These are not hiding mmap/read, they are new uverbs 'syscalls' that
> > get the kernel to perform that operation.
> 
> Oh -- so there's 2 mechanisms to get the counter info (for example):
> 
> 1. the above uverb
> 2. mmap
> 
> Right?

No, there is no mmap. Like this:

u64 my_counter = 0;

ibv_set_mmu_counter(verbs, &my_counter);
[..]
while (my_counter != last_my_counter) {
    last_my_counter = my_counter;
    ibv_get_mmu_notifications(verbs, ...);   // <- I am a memory barrier as well
}

The kernel 'syscall' ibv_set_mmu_counter would bind the given verbs to
the 8 byte counter you specified without having to the mmap thing. As
I understand it this is what perfevents does.

Integrating with the verbs api avoids the need for another device
file. That is good. Eliminating poll() from the API can remove the
dedicated fd entirely. Within verbs I guess we could replace poll()
with something like a completion channel (??) if anyone cares.

So the user space visible functionality boils down to 2 new 'syscalls'
and the new flag to ibv_reg_mr.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
