From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Ummunotify: progress at last!
Date: Wed, 7 Apr 2010 14:05:14 -0600
Message-ID: <20100407200514.GI15629@obsidianresearch.com>
References: <1CDB2AA4-A8DF-4169-943E-4EA190814596@cisco.com> <20100323165920.GH29129@obsidianresearch.com> <D7DCABC9-4BB2-4FBA-A7B3-C06F4A848467@cisco.com> <20100323172953.GI29129@obsidianresearch.com> <5F80899D-F989-4162-B050-7E4D6B389876@cisco.com> <20100323195251.GJ29129@obsidianresearch.com> <3B848E1F-C9B6-416A-9E6E-99604E71902A@cisco.com> <20100323201124.GK29129@obsidianresearch.com> <ada39z72gww.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ada39z72gww.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Linux RDMA List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Brad Benton <brad.benton-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 07, 2010 at 12:37:03PM -0700, Roland Dreier wrote:
>  > No, there is no mmap. Like this:
>  > 
>  > u64 my_counter = 0;
>  > 
>  > ibv_set_mmu_counter(verbs, &my_counter);
>  > [..]
>  > while (my_counter != last_my_counter) {
>  >     last_my_counter = my_counter;
>  >     ibv_get_mmu_notifications(verbs, ...);   // <- I am a memory barrier as well
>  > }
>  > 
>  > The kernel 'syscall' ibv_set_mmu_counter would bind the given verbs to
>  > the 8 byte counter you specified without having to the mmap thing. As
>  > I understand it this is what perfevents does.
> 
> I was trying to look at how perf events handles this, and AFAICT it
> looks like kernel/perf_event.c just supports mmap().  Can you expand on
> what you meant here?
> 
> (I was trying to figure out how one would handle the case where
> userspace gives us a counter in highmem -- doing kmap_atomic() seems to
> be to only option but then I'm not sure if I want to deal with that...)

I think I was mistaken here, disregard..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
