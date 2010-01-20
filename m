From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: mode connected infiniband
Date: Tue, 19 Jan 2010 17:09:49 -0800
Message-ID: <adar5pl37ky.fsf@roland-alpha.cisco.com>
References: <8fd3bb681001140011k5ec9492eg19b59b110e45a2b5@mail.gmail.com>
	<adabpgwmwiw.fsf@roland-alpha.cisco.com>
	<4B52C456.5030501@mellanox.co.il>
	<20100118025626.GG9059@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100118025626.GG9059-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> (Jason Gunthorpe's
	message of "Sun, 17 Jan 2010 19:56:26 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


 > The last time I tried to use it the kernel began reporting lots of
 > OOM events (2.6.30 stock). I thought this was well known because CM
 > mode uses high order allocations??

That's not well-known to me.  What's the backtrace for those high-order
allocations?  I thought the CM code was careful to allocate receive
buffers using page-size fragments but maybe there's some other path (skb
rings, QP/CQ structures?) that does a higher-order alloc.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
