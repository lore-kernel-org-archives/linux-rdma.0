From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 03/47] RDMA/cma: Avoid triggering undefined behavior
Date: Fri, 6 Oct 2017 22:01:19 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB19C1DD@ORSMSX109.amr.corp.intel.com>
References: <20171006213333.6721-1-bart.vanassche@wdc.com>
 <20171006213333.6721-4-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171006213333.6721-4-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> According to the C standard the behavior of computations with integer
> operands is as follows:
> * A computation involving unsigned operands can never overflow,
>   because a result that cannot be represented by the resulting
>   unsigned integer type is reduced modulo the number that is one
>   greater than the largest value that can be represented by the
>   resulting type.
> * The behavior for signed integer underflow and overflow is
>   undefined.
> 
> Hence only use unsigned integers when checking for integer overflow.
> 
> This patch is what I came up with after having analyzed the following
> smatch warnings:
> 
> drivers/infiniband/core/cma.c:3448: cma_resolve_ib_udp() warn: signed
> overflow undefined. 'offset + conn_param->private_data_len <
> conn_param->private_data_len'
> drivers/infiniband/core/cma.c:3505: cma_connect_ib() warn: signed
> overflow undefined. 'offset + conn_param->private_data_len <
> conn_param->private_data_len'
> 
> Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>


Acked-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
