From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] qedr: Fix missing unlock on error in qedr_post_send()
Date: Wed, 2 Nov 2016 17:51:37 +0200
Message-ID: <20161102155137.GH3617@leon.nu>
References: <1477672406-31487-1-git-send-email-weiyj.lk@gmail.com>
 <20161031053835.GV3617@leon.nu>
 <SN1PR07MB22074858C222B214F03D8ED7F8A10@SN1PR07MB2207.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="omvsDzxk2EIq1H0W"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <SN1PR07MB22074858C222B214F03D8ED7F8A10-mikhvbZlbf8TSoR2DauN2+FPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Borundia, Rajesh" <Rajesh.Borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--omvsDzxk2EIq1H0W
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 01, 2016 at 02:09:42PM +0000, Amrani, Ram wrote:
> > > index a615142..e7c7417 100644
> > > --- a/drivers/infiniband/hw/qedr/verbs.c
> > > +++ b/drivers/infiniband/hw/qedr/verbs.c
> > > @@ -2983,7 +2983,8 @@ int qedr_post_send(struct ib_qp *ibqp, struct
> > > ib_send_wr *wr,
> > >
> > >  	if (!wr) {
> > >  		DP_ERR(dev, "Got an empty post send.\n");
> > > -		return -EINVAL;
> > > +		rc = -EINVAL;
> > > +		goto out_unlock;
> > >  	}
> >
> > IMHO, this if needs to be moved to be before acquiring spinlock and avoid
> > introducing new labels for this one case only.
> >
>
> Thanks Wei and Leon.
>
> Actually, perhaps we can totally remove the check itself -
> Since this is kernel space, is it safe to presume that all ULPs are trusted to be well coded?

I think so.

--omvsDzxk2EIq1H0W
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYGguJAAoJEORje4g2clinLFQP/j7m18rF3LhY9MjWehySQslH
ADj9IW8FJOOlxqvpvR+qHfhO/nNuNmzFQR5SwvD/cSLguoFUK2jan8tOCU6xlR6h
8sy1xqR/C9GjLHoRhqe8ynsGokW2BUEm1GU9954LMc8UPbEqtzvCXrNW5psFsiwZ
404Hy7SSC5YPXypqO4WcelzHRBvhEfyMxxcQP8lGVFj5OEI3/vlq24vP2X2oFGpe
JIoW+Sdoa5x/wCs7WPAmOJxB9qhGuEvNCgMR4VimeWPHW3Dkqwc+VHUerA3WD991
8jOW5wqTayeI94IWPsarH/3we+zWtFu1JSD85tF/pZFOOayQEY1+OgJYJU2tvDqe
K3aXs4iIQXETcDHzzAlZkgN8NLp7DNtYW3+4jyqR6UTTpA8KQe7B4N86I9yUQqHI
xAwJR2p3DXJpP5OTnz8s2F9GY9C+mbHoqgN21vqoN8dYmx9yNGrLILzfF6UbohMw
d97l+BQ/INcLhsufky5Rprcls97UuP1YnkXcri+E6hWUyGD4dXqQoX9bJwHVwg49
tSAcu3AsvoEObVtbcC96TdTNLppt0k9O8ruBqoomD7YKbF2T/fjRYzu6vhrCzLI3
HgeNNRixLMf2U6U47Uh6kSwE5fuhRDiL2KylsJkpFdX6t4OJ5FVfSsZti2nhaRnM
I3Bql9BkkZxVBOIg/S8V
=SHcd
-----END PGP SIGNATURE-----

--omvsDzxk2EIq1H0W--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
