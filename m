From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 rdma-core 0/6] Common udev/systemd based module auto
 loading
Date: Wed, 9 Aug 2017 13:54:11 -0400
Message-ID: <aabb1543-57b3-b976-cbcc-8a13d080e10c@redhat.com>
References: <1501194685-9447-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1501256525.4572.44.camel@profitbricks.com>
 <20170728154749.GA9646@obsidianresearch.com>
 <1501260065.4572.47.camel@profitbricks.com>
 <20170728165614.GA14302@obsidianresearch.com>
 <1501761659.3581.2.camel@profitbricks.com>
 <20170803175242.GA31628@obsidianresearch.com>
 <1501863751.3581.19.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="OqwM9RS1NFQKB6ElUniHbihcti20o68U2"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501863751.3581.19.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OqwM9RS1NFQKB6ElUniHbihcti20o68U2
Content-Type: multipart/mixed; boundary="qACsB7pW0tT1Dt5npgxVQmVHUo49iDAsK";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>,
 Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
 Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Steve Wise
 <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Message-ID: <aabb1543-57b3-b976-cbcc-8a13d080e10c-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 rdma-core 0/6] Common udev/systemd based module auto
 loading
References: <1501194685-9447-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <1501256525.4572.44.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
 <20170728154749.GA9646-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <1501260065.4572.47.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
 <20170728165614.GA14302-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <1501761659.3581.2.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
 <20170803175242.GA31628-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <1501863751.3581.19.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
In-Reply-To: <1501863751.3581.19.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>

--qACsB7pW0tT1Dt5npgxVQmVHUo49iDAsK
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/4/2017 12:22 PM, Benjamin Drung wrote:
> Am Donnerstag, den 03.08.2017, 11:52 -0600 schrieb Jason Gunthorpe:
>> On Thu, Aug 03, 2017 at 02:00:59PM +0200, Benjamin Drung wrote:
>>
>>> Yes. That was the issue. I am using an initrd (from initramfs-
>>> tools).
>>> The mlx4_core module was included in the initrd, but mlx4_ib was
>>> missing. I tweaked initramfs-tools to include mlx4_ib and then it
>>> was
>>> autoloaded. Thanks.
>>
>> Do you know how to fix this generally for Debian? Is it possible?
>=20
> Analysis for Debian jessie/stretch:
>=20
> $ sudo update-initramfs -uv
> [...]
> Copying module directory kernel/drivers/net
> (excluding appletalk arcnet bonding can dummy.ko hamradio hippi ifb.ko
> irda macvlan.ko macvtap.ko pcmcia sb1000.ko team tokenring tun.ko usb
> veth.ko wan wimax wireless xen-netback.ko)
> [...]
> Adding module /lib/modules/$version/kernel/drivers/net/ethernet/mellano=
x/mlx5/core/mlx5_core.ko
> Adding module /lib/modules/$version/kernel/drivers/net/ethernet/mellano=
x/mlx4/mlx4_core.ko
>=20
> update-initramfs calls auto_add_modules() in
> /usr/share/initramfs-tools/hook-functions which includes 'net' as
> default. The 'net' option calls=20
> "copy_modules_dir kernel/drivers/net [...]" which copies the
> mlx5_core.ko and mlx4_core.ko modules.
>=20
> but the mlx4_ib.ko module is in the infiniband directory:
>=20
> $ find kernel/drivers/infiniband ! -type d
> kernel/drivers/infiniband/hw/mlx5/mlx5_ib.ko
> kernel/drivers/infiniband/hw/mthca/ib_mthca.ko
> kernel/drivers/infiniband/hw/mlx4/mlx4_ib.ko
> kernel/drivers/infiniband/core/ib_sa.ko
> kernel/drivers/infiniband/core/ib_umad.ko
> kernel/drivers/infiniband/core/ib_netlink.ko
> kernel/drivers/infiniband/core/ib_core.ko
> kernel/drivers/infiniband/core/rdma_cm.ko
> kernel/drivers/infiniband/core/ib_ucm.ko
> kernel/drivers/infiniband/core/ib_addr.ko
> kernel/drivers/infiniband/core/rdma_ucm.ko
> kernel/drivers/infiniband/core/ib_cm.ko
> kernel/drivers/infiniband/core/ib_uverbs.ko
> kernel/drivers/infiniband/core/iw_cm.ko
> kernel/drivers/infiniband/core/ib_mad.ko
> kernel/drivers/infiniband/ulp/ipoib/ib_ipoib.ko
> kernel/drivers/infiniband/ulp/srp/ib_srp.ko
>=20
> By default, nothing from the infiniband directory is included. The
> question is: What is the right thing to do? Should everything from
> kernel/drivers/infiniband/hw be included in the initrd by default?

That largely depends on what you want your initramfs to be capable of.
In dracut speak, an initramfs is either generic or host_only.  A generic
initramfs should be able to start any system and is suitable for things
like an installer image.  In that case, the answer is yes, you want
everything (you need the whole kit and caboodle to support root over
iSER, SRP, or NFSoRDMA, or to use an IPoIB interface as your install
source).  If you want a host_only initramfs, then you have to sort
through what's required to get to your rootfs.  If you have a network
rootfs, then the requirements jump up considerably.  If you don't, and
you can mount locally, then you only need network drivers if you want a
backup in case your rootfs craps out on you and you need to be able to
ssh in/out or perform other extraordinary recovery measures.  But if you
want to support those extraordinary recovery measures, then you are back
to a good portion of the stack because you might need IPoIB to get
anything done.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--qACsB7pW0tT1Dt5npgxVQmVHUo49iDAsK--

--OqwM9RS1NFQKB6ElUniHbihcti20o68U2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZi0xDAAoJELgmozMOVy/dc8gP/1wMU7a66AOtAcEpyJa9hyEc
ClDnVwmm5CsGf5KjLphS30Gi4ii6Jn8sdKqvdQdcwfRr2UvTf4kluNdyO3mxG4H1
Iy9FAC14awcuRmhPKTYUvP+Be2GkIioktOm5FLJPSW0AiOXyVAM1ZKuIqtQVJMX5
idLReYkVldkkM+Pkjx8YdxYMadnUsHu9NK85PAJogtzeDo+mfumiIP+Jq3Z32FD/
K7hO86EbzbjTVNQx619HfspMQ/85NYcOtDQx/A+znjGYWk3GYcIh34fmx0rXrXOt
JR+EzvfDcHnY85MVl2QKj+ep9UXxTIBRNI8t4EgH5xz51a44Ijk+IxnHgMQNnrA5
etGXTjpmiKz7CtTgkYUoW/+XebEWDuVGe3cum9KZ1e5uph3e9JXNrImAgDRb64pt
uk4cKO0q7htQygUXb/5vU2mfcEKnRFRwSGA+ZGy9lhDl6m5QkfuGK18IqRkSCdxL
31r+T+Pyuy7aVQTs19Pb8yNCxrQZQAK10hD5mQ0jH1il/imdf9RsCO36wbW6YoQJ
SWIws6b5l/5AWTSBjIve1w5fqu2B3Hc5/LX61WgNOfOMe1ehc/gVO8h3KYMyJPhB
6eVo9Y8PJtSJLkeVN54NfdWKjD856AOUhZX39DpKb3Yj4gXS5EWSGkCUvwGiqwhK
IRg8hkh0dsDPi9w44GUO
=NAen
-----END PGP SIGNATURE-----

--OqwM9RS1NFQKB6ElUniHbihcti20o68U2--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
