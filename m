From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-rc 01/12] IB/mlx5: Replace numerical constant with
 predefined MACRO
Date: Fri, 28 Oct 2016 17:55:34 +0300
Message-ID: <20161028145534.GM3617@leon.nu>
References: <1477575407-20562-1-git-send-email-leon@kernel.org>
 <1477575407-20562-2-git-send-email-leon@kernel.org>
 <CAJ3xEMiNynmpbBt0M=k5qywrvnfAq+ogZLD2PUbHBvYVJ4pLyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="S66JdqtemGhvbcZP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMiNynmpbBt0M=k5qywrvnfAq+ogZLD2PUbHBvYVJ4pLyQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--S66JdqtemGhvbcZP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 28, 2016 at 03:54:25PM +0300, Or Gerlitz wrote:
> On Thu, Oct 27, 2016 at 4:36 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > Replace the pre-defined macro signifying inline umr instead
> > of the numerical constant.
>
> Leon,
>
> By all means (or no means, choose), this is a fix. If you are telling
> vmware and Broadcom people here for months how to write their code,
> let's stop for a minute and look in the mirror, drop this patch.

Thanks Or,
I appreciate your time invested in the review and providing so much
valuable feedback.

Since change of numeric value to the same value defined by macro is not
a fix but improvement and provided here to simplify maintainer's work (Doug),
I have no plans to change the patch or/and drop it.

>
> Or.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--S66JdqtemGhvbcZP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYE2bmAAoJEORje4g2clinHSwQAMxBNLRCRlDoT1oBBocRXREn
Qj8ayf6imQPJj561KQUWMiRkOAkfDuhi+9jjnKny2Xr4+NEf+QI8dP7HuxVNCkYG
fSvmf7o0s/KfyUAJQTKKqKxAdmwf8BMHV6ywN/wmLBJtOekTPIzp69/ZS5frt+2K
2LmtXjG6LDCxzg5bCkdVzK4jf+e+HqSfHYSVSZuC+0GPVSjH/+nFoclSpENa0YFQ
jk3t5wWr2OLcAdRfYMTtxtmF8Fw6Pq9zdkky00STuo3LHrVEV/zCgAoL+sx8rWMr
VRTKJNlOs/wLPJA9Bh1ikv1Yxo9wBA4ebUoHLdn4nJUThGDlN1kTECoHSnGIlr/B
UEnmgwmBrJVRCd7F+dCSh69zodJ2EfmpvAPXtjmxTeEmz87uWK7l+u63Mbg8cTtH
z9WFkYLvjqpPNXUc3qWtJcY8GdZSWoC8nn0xJG1mtbKCHn3UmitOih+YVC1Ura6S
tyBHqk6qjF+2WJy1SXJcRUfTEs7z/UU4SVHLCrYmxTDv4pFT8Obxs6bUrUKmWnTu
qEfp1D0Rj9ywZwgukvvbh9b9ka5VASj+1zyT/n4BrZgxnqCVOzVV14kwAQ2NVm7Z
FdoqN6h+j0g+j3P6d3JotKiT3RUA1LUqN0TYyqmCQFnD/64ltdJnC18PxBXPMgxD
uNZgtPYNQwqr+5TIf7Te
=9RvS
-----END PGP SIGNATURE-----

--S66JdqtemGhvbcZP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
