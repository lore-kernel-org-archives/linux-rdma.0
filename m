From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/16] Flow counters support
Date: Thu, 2 Nov 2017 10:19:28 -0600
Message-ID: <20171102161928.GJ18874@ziepe.ca>
References: <20171029180019.GE4488@ziepe.ca>
 <CAFgAxU_CMxQ616wBd-vkvyJ905ndLHrabmWtJ-Ye_hgSwWqiag@mail.gmail.com>
 <20171101181807.GJ1030@ziepe.ca>
 <CAFgAxU-DsOr9T9P6gqvZ9AviE45_34vZ1WUgUehmF-kb2j8JtQ@mail.gmail.com>
 <20171101190119.GL1030@ziepe.ca>
 <CAFgAxU9FZQC3JC6sEjB9W3YqHyF5StJ8_=mDQsF0eCWr9010hw@mail.gmail.com>
 <20171101211629.GA18874@ziepe.ca>
 <CAFgAxU8GNEiyzwHqrYyxs8J7T0TUqmN7JrZukkA0JgYSgY8FoA@mail.gmail.com>
 <20171102153848.GF18874@ziepe.ca>
 <CAFgAxU_Ouzk1bsBpZ==gTetD3OVGVosgeJRvwqErqz5s2utHBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFgAxU_Ouzk1bsBpZ==gTetD3OVGVosgeJRvwqErqz5s2utHBg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Guy Shattah <sguy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 02, 2017 at 06:11:07PM +0200, Alex Rosenbaum wrote:
> On Thu, Nov 2, 2017 at 5:38 PM, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> wrote:
> > On Thu, Nov 02, 2017 at 08:50:22AM +0200, Alex Rosenbaum wrote:
> >
> > So, if every path has a atomic/batch API, do you still want to include
> > the single counter add capability? It would be fine to me to drop the
> > object arg, but keep the single counter and differentiated API..
> 
> I think single counter add with user space bookkeeping is good and
> simple API for applciations.
> 
> what do you mean by "differentiated API"?
> do you mean keep the ibv_add_xxx_qp() but remove the ibv_qp object
> input parameter? same for flow?

Yes

> if yes, isn't it simpler to do ibv_create_counters_qp() or
> ibv_create_counters(QP), and keep a single non differentiated add
> sample counter point on a clearly defined ibv_counter

You want to have the counters object itself linked to only QP or only
flow? Why?

The counter object should be able to aggregate counting
anything so that a single kernel round trip will return all of the
desired counters on any sort of object.

The point of the per-object differentiation is to keep the counter
labling simpler:

 ibv_add_sampling_point(counters, 0, QP, RX_BYTES)
 ibv_add_sampling_point(counters, 1, FLOW, RX_BYTES)
 ibv_add_sampling_point(counters, 2, QP, RX_PACKETS)
 ibv_add_sampling_point(counters, 3, FLOW, RX_PACKETS)

vs

 ibv_add_sampling_point(counters, 0, RX_BYTES_QP)
 ibv_add_sampling_point(counters, 1, RX_BYTES_FLOW)
[..]

Observing that most of the things we will want to count will likely
apply equally to qps, flows and other things. # packets, # bytes,
in/out versions, etc.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
