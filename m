From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Why is Infiniband a "Lossless" medium?
Date: Sun, 16 Mar 2014 01:12:57 -0400
Message-ID: <CADPSxAgq1YAY09A46jurpiuXiq4Ohboqnts4a0qt3BE0K_PW7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Infiniband has unreliable transports (UC and UD) which do not use
hardware ACKs. Does this mean that they actually suffer from packet
loss? If so, in what context is Infiniband a lossless medium?

My experience suggests that even unreliable transports do *not*
witness packet loss. I have 20 client machines bombarding one server
machine with RDMA writes over UC, and all the (billions) operations
complete successfully. Further, each clients gets throttled when more
client machines are added - suggesting some flow control. So, does
this mean that flow control kicks in even in unreliable transports,
i.e., is Infiniband's hardware level flow control decoupled from its
ACK mechanism?

I only have access to a small cluster -- will I see packet loss in
larger clusters? Or is the "unreliability" of UC and UD restricted to
packet reordering only?

Thanks for your help!

--Anuj Kalia
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
