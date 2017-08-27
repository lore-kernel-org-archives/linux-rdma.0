From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-next v3 20/24] IB/ipoib: Add get statistics support to
 SRIOV VF
Date: Sun, 27 Aug 2017 14:17:56 +0300
Message-ID: <20170827111756.GR1724@mtr-leonro.local>
References: <20170817125055.31424-1-leon@kernel.org>
 <20170817125055.31424-21-leon@kernel.org>
 <1503607480.78641.51.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="eHOIV5BfioPmIRHC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1503607480.78641.51.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--eHOIV5BfioPmIRHC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 24, 2017 at 04:44:40PM -0400, Doug Ledford wrote:
> On Thu, 2017-08-17 at 15:50 +0300, Leon Romanovsky wrote:
> > From: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > Add SRIOV VF support to get traffic statistics.
> >
> > Signed-off-by: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>
> This one was already in my tree and so I had to skip it:
>
> eb54714ddcb2 IB/ipoib: Add get statistics support to SRIOV VF
>
> git tag --contains eb54714ddcb2
> for-linus
> for-next
> v4.13-rc5
>
> So this was in what you submitted for -rc5 in the IPoIB fixes.  It
> shouldn't have made it into this patch series again.

You are right, sorry for the mess.

>
> > ---
> >  drivers/infiniband/ulp/ipoib/ipoib_main.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > index 627ff8fb59b0..9e8dce6e9fc2 100644
> > --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > @@ -1846,6 +1846,7 @@ static const struct net_device_ops
> > ipoib_netdev_ops_vf = {
> >  	.ndo_tx_timeout		 = ipoib_timeout,
> >  	.ndo_set_rx_mode	 = ipoib_set_mcast_list,
> >  	.ndo_get_iflink		 = ipoib_get_iflink,
> > +	.ndo_get_stats64	 = ipoib_get_stats,
> >  };
> >
> >  void ipoib_setup_common(struct net_device *dev)
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>

--eHOIV5BfioPmIRHC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmiqmQACgkQ5GN7iDZy
WKfNcxAAsvvRiMloKakxV3wBbpmgF32KNVdZIZ3rkmaWa5vfVOtWYpyqAQPvdOrS
VQbNyk4XHN3ppfrndTs5XLA/8YBreLeQVdIgQ6HbF5T1ATQHwN1XyFaQf2eSqz0i
zoJZopEY8q4BlhcdMJCdN9GhAs8a+r0zxtzslrUkwOnQ3NPFdzD11WGDMhHn6SP7
T58KZjEQYorecS1JpAxngSFkR/erTv8d3kd9WsoernY6RUjKmoj76PNc+D/3vg6v
g2Je9KqkEE2E8csUB/917kgCdaMmLUr/R/FpL/zcxAAnXZTuGExHjyN5G9yB9lh+
fe9G5Ryoc4uc3ijgLouniaFUzDoaJIbKbAeX5DRDt9KPATz+2NMzPlCTV2mZM7Sn
+urkmnVak5KP4+vCScJFCNY+31HpmzXP1H/QC4UFjDgJSYz8F0TmAhcLzIWR/vF1
ptkn7b7x7YQaIJ+h4NUACa9hktPlQbG5K3J/asS8kWCpb0mNj7Zn6jpk4jgHX5Xl
f4enAVBMp8Z18tbz7MOy9X5J1CJdQxZCS9d3JMCdhNPcUpf+S9fe14zRAhLCvJ3J
q2WeR2IbmfSP1M//sTFxPmh70JNxvuIw/E62UMqwo20UVs1tA1nVqGeOA+Cu30pf
geNVA1IxAQrkMMDZ9PMWQsPkdBZgMHRR4NW5Sk/RRmYHwo0+x8U=
=idkW
-----END PGP SIGNATURE-----

--eHOIV5BfioPmIRHC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
