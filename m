From: Jonathan Rosser <jonathan.rosser-gjMux1o1B1/QXOPxS62xeg@public.gmane.org>
Subject: Re: asynchronous operation with poll()
Date: Wed, 10 Nov 2010 14:39:03 +0000
Message-ID: <ibeaq8$egv$1@dough.gmane.org>
References: <ibbr34$ima$1@dough.gmane.org> <20101109204452.GG909@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101109204452.GG909-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/09/10 20:44, Jason Gunthorpe wrote:
> Broadly it looks to me like your actions are in the wrong order.
> A poll based RDMA loop should look like this:
>
> - exit poll
> - Check poll bit
> - call ibv_get_cq_event
> - call ibv_req_notify_cq
> - repeatedly call ibv_poll_cq (while rc == num requested)
> - Issue new work
> - return to poll
>
> Generally, for your own sanity, I recommend splitting into 3 functions
> - Do the stuff with ibv_get_cq_event
> - Drain and process WC's
> - Issue new work
>

Hi Jason,

Thanks very much for your advice. I had misunderstood the relationship 
between CQ events and available WC's.

> doing multithreaded things. Using num_send is wrong, I use this:
>
 > bool checkCQPoll(struct pollfd&p)

Right - using a function like your checkCQPoll has sorted out the 
behaviour of the poll() loop.

> Continually posting sends and recvs will get you into trouble, you
> will run out of recvs and get RNR's. These days the wisdom for
> implementing RDMA is that you should have explicit message flow

OK - I appreciate that a real world protocol ought to have flow control 
rather than just send as fast as possible. I've been trying to exercise 
the interfaces as far as possible and make sure my RDMA implementation 
is solid before building something real on top of it.

> control. Ie for something simple like this you could say that getting
> a recv means another send is OK, but you still need a mechanism to
> wait for a send buffer to be returned on the send CQ - there is no
> ordering guarantee.

Could I get some clarification on where there is no ordering guarantee? 
The WC's do not necessarily come back in the order that the sends were 
posted?


Many Thanks,
Jonathan.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
