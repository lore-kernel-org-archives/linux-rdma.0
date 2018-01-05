From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH, resend 4/4] IB/srp: Add RDMA/CM support
Date: Fri, 05 Jan 2018 13:06:58 -0500
Message-ID: <1515175618.3403.26.camel@redhat.com>
References: <20180104222842.26756-1-bart.vanassche@wdc.com>
         <20180104222842.26756-5-bart.vanassche@wdc.com>
         <1515172870.3403.11.camel@redhat.com> <20180105173448.GY11348@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-958UWjb4RIJnKolWkmdv"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180105173448.GY11348-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-958UWjb4RIJnKolWkmdv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2018-01-05 at 10:34 -0700, Jason Gunthorpe wrote:
> On Fri, Jan 05, 2018 at 12:21:10PM -0500, Doug Ledford wrote:
>=20
> > > +static int srp_parse_in(struct sockaddr_storage *sa, const char *add=
r_port_str)
> > > +{
> > > +	char *addr =3D kstrdup(addr_port_str, GFP_KERNEL);
> > > +	char *port_str =3D addr;
> > > +	int ret;
> > > +
> > > +	if (!addr)
> > > +		return -ENOMEM;
> > > +	strsep(&port_str, ":");
> > > +	ret =3D inet_pton_with_scope(&init_net, AF_UNSPEC, addr, port_str, =
sa);
> > > +	kfree(addr);
> > > +	return ret;
> > > +}
> > > +
> >=20
> > This particular function is problematic in that it adds new namespace
> > unaware code.  The namespace code in the RDMA stack is in a limbo state
> > of partially implemented, partially not.  I'm loathe to add any more
> > code that is not fully namespace aware as that just worsens the
> > hysteresis in the stack.  So we need to figure out how to do this in a
> > namespace aware manner.  I haven't previously been thinking about this
> > specific namespace issue, so I'm not prepared to even make suggestions
> > for a fix for this yet...
>=20
> Do the userspace daemon's still manage the connection to SRP?
>=20
> If yes, then the networking information should be relative to the
> namespace of the thing that wrote to the sysfs file..

Maybe, maybe not.  It depends on the implementation.  IIRC you get one
daemon per port, not one daemon per mount.  In that situation, it's
conceivable that you might want to allow the init_net namespace to host
a master daemon that mounts all mounts on a specific port under a
variety of namespaces and then you don't need to run a separate daemon
in the namespace itself.  You can reduce the privilege level of
applications in the namespace this way.  But, that's an implementation
detail.

> Also, are there srp_daemon patches for this too? I've been asking to
> see the userspace side for new uAPI features before accepting the
> kernel part so that everything can be well understood. If yes, please
> send, even if it is RFCish..

No, the target code is likewise clueless about namespaces.  I suspect
(although I haven't looked) that the target code's Add RDMACM support
patch will have the same problem.

And, FWIW, the iser/isert code also has this same namespace issue.

And this is all complicated by the fact that the block devices created
by the SRP code might be mounted filesystems, or might be presented as
raw block devices to apps.  If it's a filesystem, then we get a pass as
the filesystem layer will determine if any given read/write should go
through based upon the bind mounts of the filesystem and the namespace
of the application accessing the filesystem.  But if the block device is
directly accessed by a user space application, like maybe a database
writing directly to the block device or even just mkfs/fsck, then we
need to enforce namespaces ourselves.  For that we need to know what
namespace(s) the device is created in, and what namespace the app
opening the device is in.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-958UWjb4RIJnKolWkmdv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpPvsIACgkQuCajMw5X
L93h+RAArChMoyw03JP5bBo0iyi1NMtzt4jQC9p93SthP6CdowAFEkruG/zRsRhh
tiXsBkz4fp1r6jHgiMXeUufPf4Psa7QrMzIU3t4oDbRYMfUY/HNuYXZEQsC2o7f4
CkpQkx0EdtmNri3nTIJ9lJT+SDwsTl65QbINfuTq7NUabXqwxziwtyOk5ttUDyau
T2mc1Z9aVaorvCkrT+IM8deQvV9ZVrtJI4hIhFVUPNWiNU6AcOpCy8bWY7omMgGT
gIqBntPWI/FRUZUO6n1793XEzemvb+tjBqc67ZzwXx8GG7+wCmjPwBL16jimnBt2
w/jEKdeFvgjbQGZhzLZxqDHSft35pLdkXJ2prBzP2GjejkJ/TIC9Oop2/DaRdAlD
GZQ5hqcwNQunlpljXz8lsNrgiunGirayrezghy/Epy4aiCSfhSge8skYwEXtiyG1
hITlMPzAON150+Y7Z6BD8gDjGtdB3KG5KOYCqg5PWW3Qpqa2qwWeQTLBXaIPJlsy
B9UJvGhba8sdxVXrF8zDlS3ipk8uHmGFOBn5v9RcJ/EUVS8vK3hBBSSDPpiOlr8Q
Iym6N2rSrVo3k6mubRlBlUYlIOuyFsPXt3KSpyxY6pO+weXT1PCM21kfxwb4iaWb
TrWSwfVeDMYi+b9xMoL8FFq/1jh+ubkIjdTmC2jSAQMHjUw7eDE=
=AcM+
-----END PGP SIGNATURE-----

--=-958UWjb4RIJnKolWkmdv--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
