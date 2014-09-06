From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2 4/4] rsockets: acknowledge completion queue events in
 batch
Date: Sat, 6 Sep 2014 16:37:02 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237399DC36C7@FMSMSX154.amr.corp.intel.com>
References: <c144abfe27bd0bf36ff1e3c9c912d7c3@imap.linux.ibm.com>
 <1828884A29C6694DAF28B7E6B8A8237399DC1B64@ORSMSX109.amr.corp.intel.com>
 <d52658b2f68bc014103e655857096b4a@imap.linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d52658b2f68bc014103e655857096b4a-FJGp5E75HVmZamtmwQBW5tBPR1lH4CV8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> That's indeed a good approach.  But, we need to have an upper limit
> before a batch of events is flushed.  Can we decide limit based on
> completion event queue size?

I think that's fine.  We only need to ack before wrapping the 32-bit value, plus ensure that everything is acked when closing the rsocket.

But, does this change really make any difference?  At the point where ack is called, there's no contention, so the overhead seems small considering that we in a part of the code where we likely just blocked the thread.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
