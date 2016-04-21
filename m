From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/3] IB/rdmavt,hfi1,qib: Fix memory leak
Date: Thu, 21 Apr 2016 15:50:42 +0300
Message-ID: <20160421125042.GH26951@leon.nu>
References: <20160420125205.28231.86818.stgit@scvm10.sc.intel.com>
 <20160420130523.28231.90454.stgit@scvm10.sc.intel.com>
 <20160421093827.GA26951@leon.nu>
 <20160421122216.GA13471@phlsvsds.ph.intel.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r5lq+205vWdkqwtk"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160421122216.GA13471-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--r5lq+205vWdkqwtk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 21, 2016 at 08:22:17AM -0400, Dennis Dalessandro wrote:
> On Thu, Apr 21, 2016 at 12:38:27PM +0300, Leon Romanovsky wrote:
> >On Wed, Apr 20, 2016 at 06:05:24AM -0700, Dennis Dalessandro wrote:
> >>From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >>
> >>rdi->ports has memory allocated in rvt_alloc_device(), but does not get
> >>freed because the hfi1 and qib drivers drivers call ib_dealloc_device()
> >>directly instead of going through rdmavt. Add a rvt_dealloc_device()
> >>that frees rdi->ports and then calls ib_dealloc_device(). Switch hfi1
> >>and qib drivers to calling rvt_dealloc_device() instead of
> >>ib_dealloc_device() directly.
> >>
> >>Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >
> >Dennis,
> >You posted Fixes line in two other patches, please do in this one two.
> >It is needed for proper tracking.
> >
> >Except this,
> >Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Hi Leon, I don't think that a fixes line is warranted in this case. There
> isn't a single commit that causes this issue. It is a missed code path be=
ing
> moved to rdmavt.

So, it fixed the initial commit.
You can easily send an appropriate Fixes line as a response to this
email without need to resubmit the patches.

>=20
> -Denny

--r5lq+205vWdkqwtk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXGMyhAAoJEORje4g2clineP4P/Rx69PWYO/Gq3vA/GH3T8J9T
3TmoFHKp1UXjlXHne3tNH105AomQwAX3Qs7mOmwVLR68ww0Vb8u6dOS6BPwgppKy
WQ8UemhxBfNJkJiCohFKXLMqXUJCWvAHFNRgKAFn5pXKh1wG7eoKzBd6ORGNX3f2
6ARaRX6gFIn4dbWmn4BGOOiPbu2Xp4F3cMb16uzk5kFiDJg6iwqg43ywcpl11KGe
ItgaN3pEL9CaqjAGZUXbifsn1AJW44Ac7J971UECi8lM9RXjj5+FLFTxyJRwAyMR
HBNrI9sYIc1G96KDMHz66uh/F1ZfDLbH7rywmO+xHSOb1LgzITEj13paJudrgyJt
L0SZ3xqrjgyei4Pi5WM9bzGbHqg8VL0uvsJs1jwMqoC0v8TsHS/JLnLfJs150E4y
fDbXLKI3/8KeYtwPZBIlB6vyNlJDKYIPnOif0ZYMjhmL2PyAC5YxKAIrliFnEbXR
g7zD1gEYZHsSUcvCfQGkHp1L7i+ya/87LQhCLa8BE57MxRYszoWpYf9U9/YDtJbf
ahAuwQiVEoyaG+8DAlvPn+lIarFMOjOcB5WG/9ELTxPBVDypy/IqNmjwjOREdAHM
4b0GWAP7EEGfbIljaNHFFq/FtDdJVLal0u6ET6Z2YCV+3M7woEyTEtFilZ5qcIET
JzlGL5e1TvT8h6ZrORcE
=Vjit
-----END PGP SIGNATURE-----

--r5lq+205vWdkqwtk--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
