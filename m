From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V2 for-next 2/6] IB/core: Add RSS and TSS QP groups
Date: Tue, 12 Feb 2013 18:59:49 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237368B9A0FE@ORSMSX101.amr.corp.intel.com>
References: <1360079337-8173-1-git-send-email-ogerlitz@mellanox.com>
	<1360079337-8173-3-git-send-email-ogerlitz@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A8237368B99E0B@ORSMSX101.amr.corp.intel.com>
 <CAJZOPZ+eT=UGfqbwyMn8BtKCei2t1RKj1auAhSbPphLF9A6eVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZ+eT=UGfqbwyMn8BtKCei2t1RKj1auAhSbPphLF9A6eVg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

My understanding of this is that there's NO changes to the wire protocols.

A QP is simply that, a pair of queues - one send, one receive.  To the best that I can figure out, you're wanting to allocate 'multiple-queues' - something that has multiple send and receive queues.  (I use the term MQ, because it seems to be the most appropriate based on my understanding.)  A QP can be viewed as a special case of a MQ.  Is single QPN is used on the wire for all queues which are part of a MQ?  Like a QP, each queue can have its own size and CQ.  So, they're independent.. except that they're dependent on some higher association, (referred to as a parent QP).

The user has the joy of not knowing beforehand how many queues will be allocated.  Just that they need to somehow allocate them all, transition them all into a usable state, and keep all of them in that state.  The extra queues are allocated by the HW, but the user still needs to specify how big they are, how many SGEs each should have, etc.  I'm guessing specifying a size of 0 isn't acceptable if the user really doesn't want it.  But it would be okay if it went unused... maybe?  There's no mention of what happens if a user fails to allocate all queues, destroys one of the queues but keeps the others, or has the queues in different states - such as transitioning the 'parent' QP into the error state.  It's not even clear to me if the 'parent QP' has send and receive queues, or if it even sh
 ould.

Honestly, I like to see the entire concept flushed out before trying to decide if the implementation matches up with what the architecture is trying to accomplish.  Maybe you end up with the same implementation, but there are details in the usage model that seem to be missing.  The email threads talk about UD, but wants to leave open the possibility of other QP types.  How would RC even work in this model?  How would it connect?  How do you manage associated QPs being in different states?  How would this export into user space?  How and when does the HW decide to direct receives to a specific queue?

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
