From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 5/8] RDMA/core: Provide locked variant of
 device name to index function
Date: Thu, 28 Dec 2017 07:01:59 +0200
Message-ID: <20171228050159.GJ3494@mtr-leonro.local>
References: <20171224134328.17398-1-leon@kernel.org>
 <20171224134328.17398-6-leon@kernel.org>
 <20171227230227.GK25436@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jTMWTj4UTAEmbWeb"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171227230227.GK25436-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--jTMWTj4UTAEmbWeb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 27, 2017 at 04:02:27PM -0700, Jason Gunthorpe wrote:
> On Sun, Dec 24, 2017 at 03:43:25PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > Add self-contained with locks device name to index function.
> >
> > Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >  drivers/infiniband/core/core_priv.h |  1 +
> >  drivers/infiniband/core/device.c    | 16 ++++++++++++++++
> >  2 files changed, 17 insertions(+)
> >
> > diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
> > index ded3850721e0..e71dd1814bf0 100644
> > +++ b/drivers/infiniband/core/core_priv.h
> > @@ -301,6 +301,7 @@ static inline int ib_mad_enforce_security(struct ib_mad_agent_private *map,
> >  #endif
> >
> >  struct ib_device *__ib_device_get_by_index(u32 ifindex);
> > +struct ib_device *ib_device_get_by_index(u32 ifindex);
> >  /* RDMA device netlink */
> >  void nldev_init(void);
> >  void nldev_exit(void);
> > diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> > index cb69357a1909..adf3a4ca038b 100644
> > +++ b/drivers/infiniband/core/device.c
> > @@ -150,6 +150,22 @@ struct ib_device *__ib_device_get_by_index(u32 index)
> >  	return NULL;
> >  }
> >
> > +/*
> > + * Caller is responsible to return refrerence count by calling put_device()
> > + */
> > +struct ib_device *ib_device_get_by_index(u32 index)
> > +{
> > +	struct ib_device *device;
> > +
> > +	down_write(&lists_rwsem);
> > +	device = __ib_device_get_by_index(index);
> > +	if (device)
> > +		get_device(&device->dev);
> > +
> > +	up_write(&lists_rwsem);
> > +	return device;
> > +}
>
> If you hold the write side of lists_rwsem you must also hold
> device_mutex.
>
> But the write side is only needed if the code mutates the device_list
> or client list, and this does neither, so it should be the read lock, right?

Right, I'll fix.

Thanks

>
> Jason

--jTMWTj4UTAEmbWeb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpEescACgkQ5GN7iDZy
WKdgoQ/9En2PzX2M41m5oKnm2aJOkhSfWVyhORmoimIEKfDUVqYpELrayBOVglH+
ohIoQcD9KMk2hGiHhvYxJMJuAz7p0Zr50T2r4NuElsx/NN0OtAvpilf1kxMWVijp
NfFLptx5rqGrksbAs1cQQD/L0hzYm3Y08OpQNXibmeNCvrRK8mYZ5V/VLNTOUePp
iZxYg7V2MQjfrEinskDdwDEKzSz/6GiR95h8w2Zv9X7HgP2OdWz/elR6x7U68dFH
3s1hsjuvoms1UHW0zJ2Ef9cSp9meZu4CcLeoVWYHl6mHDP7Q1M7PJpeSfRwwmjVg
slLvx73dPqZGInHNK6lBVOpEfJjC4AaOXKn3xFMcFtR/Fay8BzqUC8//dGF9bbD7
1kO0G/Z89BZm6jYtg5kqcM2SZ0Y/BlXKFGiyLnORhf9sQHDYkMRGZlZmRUq+bByg
ePHLQkFstzvdsNAhhM5ZIynfiqMh0OmDNk1LqBkqph5F9qopad0xzzcyTQpUCcrI
Nx2i8ddGo3MCwrTXl4xeP7T0rVIzpY/3wTfqYLUSZAsnG0IiqhevA+BzexV8d+A+
+OxQLKSk+QP/8cZHQ1k91LpbcbkhF2QlFg2VNXs/I3FTmwlNqX6barcz2pX3gd+H
z0IiDL2zBgDRX8uOp/C8DFcUBnEXz42hdCyqWTStXmAEcywvuBA=
=G+8J
-----END PGP SIGNATURE-----

--jTMWTj4UTAEmbWeb--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
