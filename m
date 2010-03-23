From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Ummunotify: progress at last!
Date: Tue, 23 Mar 2010 13:52:51 -0600
Message-ID: <20100323195251.GJ29129@obsidianresearch.com>
References: <1CDB2AA4-A8DF-4169-943E-4EA190814596@cisco.com> <20100323165920.GH29129@obsidianresearch.com> <D7DCABC9-4BB2-4FBA-A7B3-C06F4A848467@cisco.com> <20100323172953.GI29129@obsidianresearch.com> <5F80899D-F989-4162-B050-7E4D6B389876@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5F80899D-F989-4162-B050-7E4D6B389876-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Brad Benton <brad.benton-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 23, 2010 at 03:17:12PM -0400, Jeff Squyres wrote:

> > If you don't think that is worth doing it
> > does simplify things alot, just add two new verbs calls:
> > 
> > ibv_set_mmu_counter(verbs, &my_counter);
> > ibv_get_mmu_notifications(verbs, &my_list, sizeof(my_list));
> 
> I have no real opinion on whether the mmap/read should be hidden by
> the above ibv calls or not.  Either is fine with me.  I would
> *assume* that ibv_get_mmu_notifications() is non-blocking, right?
> E.g., if you ask for N and only M are available (where M < N), then
> the call returns with only M items filled (and M could be 0).
> Perhaps you need another parameter to indicate how many items in
> my_list were actually filled?  Or is that the return value?
 
Right, non-blocking, return value indicates length, like read().

These are not hiding mmap/read, they are new uverbs 'syscalls' that
get the kernel to perform that operation.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
