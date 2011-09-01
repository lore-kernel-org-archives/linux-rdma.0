From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [patch v2 13/37] add rxe_verbs.c
Date: Thu, 1 Sep 2011 13:02:33 +0200
Message-ID: <CAO+b5-otnep143VjpsgmGWBF2Nq5WLa6-hbvePs6+1mAgKGDvQ@mail.gmail.com>
References: <20110724194300.421253331@systemfabricworks.com>
 <20110724201228.761358826@systemfabricworks.com> <CAO+b5-r3UtgnyfhyaodHQTj_xB5d2MQkZ8kRbrpZ1hF_0W1ONw@mail.gmail.com>
 <039b01cc6866$d909e900$8b1dbb00$@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <039b01cc6866$d909e900$8b1dbb00$@systemfabricworks.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 1, 2011 at 7:20 AM, Bob Pearson
<rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
> From: bvanassche-HInyCGIudOg@public.gmane.org
> > On Sun, Jul 24, 2011 at 9:43 PM, =A0<rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org=
> wrote:
> > > +static struct ib_ah *rxe_create_ah(struct ib_pd *ibpd, struct
> ib_ah_attr
> > *attr)
> > > +{
> > > + =A0 int err;
> > > + =A0 struct rxe_dev *rxe =3D to_rdev(ibpd->device);
> > > + =A0 struct rxe_pd *pd =3D to_rpd(ibpd);
> > > + =A0 struct rxe_ah *ah;
> > > +
> > > + =A0 err =3D rxe_av_chk_attr(rxe, attr);
> > > + =A0 if (err)
> > > + =A0 =A0 =A0 =A0 =A0 goto err1;
> > > +
> > > + =A0 ah =3D rxe_alloc(&rxe->ah_pool);
> > > + =A0 if (!ah) {
> > > + =A0 =A0 =A0 =A0 =A0 err =3D -ENOMEM;
> > > + =A0 =A0 =A0 =A0 =A0 goto err1;
> > > + =A0 }
> > > +
> > > + =A0 rxe_add_ref(pd);
> > > + =A0 ah->pd =3D pd;
> > > +
> > > + =A0 err =3D rxe_av_from_attr(rxe, attr->port_num, &ah->av, attr=
);
> > > + =A0 if (err)
> > > + =A0 =A0 =A0 =A0 =A0 goto err2;
> > > +
> > > + =A0 return &ah->ibah;
> > > +
> > > +err2:
> > > + =A0 rxe_drop_ref(pd);
> > > + =A0 rxe_drop_ref(ah);
> > > +err1:
> > > + =A0 return ERR_PTR(err);
> > > +}
> >
> > I'm not sure that using a variable with the name "err" and labels w=
ith
> > names "err1" and "err2" is a good idea with regard to readability.
>
> There are a lot of these. I used err instead of ret in cases where th=
e only
> purpose of the return was to indicate an error. I used a lot of stack=
ed
> error returns to avoid repetitive cleanup stanzas. Again the name err=
N:
> implies an error occurred. How about errorN: Is that enough different=
 to
> avoid the confusion you sense?

If you are going to rename the "err<n>" labels, maybe it's a better
idea to rename these into "fail<n>" instead of "error<n>". Maybe it's
even possible to do this renaming with sed.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
