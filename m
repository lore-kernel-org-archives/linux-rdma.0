From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 6/6] RDMA/core: Unify style of IOCTL commands
Date: Thu, 1 Sep 2016 19:55:52 +0300
Message-ID: <20160901165552.GE21847@leon.nu>
References: <1471987907-6336-1-git-send-email-leon@kernel.org>
 <1471987907-6336-7-git-send-email-leon@kernel.org>
 <1472738739.16467.8.camel@intel.com>
 <20160901164624.GC6479@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Uwl7UQhJk99r8jnw"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160901164624.GC6479-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Uwl7UQhJk99r8jnw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 01, 2016 at 10:46:24AM -0600, Jason Gunthorpe wrote:
> On Thu, Sep 01, 2016 at 02:05:44PM +0000, Dalessandro, Dennis wrote:
>
> > > +/* allocate HFI and context */
> > > +#define HFI1_CMD_ASSIGN_CTXT=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(HFI1_CMD_=
BASE + 0x01)
> >
> > This is a minor issue, but the problem here is when we build PSM
> > against this kernel it will no longer work for older kernels because
> > the value of HFI1_CMD_ASSIGN_CTXT has changed where as it used to be 1.
> > Right now PSM is backwards compatible, this breaks that compatibility.
>
> What? Someone renumberd an ioctl? When? Why? How?
>
> Was this ioctl ever in a mainline non-staging kernel? If not, too bad,
> deal with it in your user space..
>
> If yes, can we revert the renumbering? Why was that even done??
>
> > So while no one uses the __NUM() macro directly it lets us not change
> > the PSM command values. Can we put that part back and keep the command
> > values unchanged?
>
> Please no, do not do crazy subtle things like this. If the ioctl has
> two valid numbers then you need two entries in the ioctl file.

I didn't renumbered ioctls, but renumbered one of the internals number
which is not used in kernel, but for any reasons used in their
user-space.

=E2=9E=9C  linux-rdma git:(master) grep -r HFI1_CMD_ASSIGN_CTXT drivers/inf=
iniband/hw/hfi1/* include/*
include/uapi/rdma/hfi/hfi1_user.h:#define HFI1_CMD_ASSIGN_CTXT     1 /* all=
ocate HFI and context */

So what should I do? respin or not?

>
> Jason

--Uwl7UQhJk99r8jnw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXyF2YAAoJEORje4g2clinafYP/1weV9VknGX3/YW/oHolITxl
YqX4fzLDASJgD2RUhweYbcEPAHM5e7OC8giAegNQTTgxDl2bCfiOA7CqAqhtbAx3
ocErHWx0+ykDrLwJk3j0Qdywwfqt+oANT696MYOWqmerxFv/57Lvt2T1mGeG5Rs3
/KqXJj6XRDXNKE9BesvSC1gJrGcqhr+yujmqNT85WL+Qe8y93so6f/Uy0N4LNyFU
tNaUWt6WK5sbrpuTwLhM9w+ElwLM8tKCEl+TFT+qZK7LJJbMNUOjVvWC7RBsj23E
RtlK4aY3+lxMS69Rs3bqW4+awf0kLVzdA3X5+tf5CYXucETyLHaPIhNafmvni3jJ
VmvzPcOQW0S19KTH0zKl5l5/VnonyAaHtpwkAXxh4el5s5rqqHtK+EtQy21zdQiK
Ol92QzmNjdR/M1tkV61ZW1yDbZr4VhDyPV1AcVkke1Y+/xTJuKfhNlCSSjnrViL2
oy7xEvDXkMOoZLFN8nGQr9y87G/Ad3+mI4AC3KZSQ2D9QNoi6FnIfmTBFxgRQ16u
d1fI9zWSSZmhdazMzwBcU+8IffmDaKI3yG4wc/5cn2OdzFpvc8oGzfVcV47GBg4g
9zFUHzQTeekuklJbKvxSXMO7gEyyQGcOG9B5hC6YiRX4NoYcE9Gj/1mXkFhs/1e1
1MMDFrC1XhCPuA42ib9f
=PgVV
-----END PGP SIGNATURE-----

--Uwl7UQhJk99r8jnw--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
