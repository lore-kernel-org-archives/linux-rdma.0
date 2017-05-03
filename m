From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v4, under testing] nvme-rdma: support devices with queue
 size < 32
Date: Wed, 3 May 2017 15:45:25 +0000
Message-ID: <1493826324.3901.2.camel@sandisk.com>
References: <79901165.5342369.1493805915415.JavaMail.zimbra@kalray.eu>
         <823aa3f0-685f-4569-11d6-238cc4f0b126@grimberg.me>
         <780938034.8003164.1493824767084.JavaMail.zimbra@kalray.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <780938034.8003164.1493824767084.JavaMail.zimbra-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
Content-Language: en-US
Content-ID: <30C37440C5B77448A04C5E360A109304-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org" <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "axboe-b10kYP2dOMg@public.gmane.org" <axboe-b10kYP2dOMg@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "samuel.jones-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org" <samuel.jones-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-05-03 at 17:19 +0200, Marta Rybczynska wrote:
> > > +static inline bool nvme_rdma_queue_sig_limit(struct nvme_rdma_queue =
*queue)
> > > +{
> > > +       int v, old;
> > > +
> > > +       v =3D atomic_read(&queue->sig_count);
> > > +       while (1) {
> > > +               if (v > 1) {
> > > +                       old =3D atomic_cmpxchg(&queue->sig_count, v, =
v - 1);
> > > +                       if (old =3D=3D v)
> > > +                               return false;
> > > +               } else {
> > > +                       int new_count;
> > > +
> > > +                       new_count =3D nvme_rdma_init_sig_count(queue-=
>queue_size);
> > > +                       old =3D atomic_cmpxchg(&queue->sig_count, v, =
new_count);
> > > +                       if (old =3D=3D v)
> > > +                               return true;
> > > +               }
> > > +               v =3D old;
> > > +       }
> > > +}
> > > +
> >=20
> > Ugh, no...
> >=20
> > How about just do:
> >=20
> > 	if (atomic_inc_return(queue->sig_count) % queue->sig_limit)
> > 		return true;
> > 	return false;
> >=20
> > where
> > 	queue->sig_limit =3D max(queue->queue_size / 2, 1);
>=20
> I tried to avoid that because this adds a division in the fast path Bart
> was unhappy about in v2.
>=20
> Unfortunately we do not have an atomic with on overflow operation like
> the one needed here.

Hello Marta,

The approach I proposed works well if sig_count is modified by a single thr=
ead
at a time. Seeing your code made me realize that it is nontrivial to implem=
ent
that approach if multiple threads can change sig_count concurrently. Since
atomic_cmpxchg() is relatively expensive, what Sagi proposed may be a bette=
r
alternative. Sorry that I sent you in the wrong direction.

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
