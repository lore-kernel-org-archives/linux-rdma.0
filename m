From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 1/1] IB/ipoib: fix for rare multicast join race
 condition
Date: Fri, 12 Feb 2016 14:53:55 -0500
Message-ID: <56BE3853.20504@redhat.com>
References: <20160211213051.29589.31877.stgit@phlsvlogin03.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TUwm5xRDw9vHtiuggTKiemQ7VDdEnJMEf"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160211213051.29589.31877.stgit-u2TXY/5TJkdZ7WVY1cDZ9q2pdiUAq4bhAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TUwm5xRDw9vHtiuggTKiemQ7VDdEnJMEf
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 02/11/2016 04:30 PM, Alex Estrin wrote:
> A narrow window for race condition still exist between
> multicast join thread and *dev_flush workers.
> A kernel crash caused by prolong erratic link state changes
> was observed (most likely a faulty cabling):
>=20
> [167275.656270] BUG: unable to handle kernel NULL pointer dereference a=
t
> 0000000000000020
> [167275.665973] IP: [<ffffffffa05f8f2e>] ipoib_mcast_join+0xae/0x1d0 [i=
b_ipoib]
> [167275.674443] PGD 0
> [167275.677373] Oops: 0000 [#1] SMP
> ...
> [167275.977530] Call Trace:
> [167275.982225]  [<ffffffffa05f92f0>] ? ipoib_mcast_free+0x200/0x200 [i=
b_ipoib]
> [167275.992024]  [<ffffffffa05fa1b7>] ipoib_mcast_join_task+0x2a7/0x490=

> [ib_ipoib]
> [167276.002149]  [<ffffffff8109d5fb>] process_one_work+0x17b/0x470
> [167276.010754]  [<ffffffff8109e3cb>] worker_thread+0x11b/0x400
> [167276.019088]  [<ffffffff8109e2b0>] ? rescuer_thread+0x400/0x400
> [167276.027737]  [<ffffffff810a5aef>] kthread+0xcf/0xe0
> Here was a hit spot:
> ipoib_mcast_join() {
> ..............
>       rec.qkey      =3D priv->broadcast->mcmember.qkey;
>                                        ^^^^^^^
> .....
>  }
> Proposed patch should prevent multicast join task to continue
> if link state change is detected.
>=20
> Signed-off-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Thanks, applied.

>=20
> Changes from v4:
> - as suggested by Doug Ledford, optimized spinlock usage,
> i.e. ipoib_mcast_join() is called with lock held.
> Changes from v3:
> - sync with priv->lock before flag check.
> Chages from v2:
> - Move check for OPER_UP flag state to mcast_join() to
> ensure no event worker is in progress.
> - minor style fixes.
> Changes from v1:
> - No need to lock again if error detected.
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   24 ++++++++++++++++=
+-------
>  1 files changed, 17 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/i=
nfiniband/ulp/ipoib/ipoib_multicast.c
> index 050dfa1..2588931 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> @@ -456,7 +456,10 @@ out_locked:
>  	return status;
>  }
> =20
> -static void ipoib_mcast_join(struct net_device *dev, struct ipoib_mcas=
t *mcast)
> +/*
> + * Caller must hold 'priv->lock'
> + */
> +static int ipoib_mcast_join(struct net_device *dev, struct ipoib_mcast=
 *mcast)
