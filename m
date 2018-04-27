From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] infiniband: hw: hfi1: Change return type to vm_fault_t
Date: Fri, 27 Apr 2018 12:10:50 -0400
Message-ID: <1524845450.11756.52.camel@redhat.com>
References: <20180417142358.GA30972@jordon-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-UOjEzJ7ImfOyYRj4wANO"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180417142358.GA30972@jordon-HP-15-Notebook-PC>
Sender: linux-kernel-owner@vger.kernel.org
To: Souptick Joarder <jrdr.linux@gmail.com>, mike.marciniszyn@intel.com, dennis.dalessandro@intel.com, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, willy@infradead.org
List-Id: linux-rdma@vger.kernel.org


--=-UOjEzJ7ImfOyYRj4wANO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-04-17 at 19:53 +0530, Souptick Joarder wrote:
> Use new return type vm_fault_t for fault handler. For
> now, this is just documenting that the function returns
> a VM_FAULT value rather than an errno. Once all instances
> are converted, vm_fault_t will become a distinct type.
>=20
> Reference id -> 1c8f422059ae ("mm: change return type to
> vm_fault_t")
>=20
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>

Thanks, applied to for-next.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-UOjEzJ7ImfOyYRj4wANO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlrjS4oACgkQuCajMw5X
L90pTRAArkRlxPyLJzGQP28L1BywmBRYzBKI92fWL7aDsOjqNi+9jG53IPrHvnln
85Y+P9TPp6uSNR2Wl6XpYDwszZvHyWvCs0HsdG7tQmySg/OowIWNJe0vUeChpwGK
txdw/MjP1JJZs+qwINU1S+UnX6JBjeayHn3gwLwC0NX1hIHDk88thihZIgPB85Rq
jmfQIUjOz7AKWMcvcmEnldSD//i63mHiPSV9zeEqwxm4TYaEfusJyOrESQDMTHrj
wagYrVoQPgRuadg6IBKmoHul6/KKy9Ejwn+FA/R7ImOH1Kcr94wQk65AuSamUzCb
RGgrcWr7z3vs6pMQJ2QH6SwIc+wnnYG7sbMRXHmwuWOo27nxATxz5WE+KGrHyfmz
6l5Pa5ifiGolbOlZTHgz2O/frj+0KAAyBKoDvE7qCXa99xzvbOPYR8poYhEKuh8Z
YZmauGgmljOKfI790PO7TkAUW8F52ISkOalkg7wfJvwMt3vNNjs5QhjBTAL+zBKS
sy5UdTPeTLc6PwdW5arq0N+1nQdCTu/enddysYhIl97g8rq0kR+0ZJO6zAUPen5X
4mwXLRByBfuBbxBpyV2Bm5jiyxvmyDWgqqYyRI/51pPc38r3A9jJ0uA5g9nHPvF5
AHAyb3jYa5B7PLrMEH5ZCzKuMGdSL/kgHQnIhJl1tqAEATfHlo0=
=5eZk
-----END PGP SIGNATURE-----

--=-UOjEzJ7ImfOyYRj4wANO--
