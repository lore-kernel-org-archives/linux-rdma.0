From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: why flipping responder_resources/initiator_depth?
Date: Wed, 25 Jun 2014 23:51:41 +0300
Message-ID: <CAJZOPZ+3HN7YWPUdhXvFopx2JiqtAzG5cfrK+8we92=KzDyDDA@mail.gmail.com>
References: <53A688FB.6070600@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A823739931CCAD@ORSMSX109.amr.corp.intel.com>
	<CAJZOPZKqYiGpxi8bjDu5TBu0G6EX_DjRLvEVhNDTy9L79h6MbQ@mail.gmail.com>
	<20140623164938.GA23697@obsidianresearch.com>
	<CAJZOPZJHM1v62kr1_8X2cZXxftNqtC+ngMKNz64eFNFrxyXbAg@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A823739931FEF9@ORSMSX109.amr.corp.intel.com>
	<20140623183455.GA3879@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140623183455.GA3879-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 23, 2014 at 9:34 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Mon, Jun 23, 2014 at 06:00:57PM +0000, Hefty, Sean wrote:

>> The behavior matches the documentation.  And the problem is...?

Sean, which documentation exactly?

[...]
> I haven't looked at how this all plays through with RDMA CM. But
> looking quickly, I don't see an obvious similar min in cma_connect_ib.

Jason,

The rdma-cm doesn't do any flipping, it just provides the relevant IB
CM call with the params as given by the application, see

cma_connect_ib() --> ib_send_cm_req()  and
cma_accept_ib()   --> ib_send_cm_rep()

As I wrote on the initial note, the flipping is done in the IB CM
before it invokes  the upper layer (e.g SRP/IPoIB/RDMA-CM/UCM)
provided callback in cm_format_req_event() and cm_format_rep_event()

> To my mind, the biggest issue is the common code does not seem to make
> it easy for apps to correctly implement the IBA negotiation protocol.

And also the Linux CM assumes the peer CM will apply the same flipping practice

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
