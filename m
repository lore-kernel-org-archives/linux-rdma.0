From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/6] Refactor RDMA IOCTL declarations
Date: Thu, 18 Aug 2016 14:28:08 +0300
Message-ID: <20160818112808.GD7047@leon.nu>
References: <1471355123-6227-1-git-send-email-leon@kernel.org>
 <20160818110819.GB8590@yuval-lap.uk.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Hf61M2y+wYpnELGG"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160818110819.GB8590-Hxa29pjIrETlQW142y8m19+IiqhCXseY@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Hf61M2y+wYpnELGG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 18, 2016 at 02:08:20PM +0300, Yuval Shaia wrote:
> On Tue, Aug 16, 2016 at 04:45:17PM +0300, Leon Romanovsky wrote:
> > Hi Doug,
> >=20
> > This patch set refactors RDMA IOCTL declarations, unifies their
> > location, moves all current IOCTL exporters to one place and renames
> > them to fix the differences in coding style.
> >=20
> > IOCTLs commands need to export the size of their data for their transfer
> > which is usually declared as a struct defined in relevant submodule.
> > These structures should be visible at the linkage stage.
>=20
> Just for my understanding - this is not an issue only with RDMA-IOCTLs,
> right?
> (Wondering how other modules approaches this).

I'm not familiar with all subsystems, but IMHO, we will find all
possible solutions. While working on the patches, I took a look on
other subsystems and they exposed structures in the same file
as IOCTLs from the day one.

--Hf61M2y+wYpnELGG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXtZvIAAoJEORje4g2clinv54QALroVTr6dBW9qB7Um/v6hsHz
/G2NFLNk/OqmqdF40hHtcxszU53Kf8aK7/TCnmGF0Z1TVQPH+6v0Y7iMWp5VJ6mD
NclJ+RMsO4y15kROy2uBoKk/oC3mjOwvuPMoMGtk7tDKfdmpvo+wL6BEKv6nMr6H
AlMActPfyTY2tE8WO4BpzTMr9LjYs1ZiWNjstP3b5v3dcA8QUxJv7qVAhHh81Mtz
ZC2OmoDMusnwBDa+9Sbw3CVC00hGiwEaGkWleIJLwv0r5kXr/hNHK97fZL6qMOAO
qB4I6nl+3XiplOIupU+wP2rml1rwAFDfDtpAQzZwGSrUtScLwZxiQC+l1nVUNGl3
AKSxnM+UYNPdMsQGvnrezYuxgwnDi1xXzAaN+p3pqKqEACNtU7Lc/KnO1iQwYaGD
cMeuBOgGqs3K8u42vzQ65yB6LvXntNpmTg2LsPuRnNHLcAY9QCvUBdOE2znwuAz3
Lb3tH5M3KH48MC2Wr1Kmj3jphrVBX63j08T9mR5xEK42yryBvBzXwFpZeGe5yylA
FZWEEg5dAFV13S1aiIWiX/k/jMMFNshRPu2IShFtlKLLbhrNRqSPQM9IAsD+A/Ih
QME0Jq0faxATfgFrlfZfrh1RCLf7TMBh+z78HOyph5lEQCTjmvJOlH2wkL36tgbS
+6pjxdLI2PuS4ha3247F
=5DI2
-----END PGP SIGNATURE-----

--Hf61M2y+wYpnELGG--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
