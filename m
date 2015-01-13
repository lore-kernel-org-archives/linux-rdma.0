From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V1 FIX for-3.19] IB/ipoib: Fix broken multicast flow
Date: Tue, 13 Jan 2015 13:07:50 -0500
Message-ID: <1421172470.43839.207.camel@redhat.com>
References: <1420643066-3599-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-QAXg1sFBmaIXPwP0zdSv"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1420643066-3599-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-QAXg1sFBmaIXPwP0zdSv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-01-07 at 17:04 +0200, Or Gerlitz wrote:
> From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Following commit 016d9fb25cd9 "IPoIB: fix MCAST_FLAG_BUSY usage"
> both IPv6 traffic and for the most cases all IPv4 multicast traffic
> aren't working.
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
> we can't take mutex there. Locking isn't required there since the multica=
st
> join callback will be called only after the SA agent initialized the rele=
vant
> multicast object.
>=20
> Fixes: 016d9fb25cd9 ('IPoIB: fix MCAST_FLAG_BUSY usage')
> Reported-by: Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> V0 --> V1 changes: Added credits (...) and furnished the change-log abit.
>=20
>  drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   15 ++++++---------
>  1 files changed, 6 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/inf=
iniband/ulp/ipoib/ipoib_multicast.c
> index bc50dd0..0ea4b08 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> @@ -301,9 +301,10 @@ ipoib_mcast_sendonly_join_complete(int status,
>  			dev_kfree_skb_any(skb_dequeue(&mcast->pkt_queue));
>  		}
>  		netif_tx_unlock_bh(dev);
> +
> +		clear_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
>  	}
>  out:
> -	clear_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
>  	if (status)
>  		mcast->mc =3D NULL;
>  	complete(&mcast->done);

This chunk is wrong.  We are in our complete routine, which means
ib_sa_join_multicast is calling us for this mcast group, and we will
never see another return for this group.  We must clear the BUSY flag no
matter what as the BUSY flag now indicates that our mcast join is still
outstanding in the lower layer ib_sa_ area, not that we have joined the
group.  Please re-read my patches that re-worked the BUSY flag usage.
The BUSY flag was poorly named/used in the past, which is why a previous
patch introduced the JOINING or whatever flag it was called.  My
patchset reworks the flag usage to be more sane.  BUSY now means
*exactly* that: this mcast group is in the process of joining, aka it's
BUSY.  It doesn't mean we've joined the group and there are no more
outstanding join requests.  That's signified by mcast->mc !=3D
IS_ERR_OR_NULL.

> @@ -342,7 +343,6 @@ static int ipoib_mcast_sendonly_join(struct ipoib_mca=
st *mcast)
>  	rec.port_gid =3D priv->local_gid;
>  	rec.pkey     =3D cpu_to_be16(priv->pkey);
> =20
> -	mutex_lock(&mcast_mutex);
>  	init_completion(&mcast->done);
>  	set_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
>  	mcast->mc =3D ib_sa_join_multicast(&ipoib_sa_client, priv->ca,
> @@ -364,7 +364,6 @@ static int ipoib_mcast_sendonly_join(struct ipoib_mca=
st *mcast)
>  		ipoib_dbg_mcast(priv, "no multicast record for %pI6, starting "
>  				"sendonly join\n", mcast->mcmember.mgid.raw);
>  	}
> -	mutex_unlock(&mcast_mutex);
> =20
>  	return ret;
>  }

