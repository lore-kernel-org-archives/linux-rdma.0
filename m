From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: mlx4_wq_overflow question
Date: Thu, 9 Feb 2012 09:39:04 -0800
Message-ID: <CAL1RGDUo0bvR4wEc+vOMO_LAeK0wwssx9XVm=2KZBDzXTAOZwA@mail.gmail.com>
References: <20120208224546.GA31369@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120208224546.GA31369@mtldesk30>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 8, 2012 at 2:45 PM, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrot=
e:
> referring to the function below, I can't find a strong reason to chec=
k
> again after acquiring the cq spinlock. Any idea?
>
> static int mlx4_wq_overflow(struct mlx4_ib_wq *wq, int nreq, struct
> ib_cq *ib_cq)
> {
> =A0 =A0 =A0 =A0unsigned cur;
> =A0 =A0 =A0 =A0struct mlx4_ib_cq *cq;
>
> =A0 =A0 =A0 =A0cur =3D wq->head - wq->tail;
> =A0 =A0 =A0 =A0if (likely(cur + nreq < wq->max_post))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
>
> =A0 =A0 =A0 =A0cq =3D to_mcq(ib_cq);
> =A0 =A0 =A0 =A0spin_lock(&cq->lock);
> =A0 =A0 =A0 =A0cur =3D wq->head - wq->tail;
> =A0 =A0 =A0 =A0spin_unlock(&cq->lock);
>
> =A0 =A0 =A0 =A0return cur + nreq >=3D wq->max_post;
> }

This is the typical optimization of doing a cheaper imprecise check
first, and then only if we need to (ie the QP was close to full) take
the lock and synchronize with completions being polled to get an
exact answer.  Without the second check we might have spurious
"WQ full" indications.

If I recall correctly, MST first proposed this optimization for mthca
years ago.  If you search the archives you can probably find his
detailed explanation.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
