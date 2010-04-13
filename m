From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: two questions about RDMA-WRITE
Date: Tue, 13 Apr 2010 09:50:20 -0500
Message-ID: <4BC484AC.80804@opengridcomputing.com>
References: <q2v7bb361261004130308za7b4d6ccj6fdb657b7c7cc7e9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <q2v7bb361261004130308za7b4d6ccj6fdb657b7c7cc7e9-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?GB2312?B?tqG2qLuq?= <dingdinghua85-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

=B6=A1=B6=A8=BB=AA wrote:
> Hi guys:
> I'm doing a project using RDMA to transfer data between servers.  I'm
> using RDMA_PS_TCP type and do RDMA_WRITE operations from client node
> to server node. While the program succeed in setting up connection an=
d
> transferring data, I 'm still very confused about two problems:
> (1)  After transfer the data using IB_WR_RDMA_WRITE , the complete
> queue entry found that the opcode turned from IB_WR_RDMA_WRITE to
> IB_WR_RDMA_WRITE_WITH_IMM, I don't know the meaning of this opcode an=
d
> the reason of the change.
>  =20

The opcode in the completion is of type enum ib_wc_opcode, not enum
ib_wr_opcode. You are mis-interpreting the opcode in the completion.

> (2)  It takes a long time to finish rdma_disconnect work (about 10
> seconds), so is it a reasonable time?
>  =20

What device are you using?


Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