No!  You can not, under any circumstances, remove this locking!  One of
the things that frustrated me for a bit until I tracked it down was how
ib_sa_join_multicast returns errors to the ipoib layer.  When you call
ib_sa_join_multicast, the return value is either a valid mcast->mc
pointer or IS_ERR(err).  If it's a valid pointer, that does not mean we
have successfully joined, it means that we might join, but it isn't
until we have completed the callback that we know.  The callback will
clear out mcast->mc if we encounter an error during the callback and
know that by returning an error from the callback, the lower layer is
going to delete the mcast->mc context out from underneath us.  As it
turns out, we often get our callbacks called even before we get the
initial return from ib_sa_join_multicast.  If we don't have this
locking, and we get any error in the callback, the callback will clear
mcast->mc to indicate that we have no valid group, then we will return
from ib_sa_join_multicast and set mcast->mc to an invalid group.  To
prevent that, the callback grabs this mutex at the beginning of its
operation.  We *must* grab the mutex here and hold it until we are done
with mcast->mc or else we can't know for sure if the mcast->mc that we
just set as the return code from ib_sa_join_multicast is the right
return value or if we just overwrote the callbacks setting of that
field.

> @@ -622,10 +621,8 @@ void ipoib_mcast_join_task(struct work_struct *work)
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
> @@ -725,8 +722,6 @@ void ipoib_mcast_send(struct net_device *dev, u8 *dad=
dr, struct sk_buff *skb)
>  		memcpy(mcast->mcmember.mgid.raw, mgid, sizeof (union ib_gid));
>  		__ipoib_mcast_add(dev, mcast);
>  		list_add_tail(&mcast->list, &priv->multicast_list);
> -		if (!test_and_set_bit(IPOIB_MCAST_RUN, &priv->flags))
> -			queue_delayed_work(priv->wq, &priv->mcast_task, 0);
>  	}
> =20
>  	if (!mcast->ah) {
> @@ -740,6 +735,8 @@ void ipoib_mcast_send(struct net_device *dev, u8 *dad=
dr, struct sk_buff *skb)
>  		if (test_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags))
>  			ipoib_dbg_mcast(priv, "no address vector, "
>  					"but multicast join already started\n");
> +		else if (test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags))
> +			ipoib_mcast_sendonly_join(mcast);
> =20
>  		/*
>  		 * If lookup completes between here and out:, don't

None of this looks right to me either.  But that's OK, I think I found
the bug while looking all of this over.  I'm going to do some testing
and I'll report back here when done.  You can't even do this without
removing the mutex_lock above that I pointed out has to stay, so this
really isn't right.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-QAXg1sFBmaIXPwP0zdSv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUtV72AAoJELgmozMOVy/d3WgP/3Hdva1nqtk9hg/Jm6nZl9tV
LfVaRwj50cxYpFetjYO+yZvFPF+TwDFHYZqfr6w8B8wmzNTVCxdxW+hfphl+RZux
cTv+Ng5giRMJtmbxeW6kVA6hAAqzxk9ZC0zPZbAhjSEyR7PXAuGrJnJ5Sc0gXgmx
tytw4ULZxEEm5mmUb5WSlpKYdj0YSuSut3ucvY1wr1zSW2x20lsYmgvw79p1HWLI
34koYKroTT369FO5XaAvrxvmIjD4O2AoSFgmF0SNUP34BhPH/LKqZqJXaLNZcGOh
YKMvoFxfZP0mQ1KVI8twEDE02pF4LhIcapfLbgPSt3D40IH+mtJYWcq0G031pB8L
xL1sdmvU5HncLts7OW3gog/uKgAEWNK74n3btr4SDkYP3yh2s7ky7pC6O2+KFySg
r0juUzZfg4NwLfUc/16PrEPvj1C19Wp9bo+LrIQWMKJJCCgNs/snITQ2s+AOVPLW
2bCV6s49Ep5f6UKak2tsJ2p2WGOybYsDxnKVc55fCOlwV92vlSsUiV8wUujWhpID
yH4CtZGHhBnkj/gQ/NS51BASLUC3Z5ZSDk3uwv7j6sPIxSwgKtgKDnQ7HYK1kTtp
59bR4vM6WZWgYugdXsk2hgpvBOugX63xjmBZIplkOxMkfx3+SB8HTnWJhwDDijp/
ZECPRgWzBcoaOBn9i6al
=fUfl
-----END PGP SIGNATURE-----

--=-QAXg1sFBmaIXPwP0zdSv--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
