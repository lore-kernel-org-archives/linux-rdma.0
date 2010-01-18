From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Reducing the number of IB interrupts caused by the SRP initiator
Date: Mon, 18 Jan 2010 13:29:13 +0200
Message-ID: <4e6a6b3c1001180329n25e4257brc55fa037b97e0d18@mail.gmail.com>
References: <201001172008.16461.bart.vanassche@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201001172008.16461.bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 17, 2010 at 9:08 PM, Bart Van Assche
<bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hello,
>
> Once I noticed that the SRP initiator triggers two IB interrupts per =
I/O (more
> precise, per srp_queuecommand() call) I started looking at reducing t=
he number
> of IB interrupts. The patch below didn't help. Does this mean that th=
e patch
> below isn't complete or is this because of the hw driver used during =
the test
> (mlx4) ?
When you say that the patch did not help, do you mean that it did not
reduce the rate of interrupts?  I also think that you have a race here
since the head and tail operations are not protected (I don't know the
SRP driver I think locking should be done here). It would be better if
you'd choose a value that is a fraction of the queue size to request a
completion so that you don't get to a situation where your queue is
full and you the sender is waiting for it to be cleared. Also, you did
not touch the completion handler. Seems to me you should increment the
tail for each completion by the number of completions you skipped.
=46ailing to do so will keep cause the completion to be requested each
post after the first time it skipped queue len completions.


>
> Bart.
>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband=
/ulp/srp/ib_srp.c
> index 54c8fe2..1f674b8 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -241,7 +241,7 @@ static int srp_create_target_ib(struct srp_target=
_port *target)
> =A0 =A0 =A0 =A0init_attr->cap.max_recv_wr =A0 =A0 =3D SRP_RQ_SIZE;
> =A0 =A0 =A0 =A0init_attr->cap.max_recv_sge =A0 =A0=3D 1;
> =A0 =A0 =A0 =A0init_attr->cap.max_send_sge =A0 =A0=3D 1;
> - =A0 =A0 =A0 init_attr->sq_sig_type =A0 =A0 =A0 =A0 =3D IB_SIGNAL_AL=
L_WR;
> + =A0 =A0 =A0 init_attr->sq_sig_type =A0 =A0 =A0 =A0 =3D IB_SIGNAL_RE=
Q_WR;
> =A0 =A0 =A0 =A0init_attr->qp_type =A0 =A0 =A0 =A0 =A0 =A0 =3D IB_QPT_=
RC;
> =A0 =A0 =A0 =A0init_attr->send_cq =A0 =A0 =A0 =A0 =A0 =A0 =3D target-=
>cq;
> =A0 =A0 =A0 =A0init_attr->recv_cq =A0 =A0 =A0 =A0 =A0 =A0 =3D target-=
>cq;
> @@ -1001,7 +1001,8 @@ static int __srp_post_send(struct srp_target_po=
rt *target,
> =A0 =A0 =A0 =A0wr.sg_list =A0 =A0=3D &list;
> =A0 =A0 =A0 =A0wr.num_sge =A0 =A0=3D 1;
> =A0 =A0 =A0 =A0wr.opcode =A0 =A0 =3D IB_WR_SEND;
> - =A0 =A0 =A0 wr.send_flags =3D IB_SEND_SIGNALED;
> + =A0 =A0 =A0 wr.send_flags =3D target->tx_head - target->tx_tail =3D=
=3D SRP_SQ_SIZE - 1
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ? IB_SEND_SIGNALED : 0;
>
> =A0 =A0 =A0 =A0ret =3D ib_post_send(target->qp, &wr, &bad_wr);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
