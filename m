From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] Add a .travis.yml file
Date: Wed, 5 Oct 2016 14:51:32 +0300
Message-ID: <20161005115132.GE9282@leon.nu>
References: <1475105337-18002-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="XuV1QlJbYrcVoo+x"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1475105337-18002-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--XuV1QlJbYrcVoo+x
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 28, 2016 at 05:28:57PM -0600, Jason Gunthorpe wrote:
> Necessary to use the Travis CI service.
>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  .travis.yml | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
>  create mode 100644 .travis.yml
>
> Now that travis is enabled on repo, we need a yml file to make it run.
>
> Here is a basic one.
>
> I don't test with distros as old as precise and I don't expect that glibc=
 to
> be new enough to build this (eg missing timerfd, O_CLOEXEC, etc), and the
> cmake certainly isn't. So we use the trusty 'beta' environment and install
> gcc 6.2.

I'm using 16.04 and it has gcc 5.4.0 as a default. Don't you think that
6.2 is too "new" for us and other distributions?

=E2=9E=9C  linux-rdma git:(master) gcc --version
gcc (Ubuntu 5.4.0-6ubuntu1~16.04.2) 5.4.0 20160609
Copyright (C) 2015 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Thanks

--XuV1QlJbYrcVoo+x
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX9OlEAAoJEORje4g2clinZ3gP/iZolCQQP5OJTyypR7cX099c
sCDf/J2unFDaR88dIW6Pvxv5ep9Hf/nbLVo960kj+1iSdM4Vccv6I5d5X+qsFdG+
tW8UO1S0v0+TP5w81wdHgpKyjKVi3y1Oxba+wJd79v1uBPWiXkSQ1FVlOBymDDbi
P1O8tSEo0pVeCMapcilua+X/z5TCCJ6WHoD4aSA+FaoTNjajy8XC1IBiZu38Ixg0
bJVeWa0qIZg9LsYBsal7qQ+A08klzBw2zUrCRESwdKsjCDkXYNJJ+VkMNqVjKv6b
ekBPNZqpPqg88qMuq5S/ddJGBBN6lcMrxtrWvwmzrYOaysPygXH45TOuz3WTRM4u
mMJVGOqupYXHlG+hERekBZW4RYhXSGdJiu4ig+KVe3RZUhfS37jjVfpXNp4TnA6J
DlQwpvWvpnebLrDRrszDs1GUZjjMAE9n8gnCC5yDc/V0uU+b1A0DTjcChib6OPdN
l4lD7ME/1Mn57tflh/y9LJAYnrPkkJ7ooEWfbutISsu/mFmF06KfjmhvbP0NHQKz
npYHtRNtaOJu9MRNqYnR1SZ8novdbUXFpI9F3zGq/RTGiF5XPbpO4Mh3xyN8SFZA
kgL7sr49ouJyO7SN4ZwOio0vCvJN4/mdMU/5NElV8Sntu3rZ3fwU0eB0jLER5L8E
1N+fuhKMgsXAYITnIjvL
=bLwf
-----END PGP SIGNATURE-----

--XuV1QlJbYrcVoo+x--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
