From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v1 1/6] IB/uverbs: Allow CQ moderation with
 modify CQ
Date: Sun, 29 Oct 2017 20:28:08 +0200
Message-ID: <20171029182808.GN16127@mtr-leonro.local>
References: <20171029135140.32649-1-leon@kernel.org>
 <20171029135140.32649-2-leon@kernel.org>
 <20171029174345.GC4488@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="z20Z95FJiBb6FirT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171029174345.GC4488-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--z20Z95FJiBb6FirT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Oct 29, 2017 at 11:43:45AM -0600, Jason Gunthorpe wrote:
> On Sun, Oct 29, 2017 at 03:51:35PM +0200, Leon Romanovsky wrote:
> > From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > Uverbs support in modify_cq for CQ moderation only.
> > Gives ability to change cq_max_count and cq_period.
> > CQ moderation enhance performance by moderating the number
> > of cookies needed to create an event instead of application
> > having to suffer from event per cookie.
>
>
> Like the other recent uAPI patches, lets us see the rdma-core side and
> man page first please.

Yishai planned to send it tomorrow.

>
> Can you organize all of them into a rdma-core branch someplace?
>
> Not really sure what a cookie is, or why this should be needed when we
> already have the means to indicate if CQE's should be signalled or
> not.

It is my fault, I forgot to change cookie to be CQE.

>
> I guess it is for UD applications where the existing signalled stuff
> isn't applicable?
>
> > +int ib_uverbs_ex_modify_cq(struct ib_uverbs_file *file,
> > +			   struct ib_device *ib_dev,
> > +			   struct ib_udata *ucore,
> > +			   struct ib_udata *uhw)
>
> Is this really a good idea?
>
> Why not ib_uverbs_set_cq_moderation ?

It follows already existed ib_modify_cq(), see commit 2dd571622787 ("IB/core: Add support for modify CQ")

>
> We don't have to keep making these thicker and thicker APIs if there
> isn't a reason :(
>
> Jason

--z20Z95FJiBb6FirT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln2HbcACgkQ5GN7iDZy
WKdolw/+JCQZK1PKVPiAEs/LwQZbgKeHX9I7xWvuVM7/RxAbEW9EZaFeKKT7ZWMI
EE1hQButFU9X76YfleDDfzqA/L7h7KOPkMF5XKXWZYXTWHRUC1asgvEBziEbzrLc
xvE91xEcB7dWqx5Me+U4di15l/GPKUqzS0GD82yoDuZbUmlE6z6k73PUonkF7+Ia
MLyUP+6XnNvG3d7vRpMol8ceFMRRTK/nkHQ9K7su4UM6f1Qt+tjhUskz3nBDDS/k
GvVz+MtWlQVpDl7jAnFwRqsJtLxVqTxVJa0Y7nqLpO6+XfHq4C5Cm8NfwXXC7VKn
JVReJ9fNZ9YzCic7/PchcDLZRWYZEObHTSeLH8+/WEEwZtrVPKxTCTiH2zSR2OFc
DSQiVi6TtSvpGQBA3WFGgGd373mCmrdqExTuKE4JOcfztjC2qOEZ/47HqNWMP5Re
Pj/suEzOxiwOVXFvlhBNYwx8qMboeH+fi5fYyJFoaY3N0j2InvGha8JMctOIYncP
XO1HNB1Mai4TVePz8q1moOash2jXX1Kq1Og60NbGgUvwwZcaZoXf4lW7xpPNPSEU
HnaImDPUvhBMiGg0BJWF0B3u9U1WEobTi++gGPwnsEJJFtF1Wzpt5uZTESoK7fpK
vQjpuRZPUmf6dNISmESy2m3IBfM4OELpL5KcXCntt3Aocyu5EZI=
=E8zd
-----END PGP SIGNATURE-----

--z20Z95FJiBb6FirT--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
