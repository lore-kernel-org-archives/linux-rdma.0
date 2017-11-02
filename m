From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next] RDMA/vmw_pvrdma: Add shared receive queue
 support
Date: Thu, 2 Nov 2017 20:02:47 +0200
Message-ID: <20171102180247.GF16127@mtr-leonro.local>
References: <20171030022037.GA20100@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171030060317.GS16127@mtr-leonro.local>
 <20171102175225.GB24375@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oDFa8iZvINJ+yMtC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171102175225.GB24375-qXbCdz4EeRo1jLI2hToXVI42T8aCTgcwy4vvyvUx+exJXi8ZT2ovy+oDBWuYMCC/JZORHMmSJCU@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--oDFa8iZvINJ+yMtC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 02, 2017 at 10:52:25AM -0700, Bryan Tan wrote:
> On Mon, Oct 30, 2017 at 08:03:17AM +0200, Leon Romanovsky wrote:
> > > +struct pvrdma_srq {
> > > +	struct ib_srq ibsrq;
> > > +	int offset;
> > > +	spinlock_t lock; /* SRQ lock. */
> > > +	int wqe_cnt;
> > > +	int wqe_size;
> > > +	int max_gs;
> > > +	struct ib_umem *umem;
> > > +	struct pvrdma_ring_state *ring;
> > > +	struct pvrdma_page_dir pdir;
> > > +	u32 srq_handle;
> > > +	int npages;
> > > +	atomic_t refcnt;
> >
> > I think that new fashion is to use refcnt_t for such counts.
> >
>
> Sure, I'll change this to refcount_t.
>
> > > +	/* Check if SRQ is supported by backend */
> > > +	if (dev->dsr->caps.max_srq > 0) {
> > > +		dev->srq_tbl = kcalloc(dev->dsr->caps.max_srq, sizeof(void *),
> > > +				       GFP_KERNEL);
> >
> > Shouldn't the "sizeof(void *)" need to be "sizeof(struct pvrdma_srq *)"
>
> Fixed.
>
> > > +		if (!dev->srq_tbl)
> > > +			goto err_qp_free;
> > > +	} else {
> > > +		dev->srq_tbl = NULL;
> >
> > dev is allocated with ib_alloc_device() and srq_tbl will be zero by default.
> >
>
> Removed.
>
> > > +static void pvrdma_srq_event(struct pvrdma_dev *dev, u32 srqn, int type)
> > > +{
> > > +	struct pvrdma_srq *srq;
> > > +	unsigned long flags;
> > > +
> > > +	spin_lock_irqsave(&dev->srq_tbl_lock, flags);
> > > +	srq = dev->srq_tbl[srqn % dev->dsr->caps.max_srq];
> >
> > Are you sure that "dev->srq_tb != NULL && dev->dsr->caps.max_srq > 0" always here?
> >
>
> Added a check for srq_tbl.
>
> > > +static void pvrdma_free_srq(struct pvrdma_dev *dev, struct pvrdma_srq *srq)
> > > +{
> > > +	unsigned long flags;
> > > +
> > > +	spin_lock_irqsave(&dev->srq_tbl_lock, flags);
> > > +	dev->srq_tbl[srq->srq_handle] = NULL;
> >
> > Again, are you sure that dev->srq_tbl exist?
> >
>
> Here we assumed that the verbs layer will only call down to us to
> destroy a valid SRQ. If an SRQ has been created, then the srq_tbl
> should exist. I can add a check here if that's not behaviour we
> should rely on.

By saying "verbs layer", are you referring to libibverbs or IB/core?

>
> > > +int pvrdma_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
> > > +		      enum ib_srq_attr_mask attr_mask, struct ib_udata *udata)
> > > +{
> > > +	struct pvrdma_srq *vsrq = to_vsrq(ibsrq);
> > > +	union pvrdma_cmd_req req;
> > > +	struct pvrdma_cmd_modify_srq *cmd = &req.modify_srq;
> > > +	struct pvrdma_dev *dev = to_vdev(ibsrq->device);
> > > +	int ret;
> > > +
> > > +	/* No support for resizing SRQs. */
> >
> > Better to write that you support, so future additions to ib_srq_attr_mask
> > won't need to change your code.
> >
>
> I'm a little unclear on what you mean here. Do you mean that we
> should explicitly check for the only attribute we support
> (IB_SRQ_LIMIT) and fail otherwise?

Yes, it will ensure that your driver doesn't get untested input.

>
> > > +	if (attr_mask & IB_SRQ_MAX_WR)
> > > +		return -EINVAL;
>
>
> Thanks for the review!
> Bryan
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--oDFa8iZvINJ+yMtC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln7XccACgkQ5GN7iDZy
WKdOmQ//f/jrPUePrNGIBXN2L23MKMQoWm0czvz822izvmfmz624XJQD5OW/AXuk
gvfhz0l+EFNRDQFt5BNhQPmq+18l/8AmYrCtIiJH7H7EkYLQ+b++W27IWtSN7dcG
kgk92cgX9tul5H8109kE5Q5Te2CbodeDr4m49tj3OwC3Ns416pp6rom0ln7m4QpF
p5zNV5f37AIsd3riVHDN6oNGF4MVioasCFESQnaCNRqgrPTay85q9X/EbzoT+WGI
apaaGp3mcJa9yIRJ9o3UFDEVXPrA/GXgJ0P+4WSPal6sNad5U9OTNuFS/0GPdWS+
QlPTeFKFS/Xhbc9zRSKEGsch7zFISxOhKrfNGliOxpCLhVFQFdMmwgKE9eN4OC+l
+LsBy+e+BJyGcM2T+NcLLDqzB0v+sN/SOhAVk2IZS/3wMlIiL0NZeZxuc88iibu1
p2r/3mPk9KNtZr9pfVJHLkSHjuZ5o+C2J/v/6cgQjevibVxIdvaT/7vBb7wVreO9
zibrLiFi064LX0pM4mgeVS4CNKlfOWe+pvmyIvpn4cnqUvEsfc1NcHOv4jb6XzJ3
kxt7hpcmA1YmR01JVSYcDABdpxyt6vm2vBbkn0MN+7yboTubjPtR+xhXwoqoNvm9
eNRvx2biZndYh096tV4CHvGZUA9RE2b9nUqWC8c7Tvl3C4Zis3o=
=IGvV
-----END PGP SIGNATURE-----

--oDFa8iZvINJ+yMtC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
