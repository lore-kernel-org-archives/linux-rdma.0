From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 3/4] RDMA/netink: Export lids and sm_lids
Date: Wed, 28 Jun 2017 19:24:54 +0300
Message-ID: <20170628162454.GM1248@mtr-leonro.local>
References: <20170628133445.16550-1-leon@kernel.org>
 <20170628133445.16550-4-leon@kernel.org>
 <20170628160513.GC14375@obsidianresearch.com>
 <20170628161616.GK1248@mtr-leonro.local>
 <20170628161903.GA28996@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="z5HJNHpVrs9F5Roc"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170628161903.GA28996-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--z5HJNHpVrs9F5Roc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 28, 2017 at 10:19:03AM -0600, Jason Gunthorpe wrote:
> On Wed, Jun 28, 2017 at 07:16:16PM +0300, Leon Romanovsky wrote:
> > On Wed, Jun 28, 2017 at 10:05:13AM -0600, Jason Gunthorpe wrote:
> > > On Wed, Jun 28, 2017 at 04:34:44PM +0300, Leon Romanovsky wrote:
> > > > +	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_LID, attr.lid))
> > > > +		return -EMSGSIZE;
> > > > +	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_SM_LID, attr.sm_lid))
> > > > +		return -EMSGSIZE;
> > >
> > > Is this careful to only stuff attributes if they actuall exists? Eg
> > > these should not be present for iwarp/roce/etc
> > >
> > > Same comment for all attributes. Only present if they are valid.
> >
> > It will be zero if it is not exist, but you are right it is better to
> > avoid to fill unneeded fields.
>
> Not existing is the netlink way. Same comment for everything
> attributes. Many of the guids do not apply to iwarp, IIRC..

I got it, this is why I prefer to have basic RDMAtool with minimal
prints (device name + caps) be accepted and only after that start work
on every field in serial manner.

Thanks

>
> Jason

--z5HJNHpVrs9F5Roc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllT2FYACgkQ5GN7iDZy
WKdYVhAAn2GxgIzZJpuuxQA1221Ko7ngQ5YjZxsHzmi89faLCotnrcPD51KqEB0c
n9Yo1a+ulkXggdvojyeMb9K71+rqZbMbKGQGwTWt7z/0/epZe+VzMRsWiWTbz20Y
Ik/xHhq4jiAJSjLXWOKLxOm2BdsJ/usIS9Zxsil7hVL2gfa9Sevt0byjxTh675dD
1+9lkM1/bVXksXl2Hi43ZR94dm6kYD4rWhDiYe3Kd9SGLsvtbOKWujm281Kb4zN2
M8mmS/pRVZJcxOZTGnijIQhh5GwT53N0jO+YAW98WOIqIR6D3H2ozhZwp7+2YhzW
H6Pt9qQTiI+TtcNJT9aCtX98KorB2zZayNOhLw67cfjvOS+lp9ryXfqU2pe6JptQ
V7I/FhBJ8iwvxa10iw/j8eCQ9z6WsAOGYTRKFXIb2x0aeP7karw6DQb3uiSU3/zb
FMpI+RfeRTt3vYnYkeZq7FJk1CFQvuPsoigv1K9Eappl8XYaHP4FgF8hpWXTVUTY
RTH8PAzi//d3KIbqMaflxiQuoO8YMqfw7zYVb3QUTlQAc8mw3rj6FHCPnpS2vMGP
qjEYEvvBfzUqipQ/PGFfHc/N/Sci6NoNYRu4kgz/1QZyBWhnfL2x7JWvddZFTDcY
Frqu9MSMUIU7eXLNa0BPmMpyZn8AwviAUpgQH8yVEiZdyzD6d2g=
=IKQQ
-----END PGP SIGNATURE-----

--z5HJNHpVrs9F5Roc--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
