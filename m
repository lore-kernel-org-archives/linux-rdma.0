From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] Improve global COPYING files
Date: Thu, 29 Sep 2016 11:53:31 -0400
Message-ID: <57ED38FB.4060006@redhat.com>
References: <20160923041340.GA11269@obsidianresearch.com>
 <20160923080655.GM4088@leon.nu> <20160923152412.GB11269@obsidianresearch.com>
 <20160923171003.GR4088@leon.nu>
 <1828884A29C6694DAF28B7E6B8A82373AB08E66F@ORSMSX109.amr.corp.intel.com>
 <20160923174848.GC13920@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="rU2XjFkRdikxnwtQNU0Vnmfgt9LHVTrP7"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160923174848.GC13920-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Hefty Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rU2XjFkRdikxnwtQNU0Vnmfgt9LHVTrP7
Content-Type: multipart/mixed; boundary="xqhNIEAQmpH1l9PuWFBkWFFuCQr5D880U";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
 Hefty Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <57ED38FB.4060006-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] Improve global COPYING files
References: <20160923041340.GA11269-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <20160923080655.GM4088-2ukJVAZIZ/Y@public.gmane.org> <20160923152412.GB11269-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <20160923171003.GR4088-2ukJVAZIZ/Y@public.gmane.org>
 <1828884A29C6694DAF28B7E6B8A82373AB08E66F-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
 <20160923174848.GC13920-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
In-Reply-To: <20160923174848.GC13920-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

--xqhNIEAQmpH1l9PuWFBkWFFuCQr5D880U
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/23/16 1:48 PM, Jason Gunthorpe wrote:
> On Fri, Sep 23, 2016 at 05:23:29PM +0000, Hefty, Sean wrote:
>=20
>> If this combined repo is intended to support the plumbing for the
>> linux-rdma subsystem, then I think it must support code that is
>> submitted under GPL only.
>=20
> Hum, I don't think that follows.
>=20
> My expectation in the kernel is that the entire RDMA subystem and
> drivers follows the overall licensing model of the kernel and does not
> require userspace to follow any specific license, and certainly does
> not require userspace to follow the GPLv2.
>=20
>> Much of the tradition code can remain dual-license, but new provider
>> code, for example, should be submit-able under GPL.
>=20
> I do not support that recommendation.
>=20
> The FSF has made very clear their position on GPL licensing of plugins
> (see https://www.gnu.org/licenses/gpl-faq.en.html), and allowing a
> GPLv2 only plugin or library code would break our community's promise
> to our customers - that the library core is usable in any application.
>=20
> It would be a complicated discussion if someone proposed a GPLv2 only
> provider.
>=20
> A LGPLv2-only provider would be more acceptable, and I would encourage
> anyone who wishes to have the protections of the GPLv2 in their
> provider to go that route. I suspect it would still be controversial.
>=20
> I would prefer to see us continue with the dual license approach, and
> obviously all OFA member companies have agreed to do that.

I agree with Jason here.  Dual license or at least LGPL is needed on
providers because they will be linked to by other programs.  Libraries
shouldn't taint user programs.  But we do have some leaf code in the
overall rdma-core repo.  Things like iwpmd and ibacm.  These could be
licensed GPL only and still be OK.  So I think it's OK for the repo to
support GPL only, we just have to be clear about the fact that GPL only
is not the default as this repo is more about libraries than leaf utiliti=
es.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>    GPG Key ID: 0E572FDD
  Red Hat, Inc.
  100 E. Davie St
  Raleigh, NC 27601 USA


--xqhNIEAQmpH1l9PuWFBkWFFuCQr5D880U--

--rU2XjFkRdikxnwtQNU0Vnmfgt9LHVTrP7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJX7Tj8AAoJELgmozMOVy/do6QP/jdtEAGpl+a1duRJGQim6vkt
t+8Qm5lzbQ/41gnNDIYRmFlkw1NSKWLmmuPGVxBkhWMfvucZSUisf3vcsow83hSv
jU1LBlqgwudDLVRQ0oNJpWhIFWwJeQ/HOvqEwNRYoopVf+0qyWQnXWgEUaZx68I0
k5SvF8+oyDkGdcvnZckd87MyS2FZ/EtNH50ZiuFt/H4L1vS2nWD9TmvNBvg635b7
ah/S7yCXPHXhtKO+27pR9dFqAgvbcvSLhqHemwTiu/85+RxxD7N+4i3/1oOvfq0a
VKGmMckC+qrAzKjZSY2PkCDwYt8wJ2u9oL6csxETdcmI+MSkcSVEY9ecl+h2ffm4
L5GhrVFNtCENOxp1LfxbfdcJ2EtNb/aXMlAFSJFkkB+Oi+HxGIX3/F3pqqPqA9qd
7ji1rbAQ5CC+8jhy50y+M1IJrrurlEcI7r68CupeDwWhU5nCu8v7N0ANJLm+Ef/9
m6XQixgmlwecFf9i47yWQijzmDTqKWicxiO81Skhk1XAslncePjyCbU0SIvXTqhC
sa/YV2twa15AuNnoyjQoa2FiJFIYLbFBogVnt5qhj/3pzH2o+kPVDHpSBMuLZKfN
dNNI0ZiQAYHXsdP2srhLtqVxxLL3l108Pw2IQuWuNzsvk2b9dDsd3gWkEYo7hWyZ
2SV8pDTMVKvFdKyI7ITP
=LDoE
-----END PGP SIGNATURE-----

--rU2XjFkRdikxnwtQNU0Vnmfgt9LHVTrP7--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
