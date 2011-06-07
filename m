From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: need pointer to Understand how to use
 IBV_WR_RDMA_WRITE_WITH_IMM
Date: Tue, 7 Jun 2011 10:43:33 -0600
Message-ID: <20110607164333.GB24005@obsidianresearch.com>
References: <BANLkTikC6jPFJm=MxT5oNDoJH4Ex+j41XA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BANLkTikC6jPFJm=MxT5oNDoJH4Ex+j41XA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benoit Hudzia <benoit.hudzia-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 07, 2011 at 01:23:01PM +0100, Benoit Hudzia wrote:

> I would like to use IBV_WR_RDMA_WRITE_WITH_IMM , however I am facing
> difficulty to find documentation or example on how to use such
> feature. ?The idea would be to do an RDMA write and wake up the peer
> upon reception in order to process the received data.

You basically have it correct, but generally you also need to mix SEND
traffic on the same QP as you are doing these RDMAs, at a minimum to
manage the allocation of receive resources. Since you can't know if
the remote will place a RDMA+IMM or a SEND into your receive WR you
need to ensure that all of them that are posted are able to handle a
SEND. If you get an IMM then ignore the payload, process the imm_data
recycle the WR back into the HCA, and schedule a signal to the far
side you now have additional receive WR space.

>       a.?????? Question : can i fill the imm_data with arbitrary data?
> I would like to use this field on the peer side to identify the
> request

Keep in mind the imm_data is copied byte-for-byte so you should put it
in a sensible endian-ness for your application.

A simple example of a protocol using this might be:

 SEND [My RDMA Recv buffer is XX-YY, I have RR recv WRs posted]
           SEND [OK, I have RR recv WRs posted]
           RDMA WRITE [IMM = I wrote ZZ bytes]
           RDMA WRITE [IMM = I wrote ZZ bytes]
           RDMA WRITE [IMM = I wrote ZZ bytes]
           RDMA WRITE [IMM = I wrote ZZ bytes]
           RDMA WRITE [IMM = I wrote ZZ bytes]
 SEND [I have RR recv WRs posted]
           RDMA WRITE [IMM = I wrote ZZ bytes]
           RDMA WRITE [IMM = I wrote ZZ bytes]
           RDMA WRITE [IMM = I wrote ZZ bytes]
           RDMA WRITE [IMM = I wrote ZZ bytes]
 SEND [I have RR recv WRs posted]
           RDMA WRITE [IMM = I wrote ZZ bytes]
           RDMA WRITE [IMM = I wrote ZZ bytes]
           SEND [I have RR recv WRs posted]
 SEND [I have RR recv WRs posted]
           RDMA WRITE [IMM = I wrote ZZ bytes]
           RDMA WRITE [IMM = I wrote ZZ bytes]
[etc..]

With a scheme like this all recive work posts would include a recv
buffer to handle a SEND receive completion, and each side would stop
sending when it runs out of recv completion space on the far
side. Generally with a scheme like this some care is needed to avoid
deadlocking because you want to be a bit lazy with flow control sends.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
