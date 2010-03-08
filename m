From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: Fw: About FRMR vec and SRQ post recv
Date: Mon, 08 Mar 2010 08:58:03 -0600
Message-ID: <4B95107B.20503@opengridcomputing.com>
References: <201003072109161566975@inspur.com> <201003072113223754872@inspur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201003072113223754872-6gUaA8visnnQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: lihaidong <lihaidong-6gUaA8visnnQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

lihaidong wrote:
> Sorry.
> sge[1]= {vec1_addr, vec1_length, dma_lkey};
> should be
> sge[1]= {vec2_addr, vec2_length, dma_lkey};
> >Hi, Steve.
> >I have the following questions.
> >1)FRMR
> >I want transfer the data in vec1 and vec2 in node A to the two vecs
> with the same size in node B. Vecs' size is lower than a page.
> >A B
> >+--------+ +--------+
> >| vec1 | | vec1 |
> >+--------+ +--------+
> >
> >+--------+ +--------+
> >| vec2 | | vec2 |
> >+--------+ +--------+
> >
> >Could I use FRMR to register vec1 and vec2 as one Memory region?


yes. There are certain contstraints though. For example, vec1 has to be
physically contiguous and end on a page boundary, and vec2 would have to
start on a page boundary and be physically contiguous. IE fastreg mrs
are typically used to register an array of pages (not necessarily all
contiguous pages), not arbitrary regions.


> >If so, then they have the same rkey, and I could send them to remote
> peer for one time,right?



Yes, if you have the two vecs fast registered as one mr, then you could
send it using a single work request and even a single SGE in that work
request.



> >Or I have to register and send vec1 and vec2 seperately?
> >
> >If I use Send/Recv not RDMA Read/Write to send them. ie. I will use
> dma_mr's lkey/rkey, and let
> >sge[0]= {vec1_addr, vec1_length, dma_lkey};
> >sge[1]= {vec1_addr, vec1_length, dma_lkey};
> >ib_send_wr.sgl_list= sge;
> >

Not exactly. The result of fast registering those two regions would be a
single iova_base (aka the addr field in an SGE) and [lr]key. Those would
be used to describe the data in a send wr, probably as a single SGE.

It sounds like what you really need is either to use a dma mr or to
register the regions separately. Unless those vecs meet the criteria I
mentioned above..


> >and post send this wr. Is it allowed?
> >2) SRQ
> >SRQ's size is 1024, and I use ib_post_srq_recv 1024 times after
> getting SRQ created.
> >When cq_handler get a IB_WC_RECV event, do I need post another recv
> wr?(since in the case without SRQ, it would be yes)


I don't know much about SRQs, maybe someone else knows how these are
implemented.



Steve
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
