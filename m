From: Greg Kerr <kerr.g-movQPkccWJngpn9g0Uvcdg@public.gmane.org>
Subject: Infiniband poll_cq : nothing on queue
Date: Thu, 17 Mar 2011 18:09:18 -0400
Message-ID: <201103171809.19293.kerr.g@husky.neu.edu>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Sorry if this meant to be a kernel dev only mailing list, but I'm working on 
an Infiniband program, and am having a problem that seems to have no obvious 
answer. I was hoping someone here could nudge me in the right direction (since 
right now I'm search around blindly).

When I run ibv_post_send and ibv_post_recv on both nodes, no error is 
returned, but ibv_poll_cq never finds any completions on the queue. I was 
wondering what could be the cause of this, since I've spent a few days looking 
now.

The dest_qp_num seems fine on both nodes, as do the rq_psn and sq_psn.
I'm not sure where else there could be a problem.

To provide more background information I ran ibdump on my program (on both
nodes) and then analyzed the output in Wireshark. Basically node1 shows
nothing but RC Acknowledge packets and Node 2 shows nothing but RC Send
First packets. Does that reveal anything about where the problem likely
lies?

Of course if I look at the output of, say, ibv_rc_pingpong in Wireshark both
nodes show RC Send First, RC Send Middle, and RC Send Last packets, among
others.

I know this is too vague to really pinpoint my problem but I am hoping
someone can nudge me in the right direction of where I might try looking
(since nothing I've looked at so far has identified any clear problems).

Thanks,

Greg Kerr
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
