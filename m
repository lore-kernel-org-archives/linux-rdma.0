From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] i40iw: Set 128B as the only supported RQ WQE size
Date: Tue, 20 Dec 2016 22:02:39 +0200
Message-ID: <20161220200239.GA1074@mtr-leonro.local>
References: <20161219203227.86392-1-henry.orosco@intel.com>
 <20161220112417.GV1074@mtr-leonro.local>
 <748B799B6A00724488C603FD7E5E7EB94CBAEEA0@FMSMSX114.amr.corp.intel.com>
 <20161220134203.GW1074@mtr-leonro.local>
 <748B799B6A00724488C603FD7E5E7EB94CBAFBBC@FMSMSX114.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="MHoG8na4IvP3G3ze"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <748B799B6A00724488C603FD7E5E7EB94CBAFBBC-XfjTATA9Em864kNsxIetb7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Orosco, Henry" <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--MHoG8na4IvP3G3ze
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 20, 2016 at 02:46:30PM +0000, Tung, Chien Tin wrote:
>
>
> > -----Original Message-----
> > From: Leon Romanovsky [mailto:leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org]
> > Sent: Tuesday, December 20, 2016 7:42 AM
> > To: Tung, Chien Tin <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Cc: Orosco, Henry <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org;
> > linux- rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> > Subject: Re: [PATCH] i40iw: Set 128B as the only supported RQ WQE size
> >
> > On Tue, Dec 20, 2016 at 12:44:04PM +0000, Tung, Chien Tin wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> > > > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Leon Romanovsky
> > > > Sent: Tuesday, December 20, 2016 5:24 AM
> > > > To: Orosco, Henry <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; e1000-
> > > > rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org; Tung, Chien Tin
> > > > <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > Subject: Re: [PATCH] i40iw: Set 128B as the only supported RQ WQE
> > > > size
> > > >
> > > > > diff --git a/drivers/infiniband/hw/i40iw/i40iw_ucontext.h
> > > > > b/drivers/infiniband/hw/i40iw/i40iw_ucontext.h
> > > > > index 12acd68..57d3f1d 100644
> > > > > --- a/drivers/infiniband/hw/i40iw/i40iw_ucontext.h
> > > > > +++ b/drivers/infiniband/hw/i40iw/i40iw_ucontext.h
> > > > > @@ -39,8 +39,8 @@
> > > > >
> > > > >  #include <linux/types.h>
> > > > >
> > > > > -#define I40IW_ABI_USERSPACE_VER 4
> > > > > -#define I40IW_ABI_KERNEL_VER    4
> > > > > +#define I40IW_ABI_VER 5
> > > > > +
> > > >
> > > > Why did you remove defines and move to use constants "4" and "5"
> > instead?
> > > [Chien Tin Tung] This is the ABI version change, did you read the
> > > commit
> > message?  Two defines were not necessary.
> > >
> >
> > Thank you Chian Tin Tung for your informative answer and yes, I read
> > commit message.
> >
> > If you think that these defines are not needed, so can you please
> > remove the code which uses hardcoded "case 4" and "case 5"?
> [Chien Tin Tung]  Those are explicit checks against a particular ABI
> version and it is clearer to use the numbers rather than some define.

Can you please stop to add [..] in front of your response? This Outlook
style is annoying and not needed.

Regarding you response, you added the same check in two places and from
grep/ctags/cscope/lxr perspective it is easier to spot them with a
define.

>
> >
> > Or maybe they still needed and should be renamed?
> [Chien Tin Tung] They are not needed.  Before we were checking against
> one version and one version only.  Now we are making the provider library
> and driver backward compatible.  All we need is one define to specify current
> ABI version.
>
> Chien

--MHoG8na4IvP3G3ze
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhZjl8ACgkQ5GN7iDZy
WKfilhAAyI/OP4zD3sQE4jv/2+QqGtAPDjLW2Ta+u2j9omFsrcvYbZl5NHcQolm3
7x0i1ViYsf1M+0Z+ko0zC9y+oPau3YpnBU7nK/zeotlTh6KyAzayrTyUisv0JkeO
iO4akaT5Rck2cgtd9CAq2f8QeXfWuwaSMrFcVy+2k+GiON5Z5VIKVymEBz9IE0x5
6MdvrVByeeHJI0rAV3UOv59n2IxVtFcGQXsWlOtBCmj9knOLnO7SlnSYqVhn2LhO
SoLj3uXFRSxKhv3PcOo9CiOu0f4mmaLVnhxwlJGOoBsQDhGUnj6SxnUIwErn7Oyz
o5pa++uvwooEdWN98fogCJ1TftkbicBjtWu0MUuUZerLJoAdY+KcK998htRlTw3b
FpN0jt/lnRAmeEuyT1Ot7kNnbM0vQAqOMBP2PaNmYFf/FXpNaexY5EAOIbBJIb3/
iVFr7KH/2CxESmUZknsMUu0eOPXpt6VDmkwtp2nld58KTGJUzmzbjtAPbc46KtvS
9KZx5s9umCFl4roa2oewlhAC/Fp9lxcIyddYQ1P5fET4oj8ozJqTNXmYyFlsf4/7
o1XHEpktiCWjK3PEvyvZ1i0oAUAKguaEqDBl3lE1q4of1xZo7IHDcm4iGk/YaKwC
YqRl9AnvR3VecIfa1HgMMoAUrtLaVXLzeHP1Vew/apgskV648cY=
=tbcb
-----END PGP SIGNATURE-----

--MHoG8na4IvP3G3ze--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
