From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 0/3] IB/srp patches for kernel v4.16
Date: Tue, 23 Jan 2018 12:09:11 -0500
Message-ID: <1516727351.27592.46.camel@redhat.com>
References: <20180122222713.13197-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-iMIZ2nxIGDfRq3x1ddIA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180122222713.13197-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-iMIZ2nxIGDfRq3x1ddIA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2018-01-22 at 14:27 -0800, Bart Van Assche wrote:
> Hello Jason and Doug,
>=20
> The patches in this series add RDMA/CM support to the SRP initiator and a=
lso
> add a debug option. Please consider these patches for kernel v4.16.
>=20
> Thanks,
>=20
> Bart.

Hi Bart,

I took the series as is.  But, I don't know the target core well enough
to know what the third patch actually does (that doesn't impact my
decision to take it, it's a knob into the target core to allow you to
tweak things, that's obvious enough and since you find it useful, I have
no problem with it).  I know the cmd_per_lun setting sets the queue
depth of the scsi device on the initiator side, I would have assumed
that normally mirrors the advertised ability of the target, but this
patch now makes me think otherwise.  So what does this third patch
actually do to the target code?

> Changes compared to v4:
> - Left out the patches that have already been queued for kernel v4.16.
> - Added Greg's ack to patch 1/3.
> - Added a third patch that adds the starget_can_queue login option.
>=20
> Changes compared to v3:
> - Moved a kobj_ns_drop() call inside an if-statement to keep the grab and=
 put
>   ns calls balanced.
>=20
> Changes compared to v2:
> - Added a patch that exports kobj_ns_grab_current() and kobj_ns_drop().
> - Made the rdma_create_id() call also use the namespace of the process th=
at
>   triggered SRP login. Added kobj_ns_grab_current() and kobj_ns_drop() ca=
lls
>   to the SRP initiator to ensure that that network namespace exists at le=
ast
>   as long as the SRP channel that is using it.
>=20
> Changes compared to v1:
> - Use the network namespace of the process that writes into the SRP sysfs=
 login
>   attribute in rdma_create_id() and inet_pton_with_scope() calls.
> - Removed an irrelevant part from the RDMA/CM patch description.
>=20
> Bart Van Assche (3):
>   kobject: Export kobj_ns_grab_current() and kobj_ns_drop()
>   IB/srp: Add RDMA/CM support
>   IB/srp: Add target_can_queue login parameter
>=20
>  drivers/infiniband/ulp/srp/ib_srp.c | 723 ++++++++++++++++++++++++++++--=
------
>  drivers/infiniband/ulp/srp/ib_srp.h |  43 ++-
>  include/scsi/srp.h                  |  17 +
>  lib/kobject.c                       |   2 +
>  4 files changed, 631 insertions(+), 154 deletions(-)
>=20

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-iMIZ2nxIGDfRq3x1ddIA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpnbDcACgkQuCajMw5X
L93onBAAlpY3L4Dof0ruwjAB33vDExsATXlNCS/LuEr1Apg39AqHbTTjO+mb5sLk
jQr236LvakhDyUPDJ57na/HzGBFiHrYYgWutG54REISgR/vyfr5JwTyjldoBaRRX
kMSf4d3g0ln3lbowmDuzEvSqMwuLWooONS2yx64zMn3C4HNZKXzZq965oG5mRDdd
12h8aA2bhnl8ne+22RBNYBlXItDqykuCT33d8+3Sgb5LQEX1LflytHV3wavRSIFj
Pg37BnzCZpMqysENQIagHnekHN4VKbacOOTrzXeOEVQgDrF2hfbKO5Us++ERYOB8
8HxOfwwJ0fSjKfQIsPAAxWeFZQ0tmKr7oY8GL+h6ZMpEbHGnhqCFkfpt+gRA39JY
Q48TsSRHkxCBnRm8oDk1h7zoODnYHgmU7FopHaSui6BpUrsAPPnVyHbk2XH5XJCt
1UNfI08odSDQRIWyu3XWrp0LBk96cruNSehGKokc3eTyWTCvYeR8ijFOClq+1Om/
ww6zN3tZ+RE91qLjtGYB1O21f0xHJnAHs7n+8Ppq2Ts5yG+oeVPHVaT7xP7h03kK
pGpsEaNzQrXUkxFQ+ztZ/5U5uZPOqMQGpSC0AxMJHeNF0aJR4Xbmq4vSXWFgcA7w
eUwflWsF1yA3prOCHPphAbERWDt0pqFAkHe0E17Vt1lNFRY07cs=
=02qr
-----END PGP SIGNATURE-----

--=-iMIZ2nxIGDfRq3x1ddIA--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
