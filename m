From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: identify the race condition in this code and win the respect of
 linux-rdma developers!
Date: Fri, 16 Sep 2011 19:36:17 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E5B55E@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237316E5B2B1@ORSMSX101.amr.corp.intel.com>
 <20110916005008.GC6020@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A8237316E5B320@ORSMSX101.amr.corp.intel.com>
 <20110916155955.GA18548@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110916155955.GA18548-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> As I see it the problem flow would be this:
> 
> poll
> ibv_req_notify_cq
> // HCA Write CQ Entry
> // Trigger EVENT

Since the trigger event must be separate from writing the cq entry, if it doesn't happen until...

> poll -> return CQ
> 
> poll
> ibv_req_notify_cq // does nothing, event is already triggered

here, then the situation you describe can occur based on the spec.  And if we allow an implementation to make ibv_req_notify_cq a no-op if there is an event outstanding, the race condition is easier to hit.

> poll
> ibv_get_cq_event // returns immediately due to prior Trigger event
> poll
> ibv_get_cq_event // blocks because the CQ was never rearmed.

I changed the code to do this:

	do {
		poll
		rearm
		poll
		get_event
	} while (1);

which I believe fixes the issue.  Thanks for the help.  You are now the winner of my respect.  :)

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
