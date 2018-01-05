From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH, resend 4/4] IB/srp: Add RDMA/CM support
Date: Fri, 05 Jan 2018 13:15:43 -0500
Message-ID: <1515176143.3403.28.camel@redhat.com>
References: <20180104222842.26756-1-bart.vanassche@wdc.com>
         <20180104222842.26756-5-bart.vanassche@wdc.com>
         <1515172870.3403.11.camel@redhat.com> <20180105173448.GY11348@ziepe.ca>
         <1515175618.3403.26.camel@redhat.com> <1515175964.3254.15.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-efIxeEPL6u7h5clJ4O4F"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1515175964.3254.15.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "jgg-uk2M96/98Pc@public.gmane.org" <jgg-uk2M96/98Pc@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-efIxeEPL6u7h5clJ4O4F
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2018-01-05 at 18:12 +0000, Bart Van Assche wrote:
> On Fri, 2018-01-05 at 13:06 -0500, Doug Ledford wrote:
> > No, the target code is likewise clueless about namespaces.  I suspect
> > (although I haven't looked) that the target code's Add RDMACM support
> > patch will have the same problem.
>=20
> Hello Doug,
>=20
> The target code already allows to configure ACL (access control lists) th=
at
> control which initiator systems are allowed to log in and which ones not.=
 Are
> you sure that it will be valuable to add network namespace support to the
> RDMA/CM code in the SRP target driver?

I haven't really thought about it much.  My comment wasn't that I
thought it should be implemented, just that my quick grep of init_net in
the drivers/infiniband directory showed me that the srpt driver doesn't
distinguish any namespaces (while the isert driver does), so I suspect
adding rdmacm support will add a new init_net usage.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-efIxeEPL6u7h5clJ4O4F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpPwM8ACgkQuCajMw5X
L912YxAAmstBZBJhoTEbvBCNE+5nUMbavpr1fw9oebC3WM8ukj/G0Btnt4ipA3SH
9NGXX5VozB3tMDILwYRzKMiF1lucDM7lYrXirj8WfIP3ppiyiLsIMrtKe7xidEl2
hGPTnMkJLfPuhgAn48/zp1SAG4mUE3I0YrImQ76Y7U1f6PJc3bjnPCOYkVltUBs5
4XKQKQejs06C4iViqALrZXZYEfgpXX0mDqGHCc8IjL3jm2KMHfGPsp8cdJ2Du6zb
w/8d0gv3xp2wdCrc6QiN8U3TiaCeu6Bm9oRJRtHh6mUt6aJVodsVlHHb3XYW2H9S
y0c0j8i9a/Vr+oCgWtTphBTy0WC3tUQ/0goqvnEI71ixJq+fImOEjYZb4A4kmhdp
2VNdtNVo3dxR/f1ojYKCnpDWcVvPG3xVQMYffbIhCdTCuMlLJORbA5Dvelnf7Nt0
UTiFUI0ZHYI3pjEPC6cS1Sax5PCqJ/mB+eJkDcRu7YtdtxeAprS09ON0rOaZ3Fyy
KLT/rJFS9hlCNxKBlITeHUQbYufCB4gZZpdCa79D6Pqj81QFKSPNzDmpKWnwLBhS
Ig2TqG7XfxkdV9ZVQazPevsGax0HhhKIp0d5bQO+IeUoC3MrDysjoF5NBI2elDUm
soitBBye4VwxVcQrrx80AWdEYqdc4s5sj68aib2/gWxyWgBvAVI=
=nQ48
-----END PGP SIGNATURE-----

--=-efIxeEPL6u7h5clJ4O4F--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
