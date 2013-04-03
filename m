From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: XRC and ib_poll_cq
Date: Wed, 3 Apr 2013 09:26:42 +0300
Message-ID: <515BCBA2.5010600@mellanox.com>
References: 1828884A29C6694DAF28B7E6B8A823736F369FCB () ORSMSX101 ! amr ! corp ! intel ! com <515B393F.2080405@mellanox.com> <1828884A29C6694DAF28B7E6B8A823736F36A119@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823736F36A119-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/3/2013 3:35 AM, Hefty, Sean wrote:
>> Thanks, it seems that I asked the question in a wrong way.
>> The context is what I need eventually but in order to find it I first
>> need to recover the QP or the XRC SRQ.
>> Per core there may be several QP and SRQ using the same CQ.
>> When doing ib_poll_cq on the CQ the WQE in hand has only an ib_qp pointer.
> Correct - dereference the qp pointer to get the context, srq, and srq_context.
>
> struct ib_wc wc;
>
> ib_poll_cq(...&wc)
> my_qp = wc.qp;
> my_qp_context = wc.qp->qp_context;
> my_srq = wc.qp->srq;
> my_srq_context = wc.qp->srq->srq_context;
>
> this tells you what QP/SRQ the completion is related to.
Hi Sean,

Your answer actually raises another question.
According to the annex the XRC SRQ is used directly (it is like an RD QP 
but without a requester side), and also in the user space example 
"xrc_pingpong.c" no QP is created on-top of the XRC SRQ.
So the question is what is this QP that you de-referenced in the 
statement "my_srq = wc.qp->srq;"?
Is it just and artifact of the implementation?

S.P.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
