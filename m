From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-4.1 0/2] Adds support for user mode bar2 mapping and
 bar2 qid density
Date: Thu, 11 Jun 2015 10:10:41 -0400
Message-ID: <1434031841.71666.163.camel@redhat.com>
References: <1433854392-6531-1-git-send-email-hariprasad@chelsio.com>
	 <1433998881.71666.147.camel@redhat.com>
	 <005201d0a450$0dd27660$29776320$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-assQzzQBAuKJWlrlwreX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <005201d0a450$0dd27660$29776320$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Hariprasad Shenai' <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-assQzzQBAuKJWlrlwreX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-06-11 at 09:08 -0500, Steve Wise wrote:
> > -----Original Message-----
> > From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-fy+rA21nqHI@public.gmane.org=
rnel.org] On Behalf Of Doug Ledford
> > Sent: Thursday, June 11, 2015 12:01 AM
> > To: Hariprasad Shenai
> > Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org; leedom@che=
lsio.com; nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
> > Subject: Re: [PATCH for-4.1 0/2] Adds support for user mode bar2 mappin=
g and bar2 qid density
> >=20
> > On Tue, 2015-06-09 at 18:23 +0530, Hariprasad Shenai wrote:
> > > Hi,
> > >
> > > This patch series adds support for user mode bar2 mappings for T4 ada=
pter
> > > and also adds  support for bar2 qid densities exceeding page size.
> > >
> > > This patch series has been created against Doug's github tree 'for-4.=
1'
> > > branch and includes patches on cxgb4 and iw_cxgb4 driver.
> > >
> > > We have included all the maintainers of respective drivers. Kindly re=
view
> > > the change and let us know in case of any review comments.
> >=20
> > I didn't catch this in my original responses to this thread.  But, your
> > subject calls this out for 4.1.  You do realize that 4.1 is already at
> > 4.1-rc7.  Did you really mean for a patchset this large to go in at thi=
s
> > late stage of the rc cycles?  And if so, what's the justification?
> >=20
> > Otherwise, I fixed up the cast issue I brought up and have this ready t=
o
> > apply to 4.2.  But if you *really* mean 4.1, speak up with the problem
> > this solves and why it's so bad it can't wait.
> >
>=20
> 4.2 is fine with me.  The changes are too great for 4.1-rc7.

Whew!  Good ;-)  Applied for 4.2.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-assQzzQBAuKJWlrlwreX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVeZbhAAoJELgmozMOVy/dgtQP+wQGJOLoqph9VqiLNzC5BMfx
+OnNoJM/kEDVw+T6oyksYIGnbzHdBj1NfaK/KQOY9CCazmPscFTVz/9eA8XP0WNZ
nTAI0DBZZhAgyw3FTpPqGcr337c+uYiz1TFfkBRWpcLfzMgDO1W9Prcj5KNLNj/s
+bhoDN4vMz81Xrv/QLKNIHXkT36rB7UmGf1ZnlBv6XbfQOp+1l9MhaDILwS1Z6CE
MCO6zVNqG9YIdJ2bX/+s7yhVroMgpFxmISZ+ENR26XkY4I7uEiOrR7SKay7XLgBQ
6ecoGzrmdHyZ6SExAqdByIW3sU7fDQ4Z/lEHU2YgI2y/DSowvVeFCX8G5AVFTIcU
0Fdbjz8wvjSKYiFSUD9UBRXMcvg2DM+wELJdgyg/t5KYD2i0CQBD1lhybcujT7gL
by2UHqhP5326vA3SXlM1UfG0psLSxgDHIZkQIfpYvbYDZLimRzC5lAEQ0Jg0/j1s
WK60o1r5BbzZtDji+rgZkLU+L6yNPwp0vsONAsYjEraS8GmbI8nfoQ64iba27E+W
GQm/63+dpYo1HK9f6NalU3Sw0yZapYgJKBGQOuVpNjMviTrlSt4IXuqdZn4+Ga27
XBb5VK9ZTZ5cIKPl7p/gCi9PRbWbZHby/YCYKOaVSiX73ITWb+6da2sBh22Wvb7u
bT+hzHeVq7xzYquWJch3
=TIWG
-----END PGP SIGNATURE-----

--=-assQzzQBAuKJWlrlwreX--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
