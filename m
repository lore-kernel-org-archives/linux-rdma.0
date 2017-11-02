From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/16] Flow counters support
Date: Thu, 2 Nov 2017 09:38:48 -0600
Message-ID: <20171102153848.GF18874@ziepe.ca>
References: <20171027155955.GA15922@obsidianresearch.com>
 <CAFgAxU-UcRapsoRn3hNUn27xgY370gUJ+WWE4URBq84ufkCXtA@mail.gmail.com>
 <20171029180019.GE4488@ziepe.ca>
 <CAFgAxU_CMxQ616wBd-vkvyJ905ndLHrabmWtJ-Ye_hgSwWqiag@mail.gmail.com>
 <20171101181807.GJ1030@ziepe.ca>
 <CAFgAxU-DsOr9T9P6gqvZ9AviE45_34vZ1WUgUehmF-kb2j8JtQ@mail.gmail.com>
 <20171101190119.GL1030@ziepe.ca>
 <CAFgAxU9FZQC3JC6sEjB9W3YqHyF5StJ8_=mDQsF0eCWr9010hw@mail.gmail.com>
 <20171101211629.GA18874@ziepe.ca>
 <CAFgAxU8GNEiyzwHqrYyxs8J7T0TUqmN7JrZukkA0JgYSgY8FoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFgAxU8GNEiyzwHqrYyxs8J7T0TUqmN7JrZukkA0JgYSgY8FoA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Guy Shattah <sguy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 02, 2017 at 08:50:22AM +0200, Alex Rosenbaum wrote:

> by a ibv_modify_qp(qp, {attr{counter}}) or add some 'flush' flag/API,
> or 'more to come' flag until final add_sampling_poing_qp call.

Something along the lines of 'ibv_attach_counters_qp' or 'modify_qp'
(see other comments on overloading modify) is reasonable to me.

So, if every path has a atomic/batch API, do you still want to include
the single counter add capability? It would be fine to me to drop the
object arg, but keep the single counter and differentiated API..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
