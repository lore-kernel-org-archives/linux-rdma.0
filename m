From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-core 08/10] i40iw: Control debug error prints using
 env variable
Date: Thu, 8 Dec 2016 20:48:13 +0200
Message-ID: <20161208184813.GG9722@mtr-leonro.local>
References: <1481221001-1044-1-git-send-email-tatyana.e.nikolova@intel.com>
 <1481221001-1044-9-git-send-email-tatyana.e.nikolova@intel.com>
 <20161208182225.GA32232@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="BQPnanjtCNWHyqYD"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161208182225.GA32232-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

--BQPnanjtCNWHyqYD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 08, 2016 at 11:22:25AM -0700, Jason Gunthorpe wrote:
> On Thu, Dec 08, 2016 at 12:16:39PM -0600, Tatyana Nikolova wrote:
>=20
> > +extern unsigned int i40iw_dbg;
> > +#define i40iw_debug(fmt, args...) \
> > +	if (i40iw_dbg) \
> > +		fprintf(stderr, PFX "%s: " fmt, __FUNCTION__, ##args)
> > +
>=20
> No, this is an unsafe way to use defines, wrap it in do / while (0)
>=20
> I would also welcome providing general infrastructure for this  -
> every drvier seems to have this same basic approach.

+1,
The amount of copypasta in rdma-core drives me crazy.

>=20
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--BQPnanjtCNWHyqYD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhJqtAACgkQ5GN7iDZy
WKeRoA/+Nan7MULL2REUAAqB/r3AZ/wFeMnDJ95p2a6OxS724kBY45sMIQ8HF0g2
xNvKUfQAeuem5kJdpGLmgYCHImYch00xZTUi8g7WhILUL6v6B++3zAodxbRgCyF7
O1076rJAm5djevUfBeaXdMekEE8YRsgxqyeznrQc/jb4XxOpVFR2ErnXWEcgRiKs
dcPU8Im/K3+RzvCesNnGHPSNIED0POvwUFA6QMaKspNXZwb8B1bOsWfXBAB9hHav
KWRmSG/e/VTdBn9eoKmoL4nc0SEzk3oNtwb5FlLdStg5TpfXkhPwj/2Y+NQd6vp6
jZbF63AU/nu4NL+zIFNoumuMDWAnFIfxV0PKMRvjBVl7j6rTnVdNhxXEZA2xMv8s
8Ch3NGyHadAVzeKmLF5D4cG5ysN2NzF8biUZwL9ESkdYFjFl03IX32d4xvOZIdhA
wN8qKn0RznpIItwE0Gk+c5XVyHpwTpZQXTBSNPMBuUCUofn/hmA4nRJaiPr8lWLb
cSBYLsV8qpHKxXCh9OCxPcqYW7S5l5q6pETt8JxluD+DoLoosiXa4Mpu/NBp92sz
kgJ5EK8t0673iyO1m7QBTQ9+NSD9yFrDIffAkm+HJ9HuMqwpwOv7RuLEwSNV/sUt
m4Kmd1uzuMZXD/GzOAn1030srDH8nRhkMTCp7ukMM5ONhzznAVQ=
=jYXU
-----END PGP SIGNATURE-----

--BQPnanjtCNWHyqYD--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
