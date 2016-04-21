From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/3] IB/hfi1: Fix missing lock/unlock in verbs drain
 callback
Date: Thu, 21 Apr 2016 12:39:58 +0300
Message-ID: <20160421093958.GB26951@leon.nu>
References: <20160420125205.28231.86818.stgit@scvm10.sc.intel.com>
 <20160420130529.28231.58580.stgit@scvm10.sc.intel.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ftEhullJWpWg/VHq"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160420130529.28231.58580.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--ftEhullJWpWg/VHq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 20, 2016 at 06:05:30AM -0700, Dennis Dalessandro wrote:
> From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> The iowait_sdma_drained() callback lacked locking to
> protect the qp s_flags field.
>=20
> This causes the s_flags to be out of sync
> on multiple CPUs, potentially corrupting the s_flags.
>=20
> Fixes: a545f5308b6c ("staging/rdma/hfi: fix CQ completion order issue")
> Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--ftEhullJWpWg/VHq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXGJ/uAAoJEORje4g2clin7aoQAMUSTidWlH7OW23XBofu3PFq
4QLRKUeofTKp+uuEmaP1yC1o1WT2ZSK/sAeUsT9bq6ZJRIefbtTT65EY8+B14PqG
jOwUeACzuw/kcD924ytt1JgKvQNZ5GZ7BZxPZmysIzUA1gUZtxv/tgFgH3aW8BVT
nR9g8Pj5cRi6wT7bMrhWfZonGcngY3HcPHAY6ERw2y/86zHD8BIfeI4+YX19xITL
EP+NXjb2MXEILuoYIKFSkie5pIG64aidn0+WbQpamGGn0qIFx3hQd0I5dsOJB4qY
eHyaMS9bIFA2iq6iiqc355yY941sM9ZF1xUWrXmiFnJgVLpnH4LLFzNtmTpSaACI
6BHEsrxHXpy4wr1/lHTv4NMxRCTFXL+tPq4sNaDv/+7e6T0munDg7LG+cnlXup8O
xpNefZqQV6h02tKTuBWU6NG10zgyqmK4U066lHkZouxIs1F4heL0bF0jR2/JyYpc
4Fss+rO1H26wWxTccIbdDdUPQ831QEeL1/bgau247Cjr4sdqyJi43FKzKapdTo54
h97Ru7+lhcmyISIGDhjqfX7cHp1HGTEJHWldElRqCdOr6CRtRE0EK2201z8+n1ud
cTTiX37Rv/91hQ9O37unFhelMnpPzR1dwNPkviLjud69seOtgKT+4qvfVeid/9hS
vicWiJeRGZgu/RWe9z5e
=hh9X
-----END PGP SIGNATURE-----

--ftEhullJWpWg/VHq--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
