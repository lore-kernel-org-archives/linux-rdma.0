From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1,IB/qib: Fix qp_stats sleep with rcu read lock
 held
Date: Wed, 10 Aug 2016 11:24:27 +0300
Message-ID: <20160810082427.GI23921@leon.nu>
References: <1470755786-14054-1-git-send-email-ira.weiny@intel.com>
 <20160809181146.GE23921@leon.nu>
 <20160810055151.GB32695@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Encpt1P6Mxii2VuT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160810055151.GB32695-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Encpt1P6Mxii2VuT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 10, 2016 at 01:51:52AM -0400, ira.weiny wrote:
> On Tue, Aug 09, 2016 at 09:11:46PM +0300, Leon Romanovsky wrote:
> > On Tue, Aug 09, 2016 at 11:16:26AM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > > From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > >=20
>=20
> [snip]
>=20
> > > diff --git a/drivers/infiniband/hw/hfi1/debugfs.c b/drivers/infiniban=
d/hw/hfi1/debugfs.c
> > > index dbab9d9cc288..c35bef8dd5aa 100644
> > > --- a/drivers/infiniband/hw/hfi1/debugfs.c
> > > +++ b/drivers/infiniband/hw/hfi1/debugfs.c
> > > @@ -223,28 +223,35 @@ DEBUGFS_SEQ_FILE_OPEN(ctx_stats)
> > >  DEBUGFS_FILE_OPS(ctx_stats);
> > > =20
> > >  static void *_qp_stats_seq_start(struct seq_file *s, loff_t *pos)
> > > -__acquires(RCU)
> > > +	__acquires(RCU)
> > >  {
> > >  	struct qp_iter *iter;
> > >  	loff_t n =3D *pos;
> > > =20
> > > -	rcu_read_lock();
> > >  	iter =3D qp_iter_init(s->private);
> > > +
> > > +	/* stop calls rcu_read_unlock */
> > > +	rcu_read_lock();
> >=20
> > IMHO, it should be placed after your if(!iter) check below.
>=20
> I know this seems weird but this makes the rcu locking "balanced".  Retur=
ning
> NULL here still calls "stop" which is going to call rcu_read_unlock.  If =
we
> move rcu_read_lock we need to maintain state to determine if we called lo=
ck or
> not.  This is easier.  To me it does seem odd that the sequence operation=
 does
> not stop on its own when NULL is returned but that is the way it works.

Thanks for the explanation.

>=20
> >=20
> > > +
> > >  	if (!iter)
> > >  		return NULL;
> > > =20
> > > -	while (n--) {
> > > +	if (qp_iter_next(iter)) {
> > > +		kfree(iter);
> > > +		return NULL;
> > > +	}
> > > +	while (n--)
> > >  		if (qp_iter_next(iter)) {
> > >  			kfree(iter);
> > >  			return NULL;
> > >  		}
> >=20
> > It looks like you forgot to remove the lines above.
>=20
> Nope this replaces a call to qp_iter_next which was in qp_iter_init.
>=20
> As the commit messages says we move the implict next's back into the resp=
ective
> start functions.

Did you consider as an option to use do{...}while(...) construction
instead of this duplicated code?

--Encpt1P6Mxii2VuT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXquS7AAoJEORje4g2clin92cP/3jyrJslO79po18kbcdUU6Fk
xwDn1YyPeWXudaBFt0p0zcH7JpY1AC/ibnBN6KnwOCoHUEph2x7vvIy1hxnrOUcE
QgQ1TmWupjQ4rgftSWQ1iwYs3snyG1Palrr6VLHDhB60MjxvPTpiT0UKIVIh/yxu
lhShvtGW/CXdpdYmT0P1TLTcHfk1vy7ONBXOxNDCvVaAr/1dCaF0oB6PDgqwLzVp
ZcqAd72CZQKUgqlRCKr3HGB0aRPK9I2KN0EGocWD/sfGT6VIzUIvZYjLFKxYzokg
S7bHOBDdGKOWPhkdXqpyZtz20kwGdpTE5JdpGHUf+GxW6h+O5aiOciZpXxKuUEZh
7ZiGNEDyJjsE67ohGmQRj6XGHsdxKYAWE3A1lTSl+m4oLFJ9YFg58EsmbzXllRE8
gfUA5JOCMSqQ/cuP6VQQJxfELk2XFNtZxfBuseka94bhoS0K2mjHcXfazmq4c7rx
M/q/kjGq+9TpX+iUDDusB61UgMDrrF8f160ppcc3KdXm3hqRzryyMebejVZxnqNG
PlqSq7ujDzDHviLyZz+muwWTTf4l0OcGhjOcjPXcN3GR2rGr15Y3/RZ5XEqMvoTU
5i/XuGB5qUJLRR82dzCrdzlYEk8m1g/G8/PhcQnfxYKpy5xudH06Ef2/UAPKlxDT
Tv5MLxgmY9EhpvWGYUcG
=waeZ
-----END PGP SIGNATURE-----

--Encpt1P6Mxii2VuT--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
