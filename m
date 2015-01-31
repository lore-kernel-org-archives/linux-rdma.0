From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] infiniband: Help gcc generate better code for
 ocrdma_srq_toggle_bit
Date: Sat, 31 Jan 2015 12:07:46 +0100
Message-ID: <1422702466.3030.4.camel@opteya.com>
References: <1421419196-4659-1-git-send-email-linux@rasmusvillemoes.dk>
	 <87twz7ho25.fsf@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87twz7ho25.fsf-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le samedi 31 janvier 2015 =C3=A0 00:00 +0100, Rasmus Villemoes a =C3=A9=
crit :
> ping
>=20

As you're fixing ocrdma driver, I think you might want to find people
@emulex.com to review your patches.

BTW, there's no MAINTAINERS entry for ocrdma driver ... which is a pity=
=2E

> On Fri, Jan 16 2015, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org> wrot=
e:
>=20
> > gcc emits a surprising amount of code in order to flip a bit. One
> > would think that a single instruction is enough.
> >
> > $ scripts/bloat-o-meter /tmp/ocrdma_verbs.o drivers/infiniband/hw/o=
crdma/ocrdma_verbs.o
> > add/remove: 0/0 grow/shrink: 0/3 up/down: 0/-142 (-142)
> > function                                     old     new   delta
> > ocrdma_post_srq_recv                         498     460     -38
> > ocrdma_poll_cq                              2010    1962     -48
> > ocrdma_discard_cqes                          495     439     -56
> >
> > All three calls of ocrdma_srq_toggle_bit happen within spinlocks, s=
o
> > saving a few useless instructions might be worthwhile.
> >
> > Signed-off-by: Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 5 +----
> >  1 file changed, 1 insertion(+), 4 deletions(-)
> >
> > diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/=
infiniband/hw/ocrdma/ocrdma_verbs.c
> > index fb8d8c4dfbb9..eff11e6c6183 100644
> > --- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> > +++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> > @@ -1484,10 +1484,7 @@ static void ocrdma_srq_toggle_bit(struct ocr=
dma_srq *srq, int idx)
> >  	int i =3D idx / 32;
> >  	unsigned int mask =3D (1 << (idx % 32));
> > =20
> > -	if (srq->idx_bit_fields[i] & mask)
> > -		srq->idx_bit_fields[i] &=3D ~mask;
> > -	else
> > -		srq->idx_bit_fields[i] |=3D mask;
> > +	srq->idx_bit_fields[i] ^=3D mask;
> >  }
> > =20
> >  static int ocrdma_hwq_free_cnt(struct ocrdma_qp_hwq_info *q)
> --

Regards.

--=20
Yann Droneaud
OPTEYA



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
