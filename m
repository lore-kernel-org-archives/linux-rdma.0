From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH for-next 00/14] IB/hfi1: Updates for-next 5/2/2018
Date: Tue, 15 May 2018 10:35:29 -0400
Message-ID: <baef01959e985a7f806bc8543a6157ba33c6bc61.camel@redhat.com>
References: <20180502133831.20730.42677.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-6ANTSipexeKqHNcdkZPS"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180502133831.20730.42677.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>, jgg@ziepe.ca
Cc: Mike Mariciniszyn <mike.marciniszyn@intel.com>, linux-rdma@vger.kernel.org, Mitko Haralanov <mitko.haralanov@intel.com>, Brian Welty <brian.welty@intel.com>, Alex Estrin <alex.estrin@intel.com>, stable@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Harish Chegondi <harish.chegondi@intel.com>, Don Hiatt <don.hiatt@intel.com>, Sebastian Sanchez <sebastian.sanchez@intel.com>, Kamenee Arumugam <kamenee.arumugam@intel.com>
List-Id: linux-rdma@vger.kernel.org


--=-6ANTSipexeKqHNcdkZPS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-05-02 at 06:42 -0700, Dennis Dalessandro wrote:
> Hi Doug and Jason,
>=20
> Here are some patches to go to for-next. These include the couple patches=
 that
> needed rework that were posted before the OFA conf. Well actually those p=
atches
> that had issues were just dropped with the exception of the one from Alex=
, to
> add handling of kernel restart to hfi1 and qib. Patch 8 is his V2.
>=20
> Nothing else too scary or exciting in here. Well OK so that's not quite r=
ight
> the CQ completion vector patch is rather interesting. This adds support
> for compeltion vectors for hfi1 and helps improve performance in things l=
ike
> IPoIB.
>=20
> There is a signifianct patch from Mitko that redoes a lof our fault injec=
tion
> stuff. It's a big patch but I'm not sure it lends itself to being broken =
up
> further.
>=20
> One other thing of note is the "Create common functions" patch from Sebas=
tian
> depends on one of the patches that I sent for the -rc. It won't apply cle=
anly
> without that.
>=20
> ---
>=20
> Alex Estrin (2):
>       IB/hfi1: Complete check for locally terminated smp
>       IB/{hfi1,qib}: Add handling of kernel restart
>=20
> Brian Welty (1):
>       IB/{hfi1,qib,rdmavt}: Move logic to allocate receive WQE into rdmav=
t
>=20
> Kamenee Arumugam (1):
>       IB/Hfi1: Read CCE Revision register to verify the device is respons=
ive
>=20
> Michael J. Ruhl (4):
>       IB/hfi1: Return actual error value from program_rcvarray()
>       IB/hfi1: Use after free race condition in send context error path
>       IB/hfi1: Return correct value for device state
>       IB/hfi1: Reorder incorrect send context disable
>=20
> Mike Marciniszyn (1):
>       IB/hfi1: Fix fault injection init/exit issues
>=20
> Mitko Haralanov (1):
>       IB/hfi1: Rework fault injection machinery
>=20
> Sebastian Sanchez (4):
>       IB/hfi1: Prevent LNI hang when LCB can't obtain lanes
>       IB/hfi1: Optimize kthread pointer locking when queuing CQ entries
>       IB/hfi1: Create common functions for affinity CPU mask operations
>       IB/{hfi1,rdmavt,qib}: Implement CQ completion vector support
>=20

Hi Denny,

As mentioned, I pulled patch 5 of this series into for-rc, and I pulled
the rest into for-next last week.  Thanks.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-6ANTSipexeKqHNcdkZPS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlr68DEACgkQuCajMw5X
L91COw//ZBIO1UUWMHxB37T5uO9o5NLgBAws40hufVzE+ZZb+5+Yen/BWVn96WZr
J3VU27M3/0dq0Ey2p3IhgF8dNfIeC6bz+UrK2XPtK7dEXMHIif+CiRzXDMTLT/MR
iIYu4scxW26Y7bUY+jmqKqTr1nD/3HPUULps0dQcH4PVaj93e6+GyYHAIoPBh+O4
wxNeGgkOeL32F4VfaRLrC6PjgRtkIRsBRtVts8R03+V12VBkkPzJgpmOW96mitQz
zeE/qL5NzMsXMrl68fl+06DC/3jgFB3cx9P85Hgq/z5coWKSbDXES3dXxzTxKqmt
+0QoJYN+X4ony/Yq35WDtqwnNHaDLkLGGxJiD/jR7o3HzilRuuxSlP9hylyZ87dd
vCk6iu6D8RL83Hj5inJcni8J8xh0WeR9otMIoju+g6HnF83Kw5GJ+Y38/l3/lz98
dfN23Xf4MvOBOApshD4E9YcMHmoFWAQQmq+n/dN+cLS7dX9LAtRJsmabDS/Rxj58
/tkFlgyUEsdtIsTxl8rv//UB3ibjYFGdarVJXFiTZj8NvBbAFIjCc+PumjgbSfJ9
6ZM7VyMXBqPpgFV/8lHxv2olLkmCyWUW19+x7YCqBa7/3SvIj31e+47zBJ/F1CCV
x+Y8HLWVr6F5Y6iDkKdgSIq6HV/lph6uWWyGvLqf+FdTQxCZSZA=
=nU4U
-----END PGP SIGNATURE-----

--=-6ANTSipexeKqHNcdkZPS--
