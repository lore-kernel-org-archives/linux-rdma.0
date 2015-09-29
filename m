From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 for-next 0/7] Add support for multicast loopback
 prevention to mlx4
Date: Tue, 29 Sep 2015 14:24:26 -0400
Message-ID: <560AD75A.7080700@redhat.com>
References: <1440081275-15864-1-git-send-email-eranbe@mellanox.com>
 <CAKHjkjnQNqeLu+irEg97a1hcKp_ziXsDOFaTRwcaPpZAX_fMng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2BLd5t2M5sDkPl8DHgEbAmGUbaaMxFJRd"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKHjkjnQNqeLu+irEg97a1hcKp_ziXsDOFaTRwcaPpZAX_fMng-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: eran ben elisha <eranlinuxmellanox-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2BLd5t2M5sDkPl8DHgEbAmGUbaaMxFJRd
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 09/21/2015 10:24 AM, eran ben elisha wrote:
> On Thu, Aug 20, 2015 at 5:34 PM, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> =
wrote:
>> Hi Doug,
>>
>> This patch-set adds a new  implementation for multicast loopback preve=
ntion for
>> mlx4 driver.  The current implementation is very limited, especially i=
f link
>> layer is Ethernet. The new implementation is based on HW feature of dr=
opping
>> incoming multicast packets if the sender QP counter index is equal to =
the
>> receiver counter index.
>>
>> Patch 0001 extends ib_uverbs_create_qp in order to allow receiving the=

>> multicast loopback flag at create flags.
>> Patch 0002 adds an infrastructure for the counters' loopback preventio=
n in the
>> mlx4_core.
>> Patch 0003 modifies mlx4_en QPs to use the new loopback prevention mod=
e.
>> Patches 0004-0006 implements this feature for mlx4_ib driver.
>> Patch 0007 allows setting IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK in cre=
ate_flag
>> field both from uverbs and ib_create_qp.
>>
>> Changes from v0:
>>   Move loopback assignment outside the for loop according to Yuval's c=
omment
>>   rebase over to-be-rebased/for-4.3
>>
>>
>> Thanks,
>> Eran.
>>
>> Eran Ben Elisha (5):
>>   IB/core: Extend ib_uverbs_create_qp
>>   IB/core: Allow setting create flags in QP init attribute
>>   IB/mlx4: Add IB counters table
>>   IB/mlx4: Add counter based implementation for QP multicast loopback
>>     block
>>   IB/mlx4: Add support for blocking multicast loopback QP creation use=
r
>>     flag
>>
>> Maor Gottlieb (2):
>>   net/mlx4_core: Add support for filtering multicast loopback
>>   net/mlx4_en: Implement mcast loopback prevention for ETH qps
>=20
> Hi Doug,
> This version sits in the mailing list for a month with no comment.
> It has been tested by Christoph Lameter.
> When do you plan to take it into your tree?

I'm getting ready to tackle the for-next backlog.

> Eran.
>=20
>>
>>  drivers/infiniband/core/uverbs.h                   |   1 +
>>  drivers/infiniband/core/uverbs_cmd.c               | 259 ++++++++++++=
+++------
>>  drivers/infiniband/core/uverbs_main.c              |   1 +
>>  drivers/infiniband/hw/mlx4/mad.c                   |  25 +-
>>  drivers/infiniband/hw/mlx4/main.c                  |  66 ++++--
>>  drivers/infiniband/hw/mlx4/mlx4_ib.h               |  10 +-
>>  drivers/infiniband/hw/mlx4/qp.c                    |  88 ++++++-
>>  drivers/net/ethernet/mellanox/mlx4/en_main.c       |  22 ++
>>  drivers/net/ethernet/mellanox/mlx4/en_resources.c  |  25 ++
>>  drivers/net/ethernet/mellanox/mlx4/fw.c            |   6 +
>>  drivers/net/ethernet/mellanox/mlx4/mlx4_en.h       |   3 +-
>>  drivers/net/ethernet/mellanox/mlx4/qp.c            |  19 +-
>>  .../net/ethernet/mellanox/mlx4/resource_tracker.c  |  30 ++-
>>  include/linux/mlx4/device.h                        |   2 +
>>  include/linux/mlx4/qp.h                            |  24 +-
>>  include/uapi/rdma/ib_user_verbs.h                  |  26 +++
>>  16 files changed, 498 insertions(+), 109 deletions(-)
>>
>> --
>> 1.8.3.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" =
in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--2BLd5t2M5sDkPl8DHgEbAmGUbaaMxFJRd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWCtdaAAoJELgmozMOVy/d1oIP/RZqmeeLB6BR9OFD5pDe+/Yw
QPgcxcT86kbkwqmOfLVbOaa0HHPJGj7dJ0P2d7yNGhu4nklz0g0poc3//2DJaFRq
OquHZx6D8JaNLoI/6SxG28Q7azbWk3EZTfSVQQUrtAny9ci7IsWWyCbtSQ4pF+GB
Ez2/jhPdAfidMH8ThekS2e7JgrVnye/wAfdJJ827UNPlL43kw5Vf8vtR6rceMugZ
+Afgh6pQqHjkFwRonBUs/BrEfi/C7J15M7yIpkb3dwbL9831xkUVmNw9S1pDjX0f
kycQd6SyyVOFcKssf0H01+YruAzStpOXcOlvcSzU9DHAMYrMmoeM6rnUggzH16GD
YMbNJhGOGlhinK0GSNUHUR9v5b62qNLX4l/+0kbciP2rmVVgmS2qefdmPQWygg6T
KYuL40jELInv0DKm+lDY8xgeI1reR3oYCrEYkhoFkJTh0D7Iyf0f6ccMj5wz82aM
qhwds2NkQAVP7PpCVTDlda2nBRrFE5uLkM2TShLWN7itLyMsEr35XmAvNXVZUUk2
WqvG58dJ15551sRnAjuYg7JxpYx77XCYX2bVcMtYo62oT1l0agcZUr/IGuLkLvyV
yJOvyTGtUiHx8821FT+cTqHsk3Qdx9VC/Nnf87Qdf1yz8NRrd+quCYXmUCUOomdt
yGHwou57MCDlAjozDSlo
=e4aG
-----END PGP SIGNATURE-----

--2BLd5t2M5sDkPl8DHgEbAmGUbaaMxFJRd--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
