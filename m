From: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: RE: [PATCH v2 4/4] rsockets: acknowledge completion queue events in
 batch
Date: Sun, 07 Sep 2014 08:31:26 +0530
Message-ID: <e6c1db3bba657539303af831e1ebf8d0@imap.linux.ibm.com>
References: <c144abfe27bd0bf36ff1e3c9c912d7c3@imap.linux.ibm.com>
 <1828884A29C6694DAF28B7E6B8A8237399DC1B64@ORSMSX109.amr.corp.intel.com>
 <d52658b2f68bc014103e655857096b4a@imap.linux.ibm.com>
 <1828884A29C6694DAF28B7E6B8A8237399DC36C7@FMSMSX154.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237399DC36C7-Q3cL8pyY+6s64kNsxIetb7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2014-09-06 22:07, Hefty, Sean wrote:
>> That's indeed a good approach.  But, we need to have an upper limit
>> before a batch of events is flushed.  Can we decide limit based on
>> completion event queue size?
> 
> I think that's fine.  We only need to ack before wrapping the 32-bit
> value, plus ensure that everything is acked when closing the rsocket.
> 

Sure.  I will revert back to you with modified patch.

> But, does this change really make any difference?  At the point where
> ack is called, there's no contention, so the overhead seems small
> considering that we in a part of the code where we likely just blocked
> the thread.

Yes.  It indeed makes a small improvement when all cores are fully
saturated in a scale-up environments.

Thank You.

- Sreedhar

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
