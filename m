From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH RFC 1/3] IB/core: Expose a device attribute for rdma_read
 access flags
Date: Tue, 10 Nov 2015 05:06:48 -0800
Message-ID: <20151110130648.GA10682@infradead.org>
References: <1447152255-28231-1-git-send-email-sagig@mellanox.com>
 <1447152255-28231-2-git-send-email-sagig@mellanox.com>
 <1447156270.7089.3.camel@opteya.com>
 <5641E4C9.7000206@talpey.com>
 <5641E644.7080101@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5641E644.7080101-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 10, 2015 at 02:42:44PM +0200, Sagi Grimberg wrote:
> >When this approach is used, the upper layer doesn't have to be aware
> >at all of the lower layer's details.
> 
> Yea, we could do that too. Any preferences from other people?
> I'm pretty indifferent on which way to go...

Yes, that's the way to go.  I though we had agree on doing that as
one of the next step of the MR API cleanups, but decided to postpone
it past the first iteration for some reason that made it non-trivial.

I have to say I still don't like the Windows API either, though as it
still keeps the criptic {local,remote}_{read,write} flags.

Basically what we want is two-dimension selection:

	/*
	 * If %true this is the target of RDMA READ/WRITE operations
	 * from the remote system.  If %false this is the sink / source
	 * for RDMA READ/WRITE operations issued by the local system.
	 */
	enum ib_mr_scope { IB_MR_REMOTE, IB_MR_LOCAL };

	/*
	 * Operation we're registering for.  Can be OR'ed together
	 * when allowing RDMA READs and WRITEs on a single MR.
	 */
	enum ib_mr_dir { IB_MR_RDMA_READ = 1 << 0, IB_MR_RDMA_WRITE = 1 << 1 };

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
