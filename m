From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-next v3 02/24] IB/uverbs: Introduce and use helper
 functions to copy ah attributes
Date: Mon, 28 Aug 2017 20:24:55 +0300
Message-ID: <20170828172455.GF23726@mtr-leonro.local>
References: <20170817125055.31424-1-leon@kernel.org>
 <20170817125055.31424-3-leon@kernel.org>
 <1503607242.78641.48.camel@redhat.com>
 <20170827111059.GQ1724@mtr-leonro.local>
 <1503933314.78641.82.camel@redhat.com>
 <20170828155552.GB23726@mtr-leonro.local>
 <1503937924.78641.94.camel@redhat.com>
 <20170828172026.GE23726@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Zs/RYxT/hKAHzkfQ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170828172026.GE23726-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Zs/RYxT/hKAHzkfQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 28, 2017 at 08:20:26PM +0300, Leon Romanovsky wrote:
> On Mon, Aug 28, 2017 at 12:32:04PM -0400, Doug Ledford wrote:
> > On Mon, 2017-08-28 at 18:55 +0300, Leon Romanovsky wrote:
> > > On Mon, Aug 28, 2017 at 11:15:14AM -0400, Doug Ledford wrote:
> > > > On Sun, 2017-08-27 at 14:10 +0300, Leon Romanovsky wrote:
> > > > > On Thu, Aug 24, 2017 at 04:40:42PM -0400, Doug Ledford wrote:
> > > > > > On Thu, 2017-08-17 at 15:50 +0300, Leon Romanovsky wrote:
> > > > > > > From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > > > > >
> > > > > > > This patch introduces two helper functions to copy ah
> > > > > > > attributes
> > > > > > > from uverbs to internal ib_ah_attr structure and the other
> > > > > > > way
> > > > > > > during modify qp and query qp respectively.
> > > > > > >
> > > > > > > Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > > > > > Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > > > > > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > > > > > > Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
> > > > > > > >
> > > > > > > ---
> > > > > > >  drivers/infiniband/core/uverbs_cmd.c | 124 ++++++++++++++---
> > > > > > > ----
> > > > > > > ----
> > > > > > > ----------
> > > > > > >  1 file changed, 49 insertions(+), 75 deletions(-)
> > > > > >
> > > > > > I had to fix this patch up considerably...
> > > > > >
> > > > > > > diff --git a/drivers/infiniband/core/uverbs_cmd.c
> > > > > > > b/drivers/infiniband/core/uverbs_cmd.c
> > > > > > > index 670176b670a0..515425a50059 100644
> > > > > > > --- a/drivers/infiniband/core/uverbs_cmd.c
> > > > > > > +++ b/drivers/infiniband/core/uverbs_cmd.c
> > > > > > >
> > > > > > > @@ -1936,6 +1926,28 @@ static int modify_qp_mask(enum
> > > > > > > ib_qp_type
> > > > > > > qp_type, int mask)
> > > > > > >  	}
> > > > > > >  }
> > > > > > >
> > > > > > > +static void copy_ah_attr_from_uverbs(struct ib_device *dev,
> > > >
> > > >                                              ^^^^^^^^^^^^^^^^^^^^
> > > > From your patch...
> > > >
> > > > > > > +				     struct rdma_ah_attr
> > > > > > > *rdma_attr,
> > > > > > > +				     struct
> > > > > > > ib_uverbs_qp_dest
> > > > > > >
> > > > > >
> > > > > > And we had a fix here where we only copy the ah attributes if
> > > > > > the
> > > > > > user
> > > > > > set the flag for it, so what I ended up with looks like this:
> > > > > >
> > > > > >         if (cmd->base.attr_mask & IB_QP_AV)
> > > > > >                 copy_ah_attr_from_uverbs(qp->device, &attr-
> > > > > > > ah_attr,
> > > > > >
> > > > > >                                          &cmd->base.dest);
> > > > > >
> > > > > >         if (cmd->base.attr_mask & IB_QP_ALT_PATH)
> > > > > >                 copy_ah_attr_from_uverbs(qp->device, &attr-
> > > > > > > alt_ah_attr,
> > > > > >
> > > > > >                                          &cmd->base.alt_dest);
> > > > >
> > > > > Doug,
> > > > >
> > > > > It should be "qp" and not "qp->device" in
> > > > > copy_ah_attr_from_uverbs().
> > > > >
> > > > > 1998         if (cmd->base.attr_mask & IB_QP_AV)
> > > > > 1999                 copy_ah_attr_from_uverbs(qp, &attr->ah_attr,
> > > > > &cmd->base.dest);
> > > > > 2000         if (cmd->base.attr_mask & IB_QP_ALT_PATH)
> > > > > 2001                 copy_ah_attr_from_uverbs(qp, &attr-
> > > > > >alt_ah_attr,
> > > > > 2002                                          &cmd-
> > > > > >base.alt_dest);
> > > > > 2003         ret = ib_modify_qp_with_udata(qp, attr,
> > > > > 2004                                       modify_qp_mask(qp-
> > > > > > qp_type,
> > > > >
> > > > > 2005                                                      cmd-
> > > > > > base.attr_mask),
> > > > >
> > > > > 2006                                       udata);
> > > >
> > > > I'm pretty sure you need to re-read your own patch Leon ;-).  The
> > > > helper you added uses struct ib_device, so a pointer to the qp
> > > > would
> > > > not work.  And it wouldn't have even compiled if I had that wrong.
> > >
> > > OK, I reread it and it helped me to find the differences.
> > >
> > > In rdma-rc, there is the patch from Noa "IB/core: Avoid accessing
> > > non-allocated memory when inferring port type", which plays exactly
> > > at
> > > the same place as this one.
> > >
> > > Because, I'm creating my rdma-next for testing, I'm merging -rcX with
> > > -next and my merge conflict resolution was to move
> > > +               attr->ah_attr.type = rdma_ah_find_type(qp->device,
> > > +                                                      cmd-
> > > >base.dest.port_num);
> > > to the copy_ah_attr_from_uverbs and to change function signature to
> > > be
> > > "static void copy_ah_attr_from_uverbs(struct ib_qp *qp,"
> >
> > It turns out this is kind of a moot point.  In uverbs_marshall.c there
> > already exists void ib_copy_ah_attr_to_user().  We should have used
> > that instead of creating new versions of this in this file.  So, since
> > I've already taken this patch and pushed it to k.o, please do a new
> > incremental patch that:
> >
> > 1) Merges the differences between the static versions of this routine
> > and the one in uverbs_marshall.c into the one in uverbs_marshall.c
> > 2) Adds a copy from uverbs in uverbs_marshall.c that is coded in the
> > same style as the one already there
> > 3) Converts uverbs_cmd.c routines to use the helpers in
> > uverbs_marshall.c and removes the duplicate helpers in uverbs_cmd.c.
> >
> > And, if at all possible, I need it quick because I'm making my pull
> > request to Linus for the next merge window tomorrow.
>
> On which branch do you want me to do it?
> The k.o/for-next doesn't have if(..) copy_.. parts.

