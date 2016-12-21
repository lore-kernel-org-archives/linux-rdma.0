From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] i40iw: Set 128B as the only supported RQ WQE size
Date: Wed, 21 Dec 2016 17:12:50 +0200
Message-ID: <20161221151250.GA18935@mtr-leonro.local>
References: <20161219203227.86392-1-henry.orosco@intel.com>
 <20161220112417.GV1074@mtr-leonro.local>
 <748B799B6A00724488C603FD7E5E7EB94CBAEEA0@FMSMSX114.amr.corp.intel.com>
 <20161220134203.GW1074@mtr-leonro.local>
 <748B799B6A00724488C603FD7E5E7EB94CBAFBBC@FMSMSX114.amr.corp.intel.com>
 <20161220200239.GA1074@mtr-leonro.local>
 <748B799B6A00724488C603FD7E5E7EB94CBB12AF@FMSMSX114.amr.corp.intel.com>
 <20161221054805.GB1074@mtr-leonro.local>
 <748B799B6A00724488C603FD7E5E7EB94CBB1BA8@FMSMSX114.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <748B799B6A00724488C603FD7E5E7EB94CBB1BA8-XfjTATA9Em864kNsxIetb7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Orosco, Henry" <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 21, 2016 at 02:07:15PM +0000, Tung, Chien Tin wrote:
>
>
> > -----Original Message-----
> > From: Leon Romanovsky [mailto:leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org]
> > Sent: Tuesday, December 20, 2016 11:48 PM
> > To: Tung, Chien Tin <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Cc: Orosco, Henry <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-
> > rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> > Subject: Re: [PATCH] i40iw: Set 128B as the only supported RQ WQE size
> >
> > On Wed, Dec 21, 2016 at 12:04:55AM +0000, Tung, Chien Tin wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > From: Leon Romanovsky [mailto:leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org]
> > > > Sent: Tuesday, December 20, 2016 2:03 PM
> > > > To: Tung, Chien Tin <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > Cc: Orosco, Henry <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org;
> > > > linux- rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> > > > Subject: Re: [PATCH] i40iw: Set 128B as the only supported RQ WQE
> > > > size
> > > >
> > > > On Tue, Dec 20, 2016 at 02:46:30PM +0000, Tung, Chien Tin wrote:
> > > > >
> > > > >
> > > > > > -----Original Message-----
> > > > > > From: Leon Romanovsky [mailto:leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org]
> > > > > > Sent: Tuesday, December 20, 2016 7:42 AM
> > > > > > To: Tung, Chien Tin <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > > > Cc: Orosco, Henry <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org;
> > > > > > linux- rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> > > > > > Subject: Re: [PATCH] i40iw: Set 128B as the only supported RQ
> > > > > > WQE size
> > > > > >
> > > > > > On Tue, Dec 20, 2016 at 12:44:04PM +0000, Tung, Chien Tin wrote:
> > > > > > >
> > > > > > >
> > > > > > > > -----Original Message-----
> > > > > > > > From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> > > > > > > > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Leon Romanovsky
> > > > > > > > Sent: Tuesday, December 20, 2016 5:24 AM
> > > > > > > > To: Orosco, Henry <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > > > > > Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; e1000-
> > > > > > > > rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org; Tung, Chien Tin
> > > > > > > > <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > > > > > Subject: Re: [PATCH] i40iw: Set 128B as the only supported
> > > > > > > > RQ WQE size
> > > > > > > >
> > > > > > > > > diff --git a/drivers/infiniband/hw/i40iw/i40iw_ucontext.h
> > > > > > > > > b/drivers/infiniband/hw/i40iw/i40iw_ucontext.h
> > > > > > > > > index 12acd68..57d3f1d 100644
> > > > > > > > > --- a/drivers/infiniband/hw/i40iw/i40iw_ucontext.h
> > > > > > > > > +++ b/drivers/infiniband/hw/i40iw/i40iw_ucontext.h
> > > > > > > > > @@ -39,8 +39,8 @@
> > > > > > > > >
> > > > > > > > >  #include <linux/types.h>
> > > > > > > > >
> > > > > > > > > -#define I40IW_ABI_USERSPACE_VER 4
> > > > > > > > > -#define I40IW_ABI_KERNEL_VER    4
> > > > > > > > > +#define I40IW_ABI_VER 5
> > > > > > > > > +
> > > > > > > >
> > > > > > > > Why did you remove defines and move to use constants "4" and "5"
> > > > > > instead?
> > > > > > > [Chien Tin Tung] This is the ABI version change, did you read
> > > > > > > the commit
> > > > > > message?  Two defines were not necessary.
> > > > > > >
> > > > > >
> > > > > > Thank you Chian Tin Tung for your informative answer and yes, I
> > > > > > read commit message.
> > > > > >
> > > > > > If you think that these defines are not needed, so can you
> > > > > > please remove the code which uses hardcoded "case 4" and "case 5"?
> > > > > [Chien Tin Tung]  Those are explicit checks against a particular
> > > > > ABI version and it is clearer to use the numbers rather than some define.
> > > >
> > > > Can you please stop to add [..] in front of your response? This
> > > > Outlook style is annoying and not needed.
> > > >
> > > > Regarding you response, you added the same check in two places and
> > > > from grep/ctags/cscope/lxr perspective it is easier to spot them with a
> > define.
> > >
> > > You have yet to provide a good argument for changing the 4 and 5 to
> > > defines, so I don't know why you are telling me how to find them. Very
> > puzzling.
> >
> > I'm not telling to you, but asking from you to provide maintainable code which
> > will be read more than once. Right now, you blindly copy-pasted hardcoded
> > values in three different places (2 kernel and 1 rdma-core).
>
> Please make your case by coming up with a define that's better than 4 or 5,
> making the code more readable and understandable, then I will consider using it.

