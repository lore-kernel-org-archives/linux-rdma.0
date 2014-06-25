From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: why flipping responder_resources/initiator_depth?
Date: Wed, 25 Jun 2014 15:08:18 -0600
Message-ID: <20140625210818.GA14703@obsidianresearch.com>
References: <53A688FB.6070600@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A823739931CCAD@ORSMSX109.amr.corp.intel.com>
 <CAJZOPZKqYiGpxi8bjDu5TBu0G6EX_DjRLvEVhNDTy9L79h6MbQ@mail.gmail.com>
 <20140623164938.GA23697@obsidianresearch.com>
 <CAJZOPZJHM1v62kr1_8X2cZXxftNqtC+ngMKNz64eFNFrxyXbAg@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A823739931FEF9@ORSMSX109.amr.corp.intel.com>
 <20140623183455.GA3879@obsidianresearch.com>
 <CAJZOPZ+3HN7YWPUdhXvFopx2JiqtAzG5cfrK+8we92=KzDyDDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJZOPZ+3HN7YWPUdhXvFopx2JiqtAzG5cfrK+8we92=KzDyDDA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 25, 2014 at 11:51:41PM +0300, Or Gerlitz wrote:
 
> The rdma-cm doesn't do any flipping, it just provides the relevant IB
> CM call with the params as given by the application, see

Sure, that is what I mean. The IB spec has a protocol for negotiating
responder resources. I outlined how it works in a prior email. 

IB CM and RDMA CM both push responsibility to implement the protocol
to the app.

The app needs to be aware of the flipped names when it implements it.

Otherwise the flipped names don't matter, if you dig into it enough
you can figure out what value from the IB CMA defined MAD ends up in
what structure member during the app callback, for every callback.

If you implement an app that uses responder resources, and doesn't
implement the IB defined negotation protocol then it is broken.

The most common thing that needs to be done is to limit things to HW
capability, and to use values that reflect the apps use of the QP (eg
0 if no RRs are used in a direction). The spec has all the details.

For your immediate case, I suspect the path you need to follow is to
implement the negotiation protocol, then you can have your client
stuff in 0 for initiator_depth and when the protocol is followed the
server will avoid allocating any RRs.

To that end the confusing swapping of the labels is just confusing,
you can still implement the protocol properly. 

Bonus points if you can add some kind of core code support to
implement the protocol in common code based on both sides telling the
core what their initiator depth will be.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
