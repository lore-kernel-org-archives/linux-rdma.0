From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next] iw_cxgb4: Fix possible circular dependency
 locking warning
Date: Mon, 13 Nov 2017 16:59:39 -0500
Message-ID: <1510610379.3735.44.camel@redhat.com>
References: <1510229853-25875-1-git-send-email-bharat@chelsio.com>
         <012b01d35969$48d7d9a0$da878ce0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-mhsttwMfNcBKvqa/8OUx"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <012b01d35969$48d7d9a0$da878ce0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Potnuri Bharat Teja' <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-mhsttwMfNcBKvqa/8OUx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2017-11-09 at 08:44 -0600, Steve Wise wrote:
> >=20
> > Locking sequence of iw_cxgb4 and RoCE drivers in ib_register_device() i=
s
> > slightly different and this leads to possible circular dependency locki=
ng
> > warning when both the devices are brought up.
> >=20
> > Here is the locking sequence upto ib_register_device():
> > iw_cxgb4: rtnl_mutex(net stack) --> uld_mutex --> device_mutex
> > RoCE drivers: device_mutex --> rtnl_mutex
> >=20
> > Here is the possibility of cross locking:
> >=20
> > 	CPU #0 (iw_cxgb4) 		     CPU #1 (RoCE drivers)
> >=20
> > -> on interface up cxgb4_up()
> > executed with rtnl_mutex held
> > -> hold uld_mutex and try
> > registering ib device
> > 					-> In ib_register_device() hold
> > 					   device_mutex
> > -> hold device mutex in
> > ib_register_device
> > 					-> try acquiring rtnl_mutex in
> > 					   ib_enum_roce_netdev()
> >=20
> > Current patch schedules the ib_register_device() functionality of
> > iw_cxgb4 to a workqueue to prevent the possible cross-locking.
> > Also rename the labels in c4iw_reister_device().
> >=20
> > Signed-off-by: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
>=20
> Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>=20
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-mhsttwMfNcBKvqa/8OUx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloKFcsACgkQuCajMw5X
L914KQ//aa3d0W/ZOy8FWToj8Xe5RSbcTWDdcr77/gf7/pckvMDAIp/OIXLq4xkT
CkS+8zxUMktQnSmYDlUBunUm2o1P/vAXY0jI04+o3ES8FQzaoAF6We8j0Nn3u/6i
I/bYGLK2AAoVfjZtXozQdb3GrJp0hyLOxIRUW8JXxBsjFDbY9rlIC1vtFnZ/D0TH
fMpPuNdyRdRjV705Db12WDP6CXP8cCrtWjTLdIQgW/nX4QNy3rwjZho44cpi+Gre
I5bRBt2wihjaUN28SzjYoiAuvY90bOYHNH+IQuKSj6zc8XlkaFgzzKKRXfQOs9ma
PqGQXVBMKQn5ROEnE10Czz6l+SQVtHKY6Qvp+frdJR/EsWGd+pNuBn3cL0noyey3
0EcUXnfTkCDE2FSr28YVXlTL4B8LCMkgUNfNQrupvAy9Ma/MZyrUOftDpDloguvC
RBvcsLadKbbgz015+oq3UevsfaxvZEPuV9LLafMvtC83o/N6sxf97MIGX2d1+GKE
LRV0DQNXdBM5mD48Rgd8/EzAzFp0FyGR10Noi7P2AyNml2hqZnPHDF3fEMJ7VPri
tA2RdkD1k4/4Q4NE64Iq9RBWJ2hweaMC+ZGZIOZPxl6CapavZX1ahZ2AP3f+0xht
+A3qdJ58wlVNU9cqdbJsjDp+gwPkplTSVKn5YBzMktykm/lbafc=
=zfgA
-----END PGP SIGNATURE-----

--=-mhsttwMfNcBKvqa/8OUx--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
