From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 1/1] IB/ipoib: fix for rare multicast join race
 condition
Date: Thu, 11 Feb 2016 11:24:35 -0500
Message-ID: <56BCB5C3.8060803@redhat.com>
References: <20160211161052.22025.1263.stgit@phlsvlogin03.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="COGooqcXchO5vTH0HfcQKg8GaQrTHrhNU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160211161052.22025.1263.stgit-u2TXY/5TJkdZ7WVY1cDZ9q2pdiUAq4bhAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--COGooqcXchO5vTH0HfcQKg8GaQrTHrhNU
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 02/11/2016 11:10 AM, Alex Estrin wrote:
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
>=20
> Changes from v3:
> - sync with priv->lock before flag check.
> Chages from v2:
> - Move check for OPER_UP flag state to mcast_join() to
> ensure no event worker is in progress.
> - minor style fixes.
> Changes from v1:
> - No need to lock again if error detected.
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   15 +++++++++++++--
>  1 files changed, 13 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/i=
nfiniband/ulp/ipoib/ipoib_multicast.c
> index 050dfa1..938e5d5 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> @@ -456,7 +456,7 @@ out_locked:
>  	return status;
>  }
> =20
> -static void ipoib_mcast_join(struct net_device *dev, struct ipoib_mcas=
t *mcast)
> +static int ipoib_mcast_join(struct net_device *dev, struct ipoib_mcast=
 *mcast)
>  {
>  	struct ipoib_dev_priv *priv =3D netdev_priv(dev);
>  	struct ib_sa_multicast *multicast;
> @@ -464,8 +464,16 @@ static void ipoib_mcast_join(struct net_device *de=
v, struct ipoib_mcast *mcast)
>  		.join_state =3D 1
>  	};
>  	ib_sa_comp_mask comp_mask;
> +	unsigned long flags;
>  	int ret =3D 0;
> =20
> +	spin_lock_irqsave(&priv->lock, flags);

There's no sense using flags here.  We already know this function is
broken if it's ever called from changing contexts that require you to
save flags because we take/release the priv->lock in the error handling
for the ib_sa_join_multicast call without flags.

But, that raises a larger issue.  If we are now going to have the
majority of the function under the priv->lock, then I think we need to
rethink our entry into this function.  All these locks/releases are
expensive in terms of locked memory cycles.  I would rather see us
change this function so that it's called explicitly with the priv->lock
held, keep it held through our work, only release it to call
ib_sa_join_multicast, and then retake it before returning.

Also, a person might be tempted to move the test below to right before
the call to ipoib_mcast_join in ipoib_mcast_join_task as an
optimization.  I think I would prefer not to do that for the sake of
clarity of test/action pair that must remain under lock.  It's clearer
to people reading the code later that we hold the lock because the only
guarantee that mcast->mcmember remains valid and referenceable is that
we passed our "interface is still up test" and help the lock through the
accesses since the interface could go down in another context asoon as
we release the lock.

You'll obviously have to adjust the locking in the task thread too.

Please respin.

> +	if (!priv->broadcast ||
> +	    !test_bit(IPOIB_FLAG_OPER_UP, &priv->flags)) {
> +		spin_unlock_irqrestore(&priv->lock, flags);
> +		return -EINVAL;
> +	}
> +
>  	ipoib_dbg_mcast(priv, "joining MGID %pI6\n", mcast->mcmember.mgid.raw=
);
> =20
>  	rec.mgid     =3D mcast->mcmember.mgid;
> @@ -525,6 +533,7 @@ static void ipoib_mcast_join(struct net_device *dev=
, struct ipoib_mcast *mcast)
>  			rec.join_state =3D 4;
>  #endif
>  	}
> +	spin_unlock_irqrestore(&priv->lock, flags);
> =20
>  	multicast =3D ib_sa_join_multicast(&ipoib_sa_client, priv->ca, priv->=
port,
>  					 &rec, comp_mask, GFP_KERNEL,
> @@ -539,6 +548,7 @@ static void ipoib_mcast_join(struct net_device *dev=
, struct ipoib_mcast *mcast)
>  		spin_unlock_irq(&priv->lock);
>  		complete(&mcast->done);
>  	}
> +	return 0;
>  }
> =20
>  void ipoib_mcast_join_task(struct work_struct *work)
> @@ -621,7 +631,8 @@ void ipoib_mcast_join_task(struct work_struct *work=
)
>  				init_completion(&mcast->done);
>  				set_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
>  				spin_unlock_irq(&priv->lock);
> -				ipoib_mcast_join(dev, mcast);
> +				if (!ipoib_mcast_join(dev, mcast))
> +					return;
>  				spin_lock_irq(&priv->lock);
>  			} else if (!delay_until ||
>  				 time_before(mcast->delay_until, delay_until))
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--COGooqcXchO5vTH0HfcQKg8GaQrTHrhNU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWvLXDAAoJELgmozMOVy/dFq8QAIFKHO37g/B2lQMBjoz+Vzuj
AdPeHxxtbxdBDHji28jwAEq/M2SQ1FAz5FxhH5EaCHyhxNdvLuKPTwfF9KjiMQWm
5dBU21pZpyJf3kp4xDpwLT6+IxwS98IV/jYNTeolzEj0PeXzrki+m7Q8Ali2a6CB
Wtr7GXaBP1Pot3uYKkdZqTFrCQO1meS7LZUA/kAOKNISQb2rdYFxl/ZoivtUQMCW
GL9JZisRjc3Bw+1AR+ua3w3tga+ONxrrQ9qvdcSD80r+/zig9wdxkMtMFEgb8uWG
5TyRXmfiE/iBQog5G/4KHylmnuNHnYn53QnH4j2j59+Oe3sMBJQ2AnCfCIZibCzJ
P8XTveTcqH2QPbT876ZUkCmbOoNGpUeLY1/pYn61V1OPf3rquC5lsBmmiFNbeCoF
P7jIz70guf4m53Pq+rqU1IrKYO9hLLb6bVbimV/2s8FQjf6Bu3mvGvYocz6CiakA
K054HfWqPjTTKNtkQHLj2O2/3sMRbtvq/y6yjY9oUeduesnJzi0DmMKzdbjiFWGu
vSnuz2iAyhTEMM8VISGn7Vp9DNg+3lUycXHOHzvQjmXX+K12aKorHvdp2oqe/3Ex
rcmZfc/2mPje6qfknwkG8PRdfVnoio73wcML7PwDAnnkpzr1t/+wBOcye1RGlztn
EEugH/VTeIH1vSWh25uC
=IAUI
-----END PGP SIGNATURE-----

--COGooqcXchO5vTH0HfcQKg8GaQrTHrhNU--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
