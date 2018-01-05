From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH, resend 4/4] IB/srp: Add RDMA/CM support
Date: Fri, 05 Jan 2018 15:23:55 -0500
Message-ID: <1515183835.3403.62.camel@redhat.com>
References: <20180104222842.26756-1-bart.vanassche@wdc.com>
         <20180104222842.26756-5-bart.vanassche@wdc.com>
         <1515172870.3403.11.camel@redhat.com> <20180105173448.GY11348@ziepe.ca>
         <1515175618.3403.26.camel@redhat.com> <20180105192549.GA11348@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-byZ9Aot54utMO9D0b/DO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180105192549.GA11348-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-byZ9Aot54utMO9D0b/DO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2018-01-05 at 12:25 -0700, Jason Gunthorpe wrote:
> On Fri, Jan 05, 2018 at 01:06:58PM -0500, Doug Ledford wrote:
> > > Do the userspace daemon's still manage the connection to SRP?
> > >=20
> > > If yes, then the networking information should be relative to the
> > > namespace of the thing that wrote to the sysfs file..
> >=20
> > Maybe, maybe not.  It depends on the implementation.  IIRC you get one
> > daemon per port, not one daemon per mount.
>=20
> I don't think it depends - if we expose this sysfs file to a container

Who says we have to do that?  We could make the sysfs file only visible
in the init namespace and let the init namespace daemon control what
namespaces have what views.  That was my point, the implementation can
be flexible.  And actually, if most containers mount sysfs ro as you say
below, then the init namespace daemon would need to create the namespace
views anyway.  We could just make that mandatory by refusing to create
devices from anything other than init_net namespace.  Then even if
someone does mount sysfs rw in a container, we're still good.

> then anything less than using the contain'd net namespace sounds like
> it is a path to allow the container to escape its net namespace.

I'm a little concerned that this is a problem now regardless.

> The complication here is that sysfs creates a device, and that device
> is currently created in the host namespace.

Let's assume, for the sake of what I'm writing below, that we modify the
srp daemon so that every line in the srp_daemon.conf file can optionally
specify a namespace, and when present, the daemon will pass that to the
kernel, and when present the kernel code creates the *device* file for
that device in that specific namespace (which is really the only thing
we care about...for a filesystem based access as opposed to direct
device access, you want to create the device file in the init_net
namespace and mount the device in the init_net namespace and then follow
the typical filesystem namespace rules for determining what the client
namespaces can see, and in that situation the client need know nothing
about SRP, it is only using a filesystem in a namespace).

> So from a security perspective containers shouldn't even have access
> to this thing at all without more work to ensure that the created
> block device is also restriced inside the container.

This isn't sufficient.  The block device created must be constrained
within the container, but if we allow direct device access to the
underlying LUN on the target, then that target LUN must be exclusively
owned by the container.  No other container, nor the host, can be
allowed to have any access of any sort or it becomes a message passing
bypass around containerization.  It becomes easier then to allow the
init_net daemon to create all of the devices, and once it creates a
single mapping to any LUN, that LUN can not be reused for any other
mapping.  So, a LUN can be either A) a mounted filesystem in the
init_net namespace with other namespaces carved out of the filesystem as
appropriate or B) a direct access device that is accessible in exactly
one namespace only.  We can't actually rely on the srp_daemon to enforce
this, we have to do it at the kernel level, but I think that's what we
need to do (if we don't simply bar direct device access from a
container, period).  The only difficulty I see here is multipath.  You
still want to support it, especially for the host OS, but at the same
time, you can't allow a container to get one path and a different
container to get another path to the same device.

> Since it is a sysfs file, and most container systems mount syfs ro, we
> can probably get away with ignoring namespaces for now?
>=20
> But using the current process namespace is also a good choice.
>=20
> In princinple there can be multiple srp_daemons if they can coordinate
> which ones do which. For instance a container could run its own
> srp_daemon restricted to the pkeys the container has access to. If the
> device stuff above was fixed then this would even make some sense...
>=20
> Otherwise srp_daemon has to run in the host namespace, where the
> created devices end up and it rightly should not see the netdevices
> that are assigned to other namespaces.

This problem is made more difficult by the fact that there is persistent
storage at the other end of the connection.  It doesn't really matter
what netdevice we access a target through.  If the accesses go to the
same physical media at the other end, then they can't be shared across
namespaces without creating a containerization leak.  With netdevices we
have a unique MAC/vlan/IP tuple of data, and remote systems only know us
by that and our containerized code can't reach beyond those boundaries.=20
But with disks, the issue is different.  If we allow direct device
access in the container, then (as best we can, there may be problems we
simply can't solve) we need the container bubble to extend all the way
around the physical media we are allowing access to on the remote target
system.

We might just have to turn off all direct device file access in
containers for iser and srp and nvmeof...

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-byZ9Aot54utMO9D0b/DO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpP3tsACgkQuCajMw5X
L926AhAAgQmiSgzgVmCS59CV6bC2u29U2a6oVdCRAztZuyqVuE0etfFEz/lh4SD5
PP2a9tI82Qd6mac//Wt0uE6uNWOieqjnubZH6dyKqETX6E1pYFdABdoM9rfzHhjR
mVGaPX1XZRFVdkqTkQKAcdWxhKqKyG9czzuNREOtGUUXsdAJ/gog5+8baNQq7ojg
rB2H+HCs9SXiEGbThVNKmfpjLiEvSoJFhiiUgqwJZp/mBAFxLLWMVwP63uyeio6M
1z6TupepN+KbGpSLM3XcMFJRu2c9zHTEYJpxZV3IwyZoMbCbaUdtGLM3ICp5i3Qs
HKcHLUNN2HUNQvugMGUJertwbQjzlc5gFaYU01zd9vpw18CEKIKjJ+TIOzqj9zrh
thG6k9vuWPufGJMHwyrlgrqDxcl2dgIdHVFx1EiIPrlF5APNpZe91b+NdpUPxXBd
feC0p3qhwrwc4CqMbDSKi2TZk+2lfXhs7OhzuzS2heFtKXV/YNfNCSC710qAVtoL
eU7b6xo5a7kFXJmWNzhCXgqje+zJk7a5CjvBvPSSBf6LGWefwfJO6Y05lmmmU+fC
aW2ekCuId+s3YgFsBk8N74Aq+6pZqhEji/bUFI9FS7e5H05yOp8M2DbCh+Glu4Cb
g0w74NrDJaxIaLynQY5oa2pdqetT6ZueWAmByRhGXW7CP3qaMOk=
=RIXH
-----END PGP SIGNATURE-----

--=-byZ9Aot54utMO9D0b/DO--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
