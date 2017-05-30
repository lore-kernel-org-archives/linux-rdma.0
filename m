From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [ANNOUNCE] rdma-core-14 release available
Date: Tue, 30 May 2017 08:26:15 +0300
Message-ID: <20170530052615.GF17751@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="d6nDKxlhctiV7bVq"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--d6nDKxlhctiV7bVq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The rdma-core-14 package is now available at the normal place.

https://github.com/linux-rdma/rdma-core/releases

Version 14

@rleon rleon released this 35 minutes ago

Updates from version 13:

	AARCH64 compilations are checked now as part of travis build
	Sparse checks were added to travis
	Introduction of bnxt_re driver
	Multiple fixes to Debian package
	Rework srp_daemon's systemd integration
	Various fixes in qedr, mlx4, mlx5, bnxrt_re and rxe drivers
	New supported PCI ID were added to mlx5
	Addition of manual pages for cmtime and udpong programs
	Multiple fixes of spelling types and documentation clarifications
	Sparse fixes
	rping gained ability to bind to source IP address
	Various improvements in cmake and cbuild infrastructures
	Add support for flow tag, CVLAN and VXLAN specifications
	Provide ability to pass private data to create CQ
	Exposure various device capabilities to user applications

Thanks

--d6nDKxlhctiV7bVq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlktAncACgkQ5GN7iDZy
WKdkNw//aFnrP1EyexnSZaWzZ0dPAB3vA23F+orfl6JMPNHdyEkE/wzvxKterJF3
3htDaHt3spWvYjhMaMG23w9NwPoF1Xor3QPVg3/j/z4l49tFiWxLCpWjLeDDp3U9
LMFvMI6zkfYxgNjc/3A19Fa0X84CX5aD1tZbben69mj2CltmN5Ym8wFma8sIc128
4qGrO7sXt0dCOdtOFQpsA6nQKWVMw6UxGCC0gsO17IFvaxX4k1aYNbzRvsHb4AX7
piGj7ONPoYxYEIIP8Xy7NYMf6jIYoRWvo1Z2khegc6jFjNAhfVlJr0574AtWLQhl
ypivr8MCVT550L9VWF5qhxLH5Kmwu93hZQQJPLbGmg0ctcWx49CcmCysHVF7PicD
7Q8lV8dyfDl+DW06KUh6c6onr7INVNc3UbCy0m46dM2scgEpxEqbUSug1pP4wk6m
hsO3pM0yMMBXSSk9pWKADq7oIA5UD9teCjxlO+/XK65rKA5CERvwXQOSXAV720CX
aelvSggkeLnrXg5fR9IA7wqZp4x5cq3urMrPqgFgShKPmdV6q8nbzfY8V0f5vE1R
fEZVvOZxeTQanQljqEMISndNaIa2V9dGzmvcPOBw1dZ9VAvh639jX7CAptN3zxo2
F0w6XHwcc1+GhzmyHa9BKp+VKy1AOS4uqsLnRp/kJnCKFQMvsvY=
=66HX
-----END PGP SIGNATURE-----

--d6nDKxlhctiV7bVq--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