First of all you are already have define for 5, but who cares, you are
not junior and don't need to read the code which you wrote minute before.

Second, you need to come with new name for number 4 only.
What about following?
#define I40IW_LEGACY_ABI 4

> Until you can do that, you have no case for your comment.  Blindly using a define
> is something you tell junior programmers, sometimes, a number is just a number,
> nothing wrong with using it as is.
>
> >
> > Feel free to ask your colleagues (Faisal L. and Shiraz S.) if they interested in
> > maintainable driver code or they prefer your prone to errors copy-paste
> > technique.
>
> Why don't you go back and read the comment made against I40IW_SUCCESS?
> Maybe you will learn something from that?

Your word is a lamp for my feet, a light on my path. Please enlighten me.

Happy Christmas.

>
> >
> > > I already made my case on this.  Enough said.
> > >
> > > Chien
> > >
> > > >
> > > [Chien]
> > > > >
> > > > > >
> > > > > > Or maybe they still needed and should be renamed?
> > > > > [Chien Tin Tung] They are not needed.  Before we were checking
> > > > > against one version and one version only.  Now we are making the
> > > > > provider library and driver backward compatible.  All we need is
> > > > > one define to specify current ABI version.
> > > > >
> > > > > Chien
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> > > in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo
> > > info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlham/IACgkQ5GN7iDZy
WKdbAA/7BDooVmmzZAcfWrkjq7Lq+RvfXLQOUlVkKEJa9mQebqtD0RQ1W44Sv6yZ
3m6tJJCDvlP4oVDlPyS1ygSxsC0cOyApJM8g9yih/7mNjaqxlVPq/RvdERH/MPZ8
S3TOTtziGtw++clVFuw5qaTA2WhR1lN6gKQXT5vKfLCn+y3iTRdyui6nf7PUHMba
Oc39SmrpHggqTX+KmcwTQTkOEKzTU/jGcrr0YXtsbAnQFuYJMFsnzYePLETL5vmY
nwaoTKtBpuVz8dBLHQ0RUCtVW4kfeFx8qfmzkIAvMlsuxqo6FNSdHHwZ4LI+5LvH
vAn+Xrr64BrVRk49SdUYY1SIHyKEJp1SVkA/UW5DlIqas6YgVeyyjt0grefGD84v
53gS8pjp6xRGrleJ2NX3dS+ZunWzrZgiwoSa3GpGvT2PMdqveGhlv8QoRPXjSuHL
qXfWuuSBgdLnwKYEUmT/VxvY7IJRfwiQzIgmNbf3HMjgFdaOBQzJ0A2wMNgS9M/H
MssjAMWIJL2cfw6VxrHlzYCcdvticYTxl+UN47yNmAQCGRBHrPBq+XRm8g5Kae6H
u3MaNVcLlhI0K60ox5paGMoCK0sO14zj9l79bZI5XgHs6uYt+Q9Bzt7gtIfJSBjD
9jF9mhp41eBbJCYH/qx61cFKbslcP9Sy7DkKp2imZmHYPNN9w9Q=
=IQyb
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
