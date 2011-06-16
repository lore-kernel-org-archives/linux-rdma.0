From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/17] rdma/core: Add SRQ type
Date: Thu, 16 Jun 2011 17:54:27 +0300
Message-ID: <4DFA1923.8080201@mellanox.com>
References: <1828884A29C6694DAF28B7E6B8A82373020FFA@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373020FFA-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hefty, Sean wrote:
> Currently, there is only a single type of SRQ, but with XRC support
> we will add a second.  Prepare for this by defining an SRQ type and
> setting all current users to IB_SRQT_BASIC.

I don't see mlx4 in the hw drivers list, probably you handle it later 
on, to have things clearer and bisect-able, I guess you might want to 
touch mlx4 already at this point of the series?

Or.

>  drivers/infiniband/hw/ehca/ehca_qp.c         |    3 +++
>  drivers/infiniband/hw/ipath/ipath_srq.c      |    5 +++++
>  drivers/infiniband/hw/mthca/mthca_provider.c |    3 +++
>  drivers/infiniband/hw/qib/qib_srq.c          |    5 +++++

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
