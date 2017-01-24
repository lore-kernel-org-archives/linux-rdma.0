From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 00/37] IB: Optimize DMA mapping
Date: Tue, 24 Jan 2017 12:38:07 -0500
Message-ID: <1485279487.43764.38.camel@redhat.com>
References: <20170120210437.26389-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-Gudzwk2QvIxeYGcHH1XU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170120210437.26389-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-Gudzwk2QvIxeYGcHH1XU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2017-01-20 at 13:04 -0800, Bart Van Assche wrote:
> Hello Doug,
>=20
> As you know there are two sets of DMA mapping operations in the Linux
> kernel:
> - One set of DMA mapping operations that is used by most drivers.
> - Another set of DMA mapping operations that is only used by the RDMA
> =C2=A0 drivers.
> Having two types of DMA mapping operations is not only a source of
> confusion but also a source of unnecessary overhead. The DMA mapping
> operations are in the hot path so it is important that the overhead
> of these operations is as low as possible. Hence this patch series
> that converts the RDMA code to the standard DMA mapping operations
> and thereby eliminates the if (dev->dma_ops) test from the hot path.
>=20
> The changes compared to version 2 of this patch series are:
> - Left out the inlining of the ib_dma_map_*() functions to keep the
> =C2=A0 number of patches in this patch series reasonable.
> - Reworked this patch series such that (hopefully) the hfi1 and qib
> =C2=A0 drivers keep working.
>=20
> The changes compared to version 1 of this patch series are:
> - Patch "Move dma_ops from archdata into struct device" has been
> =C2=A0 split into three patches.
> - Patch "treewide: Inline ib_dma_map_*() functions" has been split
> =C2=A0 into 15 patches (one per driver).
> - A patch has been added that builds dma_noop_ops only for the
> =C2=A0 architectures that need it.
> - The new dma_virt_ops is only built if it is used by a driver.
> - In these last 15 patches indentation has been adjusted to keep
> =C2=A0 the arguments aligned with the opening parenthesis.

Hi Bart,

I think this has enough Acks to move foward (especially from the larger
kernel community on the core kernel bits, such as GKH's ack on the core
bits). =C2=A0I've pulled it into a branch (there were a few fixups I had to
do, compile testing that now). =C2=A0However, I'm going to wait until the
very end to merge this branch right before my pull request. =C2=A0That way
if Linus has any objections, he can just pop the top 37 patches off of
my pull request and effectively remove this patchset, at which point we
can fix up whatever he objected to and resubmit. =C2=A0And I'm only doing
that because of the number of patches that are either outside of
drivers/infiniband or treewide in this series.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-Gudzwk2QvIxeYGcHH1XU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYh5D/AAoJELgmozMOVy/dQZQQAKXsdI5N4TgRuQHquxyJHoIm
y9QdikZ91bjFM86rd+hnxwwaEY4rP51v9WMYVVsNld7ceP/sXPBwi8dkYTbjm9dc
8h35o1vksVikAnpb/+k9xE3bevAHvYbVO/wYad+rpyGcTvmMSB3nsPbQtYogur59
s9dlWAFTObOaQXd8BN2R1TNC/14Iod+0n8Zp/yp3Jha25WWDYhsg+rwt6euSqP2s
ZZPvsYpLrnGwjdIUXBMRYAkk0P5YYGB6i6DxK/llfkiY0ucynbOmWXsiT3ER6I/b
p+lXvjxesymANQCmQZDkFCby7LHNghMyoJ1F95Z+Le566a2TTrFhjsp/0EEfAEyb
JhhvyvmREkcUxUR5q9iESP757gxOtWa0h6KkTOUmun7XNLFulcVBW7N+UnU1Zwly
JV7aBN1gOSF64VPK/4ZK0M1sLarkBE9kWDmpXSnes/ZwRtjVuezzni81G9nykvm6
riaGcZNn5+q19z15X78PSUeVWdEYgvNMc6GhXqaU8w93K1DYDLTBr3Qe5X/wmP0F
HvPBqRovUgonuPUKnLt7kz25pHeK2pCZp+YhNi/PO9eH7hOutn5jfAXqNjgANem3
4by7eoYinacCpj5lQB+tRoZmOW3h9KgYRERInNou1WegZ+NPVUqMUWrdtQ5WWR0o
dMB1WRbl8SHZwIRuwTQ9
=gweM
-----END PGP SIGNATURE-----

--=-Gudzwk2QvIxeYGcHH1XU--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
