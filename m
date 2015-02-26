From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/9] IB/ipoib: factor out ah flushing
Date: Thu, 26 Feb 2015 11:27:26 -0500
Message-ID: <1424968046.2543.18.camel@redhat.com>
References: <cover.1424562072.git.dledford@redhat.com>
	 <b06eb720c2f654f5ecdb72c66f4e89149d1c24ec.1424562072.git.dledford@redhat.com>
	 <54EF1F67.4000001@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-BzCrnpmsghpkOryCL1FZ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54EF1F67.4000001-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-BzCrnpmsghpkOryCL1FZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-02-26 at 15:28 +0200, Erez Shitrit wrote:
> On 2/22/2015 2:26 AM, Doug Ledford wrote:
> > Create a an ipoib_flush_ah and ipoib_stop_ah routines to use at
> > appropriate times to flush out all remaining ah entries before we shut
> > the device down.
> >
> > Because neighbors and mcast entries can each have a reference on any
> > given ah, we must make sure to free all of those first before our ah
> > will actually have a 0 refcount and be able to be reaped.
> >
> > This factoring is needed in preparation for having per-device work
> > queues.  The original per-device workqueue code resulted in the followi=
ng
> > error message:
> >
> > <ibdev>: ib_dealloc_pd failed
> >
> > That error was tracked down to this issue.  With the changes to which
> > workqueues were flushed when, there were no flushes of the per device
> > workqueue after the last ah's were freed, resulting in an attempt to
> > dealloc the pd with outstanding resources still allocated.  This code
> > puts the explicit flushes in the needed places to avoid that problem.
> >
> > Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >   drivers/infiniband/ulp/ipoib/ipoib_ib.c | 46 ++++++++++++++++++++----=
---------
> >   1 file changed, 28 insertions(+), 18 deletions(-)
> >
> > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniba=
nd/ulp/ipoib/ipoib_ib.c
> > index 72626c34817..cb02466a0eb 100644
> > --- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> > +++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> > @@ -659,6 +659,24 @@ void ipoib_reap_ah(struct work_struct *work)
> >   				   round_jiffies_relative(HZ));
> >   }
> >  =20
> > +static void ipoib_flush_ah(struct net_device *dev, int flush)
> > +{
> > +	struct ipoib_dev_priv *priv =3D netdev_priv(dev);
> > +
> > +	cancel_delayed_work(&priv->ah_reap_task);
> > +	if (flush)
> > +		flush_workqueue(ipoib_workqueue);
> > +	ipoib_reap_ah(&priv->ah_reap_task.work);
> > +}
> > +
> > +static void ipoib_stop_ah(struct net_device *dev, int flush)
> > +{
> > +	struct ipoib_dev_priv *priv =3D netdev_priv(dev);
> > +
> > +	set_bit(IPOIB_STOP_REAPER, &priv->flags);
> > +	ipoib_flush_ah(dev, flush);
> > +}
> > +
> >   static void ipoib_ib_tx_timer_func(unsigned long ctx)
> >   {
> >   	drain_tx_cq((struct net_device *)ctx);
> > @@ -877,24 +895,7 @@ timeout:
> >   	if (ib_modify_qp(priv->qp, &qp_attr, IB_QP_STATE))
> >   		ipoib_warn(priv, "Failed to modify QP to RESET state\n");
> >  =20
> > -	/* Wait for all AHs to be reaped */
> > -	set_bit(IPOIB_STOP_REAPER, &priv->flags);
> > -	cancel_delayed_work(&priv->ah_reap_task);
> > -	if (flush)
> > -		flush_workqueue(ipoib_workqueue);
> > -
> > -	begin =3D jiffies;
> > -
> > -	while (!list_empty(&priv->dead_ahs)) {
> > -		__ipoib_reap_ah(dev);
> > -
> > -		if (time_after(jiffies, begin + HZ)) {
> > -			ipoib_warn(priv, "timing out; will leak address handles\n");
> > -			break;
> > -		}
> > -
> > -		msleep(1);
> > -	}
> > +	ipoib_flush_ah(dev, flush);
> >  =20
> >   	ib_req_notify_cq(priv->recv_cq, IB_CQ_NEXT_COMP);
> >  =20
> > @@ -1037,6 +1038,7 @@ static void __ipoib_ib_dev_flush(struct ipoib_dev=
_priv *priv,
> >   	if (level =3D=3D IPOIB_FLUSH_LIGHT) {
> >   		ipoib_mark_paths_invalid(dev);
> >   		ipoib_mcast_dev_flush(dev);
> > +		ipoib_flush_ah(dev, 0);
>=20
> Why do you need to call the flush function here?

To remove all of the ah's that were reduced to a 0 refcount by the
previous two functions prior to restarting operations.  When we remove
an ah, it calls ib_destroy_ah which calls all the way down into the low
level driver.  This was to make sure that old, stale data was removed
all the way down to the card level before we started new queries for
paths and ahs.

> I can't see the reason to use the flush not from the stop_ah, meaning=20
> without setting the IPOIB_STOP_REAPER, the flush can send twice the same=
=20
> work.

No, it can't.  The ah flush routine does not search through ahs to find
ones to flush.  When you delete neighbors and mcasts, they release their
references to ahs.  When the refcount goes to 0, the put routine puts
the ah on the to-be-deleted ah list.  All the flush does is take that
list and delete the items.  If you run the flush twice, the first run
deletes all the items on the to-be-deleted list, the second run sees an
empty list and does nothing.

As for using flush versus stop: the flush function cancels any delayed
ah_flush work so that it isn't racing with the normally scheduled
ah_flush, then flushes the workqueue to make sure anything that might
result in an ah getting freed is done, then flushes, then schedules a
new delayed flush_ah work 1 second later.  So, it does exactly what a
flush should do: it removes what there is currently to remove, and in
the case of a periodically scheduled garbage collection, schedules a new
periodic flush at the maximum interval.

It is not appropriate to call stop_ah at this point because it will
cancel the delayed work, flush the ahs, then never reschedule the
garbage collection.  If we called stop here, we would have to call start
later.  But that's not really necessary as the flush cancels the
scheduled work and reschedules it for a second later.

> >   	}
> >  =20
> >   	if (level >=3D IPOIB_FLUSH_NORMAL)
> > @@ -1100,6 +1102,14 @@ void ipoib_ib_dev_cleanup(struct net_device *dev=
)
> >   	ipoib_mcast_stop_thread(dev, 1);
> >   	ipoib_mcast_dev_flush(dev);
> >  =20
> > +	/*
> > +	 * All of our ah references aren't free until after
> > +	 * ipoib_mcast_dev_flush(), ipoib_flush_paths, and
> > +	 * the neighbor garbage collection is stopped and reaped.
> > +	 * That should all be done now, so make a final ah flush.
> > +	 */
> > +	ipoib_stop_ah(dev, 1);
> > +
> >   	ipoib_transport_dev_cleanup(dev);
> >   }
> >  =20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-BzCrnpmsghpkOryCL1FZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJU70luAAoJELgmozMOVy/da3wP/2rz3qjLLgAfnMirqh6k32LZ
O+NgHquKNijVXDI6a08su1UoINP7I/+Gr3ab03r2KMLi/VfCeMwRLtVO7VdQylfk
a+rvnM6gyt++gzmVukfRNNgS8pvw/CX9Cqzq2xOISm7hZA8AhDmCSrhXkWmGxLCq
21mnIjtNdkel8kshxixzeAfqjz7c4R2sBeiR666Gk2BGpV68FtT9979qNWZHjYAX
L0wWCAp+mOuG0s5bfc8lhBR3jyRXKc6vcdXJp6i0ZYpsNKjgBJG69gK6IygqsaHo
CC0cyxPd6lTKgi2NkL5gpPrIuo3nmGMrirz0dOrrc/NMOWRaZYWIssmopx91M+0q
fkNVraChNPc8BD604pBHJYpnCrHO0c+XcK8E9fW9EZ3uoW/x32/Pg3NlV7TulD/6
5X8dBqIzn5o/cJm6UZ/fxuLpe3UbWSD38VzUHlzERqvwzQ/s/2b5J5nhrToJdf/5
RKbRdkLPqjkRNcNXNoW1b8eIiCOsiyLAkZXG/StvxzD4qJ4D0+vIcdYb1txJ1MN6
rO9GAsEmCMCZACq/NB/XfPGFx8NyNZlXHy6IA21aI7zBqYVTdVsQ8X8S29zj10OT
HDUiKBN2KkVkQ6pLRlRlzzGhPdcmdnVVSvcR9IbSjohq3WR55Sjw+C0Ch011TgqF
prPpE5w9N7yzQ/rRRgO5
=rMGj
-----END PGP SIGNATURE-----

--=-BzCrnpmsghpkOryCL1FZ--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
