From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC rdma-core] Verbs: Introduce resource domain
Date: Wed, 20 Sep 2017 19:41:46 -0600
Message-ID: <20170921014146.GA4041@obsidianresearch.com>
References: <1505648922-21346-1-git-send-email-yishaih@mellanox.com>
 <20170918205411.GB7059@obsidianresearch.com>
 <CAFgAxU9M0MXw371Nh2tviuQHXCJxnFLPtaAcsevigEMMWjUPhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFgAxU9M0MXw371Nh2tviuQHXCJxnFLPtaAcsevigEMMWjUPhA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Alex @ Mellanox" <Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 19, 2017 at 05:05:11PM +0300, Alex Rosenbaum wrote:
> On Mon, Sep 18, 2017 at 11:54 PM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> > On Sun, Sep 17, 2017 at 02:48:42PM +0300, Yishai Hadas wrote:
> >
> >> Resource domain represents a collection of IB resources (as of QP, CQ,
> >> etc.) which are accessed by an application from the same context (e.g.
> >> same thread) and as such can share hardware and software resources to
> >> allow smarter management of resources by the provider library and better
> >> performance.
> >
> > This sounds exactly like a PD to me. Why do we need another construct?
> > What is wrong with a 'thread-unsafe' flag during PD creation and then
> > contain the shared resources in the PD?
> 
> PD does not fit good enough. It is does not cover CQ's in allocation
> flow, but limited to QP's, SRQ's, WQ's.

Well, CQ could gain a PD parameter, so that isn't a big deal..

> Also, using multiple PD's will require to use a dedicated MR per PD,
> instead of sharing a single MR for the entire memory used over
> multiple threads / QP's.

This is a bigger problem, but it could be solved, if not a bit messy..

Your concept patch requires adding a new input to every single object
creation function, this is a pretty big API change..

On the other hand, the PD is already an input to almost all of the
required creation functions so it much less API churn.

But, as you say, you'd have to solve the MR sharing problem at least
to make PD workable. Perhaps some kind of 'child' PD that was only for
threading..

> >>       uint32_t                raw_packet_caps; /* Use ibv_raw_packet_caps */
> >> +     uint32_t                max_resource_domains;
> >
> > Even with this approach, not sure a max makes much sense, this value should
> > just be hashed into whatever range the provider has on a resource by
> > resource basis.
>
> By exposing the max_resource_domains we allow the application to take
> the decision of which element will get hurt if it reaches that limit.
> If we leave the logic hidden inside the libraries, the application
> losses control over the best performance vs average better
> performance.

That goes both ways, a single 'max' does not make sense if there are
multiple different sorts of objects being controlled (eg UAR and
something else). It only works well in your context of having a single
constrained UAR.

Probably the better option is to introduce something like a 'struct
verbs_locking_domain *' input which is a proper object and can have a
range of operators.

I would say each creating locking domain objects is just strided
across the various limited resouces in the device.

'dv' accessors, eg mlxdv_set_locking_uar() can be provided to directly
assign specific limited resources under the control of the
application. 'dv' query functions can be used to directly learn the
specific limits for each specific thing.

This way we don't have to revisit things. This would also be a good
place to centralize all the crazy no threading flags we have
accumulated in various places and ways (including the stupid
environment variables). a 'struct verbs_locking_domain' option that
switches off all internal locking would make sense too.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
