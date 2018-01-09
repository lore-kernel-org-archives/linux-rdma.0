From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [for-next 1/5] RDMA/bnxt_re: Enable RoCE on virtual functions
Date: Tue, 09 Jan 2018 10:06:40 -0500
Message-ID: <1515510400.3403.138.camel@redhat.com>
References: <1515152434-13105-1-git-send-email-devesh.sharma@broadcom.com>
         <1515152434-13105-2-git-send-email-devesh.sharma@broadcom.com>
         <1515449549.3403.112.camel@redhat.com>
         <CANjDDBgG0zHqBRky=UzekBnNKrJyjgc06m4UivRTn5xu1gqE0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-P7WCz13q+dRrW2TXqROw"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANjDDBgG0zHqBRky=UzekBnNKrJyjgc06m4UivRTn5xu1gqE0w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-P7WCz13q+dRrW2TXqROw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-01-09 at 19:37 +0530, Devesh Sharma wrote:
> On Tue, Jan 9, 2018 at 3:42 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On Fri, 2018-01-05 at 06:40 -0500, Devesh Sharma wrote:
> > > From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> > >=20
> > > Currently, fifty percent of the total available resources
> > > are reserved for PF and remaining are equally divided among
> > > active VFs.
> > >=20
> > > +/*
> > > + * Percentage of resources of each type reserved for PF.
> > > + * Remaining resources are divided equally among VFs.
> > > + * [0, 100]
> > > + */
> > > +#define BNXT_RE_PCT_RSVD_FOR_PF         50
> >=20
> > This is a separate comment from the patch review itself.  But, are you
> > sure this is a good idea?  And especially are you sure that it should b=
e
> > a compile time constant and not a runtime parameter?
> >=20
>=20
> Keeping a compile time constant is indeed not a good idea and I completel=
y
> understand that if we have had a knob there it would had been much much
> better and flexible.
> For this submission we wanted to avoid the use of module-parameter or con=
figfs
> interface. Thus, as a workaround this is hard-coded compile time
> constant is used.
> Eventually, more flexible scheme would be supplied to change this.

Ok.

> > I ask because it seems to me that usage of this stuff falls into one of
> > two categories:
> >=20
> > 1) All bare metal usage
> > 2) SRIOV usage (in which case the bare metal OS does relatively little,
> > the SRIOV using clients do most of the work)
> >=20
> > I guess I'm finding it hard to imagine a scenario where, when you do
> > have SRIOV VFs, that you don't want the majority of all resources being
> > used there.
> >=20
> > I might suggest that you simply don't split resources at all.  Maybe do
> > something like filesystems do.  Let anyone at all take a resource until
> > you hit 95% utilization then only root can write to the filesystem.  In
> > this case it would be let both PFs and VFs use resources at will up
> > until you hit the 95% utilization threshold and then restrict resource
> > use to the PF.  That would make much more sense to me.
>=20
> This is indeed an excellent suggestion to optimize the resource
> utilization between
> PFs and VFs, however, I have couple of facts to put forward
>=20
> - If I have understood it correctly then this would require an
> independent entity which
>   would keep track of what percentage of resources has been utilized
> at any given
>   point in time by all the functions (PF and its VFs). Currently, we
> do not have such
>   implementation in firmware and PF driver cannot track or resource
> utilization across
>   functions.

Fair enough.

> - In the current implementation hard-coding 50% does not hard-limit PFs w=
ith 50%
>   it can still over-subscribe upto max limit even though max VFs are acti=
ve.

OK, but that means a PF can starve VFs rather easily I take it?

> - With the equal distribution of remaining resources among VFs we are
> trying to avail
>   minimum guaranteed resources to max possible VFs on a given PF. We
> want to avoid
>   the case where number of usable VFs depend on the current usage of
> resources consumed
>   by already active VFs.

And this then is the opposite of the PF in that VFs aren't *really*
guaranteed this minimum amount, since the PF can starve the VFs out, but
it at least guarantees other VFs don't starve any specific VF out.

That's fine if that's how you want things setup for now.  I think I
would work on a firmware update to implement the resource tracker as the
long term solution ;-).

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-P7WCz13q+dRrW2TXqROw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpU2oAACgkQuCajMw5X
L93BDw//Zs8O/GSzmQ00Vtvt3cfvL10m3Xgi1Sml3JiKSgYAPtKTJwntSl8Cs8kP
6f3H9Gj1qkSBuiBeu04kcEMr7jURU4u0CY1P9COFyIa65BxYkrJdbn/JtFfg51Mu
chBGx07LJ8JPjfVar+FSesv8u1e+bvsbRwtIrhQPTUktWNwsRN5QVGFrN0VM4+nz
xbG3ujAWoBzi0285p5WIR9+EKX9AJd9rjx+rk8d5KoPYv3F3Og7XWzyWSBE0iFbB
VeZC3EIgBA+WCjwdA4ccNgFPyekKrgH5gBrCuwDvXK4+vQtnk1OpSbbRByL75hz9
YB+F/qk2l6/HHWnOnb7pHbA2Z+ata/0niWB3Ma0AGMZ4ZOHell/BcGRlujw4e9Q9
6cKc8W6Lc/Py+cvsIVeKdx592f5Xw/e2gZwlil018YNElxCcL2cV2NeFvILSxU7N
klrgWTvo6nzuCgdGJZYL84bjaj8L9Vry/P4A4pV8ps3RN1Yaf+3dzmzF+eYYxS17
LT9ghs/QLE8BfpyCJ9F62rij2OUmHE8OZLEt0J3KjWJuD1QVHDhNzj4uczzfyDua
Rr4b1hnga7TreLt6sTOEGFF8MgWsrkFRM+zzDs1pJTxMcBB3LeWBT9jbvuCTynNh
vgm6endebQAROZpypVpdU+zCLNCE2MVi81hegQkGSaglyulWsFw=
=5i8E
-----END PGP SIGNATURE-----

--=-P7WCz13q+dRrW2TXqROw--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
