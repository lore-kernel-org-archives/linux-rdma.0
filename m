From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-4.1 2/2] iw_cxgb4: support for bar2 qid densities
 exceeding the page size
Date: Tue, 09 Jun 2015 10:16:03 -0400
Message-ID: <1433859363.90034.19.camel@redhat.com>
References: <1433854392-6531-1-git-send-email-hariprasad@chelsio.com>
		 <1433854392-6531-3-git-send-email-hariprasad@chelsio.com>
	 <1433858594.90034.14.camel@redhat.com>
	 <002301d0a2bd$9aef5840$d0ce08c0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-oRvRlm9mK7y0dMsKJJW+"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <002301d0a2bd$9aef5840$d0ce08c0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Hariprasad Shenai' <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-oRvRlm9mK7y0dMsKJJW+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-06-09 at 09:07 -0500, Steve Wise wrote:
>=20
> > -----Original Message-----
> > From: Doug Ledford [mailto:dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
> > Sent: Tuesday, June 09, 2015 9:03 AM
> > To: Hariprasad Shenai
> > Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org; leedom@che=
lsio.com; nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
> > Subject: Re: [PATCH for-4.1 2/2] iw_cxgb4: support for bar2 qid densiti=
es exceeding the page size
> >=20
> > On Tue, 2015-06-09 at 18:23 +0530, Hariprasad Shenai wrote:
> > > Handle this configuration:
> > >
> > >         Queues Per Page * SGE BAR2 Queue Register Area Size > Page Si=
ze
> > >
> > > Use cxgb4_bar2_sge_qregs() to obtain the proper location within the
> > > bar2 region for a given qid.
> > >
> > > Rework the DB and GTS write functions to make use of this bar2 info.
> > >
> > > Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> > > Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> > > ---
> > >  drivers/infiniband/hw/cxgb4/cq.c       | 22 ++++++------
> > >  drivers/infiniband/hw/cxgb4/device.c   | 16 +++------
> > >  drivers/infiniband/hw/cxgb4/iw_cxgb4.h |  5 +--
> > >  drivers/infiniband/hw/cxgb4/qp.c       | 64 ++++++++++++++++++++++--=
----------
> > >  drivers/infiniband/hw/cxgb4/t4.h       | 60 ++++++++++++++++++++----=
-------
> > >  5 files changed, 98 insertions(+), 69 deletions(-)
> > >
> > > diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw=
/cxgb4/cq.c
> > > index 68ddb37..8e5bbcb 100644
> > > --- a/drivers/infiniband/hw/cxgb4/cq.c
> > > +++ b/drivers/infiniband/hw/cxgb4/cq.c
> > > @@ -156,19 +156,17 @@ static int create_cq(struct c4iw_rdev *rdev, st=
ruct t4_cq *cq,
> > >  		goto err4;
> > >
> > >  	cq->gen =3D 1;
> > > +	cq->gts =3D rdev->lldi.gts_reg;
> > >  	cq->rdev =3D rdev;
> > > -	if (user) {
> > > -		u32 off =3D (cq->cqid << rdev->cqshift) & PAGE_MASK;
> > >
> > > -		cq->ugts =3D (u64)rdev->bar2_pa + off;
> > > -	} else if (is_t4(rdev->lldi.adapter_type)) {
> > > -		cq->gts =3D rdev->lldi.gts_reg;
> > > -		cq->qid_mask =3D -1U;
> > > -	} else {
> > > -		u32 off =3D ((cq->cqid << rdev->cqshift) & PAGE_MASK) + 12;
> > > -
> > > -		cq->gts =3D rdev->bar2_kva + off;
> > > -		cq->qid_mask =3D rdev->qpmask;
> > > +	cq->bar2_va =3D c4iw_bar2_addrs(rdev, cq->cqid, T4_BAR2_QTYPE_INGRE=
SS,
> > > +				      &cq->bar2_qid,
> > > +				      user ? &cq->bar2_pa : NULL);
> > > +	if (user && !cq->bar2_va) {
> > > +		pr_warn(MOD "%s: cqid %u not in BAR2 range.\n",
> > > +			pci_name(rdev->lldi.pdev), cq->cqid);
> > > +		ret =3D -EINVAL;
> > > +		goto err4;
> > >  	}
> > >  	return 0;
> > >  err4:
> > > @@ -971,7 +969,7 @@ struct ib_cq *c4iw_create_cq(struct ib_device *ib=
dev, int entries,
> > >  		insert_mmap(ucontext, mm);
> > >
> > >  		mm2->key =3D uresp.gts_key;
> > > -		mm2->addr =3D chp->cq.ugts;
> > > +		mm2->addr =3D (u64)(uintptr_t)chp->cq.bar2_pa;
> >=20
> > Why are you using a cast here at all?  bar2_pa is already u64...
> >=20
>=20
> So it should just have the (uintptr_t) cast?

No, it should be no cast at all.  The uintptr_t cast is only for casting
an int->ptr or ptr->int.  In those cases, if the size of an int !=3D size
of ptr, you can loose data, and uintptr_t tells the compiler "I know I'm
casting between possibly lossy data sizes and either A) I've checked and
it's OK or B) I'm ok with ptr truncation and the loss won't hurt us".
It basically turns off size checks when sticking a ptr into an int.  You
should therefore use it only in those circumstances.  For example, when
storing a cookie that doesn't have a strict uniqueness requirement, the
loss due to truncation is probably OK.  Or if you know you are only
doing something like initially storing an int into a pointer, and then
later storing that pointer back into an int, so there can never be any
truncation because the source of the ptr was always int sized.  Those
are the times to use uintptr.  In this case, you have a real u64 going
into a real u64, there should be no casts.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-oRvRlm9mK7y0dMsKJJW+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVdvUjAAoJELgmozMOVy/dIaoP/0k3MFHfzBeAD6uc8opTLpNN
ZK657cLjFM2kMGOA2JZ4dXPQasIvRwaVc38jinbAzS/j6Dx2JmjrZ07HZDwZhR+q
LDYE0bC1yfObEcAUur5SWAVpGmgdIp+eVU9j4saeIT6e0+HJBMcTvb8iaXd0VxP8
zgvZSAdgvOCkBOsm7bc7cj+F1SptuGqlBYgbZ3XBvVbe6l5t9jtIdm/fJLqcPgs7
TF8glfjUwBtHOxE1v6UFSSXDNAtXSXzraLj1Bmro9iRiY1OoZfRCxa3ZNTIMiHJO
PrDU7CUNk/rKsTnJVuJjhyHjlB5PQ3dhjXeSxl7MAPl7pj6yo1e/gDqKouZ3FS0e
HNETkO8+U6rqaZJ0IqUdI30eySQErXhUZVGfMkXVRw7CaOotNpDbOOOsEUGplTVl
uLisqhEVLAyOKsydW+vBl08Xu6DXxdJunBGvIfgiCw7EiTUW6jlPvRD2f6ybCJ/F
6q9qLwlRCxDBpU35vIv5IphFdKbmT2wF1rP8FwlkCZoFb3nxs9NYq8A/m38sNCzE
DLFXZ7UVhV91poXTntH1C+6cabyotSS0BkCczycrs1N5j0kbxiLAlg0mh9b4kRlg
TfES55hGfjbLOiweFxkRI91EOANWJQiYa0IJ0WAeJjdKebU8G2FP+ke7hVIoLFC8
OGPu943WYSEEc7DOemRX
=uqVp
-----END PGP SIGNATURE-----

--=-oRvRlm9mK7y0dMsKJJW+--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
