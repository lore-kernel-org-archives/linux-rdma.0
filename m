From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: qedr and vmw_pvrdma are not packaged in rdma-core
Date: Thu, 2 Feb 2017 19:44:15 +0200
Message-ID: <20170202174415.GC6005@mtr-leonro.local>
References: <20170202062628.GZ6005@mtr-leonro.local>
 <20170202163831.GA10782@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="m62MDEjg5u5lTXSK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170202163831.GA10782-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Ram Amrani <ram.amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--m62MDEjg5u5lTXSK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 02, 2017 at 09:38:31AM -0700, Jason Gunthorpe wrote:
> On Thu, Feb 02, 2017 at 08:26:28AM +0200, Leon Romanovsky wrote:
> > Hi Ram and Adit,
> >
> > I want to bring to your attention that qedr and vmw_pvrdma drivers are
> > missing from various package files available in rdma-core.
>
> It is handled automatically, can't be missing:
>
> $ buildlib/cbuild pkg jessie
> $ dpkg-deb -c ../ibverbs-providers_13-1_amd64.deb
> -rw-r--r-- root/root     35024 2017-02-02 09:31 ./usr/lib/x86_64-linux-gnu/libibverbs/libqedr-rdmav2.so
> -rw-r--r-- root/root     18600 2017-02-02 09:31 ./usr/lib/x86_64-linux-gnu/libibverbs/libvmw_pvrdma-rdmav2.so
>
> $ buildlib/cbuild pkg fc25
> $ rpm -q -l -p ../libibverbs-13-1.fc25.x86_64.rpm
> /usr/lib64/libibverbs/libqedr-rdmav2.so
> /usr/lib64/libibverbs/libvmw_pvrdma-rdmav2.so
>
> > RedHat has different scheme with explicit declaration, from redhat/rdma-core.spec
> > 98 Provides: librxe = %{version}-%{release}
> > 99 Obsoletes: librxe < %{version}-%{release}
>
> This is only for things that were previously packaged in redhat, qedr
> and vmw_pvrdma have not been, so they should not include those
> stanzas. It is similar to the obsoletes/replaces in debian/control.

Are you sure? I can't find librxe here.
https://www.rpmfind.net/linux/rpm2html/search.php?query=librxe&submit=Search+...&system=&arch=

>
> > But it is not installation only.  for example debian/copyright
> > doesn't have information about providers/vmw_pvrdma.
>
> Yes, this needs to be fixed..
>
> This is why I was hoping for an automatic script to maintain this file :)
>
> Jason

--m62MDEjg5u5lTXSK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliTb+8ACgkQ5GN7iDZy
WKeaxhAAwniJxelz3X/G5w/zq1GVgVY/IS66J7PXgHTFOl34rT6hm7Mjs8F4df50
CwlKRuc0iLMdj6aJ/lY7Tr2spxSKwaUD7cCurDRLTeVTSCdg0s5a5E+cIV5MdDzF
LNcq3bf2JD//ri1oz2WoSngrJEvGiY8lUp/rOLqefsZbVr21LR7ijQlOhwAOyyhP
iL4wxB2MXJT50xBuBiGxKlMJyaALnLN3VAqoxv+fa0Rsw9WyVjNeC3N8I99pA8ec
4eA0VH+iqyjt/cdTlWPorJUVPTyOC0C2LvsCLGFajqJ+oXBkMu8nuo2B7P2kDZGJ
HAPwONLZoiKPkRdM8c0QAc3SnG0Gw0MDGxMl3eBfq6g8LHBQLQXhQsltBEj8UjpF
Y/kCLHUu+IUOcHJ4OE1tQLKByfwNuW/BOfCqhX0B0uhW+CKAWmuYjl9z/7qgHNQ4
jJ4l+hPfXk1uy2v5xPprA/fJPwDkkKd1DVtIMoepGcwiuQd+Rl+D9dkbzqW0FSN2
Hp691NDLrtgGyNkU6r4UY7kI9kdvHpDNAdSlh1GKknKOLc5WSxYbskODJCaK72Eh
sXOb6MDWrUWBQCQOl6VQTvirIyTJBj+z1CVf2RfWFBDplZh3HZO85QVyyQLt+2Tt
FV9Cz13irF1BjjpgN76xbvm1dU/+e0RG3+/asfMX86uMwSvRhg0=
=eF95
-----END PGP SIGNATURE-----

--m62MDEjg5u5lTXSK--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
