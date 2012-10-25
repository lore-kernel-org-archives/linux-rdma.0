From: kenneth vitagliano <kenvitagliano-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Questions about IB_WR_RDMA_READ_WITH_INV and IB_WR_SEND_WITH_INV opcodes
Date: Thu, 25 Oct 2012 11:09:33 +0200
Message-ID: <CAKgG1fzodm5qPmokjOG_OTsXOFmU+nd4H1z3Kqq-A-ixpYDO_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I am currently working with OFED, and I have a few concerns.

If there is any documentation with the answers to the questions below,
please link it to me, thanks.

Can someone please confirm the usage of the post_send opcodes
IB_WR_RDMA_READ_WITH_INV and IB_WR_SEND_WITH_INV:

As far as I understood, they are used to invalidate the local MR.

Post sending a *WITH_INV will result in sending data to, or reading
data from the remote side, then invalidate the local MR.

It is equivalent as chaining 2 WRs, the first doing the send/read
operation, the second using the IB_WR_LOCAL_INV opcode. Again, as far
as I understand.

So first question, why only send and read, and no write? I might be
missing a general use case here.

The IB_WR_LOCAL_INV uses the wr.ex.invalidate_rkey field. Why the rkey?
If the side invalidating its local MR does a RDMA_READ operation, it
means it has the raddr and rkey, not the contrary. So why invalidate
the local rkey while the remote side is not supposed the perform RDMA
operation locally?
(Same remark as above, I might be missing the use case).
Or does it assume the lkey and rkey are the same? (And then, if yes, why?)

Maybe with a brief example on how to use them it would be clearer.

Thanks,

Kenneth.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
