From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 6/7] IB/mlx5: Assign DSCP for R-RoCE QPs
 Address Path
Date: Thu, 19 Jan 2017 09:54:54 +0200
Message-ID: <20170119075454.GL32481@mtr-leonro.local>
References: <20170118121036.32642-1-leon@kernel.org>
 <20170118121036.32642-7-leon@kernel.org>
 <20170118202343.GC17688@yuval-lap>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fR+PqOw3NP3t8CTJ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170118202343.GC17688@yuval-lap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--fR+PqOw3NP3t8CTJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 18, 2017 at 10:23:44PM +0200, Yuval Shaia wrote:
> On Wed, Jan 18, 2017 at 02:10:35PM +0200, Leon Romanovsky wrote:
> > From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > For Routable RoCE QPs, the DSCP should be set in the QP's
> > address path.
> >
> > The DSCP's value is derived from the traffic class.
> >
> > Fixes: 2811ba51b049 ("IB/mlx5: Add RoCE fields to Address Vector")
> > Cc: Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Reviewed-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/mlx5/main.c    | 21 +++++++++++++++++++++
> >  drivers/infiniband/hw/mlx5/mlx5_ib.h |  2 ++
> >  drivers/infiniband/hw/mlx5/qp.c      |  7 +++++++
> >  3 files changed, 30 insertions(+)
> >
> > diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> > index 1dea407..6a81f027 100644
> > --- a/drivers/infiniband/hw/mlx5/main.c
> > +++ b/drivers/infiniband/hw/mlx5/main.c
> > @@ -325,6 +325,27 @@ __be16 mlx5_get_roce_udp_sport(struct mlx5_ib_dev *dev, u8 port_num,
> >  	return cpu_to_be16(MLX5_CAP_ROCE(dev->mdev, r_roce_min_src_udp_port));
> >  }
> >
> > +int mlx5_get_roce_gid_type(struct mlx5_ib_dev *dev, u8 port_num,
> > +			   int index, enum ib_gid_type *gid_type)
> > +{
> > +	struct ib_gid_attr attr;
> > +	union ib_gid gid;
> > +	int ret;
> > +
> > +	ret = ib_get_cached_gid(&dev->ib_dev, port_num, index, &gid, &attr);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (!attr.ndev)
> > +		return -ENODEV;
>
> Two questions:
> First for my understanding :) I see that this check is already done in
> __ib_cache_gid_get so why it is not enough?
> Second: Since this is light test, can we have it before the call to
> ib_get_cached_gid?

I don't see such check there, can you point me?

 428 static int __ib_cache_gid_get(struct ib_device *ib_dev, u8 port, int index,
 429                               union ib_gid *gid, struct ib_gid_attr *attr)
 430 {
 431         struct ib_gid_table **ports_table = ib_dev->cache.gid_cache;
 432         struct ib_gid_table *table;
 433
 434         table = ports_table[port - rdma_start_port(ib_dev)];
 435
 436         if (index < 0 || index >= table->sz)
 437                 return -EINVAL;
 438
 439         if (table->data_vec[index].props &GID_TABLE_ENTRY_INVALID)
 440                 return -EAGAIN;
 441
 442         memcpy(gid, &table->data_vec[index].gid, sizeof(*gid));
 443         if (attr) {
 444                 memcpy(attr, &table->data_vec[index].attr, sizeof(*attr));
 445                 if (attr->ndev)
 446                         dev_hold(attr->ndev);
 447         }
 448
 449         return 0;

And regarding your second question, as you can see above in line 444, we
are overwriting attr->ndev, so it can be zero. It requires us to check
attr->ndev after calling to ib_get_cached_gid too.

Thanks

--fR+PqOw3NP3t8CTJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliAcM4ACgkQ5GN7iDZy
WKceBw/+LpCyZlcHhpuLwP19thGwh6NvWi00GvQOn/y3kPLbfDcBd7Qkph5Qvrpl
Vskw202VGVEUY/Xj0IXF1563iud4N2RIU7sKHw6Z5QMbKTYfyZOTMq0xkgU4AgQa
YNT5BVQcBtdLyvDkrwmTG3neOAzvYVFcwmwgQfnLlFUgU0kADNgE0B9TyPFQAvB9
v/KMI8/8r+sJLJjnhiVMD/JGrs0Lb5BLXe/+9X/N4JqgO6eGp6adgwfg7CeL+ShA
ZK+zxduX1Y0wZDzBZuREK6ZZr7ushBZ/VKRpD5bHYeTtqN59rSza8Pr5GsYrbRhh
iJP3SvPfofk2rk40Wize5KM5BIx+1j66bjHAEMwHGLfyGaZVmkBi9Q6QCE7l4pr9
EMog5yZmnMMHZC5MLnEzrasOxMsRakKwFqe/NNvCwFp9KMk5UJ+pqmpJfEyr1W+n
Bkg5V4bIyDErUHNnTNcqUigPIb5ctYL34Jv5LmnFfXcdhpkj73ceEbbgUfplfdg8
CTr8Uk/L7L3ris7jdFy2bANaQ5ECHLZftEV52Nt8DXad49m8pnU0RlYjl0NalX8N
XVLcu9ipxM0UOLu0svur5PuhNsI94HpA8sjzySdNByU4FAYT/rVbHOCNZGinbQg1
pp3sSe3SSkz71fm011S0otUvR0F5ltf7R6It/72VH+XCmwvctmk=
=t/Z+
-----END PGP SIGNATURE-----

--fR+PqOw3NP3t8CTJ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
