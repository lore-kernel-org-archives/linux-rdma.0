From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2 FIX for-3.19] IB/ipoib: Fix broken multicast flow
Date: Thu, 22 Jan 2015 15:40:36 -0500
Message-ID: <1421959236.3352.233.camel@redhat.com>
References: <1421933479-18214-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-owVBX8a65cRyztY0xr1V"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1421933479-18214-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-owVBX8a65cRyztY0xr1V
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-01-22 at 15:31 +0200, Or Gerlitz wrote:
> From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Following commit 016d9fb25cd9 "IPoIB: fix MCAST_FLAG_BUSY usage" both
> IPv6 traffic and for the most cases all IPv4 multicast traffic aren't
> working.
>=20
> After this change there is no mechanism to handle the work that does the
> join process for the rest of the mcg's. For example, if in the list of
> all the mcg's there is a send-only request, after its processing, the
> code in ipoib_mcast_sendonly_join_complete() will not requeue the
> mcast task, but leaves the bit that signals this task is running,
> and hence the task will never run.
>=20
> Also, whenever the kernel sends multicast packet (w.o joining to this
> group), we don't call ipoib_send_only_join(), the code tries to start
> the mcast task but it failed because the bit IPOIB_MCAST_RUN is always
> set, As a result the multicast packet will never be sent.
>=20
> The fix handles all the join requests via the same logic, and call
> explicitly to sendonly join whenever there is a packet from sendonly type=
.
>=20
> Since ipoib_mcast_sendonly_join() is now called from the driver TX flow,
> we can't take mutex there. We avoid locking by testing the multicast
> object to be valid (not error or null).
>=20
> Fixes: 016d9fb25cd9 ('IPoIB: fix MCAST_FLAG_BUSY usage')
> Reported-by: Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>=20
> Changes from V1:
>=20
> 1. always do clear_bit(IPOIB_MCAST_FLAG_BUSY) inipoib_mcast_sendonly_join=
_complete()

This part is good.

> 2. Sync between ipoib_mcast_sendonly_join() to ipoib_mcast_sendonly_join_=
complete=20
> using a IS_ERR_OR_NULL() test

This part is no good.  You just added a kernel data corrupter or kernel
oopser depending on the situation.

