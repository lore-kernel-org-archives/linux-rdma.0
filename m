From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3] i40iw: Add Quality of Service support
Date: Sat, 03 Dec 2016 15:51:57 -0500
Message-ID: <1480798317.15032.72.camel@redhat.com>
References: <20161011021210.21776-1-henry.orosco@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-TD4JEuIQwYvxlkU4l1JR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161011021210.21776-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-TD4JEuIQwYvxlkU4l1JR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2016-10-10 at 21:12 -0500, Henry Orosco wrote:
> Add support for QoS on QPs. Upon device initialization,
> a map is created from user priority to queue set
> handles. On QP creation, use ToS to look up the queue
> set handle for use with the QP.
>=20
> Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-TD4JEuIQwYvxlkU4l1JR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYQzBtAAoJELgmozMOVy/dUZQP/iuQE9ANz1okoFSxkTaktJSU
1RaxxbL5kIHdCoQtY0Zn0cPmcs6bTf0vznFjCpuH13Q+HpKsvEZufxvIP/2CjS0J
8GwOg+nYhRr8MBOYFVH7gMW4fDHWakwCb/QW44Hwp3M50f6lTgNYGlYJp58b39N5
0id2xHjnjJk8B/RC2FDSbAhn8yVLqAjcuq65YXn6dM5uWqGllCX6G0seKstyKDQu
VQbqcdPqM9sX1R5om3voxcK53+nRelCAnqIpovyAX0S1cN0olfmlBJ1IUWmpo4fQ
1h5yLHT8X7MnR/xkuelqN/rr3tqofgqOTXE9Kt8oKjMiamaJts+sh5xrfIAFUOCZ
dT/2yt+jPAojoHy13GTxXgpVeGfohz8y04PFEGCZ7pc1H189o6P+96fjKhd20DZP
5WFSLXg3jyMhd2+D6ZbK0IIdwpc0pSSq+XqJhanyfIfygjSYBpmI2nxf1EsboICL
YvCGLpInGWBlO43RyOCVIBY9NLFhqdRJZrgLWSKV3Jl6wGZIaV7x7K5OV8059OD+
g6olQ3GjlpbPkFbfngx7cp/YLq8sb0RT/T+nAnNOSmC47ppgKauq89PdX1sldxhu
GgXrH35aY58MV0xg9av/ROfwCIPa2Z8CAV7zDszAkfExzSXOnlhYCTlwV63YQEYv
W/ZE+nShBVqgvxCA3NRt
=QsmC
-----END PGP SIGNATURE-----

--=-TD4JEuIQwYvxlkU4l1JR--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
