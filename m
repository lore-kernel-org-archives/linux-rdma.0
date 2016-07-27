From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/1] Drivers: infiniband: hw: vmbus-nd: NetworkDirect
 driver for Linux
Date: Wed, 27 Jul 2016 07:25:21 +0300
Message-ID: <20160727042521.GD4628@leon.nu>
References: <1469585137-31229-1-git-send-email-kys@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x4pBfXISqBoDm8sr"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1469585137-31229-1-git-send-email-kys-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, olaf-QOLJcTWqO2uzQB+pC5nmwQ@public.gmane.org, apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leann.ogasawara-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--x4pBfXISqBoDm8sr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 26, 2016 at 07:05:37PM -0700, kys-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org wrote:
> From: K. Y. Srinivasan <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
>=20
> This driver is a bridge driver that surfaces a Mellanox device in the Lin=
ux guest and plugs into
> the "NetworkDirect" RDMA infrastructure on the Windows host. Only a subse=
t of the ibverbs are
> implemented (this decision is based on the verbs supported by the Windows=
 host).
> The control path is implemented over the vmbus using the NetworkDirect pr=
otocol for
> virtualized environments. The data path bypasses the guest and host kerne=
l and the NIC is able to RDMA
> into guest addresses.
>=20
> Signed-off-by: K. Y. Srinivasan <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> ---
>  drivers/infiniband/Kconfig                  |    1 +
>  drivers/infiniband/hw/Makefile              |    1 +
>  drivers/infiniband/hw/vmbus-nd/Kconfig      |    5 +
>  drivers/infiniband/hw/vmbus-nd/Makefile     |    3 +
>  drivers/infiniband/hw/vmbus-nd/hvnd_addr.c  |  292 +++
>  drivers/infiniband/hw/vmbus-nd/mx_abi.h     |  232 ++
>  drivers/infiniband/hw/vmbus-nd/provider.c   | 2844 +++++++++++++++++++++=
+++
>  drivers/infiniband/hw/vmbus-nd/vmbus_rdma.c | 3086 +++++++++++++++++++++=
++++++
>  drivers/infiniband/hw/vmbus-nd/vmbus_rdma.h | 2205 +++++++++++++++++++
>  9 files changed, 8669 insertions(+), 0 deletions(-)

If your final goal is to merge this driver into Linux kernel, so I will
ask from you to do the following actions:

1. Split this patch to smaller patches to allow review.
You can see as an example - latest submission of "Add Paravirtual RDMA Driv=
er" [1].
2. Fix licenses, magic numbers, remove creepy comments and learn about
MAINTAINERS file.
3. Use preferred for this susbsystem title format.
4. Find the relevant mailing list and maintainer for this submission and
don't add unrelated people.

Thanks.

[1] http://marc.info/?l=3Dlinux-rdma&m=3D146835226218818&w=3D2

>  create mode 100644 drivers/infiniband/hw/vmbus-nd/Kconfig
>  create mode 100644 drivers/infiniband/hw/vmbus-nd/Makefile
>  create mode 100644 drivers/infiniband/hw/vmbus-nd/hvnd_addr.c
>  create mode 100644 drivers/infiniband/hw/vmbus-nd/mx_abi.h
>  create mode 100644 drivers/infiniband/hw/vmbus-nd/provider.c
>  create mode 100644 drivers/infiniband/hw/vmbus-nd/vmbus_rdma.c
>  create mode 100644 drivers/infiniband/hw/vmbus-nd/vmbus_rdma.h

--x4pBfXISqBoDm8sr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXmDexAAoJEORje4g2clinxwsP+QE46+tl3k7HVz9//05xAlQw
waU1Ly0TCgr/SzRiL/3q2feHfKFqeMMivNESnGW2TUA4tNf1YE5z4lvvWDOvdK0p
2EXJuQTGLFCPwb4sK0y+ct9za8TW7efUw+VZYhgjleuBEDnx/dNojJsmHll1CvSI
TrSBkMKoChZ1UbSC+mfPvzabejhVv0q03NOCm/EbjoEtYkH7w7Pf8ebJiUjGIm5R
exQ/6/xMzLgd5kobiVcasYVwCJ4tVIEyDhPIm3+khNxpjqLr0rSwmapSesaa0VEq
ZtaROmpTTRPSbShDxTtsNlAXdvpyYtxqwrY7hODfE2ZcNWSl/B1LWWx9VoY9s8pY
ECXmfFVo6LuP84LrZLd0ymuojsDd+J/Jxxtk1RJytmOrgFKLdwSENNte33ch1/dj
4QI5FSmFul9T0vKHW41WV5REM6dqLtDFf/zbtASy9j/iYpK7ZDXScOgVPpCMLhsO
16l6lrmHON/iipXE1lbzLWZl/zd3txNZVk1PPg+DcKYuUfkNzJMMpcNMKRWJfvrz
CeiDbgvqtmTip4iwHVzivNeM18aua1dcJSNHl+iL3tdpF24Vq2uqoPeWV49RUcGQ
2FIvBoC1VarRlna1BCpEoGxD6wQtx4KQQ4WgfPcL6LnatWfrm8FsU7Qv7ciAhesU
4vx28lHvEA56gSqfxsiU
=PLIv
-----END PGP SIGNATURE-----

--x4pBfXISqBoDm8sr--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
