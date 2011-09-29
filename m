From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: IBV_WC_LOC_QP_OP_ERR for IBV_WR_RDMA_READ
Date: Thu, 29 Sep 2011 20:06:04 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E688C5@ORSMSX101.amr.corp.intel.com>
References: <OF7C5A38BC.B42C48EA-ON8825791A.006C2F2E-8625791A.006C7AA0@sybase.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <OF7C5A38BC.B42C48EA-ON8825791A.006C2F2E-8625791A.006C7AA0-iQUyExClMxnQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "David.Wein-iQUyExClMxnQT0dZR+AlfA@public.gmane.org" <David.Wein-iQUyExClMxnQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Thanks for responding Roland.  I wasn't setting these up.  I've added a
> call to ibv_modify_qp to set these but it doesn't help.  I even explicitly
> set the access rights on the QP
> 
>         qp_attr.max_rd_atomic = 32;
>         qp_attr.max_dest_rd_atomic = 32;
>         qp_attr.qp_access_flags = (IBV_ACCESS_LOCAL_WRITE |
>                                    IBV_ACCESS_REMOTE_WRITE |
>                                    IBV_ACCESS_REMOTE_READ);
> 
>         if (ibv_modify_qp(this->rl_cmid->qp, &qp_attr,
>                           IBV_QP_MAX_QP_RD_ATOMIC |
>                           IBV_QP_MAX_DEST_RD_ATOMIC |
>                           IBV_QP_ACCESS_FLAGS) == -1)
>         {
>                 printf("Failed to modify qp attributes, errno %d", errno);
>                 return -1;
>         }

When are you making this call?  When the QP is transitioned from RTR to RTS, the number of outstanding RDMA read requests must also be specified.  It's best to set these values during the state transition.

> The first read still throws an error.  I'm looked at the ping-rdma sample
> code and it doesn't do the ibv_modify_qp either.  Annoyingly, it works
> find with RDMA_READ on my system.  I've compared the qp initialization and
> the work request between the working sample app and my code, and don't see
> anything that looks wrong.  Again, send / receive and rdma write work find
> on this qp.

What specific sample code are you looking at?

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
