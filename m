From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: New providers in rdma-core
Date: Wed, 19 Oct 2016 14:09:12 -0600
Message-ID: <20161019200911.GA2666@obsidianresearch.com>
References: <CALq1K=+nEP0jFOCxj30HA0+bg0L1bF5+xiBcAC2bRwUz+M6+eQ@mail.gmail.com>
 <20161019163913.GA30843@infradead.org>
 <6b57d79c-dbd3-cd9b-061e-27a3d3968845@vmware.com>
 <20161019175926.GD29879@obsidianresearch.com>
 <12243e3b-87cf-2bd4-d097-1dd0a7907f41@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <12243e3b-87cf-2bd4-d097-1dd0a7907f41-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 19, 2016 at 12:51:02PM -0700, Adit Ranadive wrote:

> I see that rxe still has a rxe-abi header in the providers/rxe folder.
> Would that also move to the kernel as part of the conversion?

Ideally, but it is blocked by this:

> One of the things I'm unclear about what happends to the IBV structs
> included in the user-level ABI headers, for example, the ibv_get_context_resp
> here:
> https://github.com/linux-rdma/rdma-core/blob/master/providers/mlx4/mlx4-abi.h#L48

This is the main thing preventing the use of the uapi headers - they
are actually *different* :(

It would be great if you have have some ideas on how to deal with
that.. This hasn't been tackled yet.

One choice is to write this:

struct mlx4_alloc_ucontext_resp_v3 {
	struct ibv_get_context_resp	ibv_resp;
	__u32				qp_tab_size;
	__u16				bf_reg_size;
	__u16				bf_regs_per_page;
};

as:

struct user_mlx4_alloc_ucontext_resp_v3 {
	struct ibv_get_context_resp	ibv_resp;
	struct mlx4_alloc_ucontext_resp_v3 udata;
};

Perhaps aided by a macro so we get high uniformity:

#define DECLARE_DRIVER_UDATA(struct_driver, struct_common)
  struct user # struct_driver {
     struct struct_common ibv_resp;
     struct struct_driver udata;
  };

Where mlx4_alloc_ucontext_resp_v3 comes from the uapi header, and is
not inlined, so each driver gets an 'abi wrapper' header that just
builds all these structs.

I'd probably advocate for that for new drivers if nothing more clever
comes forward. At least it is a step closer..

Another approach might be a different way to marshal the kernel call..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
