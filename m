From: Christopher Mitchell <christopher-1z5WdJkP5Frk1uMJSBkQmQ@public.gmane.org>
Subject: rdma_connect() and IBV_QPT_UC
Date: Wed, 4 Feb 2015 20:39:38 -0500
Message-ID: <CAPb9-SGWZmHnGQa+7Y72iBwDftsUeprFF3cGKDnf=RAAOSUo_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey there,

I have a fairly complex system that I've built over the last few years
as part of my PhD that uses reliable connections for message-passing
and RDMA. After reading a recent paper, I decided to compare the
performance of message-passing over unreliable connections for the
sake of completeness, but unfortunately, I've repeatedly run into
obstacles trying to switch to using the UC mode. I even wrote a tiny
client and server that simply opens a connection, sends a message, and
sends a response, and when I switch from RC to UC, the rdma_accept()
at the server always fails with EINVAL when trying to accept the
client's rdma_connect(). I'm afraid documentation, source code, and
experimentation have left me stymied. I have tried using RDMA_PS_IB
and RDMA_PS_UDP instead of RDMA_PS_TCP in rdma_create_id() to no
avail, I've experimented with qp_attr fields, and my MWE shows the
same problems as the larger system. Any assistance woudl be greatly
appreciated, and I'd be happy to provide more details about my setup
of the event channel, queue pair, buffers, and so on if necessary.

Cheers,
Christopher
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
