From: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Ummunotify: progress at last!
Date: Tue, 23 Mar 2010 15:17:12 -0400
Message-ID: <5F80899D-F989-4162-B050-7E4D6B389876@cisco.com>
References: <1CDB2AA4-A8DF-4169-943E-4EA190814596@cisco.com> <20100323165920.GH29129@obsidianresearch.com> <D7DCABC9-4BB2-4FBA-A7B3-C06F4A848467@cisco.com> <20100323172953.GI29129@obsidianresearch.com>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100323172953.GI29129-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Linux RDMA List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Brad Benton <brad.benton-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mar 23, 2010, at 1:29 PM, Jason Gunthorpe wrote:

> > What do you poll on the fd for?
> 
> poll() is for apps that want to get the notifications without
> spinning on the counter.

Ah, ok.

I think even with the ummunotify interface, that would work, too.  Meaning: since you have to read() from the fd to get event details, poll() would *also* tell you if there was something to read (in addition to checking if (last_counter != counter)).  The counter is a fast way of checking -- e.g., if you need to check in your fast path (which MPI's likely will).  poll() could be used if you don't care if the check is slow.

> If you don't think that is worth doing it
> does simplify things alot, just add two new verbs calls:
> 
> ibv_set_mmu_counter(verbs, &my_counter);
> ibv_get_mmu_notifications(verbs, &my_list, sizeof(my_list));

I have no real opinion on whether the mmap/read should be hidden by the above ibv calls or not.  Either is fine with me.  I would *assume* that ibv_get_mmu_notifications() is non-blocking, right?  E.g., if you ask for N and only M are available (where M < N), then the call returns with only M items filled (and M could be 0).  Perhaps you need another parameter to indicate how many items in my_list were actually filled?  Or is that the return value?

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
