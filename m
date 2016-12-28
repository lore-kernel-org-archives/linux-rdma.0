From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 7/9] IB/ipoib: Use debug prints instead of
 warnings in RNR WC status
Date: Wed, 28 Dec 2016 14:22:09 +0200
Message-ID: <20161228122209.GD26885@mtr-leonro.local>
References: <20161227133911.14340-1-leon@kernel.org>
 <20161227133911.14340-8-leon@kernel.org>
 <20161228121529.GD6237@yuval-lap>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="at6+YcpfzWZg/htY"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161228121529.GD6237@yuval-lap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--at6+YcpfzWZg/htY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 28, 2016 at 02:15:29PM +0200, Yuval Shaia wrote:
> On Tue, Dec 27, 2016 at 03:39:09PM +0200, Leon Romanovsky wrote:
> > From: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > If a receive request has not been posted to the work queue, the incoming
> > message is rejected and the peer will receive a receiver-not-ready (RNR)
> > error. In IPoIB, IB_WC_RNR_RETRY_EXC_ERR error is part of the life cycle
> > therefore ipoib_cm_handle_tx_wc function will print to debug instead
> > of warnings.
> >
> > Signed-off-by: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> >  drivers/infiniband/ulp/ipoib/ipoib_cm.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> > index a720d2d..b6444b2 100644
> > --- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> > +++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> > @@ -820,9 +820,12 @@ void ipoib_cm_handle_tx_wc(struct net_device *dev, struct ib_wc *wc)
> >  	    wc->status != IB_WC_WR_FLUSH_ERR) {
> >  		struct ipoib_neigh *neigh;
> >
> > -		ipoib_dbg(priv, "failed cm send event "
> > -			   "(status=%d, wrid=%d vend_err %x)\n",
> > -			   wc->status, wr_id, wc->vendor_err);
> > +		if (wc->status != IB_WC_RNR_RETRY_EXC_ERR)
> > +			ipoib_warn(priv, "%s: failed cm send event (status=%d, wrid=%d vend_err %x)\n",
> > +				   __func__, wc->status, wr_id, wc->vendor_err);
>
> Do we really need function-name to be printed here?

You are right,
Sorry, I missed it in review and will respin without __func__.

>
> > +		else
> > +			ipoib_dbg(priv, "%s: failed cm send event (status=%d, wrid=%d vend_err %x)\n",
> > +				  __func__, wc->status, wr_id, wc->vendor_err);
> >
> >  		spin_lock_irqsave(&priv->lock, flags);
> >  		neigh = tx->neigh;
> > --
> > 2.10.2
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

--at6+YcpfzWZg/htY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhjrnEACgkQ5GN7iDZy
WKcbVg//eztfPnBAkhp/vHM1QVV+FvU+TDAquMlQ39zSsEpESLXI+M8g1mjJarm7
KSTZ5F1dBhU6EjhcXOX5+BtVp9aQwWVL4Dx5eSwXMkPU7x4wSbP2u4UCapeFIIJ8
QR2MNkndqMOds4v6E/PkYLaFFdgIgXNmsbWNlhvNvuJk/DzkPi41xDOPtgOWxUM4
VRWgXw37EVY8xN7cIvzuGbm+sct0nJ7rt5EqhRk0K/rmHiBgry3j+VvMK0H2HOjT
AO/P4PztYcp7haCccI8XMph6UZ+fLtueTX3uYf6iMv7wyeAemXm2OOXPKa/85UP1
PfzHMNQXddaD3hhK0ORG80RAirO5zw6R4K982CS6CxA+uOfzrE8vmtN/AOxQts8I
uvjaZUbnc2oDAqkRf/+03PaYdX6QhC/7pQcU8Rcxr/lLNj3cV8Trv2JcftKto5Y4
jdS1mejY5kgP0nXIjYCfgqXsmnRKgmHdIFVkJ92A9MgH27bnC5Fhi3k6Pq+FtMYz
PM/fKhWNqbdrVVvurNgsZFSzh87damtygs3pwqx6x8wqfsTsKLFC83HdTwxEQdGX
buf7CP3c2XBvt4tObiATWb91Wv27yH/LAHXKRmMiDtF3L7aMwR8Dj3XP/2gN2YwN
j1uoP5qPzyDymey5LRIneFa+fdzi50aiVnVxu2X5eFDO0SqEMNk=
=Brke
-----END PGP SIGNATURE-----

--at6+YcpfzWZg/htY--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
