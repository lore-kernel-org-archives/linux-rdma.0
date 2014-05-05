From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/4] RDMA/cxgb4: add missing padding at end of struct
 c4iw_alloc_ucontext_resp
Date: Mon, 05 May 2014 18:59:19 +0200
Message-ID: <1399309159.2957.19.camel@localhost.localdomain>
References: <cover.1399216475.git.ydroneaud@opteya.com>
	 <2236129ab4aa1ad1562858f363fb6fef0d6bc93b.1399216475.git.ydroneaud@opteya.com>
	 <005401cf6873$9216f6e0$b644e4a0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <005401cf6873$9216f6e0$b644e4a0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Steve Wise' <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: 'Roland Dreier' <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le lundi 05 mai 2014 =C3=A0 10:06 -0500, Steve Wise a =C3=A9crit :
> <snip>
>=20
> > diff --git a/drivers/infiniband/hw/cxgb4/provider.c
> b/drivers/infiniband/hw/cxgb4/provider.c
> > index a94a3e12c349..9ba01d524f51 100644
> > --- a/drivers/infiniband/hw/cxgb4/provider.c
> > +++ b/drivers/infiniband/hw/cxgb4/provider.c
> > @@ -122,7 +122,7 @@ static struct ib_ucontext *c4iw_alloc_ucontext(=
struct ib_device
> *ibdev,
> >  	INIT_LIST_HEAD(&context->mmaps);
> >  	spin_lock_init(&context->mmap_lock);
> >=20
> > -	if (udata->outlen < sizeof(uresp)) {
> > +	if (udata->outlen < sizeof(uresp) - sizeof(uresp.reserved)) {
> >  		if (!warned++)
> >  			pr_err(MOD "Warning - downlevel libcxgb4 (non-fatal), device
> status
> > page disabled.");
> >  		rhp->rdev.flags |=3D T4_STATUS_PAGE_DISABLED;
> > @@ -134,13 +134,13 @@ static struct ib_ucontext *c4iw_alloc_ucontex=
t(struct ib_device
> > *ibdev,
> >  		}
> >=20
> >  		uresp.status_page_size =3D PAGE_SIZE;
> >=20
> >  		spin_lock(&context->mmap_lock);
> >  		uresp.status_page_key =3D context->key;
> >  		context->key +=3D PAGE_SIZE;
> >  		spin_unlock(&context->mmap_lock);
> >=20
> > -		ret =3D ib_copy_to_udata(udata, &uresp, sizeof(uresp));
> > +		ret =3D ib_copy_to_udata(udata, &uresp, sizeof(uresp) -
> sizeof(uresp.reserved));
> >  		if (ret)
> >  			goto err_mm;
> >=20
>=20
> This chunk doesn't apply.  Not sure why.  I can use -F 6 with patch, =
but it should apply
> cleanly. Can you please respin this against 89ca3b8 Linux 3.15-rc4?
>=20

I've hand-edited it before sending, but I've tested it with git am
against linux-next (as of today).

Anyway, I'm rolling an updated patchset. Sorry for the inconvenience.

> I'll test the cxgb4 stuff today.=20
>=20

Thanks.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
