From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: why flipping responder_resources/initiator_depth?
Date: Mon, 23 Jun 2014 10:49:38 -0600
Message-ID: <20140623164938.GA23697@obsidianresearch.com>
References: <53A688FB.6070600@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A823739931CCAD@ORSMSX109.amr.corp.intel.com>
 <CAJZOPZKqYiGpxi8bjDu5TBu0G6EX_DjRLvEVhNDTy9L79h6MbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJZOPZKqYiGpxi8bjDu5TBu0G6EX_DjRLvEVhNDTy9L79h6MbQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 23, 2014 at 08:55:07AM +0300, Or Gerlitz wrote:
> 1. the client to put into the responder_resources they provide to
> rdma_connect the the maximum number of outstanding RDMA read that they
> will be able accept from the server side
> 
> 2. the server to apply a minimum function between the
> responder_resources which were advertized by the client (and they get
> in the connection request event params) to how many inflight
> rdma-reads  their HCA supports

>From a wire perspective the spec is pretty clear what the CM responder
resources and initiator depth are supposed to be, and the behavior of
#2 is mandated in the spec.

>From a API perspective it makes sense that the only input to the
the API would be 'the initiator depth the caller will use', which is
basically the only thing the caller actually controls. 0 if the client
never uses RDMA READ or ATOMICs, 1 if it is strictly interlocked, and
higher as necessary.

I'm not sure there is a use case to limit QP responder resources at
the caller? Maybe to specify '0' if the caller knows it will never
setup a remote readable MR?

So both sides pass in their desired initiator depth. Both sides limit
that to HCA init depth capabilities. The REQ side plugs that value
into REQ.initiatorDepth and the HCA capability into
REQ.responderResources.

The REQ responder takes min(REQ.responderResources,local
intiatorDepth) and returns that in REP.initiatorDepth. It takes
min(REQ.initiatorDepth, HW respres capability) and plugs that into the
local QP and returns it in REp.responderResources

The REQ initiator takes that reply and does
min(REP.responderResources,HW initdepth capability,API depth) and
plugs that into the QP and does checks that REP.initDepth <
REQ.responderResources and errors if false, and plugs REP.initDepth
into the local QP's responder resources.

The swapping and general missing handling of RR negotiating in the
whole kernel CM API (not just RDMA CM, but IB CM too) is a
longstanding bug, and I have written user space code that fixes it up
in the past :(

It works OK if both sides hard code 2 or 4, or whatever is 99% of use
cases, it is broken if you are doing what Or is talking about, and
optimizing RR usage because on half of a connection doesn't use RRs at
all.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
