From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/5] util: Add common mmio macros
Date: Tue, 18 Apr 2017 12:17:36 -0600
Message-ID: <20170418181736.GF7181@obsidianresearch.com>
References: <1492123127-6266-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1492123127-6266-2-git-send-email-jgunthorpe@obsidianresearch.com>
 <b35958cf-5e87-3149-5413-eb754ec89b4d@dev.mellanox.co.il>
 <20170418172852.GD7181@obsidianresearch.com>
 <20170418173815.GC14088@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170418173815.GC14088-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 18, 2017 at 08:38:15PM +0300, Leon Romanovsky wrote:
> On Tue, Apr 18, 2017 at 11:28:52AM -0600, Jason Gunthorpe wrote:
> > On Tue, Apr 18, 2017 at 06:52:00PM +0300, Yishai Hadas wrote:
> >
> > We could use a hash scheme or something to multiple the lock, but I'm
> > really not sure that 32 bit performance matters to anyone anymore?
> 
> In a hard way, I learned that we have a customer who expects that his 32bit
> application will continue to work, so the answer is - no, I care.

Of course it continues to work.

Does your customer fit this very narrow definition:
 - Would actually upgrade to rdma-core
 - 32 bit
 - No SSE hardware (any Intel chip capable of PCI-E has SSE hardware)
 - Multiple same-provider devices with a single program touching all
   devices (single device performance is unchanged)
 - Sensitive to the performance difference of a potential spinlock
   contention / cache misplacement for ~4 instructions

It is hard to understand who cares so much about peformance but leaves
a wack on the table by running in 32 bit mode.

Is this something like x32? We can certainly improve for x32.

PPC32 could also potentially have a path like SSE..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
