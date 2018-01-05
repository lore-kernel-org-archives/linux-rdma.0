From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH, resend 4/4] IB/srp: Add RDMA/CM support
Date: Fri, 05 Jan 2018 18:13:08 -0500
Message-ID: <1515193988.3403.69.camel@redhat.com>
References: <20180104222842.26756-1-bart.vanassche@wdc.com>
         <20180104222842.26756-5-bart.vanassche@wdc.com>
         <1515172870.3403.11.camel@redhat.com> <20180105173448.GY11348@ziepe.ca>
         <1515175618.3403.26.camel@redhat.com> <20180105192549.GA11348@ziepe.ca>
         <1515183835.3403.62.camel@redhat.com> <20180105203506.GD11348@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-vprY/9sDO2nvbFnw+xed"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180105203506.GD11348-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-vprY/9sDO2nvbFnw+xed
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2018-01-05 at 13:35 -0700, Jason Gunthorpe wrote:
> On Fri, Jan 05, 2018 at 03:23:55PM -0500, Doug Ledford wrote:
> > On Fri, 2018-01-05 at 12:25 -0700, Jason Gunthorpe wrote:
> > > On Fri, Jan 05, 2018 at 01:06:58PM -0500, Doug Ledford wrote:
> > > > > Do the userspace daemon's still manage the connection to SRP?
> > > > >=20
> > > > > If yes, then the networking information should be relative to the
> > > > > namespace of the thing that wrote to the sysfs file..
> > > >=20
> > > > Maybe, maybe not.  It depends on the implementation.  IIRC you get =
one
> > > > daemon per port, not one daemon per mount.
> > >=20
> > > I don't think it depends - if we expose this sysfs file to a containe=
r
> >=20
> > Who says we have to do that?  We could make the sysfs file only visible
> > in the init namespace and let the init namespace daemon control what
> > namespaces have what views.
>=20
> What 'views'? It is a sysfs file controlled by the kernel - srp_daemon
> has no control ove rit.

Ok, allow me to clarify: restrict the sysfs file to create mappings to
only the init_net namespace, and by views I meant allow the host
srp_daemon to create a mapping with a specific namespace and that would
then create a device file in that namespace, not a sysfs file.

> > views anyway.  We could just make that mandatory by refusing to create
> > devices from anything other than init_net namespace.  Then even if
> > someone does mount sysfs rw in a container, we're still good.
>=20
> Usually we don't put that kind if policy in the kernel.

No, we normally don't.  However....

> Someone could run a priviledged container with full device access and
> expect this stuff to work right. In that case it is certainly correct
> for the srp_daemon and kernel to be in the namespace of the calling
> process.
>=20
> > > So from a security perspective containers shouldn't even have access
> > > to this thing at all without more work to ensure that the created
> > > block device is also restriced inside the container.
> >=20
> > This isn't sufficient.  The block device created must be constrained
> > within the container, but if we allow direct device access to the
> > underlying LUN on the target, then that target LUN must be exclusively
> > owned by the container.
>=20
> Yes. That is done on the storage controller via ACLs of that LUN.

But we broke that already...

>  The
> container's net namespace would be restricted in some way that the ACL
> can uniquely identify it - and the srp_daemon could run inside the
> container.

When we arguing over namespaces, especially as they related to IPoIB
devices, we decided to allow the tuple to be p_key/qp/gid so that you
can have to separate containers on the same p_key and gid with the
differentiating factor being only the qp.  If we then use that to target
our SRP RDMACM connection, we've gone into an area where the target
can't differentiate our container.

So, yes, I think the storage target should control the ACLs too, but I'm
concerned that we've gone down a path where that can't currently be done
 and changes will be required on the target for things to work.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-vprY/9sDO2nvbFnw+xed
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpQBoQACgkQuCajMw5X
L90btQ//ewdB86VfB0Gs2/ZUWlURHU2phWjNwmSVmDAlG2qq4HMExgQY7+g2Pc1T
26VkX3IgC/XGNsjO60m+yfwf/qjQzdpZl7LIL5zf2j0XPWx/5TO1zaE71gq1u4iu
LoiGS8LPoH5E3rpRDWtWDytEaz3V6E8Z86GIOBpOeiQnS1EM/51UFMEpcDjWxFQX
X3d6OIkIb0pY3VJqeChTsoUnKC18nVfbih7s6oCebBOCC1nRkZ7ZGgVsI0/V+XU/
6EWGK0QIuO/UA2nGcQDIjlZ36WIPzzYezBAG5ZOG6bglHJQ7uqzcCqyMBMNyD+m1
RrKu4a1whEF8F87k+G8oL21VsGGnCnVwODES1OnxtvFXzIfA7nnGf8Dck/OwGLwK
DIuUsEEJQXacDtZGc7d4zjtPBSB/Hk5ni7T13fdPyBDu382Nmkb3i1ALfbaa2Ovd
es8GINO7NYRKS7Mku4tGqrz82XTJFD1tVnz49JSW6f8ux2FJRehhRyDD4NjhWceV
XTnyd/V79YTE02Vbag/TS0ZdanajXbjaN/49NKstcOAOKCoFqOc6MsOhP7VBaIt9
JlW9eqF9+mSLML1NiFfhx81X0zAOmAdJy1V1i0Gc/Vt6pAw5hxFj6OpPseMPP5UR
QufGaGT0yl9irwAgGygvHicv8Zsy/NU+SlcSeLs5nCxJWNfaPb8=
=P0Ry
-----END PGP SIGNATURE-----

--=-vprY/9sDO2nvbFnw+xed--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
