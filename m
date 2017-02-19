From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] vmw_pvrdma: switch to pci_alloc_irq_vectors
Date: Sun, 19 Feb 2017 08:56:53 -0500
Message-ID: <1487512613.86943.113.camel@redhat.com>
References: <20170215074704.2599-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-MRmV4/r65mNwfLiAfe+Q"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170215074704.2599-1-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-MRmV4/r65mNwfLiAfe+Q
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-02-15 at 08:47 +0100, Christoph Hellwig wrote:
> .. and greatly clean up the irq handling boilerplate code.
>=20
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-MRmV4/r65mNwfLiAfe+Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYqaQlAAoJELgmozMOVy/dze0QAKvyKmrm3ok1S6W0rktc1KkT
P0WM7V50DgaGlEWogJ1Yx48DypG997Ki0yj9qskcagzdXTYJl+iKC2hQTtsPDBx4
8KDzg7pjoU23qjZWFOgOURrQLnVpi6gecpWKMPG0O0+zWc82tGqqI70+Yxmdc4d6
rw7wsERgjON2yVKg5OSK/ZpYXyVFq7izDeKoawxxPqWxO6FvawWIODRCBMjxxjYb
oQD+2iNvoYRtX8gvaeihArIaMVAFgpHh6mp1N5F69cD34V38cBHWdybKgiAMZNFn
oexwDyLNqO13DceWOIz6eSyP+nt0DzYJN4MEvsxHe3wgc78OvTLo/pxwc/5wGCIq
H3Ge/SRyiJ6euE4KJyWvNrb0e2A6m60+GeSh/UJb90FsSKIO1sR/CpXZEFC/D2GA
BRKpdT0MCASjqgTam0bADTGBxH8qX6ZaE4dPeb8EkxGeiZxBz1iJJe0b4rFwG4dX
LkfyozmHCk8EdE6QS9tK112yxAL0CWkBBpEMIrz7yuL4RQ8Z1c5+6ZCPxD6KoWqp
ORKhAJuh2D2zXDncEY3RGqtsGwtkEhHlbFMikMq2JqPYq4fMuN8G6kca4nvySIgj
quo5k3cVl4Y8+KPVnJPiFJzxjZTqhLzAjzzLhezenzyOiNHVCIqnMBwLb1LxZeVs
QsrihVfsTqup/VRk6uzR
=tAyx
-----END PGP SIGNATURE-----

--=-MRmV4/r65mNwfLiAfe+Q--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
