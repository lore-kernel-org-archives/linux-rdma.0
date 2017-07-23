From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 7/9] IB/core: Allow QP state transition from
 reset to error
Date: Sun, 23 Jul 2017 16:04:45 +0300
Message-ID: <20170723130445.GG3259@mtr-leonro.local>
References: <20170530000314.534.72983.stgit@scvm10.sc.intel.com>
 <20170530002032.534.25061.stgit@scvm10.sc.intel.com>
 <20170530054609.GG17751@mtr-leonro.local>
 <20170723073905.GE3259@mtr-leonro.local>
 <20170723074153.GF3259@mtr-leonro.local>
 <1500812883.2610.7.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vIq7vvlOcsOjFaxi"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1500812883.2610.7.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--vIq7vvlOcsOjFaxi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 23, 2017 at 08:28:03AM -0400, Doug Ledford wrote:
> On Sun, 2017-07-23 at 10:41 +0300, Leon Romanovsky wrote:
> > On Sun, Jul 23, 2017 at 10:39:05AM +0300, Leon Romanovsky wrote:
> > > On Tue, May 30, 2017 at 08:46:09AM +0300, Leon Romanovsky wrote:
> > > > On Mon, May 29, 2017 at 05:20:53PM -0700, Dennis Dalessandro
> > > > wrote:
> > > > > From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > >
> > > > > Playing with IP-O-IB interface can trigger a warning message:
> > > > > "ib0: Failed to modify QP to ERROR state" to be logged.
> > > > > This happens when the QP is in IB_QPS_RESET state and the stack
> > > > > is trying to transition it to IB_QPS_ERR state in
> > > > > ipoib_ib_dev_stop().
> > > > >
> > > > > According to the IB spec, Table 91 - "QP State Transition
> > > > > Properties"
> > > > > it looks like the transition from reset to error is valid:
> > > > >
> > > > > Transition: Any State to Error
> > > > > Required Attributes: None
> > > > > Optional Attributes: None allowed
> > > > > Actions: Queue processing is stopped. Work Requests pending or
> > > > > in
> > > > > process are completed in error, when possible.
> > > > >
> > > > > This patch allows the transition and quiets the message.
> > > > >
> > > > > Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > > Signed-off-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > > Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
> > > > > >
> > > > > ---
> > > >
> > > > Thanks,
> > > > Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > >
> > > Doug,
> > >
> > > After digging more with Erez's help, it looks like the sentence "it
> > > looks like the transition from reset to error is valid:" is not
> > > correct.
> > >
> > > According to the InfiniBandTM Architecture Release 1.3, Figure 126
> > > QP/EE Context
> > > State Diagram - transition to error from reset is not valid.
> > >
> > > The quote from the spec:
> > > "An error can be forced from any state, except Reset, with the
> > > Modify QP/EE Verb."
> > >
> > > I'll send revert patch along with proper fix.
> >
> > Ahh, it wasn't pushed to kernel.org, so no need to revert and you can
> > simply drop it.
>
> It *is* on kernel.org, and has already been pulled by Linus:

Thanks, I updated the trees and got it.

Also I prepared revert and patch and will send once it will finish our regression runs.
https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/commit/?h=rdma-rc&id=b287b76e89503ef1d403cc5cc8bd74b035d25bfa
https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/commit/?h=rdma-rc&id=5dc78ad1904db597bdb4427f3ead437aae86f54c

BTW, when will you post for-4.14 branch so we will be able to base our
submission queue for the -next?

Thanks

>
> commit ebc9ca43e1d52a85c72fc2d343f353386ed6c188
> Author: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Date:   Mon May 29 17:20:53 2017 -0700
>
>     IB/core: Allow QP state transition from reset to error
>
>     Playing with IP-O-IB interface can trigger a warning message:
>     "ib0: Failed to modify QP to ERROR state" to be logged.
>     This happens when the QP is in IB_QPS_RESET state and the stack
>     is trying to transition it to IB_QPS_ERR state in
> ipoib_ib_dev_stop().
>
>     According to the IB spec, Table 91 - "QP State Transition
> Properties"
>     it looks like the transition from reset to error is valid:
>
>     Transition: Any State to Error
>     Required Attributes: None
>     Optional Attributes: None allowed
>     Actions: Queue processing is stopped. Work Requests pending or in
>     process are completed in error, when possible.
>
>     This patch allows the transition and quiets the message.
>
>     Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>     Signed-off-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>     Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>     Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>     Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>

--vIq7vvlOcsOjFaxi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAll0nu0ACgkQ5GN7iDZy
WKe1BxAAkh9izduyRkl9FUDTZyKFAawb30WjsuOsnihdVtL1ly6cPQQWpriIbWVM
tYOzuEA/L2NixKd01hoBv59PlFRidQRjh+EBty2xxHR9FQIavSvHwwkUVxFwQVd7
Waz4QA2gLL9Y8IMc4qyMpEIpNBPaJ8kOL/xBzomv/UftHcq9pyXgB71yDBdAS2sb
Y9AdszaL+avodHK3b9dUdDblx79PLg61WsqIt1gAaNqZ/13bQfYBuR7KNI2cqwtp
B4KDMBkxcNXxJ2cLYEx4edSONh9zPB5/PM5sdQR86SQnuhRC9+jKHEi2LywVfXKx
1ICCoPeOOXm0YlsEqRc3w5RlAmBZkr51dSCAeecUrSL+VcWNjVp8KxOw4f6D21k9
cls+UFWJ74r8mGzpZlKzwBQf5iy64gzjBw3XfQSBzCXOxX1v316+hiBGLiDS0iFh
MFwrk4X2MzCe7S9fa2nYbPEBsr1MRZFQYyA8GJ0JL9zTNQPP6DgMUQb8cB0y3wES
Mi36lb5CMru6ZY/x9zQv8hrAlOxnhAf7hwSO1YW9yxnj6JbKIa7UzdnVKEBwxUo4
q/eB8hNW1ayeceYErC3oVfJAaCeuKgVIgEp7tasKaMjoCkWrNAHViPo/EM1OvOUV
VOZuSJmtOY7tnumaqjNpJSCi+EnOqHAjwrZh6gCH6sEXDxGCR+o=
=aTYP
-----END PGP SIGNATURE-----

--vIq7vvlOcsOjFaxi--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
