From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: why flipping responder_resources/initiator_depth?
Date: Mon, 23 Jun 2014 12:34:55 -0600
Message-ID: <20140623183455.GA3879@obsidianresearch.com>
References: <53A688FB.6070600@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A823739931CCAD@ORSMSX109.amr.corp.intel.com>
 <CAJZOPZKqYiGpxi8bjDu5TBu0G6EX_DjRLvEVhNDTy9L79h6MbQ@mail.gmail.com>
 <20140623164938.GA23697@obsidianresearch.com>
 <CAJZOPZJHM1v62kr1_8X2cZXxftNqtC+ngMKNz64eFNFrxyXbAg@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A823739931FEF9@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823739931FEF9-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 23, 2014 at 06:00:57PM +0000, Hefty, Sean wrote:
> > > The swapping and general missing handling of RR negotiating in the
> > > whole kernel CM API (not just RDMA CM, but IB CM too) is a
> > > longstanding bug, and I have written user space code that fixes it up
> > > in the past :(
> > 
> > Jason, the swapping takes place in the IB CM indeed, I just used the
> > wording from the librdmacm man pages to described the desired
> > behaviour as I see it. Did you ever repored to the swapping on this
> > list in the past? when?
> 
> The behavior matches the documentation.  And the problem is...?

The problem is this whole thing is a giant gotcha if you don't
intimitely understand exactly what the spec requires, and naively
assume the kernel does something sane, or even provides you the values
the spec says you need in fields that are named the same as the spec.

If you use the IB CM in userspace you need to hook IB_CM_REQ_RECEIVED
and do something like this:

    /* Note, req.responder_resources and req.initiator_depth are swapped
       in the kernel. FIXME: this works around the kernel not implementing
       the negotation procedure by doing it here */
    rep.responder_resources = min((int)req.responder_resources,
                                       devAttr.max_qp_rd_atom);
    rep.initiator_depth = min((int)req.initiator_depth,
                                   devAttr.max_qp_init_rd_atom);

So
 1) The kernel swapped the values before passing them to userspace,
    (and other kernel consumers). So this becomes very confusing if
    you are not aware that req.responders_resources is not actually
    what the IBA spec describes as REQ responderResources.
 2) The kernel doesn't do anything to help implement the IBA sepc
    required negotiation, it doesn't limit to HCA values, for instance
    after getting a REQ.
 3) There is no aide to help a simple app developer do this right, and
    almost everyone I've ever looked at just passes 2 in for both
    values and hopes for the best.
 4) Other elements of the negotiation procedure I outlined above seem
    to be missing, like the sanity check of the REP, and the
    generation of REJ if the values are not acceptable. 

I haven't looked at how this all plays through with RDMA CM. But
looking quickly, I don't see an obvious similar min in cma_connect_ib.

To my mind, the biggest issue is the common code does not seem to make
it easy for apps to correctly implement the IBA negotiation protocol.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
