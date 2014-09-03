From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/8] IPoIB: fix mcast_dev_flush/mcast_restart_task race
Date: Wed, 03 Sep 2014 13:49:11 -0400
Message-ID: <1409766551.26762.2.camel@firewall.xsintricity.com>
References: <cover.1407885724.git.dledford@redhat.com>
	 <e1dbcfc25d8930b281aad12699ebf8fa82485b0e.1407885724.git.dledford@redhat.com>
	 <CABgxfbHDuUrdHuLJT2oD07Cy3Ys4_rj-bJ6eR=9+uv0CuPH7_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-1T+cUynjbx4wq0NKCVjQ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABgxfbHDuUrdHuLJT2oD07Cy3Ys4_rj-bJ6eR=9+uv0CuPH7_Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-1T+cUynjbx4wq0NKCVjQ
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On Fri, 2014-08-29 at 14:53 -0700, Wendy Cheng wrote:
> On Tue, Aug 12, 2014 at 4:38 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> > Our mcast_dev_flush routine and our mcast_restart_task can race against
> > each other.  In particular, they both hold the priv->lock while
> > manipulating the rbtree and while removing mcast entries from the
> > multicast_list and while adding entries to the remove_list, but they
> > also both drop their locks prior to doing the actual removes.  The
> > mcast_dev_flush routine is run entirely under the rtnl lock and so has
> > at least some locking.  The actual race condition is like this:
> >
> > Thread 1                                Thread 2
> > ifconfig ib0 up
> >   start multicast join for broadcast
> >   multicast join completes for broadcast
> >   start to add more multicast joins
> >     call mcast_restart_task to add new entries
> >                                         ifconfig ib0 down
> >                                           mcast_dev_flush
> >                                             mcast_leave(mcast A)
> >     mcast_leave(mcast A)
> >
> > As mcast_leave calls ib_sa_multicast_leave, and as member in
> > core/multicast.c is ref counted, we run into an unbalanced refcount
> > issue.  To avoid stomping on each others removes, take the rtnl lock
> > specifically when we are deleting the entries from the remove list.
>=20
> Isn't "test_and_clear_bit()" atomic so it is unlikely that
> ib_sa_free_multicast() can run multiple times  ?
>=20
>     638 static int ipoib_mcast_leave(struct net_device *dev, struct
> ipoib_mcast         *mcast)
>     639 {
>     640         struct ipoib_dev_priv *priv =3D netdev_priv(dev);
>     641         int ret =3D 0;
>     642
>     643         if (test_and_clear_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->fla=
gs))
>     644                 ib_sa_free_multicast(mcast->mc);
>     645
>     646         if (test_and_clear_bit(IPOIB_MCAST_FLAG_ATTACHED,
> &mcast->flags)        ) {

This is the original code, and you would be right, but it had other
problems.  Even though test_and_clear_bit is atomic, the original usage
of MCAST_FLAG_BUSY was really that the mcast join had started, there was
no guarantee it had completed (we would set the flag, call
ib_sa_multicast_join, and we could then race with our leave where it was
possible to leave prior to the join completing).

My patches change this around now, and the code only checks for
MCAST_FLAG_BUSY as a double check that we aren't leaving an in-process
join.

>=20
> -- Wendy
>=20
> >
> > Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 37 ++++++++++++++++++=
++++----
> >  1 file changed, 32 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/i=
nfiniband/ulp/ipoib/ipoib_multicast.c
> > index f5e8da530d9..19e3fe75ebf 100644
> > --- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> > +++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> > @@ -810,7 +810,10 @@ void ipoib_mcast_dev_flush(struct net_device *dev)
> >
> >         spin_unlock_irqrestore(&priv->lock, flags);
> >
> > -       /* seperate between the wait to the leave*/
> > +       /*
> > +        * make sure the in-flight joins have finished before we attemp=
t
> > +        * to leave
> > +        */
> >         list_for_each_entry_safe(mcast, tmcast, &remove_list, list)
> >                 if (test_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags))
> >                         wait_for_completion(&mcast->done);
> > @@ -931,14 +934,38 @@ void ipoib_mcast_restart_task(struct work_struct =
*work)
> >         netif_addr_unlock(dev);
> >         local_irq_restore(flags);
> >
> > -       /* We have to cancel outside of the spinlock */
> > +       /*
> > +        * make sure the in-flight joins have finished before we attemp=
t
> > +        * to leave
> > +        */
> > +       list_for_each_entry_safe(mcast, tmcast, &remove_list, list)
> > +               if (test_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags))
> > +                       wait_for_completion(&mcast->done);
> > +
> > +       /*
> > +        * We have to cancel outside of the spinlock, but we have to
> > +        * take the rtnl lock or else we race with the removal of
> > +        * entries from the remove list in mcast_dev_flush as part
> > +        * of ipoib_stop() which will call mcast_stop_thread with
> > +        * flush =3D=3D 1 while holding the rtnl lock, and the
> > +        * flush_workqueue won't complete until this restart_mcast_task
> > +        * completes.  So do like the carrier on task and attempt to
> > +        * take the rtnl lock, but if we can't before the ADMIN_UP flag
> > +        * goes away, then just return and know that the remove list wi=
ll
> > +        * get flushed later by mcast_dev_flush.
> > +        */
> > +       while (!rtnl_trylock()) {
> > +               if (!test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags))
> > +                       return;
> > +               else
> > +                       msleep(20);
> > +       }
> >         list_for_each_entry_safe(mcast, tmcast, &remove_list, list) {
> >                 ipoib_mcast_leave(mcast->dev, mcast);
> >                 ipoib_mcast_free(mcast);
> >         }
> > -
> > -       if (test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags))
> > -               ipoib_mcast_start_thread(dev);
> > +       ipoib_mcast_start_thread(dev);
> > +       rtnl_unlock();
> >  }
> >
> >  #ifdef CONFIG_INFINIBAND_IPOIB_DEBUG
> > --
> > 1.9.3
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-1T+cUynjbx4wq0NKCVjQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUB1SgAAoJELgmozMOVy/drHwQAJVJsvdSAEkXovjAv/ggB8rb
h1JYLF8MV+D2E9YR6dICslnR+II561mOYMeHUk+7I3kaSjCsPxK0MOGZqmdqqhpR
kDkHpaFKhOHzWkIhmy0hmJwL9gDIkvQc4J4mlxh1GPwheaAYDgiHciyLLeYIHPDL
7Q9sMJBGWbZ1FKRKa649xv1zjPDqpLmJnim+uM7pBjxbxMbzO6dlyDMlNSGhdx+e
pzsg2QfZ02aOlFivtKZE9gM0ZTD7TWeDis1n5Kh1EEFOa/Bp+oFPTxddcSlHAHiS
1zM8hwEORqj881k4F933+bUbtIwFHsBuWAi+fOvpvu0o340P/e2Wdn6HH90pC4bu
zSjXHiJ7WtvX9EQv6cT5oxEo0WTPGMlx/NtntIj1vJpsGmk5BNrBvqStXLNGh4pw
nvgECxTMVGTGlhBEdyCBeALRVy0OR1YqYnEH8k8NdOCC5dxpqEGf3JxJ8ApbOnSp
7KzYaT6gkEsb0z1cy+BOaOQMTNbxCyUODXkuWdLsoBpPARJPKOmHm5q17RBxGGQc
quCLOdXGDGQW4MEN7/rvKE19U+x885C7ZPzteFwjjiDK1Wi13vIv/ogurMmXILIn
koMujmqQmRycAUryloFv4lJc9ppc5goW1Udyf9it5MO8RrRW1crZszWABenWXNjT
jbMOX9Ya2DRoLPf/+REV
=2bzj
-----END PGP SIGNATURE-----

--=-1T+cUynjbx4wq0NKCVjQ--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
