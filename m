From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 0/3] IB/srp patches for kernel v4.16
Date: Thu, 25 Jan 2018 15:00:31 -0500
Message-ID: <1516910431.27592.190.camel@redhat.com>
References: <20180122222713.13197-1-bart.vanassche@wdc.com>
         <1516727351.27592.46.camel@redhat.com> <1516743303.3339.36.camel@wdc.com>
         <1516895274.27592.125.camel@redhat.com>
         <a136f97d-cc29-3fb1-6692-770eb11eba13@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-mfPWtWIcRlAgASrRwWtM"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a136f97d-cc29-3fb1-6692-770eb11eba13-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-mfPWtWIcRlAgASrRwWtM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2018-01-25 at 11:06 -0800, Bart Van Assche wrote:
>=20
> - A filesystem or other subsystem submits a request to the block layer
>    core.
> - The block layer core passes the request to the SCSI core.
> - The SCSI core invokes the upper layer driver (e.g. sd or sr) to
>    translate the block request into a SCSI command.
> - The SCSI command is submitted by the SCSI core to the SCSI low-level
>    driver (LLD).
> - When the command is completed, the SCSI LLD reports this to the SCSI
>    core. The SCSI core asks the upper layer driver to post-process the
>    result and next reports the completion to the block layer.

That's how it used to work too.  It just never had a struct target.=20
That's new.  And the per-target queue setting is new too.  To me anyway.
 But it has been 10+ years since I did anything of consequence in the
scsi space.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-mfPWtWIcRlAgASrRwWtM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpqN18ACgkQuCajMw5X
L922PhAAwohl2vLSG6BCTDl3GeIV6hye2lKS9f54aPblO5KU9Rg/6fjWV+RvFqhW
IVDM7vvBXZkZPFGItlBd+83jv2cfoz/ISd4vPzxD+rabwSNbeorRmyUmL8hnfVx+
ChpAE25joTEhGhCTXC5dF3KmIpi3OySxleET+EVZh56+oug01gPuNPYK4wMviAUG
fb9HazQqzilM0LGGCaBM1Gz88+oV89TUbRMFDd9Fnb/b0+3dyPXqTZrWk+UtjKLk
OTwgJ04Fik5RLq2pOqrgLEvS7VvLH+9cvULRH+9Xr6C6v7x+mUX9iYg+Shu6l2YA
mKQG0tRvJuHdGKOf/MFXanA1O1Hkuhu6Pz2NOUqAd2SP+H2CCPVSUyMR8Nl+2FcG
F0tJrOXFn/yX62LIl0glbagMhFBAdG1mtXun2FEc/GVapCwSb/vLBBrmuR95Li5P
VaM+g1y0Sak/mv8XkMYLf/uLRyqYdLm+IuXGr0qI/F9UM6zTcvxohkcraTgPMaIZ
k7/a07kVPDUZH31hRPmUssps9p5SKcVvrF0+Oq1XLctfzhPi7a+ZEyTyGQdSNI6z
Zg3dtvZMOy0yE3yscV2jokiTnpCEXbJ15HeoKKLQNpWxP7pIzN+XRfBs226uJN5Q
7hq9eZa2o/CK1ArTkJD/D2z/wrzI/S69s0idYGyWUSloCwKp+eU=
=n+QZ
-----END PGP SIGNATURE-----

--=-mfPWtWIcRlAgASrRwWtM--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
