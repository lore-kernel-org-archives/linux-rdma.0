From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1,IB/qib: Fix qp_stats sleep with rcu read lock
 held
Date: Wed, 10 Aug 2016 13:17:50 +0300
Message-ID: <20160810101750.GJ23921@leon.nu>
References: <1470755786-14054-1-git-send-email-ira.weiny@intel.com>
 <20160809181146.GE23921@leon.nu>
 <20160810055151.GB32695@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ed/6oDxOLijJh8b0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160810055151.GB32695-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--ed/6oDxOLijJh8b0
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

Did you consider to use do{..}while(..) construction instead of
duplicating code?

--ed/6oDxOLijJh8b0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXqv9OAAoJEORje4g2clinkosQAMTyu+R0zld3tQIUiI11Ufz+
0kI6yc8EszNOASNXpXWjjkZ1DzH0+UmOaulcgHsSSS1OuZeHLlwAzMcH/NceWpmS
ywFeFjnSLFdns8Rdw7JEGDIMlMV1UANBxNC+l8AcLdOJmXpLzwr82t7XEzGZak5q
RL1yV+ESBscRvDftCo+KU+BJRaysWR/PIx9YH3xkB1kgMF+YF9wWOApLzpdTDTAo
VGBkEu//C8AuFCPg/Qwv5emCpDa2nSYziEgHD4OsBRK8htaFlh7UCIGib1SbDMFs
QtEcNiu2vKkeVubzD7JsOrQD0LX1goBZI/3wl7lF5D1Ak54HKi+pFVRpV3yYwJYF
O5F9bmrsHlXeZAKYrYpqWGsCZBeI8OgvXPoclCe7yF5588g+WGnR9pKdldtxmXFZ
gt1TcNOVMrYGs+mm9yAGDFR+PRFS4v8U5FuVodWKq/WMTYdB3SQnVpg98wBqw186
yp4yiq76Yur++SNtGvkAQJ8K2ZlFJbxUQZOo9R/claFAEYu1A69JfAgi8o+ABECQ
0rKK8DSCwI9b7O5MhNDFJuY7Kk9rUbGyImF0E2s7M3LBn8R4L1+YCNwolDdz3Dk9
B7LZadh8FtbBAMbZX3sK8F4IFpixi9yh6K3sQjwhMBsLgrF8oIfbFFl4N5G2qfDh
TlZF0tUmi0Q41BgG10nn
=C7HF
-----END PGP SIGNATURE-----

--ed/6oDxOLijJh8b0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
