From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-next v3 02/24] IB/uverbs: Introduce and use helper
 functions to copy ah attributes
Date: Mon, 28 Aug 2017 18:55:52 +0300
Message-ID: <20170828155552.GB23726@mtr-leonro.local>
References: <20170817125055.31424-1-leon@kernel.org>
 <20170817125055.31424-3-leon@kernel.org>
 <1503607242.78641.48.camel@redhat.com>
 <20170827111059.GQ1724@mtr-leonro.local>
 <1503933314.78641.82.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="PmA2V3Z32TCmWXqI"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1503933314.78641.82.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--PmA2V3Z32TCmWXqI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 28, 2017 at 11:15:14AM -0400, Doug Ledford wrote:
> On Sun, 2017-08-27 at 14:10 +0300, Leon Romanovsky wrote:
> > On Thu, Aug 24, 2017 at 04:40:42PM -0400, Doug Ledford wrote:
> > > On Thu, 2017-08-17 at 15:50 +0300, Leon Romanovsky wrote:
> > > > From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > >
> > > > This patch introduces two helper functions to copy ah attributes
> > > > from uverbs to internal ib_ah_attr structure and the other way
> > > > during modify qp and query qp respectively.
> > > >
> > > > Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > > Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > > > Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > ---
> > > >  drivers/infiniband/core/uverbs_cmd.c | 124 ++++++++++++++-------
> > > > ----
> > > > ----------
> > > >  1 file changed, 49 insertions(+), 75 deletions(-)
> > >
> > > I had to fix this patch up considerably...
> > >
> > > > diff --git a/drivers/infiniband/core/uverbs_cmd.c
> > > > b/drivers/infiniband/core/uverbs_cmd.c
> > > > index 670176b670a0..515425a50059 100644
> > > > --- a/drivers/infiniband/core/uverbs_cmd.c
> > > > +++ b/drivers/infiniband/core/uverbs_cmd.c
> > > >
> > > > @@ -1936,6 +1926,28 @@ static int modify_qp_mask(enum ib_qp_type
> > > > qp_type, int mask)
> > > >  	}
> > > >  }
> > > >
> > > > +static void copy_ah_attr_from_uverbs(struct ib_device *dev,
>                                              ^^^^^^^^^^^^^^^^^^^^
> From your patch...
>
> > > > +				     struct rdma_ah_attr
> > > > *rdma_attr,
> > > > +				     struct ib_uverbs_qp_dest
> > > >
> > > And we had a fix here where we only copy the ah attributes if the
> > > user
> > > set the flag for it, so what I ended up with looks like this:
> > >
> > >         if (cmd->base.attr_mask & IB_QP_AV)
> > >                 copy_ah_attr_from_uverbs(qp->device, &attr-
> > > >ah_attr,
> > >                                          &cmd->base.dest);
> > >
> > >         if (cmd->base.attr_mask & IB_QP_ALT_PATH)
> > >                 copy_ah_attr_from_uverbs(qp->device, &attr-
> > > > alt_ah_attr,
> > >
> > >                                          &cmd->base.alt_dest);
> >
> > Doug,
> >
> > It should be "qp" and not "qp->device" in copy_ah_attr_from_uverbs().
> >
> > 1998         if (cmd->base.attr_mask & IB_QP_AV)
> > 1999                 copy_ah_attr_from_uverbs(qp, &attr->ah_attr,
> > &cmd->base.dest);
> > 2000         if (cmd->base.attr_mask & IB_QP_ALT_PATH)
> > 2001                 copy_ah_attr_from_uverbs(qp, &attr->alt_ah_attr,
> > 2002                                          &cmd->base.alt_dest);
> > 2003         ret = ib_modify_qp_with_udata(qp, attr,
> > 2004                                       modify_qp_mask(qp-
> > >qp_type,
> > 2005                                                      cmd-
> > >base.attr_mask),
> > 2006                                       udata);
>
> I'm pretty sure you need to re-read your own patch Leon ;-).  The
> helper you added uses struct ib_device, so a pointer to the qp would
> not work.  And it wouldn't have even compiled if I had that wrong.

OK, I reread it and it helped me to find the differences.

In rdma-rc, there is the patch from Noa "IB/core: Avoid accessing
non-allocated memory when inferring port type", which plays exactly at
the same place as this one.

Because, I'm creating my rdma-next for testing, I'm merging -rcX with
-next and my merge conflict resolution was to move
+               attr->ah_attr.type = rdma_ah_find_type(qp->device,
+                                                      cmd->base.dest.port_num);
to the copy_ah_attr_from_uverbs and to change function signature to be
"static void copy_ah_attr_from_uverbs(struct ib_qp *qp,"

Thanks

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--PmA2V3Z32TCmWXqI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmkPQgACgkQ5GN7iDZy
WKekxA/9EXA3x0GIadaKQFKep8B53U3gpDVQJxvWU7wgBZh8DKxSw+otJ7/iVUL7
BF46Iqnbx5WWsVIEZJ7y7G+YBpwgCGEiF0bE+mZxSjs2RWncaoRJAGZDtJeAL2Rc
TxfUWO5Mp+rtPcrIkoGx6YIb8rV+5j7/BswUM0QrYkMfPZ5x5mA2ArrenXACL0L8
Wxzs1isKH7gwQvPh0mww/7n+iqFTFdrdw20zDVtXrD8YAA60Ed7mGPj706bqXDa1
Iytco/uEzZXZ27CSUeQqxLKwWQ3ulMGwOn4ZvSdnGw+nx+SSnG6uQQLvRqv+kiqH
p2NcNCm58xspdnV/m8oRhWYyL8mx/zCSl/7Wz7Nxv2wRZOnwRgI+IZmhGKoSIaH6
ZBVcZcvU675Xq30R8RPdbOOhujsDR0QzNLffmf1cbR8SNHKXXWFEcI5MfUVlothC
qCuOOcAAgarwPaz56J9SB2SsOjru9fnkU+kX0pxYH5rVPgWXtoCQ/M8kQOZK2DmR
WFC1JwGNK8SOGw6epxd2VntXi874c5Xf7jL6HFzPjj0KnGXlnBufjx2UroxMs+Dt
8q8NpKQLHDiA/PI4rE3iKdKBW8kdc8Ib3GKZ7QvfnUiGu8FgTdlKJaaHpoK98Gwx
7zxDyL8hsLG3L14BboK6lLXIzL3ZpD6qEb2LXlo6bY4P4Fmdris=
=TWGA
-----END PGP SIGNATURE-----

--PmA2V3Z32TCmWXqI--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
