From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 2/2] RPING: Remove printf for FLUSH completion.
Date: Thu, 21 Oct 2010 07:30:34 -0500
Message-ID: <4CC0326A.4080802@opengridcomputing.com>
References: <20101020192859.1431.68877.stgit@build.ogc.int> <20101020192905.1431.40267.stgit@build.ogc.int> <CF9C39F99A89134C9CF9C4CCB68B8DDF25B801FB15@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B801FB15-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/20/2010 4:12 PM, Hefty, Sean wrote:
> I applied this, but am waiting on the other patch until the discussion finishes up.

Since pthread_cancel() seems to be iffy for user verbs, maybe I'll try 
another approach:  Since the rping main thread issues an 
rdma_disconnect(), we can assume that the CQ thread will definitely get 
an event and then poll the FLUSHED recv wr and pthread_exit().  So the 
main thread only needs to do a pthread_join() after issuing the 
disconnect.  I'll try this approach on iWARP and IB transports to make 
sure my assumptions are true...

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
