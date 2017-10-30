From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v1 1/6] IB/uverbs: Allow CQ moderation with
 modify CQ
Date: Mon, 30 Oct 2017 21:09:52 +0200
Message-ID: <20171030190952.GC16127@mtr-leonro.local>
References: <20171029135140.32649-1-leon@kernel.org>
 <20171029135140.32649-2-leon@kernel.org>
 <20171029174345.GC4488@ziepe.ca>
 <20171029182808.GN16127@mtr-leonro.local>
 <20171030144807.GA12392@ziepe.ca>
 <20171030152815.GA16127@mtr-leonro.local>
 <20171030155236.GC12392@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="aIPTgi9H47uqouUT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171030155236.GC12392-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--aIPTgi9H47uqouUT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 30, 2017 at 09:52:36AM -0600, Jason Gunthorpe wrote:
> On Mon, Oct 30, 2017 at 05:28:15PM +0200, Leon Romanovsky wrote:
> > > + * ib_modify_cq - Modifies moderation params of the CQ
> > > + * @cq: The CQ to modify.
> > > + * @cq_count: number of CQEs that will trigger an event
> > > + * @cq_period: max period of time in usec before triggering an event
> > > + *
> > > + */
> > > +int ib_modify_cq(struct ib_cq *cq, u16 cq_count, u16 cq_period);
> >
> > I see it differently, this is extendable version of modify_cq, which is
> > going to benefit all other users who will decide to extend it.
>
> The only reason we have these goofy 'thick' APIs like modify_qp is
> because people said they needed a very high rate of qp modifications
> and could not tolerate the performance downside of a dis-aggregated
> API.
>
> I don't think CQ falls into that reasoning, so it should be
> dis-aggregated.
>
> Many things in verbs are terrible examples of how to make APIs, we
> should not just blindly copy things..

"Many things" ???
At least, you found something that is not terrible, I didn't find yet.

For the libibverb's API, I completely agree with you that we need to
strive to more simple API without overloaded functions with a lot of
parameters and you can count on my voice and support for any effort
to do so.

However, I don't think that kernel to libibverbs API should follow the
same path. The centralized entry points to the kernel provides better
enforcement and minimizes system call bloat.

Thanks

>
> Jason

--aIPTgi9H47uqouUT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln3eQAACgkQ5GN7iDZy
WKcong/+KamWfig8qb713664ErUl1u7N0EGPnooWK6HnRNR1XxKlPgbMTmBGQgMX
AHgJNrTyWu1z6xeprXBLRyvczBMzZu5lAzV4wM+uh5bjjWiKarst8P3u163MMACQ
kgnRCF8oLhm9ooebkL1ic9WvaWGG+aN/SlBQU0PuxFlRwwbNfe8txqV9d3of1+Qi
+aMhxuZ4PCMGZdYiVRIHLjmTYBKCDcujjB+/S9hz2FNAACEo/Ba2jw3uI9aWrZub
hco6hXAOVwFAJ1uPByO5zHYMJWaRRk+b5EmVX9ZXiD7eZHNlh/hbsP4iVBG5JGkE
cb1RJU0ecDA21YpSJ7FTpMxQscIP/uPEk5OjRc0eG0eOHwNjEklso4pk4+s7YZ6t
yuNX3KyskdgHNasQPHc1aSjvdvet1ME431+v9ObifIwT+OAATWOGTSrXN2+2sHCv
bsS2HiVGgLU4ZchCCqItoE47+x8oWHJM0wvjTHw6Ynp3KnwFoGkk8rpmUfcnToRB
/vs5j4TmXZ6R6vcu/sNAzAGlucsMu2yTTG+svKCHR/+DVRC01HsGskvZ6qnQzZoW
w9Uj3ZmD6eDpmUsvYEHp/6RsuyPrvMKljr49usXwFwZXidWnljd/Z5XTkzoMF01p
NIsmBA7Manv2etsXl2JtHIOvycH56dRp9qzx6lg/cLoaZ0RNwww=
=jIUk
-----END PGP SIGNATURE-----

--aIPTgi9H47uqouUT--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
