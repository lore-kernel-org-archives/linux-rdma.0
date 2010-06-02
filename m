From: Bryan Green <bryan.d.green-NSQ8wuThN14@public.gmane.org>
Subject: librdmacm: select() gives false positive on cm channel file descriptor
Date: Tue, 01 Jun 2010 17:04:56 -0700
Message-ID: <20100602000456.A4C10225DA@vis06.nas.nasa.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I'm looking for some help with a problem I'm having with librdmacm.

I have been using the select() call to detect when a disconnect event is
pending on the rdma_cm event channel (while also waiting for completion queue
events).

On the client side, things seem to work fine.
On the server side, I get a false positive from select() if I'm also waiting
for completion notification on a completion channel.

If I comment out any one piece of the code involving the completion event -
the ibv_req_notify_cq(), the ibv_post_send(), or the FD_SET(comp_channel) -
then I do not get the false positive.  But if I've done all the steps
necessary to detect the completion of my send operation, select() returns
immediately with an indication that the rdma_cm channel is readable, though a
call to rdma_get_cm_event() just blocks because there are no events pending.

Any insights into what the problem might be?
I can provide code for a simple client and server that demonstrate the problem.
I've been testing on a system with SLES 10, and the librdmacm version appears
to be 1.0.11.

Thanks,
-Bryan

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
