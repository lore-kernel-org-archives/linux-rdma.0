From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Ummunotify: progress at last!
Date: Tue, 23 Mar 2010 10:59:20 -0600
Message-ID: <20100323165920.GH29129@obsidianresearch.com>
References: <1CDB2AA4-A8DF-4169-943E-4EA190814596@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1CDB2AA4-A8DF-4169-943E-4EA190814596-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Brad Benton <brad.benton-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 23, 2010 at 12:06:50PM -0400, Jeff Squyres wrote:
> IBM has found a resource that they think will be able to progress Roland's ummunotify work.
> 
> After a few discussions in Sonoma last week and some off-list emails, here's what we decided:
> 
> 1. Take Roland's last code drop (Roland: can you re-send the last copy of your code?).
> 
> 2. Do not convert it to the perf events kernel framework as the Linux kernel community requested.  Instead, migrate the functionality into the ibv code base.  Roland thinks that most of the code should be adaptable without too many changes.  Here's the highlights of the new functionality:
> 
>    a. Add a new flag to ibv_reg_mr() that does the same function as UMMUNOTIFY_REGISTER_REGION
>    b. ibv_dereg_mr() always performs the equivalent of
>    UMMUNOTIFY_UNREGISTER_REGION (if necessary)

>    c. Make a new device somewhere (under /dev/infiniband?) that
>    performs the same functions as /dev/ummunotify (open it to mmap
>    the counter into user space, and read events when something
>    "interesting" happens)

I would prefer to do this by adding a new verbs call that returns a fd
directly. Ie use ib_uverbs_alloc_event_file and act like
ibv_create_comp_channel.

The main reason for the new FD is so it can be polled on..

You can also avoid the mmap scheme by doing what perf events does,
pass in a pointer from userspace and have the kernel pin that page it
is on.

So, I'd suggest

fd = ibv_create_mmu_monitor(verbs, &counter);
[..]
poll(fd);
[..]
if (counter != last_counter)
  [..]
close(fd);

Refuse to create more than one mmu_monitor for each verbs for now.

I looked at this for a little while at Sonoma and I think it is quite
straightforward, I'm happy to look over anything.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
