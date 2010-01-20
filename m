From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: mode connected infiniband
Date: Wed, 20 Jan 2010 12:29:49 -0700
Message-ID: <20100120192949.GI16490@obsidianresearch.com>
References: <8fd3bb681001140011k5ec9492eg19b59b110e45a2b5@mail.gmail.com> <adabpgwmwiw.fsf@roland-alpha.cisco.com> <4B52C456.5030501@mellanox.co.il> <20100118025626.GG9059@obsidianresearch.com> <adar5pl37ky.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adar5pl37ky.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 19, 2010 at 05:09:49PM -0800, Roland Dreier wrote:
> 
>  > The last time I tried to use it the kernel began reporting lots of
>  > OOM events (2.6.30 stock). I thought this was well known because CM
>  > mode uses high order allocations??
> 
> That's not well-known to me.  What's the backtrace for those high-order
> allocations?  I thought the CM code was careful to allocate receive
> buffers using page-size fragments but maybe there's some other path (skb
> rings, QP/CQ structures?) that does a higher-order alloc.

Hmm, I'll keep an eye out then. I've seen it several times in very
different systems, usually just turn CM mode off and it goes
away. Unfortunately I have no systems like that now and I didn't keep
the traces... The traces did have ipoib function calls.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
