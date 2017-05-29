From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/2] IB/mlx5: set UMR wqe fence according to HCA cap
Date: Mon, 29 May 2017 19:06:09 +0300
Message-ID: <20170529160609.GA17751@mtr-leonro.local>
References: <1495957991-19223-1-git-send-email-maxg@mellanox.com>
 <1495957991-19223-2-git-send-email-maxg@mellanox.com>
 <20170528090705.GM13083@lst.de>
 <19a1d347-91da-7e5f-8877-86772204a80a@mellanox.com>
 <20170529100504.GZ17751@mtr-leonro.local>
 <89409b6d-466d-070a-7082-1f7bbb9ad7c7@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="D2rVImvqWGvKULsk"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <89409b6d-466d-070a-7082-1f7bbb9ad7c7-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org, vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--D2rVImvqWGvKULsk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 29, 2017 at 03:21:11PM +0300, Max Gurtovoy wrote:
>
>
> On 5/29/2017 1:05 PM, Leon Romanovsky wrote:
> > On Sun, May 28, 2017 at 12:53:00PM +0300, Max Gurtovoy wrote:
> > >
> > >
> > > On 5/28/2017 12:07 PM, Christoph Hellwig wrote:
> > > > On Sun, May 28, 2017 at 10:53:11AM +0300, Max Gurtovoy wrote:
> > > > > Cache the needed umr_fence and set the wqe ctrl segmennt
> > > > > accordingly.
> > > >
> > > > Looks good,
> > > >
> > > > Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> > >
> > > Thanks.
> > >
> > > >
> > > > But that whole fence logic looks awkward to me.  Does the following
> > > > patch to reorder it make sense to you?
> > > >
> > >
> > >
> > > Yes it make sense to me.
> > > Sagi/Leon, any comments ?
> >
> > Max,
> >
> > Do you see any performance impact for IB_WR_RDMA_READ, IB_WR_RDMA_WRITE
> > and IB_WR_RDMA_WRITE_WITH_IMM flows? They don't need fences and such
> > change can cause to performance losses.
> >
> > Thanks
> >
>
> We don't fence those WR's.
> Christoph just re-write it to be more intuitive code. I don't see logic
> difference, am I wrong here ?

A little bit, before Christoph's suggestion, we calculated fence for
the paths which need such fence, after we will calculate for all paths.

Thanks

>
> >
> > >
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html

--D2rVImvqWGvKULsk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlksRvEACgkQ5GN7iDZy
WKdlmg/+MHYdGiUaypLVniOkHEDa6tbW590y8/uWHLbEIqSOySKGhH5zZghQR3sV
oFsYIBKYrD8Dmdegr15aNykVfsBKp2//n+4cK1/T0KPlc5O/RRvhFXYPaTkqf7gT
6R0jng/LohV2d2gjiKSWkJCZUApC7UveM9VI/XYt4wf4DcW86liDVbOnzGJRm/sb
5hjQ6V2tX/TafJdBw6jO5uVNlpOTEv7y75U3JJJgc+1b2iMHkgxK0g0HNnms6Iji
TcJ79aZv0r8BdMDBx3PzAB7rn3X5Pl36IfC6tSAFVlP5hpcBGN5UBfrdSXtuvkLV
Kmuf6BWS+5md/7rIul/gxO5/uUFs+UB8FfZsDv4pslSJvDVuBdoId0K0OLUWjJuf
hhghD5BECww71ief5LByPtLooMAYnsiCqgveXlW4Tc47BRSNH2thRvtge0dkVvJc
wshZK4+x1dFv+EC2MeTPK1JctWkh0miG0UHo4G9tUcYIWtDahkCe6WP2Dh9HkIIO
jc9gKFWzGCtHueqS3cG0+qAPbkZNcsdJHqRke6+WZXeOE6BnMoQqOhA8pWNKFxxp
L7dqisnU2LU06CbED7gO/h6NNlKM0ZVLpJQlOGixqUR96BGDZuVvAkwUFZE76N+e
FXCRbLbhLSUnBnWtb1I6VREcL+dSqeauWHVfDZLv3ThZ5/D+aZM=
=ZOuv
-----END PGP SIGNATURE-----

--D2rVImvqWGvKULsk--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
