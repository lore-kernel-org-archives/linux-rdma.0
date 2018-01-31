From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] iwpmd: fix double mutex unlock
Date: Wed, 31 Jan 2018 16:28:42 -0500
Message-ID: <1517434122.19117.45.camel@redhat.com>
References: <1517413071-20438-1-git-send-email-bharat@chelsio.com>
                 <010901d39aa9$d4d66fd0$7e834f70$@opengridcomputing.com>
                 <012d01d39aad$228c34f0$67a49ed0$@opengridcomputing.com>
         <1517432802.19117.41.camel@redhat.com>
         <021201d39ad8$349bb730$9dd32590$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-7RHmuK67FIRyAaJYwIOW"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <021201d39ad8$349bb730$9dd32590$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Potnuri Bharat Teja' <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, jgg-uk2M96/98Pc@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-7RHmuK67FIRyAaJYwIOW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-01-31 at 15:12 -0600, Steve Wise wrote:
> > Applied to master branch, thanks.
> >=20
>=20
> Thanks Doug.  Do I need to do some process magic to get it into stable an=
d spin a 16.x.y point release for the EWG to pull into OFED-4.8-2? =20

I added a comment to the commit on github and tagged you and Nicolas.=20
He should pull it back for you.
=20
--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-7RHmuK67FIRyAaJYwIOW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpyNQoACgkQuCajMw5X
L90t4BAAjYepJFRNpDZDZDlgjAb6Q/YyvuhGMbikCQSPXcAtTabOpmlPcMz8whWk
cOnHoc77gPoZw6U+O+aHyVoCuvwX4Ns0NkQe/0K+u7kkTlGpyZNpGRiF2NS0EAfN
8sHydtdKdYHL2fDxPcG5A+wZKoEl3jzDzVMjC4durc91gIYYtM7DyrAyWod80wJ3
ssNxHpCqTsdGOBlgne9uybKkFv2ODNOYZS85Av+O1+Qk8Ef326qNArI33of881re
GLHmzuSki1fqObqBdyYPq9OFqb2NSNTmEV7/GcaKZ8kVTRTiRfVT5oO3ukLrimTe
ouLuW/qcwXj3PPglSKWBSNQ5ljuKNV246IMdG6z8kOJoeQzhcyvQTK96ZsNrPsAf
DKucH1dLgsYHAzv3QLzsGX4tbOCRECqAg01rP+ZzB6dD7JnflAiBZC65BssGOevX
Sx92Ybs6EyvIsgmwJDsUcqzweF4DfNQjvL5IENsi6wnKJ+ApkZ4WVi6bGHOLa5K6
oRhDZ29lmXCkzCY2D9lXXmPHD4wAQGsI7E9DYyPRB5nv8Efg/2vV3j1SogGKP86P
ir/bt+wQByk8Qv7GtXhE7nYkKI84siGX4TT1WQplkwMwtG4/BuwZqfLK6dXdNBLi
CLWR0ihHqmN2ruXIahJ5enk2aVa2KkO2KT6xQzWpx/gqIFAbHEI=
=Vfxz
-----END PGP SIGNATURE-----

--=-7RHmuK67FIRyAaJYwIOW--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
