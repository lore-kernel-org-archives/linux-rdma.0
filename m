From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH for-next 0/5] IB/hfi1,isert: Updates for-next 5/15/2018
Date: Tue, 22 May 2018 15:33:34 -0400
Message-ID: <38faf50391a9bc1a8d874a32ce5857a4023dff3e.camel@redhat.com>
References: <20180516012947.12474.2286.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-rDBDu0ecPqCZc5YkwAed"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180516012947.12474.2286.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>, jgg@ziepe.ca
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, linux-rdma@vger.kernel.org, Alex Estrin <alex.estrin@intel.com>, stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Don Dutile <ddutile@redhat.com>, Kamenee Arumugam <kamenee.arumugam@intel.com>
List-Id: linux-rdma@vger.kernel.org


--=-rDBDu0ecPqCZc5YkwAed
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-05-15 at 18:31 -0700, Dennis Dalessandro wrote:
> Hi Doug and Jason,
>=20
> Here are some patches to go to for-next. One is a code cleanup. The rest =
are
> bug fixes that are probably not serious enough for an -rc6. The one that =
may be
> on the fence is the isert patch. Since it only affects debug kernels it c=
an
> probably even wait till for-next. It has been marked stable though.=20
>=20
> ---
>=20
> Alex Estrin (1):
>       IB/isert: Fix for lib/dma_debug check_sync warning
>=20
> Kamenee Arumugam (1):
>       IB/Hfi1: Mask Unsupported Request error bit in PCIe AER
>=20
> Michael J. Ruhl (1):
>       IB/hfi1: Set port number for errorinfo MAD response
>=20
> Mike Marciniszyn (2):
>       IB/hfi1: Cleanup of exp_rcv
>       IB/{rdmavt,hfi1}; Change hrtimer add to use the pinned variation

Hi Denny,

I dropped the PCI bit fiddling patch as per comments.  Please provide a
more detailed commit message if you want this patch to go in.

I provided my own guestimate of a commit message touchup to the hrtimers
patch.  Please let me know if I was wrong in my assumptions there.

The rest applied as-is.  Thanks.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-rDBDu0ecPqCZc5YkwAed
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlsEcI4ACgkQuCajMw5X
L90N9A/6Az511ObM0PR4CWUsNmv++cp2wFCU+B2RyrQTU7aMGKwtYkZS/Ba8jQtS
DaqkLhM/x+SA675BLHb6Q2ZpYGYZVvf5f6RMu+YQLpjuBQQz3YGfUkQ9cSyXRFvd
fG4zFUN7zddmg+7Ar3jzN6fc/hHSyFUObYgDp4TyNnFyfClLM8iqcfPu1JUZAi16
sAGfL4q22KQiqbfmZ3677rj0y3z3tYmalMrr7r7wkuM6uvW/AndOpKYUemniu09Q
1YNYGY+Y50v9iJxCaswmBWLdfgyPIAYG8SUkLgqhCWFTAGvnkAJe30gN1Yzxy9Pi
17liljq0WDX03Hc0GV6hrrTlkvEY+Bafv7o8fRdq7FZvEoOSpOgWwu1Ts7eKI0Rj
bE+bZVoXiC2aVKU55luJJ0QLttgtUQGcZjWU3KcRPoufiqmXx/UUd75hRUmjyQMg
qp5ElSp6xOlmp8tP61SKizFAW71+9vdd9xT3ZmzBFjZTAPoea78hyWmSSd2+yeP+
d2c/Xw/sAWFcOigxqonW9kKgEmAR2nTWYCg9HNJFUpMA21JPsdf+LjdklNAnuyyh
eeL+rJvEyFqDtIboBxo2Mye5K75+s4/gFis7qDtFXcsjp2kkGwqQmhPQBGo5vByr
jgmU3D5T0/tWtbe/YPs/dfAVWi3IqMbEG57j7ihPNYJI6Jg4BmI=
=eyig
-----END PGP SIGNATURE-----

--=-rDBDu0ecPqCZc5YkwAed--
