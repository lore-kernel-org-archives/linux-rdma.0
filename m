From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 06/31] IB/ipoib: Avoid memory leak if neigh
 destination was changed
Date: Wed, 15 Nov 2017 07:11:50 +0200
Message-ID: <20171115051150.GL18825@mtr-leonro.local>
References: <20171114125218.20477-1-leon@kernel.org>
 <20171114125218.20477-7-leon@kernel.org>
 <CAJ3xEMjPD-MwKHknnYVBzzhSoxCFWE2i9jOCC500yEn5pFXarg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="BwgxZU5iS1dWSTZh"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMjPD-MwKHknnYVBzzhSoxCFWE2i9jOCC500yEn5pFXarg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--BwgxZU5iS1dWSTZh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 14, 2017 at 11:51:09PM +0200, Or Gerlitz wrote:
> On Tue, Nov 14, 2017 at 2:51 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > If from some reason the SM responses to path query request with response
> > that doesn't contain the exact SGID, ipoib should warn and change that
> > part of the response before push it to the path record DB.
> > Otherwise, new record will be added to the path record DB with no access
> > to them from the ipoib.
> >
> > Demonstration of the bug is as the follow:
>
> this series contains bunch of fixes, any reason to direct them to
> -next (4.16) and not -rc (4.15)

Doug didn't send his pull request yet and most probably we will have two
pull requests in this merge window, one with already accepted code and
another with fixes from Denny and us. So all these patches are targeted
for 4.15.


>
> Also, in most of the cases ppl didn't provide a Fixes: line with the
> offending patch, any reason to skip that?

There are two main reasons:
1. I didn't request to add Fixes for refactoring code (most Parav's
patches), because I don't want that code to be picked for stable@ trees
by Greg's and Sasha's automatic scripts.
2. Sometimes, it is not clear the origin of the bug and the chances to
have wrong Fixes are higher than to have right ones.

Everything else is my mistake during review. Can you point me to
specific commits where you would like to see Fixes with right Fixes? I'll add.

Thanks

--BwgxZU5iS1dWSTZh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloLzJYACgkQ5GN7iDZy
WKeq8w/+K5OH5fzptIUAoxoenPpLt0zB3qnsb91XRkMkAJGjpopzrkRHS4RojndZ
ZDmcip3LQRD0QeUClRJkhX/GkpWDKRb3Q6u/ssoYpLebA1BCLnOs5cW+7cZqGgJL
xCcvgXNNRoYxob2o5u4RPJZsOqlmu1x0RkeJ0+Zxwkymi9EPgvNVscpc44bKfMMG
FsUMAiE8u3AXAVHUO2ppKhIwNtpIypKOPt2dbEoOfDlNmbmj+wLUASr0PLHsYvuS
yPNE5t10sJcCFKXaOJcbChmjm/sDJdeanJcljiXSYauJg5mhjpJ6JFppfaa7i1CL
ulbn8v5O+C4gEzJG15wojUtCqChkOWGCGwdxOMUsAl8f08GGlH5/6c7H0EsqMA2e
rpXR7FDxta4t0SztPf0xY8mJctLho3sng8yR9LVPexCQ58GE9OkaCjL5Do2rePve
0D87dyVBmbLVedzKE1N4qT4AW+flUgkP3kiFFzO2OrJcihmO0LJMszzygLCmKoFy
isXOBWKBetUeOsEeTGJTcPhJXvfipodBqStcZFkb0SYEi3wQk1+bvO/3Z5I1GG4Y
rGo6rcPwtx74ogTvPb/ZmdcaNJ5bRNRiI0GJWQx46VoooMUvi70KwXs0mQ5x9+a3
qJFxAJ6ajt+Qnh8pFsAt/7sg8IzjT3tvyhqFGAHR/bs3cG+mDBE=
=nPMt
-----END PGP SIGNATURE-----

--BwgxZU5iS1dWSTZh--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
