From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v7 3/8] RDMA/restrack: Add general
 infrastructure to track RDMA resources
Date: Mon, 29 Jan 2018 07:37:11 +0200
Message-ID: <20180129053711.GC1393@mtr-leonro.local>
References: <20180128091725.13103-1-leon@kernel.org>
 <20180128091725.13103-4-leon@kernel.org>
 <20180128210350.GJ23869@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="pJYAKWPIlN1lq59k"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180128210350.GJ23869-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--pJYAKWPIlN1lq59k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 28, 2018 at 02:03:50PM -0700, Jason Gunthorpe wrote:
> On Sun, Jan 28, 2018 at 11:17:20AM +0200, Leon Romanovsky wrote:
> > +int __must_check rdma_restrack_get(struct rdma_restrack_entry *res)
> > +{
> > +	return kref_get_unless_zero(&res->kref);
> > +}
> > +EXPORT_SYMBOL(rdma_restrack_get);
> > +
> > +static void restrack_release(struct kref *kref)
> > +{
> > +	struct rdma_restrack_entry *res;
> > +
> > +	res = container_of(kref, struct rdma_restrack_entry, kref);
> > +	complete(&res->comp);
> > +}
> > +
> > +int rdma_restrack_put(struct rdma_restrack_entry *res)
> > +{
> > +	return kref_put(&res->kref, restrack_release);
> > +}
> > +EXPORT_SYMBOL(rdma_restrack_put);
> > +
> > +void rdma_restrack_del(struct rdma_restrack_entry *res)
> > +{
> > +	struct ib_device *dev;
> > +
> > +	if (!res->valid)
> > +		return;
> > +
> > +	dev = res_to_dev(res);
> > +	if (!dev)
> > +		return;
> > +
> > +	down_read(&dev->res.rwsem);
> > +	rdma_restrack_put(res);
> > +	up_read(&dev->res.rwsem);
>
> I can't see why this lock is necessary, the underlying kref is already
> atomic.

Just to be similar to read implementation.

>
> This locking seems fine, can't see any problem with it.
>
> But I still hate the readability of the kref-as-not-a-kref approach.
>

And I like :)

> Now that you've written it out, it is clear this is actually open
> coding a rw_semaphore??
>
> I think lockdep will be okay with this due to the trylock?
>
> It saves a bit of memory compared to a kref + completion, and has
> better clarity:

Let's put debug option aside,
It saves one "unsigned int done" and only if you didn't
enable CONFIG_RWSEM_SPIN_ON_OWNER, otherwise they are the same.

Thanks

--pJYAKWPIlN1lq59k
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpuswcACgkQ5GN7iDZy
WKfX+xAAqahcJkUBwkXiZiaC+/ao4hn027WUyzY/I5LQVX+r67Yj716J+wCFanPz
6n0Van5HDeFCB5eAyS4RvB09g0hgz68BOOl8eNA4i5BI9xMDeShRrGQOvquRS6Yj
7Tb2MCn3HKBA8B847Q5ektJXwCMDEkwDPAkqugU+irMi/0RA0KZv1xNu6r8zmAIQ
6xUH1tS7kFsgAjbCNKnQ3PS9ki6KwblgPpQEydPcfdhsbLbISrAnigajkVWCYjib
RKc+PkxRFGHbqrrtm/i97yvJ8ClHsJRiIIh9ILSmHzWyVyJE24c+YT/AqHmod2e4
w/1EqqvFKWO+Qm9/WZzT0NQBxzRnsqcfo2i3k/e0IGIzB7iyHu/zNrzVfsKXVSUX
bdeMUxU1pF2UxX3494G64MlaWR48tlm0r+GiMTXjf9eGJtkBxmn7Y0wyZY9KCNjg
OM2eMKx0flGNoVvn1NU5VdbObjHJLnJbx6ifWEo5hIxeTZm1A88eGgvnYzwtYdBz
wlEMzM5ji6DGyXDmBNbS+Oxuaq2m0YzK3Oh+i0oknCdI/UQcRSdiOfGmnreKUOpu
Dht1+q8pFuEMAYbeM31P9gThK6htxXt2NZWgiKVNkIQnlZQJF4J9Sv1Z0xLwGx4I
Ak5o+cl+ZJ8gHKE2nV1B2FbwuODuMhIJGhobov/+2eGxcsS8wIE=
=9ytN
-----END PGP SIGNATURE-----

--pJYAKWPIlN1lq59k--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
