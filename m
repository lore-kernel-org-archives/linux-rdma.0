From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4] IB/qib: fix test of unsigned variable
Date: Tue, 12 May 2015 13:49:30 -0400
Message-ID: <1431452970.43876.68.camel@redhat.com>
References: <20150512174242.9547.82789.stgit@phlsvslse11.ph.intel.com>
	 <32E1700B9017364D9B60AED9960492BC2570FF8A@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-v3WIG2P6YlHn6/AE9Z23"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC2570FF8A-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-v3WIG2P6YlHn6/AE9Z23
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-05-12 at 17:44 +0000, Marciniszyn, Mike wrote:
> > Fix the issue by changing the type of wc_cookie to int.  For the succes=
s case the
> > ret left at zero to avoid a warning from the caller.  For failure wc_co=
okie is used
> > as the ret.
> >=20
>=20
> Just commit message change.

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-v3WIG2P6YlHn6/AE9Z23
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVUj0qAAoJELgmozMOVy/dF+AP/imoQ5mRqPHNcYQiEXSD5OnG
jiY7UuITHcZzuWTWUFPSLevwGmXz0ACqGn4ZyCYf5PUM22W46SSz+Ktj/ynXHIH+
4eeLjqjm1bHOjiYiagubOQ1oIt6mxTncMarLLOi1paL2fOqyvb1yRjc+tCKOo2qL
ZmzsioMOngd6BoWeAKaQPWCzXL4kXDc8FnFAqVJB3N3YVNzm1ahGAV62i0fw9vNp
p201TIGO6nsxWkHJTrbf9NrDzygB93DqW3FzPQq6bE/HivLgPqfAH8SeHZSkbbK2
6MuE+2e7c9v0ajURImLQm0yy4K4o6QQBmU+ies5553LRx3KTKZNy4JkXGBZilv2k
xvvQs5Ulo7tMtztMfIoU12uCQu/Wp+T/W5LnsqISLebJsgKPHnjy7m9e7q4GUyNx
Loh+21F7HtWfhITxuvdy5nzNO3qdNMxoZSVlX1MnpAmf2TPl4ix08kWl4H1ZnfHH
rXGxCCW4FLASy9aw257C7TRtsBE9YsbG/cMmjCHt7xxvNJi5iTdP0/EwdHJyl+BC
rhwYsgc/E6Jm8NPKrrhZhmBJSEyCAyd4LpDyst7JHcpWC9ONcuZTy0s8xc3kO9iQ
sdn+mSXkVcapSdNgmypPOVlPWHzpTjaIjXz+t+8+N79Wmk9DSmgJ+ytSrpG2TFha
M58zgLKUcVpDCtbhfaD7
=gm8V
-----END PGP SIGNATURE-----

--=-v3WIG2P6YlHn6/AE9Z23--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
