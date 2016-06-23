From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma 00/11] IB core,mlx5,mlx4 fixes for 4.7-rc4
Date: Thu, 23 Jun 2016 10:11:40 -0400
Message-ID: <93888d35-3b0b-0911-c1da-8f47f79f88c7@redhat.com>
References: <1466605652-24798-1-git-send-email-leonro@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Us2mvTUSfXxrAImglohmIoARCwN73w1qS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1466605652-24798-1-git-send-email-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Us2mvTUSfXxrAImglohmIoARCwN73w1qS
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 06/22/2016 10:27 AM, Leon Romanovsky wrote:
> Hi Doug,
>=20
> We are sending 11 patches with fixes for 4.7-rc4.
>=20
> Since most of the patches are one liners which will apply
> cleanly on current rc4 and no merge conflicts is expected for
> future ->next branches, we decided to send them as one patch series.
>=20
> These patches are available in the "topic/fixes-ib" branch of this git =
repo:
> git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
>=20
> Or for browsing:
> https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=
=3Dtopic/fixes-ib
>=20
> Thanks
>=20
> Alex Vesker (1):
>   IB/core: Fix RoCE v1 multicast join logic issue
>=20
> Chuck Lever (1):
>   IB/mlx4: Prevent cross page boundary allocation
>=20
> Dotan Barak (1):
>   IB/mlx4: Fix memory leak if QP creation failed
>=20
> Eli Cohen (2):
>   IB/core: Fix false search of the IB_SA_WELL_KNOWN_GUID
>   IB/mlx5: Fix post send fence logic
>=20
> Maor Gottlieb (1):
>   IB/uverbs: Initialize ib_qp_init_attr with zeros
>=20
> Talat Batheesh (2):
>   IB/core: Fix no default GIDs when netdevice reregisters
>   IB/mlx5: Fix wrong naming of port_rcv_data counter
>=20
> Yishai Hadas (3):
>   IB/mlx4: Fix the SQ size of an RC QP
>   IB/mlx4: Fix error flow when sending mads under SRIOV
>   IB/mlx4: Check that port number is valid in flow steering create flow=

>=20
>  drivers/infiniband/core/cache.c      |  4 +++-
>  drivers/infiniband/core/cma.c        |  8 ++++----
>  drivers/infiniband/core/uverbs_cmd.c |  2 +-
>  drivers/infiniband/core/verbs.c      | 16 ++++++++++------
>  drivers/infiniband/hw/mlx4/mad.c     | 24 ++++++++++++++++++------
>  drivers/infiniband/hw/mlx4/main.c    |  3 +++
>  drivers/infiniband/hw/mlx4/mlx4_ib.h |  2 +-
>  drivers/infiniband/hw/mlx4/mr.c      | 34 +++++++++++++++++-----------=
------
>  drivers/infiniband/hw/mlx4/qp.c      |  6 ++++--
>  drivers/infiniband/hw/mlx5/mad.c     |  2 +-
>  drivers/infiniband/hw/mlx5/qp.c      |  7 ++++---
>  include/linux/mlx5/qp.h              |  1 +
>  12 files changed, 67 insertions(+), 42 deletions(-)
>=20

Thanks, series applied (with one minor nit fixed in patch 7/11, just a
whitespace issue the patch introduced).

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--Us2mvTUSfXxrAImglohmIoARCwN73w1qS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXa+4cAAoJELgmozMOVy/d4EYP/0+1VnTknTb3MqClHvNG0Tai
1+2oMza09hFg+iIpfURA8N/Bg4nALn8Ek+oTZxHEx0T7klbCVDJpAUVStkvQ8+HM
KcVUerhKPNIEwGwHOkWqs3/pdo74wNngDOeVzpdVInLwAfn3FBUeYkjDqTqqvC2z
nWIwThr9RoXAUnS6epL75C7UwoFwyFTCRwE+5W3TFrW8QnA7mzwpxPMRkrCnTa/J
DzYgJB57gijgWLFc/v3wLmNc/rcZkJepVu7StKRzJucXynnZdSssh1J2i2nZJPXE
eqpluLQkF6u1k4wK3iNMefpNFhP/PMKqtBZLT7ZttJHGBCXlNe6Yv7Nlt/HiBciA
CR/JhwcwYDdPXVWSLMm6t0QHonD7FLMxUiy7nHktheUE4O4yLubXpKWA41nYcN2O
/sRlRDk2mTb+bdQdDe5XvErXdF5YO19fGfXduGC77Y5G5MWTKklRS8hFQ7rfbCFb
2NbkAkZfsX2AEwpG2fIkEp4mAhD7AH8n7vzEBxpES9Y6eBmQumuWkNoBghyaDCFS
aygzNKUYTgGY11hq4O5c3cpQVcAE9JeE8Hlh1XKQLWyUB5cevczExG0PGAiqNHCs
uJ7ugTIUxIRgNdB6LIe1Meom3E4DgExt42gdg8jlPmlwlGdXtgBYC916MR2Eaker
3xWvISfcE62IY/XtPh1Z
=jbvx
-----END PGP SIGNATURE-----

--Us2mvTUSfXxrAImglohmIoARCwN73w1qS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
