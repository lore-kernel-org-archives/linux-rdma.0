From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: Fw: About FRMR vec and SRQ post recv
Date: Mon, 08 Mar 2010 21:04:23 -0600
Message-ID: <4B95BAB7.3060409@opengridcomputing.com>
References: <201003072109161566975@inspur.com>, <201003072113223754872@inspur.com> <201003090948570789220@inspur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201003090948570789220-6gUaA8visnnQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: lihaidong <lihaidong-6gUaA8visnnQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> I try getting a summary. Give some comments on the following
> sentences,please.
> For local side(A), where data to be transferred is placed.
> send or RDMA Read/Write operations.
> the sge array in one send wr pointed by sgl_list should have the same
> [lr]key.
> a) one send wr could send two arbitrary regions when using dma mr's
> [lr]ley or local_dma_lkey
> b) one send wr could 'not' send two arbitrary regions registered by
> two FRWRs seperately.


b) is not true. If you register these 2 regions separately, then you can
certainly send them in one send wr, each being an sge entry in the wr.


>
> For remote side(B), where data transferred will be placed.
> 2) RDMA Read/Write operations could put data to
> a) a single physical continous region registerd
> b) two or more regions with contstraints that they could be registerd
> by one FRWR.
> c) could not put data to two regions registerd by two FRWR sperately
> since in side A, ib_send_wr.wr.rdma should specify one group
> {rkey,addr} for remote destination region.


This is all correct: The sink (aka the target) of a write or read is a
single rkey/addr/len. So to have it place into two separate regions, you
would need them to have been registered via fastreg-mr and thus they
would have to adhere to the constraints of a fastreg-mr.


>
> and send/recv operatons can also put data to
> c) two or more arbitrary regions using dma mr. since send operation in
> side A do not need remote {addr,rkey} and recv operation in side B
> could post two arbitrary regions using dma mr's lkey or local_dma_lkey
> in a singel recv_wr.
>

This is correct also. incoming sends will be placed into recv buffers as
specified in the sg list for the recv wr.


>
> I want to transfer data from two arbitrary regions of A to two
> arbitrary regions of B for a single RDMA Read/Write operation
> originally.And it seems impossible now.
>

you'll have to issue multiple reads or writes...


Steve
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
