From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/hns: Move HNS RoCE user vendor structures
Date: Sat, 03 Dec 2016 14:24:35 -0500
Message-ID: <1480793075.15032.68.camel@redhat.com>
References: <1476897187-15991-1-git-send-email-leon@kernel.org>
         <58097F0D.2040001@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-C3zePri4qL2YsXcpKsgT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <58097F0D.2040001-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-C3zePri4qL2YsXcpKsgT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2016-10-21 at 10:35 +0800, oulijun wrote:
> =E5=9C=A8 2016/10/20 1:13, Leon Romanovsky =E5=86=99=E9=81=93:
> >=20
> > This patch moves HNS vendor's specific structures to
> > common UAPI folder which will be visible to all consumers.
> >=20
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> > =C2=A0drivers/infiniband/hw/hns/hns_roce_cq.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|
> > 2 +-
> > =C2=A0drivers/infiniband/hw/hns/hns_roce_main.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|
> > 2 +-
> > =C2=A0drivers/infiniband/hw/hns/hns_roce_qp.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|
> > 2 +-
> > =C2=A0include/uapi/rdma/Kbuild=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|
> > 1 +
> > =C2=A0.../hw/hns/hns_roce_user.h =3D> include/uapi/rdma/hns-abi.h=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=20
> > 9 +++++----
> > =C2=A05 files changed, 9 insertions(+), 7 deletions(-)
> > =C2=A0rename drivers/infiniband/hw/hns/hns_roce_user.h =3D>
> > include/uapi/rdma/hns-abi.h (94%)
> >=20
> > diff --git a/drivers/infiniband/hw/hns/hns_roce_cq.c
> > b/drivers/infiniband/hw/hns/hns_roce_cq.c
> > index 0973659..d8a1764 100644
> > --- a/drivers/infiniband/hw/hns/hns_roce_cq.c
> > +++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
> > @@ -35,7 +35,7 @@
> > =C2=A0#include "hns_roce_device.h"
> > =C2=A0#include "hns_roce_cmd.h"
> > =C2=A0#include "hns_roce_hem.h"
> > -#include "hns_roce_user.h"
> > +#include <rdma/hns-abi.h>
> > =C2=A0#include "hns_roce_common.h"
> > =C2=A0
> > =C2=A0static void hns_roce_ib_cq_comp(struct hns_roce_cq *hr_cq)
> > diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c
> > b/drivers/infiniband/hw/hns/hns_roce_main.c
> > index 764e35a..354f100 100644
> > --- a/drivers/infiniband/hw/hns/hns_roce_main.c
> > +++ b/drivers/infiniband/hw/hns/hns_roce_main.c
> > @@ -37,7 +37,7 @@
> > =C2=A0#include <rdma/ib_user_verbs.h>
> > =C2=A0#include "hns_roce_common.h"
> > =C2=A0#include "hns_roce_device.h"
> > -#include "hns_roce_user.h"
> > +#include <rdma/hns-abi.h>
> > =C2=A0#include "hns_roce_hem.h"
> > =C2=A0
> > =C2=A0/**
> > diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c
> > b/drivers/infiniband/hw/hns/hns_roce_qp.c
> > index e86dd8d..5d13b6b 100644
> > --- a/drivers/infiniband/hw/hns/hns_roce_qp.c
> > +++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
> > @@ -37,7 +37,7 @@
> > =C2=A0#include "hns_roce_common.h"
> > =C2=A0#include "hns_roce_device.h"
> > =C2=A0#include "hns_roce_hem.h"
> > -#include "hns_roce_user.h"
> > +#include <rdma/hns-abi.h>
> > =C2=A0
> > =C2=A0#define SQP_NUM				(2 *
> > HNS_ROCE_MAX_PORTS)
> > =C2=A0
> > diff --git a/include/uapi/rdma/Kbuild b/include/uapi/rdma/Kbuild
> > index f14ab7f..b54f10d 100644
> > --- a/include/uapi/rdma/Kbuild
> > +++ b/include/uapi/rdma/Kbuild
> > @@ -14,3 +14,4 @@ header-y +=3D mlx5-abi.h
> > =C2=A0header-y +=3D mthca-abi.h
> > =C2=A0header-y +=3D nes-abi.h
> > =C2=A0header-y +=3D ocrdma-abi.h
> > +header-y +=3D hns-abi.h
> > diff --git a/drivers/infiniband/hw/hns/hns_roce_user.h
> > b/include/uapi/rdma/hns-abi.h
> > similarity index 94%
> > rename from drivers/infiniband/hw/hns/hns_roce_user.h
> > rename to include/uapi/rdma/hns-abi.h
> > index a28f761..5d74019 100644
> > --- a/drivers/infiniband/hw/hns/hns_roce_user.h
> > +++ b/include/uapi/rdma/hns-abi.h
> > @@ -30,8 +30,10 @@
> > =C2=A0 * SOFTWARE.
> > =C2=A0 */
> > =C2=A0
> > -#ifndef _HNS_ROCE_USER_H
> > -#define _HNS_ROCE_USER_H
> > +#ifndef HNS_ABI_USER_H
> > +#define HNS_ABI_USER_H
> > +
> > +#include <linux/types.h>
> > =C2=A0
> > =C2=A0struct hns_roce_ib_create_cq {
> > =C2=A0	__u64=C2=A0=C2=A0=C2=A0buf_addr;
> > @@ -49,5 +51,4 @@ struct hns_roce_ib_create_qp {
> > =C2=A0struct hns_roce_ib_alloc_ucontext_resp {
> > =C2=A0	__u32	qp_tab_size;
> > =C2=A0};
> > -
> > -#endif /*_HNS_ROCE_USER_H */
> > +#endif /* HNS_ABI_USER_H */
> >=20
> ok, thanks!
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-C3zePri4qL2YsXcpKsgT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYQxvzAAoJELgmozMOVy/dHsMQALAVVeua3E5Vnl/3Ay92sIQ0
wFKih83DG+edYXII87T86OxxpAnNwk3Gza7ErjScdT4oo42W7rucv52Moo+1ES9E
iu0lyYSAyFL8QDphHdoE1V/CYrDPB360r/p+7k2l+ZX2Ovnt0QZ9tJ3GjHooe9sn
P2bs8v7H/HOKwNevS3ifVW8erfux7Y8VHozwq6r0cwYXAZWcL/XjOAVgOu113kKG
buH+5TRPs+HXXoqWNrW1DVmSsiIQN3amW8HrkPOXaxn9AreM1huNNvLiSB9Oo5nC
hk1an9uwpo59CeJgM7H9pJolHOrDFYWln/asE9ZBQf43DHGCsUGr6hBeiLx0IOQP
XuTLL9Kz1lgRy8wHugfJTotDogk845nDblWvGX9k66ZrPQhQDBfW04249axQrnxW
VgO+5kcwtd+2R7IYzhg30T8QjE2SypZJbV+0k5Yn8l7qWikm9ViQ7Lhp8/gT54jW
AB+noZUSctMkAY+ROcrrqbcElvYzRwCS8Tp6bjBF60zM4uJUyQH6JtmG10eAdZh+
hKZSyiY5krTXWdHYY886jDUXRGoFwW3gJwFaKGv5S2byNXgX2AFesNnPJYlXZ9/d
5uoxdKGuqd5lW/PDheJN65DyA9qicQ1lyFq9uSOJSN99Vjk5kHcRMeMZEfhwr65P
R3+haQHS6Lge47r+PNvY
=I45J
-----END PGP SIGNATURE-----

--=-C3zePri4qL2YsXcpKsgT--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
