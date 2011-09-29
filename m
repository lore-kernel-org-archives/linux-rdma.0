From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: IBV_WC_LOC_QP_OP_ERR for IBV_WR_RDMA_READ
Date: Thu, 29 Sep 2011 14:45:54 -0700
Message-ID: <CAL1RGDV31pdN1BL7LotTf9GaP0s1r=ecRoAB2uUYEaQBhfa+PA@mail.gmail.com>
References: <OF7C5A38BC.B42C48EA-ON8825791A.006C2F2E-8625791A.006C7AA0@sybase.com>
 <CAL1RGDVaN58y4u6TtwWuhGMsUuGxMQJkObqHPk2J=Gt0nPAxOQ@mail.gmail.com> <OFF9ECDEA0.0854A87D-ON8825791A.00743004-8625791A.007705D2@sybase.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <OFF9ECDEA0.0854A87D-ON8825791A.00743004-8625791A.007705D2-iQUyExClMxnQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David.Wein-iQUyExClMxnQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 29, 2011 at 2:40 PM,  <David.Wein-iQUyExClMxnQT0dZR+AlfA@public.gmane.org> wrote:
> I'm using RDMA CM. =A0I am making the ibv_modify_qp() call immediatel=
y after
> rdma_create_qp(). =A0Should I move this code after the rdma_connect()=
 /
> rdma_accept()?

What are you passing in for conn_param->initiator_depth for rdma_accept=
()?
It should be non-zero.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
