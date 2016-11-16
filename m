From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: LPC RDMA Workshop 2016 Summary
Date: Wed, 16 Nov 2016 08:19:29 +0200
Message-ID: <20161116061929.GF4240@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="uc35eWnScqDcQrv5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--uc35eWnScqDcQrv5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello RDMAers,

First of all, we would like to say thank you for everyone who made the RDMA
workshop and summit happened. This two day event was held at KS/LPC 2016 ve=
nue
and offsite, respectively [1].

It wasn=E2=80=99t happened without you, Thank you.

The below summary for the first day came from many attendees and doesn=E2=
=80=99t try to
cover everything discussed there. We invite you to share your notes with us=
 and
mailing list.

The following list mostly consists from future plans and TODOs.
 =C2=B7 Implementing a new Linux RDMA provider by Knut Omang
   o Weak documentation for driver developers.
   o Unclear development guides, no best practices.
   o Need general RDMA test suite.

 =C2=B7 New IOCTL ABI by Matan Barak
   o Agreed on acceptance track. All core changes in bisectable way and ioc=
tl
     parts under EXPERIMENTAL Kconfig option and after that patch-per-comma=
nd
     transition.
   o Extensive review was done and it will be addressed in the actual patch=
es.
   o This new code is valid candidate to introduce tracepoints into RDMA
     subsystem.

 =C2=B7 Consolidation of RDMA User-space code by Jason Gunthorpe
   o Ongoing work on code quality/modernization, there is need to continue =
with
     sparse annotations, coverity, MMIO accessor.
   o There is need for proper systemd integration to autoload modules and p=
roper
     vendor upgrade sequence.
   o 7 licenses is too much for 76K LOC code, there is clear benefit in
     decreasing number of copyrights.
   o Ensure that distribution packages are built from rdma-core. RedHat is
     already doing it, there is need to continue to work with other distrib=
utions.
   o Reuse kernel uAPI headers as a source base for libibverbs and provider=
s.

 =C2=B7 Debuggability and Tracing by Leon Romanovsky
   o Extend standard tools as much as possible, like ss and ethtool.
   o Use tracepoints for MAD snooping, new ABI work and memory registrations
     flows.
   o Reduce redundant printks.
 =C2=B7 Integration with other subsystems by Liran Liss
   o Challenges to integrate complex RDMA schemes (GPU-to-HCA-to-GPU) where=
 CPU
     is not involved. Multiple solutions were sent to mailing lists, but not
     accepted yet.
   o Best candidate seems to be DMA-BUFs, which don=E2=80=99t map peer BARs=
 to the CPU.
   o Associating SELinux security contexts with partition keys and subnet I=
Ds is
     an effective policy for isolating users in an IB fabric.

 =C2=B7 Containers and RDMA by Liran Liss
   o Supporting RoCE UD QPs is subtle because these QPs may only send and
     receive from a subset of the GIDs =E2=80=93 those that correspond to n=
etdevs within the
     process's namespace. Providers must enforce this implicitly, or fail U=
D QP
     creation.
   o Consider delivering RoCE CM packets through the network stack for bett=
er
     enforcement.
   o For IB, a process must be constrained to the partitions associated wit=
h the
     netdev within the process's network namespace.
   o RDMA cgroups will expose two types of objects only (instead of exposing
     verbs objects): HCA objects and HCA handles, which will be presented in
     absolute values and can be limited by the drivers. It will allow nativ=
e support
     of future vendor specific objects.

 =C2=B7 New Fabrics by Ira Weiny
   o It was open discussion about the scope of RDMA subsystem and the old
     requirement to support verbs for every driver in driver/infiniband/, w=
hich
     doesn=E2=80=99t hold for usnic and PSM.

 =C2=B7 Future and Roadmap for RDMA for Doug Ledford
   o The interoperability between IB vendors is less important now, since
     Mellanox is the only one active vendor and Oracle will be in the futur=
e.
   o RoCE is the main place for interoperability.
   o Revealed UNH testing lab initiative to test and perform debug hackaton=
s for
     vendors, in similar way to NFS-RDMA.
   o OFED software stack is rising, while upstream continues to shine :)

 =C2=B7 User Mode Ethernet Verbs by Tzahi Oved
   o Verbs objects suite well OS bypass Eth programming with generic object=
 model
     to expend to new I/O offloads. These APIs can support both Eth and IPo=
IB
     offloads.
   o Developers can use common API for OS bypass and share objects like mem=
ory
     registration, CQs, SRQs for both RDMA and user mode Eth.
   o New introduced RSS objects present generic approach of breaking QP into
     transport and work queues allowing flexible future expansion.
   o Object oriented approach taken with CQ can be taken with posting work =
queue.
   o Future vendor specific capabilities can be implemented using vendor
     specific new kernel ABI support and user mode vendor API query through
     libibverbs.

 =C2=B7 Dual Licensing by Susan Coulter
   o OFA can=E2=80=99t and won=E2=80=99t enforce dual-license on kernel spa=
ce.
   o User space will continue to be under dual-license.

It was great event and we are looking forward to see you next year.

	Christoph and Leon.

[1] http://marc.info/?l=3Dlinux-rdma&m=3D147767504329945&w=3D2

--uc35eWnScqDcQrv5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYK/pxAAoJEORje4g2clinMGMP/0EoIOrKb9nvIkULbemWgfeZ
lZ9+TKc0+z5Oy2DKKqq/8iuoMys5A3Sv+t8ppxkoc5Q6TuBNVTNd7RcmsqgMpWtc
SH58cwip7WvugKIYijn/pzceLhjRyJo5EvZywkC1dfUmwZGwuEW9JE0M0qW73v23
mYNudQh4aYqTHQKKeuiMZUL57MaQTcZMqEr/H0HnoSbcemH5AnpmCReI3xyBHCto
yr/YvyPhne7nz2NgqqOF4hyIJoYOBqRzPQwar9VfzxFiBYsH/LCmavsuaPaC7yIa
7k923LH6V033T3Hrqw/1ApOGvMy3m29U5oyCpgaXjHCbaqLxLET8zYtcPKkgh93M
hH9kUBdgVQxa7+C1bYuZOD+p5xMB0yuT9F7GWHwO5D+Kap7du7POIpv8tlyg6xLz
O6KREIo82ZkEXLKAoEOeY4c8S/lxmtqQ3h7ygS2uB4ScaFnuUyqsCkENzn9Ycv9r
aLg+zNqlHYRpRLgAmojf4/tSYazQGTWiteqUCmi9VecsRM3/s21dViW72Fd8mnWR
9c6vDdp1XbpvQLp4EjPbnPqcFo9nREk+NXLVXQlJ+V4B+JXoq0Qv5v1WH3ZUGaZn
WG4GHYAyrZTnFOKJKnOdrnyPfUlrCSDvp7usrX48ypLPO7b6QLoBOm/oXbVqGVW6
zOLJ020CQhEsM5eLFQWJ
=uYJu
-----END PGP SIGNATURE-----

--uc35eWnScqDcQrv5--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
