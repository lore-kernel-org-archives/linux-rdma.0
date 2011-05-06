From: ren yufei <renyufei83-/E1597aS9LRv1O+Z8WTAqQ@public.gmane.org>
Subject: Re: Call to ibv_post_recv fails
Date: Sat, 7 May 2011 06:00:05 +0800 (CST)
Message-ID: <269364.2773.qm@web15806.mail.cnb.yahoo.com>
References: <BANLkTik2t9dFrtpMqGd29xQWHk=EB8_g6Q@mail.gmail.com>
Reply-To: ren yufei <renyufei83-/E1597aS9LRv1O+Z8WTAqQ@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTik2t9dFrtpMqGd29xQWHk=EB8_g6Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg I Kerr <kerr.g-movQPkccWJngpn9g0Uvcdg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Did you ibv_post_recv the wr twice in you code?

=A0 =A0 =A0 for (i =3D 0; i < n; ++i)
=A0 =A0 =A0 =A0 =A0 =A0 if (ibv_post_recv(ctx->qp, &wr, &bad_wr))
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;

remove the=A0for loop and try again,

=A0=A0=A0=A0 if (ibv_post_recv(ctx->qp, &wr, &bad_wr))
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 print error;

Regards.

Yufei


________________________________
=46rom: Greg I Kerr <kerr.g-movQPkccWJngpn9g0Uvcdg@public.gmane.org>
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Sent: Friday, May 6, 2011 3:39 PM
Subject: Re: Call to ibv_post_recv fails

I was hoping some of you might be able to tell me why the call to
ibv_post_recv fails in the following code snippet, based off of
rc_pingpong.

I registered both buffers with ibv_reg_mr and am simply trying to post
a work request that points to an sge list of 2 buffers. Is it not
allowed to point to separately registered memory regions with this
list?

Thanks,

Greg Kerr

static int pp_post_recv(struct pingpong_context *ctx, int n)
{
=A0 =A0 =A0 struct ibv_sge list[] =3D {
=A0 =A0 =A0 =A0 {
=A0 =A0 =A0 =A0 =A0 =A0 .addr =3D (uintptr_t) ctx->buf,
=A0 =A0 =A0 =A0 =A0 =A0 .length =3D ctx->size,
=A0 =A0 =A0 =A0 =A0 =A0 .lkey =3D ctx->mr->lkey
=A0 =A0 =A0 =A0 },
=A0 =A0 =A0 =A0 {
=A0 =A0 =A0 =A0 =A0 .addr =3D (uintptr_t) ctx->buf2,
=A0 =A0 =A0 =A0 =A0 .length =3D ctx->size,
=A0 =A0 =A0 =A0 =A0 .lkey =3D ctx->mr2->lkey
=A0 =A0 =A0 =A0 }};

=A0 =A0 =A0 struct ibv_recv_wr wr =3D {
=A0 =A0 =A0 =A0 =A0 =A0 .wr_id=A0 =A0 =A0 =A0 =A0 =3D PINGPONG_RECV_WRI=
D,
=A0 =A0 =A0 =A0 =A0 =A0 .sg_list=A0 =A0 =3D list,
=A0 =A0 =A0 =A0 =A0 =A0 .num_sge=A0 =A0 =3D 2,
=A0 =A0 =A0 };
=A0 =A0 =A0 struct ibv_recv_wr *bad_wr;
=A0 =A0 =A0 int i;

=A0 =A0 =A0 for (i =3D 0; i < n; ++i)
=A0 =A0 =A0 =A0 =A0 =A0 if (ibv_post_recv(ctx->qp, &wr, &bad_wr))
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;

=A0 =A0 =A0 return i;
}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at=A0 http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