>  drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   16 ++++++----------
>  1 files changed, 6 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/inf=
iniband/ulp/ipoib/ipoib_multicast.c
> index bc50dd0..212cfb4 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> @@ -342,7 +342,6 @@ static int ipoib_mcast_sendonly_join(struct ipoib_mca=
st *mcast)
>  	rec.port_gid =3D priv->local_gid;
>  	rec.pkey     =3D cpu_to_be16(priv->pkey);
> =20
> -	mutex_lock(&mcast_mutex);
>  	init_completion(&mcast->done);
>  	set_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
>  	mcast->mc =3D ib_sa_join_multicast(&ipoib_sa_client, priv->ca,
> @@ -354,8 +353,8 @@ static int ipoib_mcast_sendonly_join(struct ipoib_mca=
st *mcast)
>  					 GFP_ATOMIC,
>  					 ipoib_mcast_sendonly_join_complete,
>  					 mcast);
> -	if (IS_ERR(mcast->mc)) {
> -		ret =3D PTR_ERR(mcast->mc);
> +	if (IS_ERR_OR_NULL(mcast->mc)) {
> +		ret =3D mcast->mc ? PTR_ERR(mcast->mc) : -EAGAIN;
>  		clear_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
>  		complete(&mcast->done);
>  		ipoib_warn(priv, "ib_sa_join_multicast for sendonly join "
> @@ -364,7 +363,6 @@ static int ipoib_mcast_sendonly_join(struct ipoib_mca=
st *mcast)
>  		ipoib_dbg_mcast(priv, "no multicast record for %pI6, starting "
>  				"sendonly join\n", mcast->mcmember.mgid.raw);
>  	}
> -	mutex_unlock(&mcast_mutex);
> =20
>  	return ret;
>  }

These three hunks allow the join completion routine to run parallel to
ib_sa_join_multicast returning.  It is a race condition to see who
finishes first.  However, what's not much of a race condition is that if
the join completion finishes first, and it set mcast->mc =3D NULL;, then
it also ran clear_bit(IPOIB_MCAST_FLAG_BUSY, &mcast_flags); and
complete(&mcast->done);.  We will now enter into an if statement and run
those same things again.  If, at the time the first complete was run, we
were already waiting in mcast_dev_flush or mcast_restart_task for the
completion to happen, it is entirely possible, and maybe even probable,
that one of those routines would have already proceeded to free our
mcast struct out from underneath us.  By the time we get around to
running the clear_bit and complete in this routine, it is entirely
possible that our memory has been freed and reused and we are causing
random data corruption.  Or it's been freed and during reuse it was
cleared and now when we try to dereference those pointers we oops the
kernel.

The alternative, if you really want to remove that lock, is that we
can't abuse mcast->mc to store the return value.  Instead, we would need
to use a temporary pointer, and check that temporary pointer for
ERR_PTR.  If we got that, then we know we will never run our completion
routine and we should complete ourselves.  If we get anything else, then
it might be valid, or it might get nullified by our completion routine,
so we simply throw the data away and let the completion routine set it
as it sees fit.  However, as I mentioned off list to Erez, I was
reluctant to make that change in the 3.19 fix series because that's very
risk IMO.  I don't mind adding locks, but removing that much locking is
more 3.20 material IMO.


> @@ -622,10 +620,8 @@ void ipoib_mcast_join_task(struct work_struct *work)
>  			break;
>  		}
> =20
> -		if (test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags))
> -			ipoib_mcast_sendonly_join(mcast);
> -		else
> -			ipoib_mcast_join(dev, mcast, 1);
> +		ipoib_mcast_join(dev, mcast, 1);
> +
>  		return;
>  	}
> =20
> @@ -725,8 +721,6 @@ void ipoib_mcast_send(struct net_device *dev, u8 *dad=
dr, struct sk_buff *skb)
>  		memcpy(mcast->mcmember.mgid.raw, mgid, sizeof (union ib_gid));
>  		__ipoib_mcast_add(dev, mcast);
>  		list_add_tail(&mcast->list, &priv->multicast_list);
> -		if (!test_and_set_bit(IPOIB_MCAST_RUN, &priv->flags))
> -			queue_delayed_work(priv->wq, &priv->mcast_task, 0);
>  	}
> =20
>  	if (!mcast->ah) {
> @@ -740,6 +734,8 @@ void ipoib_mcast_send(struct net_device *dev, u8 *dad=
dr, struct sk_buff *skb)
>  		if (test_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags))
>  			ipoib_dbg_mcast(priv, "no address vector, "
>  					"but multicast join already started\n");
> +		else if (test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags))
> +			ipoib_mcast_sendonly_join(mcast);
> =20
>  		/*
>  		 * If lookup completes between here and out:, don't

These items make a passable effort at fixing up the same items as
patches 1 and 2 in my patchset.  Patch 3 in my patchset was just
something I noticed, but it isn't drastically important.

This alternative patch does nothing to address what is fixed in these
patches though:

patch 4: we leaked joins as a result of handling ENETRESET wrong.  you
wouldn't see this unless your testing included taking the network up and
down via killing opensm or the like, but it's a real issue

patch 5: over zealous rescheduling of join task that got in the way of
the flush thread

patch 6: took out an unneeded spinlock

patch 7: during my testing, I got an oops in ipoib_mcast_join that is
the result of lack of locking between the flush task and the
mcast_join_task thread

patch 8: there is a legitimate leak of mcast entries any time we process
this list and get to the end only to find that our device is no longer
up, and given that the debug messages show that we call
mcast_restart_task every time right before we call mcast_dev_flush when
we are downing the interface, the chance of leak here is very high

patch 9: similar to patch 4, you don't see this unless you are abusing
opensm in order to trigger net events, and then combining that with
removing the module at the same time.  but if you have a queue net event
and you don't flush after you unregister, it can oops your kernel later
when the net event finally runs

patch 10: if you have mcast debugging on, that printk can actually cause
problems that don't otherwise exist because it isn't rate limited in any
way

This interim patch you are suggesting addresses the first couple items
my patches address, but it also introduces data corrupter/oopser, but
also like I said in a previous email, your testing is myopic, just like
my original testing was, and you are ignoring other items and thinking
your patch is OK when it really isn't.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-owVBX8a65cRyztY0xr1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUwWBEAAoJELgmozMOVy/dNfEP+wV5dtpu5OGHocoWtq6wshZm
gQdopQqocAJprdOECn9xEdm10h/0yiqDNkdJegWUMG4Rg2vv4aPgdGmJ1Jx/XiRB
y/OcUaeRTXNUbqnHizHgJwzKsQJtsT4Ll319X2sfHIkUqrABkVMH6l8PnjwhSPXR
tt7iWdAzoA7R4sBMHJtU0YmdphC6nghPw7COdPsU/Db2ZNMyZ4a+trdeml0996q1
5LF5u69EGyNJgwIyFp8XUZejkHESyMZCCVf0sGo+ui8QSgFxuUy2V7Kglhe2Q6tf
v2pQoBROLB4C2870EiuwdWmdp2ABb6UblB5B+PaM1gnqOxPmPFhD7bmSe/eAb2wD
tPQDBS1BwwogXfvvTGSRpQHcUfW411OW891iDuecsViFuMJQ4kOW4WCl4G0B7bNr
wD25k050mE+hNwuAz7sZY9hBwjsvw6zH6fq/OFZa/9shz/X6fOjmJ6umF1zp097w
TnlUTaVtMk/w9zEeMusDVGIYLSyaGNIc1t/4/pi/t15TFbvONUJfvQnoUVs92D/q
n5YYE0SmTEb9rnPootJxdrdAZktXmmKUUt3DI8q9is3FH+CmPRItL8XiH998GVNQ
meXMXrURd4hFB096Ji7tCKo48pA1VpIf2+Ph8wK6qcui8Hd18zZTvkduIJfLeA1O
zr12Gk65X2oqKu6L4q+R
=Omxa
-----END PGP SIGNATURE-----

--=-owVBX8a65cRyztY0xr1V--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
