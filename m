From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] infiniband: hw: qib: Change return type to vm_fault_t
Date: Fri, 27 Apr 2018 12:11:05 -0400
Message-ID: <1524845465.11756.53.camel@redhat.com>
References: <20180417143428.GA31255@jordon-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-vqICE7gXW9ndRCg1Qugc"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180417143428.GA31255@jordon-HP-15-Notebook-PC>
Sender: linux-kernel-owner@vger.kernel.org
To: Souptick Joarder <jrdr.linux@gmail.com>, dennis.dalessandro@intel.com, mike.marciniszyn@intel.com, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, willy@infradead.org
List-Id: linux-rdma@vger.kernel.org


--=-vqICE7gXW9ndRCg1Qugc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-04-17 at 20:04 +0530, Souptick Joarder wrote:
> Use new return type vm_fault_t for fault handler. For
> now, this is just documenting that the function returns
> a VM_FAULT value rather than an errno. Once all instances
> are converted, vm_fault_t will become a distinct type.
>=20
> Reference id -> 1c8f422059ae ("mm: change return type to
> vm_fault_t")

Thanks, applied to for-next.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-vqICE7gXW9ndRCg1Qugc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlrjS5kACgkQuCajMw5X
L92cMBAAmAcIlyzeUCYmQEeisM8hSSIp5GZrIs0HY4R6UAKv7mgGxwljEQLTsYpu
ckDb67mmfVFE7VjRvvhMmVIF/XFypEgzyGsIkztnkr3O/mC3MDm1QlONs39+/o4P
l3cOKhsheggwCwuSMuH02j1rIii6JXneDNWbskVq2ufQG/7dsNTug1CYkalwaCGM
n4fJC8ztEODzYxzqT7dAnw55GMt6GnjaO7SIgv27hazmvDr+e2mq5ucXmUeZZcgv
GofOJrFmdiRAIKsloj2lQI5eW/3hw/ps4OPehDAblQ8tznl1VocIsKbYssYFsFpW
lcdUr1aJJgEAF468JxER5L4tycluU4wNEZo2CqnxZcjom/UQM4S79nUEfQQGktQB
E+SuwIxnSGqvoPdIDXR3esIhchzyBimu8XRMQVgD/GgcQfAnaQiwB+bGn2UJ76TN
FhSh1WVz1NMJuYwBeDXSmCu7XPvqPBXIqtuWTXMAMZUmO1plystmN9MqposyQ8bJ
/R8zMYCgEnimiVnp0Lygxq7d2aG1Hw2qEsQh+fdfRjI0qAxPB/bp8are7DSiv2lf
PxtjzwXX5AFmacbV4RcJBHy5wj6Nq/WNSe4n/t+ZXfKW6pu242pj/ZUjOiV6PaDX
M5B2FcNZdA3RnNSbvjXUoVlizJc6ERmM35GLZFk5KJrTMTlc0Wo=
=zt5B
-----END PGP SIGNATURE-----

--=-vqICE7gXW9ndRCg1Qugc--
