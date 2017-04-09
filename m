From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 00/14] RDMA/cxgb: Fine-tuning for several function
 implementations
Date: Sun, 9 Apr 2017 09:30:06 +0300
Message-ID: <20170409063006.GO2269@mtr-leonro.local>
References: <0aff92fa-2891-333a-2e1e-ca309db2ec72@users.sourceforge.net>
 <1491416174.2923.3.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rPgHZmYkQ+bUEpVC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1491416174.2923.3.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--rPgHZmYkQ+bUEpVC
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 05, 2017 at 02:16:14PM -0400, Doug Ledford wrote:
> On Wed, 2017-02-08 at 22:10 +0100, SF Markus Elfring wrote:
> > From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> > Date: Wed, 8 Feb 2017 22:00:10 +0100
> >
> > Several update suggestions were taken into account
> > from static source code analysis.
> >
> > Markus Elfring (14):
> > =A0 Use kcalloc() in cxio_create_qp()
> > =A0 Rename jump labels in cxio_create_qp()
> > =A0 Use kcalloc() in two functions
> > =A0 Use common error handling code in recover_queues()
> > =A0 Return an error code only as a constant in ep_open()
> > =A0 Return an error code only as a constant in stag_open()
> > =A0 Adjust three checks for null pointers
> > =A0 Adjust construction of two error messages in recover_lost_dbs()
> > =A0 Use common error handling code in recover_lost_dbs()
> > =A0 Use kmalloc_array() in c4iw_id_table_alloc()
> > =A0 Use kcalloc() in create_qp()
> > =A0 Delete an unnecessary variable initialisation in create_qp()
> > =A0 Rename jump labels in c4iw_create_qp()
> > =A0 Rename jump labels in rdma_init()
> >
> > =A0drivers/infiniband/hw/cxgb3/cxio_hal.c | 20 ++++----
> > =A0drivers/infiniband/hw/cxgb4/device.c=A0=A0=A0| 83 +++++++++++++++---=
------
> > ----------
> > =A0drivers/infiniband/hw/cxgb4/id_table.c |=A0=A05 +-
> > =A0drivers/infiniband/hw/cxgb4/qp.c=A0=A0=A0=A0=A0=A0=A0| 48 ++++++++++=
----------
> > =A04 files changed, 75 insertions(+), 81 deletions(-)
>
> I didn't see enough value in this series to bother picking it up.
> =A0Steve, if there are any patches out of this series you actually want,
> please collect them and forward them on to me.

Hi Doug,

Can you please use the same pattern for ALL Markus's patches?

It is too time consuming to review his changes and it gives a very little
actual value.

Thanks

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> =A0 =A0 GPG KeyID: B826A3330E572FDD
> =A0 =A0
> Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =A01274 B826 A333 0E57 2FDD
>

--rPgHZmYkQ+bUEpVC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljp1O4ACgkQ5GN7iDZy
WKczKg/+JlXVJ3xYK82LU50f4OUxQePCt8Qbj10ZjeA7jGmK3MQEqwtvkfD/O8KH
ybwxPlmCRcZIoYHbfs6WMHm5av0c5td970eEZnv6K9CNsjjtXqPgfSfQR5zPydie
CFCfXgH75g43YIctXiwWzXND5IAnV034koRALenLHcLFSNbaqNbriQ06QKbx2McI
AAGiwyPF1zwum+NR2OehQVe48Ocb2Tuv6lCBGHEQnvuxaBIi4BOccDcYlLcSpmrW
6QDhPBDtbkkmBt2CF7OBTzt/NU944e1z89Tn6DmZC6ah80s6+6ogR+urwRaswMnU
UomyFT1GPD5LD4jp3VXx6je+P6A6V63c9FImr0tN8SPfAHLCcFDSf9+8KqVPqd23
iWV0f3bDRDkkTr5hLolDrUaA+vMCfZZBf+M3yquoPKUmILsUrrbxhPD+JDT9o2X9
TrVFgWRtQQXDuQnIp/Ns3PRsyy1JJVH4FOcjqiqpQp7B21bzjyS+l7WP8rl1zPsh
VaqTQkbpVyIVvRhwEIQ+uDm4J8KhfZgEzxhFdVNI6Ow0ZHSBLjw4mNKEod/et4Ts
Sz0TmlSPD365oNe1Xv639mVXXXEj+FMrfkzkYev52uatYQBUaVOVNy8ue23uxaIE
A40zTUjbg6RQXNqAXk6yq7IDQryrcJw0bvHNI9oGBCIKoPDhucY=
=a5yT
-----END PGP SIGNATURE-----

--rPgHZmYkQ+bUEpVC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
