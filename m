From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] libibverbs init.c: conditionally emit warning if no
 userspace driver found
Date: Fri, 22 May 2015 10:44:21 -0400
Message-ID: <1432305861.28905.83.camel@redhat.com>
References: <1431440068-19037-1-git-send-email-jsquyres@cisco.com>
	 <BED0001D-0051-4ACD-8506-8FA07E625694@cisco.com>
	 <1432044878.5304.1.camel@opteya.com> <1432049804.3114.41.camel@redhat.com>
	 <1432133301.5304.10.camel@opteya.com> <1432139226.3114.83.camel@redhat.com>
	 <1828884A29C6694DAF28B7E6B8A82373A8FDD9BC@ORSMSX109.amr.corp.intel.com>
	 <1432141870.3114.89.camel@redhat.com>
	 <B397943B-9919-47CC-94E9-98A2A0BEFE8F@cisco.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-ckOL6W0HWItNAD3mVrDv"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <B397943B-9919-47CC-94E9-98A2A0BEFE8F-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-ckOL6W0HWItNAD3mVrDv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2015-05-22 at 13:58 +0000, Jeff Squyres (jsquyres) wrote:
> On May 20, 2015, at 1:11 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >=20
> > The location of the upstream sources and tarballs would not change.
> > Neither the git repo nor the tarball repo were like the kernel.  The
> > upstream kernel.org git repo Roland had, had his name in the repo.  So
> > it had to change.  But the libibverbs repo is in a generic location.
> > There is no need to change it, only to change the permissions on the gi=
t
> > repo to allow the new maintainer to push directly into it. =20
>=20
> Did that happen yet?

I don't think so.  I didn't file a specific ticket for it at k.o yet
(the k.o tickets take a while to process, so I didn't want to file it
until after the comment period here on list).

> > Ditto with
> > the upload/download space on openfabrics.org/downloads/verbs.
>=20
> It looks like someone did part of this on flatbed -- you own the download=
 directory but none of the files, and they are all 644.  So I took the libe=
rty of chown'ing them all to you:

Yeah, I did that one separately.  I had that done earlier, but getting
things done on flatbed is much faster and so could be reversed much
easier if need be ;-)  The reason I didn't own the files is that I
didn't really need to.  They are more or less set in stone and can't be
changed, so being owned by roland's account was fine.  It's fine this
way too.

> ----
> $ hostname; pwd; ls -la
> flatbed.openfabrics.org
> /var/www/html/downloads/verbs
> total 6096
> drwxr-xr-x.  2 dledford ofed   4096 May  7  2014 .
> drwxrwxr-x. 55 apache   ofed   4096 Feb 13 07:31 ..
> -rw-r--r--.  1 dledford ofed 347508 Mar 14  2006 libibverbs-1.0.2.tar.gz
> -rw-r--r--.  1 dledford ofed 349439 May  2  2006 libibverbs-1.0.3.tar.gz
> -rw-r--r--.  1 dledford ofed 360410 Oct 31  2006 libibverbs-1.0.4.tar.gz
> -rw-r--r--.  1 dledford ofed 359902 Jun 18  2007 libibverbs-1.0.5.tar.gz
> -rw-r--r--.  1 dledford ofed 321835 Aug 29  2005 libibverbs-1.0-rc1.tar.g=
z
> -rw-r--r--.  1 dledford ofed 338537 Oct  2  2005 libibverbs-1.0-rc3.tar.g=
z
> -rw-r--r--.  1 dledford ofed 341792 Oct 28  2005 libibverbs-1.0-rc4.tar.g=
z
> -rw-r--r--.  1 dledford ofed 347699 Feb 17  2006 libibverbs-1.0-rc7.tar.g=
z
> -rw-r--r--.  1 dledford ofed 384743 Jun 18  2007 libibverbs-1.1.1.tar.gz
> -rw-r--r--.  1 dledford ofed 394618 Apr 18  2008 libibverbs-1.1.2.tar.gz
> -rw-r--r--.  1 dledford ofed 359331 Oct 29  2009 libibverbs-1.1.3.tar.gz
> -rw-r--r--.  1 dledford ofed 362475 Jun  3  2010 libibverbs-1.1.4.tar.gz
> -rw-r--r--.  1 dledford ofed 364219 Jun 28  2011 libibverbs-1.1.5.tar.gz
> -rw-r--r--.  1 dledford ofed 387794 Dec 21  2011 libibverbs-1.1.6.tar.gz
> -rw-r--r--.  1 dledford ofed 391812 May 28  2013 libibverbs-1.1.7.tar.gz
> -rw-r--r--   1 dledford ofed 406548 May  5  2014 libibverbs-1.1.8.tar.gz
> -rw-r--r--.  1 dledford ofed 384656 Apr 24  2007 libibverbs-1.1.tar.gz
> -rw-r--r--   1 dledford ofed   3957 May  7  2014 README.html
> -rw-r--r--.  1 dledford ofed     60 Mar 12  2008 WEB_README
> -----
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-ckOL6W0HWItNAD3mVrDv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVX0DFAAoJELgmozMOVy/dq7wQAMHKYk3goBjUBMX0EznawtCP
M8US3iwxMRf5hqfWgR2dnffoOIFUo3jTJIGmTkJ+KTRu3JgXEOVUSFQdLNMLJoKF
bJI6Y8saaBCGcWnDpq4VAsSorUKiAshYME3aoVL3h4T2HIhUaUL6Enw8LgrG3A61
YPPZzqzQd9AoAA5MnY+AjfYtPFCd8Ak6PPlVhSfUsTVN8fI5BrP/KEdB01Y+7Nfm
TZSMw1S5csBN8B/leHQnU6LyfaiJ/iZP+f8h0g9ekFQSfdiKBxrlwEdAGOkj0TKf
9/Avsn0LTuvCgoW+0yFtAUK67ZSkeGfOD4l72ENgZkX5lNJnaea9vM1pTc4rvrR+
1IjYxt34fv8+L77Wdg679j1HIipRDIyNMi0XPaF78oaHk+IXn7fptOte09H7yXFz
JaoYp+AA18YEvHxoFNoM65WntT4HXNR7I2tU4hjfliMq5XBLA4qgjoq7xZlpBJk/
dIjfuYey+paysnl7sFJVbs4qGrFw8kyC/Scpj60k/eSBwdc8GwcUVKpgbiXOl7Cb
AU9VLUjtoKBL9+EY/twxG70iHghSYDnYtiyzdYRSmt6DWEjhwzxV6NnniSgWsDV8
KmSTdGXl3wInQUhBJDwgCbA7Fgj95uXVcksTWIiHZbEAkFZq5z3CbCJpkwx4cnzu
zR+cB+76kzsdtGX8EkuK
=D+ng
-----END PGP SIGNATURE-----

--=-ckOL6W0HWItNAD3mVrDv--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
