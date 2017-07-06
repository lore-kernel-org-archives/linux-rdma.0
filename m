From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-rc v1] IB/core, opa_vnic, hfi1, mlx5: Properly free
 rdma_netdev
Date: Thu, 6 Jul 2017 17:11:31 +0300
Message-ID: <20170706141131.GB1528@mtr-leonro.local>
References: <8e959601996dc645f4ed7004482a1667c27deb39.1499289360.git.dledford@redhat.com>
 <20170706042347.GP1528@mtr-leonro.local>
 <1499348404.2783.32.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="dT+85zccSFkyJC53"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1499348404.2783.32.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--dT+85zccSFkyJC53
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 06, 2017 at 09:40:04AM -0400, Doug Ledford wrote:
> On 7/6/2017 12:23 AM, Leon Romanovsky wrote:
> > On Wed, Jul 05, 2017 at 05:17:52PM -0400, Doug Ledford wrote:
> > > From: Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuE@public.gmane.org
> > > m>
> > >
> > > -static void mlx5_ib_free_rdma_netdev(struct net_device *netdev)
> > > -{
> > > -	return mlx5_rdma_netdev_free(netdev);
> > > +	netdev = mlx5_rdma_netdev_alloc(to_mdev(hca)->mdev, hca,
> > > +					name, setup);
> > > +	if (likely(!IS_ERR_OR_NULL(netdev))) {
> > > +		rn = netdev_priv(netdev);
> > > +		rn->free_rdma_netdev = mlx5_ib_free_rdma_netdev;
> > > +	}
> > > +	return netdev;
> > >  }
> >
> >
> > Thanks Doug, it looks good enough for the fix.
> >
> > In general, the "likely" is not needed here (we are not in data path)
>
> It doesn't hurt though...
>
> > and our preference is to avoid "if(!error) { do something }"
> > constructions
> > in favor of "if(error) { return ...}" (fail as early as you can).
>
> Normally I would agree with you on that point.  But when you aren't
> returning an error code but instead are returning the same thing you
> return in the non error case, and when there are so few things to be
> done in the non error case, I think this sort of construct becomes more
> appealing (mainly because it will more closely match the assembler that
> GCC puts out when compiling this code and I think that has value for
> those times when you need to debug the object code, but that's just my
> personal opinion).
>
> > Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >

Any options are good for me, it fixes the crash :)

Thanks

>
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>

--dT+85zccSFkyJC53
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlleRRIACgkQ5GN7iDZy
WKdQqA/+OpU1IILPfLAf2lg1ht6+ZuKAy7gUpvLU1cM1nu9RD87rnBFjnWrmvW0k
Ahd52kxJ/3yBD5SpmT056IPUSNGVeL+7dTylpRz4hfNA7y4nT1WW3PXCipdIHoH1
m6HiOCGBObikYtPF0poJutECBooTkggQULkiXiu4vVi1HOgogb4fli2nNSwMuhL0
oOpYVI+lL/GjcLEXC4zwfqT4NgWiS5a+YADxwY7cun2L9k/6D3ZSZUXauKjNXU6O
R7yvGitGFPhKOYpTZ8x1CXapVUt6MRQORT5RZDyiVHxLXjsdJTjMoNasFdRe0Q4R
faj2/bz/OUVnXQ4IW5ZHQqt7lYGI9UWqmL6k89Iii9c/DYxmkkwsAWEsUu90SMQ/
1qppF7v5VO0AqaSlS+TiRIeelIJQAFFZcSBfY/DFG19VXmxlbu2ginX5A5F+PTmt
2BqkN/WbRdf6xD3PlEaYzMec/q/CDK4RNElgUB094b2YVRuk8eiL9y66pg1Bso0x
ZzN2fPBKr4hA3zw3nRCF2vWh6O1NhuZA4Kg2XGw4L7Qzx34cZm7lh+6MusPPwY23
rWSdNlcok1CUrHHfmcOsdv22+G/YmZMfkiQ8+ALT509i4uJMrvW8orfEjcOQo34g
C9/jdixKX60/n2zqvcC1S7jLYKWsMcB0O5rYpPmScdMVTLXfEjc=
=Sy4E
-----END PGP SIGNATURE-----

--dT+85zccSFkyJC53--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
