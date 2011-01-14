From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: mlx4 fix for 36-bit bus addresses on 32-bit arch
Date: Fri, 14 Jan 2011 15:40:58 -0700
Message-ID: <20110114224058.GG9681@obsidianresearch.com>
References: <ig5vl1$j0$1@dough.gmane.org>
 <adafwt06puj.fsf@cisco.com>
 <4D2D5FAD.6030508@cadence.com>
 <adahbde57r7.fsf_-_@cisco.com>
 <20110114130903.GA29706@mtldesk30>
 <20110114172721.GB16535@obsidianresearch.com>
 <adawrm718ja.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adawrm718ja.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "J.L. Burr" <jlburr-vna1KIf7WgpBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 14, 2011 at 01:26:33PM -0800, Roland Dreier wrote:
>  > > Regardless of whether what I say above is correct or not, wouldn't it
>  > > be nicer to to define pfn as either u64 or phys_addr_t and avoid the
>  > > casting?
>  > 
>  > Good point, the pfn must be stored as phys_addr_t too, otherwise you
>  > only support a 44 bit physical address space before truncatation
>  > occures.
> 
> Not sure I agree at the moment... eg remap_pfn_range takes unsigned
> long.  So I don't think things will really work on a 32-bit arch with >
> 44 bit bus addresses for lots of other reasons.

Hmm, fair point. It does look to me like pfns are generally (always?)
stored as unsigned long, so there is no attempt to support more
physical bits than about 44 or so on 32 bit. But I also don't know of
any places that actually check for this when processing BARs... :)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
