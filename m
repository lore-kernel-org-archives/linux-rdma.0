From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] iw_cxgb4: Use dsgl by default
Date: Thu, 2 Mar 2017 17:19:27 +0200
Message-ID: <20170302151927.GE14379@mtr-leonro.local>
References: <1487833303-4779-1-git-send-email-ganeshgr@chelsio.com>
 <20170302144710.GF9525@mtr-leonro.local>
 <039001d29365$fbaf37f0$f30da7d0$@opengridcomputing.com>
 <20170302151122.GC14379@mtr-leonro.local>
 <03fb01d29367$d0cdd2b0$72697810$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="LSp5EJdfMPwZcMS1"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <03fb01d29367$d0cdd2b0$72697810$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Ganesh Goudar' <ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, indranil-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, 'Bharat Potnuri' <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--LSp5EJdfMPwZcMS1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 02, 2017 at 09:15:24AM -0600, Steve Wise wrote:
> > On Thu, Mar 02, 2017 at 09:02:17AM -0600, Steve Wise wrote:
> > > >
> > > > On Thu, Feb 23, 2017 at 12:31:43PM +0530, Ganesh Goudar wrote:
> > > > > Enable the use of dsgl by default and determine whether dsgl is
> > > > > supported from lld info.
> > > > >
> > > > > Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> > > > > Signed-off-by: Bharat Potnuri <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> > > > > Signed-off-by: Ganesh Goudar <ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> > > > > ---
> > > > >  drivers/infiniband/hw/cxgb4/mem.c | 6 +++---
> > > > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > > >
> > > > > diff --git a/drivers/infiniband/hw/cxgb4/mem.c
> > > > b/drivers/infiniband/hw/cxgb4/mem.c
> > > > > index 410408f..8db7a11 100644
> > > > > --- a/drivers/infiniband/hw/cxgb4/mem.c
> > > > > +++ b/drivers/infiniband/hw/cxgb4/mem.c
> > > > > @@ -38,9 +38,9 @@
> > > > >
> > > > >  #include "iw_cxgb4.h"
> > > > >
> > > > > -int use_dsgl = 0;
> > > > > +int use_dsgl = 1;
> > > > >  module_param(use_dsgl, int, 0644);
> > > > > -MODULE_PARM_DESC(use_dsgl, "Use DSGL for PBL/FastReg (default=0)");
> > > > > +MODULE_PARM_DESC(use_dsgl, "Use DSGL for PBL/FastReg (default=1)");
> > > >
> > > > Can we get rid of this module parameter completely?
> > >
> > > We can, but we would need to deprecate it for a release or two.  I believe
> > > removing them cold-turkey isn't recommended because it represents a form of
> > user
> > > interface...
> >
> > You can rename it to be deprecated_use_dsgl instead of use_dsgl and wait
> > for a couple of years to see if someone complains.
> >
>
> I think for cxgb4 module options, we just add "DEPRECATED" to the description
> for a few releases, then remove it.

Sounds great.

>
>

--LSp5EJdfMPwZcMS1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAli4N/8ACgkQ5GN7iDZy
WKcJ8g//WSpWDo9hpOR50Y3AjFnagPC8/NEn9a1Ax4XtHJrjLME833lkKwTi+oOE
D2cH3kdXmyXO3b/NV1hczOuJG15KOjRHM//ut6iB/hoVyG9iqV1EuestMWe4blEG
jFCNVgI6zR6TE7StX2HAAxoAToboakZwRgcOsvzs2LxR9wnShtjyKVc4jOGTojZL
cJZD2+4uDsBLzwYD3UnIexPdmiAVbYqefIoarTryU/yLpBbDL36r8Ei5y7UGHeY6
KrEoPVk7cKM0EwLKjgf7tVGAr0qOlODuKGdSlkP1NBd8Bnixk0IlW6AD02ZPc79/
I+9+BmVjC2F0/5IK3h+y8YHzJXsCVoT2GA6GgwFYYcVXpDUZYHjPdRh656JIDPht
oqGV5smoS+yLrydSJf5P4kzYK4s7rS+bxnq7S7hJ2CIicNnhYhpkzRh5cxXhMuTr
JNhO5DQaShdIcW6EHwKEO8N3OZHXNvOmCPp+jkXos02I1Hj5E/YmUGYNhGVL2Xa9
VZ0PuMaWQaLGNDKGNssj8AU94Mda9UZ+LeUGM+K7UNT1fn+i+iCEssBQvcsDeesz
Wt6HeZoiLoJr78LCS5NPBQGCTK9V1GU7x6Y718iwEuGcPOg7e3fKCom2Izn8OyHw
MZ79j1V7+NOAQQ1nZLazy6aMe4ZizE1gDEnCE1JEbT5AfOJCWQI=
=lF8A
-----END PGP SIGNATURE-----

--LSp5EJdfMPwZcMS1--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
