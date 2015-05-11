From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ehca: use correct destination for memcpy
Date: Mon, 11 May 2015 17:09:40 -0400
Message-ID: <1431378580.2407.528.camel@redhat.com>
References: <1431355082-29290-1-git-send-email-hofrat@osadl.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-URQORkTtxU0MNoDlv/TM"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431355082-29290-1-git-send-email-hofrat-Q945KHDl0DbYtjvyW6yDsg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicholas Mc Guire <hofrat-Q945KHDl0DbYtjvyW6yDsg@public.gmane.org>
Cc: Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-URQORkTtxU0MNoDlv/TM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-05-11 at 16:38 +0200, Nicholas Mc Guire wrote:
> Using an element of a struct as the address for the memcpy of the whole
> struct may introduce a buffer overflow and does not help readability eith=
er
> simply pass the real thing as first argument to memcpy.
>=20
> Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Nicholas Mc Guire <hofrat-Q945KHDl0DbYtjvyW6yDsg@public.gmane.org>
> ---
>=20
> passing the first element of a struct as destination triggers buffer=20
> overflows warnings in tools like Smatch.=20
> ./drivers/infiniband/hw/ehca/ehca_mcast.c:ehca_attach_mcast.80 WARNING:
> memcpy copying entire struct to first element
> ./drivers/infiniband/hw/ehca/ehca_mcast.c:ehca_detach_mcast.117 WARNING:
> memcpy copying entire struct to first element
>=20
> Simply use the structure rather than the first element (which could chang=
e)
> which also help readability.
>=20
> Patch was only compile tested with ppc64_defconfig (implies
> CONFIG_INFINIBAND_EHCA=3Dm)
>=20
> Patch is against 4.1-rc3 (localversion-next is -next-20150511)

Applied, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-URQORkTtxU0MNoDlv/TM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVURqUAAoJELgmozMOVy/dcVEQAKZ2lsW+KePcS7G1nWsl2X6o
IiEZ6M1UT0XHxEPNrxnBpFhMdRG6dlTWxVHaOEtjY1p1aESJG9If6x0Xz06wzGSH
koPzcUxVDSPjI/91KpwZp5JN/fQLaSU1ukqpkeKcexKIJ8Wv9yJuVcEzxbe9sQSn
TUSNq9lIN4DGrIDw4Qn9a74qSc4pThvuwblNaTyxJRG2s1oTVn6f+UgGvyfFVtBR
NhfJYOPffmSt0rG8LnWIBaaEz98UuFJg29AlI7xQK1VFkShEXbGSGyZgOU0K0xOP
gnVh9hVAzZyX8eySujMIqjsiXJmw960DaffYuBeifu9HwYt0CtvNFZgZW2qPn6QZ
X8ZEWDgCcUtefK97CTRw6qRLPOuAbN5R2sdTrbYTcrm0UQ6V43uDgxGbyhwk6vz6
osMRvvUtlnxCFT2RqCOPe4IRrTtGbRGZ6pdCxjX1Wr029wtZVu0EJVUDLuETaWYv
buWR81v3mqLJyf3+BlGayTYasi8WlQ26CJ9GyabCM+FYHKJO12kcrki9wC4L4IJF
UuHY7EZMPffQwPVIy5FN6cf6vo0y+lovMi93g+hkOgFWzIJfsDXgCzZmZ/36SxLq
cRR/Xl7c5HrgXROZuuTYd2JoouJvs+RL2M4nv+zurbULrVb5kw8RX5iGa6hq1+xP
FhZrXEtYfG8tuNCR1H/E
=OqHi
-----END PGP SIGNATURE-----

--=-URQORkTtxU0MNoDlv/TM--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
