From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 0/3] Support standard SRIOV configuration for IB VFs
Date: Thu, 21 May 2015 12:40:06 -0400
Message-ID: <1432226406.28905.22.camel@redhat.com>
References: <1432225447-6536-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-1T7+mli9nZnUprkn30Q7"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432225447-6536-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-1T7+mli9nZnUprkn30Q7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-05-21 at 19:24 +0300, Or Gerlitz wrote:
> Standard configuration of SRIOV VFs through the host is done over the
> following chain of calls: libvirt --> netlink --> PF netdevice -- where
> the PF netdevice exports the ndo_set_vf_ calls.
>=20
> When this comes to IB/IPoIB we should normalize this into the verbs
> framework so we further go: PF IPoIB --> verbs API --> PF HW driver
>=20
> Virtualization systems assign VMs with 48 bits mac, to allow working=20
> with non-modified SW layers

Why are we suggesting to make this work with unmodified software?  Why
aren't we doing this right and adding a new ndo entry point for the
GUID?  The MAC/GUID mapping isn't the only thing that has to be faked
here, you would also have to fake the vlan/pkey mapping.  This just
seems the wrong thing to do.

>  (open-stack, libvirt, etc), we can safely
> extend this mac to unique 64 bits GUID. Hence the IPoIB ndo_set_vf_mac
> entry calls the set_vf_guid verb.
>=20
> One thing to clean for being beyond RFC is to make the get_vf_config=20
> verb return guid and have IPoIB to make it back a mac.
>=20
> Here's how it looks when using the ip tool (libvirt runs the same
> netlink to set it out) and later reflected when the VF read their port.
>=20
> # ip link set dev ib0 vf 1 mac aa:bb:cc:dd:ee:ff
>=20
> # ibstat -d mlx4_2
> CA 'mlx4_2'
>         CA type: MT4100
>         Number of ports: 1
>         Firmware version: 2.34.1260
>         Hardware version: 0
>         Node GUID: 0x00140500f30e84c4
>         System image GUID: 0xf452140300117423
>         Port 1:
>                 State: Active
>                 Physical state: LinkUp
>                 Rate: 56
>                 Base lid: 7
>                 LMC: 0
>                 SM lid: 1
>                 Capability mask: 0x02514868
>                 Port GUID: 0xffeeddfeffccbbaa
>                 Link layer: InfiniBand
>=20
> Or Gerlitz (3):
>   IB/IPoIB: Support SRIOV standard configuration
>   IB/mlx4: Refactor Alias GUID storing
>   IB/mlx4: Add support for SRIOV VF management
>=20
>  drivers/infiniband/hw/mlx4/main.c         |   26 ++++++++++++++
>  drivers/infiniband/hw/mlx4/mlx4_ib.h      |    4 ++
>  drivers/infiniband/hw/mlx4/sysfs.c        |   54 ++++++++++++++++++-----=
-----
>  drivers/infiniband/ulp/ipoib/ipoib_main.c |   39 +++++++++++++++++++++
>  drivers/net/ethernet/mellanox/mlx4/cmd.c  |   26 +++++++++----
>  include/linux/mlx4/device.h               |    2 +
>  include/rdma/ib_verbs.h                   |    4 ++
>  7 files changed, 128 insertions(+), 27 deletions(-)
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-1T7+mli9nZnUprkn30Q7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVXgpmAAoJELgmozMOVy/ddikP/2N5gkv8vJ4PvENJODiCU1q5
M33nm1ZA2dezYv8+VF/NT5ifDZd0exgKXPJkVJAhKFyuyB9SNRhJKBNe+ieJoLAx
iCJJ3uvORnl/BJj7ig51E8Jz3jAstxaxO23dp462u1daqLscTirVvjrhkKuiSVXu
3KDYBn7cqWpHgZlX6swnmJupj9pYA87z03RNM0B3E/aFj/nF/6rHm8eAvitbVyJN
kjuTMYIM44GQUSWjQndxR0C77cBbkPIIERjeiDcRPwn+dYEQdYn7jbPfrKcado/s
a8xzmElIaORgyJnp5gN1HLoJNv5pOBJiuHaPKQdtq7NSey0jLBA1yWnILxhEBxai
fPUtJQQ/u1rp5SP5kyQkQHRwSd/jMVcgqBDk89yTp1axvHsIHNG5SKokn+XSgHWx
Z4iCNDE/DiTL6TCaqbJzEvwDzGni9R1HAVKMg+n93eKIiQ0wcSoe+t3TXmAgQgMT
RpFiZF5NyxGYqQT8SWK2PtHBKP91kOZSgHYbOHccc4QqtfczWnz27yUCo0cjhAKJ
K6gbkadtvvuzwrvsRxJhnzGj5TKazy/SEaN+MvnaWvvti3iCipW3pYY60owZnMd8
32UbYcPqAKZSmn0vqTsPW44GaDSMQa1mKXksZbS6c39QGezmNr+xrEwfeCHbeFTv
HwPQgZExBj4MQlYu1aB2
=M0UW
-----END PGP SIGNATURE-----

--=-1T7+mli9nZnUprkn30Q7--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
