From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: [BUG] Bad page map in process ibv_devinfo
Date: Thu, 17 Nov 2011 21:03:16 -0500 (EST)
Message-ID: <20111117.210316.83327515715765011.davem@davemloft.net>
References: <1321471354.5493.YahooMailNeo@web24714.mail.ird.yahoo.com>
	<20111117.164941.2104520709167256016.davem@davemloft.net>
	<CAL1RGDV_AwOOnLvWJKGqBTaptetfVN_gXNG=PcaFUXYSXrQ5AA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDV_AwOOnLvWJKGqBTaptetfVN_gXNG=PcaFUXYSXrQ5AA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org, sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Date: Thu, 17 Nov 2011 15:30:19 -0800

> But the call trace is in the munmap() call -- it's just printing where the
> bad map was set up initially.  We're somewhere in unmap_vmas(),
> probably one of the tests in zap_pte_range().  Since we got
> 
>     [ 9305.698663] swap_free: Bad swap file entry 100005e000061800
> 
> I'm guessing somehow we reached
> 
> 		} else {
> 			swp_entry_t entry = pte_to_swp_entry(ptent);
> 
> 			if (!non_swap_entry(entry))
> 				rss[MM_SWAPENTS]--;
> 			if (unlikely(!free_swap_and_cache(entry)))
> 				print_bad_pte(vma, addr, ptent, NULL);
> 		}
> 
> which shouldn't be possible if pte_present() were set.

I suspect this is an issue about who is responsible for setting the
various VM_* flags in the VMA.

It at least used to be the case that the caller was responsible, but
it seems that this has changed in some regard.  And if you look at
remap_pfn_range(), which is what x86 uses, it sets things like VM_IO
explicitly.

In fact, sparc is one of the few platforms not using remap_pfn_range()
as it's io_remap_pfn_range() implementation.

Sparc overrides the implementation for two reasons:

1) To deal with encoding of upper bits into the PFN properly on 32-bit
   machines.  This is similar to what MIPS is dealing with in it's
   wrapper around remap_pfn_range().

2) To use large page mappings when possible on 64-bit.  This used to
   matter a lot with framebuffers about 10 years ago.

I'd rather give up an optimization of dubious value than to have to
constantly stay on top of every single change ever made to
remap_pfn_range().

Therefore I'll code up a patch that handles the PFN encoding issue
the way that MIPS does, with a small wrapper around remap_pfn_range().

Patch coming up for testing in a bit.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
