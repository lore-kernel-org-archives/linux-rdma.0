From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/qib: Use memdup_user() rather than duplicating its
 implementation
Date: Fri, 19 Aug 2016 18:41:06 +0300
Message-ID: <20160819154106.GC18515@leon.nu>
References: <620b3961-6e05-6638-4ca8-18766acc91f4@users.sourceforge.net>
 <32E1700B9017364D9B60AED9960492BC2D0AF815@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="s9fJI615cBHmzTOP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC2D0AF815-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--s9fJI615cBHmzTOP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 19, 2016 at 03:27:20PM +0000, Marciniszyn, Mike wrote:
> > Subject: [PATCH] IB/qib: Use memdup_user() rather than duplicating its
> > diff --git a/drivers/infiniband/hw/qib/qib_fs.c
>=20
> I would be even more aggressive at reducing lines of code.
>=20
> For example do direct returns when ok to do:
>         if (pos !=3D 0 || count !=3D sizeof(struct qib_flash))
>                 return -EINVAL;
>=20
>         tmp =3D memdup_user(buf, count);
>         if (IS_ERR(tmp))
>                 return PTR_ERR(tmp);
>=20
> The bail_tmp: label is then not needed.

You still need to free tmp allocation if qib_eeprom_write failed and
this is your bail_tmp.

341         tmp =3D kmalloc(count, GFP_KERNEL);
342         if (!tmp) {
343                 ret =3D -ENOMEM;
344                 goto bail;
345         }
346
347         if (copy_from_user(tmp, buf, count)) {
348                 ret =3D -EFAULT;
349                 goto bail_tmp;
350         }
351
352         dd =3D private2dd(file);
353         if (qib_eeprom_write(dd, pos, tmp, count)) {
354                 ret =3D -ENXIO;
355                 qib_dev_err(dd, "failed to write to flash\n");
356                 goto bail_tmp;
357         }

>=20
> Mike
>=20

--s9fJI615cBHmzTOP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXtyiSAAoJEORje4g2clincbgP/iFbR/NRNIxGPptRYwx90xC5
soZ+DM84KHB380vWv2WA1iSgYEE/l+Z0G+FGKmJreFfrLKvW82WIXVpNU1Jx4bNi
Qa+DjR6vxUlae4C53ySTzqTEYeb3OHAWkIL2Ahr5CqPfqELS8ASkoSpJt/jGya4Z
H3XRybyLjmTOifoNOD/BPxba3bWqehmvyMb7i3PLvPLT6Jgnk+YbR0khIj4CHIpS
88zVrLZdFKyJetf5WHbhLUMNAI+VrZVBzEtgpPxPCqm2LFl4ns1wU+YrYFHDYqBQ
jQmGF9u+Mh1Q3vTRFNw7M3z1jptMIVS3c3P7Ufj4VFZcvsFt4jrC6e47JzEwCw/d
5iPQN2+8s7z6FCVvXaiVaOo2Qg4SSh2qM+CKj7dgAHicFfsLivMJEzfL0B8L5cyC
Q7UoeQOBn+CxPZUbfm4g1YmEsrrWeYEMfNOc/z+56iuTUo3JsiXmF/pvn/Z01w/K
A2c7SCrflBHdlmYaR0ad+dnH/BBI9+4dtzwegE0fvYNtj/EYlWpncQx9LgzuMxHL
fN/RJutNyz2mY5Wid9xZwN/5XEp8VsRW09SfpElZIlX2bKdoOrqkgntQt2m9aYS+
YxGZMLd2maquSsj4kKjyhwAfv+3+5sMSbRSkBbO5Ckl6rZvNcrNCLBybltIp7CB7
ityeVW+uGfrjn+cIpt1Z
=BUSs
-----END PGP SIGNATURE-----

--s9fJI615cBHmzTOP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
