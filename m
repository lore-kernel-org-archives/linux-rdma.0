From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 5/5] IB: Query port through the core instead of
 directly calling the driver handler
Date: Wed, 25 Jan 2017 14:39:20 +0200
Message-ID: <20170125123920.GO6005@mtr-leonro.local>
References: <20170119054102.20135-1-leon@kernel.org>
 <20170119054102.20135-6-leon@kernel.org>
 <20170124205938.GA5524@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="N/GrjenRD+RJfyz+"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170124205938.GA5524-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Rajesh Borundia <rajesh.borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--N/GrjenRD+RJfyz+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 24, 2017 at 02:59:38PM -0600, Shiraz Saleem wrote:
> On Thu, Jan 19, 2017 at 07:41:02AM +0200, Leon Romanovsky wrote:
> > From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > Change the drivers to call ib_query_port in their get port
> > immutable handler instead of their own query port handler.
> >
> > Doing this required to set the core cap flags of this device
> > before the ib_query_port call is made, since the IB core might
> > need these caps to serve the port query.
> >
> > Drivers are ensured by the IB core that the port attributes passed
> > to the port query verb implementation are zero, and hence we
> > removed the zeroing from the drivers.
> >
> > This patch doesn't add any new functionality.
> >
> > Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---

<snip>

> > --- a/drivers/infiniband/hw/mlx4/alias_GUID.c
> > +++ b/drivers/infiniband/hw/mlx4/alias_GUID.c
> > @@ -499,6 +499,7 @@ static int set_guid_rec(struct ib_device *ibdev,
> >  	struct list_head *head =
> >  		&dev->sriov.alias_guid.ports_guid[port - 1].cb_list;
> >
> > +	memset(&attr, 0, sizeof(struct ib_port_attr));
> >  	err = __mlx4_ib_query_port(ibdev, port, &attr, 1);
>
> So why not call ib_query_port here as opposed to driver handler? As stated in your subject line.

This is call to mlx4 internal implementation of ib_query_port. This
implementation takes an additional parameter. In this case it is "1",
while call to ib_query_port will call to this function with "0".

>
> >  	if (err) {
> >  		pr_debug("mlx4_ib_query_port failed (err: %d), port: %d\n",
> > diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
> > index 7019b94..646dcbf 100644
> > --- a/drivers/infiniband/hw/mlx4/main.c
> > +++ b/drivers/infiniband/hw/mlx4/main.c
> > @@ -741,7 +741,7 @@ int __mlx4_ib_query_port(struct ib_device *ibdev, u8 port,
> >  {
> >  	int err;
> >
> > -	memset(props, 0, sizeof *props);
> > +	/* props being zeroed by the caller, avoid zeroing it here */
> >
> >  	err = mlx4_ib_port_link_layer(ibdev, port) == IB_LINK_LAYER_INFINIBAND ?
> >  		ib_link_query_port(ibdev, port, props, netw_view) :
> > @@ -1014,7 +1014,7 @@ static int mlx4_ib_modify_port(struct ib_device *ibdev, u8 port, int mask,
> >
> >  	mutex_lock(&mdev->cap_mask_mutex);
> >
> > -	err = mlx4_ib_query_port(ibdev, port, &attr);
> > +	err = ib_query_port(ibdev, port, &attr);
> >  	if (err)
> >  		goto out;
> >
> > @@ -2527,13 +2527,6 @@ static int mlx4_port_immutable(struct ib_device *ibdev, u8 port_num,
> >  	struct mlx4_ib_dev *mdev = to_mdev(ibdev);
> >  	int err;
> >
> > -	err = mlx4_ib_query_port(ibdev, port_num, &attr);
> > -	if (err)
> > -		return err;
> > -
> > -	immutable->pkey_tbl_len = attr.pkey_tbl_len;
> > -	immutable->gid_tbl_len = attr.gid_tbl_len;
> > -
> >  	if (mlx4_ib_port_link_layer(ibdev, port_num) == IB_LINK_LAYER_INFINIBAND) {
> >  		immutable->core_cap_flags = RDMA_CORE_PORT_IBA_IB;
> >  		immutable->max_mad_size = IB_MGMT_MAD_SIZE;
> > @@ -2549,6 +2542,13 @@ static int mlx4_port_immutable(struct ib_device *ibdev, u8 port_num,
> >  			immutable->max_mad_size = IB_MGMT_MAD_SIZE;
> >  	}
> >
> > +	err = ib_query_port(ibdev, port_num, &attr);
> > +	if (err)
> > +		return err;
> > +
> > +	immutable->pkey_tbl_len = attr.pkey_tbl_len;
> > +	immutable->gid_tbl_len = attr.gid_tbl_len;
> > +
> >  	return 0;
> >  }
> >
> > diff --git a/drivers/infiniband/hw/mlx4/sysfs.c b/drivers/infiniband/hw/mlx4/sysfs.c
> > index 69fb5ba..5835165 100644
> > --- a/drivers/infiniband/hw/mlx4/sysfs.c
> > +++ b/drivers/infiniband/hw/mlx4/sysfs.c
> > @@ -226,6 +226,7 @@ static int add_port_entries(struct mlx4_ib_dev *device, int port_num)
> >  	int ret = 0 ;
> >  	struct ib_port_attr attr;
> >
> > +	memset(&attr, 0, sizeof(struct ib_port_attr));
> >  	/* get the physical gid and pkey table sizes.*/
> >  	ret = __mlx4_ib_query_port(&device->ib_dev, port_num, &attr, 1);
>
> Ditto as previous comment.

The same answer as before.

>
>

--N/GrjenRD+RJfyz+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliInHgACgkQ5GN7iDZy
WKcoVxAAm6fxpn4raXdhTBnZdGOEf+qBtchWKxb2stz70D9dWUkSvdvuujXPhRjR
JxA6ygHnIaK8aoQJFWmu6jenQevdAKac/SlpnPc2Rr1nEOicUyy+1YYXJIcYlLNd
Hxne0legSINzIy1YvZ0cMwNdT2AXX2yaN1tLCqfDBU9VSRvm+8CN15Yvk8OwJNrY
TYj9v0UGyDPeNu5NjeQIh2qXr+nTKgR9HnlORWGDMG1b0aMxxug3auZjBKPv0y3L
CN47T7nsSwRmS9AkqYfFdnR5IsxjrlTLAvS9rBiygkEYy0Rx/kwv4aY4E6hAYscF
iqXb7Q0YM7H1/GHwIlegrd3ozEsjTsqQWm52v9EOJipXmyOpLez64GILb+RLY8EV
XKk7dMvKAAKFK0rgx6AQigHNaNkDZfaAS+/6rU3J55uJZHyUnpUTOPV9LyFXQHFa
LZAsq8GUO0RbECbXdkv0UfqjFtZFWO09ITKtdMM5WQchLS10812JPnjkUfnYS5he
H3qPCxV+x5cYf4LK6I9OuFg+q6/3v1/4lKhmGXwKf4mjAjTbeqaR5/MBMd2Fm+IM
pMPB5j5QA22rHx98qe1GqEuk1S9xVLEjCLlf4MMgieRMni1TbR+9d6krkQqw0mXm
mQzf9zim2vVMpwhPGbK5NjQzqbKvi/CNzSrWCVheifpjGAF45lw=
=GJ3F
-----END PGP SIGNATURE-----

--N/GrjenRD+RJfyz+--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
