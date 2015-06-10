From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Don't advertise SA in RoCE port capabilities
Date: Wed, 10 Jun 2015 12:06:53 -0400
Message-ID: <1433952413.71666.14.camel@redhat.com>
References: <5577F72A.2070008@mellanox.com>
	 <1433925815-19725-1-git-send-email-monis@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-zQ8cY6UD5SyCEzd7UyKC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433925815-19725-1-git-send-email-monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-zQ8cY6UD5SyCEzd7UyKC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-06-10 at 11:43 +0300, Moni Shoua wrote:
> The Subnet Administrator (SA) is not a component of the RoCE spec.
> Therefore, it should not be a capability of a RoCE port.
>=20
> Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  include/rdma/ib_verbs.h | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 7d78794..7725cee 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -381,7 +381,6 @@ union rdma_protocol_stats {
>  #define RDMA_CORE_PORT_IBA_ROCE        (RDMA_CORE_CAP_PROT_ROCE \
>  					| RDMA_CORE_CAP_IB_MAD  \
>  					| RDMA_CORE_CAP_IB_CM   \
> -					| RDMA_CORE_CAP_IB_SA   \
>  					| RDMA_CORE_CAP_AF_IB   \
>  					| RDMA_CORE_CAP_ETH_AH)
>  #define RDMA_CORE_PORT_IWARP           (RDMA_CORE_CAP_PROT_IWARP \

This looks like the right fix, thanks.  Applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-zQ8cY6UD5SyCEzd7UyKC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVeGCdAAoJELgmozMOVy/djhUQALJuxvPXBDoZGzLeE0B+2NDn
iqxbqCsvR8GkhXzOhnUSrioMw7S92ymJOUZd6kWHvwtbyRcn9LnADaesp+p/7S3B
6oIHuuvZyQnGqpLFKkqedoJaKz9K2W7+E7aZYzY06Rp3YyCuQZEJ6r9gl1dZ4Bjx
+ZNTYz4HDZK1nF8Wra+9sgqLLf7XC6R/P4BTv2QPUUOQyQW4Spm2Qeem6tQd413m
HyAG9sZurH4KPN3cb8a4bnRlJnqMndNaG25KGDioaw1oFrnpUM/Q3p0Gab4mTY+E
kw6YiZNZ+ZqGnsBvVWWJirQ6MdsPuSOZTjNpKtadfgCaSHyIhGvkce0zVB5l7iPs
h2h4haTgqCpjPb1MAUmLvodar4IkcEMkVWQxDS2GM/lwd5tCZM2OFok9eb3CNn3v
4EQSdLfK8RsO+wD4/pSah4Ke4aOC3aBOwFXT+9DbxkFs2aZrbzEAGl+N7q+cc1Lf
EJts5I6eIObvF8yzYScn/fFeSaD3HWM+iYC6iADer9ZWNxnbSDHI8LdoOVZXRNs4
P/qyzJxjEvapDv8m8w75VUJ07MjS23eN4jzYjicB5Wb0WCS2rB/wy/yCw5f71rRA
YBTULG1KgVhCLN5AApUEUhF1etR53bMs+YP47lsC1fYE2NgJHvuu0ZWcZ4gre6OC
EjlwK4jyxb+s5LCMN30Z
=xFAy
-----END PGP SIGNATURE-----

--=-zQ8cY6UD5SyCEzd7UyKC--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
