From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: identify the race condition in this code and win the respect of
 linux-rdma developers!
Date: Fri, 16 Sep 2011 16:57:00 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E5B3B8@ORSMSX101.amr.corp.intel.com>
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

> poll and cq_events are totally independent, I belive the implementation
> of CQ events is like:
> 
> enum {DISABLED,ARMED,TRIGGERED} flag;

I was suggesting that there were only 2 states, not 3, with ibv_get_cq_event() simply retrieving a queued event from the kernel without touching the CQ state.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
