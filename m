From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4] IB/umem: Release pid in error and ODP flow
Date: Tue, 24 Jan 2017 14:50:08 -0500
Message-ID: <1485287408.43764.52.camel@redhat.com>
References: <1483599605-24456-1-git-send-email-liguozhu@hisilicon.com>
         <20170105063922.GX12077@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-fn8wmSZQ267wLKmgqby4"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170105063922.GX12077-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, robin.murphy-5wv7dgnIgG8@public.gmane.org, jroedel-l3A5Bk7waGM@public.gmane.org, egtvedt-BrfabpQBY5qlHtIdYg32fQ@public.gmane.org, vgupta-HKixBCOQz3hWk0Htik3J/w@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, lstoakes-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-fn8wmSZQ267wLKmgqby4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2017-01-05 at 08:39 +0200, Leon Romanovsky wrote:
> On Thu, Jan 05, 2017 at 03:00:05PM +0800, Kenneth Lee wrote:
> >=20
> > 1. Release pid before enter odp flow
> > 2. Release pid when fail to allocate memory
> >=20
> > Fixes: 87773dd56d54 ("IB: ib_umem_release() should decrement mm-
> > >pinned_vm from ib_umem_get")
> > Fixes: 8ada2c1c0c1d ("IB/core: Add support for on demand paging
> > regions")
> > Signed-off-by: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
> > Reviewed-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Thanks a lot for resending.
> Reviewed-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-fn8wmSZQ267wLKmgqby4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYh6/wAAoJELgmozMOVy/dOhQP/14de/RqoycXf37qB6GDxoJn
NoZ0PAB1pAXE17b+Q+Pt3XnvHwv94vBcUsMd9QjF437P/r655nOBAvDv+CsMBXLz
ecDk/ybIfTT18Fq605d5pti+zQp1fDIkFZ3aXPiek+v0SXfsnGeOohs/Uv7j5yX2
AYjIvdBEJ1yOB18udDM1uactPhEWPdMJmfitHmo9C/3yTSnaxG9PnymFmqxauMT/
kn7US6WiIuR3Ih10gVOW2FE4CV8l3jpYa+lfCpL5i1lO9vA5F2R4VU+mm7ArWtMt
tQ72it9JkDq4SBkQE8By/qHZv2XOxRHfOnxuw2W9fFum5brKjTHk639JfnCmXNs0
mjtkjSyQCicsjKoUs696rmqnrqphKq1APvQPUX41G2oESmsBH3iwZUvQh5G96FSj
sfONMug3cMpon8kbBClAgBCVRX4ndQKMCAkrMkn7nuwYfCtj9v8VjckE1rGPHZmR
sSdWkBAHPSVjj+YdtAvUvGmWs+Gz0fpxHQfCZsTSylCWOYnqLy6Em8bgvBfcS3mD
sd9mdYebAtRKCnwVuIBsBXHPtMiSdvqyCJKvSlz6QWzZkt4ulWDOl0U2n5KBeRea
qPbzjuY+wQVlX3sRWovHpLA7kZLBs+tnqLrtOMIZsyzcbNkzXPhLzIS+glYZXRlA
2ea8VdNNz2RlmKI/l1ww
=rmMd
-----END PGP SIGNATURE-----

--=-fn8wmSZQ267wLKmgqby4--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
