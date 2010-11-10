From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: asynchronous operation with poll()
Date: Wed, 10 Nov 2010 10:56:33 -0700
Message-ID: <20101110175633.GI909@obsidianresearch.com>
References: <ibbr34$ima$1@dough.gmane.org>
 <20101109204452.GG909@obsidianresearch.com>
 <ibeaq8$egv$1@dough.gmane.org>
 <adak4klqdlb.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adak4klqdlb.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Jonathan Rosser <jonathan.rosser-gjMux1o1B1/QXOPxS62xeg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 10, 2010 at 09:43:12AM -0800, Roland Dreier wrote:
>  > Could I get some clarification on where there is no ordering
>  > guarantee? The WC's do not necessarily come back in the order that the
>  > sends were posted?
> 
> For a given queue, completions are always returned in the order that
> work requests were posted.  However there is no ordering between
> different queues.

Right, so if you design a scheme where getting a recv grants a send
credit then you are doing

  Post Send #1    ---> Recv WC
  Recv WC        <---- Post Send #2
  Send WC #2           Send WC #2
  PostSend #3     ---> Recv WC

and there is no order guarentee for when you get a Recv WC vs a Send
WC, even though by protocol design they are in fact ordered. If you
load the HCA the Send Complete WC's do get behind Recv WCs.

This is true even if you use the same CQ for Recv WC and Send Complete
WCs.

In practice this can make the implementation quite troublesome since
the posting of a new Send can't necessarily be done in the Recv WC
path as no send buffers could be available at that time.

I've found properly placing all the activities in a RDMA system to be
the hardest challenge of the whole design. Avoiding deadlock and
starvation and untangling the various data dependencies can be
hard :(

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
