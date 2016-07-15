From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] Use smaller 512 byte messages for portmapper messages
Date: Fri, 15 Jul 2016 23:48:28 +0300
Message-ID: <20160715204828.GB10556@leon.nu>
References: <1468602052-63692-1-git-send-email-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i0/AhcQY5QxfSsSZ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1468602052-63692-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--i0/AhcQY5QxfSsSZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 15, 2016 at 12:00:52PM -0500, Shiraz Saleem wrote:
> From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> Reduce memory footprint by lowering the portmapper message size
> to 512 bytes.

Can you please add two things to the commit message?
1. Previous value.
2. Short justification of Why it is safe and needed to do.

Thanks

--i0/AhcQY5QxfSsSZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXiUwcAAoJEORje4g2clinkbwP/1xjEWQ2crhs3AFZg6mZtJQu
pe7EMB2PcDKyT6MVTwli0CQgrxSSGPHq6A+7dqPfo8QCHnNmX4ZZffIZrmgmx1Gn
XSx+bH5DYGi6f668Ys90dWDRBAH/oms3B8sI057irZbtiTHm9QPmMZ7lY46zXb4t
cSz4dGgbmoE45cuIVSczSQydB+/bQL3m4mjwdSVwHqYr8YrtvUGF0XRNgnWUiWDP
qOIWiydKQ8DNd+t9gCGGiWuJiqx7AbbQcB6ORvRKosHbAtOeAyDTWnlFnTROcynr
JDYAUR8Vulw6HlCSLUTL9SowewsMxTgqjv3s7ue8Ck4GcUV75TyaG0juVJreyFcU
0eScEsvm0ojt6JpzfZa7voLhFCml1SvhY4RDWSRAKw3T0S1ReANFz0eZGp9cUkVw
mINRVYIXsSu3f4kObgPnJzFGdOwuFrioNg5qm8ojoqitQISRqHN5SUExP9E49YiO
cjBFpKeVSaf5eiXpo3jH05gKj5slsnlr0y8Ms203jHPKtPnxgw6QPDW3T5H35K5E
Z9HevZ0w7qXk5EUbrarSsa4TOmzMxE9ogWxUHip4J/JAX7p7suqQX3nSeKzbBaTT
R4GdbVLREf2XiIYB+waGkl59J53YyO7ZTInezOeHKVHZnc1wg6ASr2RdD7K39Mxz
sJ4WloZSCB0t0k4YwN6E
=/jZR
-----END PGP SIGNATURE-----

--i0/AhcQY5QxfSsSZ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
