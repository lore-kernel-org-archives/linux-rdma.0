From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 8/9] IB/ipoib: deserialize multicast joins
Date: Mon, 02 Mar 2015 10:29:05 -0500
Message-ID: <1425310145.2354.26.camel@redhat.com>
References: <cover.1424562072.git.dledford@redhat.com>
	 <a24ade295dfdd1369aac47a978003569ec190952.1424562072.git.dledford@redhat.com>
	 <54F31AEC.3010001@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-dgtMycviCzdKwAPbrpz6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54F31AEC.3010001-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-dgtMycviCzdKwAPbrpz6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2015-03-01 at 15:58 +0200, Erez Shitrit wrote:
> On 2/22/2015 2:27 AM, Doug Ledford wrote:
> > Allow the ipoib layer to attempt to join all outstanding multicast
> > groups at once.  The ib_sa layer will serialize multiple attempts to
> > join the same group, but will process attempts to join different groups
> > in parallel.  Take advantage of that.
> >
> > In order to make this happen, change the mcast_join_thread to loop
> > through all needed joins, sending a join request for each one that we
> > still need to join.  There are a few special cases we handle though:
> >
> > 1) Don't attempt to join anything but the broadcast group until the joi=
n
> > of the broadcast group has succeeded.
> > 2) No longer restart the join task at the end of completion handling.
> > If we completed successfully, we are done.  The join task now needs kic=
ked
> > either by mcast_send or mcast_restart_task or mcast_start_thread, but
> > should not need started anytime else except when scheduling a backoff
> > attempt to rejoin.
> > 3) No longer use separate join/completion routines for regular and
> > sendonly joins, pass them all through the same routine and just do the
> > right thing based on the SENDONLY join flag.
> > 4) Only try to join a SENDONLY join twice, then drop the packets and
> > quit trying.  We leave the mcast group in the list so that if we get a
> > new packet, all that we have to do is queue up the packet and restart
> > the join task and it will automatically try to join twice and then
> > either send or flush the queue again.
> >
> > Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >   drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 250 ++++++++--------=
---------
> >   1 file changed, 82 insertions(+), 168 deletions(-)
> >
> > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/i=
nfiniband/ulp/ipoib/ipoib_multicast.c
> > index 277e7ac7c4d..c670d9c2cda 100644
> > --- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> > +++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> > @@ -307,111 +307,6 @@ static int ipoib_mcast_join_finish(struct ipoib_m=
cast *mcast,
> >   	return 0;
> >   }
> >  =20
> > -static int
> > -ipoib_mcast_sendonly_join_complete(int status,
> > -				   struct ib_sa_multicast *multicast)
> > -{
> > -	struct ipoib_mcast *mcast =3D multicast->context;
> > -	struct net_device *dev =3D mcast->dev;
> > -	struct ipoib_dev_priv *priv =3D netdev_priv(dev);
> > -
> > -	/*
> > -	 * We have to take the mutex to force mcast_sendonly_join to
> > -	 * return from ib_sa_multicast_join and set mcast->mc to a
> > -	 * valid value.  Otherwise we were racing with ourselves in
> > -	 * that we might fail here, but get a valid return from
> > -	 * ib_sa_multicast_join after we had cleared mcast->mc here,
> > -	 * resulting in mis-matched joins and leaves and a deadlock
> > -	 */
> > -	mutex_lock(&mcast_mutex);
> > -
> > -	/* We trap for port events ourselves. */
> > -	if (status =3D=3D -ENETRESET) {
> > -		status =3D 0;
> > -		goto out;
> > -	}
> > -
> > -	if (!status)
> > -		status =3D ipoib_mcast_join_finish(mcast, &multicast->rec);
> > -
> > -	if (status) {
> > -		if (mcast->logcount++ < 20)
> > -			ipoib_dbg_mcast(netdev_priv(dev), "sendonly multicast "
> > -					"join failed for %pI6, status %d\n",
> > -					mcast->mcmember.mgid.raw, status);
> > -
> > -		/* Flush out any queued packets */
> > -		netif_tx_lock_bh(dev);
> > -		while (!skb_queue_empty(&mcast->pkt_queue)) {
> > -			++dev->stats.tx_dropped;
> > -			dev_kfree_skb_any(skb_dequeue(&mcast->pkt_queue));
> > -		}
> > -		netif_tx_unlock_bh(dev);
> > -		__ipoib_mcast_schedule_join_thread(priv, mcast, 1);
> > -	} else {
> > -		mcast->backoff =3D 1;
> > -		mcast->delay_until =3D jiffies;
> > -		__ipoib_mcast_schedule_join_thread(priv, NULL, 0);
> > -	}
> > -out:
> > -	clear_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
> > -	if (status)
> > -		mcast->mc =3D NULL;
> > -	complete(&mcast->done);
> > -	mutex_unlock(&mcast_mutex);
> > -	return status;
> > -}
> > -
> > -static int ipoib_mcast_sendonly_join(struct ipoib_mcast *mcast)
> > -{
> > -	struct net_device *dev =3D mcast->dev;
> > -	struct ipoib_dev_priv *priv =3D netdev_priv(dev);
> > -	struct ib_sa_mcmember_rec rec =3D {
> > -#if 0				/* Some SMs don't support send-only yet */
> > -		.join_state =3D 4
> > -#else
> > -		.join_state =3D 1
> > -#endif
> > -	};
> > -	int ret =3D 0;
> > -
> > -	if (!test_bit(IPOIB_FLAG_OPER_UP, &priv->flags)) {
> > -		ipoib_dbg_mcast(priv, "device shutting down, no sendonly "
> > -				"multicast joins\n");
> > -		clear_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
> > -		complete(&mcast->done);
> > -		return -ENODEV;
> > -	}
> > -
> > -	rec.mgid     =3D mcast->mcmember.mgid;
> > -	rec.port_gid =3D priv->local_gid;
> > -	rec.pkey     =3D cpu_to_be16(priv->pkey);
> > -
> > -	mutex_lock(&mcast_mutex);
> > -	mcast->mc =3D ib_sa_join_multicast(&ipoib_sa_client, priv->ca,
> > -					 priv->port, &rec,
> > -					 IB_SA_MCMEMBER_REC_MGID	|
> > -					 IB_SA_MCMEMBER_REC_PORT_GID	|
> > -					 IB_SA_MCMEMBER_REC_PKEY	|
> > -					 IB_SA_MCMEMBER_REC_JOIN_STATE,
> > -					 GFP_ATOMIC,
> > -					 ipoib_mcast_sendonly_join_complete,
> > -					 mcast);
> > -	if (IS_ERR(mcast->mc)) {
> > -		ret =3D PTR_ERR(mcast->mc);
> > -		clear_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
> > -		ipoib_warn(priv, "ib_sa_join_multicast for sendonly join "
> > -			   "failed (ret =3D %d)\n", ret);
> > -		complete(&mcast->done);
> > -	} else {
> > -		ipoib_dbg_mcast(priv, "no multicast record for %pI6, starting "
> > -				"sendonly join\n", mcast->mcmember.mgid.raw);
> > -	}
> > -	mutex_unlock(&mcast_mutex);
> > -
> > -	return ret;
> > -}
> > -
> >   void ipoib_mcast_carrier_on_task(struct work_struct *work)
> >   {
> >   	struct ipoib_dev_priv *priv =3D container_of(work, struct ipoib_dev_=
priv,
> > @@ -452,7 +347,9 @@ static int ipoib_mcast_join_complete(int status,
> >   	struct net_device *dev =3D mcast->dev;
> >   	struct ipoib_dev_priv *priv =3D netdev_priv(dev);
> >  =20
> > -	ipoib_dbg_mcast(priv, "join completion for %pI6 (status %d)\n",
> > +	ipoib_dbg_mcast(priv, "%sjoin completion for %pI6 (status %d)\n",
> > +			test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags) ?
> > +			"sendonly " : "",
> >   			mcast->mcmember.mgid.raw, status);
> >  =20
> >   	/*
> > @@ -477,27 +374,52 @@ static int ipoib_mcast_join_complete(int status,
> >   	if (!status) {
> >   		mcast->backoff =3D 1;
> >   		mcast->delay_until =3D jiffies;
> > -		__ipoib_mcast_schedule_join_thread(priv, NULL, 0);
> >  =20
> >   		/*
> >   		 * Defer carrier on work to priv->wq to avoid a
> > -		 * deadlock on rtnl_lock here.
> > +		 * deadlock on rtnl_lock here.  Requeue our multicast
> > +		 * work too, which will end up happening right after
> > +		 * our carrier on task work and will allow us to
> > +		 * send out all of the non-broadcast joins
> >   		 */
> > -		if (mcast =3D=3D priv->broadcast)
> > +		if (mcast =3D=3D priv->broadcast) {
> >   			queue_work(priv->wq, &priv->carrier_on_task);
> > +			__ipoib_mcast_schedule_join_thread(priv, NULL, 0);
> > +		}
> >   	} else {
> >   		if (mcast->logcount++ < 20) {
> >   			if (status =3D=3D -ETIMEDOUT || status =3D=3D -EAGAIN) {
> > -				ipoib_dbg_mcast(priv, "multicast join failed for %pI6, status %d\n=
",
> > +				ipoib_dbg_mcast(priv, "%smulticast join failed for %pI6, status %d=
\n",
> > +						test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags) ? "sendonly "=
 : "",
> >   						mcast->mcmember.mgid.raw, status);
> >   			} else {
> > -				ipoib_warn(priv, "multicast join failed for %pI6, status %d\n",
> > +				ipoib_warn(priv, "%smulticast join failed for %pI6, status %d\n",
> > +						test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags) ? "sendonly "=
 : "",
> >   					   mcast->mcmember.mgid.raw, status);
> >   			}
> >   		}
> >  =20
> > -		/* Requeue this join task with a backoff delay */
> > -		__ipoib_mcast_schedule_join_thread(priv, mcast, 1);
> > +		if (test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags) &&
> > +		    mcast->backoff >=3D 2) {
> > +			/*
> > +			 * We only retry sendonly joins once before we drop
> > +			 * the packet and quit trying to deal with the
> > +			 * group.  However, we leave the group in the
> > +			 * mcast list as an unjoined group.  If we want to
> > +			 * try joining again, we simply queue up a packet
> > +			 * and restart the join thread.  The empty queue
> > +			 * is why the join thread ignores this group.
> > +			 */
>=20
> Question: the sendonly is at the list for ever? looks like that, and it=
=20
> is prior to your patches, so probably it should be sent in some other=20
> patch to solve that.

Correct.  That logic is unchanged.  It probably deserves some sort of
timeout such that after X seconds with no traffic on a sendonly group,
we leave that group and only rejoin if we get a new send.  I had thought
about making it something really long, like 20 minutes, but thinking
about it is all I've done.  I didn't code anything up or include that in
these patches.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-dgtMycviCzdKwAPbrpz6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJU9IHBAAoJELgmozMOVy/dMjAP/iDZ8AqDPAvknTLgUm9bcakr
MEswN1JEeQcMh1W9bdO7lZdSig62C9ywHYbDVoktkYLVmh57UODhrNjQtJVnISo1
5laDUZySAM/5baRH/x+FmrjD/TBIwHSvrmbCbMRF2RFHlUoXO9MyPSURTEoT7dQQ
/swpoUtuDpy6vjbjazOsb2QmAr/EWZzximGpF3kbUFStSd0uM7dt9DwsA0RYFl/n
/Sb4R6KVoj+UdEToqynYn+BirucnCsoCqW6zZB9h9FsOa7MaMheDmBlJIFxl1zHC
f5MM06e1n3T5cKCYn+hMPATf+DRPjDaO9CsbWreuCSIOJd6XAe1KKRrDo1ywgWvS
i/TGV8+JDtSI57yHSf769p7kTXytFJBhJ99j+KzzkfVR7fcX47/G1wzAy56yVymF
H+mkZ/FnQHFrgO9u5S/snBskMgfSz+sJRv5MK0T7Ua+/b2HtNkSEjGAAoXOzG3jd
JSYHWNmZtxO83DwA1m7L2vEZLVGyFitKB4xXPSMdtDw8QdNx1sO3/atLZnMf9tNw
8TwS8LBxG+eRz82bJqevBdHDLK/KI/4L9tAWeDzixItGxnawEQ2+STX7xHX1wNHj
zAr8yp0SF9HCtqupek0alZodcs8e4cq4yUAjWY5D3O147bobDvpQ53vDjHfXp2JT
ee+IJMcSkJdt8T287cbv
=pFhi
-----END PGP SIGNATURE-----

--=-dgtMycviCzdKwAPbrpz6--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
