From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: IBV_WC_LOC_QP_OP_ERR for IBV_WR_RDMA_READ
Date: Thu, 29 Sep 2011 14:06:27 -0700
Message-ID: <CAL1RGDVaN58y4u6TtwWuhGMsUuGxMQJkObqHPk2J=Gt0nPAxOQ@mail.gmail.com>
References: <OF7C5A38BC.B42C48EA-ON8825791A.006C2F2E-8625791A.006C7AA0@sybase.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <OF7C5A38BC.B42C48EA-ON8825791A.006C2F2E-8625791A.006C7AA0-iQUyExClMxnQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David.Wein-iQUyExClMxnQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 29, 2011 at 12:44 PM,  <David.Wein-iQUyExClMxnQT0dZR+AlfA@public.gmane.org> wrote:
> Thanks for responding Roland. =A0I wasn't setting these up. =A0I've a=
dded a
> call to ibv_modify_qp to set these but it doesn't help. =A0I even exp=
licitly
> set the access rights on the QP
>
> =A0 =A0 =A0 =A0qp_attr.max_rd_atomic =3D 32;
> =A0 =A0 =A0 =A0qp_attr.max_dest_rd_atomic =3D 32;
> =A0 =A0 =A0 =A0qp_attr.qp_access_flags =3D (IBV_ACCESS_LOCAL_WRITE |
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 I=
BV_ACCESS_REMOTE_WRITE |
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 I=
BV_ACCESS_REMOTE_READ);
>
> =A0 =A0 =A0 =A0if (ibv_modify_qp(this->rl_cmid->qp, &qp_attr,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0IBV_QP_MAX_QP_RD_A=
TOMIC |
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0IBV_QP_MAX_DEST_RD=
_ATOMIC |
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0IBV_QP_ACCESS_FLAG=
S) =3D=3D -1)
> =A0 =A0 =A0 =A0{
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printf("Failed to modify qp attributes=
, errno %d", errno);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -1;
> =A0 =A0 =A0 =A0}
>

When are you doing this?  I would guess it would work if you do
it after the QP is already transitioned to RTS, but I think it would
be more standard to do it as part of the RTR->RTS transition.

 > I'm looked at the ping-rdma sample
 > code and it doesn't do the ibv_modify_qp either.  Annoyingly, it wor=
ks
 > find with RDMA_READ on my system

I'm sure that the working example code sets max_rd_atomic and
IBV_QP_MAX_QP_RD_ATOMIC it some modify_qp call.  You should
have your code mimic that.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
