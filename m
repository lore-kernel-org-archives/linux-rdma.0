From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 0/5] IB/srp: Add RDMA/CM support
Date: Wed, 17 Jan 2018 20:35:57 -0500
Message-ID: <1516239357.3403.299.camel@redhat.com>
References: <20180116183945.30629-1-bart.vanassche@wdc.com>
         <1516230684.3403.290.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-ZupwalVpCe2QWFcjJRj0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1516230684.3403.290.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-ZupwalVpCe2QWFcjJRj0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-01-17 at 18:11 -0500, Doug Ledford wrote:
> On Tue, 2018-01-16 at 10:39 -0800, Bart Van Assche wrote:
> > Hello Jason and Doug,
> >=20
> > The five patches in this series add RDMA/CM support to the SRP
> > initiator. Please consider these patches for kernel v4.16.
> >=20
> > Thanks,
> >=20
> > Bart.
> >=20
> > Changes compared to v3:
> > - Moved a kobj_ns_drop() call inside an if-statement to keep the grab a=
nd put
> >   ns calls balanced.
> >=20
> > Changes compared to v2:
> > - Added a patch that exports kobj_ns_grab_current() and kobj_ns_drop().
> > - Made the rdma_create_id() call also use the namespace of the process =
that
> >   triggered SRP login. Added kobj_ns_grab_current() and kobj_ns_drop() =
calls
> >   to the SRP initiator to ensure that that network namespace exists at =
least
> >   as long as the SRP channel that is using it.
> >=20
> > Changes compared to v1:
> > - Use the network namespace of the process that writes into the SRP sys=
fs login
> >   attribute in rdma_create_id() and inet_pton_with_scope() calls.
> > - Removed an irrelevant part from the RDMA/CM patch description.
> >=20
> > Bart Van Assche (5):
> >   kobject: Export kobj_ns_grab_current() and kobj_ns_drop()
> >   IB/srp: Use kstrtoull() instead of simple_strtoull()
> >   IB/srp: Make the path record query error message more informative
> >   IB/srp: Refactor srp_send_req()
> >   IB/srp: Add RDMA/CM support
> >=20
> >  drivers/infiniband/ulp/srp/ib_srp.c | 762 ++++++++++++++++++++++++++++=
--------
> >  drivers/infiniband/ulp/srp/ib_srp.h |  42 +-
> >  include/scsi/srp.h                  |  17 +
> >  lib/kobject.c                       |   2 +
> >  4 files changed, 654 insertions(+), 169 deletions(-)
> >=20
>=20
> The patchset looks pretty good now, but obviously we need an ack from
> Greg before patch 1 can be applied.
>=20

Since I took the majority of the srpt patchset, I took patches 2, 3, and
4 of this set.  We're waiting on Greg's ack on patch 1, and patch 5 is
the only one that needs patch 1, so that at least get's the backlog
widdled down.  Thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-ZupwalVpCe2QWFcjJRj0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpf+f4ACgkQuCajMw5X
L93mxw//YJ/8ZYjy1jm+TivXwtIeRvbEQivgoWdW3ECbqvbRxSQBO8MbCCWrz/QM
VHzynTD7fxCMzdIuN6/5dKMJxc4+bpYgCpDB9j5gdkEgZ1PkbkfbSEGgpistWmWk
ldG24HVWguQxegLg26Rv6llmg+2oBZ3mahjC/rl+qk+Y909Qr8Vot1kGQ7yYxc/k
HNLtfMWgzh3W4aP/uCV1JMIe7nvz7XYhNI6nTYk4Xpbc4EV72+b8PuCqFAW2cl/p
gfQmAKlxDtn8eMVCE0AbrHgxTddW93tmdQ1bSoXNgFKwk4TcKRSxTKKyNaUWjgUM
o3N3etMu4nyS9t+co3KnWzVXGWgTJKICq2txd88YSfa6uZD2iEzxYBtrgte5bGZc
aF+vu9lBqI5SiCJcqfQ1tblBcmr0QDL3XOGbhDq7ZrKwqZwHcEOvcOMFz9vFot5P
DVBThw5vCp0wtk0dFfLzjfI0SjQRKuROQkYVrVjWwNZqjR9a3b48nX1QK5z4Mi/9
UhIJIeWZGn54v5g3MZqEfKj/tO5IkZUF2nXzPXieDPnHM5Bfx6f5TnWOUcuBNWO7
fUNFLhPEtWDhkt10a2V+A9bXBARJuzNl671hv94AVPHLlS8zwoJQ5Ld4RyD++YMq
p6s6E5t5JUdA3UOIyoF907LbwQxOCK9+U9sGczpCipUNK2qsIOg=
=duSK
-----END PGP SIGNATURE-----

--=-ZupwalVpCe2QWFcjJRj0--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
