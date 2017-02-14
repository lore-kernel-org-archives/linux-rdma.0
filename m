From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 22/27] IB/hfi1: Add receive fault injection feature
Date: Tue, 14 Feb 2017 16:51:05 -0500
Message-ID: <1487109065.86943.86.camel@redhat.com>
References: <20170208132142.16442.69329.stgit@scvm10.sc.intel.com>
         <20170208132800.16442.94549.stgit@scvm10.sc.intel.com>
         <20170212174205.GI14015@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-Eq0qJOf+eWSYWQKsvUZj"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170212174205.GI14015-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-Eq0qJOf+eWSYWQKsvUZj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2017-02-12 at 19:42 +0200, Leon Romanovsky wrote:
> On Wed, Feb 08, 2017 at 05:28:01AM -0800, Dennis Dalessandro wrote:
> >=20
> > From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >=20
> > Add fault injection capability:
> > =C2=A0 - Drop packets unconditionally (fault_by_packet)
> > =C2=A0 - Drop packets based on opcode (fault_by_opcode)
> >=20
> > This feature is disabled by default and can be
> > enabled using the HFI1_FAULT_INJECTION Kconfig.
> >=20
> > The faulting traces have been added:
> > =C2=A0 - misc/fault_opcode
> > =C2=A0 - misc/fault_packet
> >=20
> > See 'Documentation/fault-injection/fault-injection.txt'
> > for details.
> >=20
> > Examples:
> > =C2=A0 - Dropping packets by opcode:
> > =C2=A0=C2=A0=C2=A0=C2=A0/sys/kernel/debug/hfi1/hfi1_X/fault_opcode
> > 	# Enable fault
> > 	echo Y > fault_by_opcode
> > 	# Setprobability of dropping (0-100%)
> > 	# echo 25 > probability
> > 	# Set opcode
> > 	echo 0x64 > opcode
> > 	# Number of times to fault
> > 	echo 3 > times
> > 	# An optional mask allows you to fault
> > 	# a range of opcodes
> > 	echo 0xf0 > mask
> > =C2=A0=C2=A0=C2=A0=C2=A0/sys/kernel/debug/hfi1/hfi1_X/fault_stats
> > =C2=A0=C2=A0=C2=A0=C2=A0contains a value in parentheses to indicate
> > =C2=A0=C2=A0=C2=A0=C2=A0number of each opcode dropped.
> >=20
> > =C2=A0 - Dropping packets unconditionally
> > =C2=A0=C2=A0=C2=A0=C2=A0/sys/kernel/debug/hfi1/hfi1_X/fault_packet
> > 	# Enable fault
> > 	echo Y > fault_by_packet
> > =C2=A0=C2=A0=C2=A0=C2=A0/sys/kernel/debug/hfi1/hfi1_X/fault_packet/faul=
t_stats
> > =C2=A0=C2=A0=C2=A0=C2=A0contains the number of packets dropped.
> >=20
> > Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> > =C2=A0drivers/infiniband/hw/hfi1/Kconfig=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0|=C2=A0=C2=A0=C2=A0=C2=A06 +
> > =C2=A0drivers/infiniband/hw/hfi1/debugfs.c=C2=A0=C2=A0=C2=A0=C2=A0|=C2=
=A0=C2=A0222
> > +++++++++++++++++++++++++++++++
> > =C2=A0drivers/infiniband/hw/hfi1/debugfs.h=C2=A0=C2=A0=C2=A0=C2=A0|=C2=
=A0=C2=A0=C2=A035 +++++
> > =C2=A0drivers/infiniband/hw/hfi1/driver.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
|=C2=A0=C2=A0=C2=A0=C2=A08 +
> > =C2=A0drivers/infiniband/hw/hfi1/trace_misc.h |=C2=A0=C2=A0=C2=A048 +++=
++++
> > =C2=A0drivers/infiniband/hw/hfi1/verbs.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0|=C2=A0=C2=A0=C2=A0=C2=A06 +
> > =C2=A0drivers/infiniband/hw/hfi1/verbs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0|=C2=A0=C2=A0=C2=A0=C2=A04 +
> > =C2=A07 files changed, 329 insertions(+), 0 deletions(-)
> >=20
> > diff --git a/drivers/infiniband/hw/hfi1/Kconfig
> > b/drivers/infiniband/hw/hfi1/Kconfig
> > index f6ea088..7465595 100644
> > --- a/drivers/infiniband/hw/hfi1/Kconfig
> > +++ b/drivers/infiniband/hw/hfi1/Kconfig
> > @@ -27,3 +27,9 @@ config SDMA_VERBOSITY
> > =C2=A0	---help---
> > =C2=A0	This is a configuration flag to enable verbose
> > =C2=A0	SDMA debug
> > +config HFI1_FAULT_INJECTION
> > +	bool "Fault-injection capability"
> > +	depends on FAULT_INJECTION && FAULT_INJECTION_DEBUG_FS
> > +	default n
>=20
> First no need to set default to "n", it is already default.
> Second, we got NAK from Doug while we proposed to add new Kconfig to
> our
> driver (mlx5) to improve debug.
>=20
> Doug,
> I would like to know if your statement do not add new Kconfigs to IB
> is
> still relevant.

As much as is possible, yes. =C2=A0Kconfig bloat is something I very much
want to avoid. =C2=A0I would be more willing to have a single, global
CONFIG_INFINIBAND_DEBUG option that turned on debugging stack wide than
I would for individual drivers to each have their own debug configs.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-Eq0qJOf+eWSYWQKsvUZj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYo3vJAAoJELgmozMOVy/df7cQAIS8qFUGpr0ptdQXNvbZsr14
CWvEZNUn2iZ+WcZiT/o+Tau7mlchSQ+vBUDdux2yS1YylCj+zWyR5KzV1hDS+0/w
BineMmeICFbyWCj5ChiAXAG0ffYWZi45nvf186Es9mJMbp93YpND1GmtVJDnQu8v
+vc1ltNOn9sghhpV+3wdm/jGTJN69LdILwczAcdoSYkLsaJvCdsj0nFDKnHw1MPv
IR5OVF3tdleAKFItqtAWpsa1ohaxNeL0xfz7ZmivGtzHMoIWKz65S0caTyDp9Hdd
3sIPZUFW2dL9zvVzE1Nog547/Np62f5ClGhXgyj556KtnJ00tR93HlBrPnWXwSgB
5vkfjDIdeWGdHj4Z/0UO5Tg+XsqkVjKx1zkGm8K3XO0hv+hBP1BI4h5o2REyqUSJ
0CNqTdI8tqkSsDy0F5K6FSTAWioa1QV5XT76686aT9LqRNlJ7O6wQflqdQENXeDf
f0alV8WIoMcSbrZ6kmh2YJcFifn/kwA1rp84s9Z6BG27l3wNfiRNK8rlODyBBVTE
4kF8VFRhsihTv8yRWt3Z0pxjM8unyNiLyxMxWlRuDSvgOYLXH3+Tw+/FDSOKKAry
Ebqj6VaGFDWGW8LNo8HiykuiTLGMUoKhsua3lwwkQfSWxmui17Zkicj5nU7XzPml
+RmyCfmSmsxmoyj6M15u
=iQ92
-----END PGP SIGNATURE-----

--=-Eq0qJOf+eWSYWQKsvUZj--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
