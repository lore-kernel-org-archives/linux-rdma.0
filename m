From: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: Why is Infiniband a "Lossless" medium?
Date: Sun, 16 Mar 2014 13:51:53 +0000
Message-ID: <6B2A6E60C06CCC42AE31809BF572352B9ABACD98@MTLDAG01.mtl.com>
References: <CADPSxAgq1YAY09A46jurpiuXiq4Ohboqnts4a0qt3BE0K_PW7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADPSxAgq1YAY09A46jurpiuXiq4Ohboqnts4a0qt3BE0K_PW7g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Anuj Kalia
> Sent: Sunday, March 16, 2014 7:13 AM
> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Why is Infiniband a "Lossless" medium?
> 
> Infiniband has unreliable transports (UC and UD) which do not use
> hardware ACKs. Does this mean that they actually suffer from packet
> loss? If so, in what context is Infiniband a lossless medium?

Infiniband is a lossless medium in the aspect of the switches and L2 buffering.
This means that if the switch or HCA does not have buffer space to receive a packet, the remote side will not send it.

Packet loss can still occur if there is physical level signal issue, or if the receiver did not post a receive WQE for the incoming message.
However, the first event is relatively rare, and the second will not happen if you are using RDMA writes over UC.

> 
> My experience suggests that even unreliable transports do *not*
> witness packet loss. I have 20 client machines bombarding one server
> machine with RDMA writes over UC, and all the (billions) operations
> complete successfully. Further, each clients gets throttled when more
> client machines are added - suggesting some flow control. So, does
> this mean that flow control kicks in even in unreliable transports,
> i.e., is Infiniband's hardware level flow control decoupled from its
> ACK mechanism?

Yes, there is an hardware level flow control, which is done hop by hop, using a per-VL credits.

> 
> I only have access to a small cluster -- will I see packet loss in
> larger clusters? Or is the "unreliability" of UC and UD restricted to
> packet reordering only?

 You will see packet loss only if you are having BER issues, or in case the receiver is not posting receive WQEs fast enough.
Packet reordering should be extremely rare in any case, and only happen if the SM reconfigured the network.
Note that the order of received packets is not guaranteed if different senders sent them to the same receiving UD QP.
> 
> Thanks for your help!
You are welcome.

--Shachar 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
