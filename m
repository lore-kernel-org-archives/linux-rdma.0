From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC] rdma/ib: Add trace point macros to display
 human-readable values
Date: Thu, 2 Nov 2017 18:34:11 +0200
Message-ID: <20171102163411.GA16127@mtr-leonro.local>
References: <20171030215809.31286.46685.stgit@manet.1015granger.net>
 <0370B773-BB98-49BD-9C9D-DFD3220CCC20@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5Jh2alslEMtI9ynf"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0370B773-BB98-49BD-9C9D-DFD3220CCC20-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--5Jh2alslEMtI9ynf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 02, 2017 at 12:18:41PM -0400, Chuck Lever wrote:
>
> > On Oct 30, 2017, at 6:01 PM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > These can be shared with all kernel ULPs, and more can easily be
> > added as needed.
> >
> > Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > ---
> > include/trace/events/rdma.h |  128 +++++++++++++++++++++++++++++++++++++++++++
> > 1 file changed, 128 insertions(+)
> > create mode 100644 include/trace/events/rdma.h
> >
> > Hi-
> >
> > I'm putting together a series of patches for v4.16 (or later) that
> > add static ftrace trace points to the RPC-over-RDMA client imple-
> > mentation. As part of that effort, I've constructed some trace point
> > helpers that might be useful for other kernel ULPs.
> >
> > So far this patch adds just helpers that xprtrdma needs. It is not
> > complete, but additional helpers can be introduced as they are
> > needed.
> >
> > I'd like to hear comments about these, or please let me know if
> > such helpers already exist and where xprtrdma can find them.
>
> Now that the question of whether new trace points will be allowed
> has been answered...
>
> The helpers that are used for displaying errors in the kernel
> log display the spelled out text, not the symbolic name of the
> error code, as is done here.
>
> Would the community prefer long-form text or symbolic error names
> in trace reports?

IMHO, short names are preferred. It is intended for the developers who
have access to the code, so anyway they will check the meaning if
necessary.

Thanks

--5Jh2alslEMtI9ynf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln7SQMACgkQ5GN7iDZy
WKes+A//YI1uLFuym2oF8vXFCCrkioLRK+ArxTMkmDh03MN+gSBBR3ehpQ4qrPv2
i+dapI3YuRyDypPttshUJmOTaw92Q9u1BPPuSCm9MrWKq5yIOWYRZRRIBWOwTJwi
Z7gLkkdvQudmM1hD77Z2hT91BveiZf7CXMJ8292L4tzc6f1Xb+GoKflDMVBpmKMN
Ke0zEo4NsmUM+j9rBveVyJoHa4D0T6GoAqkJCQQgZ/Oa10SdvhZvTWLjgYjBfURF
SSREIGDHeF+xQkJR8JPlG1gGMcKn9dgi1b4uYr+YWTXRx6WMuHUoeDTI7vM+Qnxa
vr2ac3eDHZXJr0TlOKRi134nRr3XcAeN/8v4bkLJYzO1GQumms5c5NQ2G3iWQ8+v
DcDvaN1ipZjTgpyX2tD7LkLaxdNsUkp+fw/WudSLxMvhdq28LHEwaG+iQIkmR7Ja
SuyNoWRzUWJzB4qUXL1S2UWaJex5b5R4vPPo1kFZ2fld+sGR6WetNRD74WTM2eOm
Pu2oKWtq/oCRIFRj7zMXjPsN7OPWGsLmkfVQjhP4Aoj335e1DMRdyt7n3nSSb79R
Vk8iP4Vu+oXbRT4fv1VZPG6+TtP5mkeYNf49wwM3zcoBbHBeIcCfJwXBydwgEGLI
hZpRbkqtE/lmivWn1HOHPq1PHrhLJ5qU2YfjLas12XqhrcQqDsU=
=589q
-----END PGP SIGNATURE-----

--5Jh2alslEMtI9ynf--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
