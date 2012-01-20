From: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Subject: Re: [PATCH] core/verb.c: fix kernel panic: always initialize struct
 ib_qp *qp->usecnt
Date: Fri, 20 Jan 2012 17:14:46 +0100
Message-ID: <4F1992F6.9070103@itwm.fraunhofer.de>
References: <20120119194641.1391553.39048.stgit@localhost.localdomain> <1828884A29C6694DAF28B7E6B8A823732DC0C33E@ORSMSX106.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823732DC0C33E-P5GAC/sN6hlZtRGVdHMbwrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Sven Breuner <sven.breuner-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hmm, I think we do have serious problem with the hole approach. While 
the patch works for the kernel side, there is a problem with user space 
libraries. So I monitored our daemons and noticed ibv_destroy_cq() 
failed. The reason again seems to be the same issue as already fixed for 
kernel qp's. So in __ibv_create_qp() (libibverbs/src/verbs.c):

> __ibv_create_qp()

> 	struct ibv_qp *qp = pd->context->ops.create_qp(pd, qp_init_attr);
>
> 	if (qp) {
> 		qp->context    	     = pd->context;
> 		qp->qp_context 	     = qp_init_attr->qp_context;
> 		qp->pd         	     = pd;
> 		qp->send_cq    	     = qp_init_attr->send_cq;
[...]

I *guess* the qp allocated by pd->context->ops.create_qp() does not have 
qp->usecnt initialized (not does it know anything about it). So its 
random value will fail the destruction later. A simple workaround that 
would work for us, is to extend the patch I send to

diff --git a/drivers/infiniband/core/verbs.c 
b/drivers/infiniband/core/verbs.c
index 602b1bd..fba1675 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -874,7 +874,7 @@ int ib_destroy_qp(struct ib_qp *qp)
         struct ib_srq *srq;
         int ret;

-       if (atomic_read(&qp->usecnt))
+       if (qp->qp_type == IB_QPT_XRC_TGT && atomic_read(&qp->usecnt))
                 return -EBUSY;

         if (qp->real_qp != qp)



However, what is is with user space setting type to IB_QPT_XRC_TGT? I 
guess this could be solved by letting the kernel zero the memory 
returned by ->ops.create_qp(pd, qp_init_attr).
Btw, I didn't figure out yet, how this translates at all in kernel 
space? Is this op directly going to the device driver?

But even if we are properly going to initialize the qp, what is with 
user space mischievously trying to crash the system by manipulating 
struct ib_qp *qp?


Thanks,
Bernd


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
