From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH RFC] Verbs requirement for GRH when working in GID based
 addressing
Date: Wed, 10 Jan 2018 15:31:26 -0700
Message-ID: <20180110223126.GO4518@ziepe.ca>
References: <CAFgAxU_p4OR7qUe+HjK_rYP+LxUUOxYs+Qp6g4_e64WvOXMWDg@mail.gmail.com>
 <CAJ3xEMgtcv0dgyY59i4+t9tOt8QOfGD9onPcc=QdZBe2ZmKA9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMgtcv0dgyY59i4+t9tOt8QOfGD9onPcc=QdZBe2ZmKA9w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 10, 2018 at 11:59:18PM +0200, Or Gerlitz wrote:
> On Wed, Jan 10, 2018 at 9:28 PM, Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > RDMA applications require an indication they are operating in an
> > environment which is based on GID addressing, such as SR-IOV IB
> > Virtualization. In this mode, all sent traffic must include a GRH.
> 
> Hi Alex,
> 
> Isn't this the case for RoCE since it's day one? how does it work there? maybe
> a hop limit > 1 is used and the kernel rdma stack tweaks it over RoCE ports?

roce requires GRH because it is roce. Everything should just use
that as the criteria.

The hop limit trick is only for IB and it is only for path records
from the SA. It allows the SA to say 'a GRH is required for this path'
even if the path has local GIDs.

The SA *should* be returning hop limit > 1 for any GID that has
grh_required=1 in this patch, otherwise CM won't work right if the
node is a target.

Presumably the attr is required for non SA based schemes?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
