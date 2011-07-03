From: "Bob Pearson" <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: RE: [patch 34/44] rxe_arbiter.c
Date: Sun, 3 Jul 2011 10:21:44 -0500
Message-ID: <002d01cc3994$eb7cf600$c276e200$@systemfabricworks.com>
References: <20110701131821.928693424@systemfabricworks.com> <20110701132202.342196794@systemfabricworks.com> <CAO+b5-oh8Qavo1q5n1-KKa9XVmLcJ0s7ZZswC1Efp+gOgOAqQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-oh8Qavo1q5n1-KKa9XVmLcJ0s7ZZswC1Efp+gOgOAqQw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Bart Van Assche' <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

A regression slipped in. We had been clean on sparse and checkpatch exc=
ept
for the msleep which is not ciritical to performance.
CHECK_ENDIAN is new to me. That will help.

-----Original Message-----
=46rom: bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org [mailto:bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org] On B=
ehalf
Of Bart Van Assche
Sent: Sunday, July 03, 2011 2:53 AM
To: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: [patch 34/44] rxe_arbiter.c

On Fri, Jul 1, 2011 at 3:18 PM, <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
>
> +int rxe_arbiter(void *arg)
> +{
> + =A0 =A0 =A0 int err;
> + =A0 =A0 =A0 unsigned long flags;
> + =A0 =A0 =A0 struct rxe_dev *rxe =3D (struct rxe_dev *)arg;
> + =A0 =A0 =A0 struct sk_buff *skb;
> + =A0 =A0 =A0 struct list_head *qpl;
> + =A0 =A0 =A0 struct rxe_qp *qp;
> +
> + =A0 =A0 =A0 /* get the next qp's send queue */
> + =A0 =A0 =A0 spin_lock_irqsave(&rxe->arbiter.list_lock, flags);
> + =A0 =A0 =A0 if (list_empty(&rxe->arbiter.qp_list)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irqrestore(&rxe->arbiter.li=
st_lock,=20
> + flags);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 qpl =3D rxe->arbiter.qp_list.next;
> + =A0 =A0 =A0 list_del_init(qpl);
> + =A0 =A0 =A0 qp =3D list_entry(qpl, struct rxe_qp, arbiter_list);
> + =A0 =A0 =A0 spin_unlock_irqrestore(&rxe->arbiter.list_lock, flags);
> +
> + =A0 =A0 =A0 /* get next packet from queue and try to send it
> + =A0 =A0 =A0 =A0 =A0note skb could have already been removed */
> + =A0 =A0 =A0 skb =3D skb_dequeue(&qp->send_pkts);
> + =A0 =A0 =A0 if (skb) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D xmit_one_packet(rxe, qp, skb);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err =3D=3D RXE_QUEU=
E_STOPPED)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 skb_que=
ue_head(&qp->send_pkts, skb);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rxe_run_task(&rxe->arbi=
ter.task, 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=20
> + spin_unlock_irqrestore(&rxe->arbiter.list_lock, flags);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }

Can you please run these patches through sparse ? Sparse complains abou=
t the
above code:

$ make C=3D2 M=3Ddrivers/infiniband/hw/rxe
[ ... ]
drivers/infiniband/hw/rxe/rxe_arbiter.c:155:25: warning: context imbala=
nce
in 'rxe_arbiter' - unexpected unlock [ ... ]

Also, several complaints are reported with endianness checking enabled =
(make
CF=3D-D__CHECK_ENDIAN__ C=3D2 M=3Ddrivers/infiniband/hw/rxe).

Checkpatch is complaining too:

$ git show HEAD | scripts/checkpatch.pl - -nosignoff
WARNING: suspect code indent for conditional statements (8, 10)
#1061: FILE: drivers/infiniband/hw/rxe/rxe_arbiter.c:69:
+       if (is_request) {
+         if (qp->req.state !=3D QP_STATE_READY)

WARNING: suspect code indent for conditional statements (10, 12)
#1062: FILE: drivers/infiniband/hw/rxe/rxe_arbiter.c:70:
+         if (qp->req.state !=3D QP_STATE_READY)
+           goto drop;

WARNING: suspect code indent for conditional statements (10, 12)
#1065: FILE: drivers/infiniband/hw/rxe/rxe_arbiter.c:73:
+         if (qp->resp.state !=3D QP_STATE_READY)
+           goto drop;

WARNING: msleep < 20ms can sleep for up to 20ms; see
Documentation/timers/timers-howto.txt
+               msleep(1);
total: 0 errors, 4 warnings, 14803 lines checked

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
