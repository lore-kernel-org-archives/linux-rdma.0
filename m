From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-next v3 02/24] IB/uverbs: Introduce and use helper
 functions to copy ah attributes
Date: Mon, 28 Aug 2017 21:09:56 +0300
Message-ID: <20170828180956.GG23726@mtr-leonro.local>
References: <20170817125055.31424-1-leon@kernel.org>
 <20170817125055.31424-3-leon@kernel.org>
 <1503607242.78641.48.camel@redhat.com>
 <20170827111059.GQ1724@mtr-leonro.local>
 <1503933314.78641.82.camel@redhat.com>
 <20170828155552.GB23726@mtr-leonro.local>
 <1503937924.78641.94.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5UGlQXeG3ziZS81+"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1503937924.78641.94.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--5UGlQXeG3ziZS81+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 28, 2017 at 12:32:04PM -0400, Doug Ledford wrote:
> On Mon, 2017-08-28 at 18:55 +0300, Leon Romanovsky wrote:
> > On Mon, Aug 28, 2017 at 11:15:14AM -0400, Doug Ledford wrote:
> > > On Sun, 2017-08-27 at 14:10 +0300, Leon Romanovsky wrote:
> > > > On Thu, Aug 24, 2017 at 04:40:42PM -0400, Doug Ledford wrote:
> > > > > On Thu, 2017-08-17 at 15:50 +0300, Leon Romanovsky wrote:
> > > > > > From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > > > >
> > > > > > This patch introduces two helper functions to copy ah
> > > > > > attributes
> > > > > > from uverbs to internal ib_ah_attr structure and the other
> > > > > > way
> > > > > > during modify qp and query qp respectively.
> > > > > >
> > > > > > Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > > > > Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > > > > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > > > > > Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
> > > > > > >
> > > > > > ---
> > > > > >  drivers/infiniband/core/uverbs_cmd.c | 124 ++++++++++++++---
> > > > > > ----
> > > > > > ----
> > > > > > ----------
> > > > > >  1 file changed, 49 insertions(+), 75 deletions(-)
> > > > >
> > > > > I had to fix this patch up considerably...
> > > > >
> > > > > > diff --git a/drivers/infiniband/core/uverbs_cmd.c
> > > > > > b/drivers/infiniband/core/uverbs_cmd.c
> > > > > > index 670176b670a0..515425a50059 100644
> > > > > > --- a/drivers/infiniband/core/uverbs_cmd.c
> > > > > > +++ b/drivers/infiniband/core/uverbs_cmd.c
> > > > > >
> > > > > > @@ -1936,6 +1926,28 @@ static int modify_qp_mask(enum
> > > > > > ib_qp_type
> > > > > > qp_type, int mask)
> > > > > >  	}
> > > > > >  }
> > > > > >
> > > > > > +static void copy_ah_attr_from_uverbs(struct ib_device *dev,
> > >
> > >                                              ^^^^^^^^^^^^^^^^^^^^
> > > From your patch...
> > >
> > > > > > +				     struct rdma_ah_attr
> > > > > > *rdma_attr,
> > > > > > +				     struct
> > > > > > ib_uverbs_qp_dest
> > > > > >
> > > > >
> > > > > And we had a fix here where we only copy the ah attributes if
> > > > > the
> > > > > user
> > > > > set the flag for it, so what I ended up with looks like this:
> > > > >
> > > > >         if (cmd->base.attr_mask & IB_QP_AV)
> > > > >                 copy_ah_attr_from_uverbs(qp->device, &attr-
> > > > > > ah_attr,
> > > > >
> > > > >                                          &cmd->base.dest);
> > > > >
> > > > >         if (cmd->base.attr_mask & IB_QP_ALT_PATH)
> > > > >                 copy_ah_attr_from_uverbs(qp->device, &attr-
> > > > > > alt_ah_attr,
> > > > >
> > > > >                                          &cmd->base.alt_dest);
> > > >
> > > > Doug,
> > > >
> > > > It should be "qp" and not "qp->device" in
> > > > copy_ah_attr_from_uverbs().
> > > >
> > > > 1998         if (cmd->base.attr_mask & IB_QP_AV)
> > > > 1999                 copy_ah_attr_from_uverbs(qp, &attr->ah_attr,
> > > > &cmd->base.dest);
> > > > 2000         if (cmd->base.attr_mask & IB_QP_ALT_PATH)
> > > > 2001                 copy_ah_attr_from_uverbs(qp, &attr-
> > > > >alt_ah_attr,
> > > > 2002                                          &cmd-
> > > > >base.alt_dest);
> > > > 2003         ret = ib_modify_qp_with_udata(qp, attr,
> > > > 2004                                       modify_qp_mask(qp-
> > > > > qp_type,
> > > >
> > > > 2005                                                      cmd-
> > > > > base.attr_mask),
> > > >
> > > > 2006                                       udata);
> > >
> > > I'm pretty sure you need to re-read your own patch Leon ;-).  The
> > > helper you added uses struct ib_device, so a pointer to the qp
> > > would
> > > not work.  And it wouldn't have even compiled if I had that wrong.
> >
> > OK, I reread it and it helped me to find the differences.
> >
> > In rdma-rc, there is the patch from Noa "IB/core: Avoid accessing
> > non-allocated memory when inferring port type", which plays exactly
> > at
> > the same place as this one.
> >
> > Because, I'm creating my rdma-next for testing, I'm merging -rcX with
> > -next and my merge conflict resolution was to move
> > +               attr->ah_attr.type = rdma_ah_find_type(qp->device,
> > +                                                      cmd-
> > >base.dest.port_num);
> > to the copy_ah_attr_from_uverbs and to change function signature to
> > be
> > "static void copy_ah_attr_from_uverbs(struct ib_qp *qp,"
>
> It turns out this is kind of a moot point.  In uverbs_marshall.c there
> already exists void ib_copy_ah_attr_to_user().  We should have used
> that instead of creating new versions of this in this file.

I don't see clean way to reuse those functions.

The ib_copy_qp_attr_to_user has second parameter of "struct
ib_uverbs_qp_attr", while ib_uverbs_query_qp returns results in "struct
ib_uverbs_query_qp_resp" and operates on it.

Thanks

--5UGlQXeG3ziZS81+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmkXHQACgkQ5GN7iDZy
WKdkqA//VNTwlVQFedZiwGGbQPAgcMm+mOEy89zsInn3dmMDaISfWg05IkUyf1LG
fLNK6HQwxU+sEvAvbhVGHdJDlm0f0mq8An0HCeO5QE5f1qK+Ok8ZEyWcaCxEKunX
2jD8v3F3Ab+NW1tff25t5Vs+BLcjwVZ/8jsldln2lIlhHTIb6qRbBtQb+R0Fu+ve
Aw5yGAB5tYeDdepVwjp0AzEomEFfzxedpog5LgGdNdblmAmhExYkNV1WGZWkeDF/
Zs64BiSEKZCYKvYc7l1/a0Sofh9F9TCDZ6v7XNg4Mya5n95p2nGN1yEGB1xEbJar
k5frKSwRUrRP/a/kU2D1JJxBCySCvG+dg9v0y9j8dYdNU7GYLdl/2nZKMNxhp7Ww
L2jHjFFcS8CqSzVSkWIJOQcxL795FnIFttjBy3npSEVdIz5Zd2WcdMOxLwdqZdeZ
ZoHbduKqyV4Ln/IcGtRshY+ICEIO1PHoivcZJbM8jJkaQ3cvyXEBE+2MJmmS6CWx
Umhik6aAJupzRTtGEjNxnIkS1p5L9S6LZkmKzyrYnsSNyUK9jyWKOPQ8Vg2dbmnw
y5gRKLEwmxewC5udHW2t0tvC4cq6dWNv3JhLtU/QfKzIvM7duGfbBBvBgk+ikV0H
pCOIRAaVt7/ge9QdhkmQpkuAa4jPwfU5VjYZfFZQzxZP2wDN84I=
=/4/8
-----END PGP SIGNATURE-----

--5UGlQXeG3ziZS81+--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
