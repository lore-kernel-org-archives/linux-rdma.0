From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 00/11] IB/hfi1: Driver fixes for 11/6/2017
Date: Mon, 13 Nov 2017 15:55:19 -0500
Message-ID: <1510606519.3735.33.camel@redhat.com>
References: <20171106143510.27539.65950.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-ToPFqH1WmmHKiDdujRHR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171106143510.27539.65950.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Duane McCrory <duane.mccrory-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kamenee Arumugam <kamenee.arumugam-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Grzegorz Morys <grzegorz.morys-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-ToPFqH1WmmHKiDdujRHR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2017-11-06 at 06:38 -0800, Dennis Dalessandro wrote:
> Hi Doug,
>=20
> More fixes for our drivers. Nothing scary or out of the ordinary here. Th=
ere
> is a core change, but it is for extended lids. This does include a patch
> suggested by Dan and is based off of his patch and the ensuing discussion=
 on the
> list.
>=20
> As always patches available for browsing at:
> https://github.com/ddalessa/kernel/tree/for-4.15
>=20
> ---
>=20
> Dennis Dalessandro (1):
>       IB/hfi1: Handle initial value of 0 for CCTI setting
>=20
> Don Hiatt (2):
>       IB/core: Convert OPA AH to IB for Extended LIDs only
>       IB/hfi1: Mask upper 16Bits of Extended LID prior to rvt_cq_entry
>=20
> Grzegorz Morys (1):
>       IB/hfi1: Prohibit invalid Init to Armed state transition
>=20
> Jakub Byczkowski (1):
>       IB/hfi1: Reduce 8051 command timeout
>=20
> Jan Sokolowski (3):
>       IB/hfi1: Allow MgmtAllowed on B2B setups
>       IB/hfi1: Remove unnecessary if check
>       IB/hfi1: Send 'reboot' as planned down remote reason
>=20
> Kamenee Arumugam (1):
>       IB/hfi1: Remove wrapper function in mmu_rb
>=20
> Mike Marciniszyn (1):
>       IB/hfi1: Fix a wrapping test to insure the correct timeout
>=20
> Niranjana Vishwanathapura (1):
>       IB/hfi1: Do not allocate PIO send contexts for VNIC

Thanks Denny, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-ToPFqH1WmmHKiDdujRHR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloKBrcACgkQuCajMw5X
L919aw//RAJNuq8kKOup08n+18egymPo60uVFmeJnsVdnVXp0cq+q2v3Ce0AX+pv
MdCuzUP+ox23vk6IhoSWNCNU+IoT9AoESqz4jJEkrE0+2cprqF7sbLqfcPpaO8RW
/ZoqtiBxRmJ9dwy6XvS6zNIpbLN/dXH8zoGAf5KnNIqTUAv+FvJ8ZiN/Sxn5m5qq
D4NIQP5fG+1Vbu9IYn+zSe/5FHTj4rm0s5wKa3XnESlvjJiOaSwH/EbJ/4m+r6fx
rKxoNNaOC6EtrvsnoppytEOirz0bLkuXqdVzbM+sOWrqC7A4J1MzBNCyS2VVX1YG
CNd8vF5U/GLwwC/tpH6dklkShyA70QCL8BfUZ5Yu8q7XCKB8/djH+GzMlLZTgDBh
C3a7fFL7HTTt2cCgkpuUzYl28x69TAPw2DTp6ZSQ+FfTEyQQadboyqQ/MIgIX5fT
Z+PhxWJ6hwCxFj6NRw20ntS74GvkVUBAmmzVtKqqBYjI8lGlapMurLLtVAmPs3Bu
E861oK2yFiMXhTJ+Fx03AS9fh2be3PDB2m1O+hceduzRV6TIreY5BZHeJl+0NsFe
VG5jNk2z8mnJcT0oixZNfBL1yxMT9eIMV+gMwiht4nrmf/wIx0/2xNBG3Lv5AAnM
zXcwmas+Xv9vO1hABaB/IdZF2i9MFL9GLpyxwpu0C0/LbXWQw9c=
=FwoH
-----END PGP SIGNATURE-----

--=-ToPFqH1WmmHKiDdujRHR--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
