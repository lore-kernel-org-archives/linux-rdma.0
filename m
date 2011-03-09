From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH/libmlx] Set the ibv_wc.opcode even if the wc is an
 error wc
Date: Wed, 9 Mar 2011 10:40:44 -0700
Message-ID: <20110309174044.GO22729@obsidianresearch.com>
References: <20110309042613.GA21606@obsidianresearch.com>
 <4D771E0F.7040402@mellanox.com>
 <20110309070441.GA25213@obsidianresearch.com>
 <4D772E36.90103@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4D772E36.90103-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 09, 2011 at 09:37:26AM +0200, Or Gerlitz wrote:

> >I'd say that 11.4.2.1 supports the view that wr_id and status are the
> >only valid fields. However, the whole error handling architecture that
> >the WC's fit into is based around the idea that you can go from an
> >error WC back to the RQ/SQ that caused the error, correct the
> >situation and resume operation. That requires the opcode indicate at
> >least SEND vs RECV, and that qp_num be valid
> 
> Indeed, the qp number is required for supporting SRQ, since in that
> case, many sessions (QPs) share the same RQ buffer pool. 

IBA says qp_num is also not available, you have to code that into
wr_id as well, which pretty much means wr_id has point to allocated
memory.

> As for the opcode, I understand what you're saying, but, still -
> given the cookie and the qp number the application can realize
> whether is was send or receive that failed, and with recording of
> the actual send opcode (send/rdma-read/write/etc) in the buffer
> pointed by the cookie further debug this. 

Right, but why should apps have to do this extra work of allocating
more memory, etc, etc, just to keep track of something the HCA already
keeps track of?

> Ofcourse your approach would make debugging easier. The question is
> how to educate people that write to IB, should we tell them now they
> can look on the opcode? so far I was telling people never do so if
> the status isn't success.

Well, clearly today you have to say that only wr_id and status are
valid and everything else is garbage, because that is what mlx4's
drivers do.

If we fix mlx4 and I'm correct then qib works, then you can go on to
say that 90% of the cards do correctly set opcode and qp_num, however
relying on it is not portable.

If mthca and ehca can be made to work in the same way then we go on to
say that OFA requires that all IB drivers work this way and propose
that IBA be updated.

Like any other non-portable construct using it or not depends on what
you are trying to accomplish and how much performance you gain. But in
any event, having the information is better for diagnostics so I think
the patch should be applied :)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
