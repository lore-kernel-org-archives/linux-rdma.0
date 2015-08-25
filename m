From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/ipoib: Clean up send-only multicast joins
Date: Tue, 25 Aug 2015 13:50:05 -0400
Message-ID: <55DCAACD.3000307@redhat.com>
References: <1440200053-18890-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GOLitGnoIE83DiCoKxR5WlGwLEL77qNxq"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1440200053-18890-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GOLitGnoIE83DiCoKxR5WlGwLEL77qNxq
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/21/2015 07:34 PM, Jason Gunthorpe wrote:
> Even though we don't expect the group to be created by the SM we
> sill need to provide all the parameters to force the SM to validate
> they are correct.

Why does this patch embed locking changes that, as far I can tell, are
not needed by the rest of the patch?  If the locking changes are needed
for some reason, then they likely need to be their own patch with their
own changelog.

> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 47 +++++++++++++++++-=
--------
>  1 file changed, 31 insertions(+), 16 deletions(-)
>=20
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/i=
nfiniband/ulp/ipoib/ipoib_multicast.c
> index 0d23e0568deb..c0e702c577d5 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> @@ -448,8 +448,8 @@ out_locked:
>  	return status;
>  }
> =20
> -static void ipoib_mcast_join(struct net_device *dev, struct ipoib_mcas=
t *mcast,
> -			     int create)
> +/* priv->lock must be held when calling */
> +static void ipoib_mcast_join(struct net_device *dev, struct ipoib_mcas=
t *mcast)
>  {
>  	struct ipoib_dev_priv *priv =3D netdev_priv(dev);
>  	struct ib_sa_multicast *multicast;
> @@ -471,7 +471,14 @@ static void ipoib_mcast_join(struct net_device *de=
v, struct ipoib_mcast *mcast,
>  		IB_SA_MCMEMBER_REC_PKEY		|
>  		IB_SA_MCMEMBER_REC_JOIN_STATE;
> =20
> -	if (create) {
> +	if (mcast !=3D priv->broadcast) {
> +		/*
> +		 * RFC 4391:
> +		 *  The MGID MUST use the same P_Key, Q_Key, SL, MTU,
> +		 *  and HopLimit as those used in the broadcast-GID.  The rest
> +		 *  of attributes SHOULD follow the values used in the
> +		 *  broadcast-GID as well.
> +		 */
>  		comp_mask |=3D
>  			IB_SA_MCMEMBER_REC_QKEY			|
>  			IB_SA_MCMEMBER_REC_MTU_SELECTOR		|
> @@ -492,19 +499,35 @@ static void ipoib_mcast_join(struct net_device *d=
ev, struct ipoib_mcast *mcast,
>  		rec.sl		  =3D priv->broadcast->mcmember.sl;
>  		rec.flow_label	  =3D priv->broadcast->mcmember.flow_label;
>  		rec.hop_limit	  =3D priv->broadcast->mcmember.hop_limit;
> +
> +		/*
> +		 * Historically Linux IPoIB has never properly supported SEND
> +		 * ONLY join. It emulated it by not providing all the required
> +		 * attributes, which is enough to prevent group creation and
> +		 * detect if there are full members or not. A major problem
> +		 * with supporting SEND ONLY is detecting when the group is
> +		 * auto-destroyed as IPoIB will cache the MLID..
> +		 */
> +#if 1
> +		if (test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags))
> +			comp_mask &=3D ~IB_SA_MCMEMBER_REC_TRAFFIC_CLASS;
> +#else
> +		if (test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags))
> +			rec.join_state =3D 4;
> +#endif
>  	}
> =20
> +	spin_unlock_irq(&priv->lock);
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
> -		spin_unlock_irq(&priv->lock);
>  		complete(&mcast->done);
>  	}
>  }
> @@ -517,7 +540,6 @@ void ipoib_mcast_join_task(struct work_struct *work=
)
>  	struct ib_port_attr port_attr;
>  	unsigned long delay_until =3D 0;
>  	struct ipoib_mcast *mcast =3D NULL;
> -	int create =3D 1;
> =20
>  	if (!test_bit(IPOIB_FLAG_OPER_UP, &priv->flags))
>  		return;
> @@ -566,7 +588,6 @@ void ipoib_mcast_join_task(struct work_struct *work=
)
>  		if (IS_ERR_OR_NULL(priv->broadcast->mc) &&
>  		    !test_bit(IPOIB_MCAST_FLAG_BUSY, &priv->broadcast->flags)) {
>  			mcast =3D priv->broadcast;
> -			create =3D 0;
>  			if (mcast->backoff > 1 &&
>  			    time_before(jiffies, mcast->delay_until)) {
>  				delay_until =3D mcast->delay_until;
> @@ -590,13 +611,7 @@ void ipoib_mcast_join_task(struct work_struct *wor=
k)
>  				/* Found the next unjoined group */
>  				init_completion(&mcast->done);
>  				set_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
> -				if (test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags))
> -					create =3D 0;
> -				else
> -					create =3D 1;
> -				spin_unlock_irq(&priv->lock);
> -				ipoib_mcast_join(dev, mcast, create);
> -				spin_lock_irq(&priv->lock);
> +				ipoib_mcast_join(dev, mcast);
>  			} else if (!delay_until ||
>  				 time_before(mcast->delay_until, delay_until))
>  				delay_until =3D mcast->delay_until;
> @@ -616,9 +631,9 @@ out:
>  		init_completion(&mcast->done);
>  		set_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
>  	}
> -	spin_unlock_irq(&priv->lock);
>  	if (mcast)
> -		ipoib_mcast_join(dev, mcast, create);
> +		ipoib_mcast_join(dev, mcast);
> +	spin_unlock_irq(&priv->lock);
>  }
> =20
>  int ipoib_mcast_start_thread(struct net_device *dev)
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--GOLitGnoIE83DiCoKxR5WlGwLEL77qNxq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV3KrNAAoJELgmozMOVy/dU3wQAISAJDeVtJ4evc2+FfqoejiX
lMZxQ236cCN+PgNo0B8QLV6XQ9JpAaTROV8bVwBoAio5iUar77VFwLlUJi+qNlm/
XjeTzmH+CpRFjjwUWGgSDzjfZNm53VfM4tDNYVdGosn/5S0MEZsq/R45auimhqIY
y2pg12RwfBGb4eETmqcEFGDbcLimuF4shlVq1wOiuFk+aCVCaaIM3ukoF/y/aOTx
IIpJTVU67E4sssnkfwi3l9OCh7OtxwouyuAV0E/5S0t5MPqJBTL3UClSPbojGBOR
0jqznoIULSL2/pefnObNaS7MPwgCY3202C7shiZdZ37fFhc+XJajJfqSHdqU3sw8
HU1r3CEAFgpyWS8G82w3IiI0cP9g3qq0YPaEGTEQ1xPIHub6AmXjWS66+ut4aQD4
qJu5Ufp4R8vh6zn8NFbnEPHxHT9Sk/r6WXmxWL4gjIudFQTWq2gKEwwqfv3NaAV7
Ju4/PFzUg59bSoN2I101q78MD3mh17d0M7ipYkeBTLFeVddxAmw2c6XmqVKs5kQT
AJbIl1G0Gwtsm58Hmtlv8MjZr41UH6NOwTfI6HQTKTUYmGAlY/HGlyz6BExLOcYv
GbLfzzjCteKIQbpmOumjW9scdtJSVxkU/uh0kyCAs67AeUqeK11jyDlabETOaodL
peqJl1M0yQBH+nVrrbuf
=/m5D
-----END PGP SIGNATURE-----

--GOLitGnoIE83DiCoKxR5WlGwLEL77qNxq--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
