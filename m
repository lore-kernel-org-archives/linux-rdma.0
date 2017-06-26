From: Dan Coombs <dcoombs-LmJBtNfl/RVO0n7uQEQMm4CZgX+1HZI1@public.gmane.org>
Subject: Re: IWARP Valgrind Issue
Date: Mon, 26 Jun 2017 23:08:11 +0000
Message-ID: <21c2d870fa494af1864ec1ae35b10a28CY4PR19MB1221A6E40939E2669E369D2D8BDF0@CY4PR19MB1221.namprd19.prod.outlook.com>
References: <CY4PR19MB12215AF6E7225113294CF8DB8BDF0@CY4PR19MB1221.namprd19.prod.outlook.com>,<006801d2eebd$2e54ba60$8afe2f20$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <006801d2eebd$2e54ba60$8afe2f20$@opengridcomputing.com>
Content-Language: en-US
Content-ID: <0160CE5153691D46AACA0FC3706F71C2-djBWYZLlpnKcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: 'Michael Chen' <mchen-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 Thanks Steve, this is Chelsio's Unified Wire package. That additional line=
 fixed the leak.

- Dan
 =20
From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sent: Monday, June 26, 2017 3:45:44 PM
To: Dan Coombs; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: 'Michael Chen'
Subject: RE: IWARP Valgrind Issue
=A0  =20
Hey Dan:

>=20
> Hello,
>=20
> I'm getting a valgrind error when using the cxgb4/iw_cxgb4 drivers for a
Chelsio
> IWARP card.
>=20
> System info:
> Distribution:=A0Ubuntu 16.04.2 LTS
> Kernel:=A04.4.0-79-generic
> Hardware: Chelsio T420-BT
> Drivers:
> Chelsio T4/T5/T6 Offload Network Driver - version 3.2.0.0
> Chelsio T420-BT rev 2
> iw_cxgb4:Chelsio T4/T5/T6 RDMA Driver - version 3.2.0.0
>=20

This is Chelsio's Unified Wire package, yes?

>=20
> Bug:
>=20
> Running with=A0sudo valgrind --leak-check=3Dfull --undef-value-errors=3Dn=
o
>=20
> 12,720 bytes in 1 blocks are definitely lost in loss record 146 of 150
>=20
>=20
> Call stack:
>=20
> ibv_create_cq (verbs.c:328)
> c4iw_create_cq (verbs.c:245)
> calloc (in /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
>=20
> Code simply opens the device, creates a completion channel and a completi=
on
> queue with ibv_create_*, then destroys the completion queue and completio=
n
> channel with ibv_destroy_*.
>=20

That looks like a bug in Chelsio's Unified Wire libcxgb4 core (ie not in th=
e
upstream rdma-core libcxgb4 code).=A0 I See the leak.=A0 Something like thi=
s should
probably fix it.

diff -r fbf715bf1eb7 linux_libs/libcxgb4/src/verbs.c
--- a/linux_libs/libcxgb4/src/verbs.c=A0=A0 Fri Jun 23 13:44:07 2017 -0700
+++ b/linux_libs/libcxgb4/src/verbs.c=A0=A0 Mon Jun 26 13:43:52 2017 -0700
@@ -304,6 +304,7 @@ int c4iw_destroy_cq(struct ibv_cq *ibcq)
=A0=A0=A0=A0=A0=A0=A0 dev->cqid2ptr[chp->cq.cqid] =3D NULL;
=A0=A0=A0=A0=A0=A0=A0 pthread_spin_unlock(&dev->lock);

+=A0=A0=A0=A0=A0=A0 free(chp->cq.swiq_queue);
=A0=A0=A0=A0=A0=A0=A0 free(chp->cq.sw_queue);
=A0=A0=A0=A0=A0=A0=A0 free(chp);
=A0=A0=A0=A0=A0=A0=A0 return 0;


Steve.


    =
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