Ahh, I found it in k.o/for-next.

>
> Thanks
>
> >
> > --
> > Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >     GPG KeyID: B826A3330E572FDD
> >     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
> >



--Zs/RYxT/hKAHzkfQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmkUecACgkQ5GN7iDZy
WKfndw//Sqv7ayCnpzhO7yQskDy0vt+v0OVd1W0ueYbx1E/yGgli0Bf6oDC3taU3
4onwW/hjEq0LgNdjZN5h3bUVMw8bi24hqcJMk/r5uRp3ZI9GcVOBhf3sesAnPniS
EFsklfEmdrNJqG83KOhTvfDAkCbtmUm/NOutrCkpaYiAAK+7p0knZgLgUaiZh7qo
M9n0Urwi/wfbrHLiepv1rrOVDUQYILLWiJsodORpsVvq1Ns0SWX8rIVp2Czmy3rU
++ZR7x/G7Ms9aJrsplGsx5ieWypjlMUtesVa6qCzVd1G139t32Dvi/U+AivwYX6i
jgrYCnlEsDGG725dtFiraqmygffS9cqEeXMep2edh1DoFormriHIlyvbcZyjM+X5
3Gv1zpMscvzIuXIPC7ZGnwBxDo8BlmeF+aqG1D7PVfuLkkXBhNVBJY03vFdVnHiS
B82evVGCKBUGRJChHLddaE36M1lGJnJF/oObx0vOu//oYGPeLlGQDuGlJE1EhDxr
JTnCfFEE9ZoxpsWDQzOdrTLkmwfZGJU0ojERJooYVhFKXAqdieIIzy1vpHlfuKOp
dvNWDfiVnaXIzYrSFdn7WV0nhZs13zp6b8HAQxt+ASMZKQdy+54EPubMII6nH9gq
SHSy6Uwekwy26bzD6f6XfsV9f9nLpzdoGnxRwdxz0mah88Gkaa8=
=Lz6Z
-----END PGP SIGNATURE-----

--Zs/RYxT/hKAHzkfQ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
