From: David.Wein-iQUyExClMxnQT0dZR+AlfA@public.gmane.org
Subject: Re: IBV_WC_LOC_QP_OP_ERR for IBV_WR_RDMA_READ
Date: Thu, 29 Sep 2011 16:40:02 -0500
Message-ID: <OFF9ECDEA0.0854A87D-ON8825791A.00743004-8625791A.007705D2@sybase.com>
References: <OF7C5A38BC.B42C48EA-ON8825791A.006C2F2E-8625791A.006C7AA0@sybase.com> <CAL1RGDVaN58y4u6TtwWuhGMsUuGxMQJkObqHPk2J=Gt0nPAxOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDVaN58y4u6TtwWuhGMsUuGxMQJkObqHPk2J=Gt0nPAxOQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I'm using RDMA CM.  I am making the ibv_modify_qp() call immediately after 
rdma_create_qp().  Should I move this code after the rdma_connect() / 
rdma_accept()?

Sample code I am looking at is from the OFA coding course.

-Dave



From:
Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
To:
<David.Wein-iQUyExClMxnQT0dZR+AlfA@public.gmane.org>
Cc:
linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Date:
09/29/2011 04:07 PM
Subject:
Re: IBV_WC_LOC_QP_OP_ERR for IBV_WR_RDMA_READ



On Thu, Sep 29, 2011 at 12:44 PM,  <David.Wein-iQUyExClMxnQT0dZR+AlfA@public.gmane.org> wrote:
> Thanks for responding Roland.  I wasn't setting these up.  I've added a
> call to ibv_modify_qp to set these but it doesn't help.  I even 
explicitly
> set the access rights on the QP
>
>        qp_attr.max_rd_atomic = 32;
>        qp_attr.max_dest_rd_atomic = 32;
>        qp_attr.qp_access_flags = (IBV_ACCESS_LOCAL_WRITE |
>                                   IBV_ACCESS_REMOTE_WRITE |
>                                   IBV_ACCESS_REMOTE_READ);
>
>        if (ibv_modify_qp(this->rl_cmid->qp, &qp_attr,
>                          IBV_QP_MAX_QP_RD_ATOMIC |
>                          IBV_QP_MAX_DEST_RD_ATOMIC |
>                          IBV_QP_ACCESS_FLAGS) == -1)
>        {
>                printf("Failed to modify qp attributes, errno %d", 
errno);
>                return -1;
>        }
>

When are you doing this?  I would guess it would work if you do
it after the QP is already transitioned to RTS, but I think it would
be more standard to do it as part of the RTR->RTS transition.

 > I'm looked at the ping-rdma sample
 > code and it doesn't do the ibv_modify_qp either.  Annoyingly, it works
 > find with RDMA_READ on my system

I'm sure that the working example code sets max_rd_atomic and
IBV_QP_MAX_QP_RD_ATOMIC it some modify_qp call.  You should
have your code mimic that.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
