From: Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CQEs in unreliable connection
Date: Thu, 28 Nov 2013 21:49:11 +0200
Message-ID: <52979E37.3080000@gmail.com>
References: <CADPSxAhQKoKOQVbixMXvQRpp0_h1iQCtChrF0v1UUR1cZsPZvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADPSxAhQKoKOQVbixMXvQRpp0_h1iQCtChrF0v1UUR1cZsPZvA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Anuj.

On 28/11/2013 14:24, Anuj Kalia wrote:
> Hi.
>
> I had 2 questions related to RDMA operations (reads and writes) over
> unreliable connections:
>
> 1. Are WQEs issued over an unreliable connection supposed to generate
> CQEs? The Infiniband spec says that such WQEs may not generate an
> 'ACK'. I'm confused if ACK refers to CQE.
ACK is an acknowledgment that was sent over the wire that the message 
was received by the remote side.
CQE is a mechanism to indicate that a Work Request isn't outstanding 
anymore.

In RC QP, a CQE with successful status of a Send Request means that an 
ACK was received by the sender.
However, In UC QP, a CQE with successful status of a Send Request means 
that the message was sent;
it isn't indicate that the message was received by the remote side ...
(You will get a successful CQE even if the remote side didn't receive 
this message)

>
> 2. If the status of the work completion (fetched using ibv_poll_cq())
> is IBV_WC_SUCCESS, does it mean that the operation was successful at
> the remote host (even though we used an unreliable connection)?
I answered your answer above ...

If you want some more information, you are welcome to read it in:
http://www.rdmamojo.com/2013/06/01/which-queue-pair-type-to-use/


Thanks
Dotan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