>  {
>  	struct ipoib_dev_priv *priv =3D netdev_priv(dev);
>  	struct ib_sa_multicast *multicast;
> @@ -466,6 +469,10 @@ static void ipoib_mcast_join(struct net_device *de=
v, struct ipoib_mcast *mcast)
>  	ib_sa_comp_mask comp_mask;
>  	int ret =3D 0;
> =20
> +	if (!priv->broadcast ||
> +	    !test_bit(IPOIB_FLAG_OPER_UP, &priv->flags))
> +		return -EINVAL;
> +
>  	ipoib_dbg_mcast(priv, "joining MGID %pI6\n", mcast->mcmember.mgid.raw=
);
> =20
>  	rec.mgid     =3D mcast->mcmember.mgid;
> @@ -525,20 +532,23 @@ static void ipoib_mcast_join(struct net_device *d=
ev, struct ipoib_mcast *mcast)
>  			rec.join_state =3D 4;
>  #endif
>  	}
> +	spin_unlock_irq(&priv->lock);
> =20
>  	multicast =3D ib_sa_join_multicast(&ipoib_sa_client, priv->ca, priv->=
port,
>  					 &rec, comp_mask, GFP_KERNEL,
>  					 ipoib_mcast_join_complete, mcast);
> +	spin_lock_irq(&priv->lock);
>  	if (IS_ERR(multicast)) {
>  		ret =3D PTR_ERR(multicast);
>  		ipoib_warn(priv, "ib_sa_join_multicast failed, status %d\n", ret);
> -		spin_lock_irq(&priv->lock);
>  		/* Requeue this join task with a backoff delay */
>  		__ipoib_mcast_schedule_join_thread(priv, mcast, 1);
>  		clear_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
>  		spin_unlock_irq(&priv->lock);
>  		complete(&mcast->done);
> +		spin_lock_irq(&priv->lock);
>  	}
> +	return 0;
>  }
> =20
>  void ipoib_mcast_join_task(struct work_struct *work)
> @@ -620,9 +630,10 @@ void ipoib_mcast_join_task(struct work_struct *wor=
k)
>  				/* Found the next unjoined group */
>  				init_completion(&mcast->done);
>  				set_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
> -				spin_unlock_irq(&priv->lock);
> -				ipoib_mcast_join(dev, mcast);
> -				spin_lock_irq(&priv->lock);
> +				if (ipoib_mcast_join(dev, mcast)) {
> +					spin_unlock_irq(&priv->lock);
> +					return;
> +				}
>  			} else if (!delay_until ||
>  				 time_before(mcast->delay_until, delay_until))
>  				delay_until =3D mcast->delay_until;
> @@ -641,10 +652,9 @@ out:
>  	if (mcast) {
>  		init_completion(&mcast->done);
>  		set_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
> +		ipoib_mcast_join(dev, mcast);
>  	}
>  	spin_unlock_irq(&priv->lock);
> -	if (mcast)
> -		ipoib_mcast_join(dev, mcast);
>  }
> =20
>  int ipoib_mcast_start_thread(struct net_device *dev)
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--TUwm5xRDw9vHtiuggTKiemQ7VDdEnJMEf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWvjhTAAoJELgmozMOVy/dM8QQALBqloLvd7KanpuG+co4BZj3
uEMPOekk34ed1f6byDLe+ILveZDCnR7WejPGHeKu8CSaLo+YdXJLnKGXKaG0qBV+
46UgTTftejxJYkDz8hVtvDk8a3KVQnZ8ip2tq0beoddWJCYdHOYlpZDhCEv8SwZN
n9c33gWSQHR9wgdfpWLLgqtSi+UNy2CRllhbw+4rN2JS+yq9MKg5KJBYbUBoegjc
NXoGl+vDjiZYuLySAo58nTi1v92d68vY1Ax6DwmY1NJsRZ8cF5S0CEO8goAFno4y
yOokUWfSC8qb7QJKNJ6NnfBDkYp1u2jgjGV+mVGobAwh35dw7JlbzGumvwAklooM
gdIiiFQMz2B6aUmbG09cKNd+Ldw4fIHuKsg8m/aDOkhuIL5gXPyg0OGjSRgipBH1
FYAlJHXeQFci0RrWv/J7bSCLMcw6YQtgmCArFqHmgEnTaOsMyMDQihNJuj6YdOLZ
/3tyUYOiQqxjs3UCTHYLmEhixgpixAKjhwUlGrAQfMbobLJGIgrV5iuKRccvVczN
dyCuLUKfqZl5vUDvtR1hIVYaTZQiSsw4cGEkJ/wtCU0CIqqtSuO040Me+rI0AxBu
qFbXC7D5plhXyXgaUqgDrWdjNCWNhSqkhfSmKmSxFIJb7Mu2ROHEHMpPtKERGtOd
2NOuKPGvpxz4AH+6CLwX
=CkRk
-----END PGP SIGNATURE-----

--TUwm5xRDw9vHtiuggTKiemQ7VDdEnJMEf--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
